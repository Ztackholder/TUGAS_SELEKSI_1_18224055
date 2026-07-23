"""Logika ETL dari JSON Coffee Review menuju star schema PostgreSQL."""

import json
import logging
from dataclasses import dataclass
from datetime import date
from pathlib import Path
from typing import Any, Mapping, Sequence

from psycopg2.extensions import connection as Connection
from psycopg2.extensions import cursor as Cursor

from config import INPUT_JSON_PATH
from database import cursor
from utils import (
    clean_text,
    make_date_id,
    parse_integer,
    parse_review_date,
    require_mapping,
    require_text,
)


LOGGER = logging.getLogger(__name__)


@dataclass(frozen=True)
class EtlStatistics:
    """Jumlah baris yang tersimpan pada setiap tabel setelah ETL."""

    roaster_count: int
    origin_count: int
    coffee_count: int
    date_count: int
    review_count: int


def load_json(json_path: Path = INPUT_JSON_PATH) -> list[dict[str, Any]]:
    """Membaca dan memvalidasi root array dari berkas JSON hasil scraping."""
    with json_path.open("r", encoding="utf-8") as json_file:
        records = json.load(json_file)

    if not isinstance(records, list) or not all(
        isinstance(record, dict) for record in records
    ):
        raise ValueError("Root JSON harus berupa array yang berisi object coffee.")
    return records


def insert_roaster(db_cursor: Cursor, name: str, location: str) -> int:
    """Mengambil atau memasukkan dimensi roaster dan mengembalikan surrogate key."""
    db_cursor.execute(
        """
        INSERT INTO dim_roaster (roaster_name, location)
        VALUES (%s, %s)
        ON CONFLICT (roaster_name, location)
        DO UPDATE SET roaster_name = EXCLUDED.roaster_name
        RETURNING roaster_id;
        """,
        (name, location),
    )
    return int(db_cursor.fetchone()[0])


def insert_origin(
    db_cursor: Cursor,
    locality: str | None,
    region: str | None,
    country: str,
) -> int:
    """Mengambil atau memasukkan dimensi origin dan mengembalikan surrogate key."""
    db_cursor.execute(
        """
        INSERT INTO dim_origin (locality, region, country)
        VALUES (%s, %s, %s)
        ON CONFLICT (locality, region, country)
        DO UPDATE SET country = EXCLUDED.country
        RETURNING origin_id;
        """,
        (locality, region, country),
    )
    return int(db_cursor.fetchone()[0])


def insert_coffee(
    db_cursor: Cursor,
    coffee_name: str,
    roast_level: str | None,
    agtron: str | None,
    estimated_price: str | None,
) -> int:
    """Mengambil atau memasukkan dimensi coffee dan mengembalikan surrogate key."""
    db_cursor.execute(
        """
        INSERT INTO dim_coffee (coffee_name, roast_level, agtron, estimated_price)
        VALUES (%s, %s, %s, %s)
        ON CONFLICT (coffee_name, roast_level, agtron, estimated_price)
        DO UPDATE SET coffee_name = EXCLUDED.coffee_name
        RETURNING coffee_id;
        """,
        (coffee_name, roast_level, agtron, estimated_price),
    )
    return int(db_cursor.fetchone()[0])


def insert_date(db_cursor: Cursor, full_date: date) -> int:
    """Mengambil atau memasukkan dimensi tanggal dengan key YYYYMMDD."""
    date_id = make_date_id(full_date)
    db_cursor.execute(
        """
        INSERT INTO dim_date (date_id, full_date, day, month, year)
        VALUES (%s, %s, %s, %s, %s)
        ON CONFLICT (date_id)
        DO UPDATE SET full_date = EXCLUDED.full_date
        RETURNING date_id;
        """,
        (date_id, full_date, full_date.day, full_date.month, full_date.year),
    )
    return int(db_cursor.fetchone()[0])


