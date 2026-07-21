"""Helper koneksi dan transaction PostgreSQL."""

import logging
from collections.abc import Generator
from contextlib import contextmanager

import psycopg2
from psycopg2.extensions import connection as Connection
from psycopg2.extensions import cursor as Cursor

from config import DATABASE, HOST, PASSWORD, PORT, USER


LOGGER = logging.getLogger(__name__)


def get_connection() -> Connection:
    """Membuat koneksi PostgreSQL dari environment variable."""
    if not DATABASE or not USER:
        raise RuntimeError(
            "POSTGRES_DATABASE dan POSTGRES_USER harus diatur pada environment variable."
        )

    connection = psycopg2.connect(
        host=HOST,
        port=PORT,
        dbname=DATABASE,
        user=USER,
        password=PASSWORD,
    )
    return connection


@contextmanager
def transaction(connection: Connection) -> Generator[Cursor, None, None]:
    """Menjalankan operasi database secara atomik dengan commit atau rollback."""
    cursor = connection.cursor()
    try:
        yield cursor
        connection.commit()
    except Exception:
        connection.rollback()
        LOGGER.exception("Transaction di-rollback karena terjadi error.")
        raise
    finally:
        cursor.close()


def close_connection(connection: Connection) -> None:
    """Menutup koneksi PostgreSQL apabila masih terbuka."""
    if not connection.closed:
        connection.close()
