"""Cleaning, parsing, transformasi, dan validasi data review."""

import logging
import re
import unicodedata
from datetime import datetime
from typing import Any


LOGGER = logging.getLogger(__name__)
INVISIBLE_CHARACTERS = "\u200b\u200c\u200d\ufeff"
NUMERIC_REVIEW_FIELDS = ("score", "aroma", "acidity", "body", "flavor", "aftertaste")


def clean_text(value: object) -> str | None:
    """Membersihkan whitespace dan karakter Unicode tak terlihat dari teks."""
    if value is None:
        return None

    cleaned = unicodedata.normalize("NFKC", str(value))
    cleaned = cleaned.replace("\u00a0", " ")
    cleaned = cleaned.translate({ord(character): None for character in INVISIBLE_CHARACTERS})
    cleaned = re.sub(r"\s+", " ", cleaned).strip()
    return cleaned or None


def parse_origin(value: object) -> dict[str, str | None]:
    """Memecah origin menjadi locality, region, dan country secara deterministik."""
    cleaned = clean_text(value)
    empty_origin = {"locality": None, "region": None, "country": None}
    if cleaned is None:
        return empty_origin

    parts = [clean_text(part) for part in cleaned.split(",")]
    parts = [part for part in parts if part]

    if len(parts) == 1:
        return {"locality": None, "region": None, "country": parts[0]}
    if len(parts) == 2:
        return {"locality": parts[0], "region": None, "country": parts[1]}

    return {
        "locality": ", ".join(parts[:-2]),
        "region": parts[-2],
        "country": parts[-1],
    }


def parse_integer(value: object) -> int | None:
    """Mengubah nilai angka review menjadi integer atau None."""
    cleaned = clean_text(value)
    if cleaned is None:
        return None

    match = re.search(r"-?\d+", cleaned)
    return int(match.group()) if match else None


def parse_review_date(value: object) -> str | None:
    """Menormalkan tanggal review seperti 'September 2025' ke YYYY-MM."""
    cleaned = clean_text(value)
    if cleaned is None:
        return None

    for date_format in ("%B %Y", "%b %Y"):
        try:
            return datetime.strptime(cleaned, date_format).strftime("%Y-%m")
        except ValueError:
            continue

    LOGGER.warning("Format review date tidak dikenali: %s", cleaned)
    return None


def preprocess_review(raw_review: dict[str, str | None]) -> dict[str, Any]:
    """Membersihkan dan mengubah satu review mentah ke skema JSON final."""
    record: dict[str, Any] = {
        "coffee_name": clean_text(raw_review.get("coffee_name")),
        "roaster": {
            "name": clean_text(raw_review.get("roaster_name")),
            "location": clean_text(raw_review.get("roaster_location")),
        },
        "origin": parse_origin(raw_review.get("coffee_origin")),
        "roast_level": clean_text(raw_review.get("roast_level")),
        "agtron": clean_text(raw_review.get("agtron")),
        "estimated_price": clean_text(raw_review.get("estimated_price")),
        "review": {
            "score": parse_integer(raw_review.get("score")),
            "review_date": parse_review_date(raw_review.get("review_date")),
            "aroma": parse_integer(raw_review.get("aroma")),
            "acidity": parse_integer(raw_review.get("acidity")),
            "body": parse_integer(raw_review.get("body")),
            "flavor": parse_integer(raw_review.get("flavor")),
            "aftertaste": parse_integer(raw_review.get("aftertaste")),
            "blind_assessment": clean_text(raw_review.get("blind_assessment")),
        },
    }
    validate_review(record)
    return record


def validate_review(record: dict[str, Any]) -> None:
    """Mencatat field penting yang kosong tanpa menghentikan proses scraping."""
    if record["coffee_name"] is None:
        LOGGER.warning("coffee_name tidak ditemukan pada satu review.")

    for field_name in NUMERIC_REVIEW_FIELDS:
        if record["review"][field_name] is None:
            LOGGER.warning("Nilai %s tidak ditemukan atau tidak valid.", field_name)

    origin = record["origin"]
    if not any(origin.values()):
        LOGGER.warning("Coffee origin tidak ditemukan atau tidak dapat diparse.")
