"""Konfigurasi terpusat untuk scraper Coffee Review."""

from pathlib import Path


BASE_URL = "https://www.coffeereview.com/"
TOP_50_URL = f"{BASE_URL}top-50-coffees-2025/"

REQUEST_TIMEOUT_SECONDS = 20
MAX_RETRIES = 3
REQUEST_DELAY_SECONDS = 1.5
RETRY_BACKOFF_SECONDS = 1.0
EXPECTED_REVIEW_COUNT = 50

USER_AGENT = (
    "CoffeeReviewETL/1.0 "
    "(educational project; contact: student@example.invalid)"
)

PROJECT_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = PROJECT_DIR / "data"
OUTPUT_JSON_PATH = DATA_DIR / "coffees.json"

# Selector halaman Top 50 yang telah diverifikasi dari HTML situs.
TOP_50_CARD_SELECTOR = (
    'main#genesis-content article[aria-label="Top 50 Coffees of 2025"] '
    ".review-template"
)
TOP_50_CARD_FALLBACK_SELECTOR = "main#genesis-content .review-template"
REVIEW_URL_SELECTOR = '.review-title a[href*="/review/"]'

# Selector untuk halaman detail review.
REVIEW_CONTAINER_SELECTOR = "main#genesis-content article.type-review .review-template"
REVIEW_CONTAINER_FALLBACK_SELECTOR = "main#genesis-content .review-template"
REVIEW_TITLE_SELECTOR = ".review-title"
ROASTER_SELECTOR = ".review-roaster"
SCORE_SELECTOR = ".review-template-rating"
METADATA_TABLE_SELECTOR = ".review-template-table"

TABLE_LABEL_TO_FIELD = {
    "Roaster Location:": "roaster_location",
    "Coffee Origin:": "coffee_origin",
    "Roast Level:": "roast_level",
    "Agtron:": "agtron",
    "Est. Price:": "estimated_price",
    "Review Date:": "review_date",
    "Aroma:": "aroma",
    "Acidity/Structure:": "acidity",
    "Body:": "body",
    "Flavor:": "flavor",
    "Aftertaste:": "aftertaste",
}
