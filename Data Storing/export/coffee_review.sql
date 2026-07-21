BEGIN;

CREATE TABLE roaster (
    roaster_id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    roaster_name TEXT NOT NULL,
    roaster_location TEXT NOT NULL
);

CREATE TABLE origin (
    origin_id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    locality TEXT,
    region TEXT,
    country TEXT NOT NULL
);

CREATE TABLE coffee (
    coffee_id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    coffee_name TEXT NOT NULL,
    roast_level TEXT,
    agtron TEXT,
    estimated_price TEXT,
    roaster_id BIGINT NOT NULL,
    origin_id BIGINT NOT NULL
);

CREATE TABLE review (
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

ALTER TABLE roaster
    ADD CONSTRAINT pk_roaster PRIMARY KEY (roaster_id),
    ADD CONSTRAINT uq_roaster_name_location UNIQUE (roaster_name, roaster_location);

ALTER TABLE origin
    ADD CONSTRAINT pk_origin PRIMARY KEY (origin_id),
    ADD CONSTRAINT uq_origin_geography
        UNIQUE NULLS NOT DISTINCT (locality, region, country);

ALTER TABLE coffee
    ADD CONSTRAINT pk_coffee PRIMARY KEY (coffee_id),
    ADD CONSTRAINT uq_coffee_identity UNIQUE (coffee_name, roaster_id, origin_id),
    ADD CONSTRAINT fk_coffee_roaster
        FOREIGN KEY (roaster_id) REFERENCES roaster(roaster_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD CONSTRAINT fk_coffee_origin
        FOREIGN KEY (origin_id) REFERENCES origin(origin_id)
        ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE review
    ADD CONSTRAINT pk_review PRIMARY KEY (review_id),
    ADD CONSTRAINT uq_review_coffee UNIQUE (coffee_id),
    ADD CONSTRAINT fk_review_coffee
        FOREIGN KEY (coffee_id) REFERENCES coffee(coffee_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD CONSTRAINT ck_review_score CHECK (score BETWEEN 0 AND 100),
    ADD CONSTRAINT ck_review_aroma_score
        CHECK (aroma_score IS NULL OR aroma_score BETWEEN 0 AND 10),
    ADD CONSTRAINT ck_review_acidity_score
        CHECK (acidity_score IS NULL OR acidity_score BETWEEN 0 AND 10),
    ADD CONSTRAINT ck_review_body_score
        CHECK (body_score IS NULL OR body_score BETWEEN 0 AND 10),
    ADD CONSTRAINT ck_review_flavor_score
        CHECK (flavor_score IS NULL OR flavor_score BETWEEN 0 AND 10),
    ADD CONSTRAINT ck_review_aftertaste_score
        CHECK (aftertaste_score IS NULL OR aftertaste_score BETWEEN 0 AND 10);

CREATE INDEX idx_coffee_roaster_id ON coffee(roaster_id);
CREATE INDEX idx_coffee_origin_id ON coffee(origin_id);

COMMIT;
