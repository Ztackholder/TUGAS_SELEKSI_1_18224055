"""Pembuatan tabel, constraint, dan index PostgreSQL."""

import logging

from psycopg2.extensions import cursor as Cursor

from database import close_connection, get_connection, transaction


LOGGER = logging.getLogger(__name__)

CREATE_TABLE_STATEMENTS = (
    """
    CREATE TABLE IF NOT EXISTS roaster (
        roaster_id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
        roaster_name TEXT NOT NULL,
        roaster_location TEXT NOT NULL
    );
    """,
    """
    CREATE TABLE IF NOT EXISTS origin (
        origin_id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
        locality TEXT,
        region TEXT,
        country TEXT NOT NULL
    );
    """,
    """
    CREATE TABLE IF NOT EXISTS coffee (
        coffee_id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
        coffee_name TEXT NOT NULL,
        roast_level TEXT,
        agtron TEXT,
        estimated_price TEXT,
        roaster_id BIGINT NOT NULL,
        origin_id BIGINT NOT NULL
    );
    """,
    """
    CREATE TABLE IF NOT EXISTS review (
        review_id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
        coffee_id BIGINT NOT NULL,
        score INTEGER NOT NULL,
        review_date DATE NOT NULL,
        aroma_score INTEGER,
        acidity_score INTEGER,
        body_score INTEGER,
        flavor_score INTEGER,
        aftertaste_score INTEGER,
        blind_assessment TEXT NOT NULL
    );
    """,
)

CONSTRAINT_DEFINITIONS = (
    ("roaster", "pk_roaster", "PRIMARY KEY (roaster_id)"),
    (
        "roaster",
        "uq_roaster_name_location",
        "UNIQUE (roaster_name, roaster_location)",
    ),
    ("origin", "pk_origin", "PRIMARY KEY (origin_id)"),
    (
        "origin",
        "uq_origin_geography",
        "UNIQUE NULLS NOT DISTINCT (locality, region, country)",
    ),
    ("coffee", "pk_coffee", "PRIMARY KEY (coffee_id)"),
    (
        "coffee",
        "uq_coffee_identity",
        "UNIQUE (coffee_name, roaster_id, origin_id)",
    ),
    (
        "coffee",
        "fk_coffee_roaster",
        "FOREIGN KEY (roaster_id) REFERENCES roaster(roaster_id) "
        "ON UPDATE CASCADE ON DELETE RESTRICT",
    ),
    (
        "coffee",
        "fk_coffee_origin",
        "FOREIGN KEY (origin_id) REFERENCES origin(origin_id) "
        "ON UPDATE CASCADE ON DELETE RESTRICT",
    ),
    ("review", "pk_review", "PRIMARY KEY (review_id)"),
    ("review", "uq_review_coffee", "UNIQUE (coffee_id)"),
    (
        "review",
        "fk_review_coffee",
        "FOREIGN KEY (coffee_id) REFERENCES coffee(coffee_id) "
        "ON UPDATE CASCADE ON DELETE RESTRICT",
    ),
    ("review", "ck_review_score", "CHECK (score BETWEEN 0 AND 100)"),
    (
        "review",
        "ck_review_aroma_score",
        "CHECK (aroma_score IS NULL OR aroma_score BETWEEN 0 AND 10)",
    ),
    (
        "review",
        "ck_review_acidity_score",
        "CHECK (acidity_score IS NULL OR acidity_score BETWEEN 0 AND 10)",
    ),
    (
        "review",
        "ck_review_body_score",
        "CHECK (body_score IS NULL OR body_score BETWEEN 0 AND 10)",
    ),
    (
        "review",
        "ck_review_flavor_score",
        "CHECK (flavor_score IS NULL OR flavor_score BETWEEN 0 AND 10)",
    ),
    (
        "review",
        "ck_review_aftertaste_score",
        "CHECK (aftertaste_score IS NULL OR aftertaste_score BETWEEN 0 AND 10)",
    ),
)

INDEX_STATEMENTS = (
    "CREATE INDEX IF NOT EXISTS idx_coffee_roaster_id ON coffee(roaster_id);",
    "CREATE INDEX IF NOT EXISTS idx_coffee_origin_id ON coffee(origin_id);",
)


def create_tables() -> None:
    """Membuat seluruh tabel, constraint, dan index secara idempoten."""
    connection = get_connection()
    try:
        with transaction(connection) as cursor:
            for statement in CREATE_TABLE_STATEMENTS:
                cursor.execute(statement)

            for table_name, constraint_name, definition in CONSTRAINT_DEFINITIONS:
                _add_constraint_if_missing(cursor, table_name, constraint_name, definition)

            for statement in INDEX_STATEMENTS:
                cursor.execute(statement)
    finally:
        close_connection(connection)

    LOGGER.info("Tabel, constraint, dan index PostgreSQL siap digunakan.")


def _add_constraint_if_missing(
    cursor: Cursor,
    table_name: str,
    constraint_name: str,
    definition: str,
) -> None:
    """Menambahkan constraint hanya jika belum ada pada tabel terkait."""
    cursor.execute(
        """
        SELECT EXISTS (
            SELECT 1
            FROM pg_constraint
            WHERE conrelid = %s::regclass AND conname = %s
        );
        """,
        (table_name, constraint_name),
    )
    exists = cursor.fetchone()[0]
    if not exists:
        cursor.execute(
            f"ALTER TABLE {table_name} ADD CONSTRAINT {constraint_name} {definition};"
        )
