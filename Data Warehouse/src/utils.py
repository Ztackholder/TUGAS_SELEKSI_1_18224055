"""Fungsi validasi dan transformasi deterministik untuk ETL Data Warehouse."""

import re
from datetime import date, datetime
from typing import Any, Mapping


def clean_text(value: Any) -> str | None:
    """Mengubah nilai menjadi teks bersih atau ``None`` apabila kosong."""
    if value is None:
        return None
    cleaned = re.sub(r"\s+", " ", str(value)).strip()
    return cleaned or None


def require_mapping(value: Any, field_name: str) -> Mapping[str, Any]:
    """Memastikan nilai JSON bersarang merupakan object."""
    if not isinstance(value, Mapping):
        raise ValueError(f"{field_name} harus berupa object JSON.")
    return value


def require_text(value: Any, field_name: str) -> str:
    """Memastikan field teks wajib tersedia dan tidak hanya whitespace."""
    cleaned = clean_text(value)
    if cleaned is None:
        raise ValueError(f"{field_name} wajib tersedia.")
    return cleaned


def parse_integer(value: Any, field_name: str, required: bool = False) -> int | None:
    """Mengubah nilai bilangan JSON menjadi integer dengan validasi sederhana."""
    if value is None or value == "":
        if required:
            raise ValueError(f"{field_name} wajib tersedia.")
        return None
    try:
        return int(value)
    except (TypeError, ValueError) as error:
        raise ValueError(f"{field_name} harus berupa integer.") from error


def parse_review_date(value: Any) -> date:
    """Mengubah tanggal review menjadi tanggal kalender.

    Dataset menggunakan ``YYYY-MM``. Nilai tersebut direpresentasikan sebagai
    hari pertama pada bulan yang sama agar dim_date tetap berformat YYYYMMDD.
    """
    text_value = require_text(value, "review.review_date")
    for date_format in ("%Y-%m-%d", "%Y-%m", "%B %Y", "%b %Y"):
        try:
            parsed = datetime.strptime(text_value, date_format).date()
            return parsed.replace(day=1) if date_format != "%Y-%m-%d" else parsed
        except ValueError:
            continue
    raise ValueError(
        "review.review_date harus berformat YYYY-MM, YYYY-MM-DD, atau nama bulan."
    )


def make_date_id(full_date: date) -> int:
    """Membuat natural key integer dim_date dengan format YYYYMMDD."""
    return int(full_date.strftime("%Y%m%d"))