def insert_fact_review(
    db_cursor: Cursor,
    coffee_id: int,
    origin_id: int,
    roaster_id: int,
    date_id: int,
    score: int,
    aroma_score: int | None,
    acidity_score: int | None,
    body_score: int | None,
    flavor_score: int | None,
    aftertaste_score: int | None,
) -> int:
    """Memasukkan satu fact atau memperbarui measure pada grain yang sama."""
    db_cursor.execute(
        """
        INSERT INTO fact_review (
            coffee_id, origin_id, roaster_id, date_id, score, aroma_score,
            acidity_score, body_score, flavor_score, aftertaste_score
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        ON CONFLICT (coffee_id, origin_id, roaster_id, date_id)
        DO UPDATE SET
            score = EXCLUDED.score,
            aroma_score = EXCLUDED.aroma_score,
            acidity_score = EXCLUDED.acidity_score,
            body_score = EXCLUDED.body_score,
            flavor_score = EXCLUDED.flavor_score,
            aftertaste_score = EXCLUDED.aftertaste_score
        RETURNING review_id;
        """,
        (
            coffee_id,
            origin_id,
            roaster_id,
            date_id,
            score,
            aroma_score,
            acidity_score,
            body_score,
            flavor_score,
            aftertaste_score,
        ),
    )
    return int(db_cursor.fetchone()[0])


def insert_data(
    connection: Connection,
    records: Sequence[Mapping[str, Any]],
) -> EtlStatistics:
    """Memproses seluruh record JSON dalam transaksi aktif tanpa commit."""
    db_cursor = cursor(connection)
    try:
        for index, record in enumerate(records, start=1):
            _insert_record(db_cursor, record)
            LOGGER.info("ETL record %s/%s selesai.", index, len(records))
        return _get_statistics(db_cursor)
    finally:
        db_cursor.close()


def _insert_record(db_cursor: Cursor, record: Mapping[str, Any]) -> None:
    """Mentransformasikan dan memuat satu record ke seluruh tabel star schema."""
    roaster = require_mapping(record.get("roaster"), "roaster")
    origin = require_mapping(record.get("origin"), "origin")
    review = require_mapping(record.get("review"), "review")

    roaster_id = insert_roaster(
        db_cursor,
        require_text(roaster.get("name"), "roaster.name"),
        require_text(roaster.get("location"), "roaster.location"),
    )
    origin_id = insert_origin(
        db_cursor,
        clean_text(origin.get("locality")),
        clean_text(origin.get("region")),
        require_text(origin.get("country"), "origin.country"),
    )
    coffee_id = insert_coffee(
        db_cursor,
        require_text(record.get("coffee_name"), "coffee_name"),
        clean_text(record.get("roast_level")),
        clean_text(record.get("agtron")),
        clean_text(record.get("estimated_price")),
    )
    date_id = insert_date(db_cursor, parse_review_date(review.get("review_date")))
    insert_fact_review(
        db_cursor,
        coffee_id,
        origin_id,
        roaster_id,
        date_id,
        _validate_measure(
            parse_integer(review.get("score"), "review.score", True),
            100,
        ),
        _optional_measure(review.get("aroma"), "review.aroma"),
        _optional_measure(review.get("acidity"), "review.acidity"),
        _optional_measure(review.get("body"), "review.body"),
        _optional_measure(review.get("flavor"), "review.flavor"),
        _optional_measure(review.get("aftertaste"), "review.aftertaste"),
    )


def _optional_measure(value: Any, field_name: str) -> int | None:
    """Memvalidasi subscore opsional pada rentang 0 sampai 10."""
    parsed_value = parse_integer(value, field_name)
    return None if parsed_value is None else _validate_measure(parsed_value, 10)


def _validate_measure(value: int | None, maximum: int) -> int:
    """Memastikan measure wajib berada pada rentang yang ditetapkan schema."""
    if value is None or not 0 <= value <= maximum:
        raise ValueError(f"Measure wajib bernilai antara 0 dan {maximum}.")
    return value


def _get_statistics(db_cursor: Cursor) -> EtlStatistics:
    """Menghitung jumlah baris aktual pada setiap tabel warehouse."""
    table_names = ("dim_roaster", "dim_origin", "dim_coffee", "dim_date", "fact_review")
    counts: list[int] = []
    for table_name in table_names:
        db_cursor.execute(f"SELECT COUNT(*) FROM {table_name};")
        counts.append(int(db_cursor.fetchone()[0]))
    return EtlStatistics(*counts)
