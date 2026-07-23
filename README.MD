<h1 align="center">
  <br>
  Seleksi Warga Basdat 2026 <br>
  ETL Project <br>
  Coffee Review: Top 50 Coffees of 2025
  <br>
  <br>
</h1>

## Author

**Nama** : Adrian Akhdan Assyauqi  
**NIM** : 18224055


## Deskripsi

Proyek ini merupakan implementasi proses **Data Storing** menggunakan data hasil web scraping dari situs **Coffee Review**. Dataset yang digunakan berisi daftar **Top 50 Coffees of 2025**, lengkap dengan informasi mengenai kopi, roaster, asal kopi, serta hasil penilaian (review) yang diberikan oleh Coffee Review. Data hasil scraping kemudian disimpan ke dalam sebuah **Relational Database Management System (RDBMS)** menggunakan **PostgreSQL** dengan memperhatikan prinsip normalisasi, integritas data, serta relasi antar entitas.

### Mengapa memilih topik ini?

Saya memilih topik ini karena saya merupakan seorang pecinta kopi dan memiliki rasa penasaran mengenai berbagai jenis kopi terbaik yang ada di dunia. Melalui dataset ini saya dapat mempelajari informasi mengenai asal kopi, perusahaan roaster, karakteristik kopi, serta bagaimana kopi tersebut dinilai oleh para reviewer profesional.


## DBMS yang Digunakan

DBMS yang digunakan pada proyek ini adalah:

- PostgreSQL 18

Alasan pemilihan PostgreSQL:

- Open source dan banyak digunakan di industri.
- Mendukung constraint yang lengkap (PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK).
- Memiliki performa yang baik untuk relational database.
- Mendukung transaksi (ACID).
- Mudah diintegrasikan dengan Python melalui library **psycopg2**.


## Cara Menjalankan Program

### 1. Clone repository

```bash
git clone <repository-url>
cd TUGAS_SELEKSI_1_18224055
```


### 2. Install dependency

```bash
pip install -r requirements.txt
```


### 3. Jalankan proses scraping

Masuk ke folder Data Scraping kemudian jalankan

```bash
python src/main.py
```

Program akan:

- Mengambil data dari website Coffee Review
- Melakukan parsing HTML menggunakan BeautifulSoup
- Menghasilkan file

```
Data Scraping/data/coffees.json
```

### 4. Buat database PostgreSQL

Masuk ke PostgreSQL

```bash
psql -U postgres
```

Buat database

```sql
CREATE DATABASE coffee_review;
```

Keluar

```sql
\q
```

### 5. Membuat struktur database

Import file SQL

```bash
psql -U postgres -d coffee_review -f "Data Storing/export/coffee_review.sql"
```

### 6. Atur environment variable

Buat file `.env`

```env
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DATABASE=coffee_review
POSTGRES_USER=postgres
POSTGRES_PASSWORD=<password PostgreSQL>
```

### 7. Jalankan proses Data Storing

```bash
python "Data Storing/src/main.py"
```

Program akan

- Membaca file JSON hasil scraping
- Memproses data
- Memasukkan data ke PostgreSQL

## Struktur File JSON

File hasil scraping disimpan pada

```
Data Scraping/data/coffees.json
```

Struktur setiap objek pada file JSON adalah sebagai berikut.

```json
{
    "coffee_name": "...",
    "roaster": {
        "name": "...",
        "location": "..."
    },
    "origin": {
        "locality": "...",
        "region": "...",
        "country": "..."
    },
    "coffee": {
        "roast_level": "...",
        "agtron": "...",
        "estimated_price": "..."
    },
    "review": {
        "score": ...,
        "review_date": "...",
        "aroma": ...,
        "acidity": ...,
        "body": ...,
        "flavor": ...,
        "aftertaste": ...,
        "blind_assessment": "..."
    }
}
```

Penjelasan setiap bagian:

| Field | Keterangan |
|--------|------------|
| coffee_name | Nama kopi |
| roaster | Informasi perusahaan roaster |
| origin | Informasi asal kopi |
| roast_level | Tingkat roasting |
| agtron | Nilai Agtron |
| estimated_price | Estimasi harga |
| score | Nilai keseluruhan review |
| aroma | Nilai aroma |
| acidity | Nilai acidity |
| body | Nilai body |
| flavor | Nilai flavor |
| aftertaste | Nilai aftertaste |
| blind_assessment | Deskripsi hasil review |


## Entity Relationship Diagram (ERD)

![ERD](<Data Storing/design/ERD.png>)

### Penjelasan Desain ERD

Basis data terdiri dari empat entitas utama:

- **Roaster**
- **Origin**
- **Coffee**
- **Review**

Hubungan antar entitas adalah:

- Satu **Roaster** dapat memiliki banyak **Coffee** (1:N).
- Satu **Origin** dapat dimiliki oleh banyak **Coffee** (1:N).
- Setiap **Coffee** memiliki tepat satu **Review** (1:1).

Desain ini dipilih agar data tidak mengalami redundansi serta memenuhi prinsip normalisasi sehingga informasi mengenai roaster maupun asal kopi tidak perlu disimpan berulang kali pada setiap data kopi.


## Diagram Relasional

![Diagram Relasional](<Data Storing/design/Diagram Relasional.png>)

### Penjelasan Diagram Relasional

Hasil translasi menghasilkan empat tabel utama:

- Roaster
- Origin
- Coffee
- Review

Relasi antar tabel direpresentasikan menggunakan **Foreign Key**, sedangkan integritas data dijaga menggunakan:

- PRIMARY KEY
- FOREIGN KEY
- UNIQUE
- CHECK Constraint


## Translasi ERD ke Diagram Relasional

Proses translasi mengikuti aturan pemetaan ERD ke model relasional.

