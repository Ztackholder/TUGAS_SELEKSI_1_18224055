"""Fungsi dasar untuk mengelola koneksi dan transaksi PostgreSQL."""

import logging

import psycopg2
from psycopg2.extensions import connection as Connection
from psycopg2.extensions import cursor as Cursor

from config import DATABASE, HOST, PASSWORD, PORT, USER


LOGGER = logging.getLogger(__name__)


def connect() -> Connection:
    """Membuka koneksi PostgreSQL berdasarkan environment variable."""
    if not DATABASE or not USER or PASSWORD is None:
        raise RuntimeError(
            "POSTGRES_DATABASE, POSTGRES_USER, dan POSTGRES_PASSWORD harus diatur."
        )

    return psycopg2.connect(
        host=HOST,
        port=PORT,
        dbname=DATABASE,
        user=USER,
        password=PASSWORD,
    )


def close(connection: Connection) -> None:
    """Menutup koneksi jika koneksi masih terbuka."""
    if not connection.closed:
        connection.close()


def cursor(connection: Connection) -> Cursor:
    """Membuat cursor baru untuk menjalankan statement berparameter."""
    return connection.cursor()


def commit(connection: Connection) -> None:
    """Menyimpan seluruh perubahan dalam transaksi aktif."""
    connection.commit()


def rollback(connection: Connection) -> None:
    """Membatalkan seluruh perubahan dalam transaksi aktif."""
    connection.rollback()
    LOGGER.warning("Transaksi Data Warehouse di-rollback.")
