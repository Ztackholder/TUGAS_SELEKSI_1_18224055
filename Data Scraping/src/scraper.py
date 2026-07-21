"""Orkestrasi pengambilan halaman Top 50 dan halaman review."""

import logging

import requests

from config import EXPECTED_REVIEW_COUNT, REQUEST_DELAY_SECONDS, TOP_50_URL
from parser import extract_review_urls, parse_review_html
from utils import create_session, fetch_html, wait_between_requests


LOGGER = logging.getLogger(__name__)


class CoffeeReviewScraper:
    """Scraper berbasis requests untuk daftar Top 50 Coffee Review."""

    def __init__(self, delay_seconds: float = REQUEST_DELAY_SECONDS) -> None:
        """Membuat scraper dengan satu HTTP session dan jeda request."""
        self.delay_seconds = delay_seconds
        self.session = create_session()

    def close(self) -> None:
        """Menutup session HTTP setelah proses selesai."""
        self.session.close()

    def get_review_urls(self) -> list[str]:
        """Mengambil daftar URL detail review dari halaman Top 50."""
        top_50_html = fetch_html(self.session, TOP_50_URL)
        if top_50_html is None:
            return []

        LOGGER.info("Halaman Top 50 berhasil diambil.")
        review_urls = extract_review_urls(top_50_html)
        LOGGER.info("%s URL review ditemukan.", len(review_urls))
        if len(review_urls) != EXPECTED_REVIEW_COUNT:
            LOGGER.warning(
                "Jumlah URL review berbeda dari ekspektasi (%s): %s.",
                EXPECTED_REVIEW_COUNT,
                len(review_urls),
            )
        return review_urls

    def scrape_reviews(self, review_urls: list[str]) -> list[dict[str, str | None]]:
        """Mengambil dan mem-parsing setiap halaman review tanpa berhenti saat gagal."""
        reviews: list[dict[str, str | None]] = []
        total_reviews = len(review_urls)

        for index, review_url in enumerate(review_urls, start=1):
            LOGGER.info("Memproses %s/%s: %s", index, total_reviews, review_url)
            review_html = fetch_html(self.session, review_url)

            if review_html is not None:
                try:
                    parsed_review = parse_review_html(review_html)
                except Exception as error:  # Parser tidak boleh menghentikan review berikutnya.
                    LOGGER.exception("Parsing gagal untuk %s: %s", review_url, error)
                    parsed_review = None
                if parsed_review is not None:
                    reviews.append(parsed_review)
                else:
                    LOGGER.error("Parsing gagal, review dilewati: %s", review_url)

            if index < total_reviews:
                wait_between_requests(self.delay_seconds)

        return reviews

    def __enter__(self) -> "CoffeeReviewScraper":
        """Mengembalikan scraper untuk penggunaan context manager."""
        return self

    def __exit__(self, *_: object) -> None:
        """Menutup session ketika blok context manager selesai."""
        self.close()