### Strong Entity

Setiap strong entity diterjemahkan menjadi sebuah tabel.

- Roaster
- Origin
- Coffee
- Review

---

### One-to-Many Relationship

Hubungan **one-to-many** direpresentasikan dengan menambahkan **primary key dari sisi "one" sebagai foreign key pada sisi "many"**.

Pada desain ini:

- `Coffee.roaster_id` mengacu pada `Roaster.roaster_id`
- `Coffee.origin_id` mengacu pada `Origin.origin_id`

Dengan demikian, satu data roaster maupun origin dapat direferensikan oleh banyak data coffee tanpa terjadi duplikasi data.

---

### One-to-One Relationship

Hubungan **one-to-one** dapat direpresentasikan dengan menambahkan foreign key pada salah satu tabel.

Pada implementasi ini dipilih:

```
Review.coffee_id
```

sebagai foreign key menuju tabel Coffee.

Atribut tersebut juga diberikan constraint **UNIQUE** sehingga setiap coffee hanya dapat memiliki satu review.

---

### Integritas Data

Selain foreign key, digunakan beberapa constraint tambahan seperti:

- PRIMARY KEY
- UNIQUE
- CHECK
- ON UPDATE CASCADE
- ON DELETE RESTRICT

untuk menjaga konsistensi data pada database.


## Screenshot Program

### Data Scraping


![Scraping](<Data Scraping/screenshots/01_Scraper_Execution.jpeg>)


---

### Data Storing

### Struktur tabel

![Tables](<Data Storing/screenshots/03_Table_List.png>)

### Hasil SELECT Coffee

![Coffee](<Data Storing/screenshots/04_Select_Coffee.png>)


### Query SELECT dengan JOIN dan WHERE

![Specific](<Data Storing/screenshots/05_Select_Specific.png>)

## Bonus: Query Optimization

### 1. Menghindari `SELECT *`

#### Before
![](Data%20Storing/Screenshots/query_optimization_1_before.png)

#### After
![](Data%20Storing/Screenshots/query_optimization_1_after.png)

**Penjelasan**

Query awal menggunakan SELECT * sehingga seluruh kolom dari tabel coffee dan review diambil. Setelah dioptimasi, query hanya mengambil kolom yang diperlukan, yaitu coffee_name dan score. Hal ini mengurangi jumlah data yang diproses sehingga waktu eksekusi menjadi lebih cepat.

### 2. Menggunakan Explicit `JOIN`

#### Before
![](Data%20Storing/Screenshots/query_optimization_2_before.png)

#### After
![](Data%20Storing/Screenshots/query_optimization_2_after.png)

**Penjelasan**

Query awal menggunakan implicit join dengan kondisi relasi pada klausa WHERE. Setelah dioptimasi, query menggunakan JOIN ... ON sehingga hubungan antar tabel menjadi lebih jelas. Selain meningkatkan keterbacaan, penggunaan explicit JOIN juga mengurangi risiko terjadinya Cartesian Product akibat kondisi join yang terlewat.

### 3. Mengubah Subquery menjadi `JOIN`

#### Before
![](Data%20Storing/Screenshots/query_optimization_3_before.png)

#### After
![](Data%20Storing/Screenshots/query_optimization_3_after.png) 

**Penjelasan**

Query awal menggunakan subquery untuk memperoleh data dari tabel roaster. Setelah dioptimasi, query ditulis menggunakan JOIN sehingga hubungan antar tabel lebih jelas dan struktur query menjadi lebih sederhana. Pada PostgreSQL, kedua query menghasilkan execution plan yang hampir sama, namun penggunaan JOIN lebih mudah dipahami dan dipelihara.

## Referensi

Website

- https://www.coffeereview.com/top-50-coffees-2025/

Library

- https://requests.readthedocs.io/
- https://beautiful-soup-4.readthedocs.io/
- https://www.psycopg.org/psycopg3/docs/
- https://www.postgresql.org/docs/

Dokumentasi PostgreSQL

- https://www.postgresql.org/docs/current/


## Penggunaan AI

### Bagian yang dibantu AI

AI digunakan untuk membantu pada beberapa bagian implementasi, antara lain:

- Penyusunan kode web scraping menggunakan **requests** dan **BeautifulSoup**.
- Penyusunan kode ETL untuk membaca file JSON dan melakukan insert data ke PostgreSQL menggunakan **psycopg2**.
- Membantu proses debugging terhadap error implementasi selama proses pengembangan.


### Bagian yang dikerjakan sendiri

Beberapa bagian yang tetap dikerjakan secara mandiri meliputi:

- Pemilihan topik dataset.
- Analisis struktur data hasil scraping.
- Perancangan Entity Relationship Diagram (ERD).
- Perancangan diagram relasional.
- Penentuan normalisasi data.
- Implementasi dan pengujian database PostgreSQL.
- Penyusunan dokumentasi proyek.

### Refleksi Penggunaan AI

Penggunaan AI membantu mempercepat proses pengembangan, terutama pada tahap implementasi kode dan debugging. AI juga memberikan referensi mengenai penggunaan library serta membantu menjelaskan error yang muncul selama proses pengerjaan.

Meskipun demikian, seluruh keputusan terkait desain basis data, penentuan relasi antar entitas, normalisasi, serta validasi hasil implementasi tetap dilakukan secara mandiri. Dengan demikian, AI berperan sebagai alat bantu untuk meningkatkan efisiensi pengerjaan, bukan sebagai pengganti proses analisis dan perancangan yang dilakukan.

---

# Struktur Folder

```
Data Scraping/
├── data/
├── screenshots/
└── src/

Data Storing/
├── design/
├── export/
├── screenshots/
└── src/

Data Warehouse/
├── design/
├── export/
├── screenshots/
└── src/

README.md
```