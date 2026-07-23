"""DDL untuk seluruh tabel pada star schema Coffee Review Data Warehouse."""

from psycopg2.extensions import connection as Connection

from database import cursor


CREATE_DIM_ROASTER = """
CREATE TABLE IF NOT EXISTS dim_roaster (
    roaster_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    roaster_name TEXT NOT NULL,
    location TEXT NOT NULL,
    CONSTRAINT uq_dim_roaster UNIQUE (roaster_name, location)
);
"""

CREATE_DIM_ORIGIN = """
CREATE TABLE IF NOT EXISTS dim_origin (
    origin_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    locality TEXT,
    region TEXT,
    country TEXT NOT NULL,
    CONSTRAINT uq_dim_origin UNIQUE NULLS NOT DISTINCT (locality, region, country)
);
"""

CREATE_DIM_COFFEE = """
CREATE TABLE IF NOT EXISTS dim_coffee (
    coffee_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    coffee_name TEXT NOT NULL,
    roast_level TEXT,
    agtron TEXT,
    estimated_price TEXT,
    CONSTRAINT uq_dim_coffee UNIQUE NULLS NOT DISTINCT (
        coffee_name, roast_level, agtron, estimated_price
    )
);
"""

CREATE_DIM_DATE = """
CREATE TABLE IF NOT EXISTS dim_date (
    date_id INTEGER PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    day SMALLINT NOT NULL CHECK (day BETWEEN 1 AND 31),
    month SMALLINT NOT NULL CHECK (month BETWEEN 1 AND 12),
    year SMALLINT NOT NULL CHECK (year BETWEEN 1900 AND 9999),
    CONSTRAINT ck_dim_date_id_matches_date
        CHECK (date_id = (EXTRACT(YEAR FROM full_date)::INTEGER * 10000)
                         + (EXTRACT(MONTH FROM full_date)::INTEGER * 100)
                         + EXTRACT(DAY FROM full_date)::INTEGER)
);
"""

CREATE_FACT_REVIEW = """
CREATE TABLE IF NOT EXISTS fact_review (
    review_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    coffee_id BIGINT NOT NULL,
    origin_id BIGINT NOT NULL,
    roaster_id BIGINT NOT NULL,
    date_id INTEGER NOT NULL,
    score SMALLINT NOT NULL CHECK (score BETWEEN 0 AND 100),
    aroma_score SMALLINT CHECK (aroma_score BETWEEN 0 AND 10),
    acidity_score SMALLINT CHECK (acidity_score BETWEEN 0 AND 10),
    body_score SMALLINT CHECK (body_score BETWEEN 0 AND 10),
    flavor_score SMALLINT CHECK (flavor_score BETWEEN 0 AND 10),
    aftertaste_score SMALLINT CHECK (aftertaste_score BETWEEN 0 AND 10),
    CONSTRAINT fk_fact_review_coffee
        FOREIGN KEY (coffee_id) REFERENCES dim_coffee (coffee_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_fact_review_origin
        FOREIGN KEY (origin_id) REFERENCES dim_origin (origin_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_fact_review_roaster
        FOREIGN KEY (roaster_id) REFERENCES dim_roaster (roaster_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_fact_review_date
        FOREIGN KEY (date_id) REFERENCES dim_date (date_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_fact_review_grain UNIQUE (coffee_id, origin_id, roaster_id, date_id)
);
"""

CREATE_INDEXES = (
    "CREATE INDEX IF NOT EXISTS idx_fact_review_origin_id "
    "ON fact_review (origin_id);",
    "CREATE INDEX IF NOT EXISTS idx_fact_review_roaster_id "
    "ON fact_review (roaster_id);",
    "CREATE INDEX IF NOT EXISTS idx_fact_review_date_id "
    "ON fact_review (date_id);",
)


def create_tables(connection: Connection) -> None:
    """Membuat setiap dimension, fact table, dan index jika belum tersedia."""
    statements = (
        CREATE_DIM_ROASTER,
        CREATE_DIM_ORIGIN,
        CREATE_DIM_COFFEE,
        CREATE_DIM_DATE,
        CREATE_FACT_REVIEW,
        *CREATE_INDEXES,
    )
    db_cursor = cursor(connection)
    try:
        for statement in statements:
            db_cursor.execute(statement)
    finally:
        db_cursor.close()
