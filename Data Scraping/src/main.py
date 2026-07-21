"""Titik masuk untuk menjalankan seluruh alur data scraping."""

import logging

from config import OUTPUT_JSON_PATH
from preprocess import preprocess_review
from scraper import CoffeeReviewScraper
from utils import configure_logging, write_json


LOGGER = logging.getLogger(__name__)


def main() -> int:
    """Menjalankan extraction, preprocessing, dan export JSON."""
    configure_logging()

    with CoffeeReviewScraper() as scraper:
        review_urls = scraper.get_review_urls()
        if not review_urls:
            LOGGER.error("Tidak ada URL review yang dapat diproses.")
            return 1

        raw_reviews = scraper.scrape_reviews(review_urls)

    cleaned_reviews = []
    for index, raw_review in enumerate(raw_reviews, start=1):
        try:
            cleaned_reviews.append(preprocess_review(raw_review))
        except (TypeError, ValueError) as error:
            LOGGER.error("Preprocessing review ke-%s gagal: %s", index, error)

    write_json(cleaned_reviews, OUTPUT_JSON_PATH)
    LOGGER.info(
        "Export selesai: %s dari %s review disimpan ke %s.",
        len(cleaned_reviews),
        len(review_urls),
        OUTPUT_JSON_PATH,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
