"""ETL JSON ke PostgreSQL dengan urutan Roaster, Origin, Coffee, lalu Review."""

import json
import logging
from datetime import date
from pathlib import Path
from typing import Any

from psycopg2.extensions import cursor as Cursor

from config import INPUT_JSON_PATH
from database import close_connection, get_connection, transaction
from utils import (
    get_or_create_origin,
    get_or_create_roaster,
    parse_nullable_integer,
    parse_nullable_value,
    parse_review_date,
)


LOGGER = logging.getLogger(__name__)


def insert_data(json_path: Path = INPUT_JSON_PATH) -> int:
    """Membaca JSON dan memasukkan seluruh record dalam satu transaction."""
    records = _load_records(json_path)
    connection = get_connection()
    try:
        with transaction(connection) as cursor:
            for index, record in enumerate(records, start=1):
                _insert_record(cursor, record)
                LOGGER.info("Memasukkan record %s/%s.", index, len(records))
    finally:
        close_connection(connection)

    LOGGER.info("ETL berhasil menyimpan %s record dari %s.", len(records), json_path)
    return len(records)


def _load_records(json_path: Path) -> list[dict[str, Any]]:
    """Memuat dataset JSON dan memastikan struktur root berupa list."""
    with json_path.open("r", encoding="utf-8") as json_file:
        records = json.load(json_file)

    if not isinstance(records, list):
        raise ValueError("Root file JSON harus berupa list record coffee.")
    if not all(isinstance(record, dict) for record in records):
        raise ValueError("Setiap item JSON harus berupa object record coffee.")
    return records


def _insert_record(cursor: Cursor, record: dict[str, Any]) -> None:
    """Memasukkan satu record sesuai urutan dependensi foreign key."""
    roaster = _require_mapping(record.get("roaster"), "roaster")
    origin = _require_mapping(record.get("origin"), "origin")
    review = _require_mapping(record.get("review"), "review")

    roaster_name = _require_text(roaster.get("name"), "roaster.name")
    roaster_location = _require_text(roaster.get("location"), "roaster.location")
    country = _require_text(origin.get("country"), "origin.country")
    coffee_name = _require_text(record.get("coffee_name"), "coffee_name")
    score = _require_integer(review.get("score"), "review.score")
    blind_assessment = _require_text(
        review.get("blind_assessment"), "review.blind_assessment"
    )

    roaster_id = get_or_create_roaster(cursor, roaster_name, roaster_location)
    origin_id = get_or_create_origin(
        cursor,
        parse_nullable_value(origin.get("locality")),
        parse_nullable_value(origin.get("region")),
        country,
    )
    coffee_id = _get_or_create_coffee(
        cursor,
        coffee_name,
        parse_nullable_value(record.get("roast_level")),
        parse_nullable_value(record.get("agtron")),
        parse_nullable_value(record.get("estimated_price")),
        roaster_id,
        origin_id,
    )
    _upsert_review(
        cursor,
        coffee_id,
        score,
        parse_review_date(review.get("review_date")),
        parse_nullable_integer(review.get("aroma")),
        parse_nullable_integer(review.get("acidity")),
        parse_nullable_integer(review.get("body")),
        parse_nullable_integer(review.get("flavor")),
        parse_nullable_integer(review.get("aftertaste")),
        blind_assessment,
    )


def _get_or_create_coffee(
    cursor: Cursor,
    coffee_name: str,
    roast_level: str | None,
    agtron: str | None,
    estimated_price: str | None,
    roaster_id: int,
    origin_id: int,
) -> int:
    """Mengambil atau membuat coffee berdasarkan identitas naturalnya."""
    cursor.execute(
        """
        INSERT INTO coffee (
            coffee_name, roast_level, agtron, estimated_price, roaster_id, origin_id
        )
        VALUES (%s, %s, %s, %s, %s, %s)
        ON CONFLICT (coffee_name, roaster_id, origin_id)
        DO UPDATE SET
            roast_level = EXCLUDED.roast_level,
            agtron = EXCLUDED.agtron,
            estimated_price = EXCLUDED.estimated_price
        RETURNING coffee_id;
        """,
        (coffee_name, roast_level, agtron, estimated_price, roaster_id, origin_id),
    )
    return cursor.fetchone()[0]


def _upsert_review(
    cursor: Cursor,
    coffee_id: int,
    score: int,
    review_date: date,
    aroma_score: int | None,
    acidity_score: int | None,
    body_score: int | None,
    flavor_score: int | None,
    aftertaste_score: int | None,
    blind_assessment: str,
) -> None:
    """Menyimpan tepat satu review untuk setiap coffee melalui UNIQUE(coffee_id)."""
    cursor.execute(
        """
        INSERT INTO review (
            coffee_id, score, review_date, aroma_score, acidity_score, body_score,
            flavor_score, aftertaste_score, blind_assessment
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        ON CONFLICT (coffee_id)
        DO UPDATE SET
            score = EXCLUDED.score,
            review_date = EXCLUDED.review_date,
            aroma_score = EXCLUDED.aroma_score,
            acidity_score = EXCLUDED.acidity_score,
            body_score = EXCLUDED.body_score,
            flavor_score = EXCLUDED.flavor_score,
            aftertaste_score = EXCLUDED.aftertaste_score,
            blind_assessment = EXCLUDED.blind_assessment;
        """,
        (
            coffee_id,
            score,
            review_date,
            aroma_score,
            acidity_score,
            body_score,
            flavor_score,
            aftertaste_score,
            blind_assessment,
        ),
    )


def _require_mapping(value: Any, field_name: str) -> dict[str, Any]:
    """Memastikan nested JSON object tersedia."""
    if not isinstance(value, dict):
        raise ValueError(f"{field_name} harus berupa object.")
    return value


def _require_text(value: Any, field_name: str) -> str:
    """Memastikan field text wajib tidak kosong."""
    parsed_value = parse_nullable_value(value)
    if parsed_value is None:
        raise ValueError(f"{field_name} wajib tersedia.")
    return parsed_value


def _require_integer(value: Any, field_name: str) -> int:
    """Memastikan field integer wajib tidak kosong."""
    parsed_value = parse_nullable_integer(value)
    if parsed_value is None:
        raise ValueError(f"{field_name} wajib tersedia.")
    return parsed_value
