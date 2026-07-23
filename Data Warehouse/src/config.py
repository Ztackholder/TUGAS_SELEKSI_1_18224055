"""Konfigurasi koneksi dan lokasi berkas Data Warehouse."""

import os
from pathlib import Path

from dotenv import load_dotenv


DATA_WAREHOUSE_DIR = Path(__file__).resolve().parent.parent
PROJECT_DIR = DATA_WAREHOUSE_DIR.parent
INPUT_JSON_PATH = PROJECT_DIR / "Data Scraping" / "data" / "coffees.json"

# Berkas .env Data Warehouse diprioritaskan. Root project juga didukung agar
# kredensial yang telah ada dapat dipakai tanpa disalin ulang.
load_dotenv(DATA_WAREHOUSE_DIR / ".env", override=False)
load_dotenv(PROJECT_DIR / ".env", override=False)

HOST = os.getenv("POSTGRES_HOST", "localhost")
PORT = int(os.getenv("POSTGRES_PORT", "5432"))
DATABASE = "dw_coffee_review"
USER = os.getenv("POSTGRES_USER")
PASSWORD = os.getenv("POSTGRES_PASSWORD")
