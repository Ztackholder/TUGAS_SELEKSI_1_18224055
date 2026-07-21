"""Parser HTML menjadi data mentah terstruktur tanpa menyimpan HTML."""

import logging
from collections.abc import Iterable
from urllib.parse import urljoin, urlparse

from bs4 import BeautifulSoup, Tag

from config import (
    BASE_URL,
    METADATA_TABLE_SELECTOR,
    REVIEW_CONTAINER_FALLBACK_SELECTOR,
    REVIEW_CONTAINER_SELECTOR,
    REVIEW_TITLE_SELECTOR,
    REVIEW_URL_SELECTOR,
    ROASTER_SELECTOR,
    SCORE_SELECTOR,
    TABLE_LABEL_TO_FIELD,
    TOP_50_CARD_FALLBACK_SELECTOR,
    TOP_50_CARD_SELECTOR,
)


LOGGER = logging.getLogger(__name__)


def extract_review_urls(top_50_html: str) -> list[str]:
    """Mengambil URL review unik dari kartu coffee pada halaman Top 50."""
    soup = BeautifulSoup(top_50_html, "html.parser")
    cards = soup.select(TOP_50_CARD_SELECTOR)

    if not cards:
        LOGGER.warning("Selector kartu utama tidak ditemukan; memakai selector alternatif.")
        cards = soup.select(TOP_50_CARD_FALLBACK_SELECTOR)

    review_urls: list[str] = []
    seen_urls: set[str] = set()
    for card in cards:
        link = card.select_one(REVIEW_URL_SELECTOR)
        if link is None or not link.get("href"):
            LOGGER.warning("URL review tidak ditemukan pada satu kartu Top 50.")
            continue

        review_url = urljoin(BASE_URL, link["href"])
        if _is_internal_review_url(review_url) and review_url not in seen_urls:
            seen_urls.add(review_url)
            review_urls.append(review_url)

    return review_urls


def parse_review_html(review_html: str) -> dict[str, str | None] | None:
    """Mengubah satu halaman review menjadi dictionary data mentah."""
    soup = BeautifulSoup(review_html, "html.parser")
    container = soup.select_one(REVIEW_CONTAINER_SELECTOR)

    if container is None:
        LOGGER.warning("Selector review utama tidak ditemukan; memakai selector alternatif.")
        container = soup.select_one(REVIEW_CONTAINER_FALLBACK_SELECTOR)
    if container is None:
        LOGGER.error("Kontainer review tidak ditemukan. Struktur halaman mungkin berubah.")
        return None

    table_values = _extract_table_values(container)
    raw_review: dict[str, str | None] = {
        "coffee_name": _element_text(container.select_one(REVIEW_TITLE_SELECTOR)),
        "roaster_name": _element_text(container.select_one(ROASTER_SELECTOR)),
        "score": _element_text(container.select_one(SCORE_SELECTOR)),
        "blind_assessment": _extract_blind_assessment(container),
    }

    for label, field_name in TABLE_LABEL_TO_FIELD.items():
        raw_review[field_name] = table_values.get(label)

    return raw_review


def _extract_table_values(container: Tag) -> dict[str, str | None]:
    """Membaca pasangan label dan nilai dari tabel metadata review."""
    values: dict[str, str | None] = {}
    for table in container.select(METADATA_TABLE_SELECTOR):
        for row in table.select("tr"):
            cells = row.find_all("td", recursive=False)
            if len(cells) < 2:
                continue

            label = _element_text(cells[0])
            value = _element_text(cells[1])
            if label:
                values[label] = value

    return values


def _extract_blind_assessment(container: Tag) -> str | None:
    """Mengambil paragraf yang langsung mengikuti heading Blind Assessment."""
    heading = next(
        (
            element
            for element in _headings(container)
            if element.get_text(" ", strip=True).casefold() == "blind assessment"
        ),
        None,
    )
    if heading is None:
        return None

    paragraph = heading.find_next_sibling("p")
    return _element_text(paragraph)


def _headings(container: Tag) -> Iterable[Tag]:
    """Menghasilkan heading dalam kontainer review."""
    return container.find_all(["h1", "h2", "h3"])


def _element_text(element: Tag | None) -> str | None:
    """Mengambil teks dari elemen tanpa melakukan preprocessing akhir."""
    if element is None:
        return None
    return element.get_text(" ", strip=True) or None


def _is_internal_review_url(url: str) -> bool:
    """Memastikan URL berasal dari Coffee Review dan memiliki path review."""
    parsed = urlparse(url)
    hostname = (parsed.hostname or "").casefold()
    is_coffee_review_host = hostname == "coffeereview.com" or hostname.endswith(
        ".coffeereview.com"
    )
    return is_coffee_review_host and parsed.path.startswith("/review/")
