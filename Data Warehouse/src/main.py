"""Entry point untuk membangun dan mengisi Coffee Review Data Warehouse."""

import logging
import sys

from create_tables import create_tables
from database import close, commit, connect, rollback
from insert_data import EtlStatistics, insert_data, load_json


def configure_logging() -> None:
    """Mengatur format log konsisten untuk proses Data Warehouse."""
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )


def print_statistics(statistics: EtlStatistics) -> None:
    """Mencetak jumlah akhir setiap dimension dan fact table."""
    print(f"Dimension Roaster : {statistics.roaster_count}")
    print(f"Dimension Origin  : {statistics.origin_count}")
    print(f"Dimension Coffee  : {statistics.coffee_count}")
    print(f"Dimension Date    : {statistics.date_count}")
    print(f"Fact Review       : {statistics.review_count}")


def main() -> int:
    """Membuat schema, memuat JSON, menjalankan ETL, dan menyimpan transaksi."""
    configure_logging()
    logger = logging.getLogger("main")
    connection = None
    try:
        connection = connect()
        create_tables(connection)
        records = load_json()
        statistics = insert_data(connection, records)
        commit(connection)
        print_statistics(statistics)
        logger.info(
            "Data Warehouse berhasil dibangun dari %s record JSON.",
            len(records),
        )
        return 0
    except Exception as error:
        if connection is not None:
            rollback(connection)
        logger.exception("Pembuatan Data Warehouse gagal: %s", error)
        return 1
    finally:
        if connection is not None:
            close(connection)


if __name__ == "__main__":
    sys.exit(main())
