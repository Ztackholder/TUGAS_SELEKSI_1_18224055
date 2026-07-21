"""Utilitas ETL untuk logging, parsing nilai nullable, dan deduplikasi master data."""

import logging
from datetime import date
from typing import Any

from psycopg2.extensions import cursor as Cursor


LOGGER = logging.getLogger(__name__)


def configure_logging() -> None:
    """Mengatur format logging konsisten untuk tahap data storing."""
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )


def parse_nullable_value(value: Any) -> str | None:
    """Mengubah nilai kosong menjadi None dan membersihkan teks sederhana."""
    if value is None:
        return None

    normalized = str(value).strip()
    return normalized or None


def parse_nullable_integer(value: Any) -> int | None:
    """Mengubah nilai angka nullable menjadi integer."""
    if value is None or isinstance(value, bool):
        return None
    return int(value)


def parse_review_date(value: Any) -> date:
    """Mengubah format JSON YYYY-MM atau YYYY-MM-DD ke tipe DATE PostgreSQL."""
    normalized = parse_nullable_value(value)
    if normalized is None:
        raise ValueError("review_date wajib tersedia.")

    if len(normalized) == 7:
        return date.fromisoformat(f"{normalized}-01")
    return date.fromisoformat(normalized)


def get_or_create_roaster(cursor: Cursor, name: str, location: str) -> int:
    """Mengambil atau membuat roaster berdasarkan nama dan lokasi unik."""
    cursor.execute(
        """
        INSERT INTO roaster (roaster_name, roaster_location)
        VALUES (%s, %s)
        ON CONFLICT (roaster_name, roaster_location) DO NOTHING
        RETURNING roaster_id;
        """,
        (name, location),
    )
    row = cursor.fetchone()
    if row is not None:
        return row[0]

    cursor.execute(
        """
        SELECT roaster_id
        FROM roaster
        WHERE roaster_name = %s AND roaster_location = %s;
        """,
        (name, location),
    )
    return _require_identifier(cursor.fetchone(), "roaster")


def get_or_create_origin(
    cursor: Cursor,
    locality: str | None,
    region: str | None,
    country: str,
) -> int:
    """Mengambil atau membuat origin berdasarkan kombinasi geografis unik."""
    cursor.execute(
        """
        INSERT INTO origin (locality, region, country)
        VALUES (%s, %s, %s)
        ON CONFLICT (locality, region, country) DO NOTHING
        RETURNING origin_id;
        """,
        (locality, region, country),
    )
    row = cursor.fetchone()
    if row is not None:
        return row[0]

    cursor.execute(
        """
        SELECT origin_id
        FROM origin
        WHERE locality IS NOT DISTINCT FROM %s
          AND region IS NOT DISTINCT FROM %s
          AND country = %s;
        """,
        (locality, region, country),
    )
    return _require_identifier(cursor.fetchone(), "origin")


def _require_identifier(row: tuple[int] | None, entity_name: str) -> int:
    """Memastikan proses get-or-create menghasilkan primary key."""
    if row is None:
        raise RuntimeError(f"Gagal mendapatkan ID untuk {entity_name}.")
    return row[0]
