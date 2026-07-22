"""Konfigurasi koneksi PostgreSQL dan lokasi file proyek."""

from pathlib import Path
import os
from dotenv import load_dotenv

load_dotenv()

HOST = os.getenv("POSTGRES_HOST", "localhost")
PORT = int(os.getenv("POSTGRES_PORT", "5432"))
DATABASE = os.getenv("POSTGRES_DATABASE")
USER = os.getenv("POSTGRES_USER")
PASSWORD = os.getenv("POSTGRES_PASSWORD")

DATA_STORING_DIR = Path(__file__).resolve().parent.parent
PROJECT_DIR = DATA_STORING_DIR.parent
INPUT_JSON_PATH = PROJECT_DIR / "Data Scraping" / "data" / "coffees.json"
