"""Titik masuk tahap Data Storing."""

import logging

from create_tables import create_tables
from insert_data import insert_data
from utils import configure_logging


LOGGER = logging.getLogger(__name__)


def main() -> int:
    """Membuat skema PostgreSQL lalu menjalankan ETL dari JSON."""
    configure_logging()
    try:
        create_tables()
        inserted_records = insert_data()
    except Exception as error:
        LOGGER.error("Data storing gagal: %s", error)
        return 1

    LOGGER.info("Data storing selesai untuk %s record.", inserted_records)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
