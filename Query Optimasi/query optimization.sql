/*
===========================================================
BONUS - QUERY OPTIMIZATION

Database: Coffee Review
===========================================================

Seluruh query di bawah menggunakan EXPLAIN ANALYZE untuk
membandingkan performa query sebelum dan sesudah optimasi.
Output query tetap sama, namun penulisan query dioptimalkan
agar lebih efisien atau lebih mudah dipahami.
*/

-- =========================================================
-- QUERY OPTIMIZATION 1
-- Menghindari penggunaan SELECT *
--
-- Query awal mengambil seluruh kolom dari tabel coffee dan
-- review meskipun tidak semuanya diperlukan.
--
-- Query hasil optimasi hanya mengambil kolom yang dibutuhkan
-- sehingga jumlah data yang diproses menjadi lebih kecil.
-- =========================================================

-- Before
EXPLAIN ANALYZE
SELECT *
FROM coffee
JOIN review
ON coffee.coffee_id = review.coffee_id;

-- After
EXPLAIN ANALYZE
SELECT
    coffee.coffee_name,
    review.score
FROM coffee
JOIN review
ON coffee.coffee_id = review.coffee_id;

------------------------------------------------------------

-- =========================================================
-- QUERY OPTIMIZATION 2
-- Mengubah Implicit JOIN menjadi Explicit JOIN.
--
-- Query awal menggunakan sintaks implicit join dengan kondisi
-- relasi pada klausa WHERE.
--
-- Query hasil optimasi menggunakan JOIN ... ON sehingga
-- hubungan antar tabel lebih jelas dan mengurangi risiko
-- terjadinya Cartesian Product akibat kondisi join yang
-- terlewat.
-- =========================================================

-- Before
EXPLAIN ANALYZE
SELECT
    coffee.coffee_name,
    origin.country
FROM coffee, origin
WHERE coffee.origin_id = origin.origin_id;

-- After
EXPLAIN ANALYZE
SELECT
    coffee.coffee_name,
    origin.country
FROM coffee
JOIN origin
ON coffee.origin_id = origin.origin_id;

------------------------------------------------------------

-- =========================================================
-- QUERY OPTIMIZATION 3
-- Mengubah Subquery menjadi JOIN.
--
-- Query awal menggunakan subquery dengan operator IN untuk
-- memperoleh data roaster.
--
-- Query hasil optimasi menggunakan JOIN sehingga relasi antar
-- tabel lebih jelas dan struktur query menjadi lebih sederhana.
-- =========================================================

-- Before
EXPLAIN ANALYZE
SELECT coffee_name
FROM coffee
WHERE roaster_id IN (
    SELECT roaster_id
    FROM roaster
    WHERE roaster_location = 'California'
);

-- After
EXPLAIN ANALYZE
SELECT c.coffee_name
FROM coffee c
JOIN roaster r
ON c.roaster_id = r.roaster_id
WHERE r.roaster_location = 'California';