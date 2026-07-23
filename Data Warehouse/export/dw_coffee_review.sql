--
-- PostgreSQL database dump
--

\restrict voSpaQJ7Iag8OX5bNFf6yONXIO6K4TEXeJWgZm268J4Z1BSdFEdnrHKdH7K7f8r

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dim_coffee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dim_coffee (
    coffee_id bigint NOT NULL,
    coffee_name text NOT NULL,
    roast_level text,
    agtron text,
    estimated_price text
);


ALTER TABLE public.dim_coffee OWNER TO postgres;

--
-- Name: dim_coffee_coffee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.dim_coffee ALTER COLUMN coffee_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.dim_coffee_coffee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: dim_date; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dim_date (
    date_id integer NOT NULL,
    full_date date NOT NULL,
    day smallint NOT NULL,
    month smallint NOT NULL,
    year smallint NOT NULL,
    CONSTRAINT ck_dim_date_id_matches_date CHECK ((date_id = ((((EXTRACT(year FROM full_date))::integer * 10000) + ((EXTRACT(month FROM full_date))::integer * 100)) + (EXTRACT(day FROM full_date))::integer))),
    CONSTRAINT dim_date_day_check CHECK (((day >= 1) AND (day <= 31))),
    CONSTRAINT dim_date_month_check CHECK (((month >= 1) AND (month <= 12))),
    CONSTRAINT dim_date_year_check CHECK (((year >= 1900) AND (year <= 9999)))
);


ALTER TABLE public.dim_date OWNER TO postgres;

--
-- Name: dim_origin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dim_origin (
    origin_id bigint NOT NULL,
    locality text,
    region text,
    country text NOT NULL
);


ALTER TABLE public.dim_origin OWNER TO postgres;

--
-- Name: dim_origin_origin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.dim_origin ALTER COLUMN origin_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.dim_origin_origin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: dim_roaster; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dim_roaster (
    roaster_id bigint NOT NULL,
    roaster_name text NOT NULL,
    location text NOT NULL
);


ALTER TABLE public.dim_roaster OWNER TO postgres;

--
-- Name: dim_roaster_roaster_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.dim_roaster ALTER COLUMN roaster_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.dim_roaster_roaster_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: fact_review; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fact_review (
    review_id bigint NOT NULL,
    coffee_id bigint NOT NULL,
    origin_id bigint NOT NULL,
    roaster_id bigint NOT NULL,
    date_id integer NOT NULL,
    score smallint NOT NULL,
    aroma_score smallint,
    acidity_score smallint,
    body_score smallint,
    flavor_score smallint,
    aftertaste_score smallint,
    CONSTRAINT fact_review_acidity_score_check CHECK (((acidity_score >= 0) AND (acidity_score <= 10))),
    CONSTRAINT fact_review_aftertaste_score_check CHECK (((aftertaste_score >= 0) AND (aftertaste_score <= 10))),
    CONSTRAINT fact_review_aroma_score_check CHECK (((aroma_score >= 0) AND (aroma_score <= 10))),
    CONSTRAINT fact_review_body_score_check CHECK (((body_score >= 0) AND (body_score <= 10))),
    CONSTRAINT fact_review_flavor_score_check CHECK (((flavor_score >= 0) AND (flavor_score <= 10))),
    CONSTRAINT fact_review_score_check CHECK (((score >= 0) AND (score <= 100)))
);


ALTER TABLE public.fact_review OWNER TO postgres;

--
-- Name: fact_review_review_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.fact_review ALTER COLUMN review_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.fact_review_review_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: dim_coffee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dim_coffee (coffee_id, coffee_name, roast_level, agtron, estimated_price) FROM stdin;
1	Flor Blanca Geisha Colombia	Medium-Light	62/84	$25.00/8 ounces
2	Ethiopia Mehbuba Guji	Medium-Light	64/88	$27.75/12 ounces
3	Ethiopia Washed Guji Bishala G1 25/02	Medium-Light	62/84	NT $480/8 ounces
4	Kona Pointu®	Medium	56/78	$169.95/8 ounces
5	Tanzania Natural Gesha Neel & Kavita Vahora	Medium	60/78	$50.00/12 ounces
6	Kaʻū Morning Glory	Medium-Light	62/84	$39.00/10 ounces
7	Taiwan Natural Alishan Lalauya Zou Zhu Yuan Gesha	Medium-Light	62/84	NT $1100/4 ounces
8	Ecuador La Papaya Geisha Natural	Medium	61/79	$38.00/8 ounces
9	Honduras Geisha E-F by Pedro Turcios	Medium	58/76	$30.00/150 grams
10	Ethiopia Natural Durato Bombe	Medium	58/74	$26.00/12 ounces
11	Colombia Sebastian Ramirez Washed Pink Bourbon	Medium-Light	62/84	$30.00/12 ounces
12	Rwanda Kungahara Carbonic Maceration	Medium-Light	64/86	$28.00/12 ounces
13	Guatemala El Injerto Legendary Geisha Los Pinos Washed El-05	Medium	60/80	NT $4569/8 ounces
14	Wilton Benitez Java	Medium	60/76	$26.00/8 ounces
15	Panama Esmeralda Nano Nido Geisha Washed	Medium-Light	64/88	NT $5,850/100 grams
16	Kenya Gondo Peaberry	Medium	58/80	$19.00/12 ounces
17	Panama Bambito Estate Geisha	Medium-Light	62/88	$60.00/5 ounces
18	Colombia El Origen Pink Bourbon Thermal Shock Washed	Medium-Light	66/88	$30.00/150 grams
19	Panama Hacienda La Esmeralda Nano Geisha Nido FC	Medium-Light	64/88	$170/120 grams
20	Zambia Katheshi Estate Anaerobic Natural	Medium-Light	64/88	$22.00/12 ounces
21	Kenya Nyeri AA	Medium	58/78	$25.00/12 ounces
22	Jamaica Blue Mountain Coffea Diversa Reserve Geisha + Bourbon Rey	Medium-Light	62/84	$50.00/4 ounces
23	Guatemala Finca La Bolsa Natural Pacamara	Medium	58/80	$18.00/150 grams
24	Panama Volcan Valley Thermolic Gesha	Medium-Light	63/80	$56.00/6 ounces
25	Finca San Ramon Maragogype	Medium	51/72	$20.00/12 ounces
26	Costa Rica Mirazù Catajo Geisha Blend	Medium	60/80	NT $680/200 grams
27	Peru Oscar Abad Geisha	Medium	60/78	$24.00/8 ounces
28	El Salvador Unicorn	Medium	58/78	$26.00/11 ounces
29	Colombia Wilder Lazo Pink Bourbon 60-Hour Anaerobic Honey	Medium	59/80	$24.00/115 grams
30	Moa’ula Ohana Blend	Medium	56/79	$42.00/10 ounces
31	Kenya Baragwi Guama AA Washed	Medium-Light	61/83	$21.00/12 ounces
32	Made in Heaven Espresso Blend	Medium	57/81	$17.00/8 ounces
33	Colombia El Pijao Divisa CM Java	Medium-Light	66/91	$33.00/8 ounces
34	Colombia Nestor Lasso Natural	Medium	58/80	$26.00/8 ounces
35	Colombia Hacienda La Pradera Mokka	Medium-Light	64/88	$42.00/12 ounces
36	Costa Rica Las Lajas Perla Negra	Medium	58/82	$19.95/12 ounces
37	El Salvador Loma La Gloria Unicorn Natural	Medium-Light	64/88	$29.00/10 ounces
38	Sulawesi Bolokan	Medium	58/80	$29.00/12 ounces
39	Ethiopia Guji Blosselle Geisha Washed G1	Medium-Light	64/88	NT $670/227 grams
40	Ka‘ū Geisha Champagne Natural	Medium	60/78	$200.00/4 ounces
41	Colombia Acevedo Huila Bourbon Aji Thermo-Shock	Medium	59/79	$24.95/170 grams
42	Brazil Vinhal Grape Starfruit	Medium	59/77	$21.00/12 ounces
43	Malaysia Liberica Anaerobic Natural	Medium-Light	58/93	RM85/80 grams
44	Fair-Trade Ethiopian	Medium-Light	62/80	$14.95/12 ounces
45	Colombia San Adolfo Huila	Medium-Light	65/87	$40.00/8 ounces
46	Yemen Ismaili	Medium	57/81	NT $1200/227 grams
47	Alishan Geisha Washed	Medium-Light	66/76	NT $1000/114 grams
48	St. Helena Wranghams Estate	Medium	58/74	£75.00/125 grams
49	Hawai’i Monarch Kona Pacamara Natural Maceration	Medium-Light	64/82	$40.00/6 ounces
50	Honduras Bryan Bautista	Medium	59/80	$22.00/12 ounces
\.


--
-- Data for Name: dim_date; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dim_date (date_id, full_date, day, month, year) FROM stdin;
20251001	2025-10-01	1	10	2025
20250101	2025-01-01	1	1	2025
20250201	2025-02-01	1	2	2025
20250901	2025-09-01	1	9	2025
20250501	2025-05-01	1	5	2025
20250601	2025-06-01	1	6	2025
20250801	2025-08-01	1	8	2025
20250401	2025-04-01	1	4	2025
20250301	2025-03-01	1	3	2025
20251101	2025-11-01	1	11	2025
20250701	2025-07-01	1	7	2025
\.


--
-- Data for Name: dim_origin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dim_origin (origin_id, locality, region, country) FROM stdin;
1	Las Toldas	Huila Department	Colombia
2	Haro Adam, Uraga, Guji Zone	Oromia Region	southern Ethiopia
3	Guji Zone	Oromia Region	southern Ethiopia
4	Holualoa	North Kona growing district	Hawai’i Island
5	Karatu District	Arusha Region	Tanzania
7	Alishan	Chia-Yi	Taiwan
8	Saraguro	Loja	Ecuador
9	Marcala	\N	Honduras
10	Sidamo growing region	\N	southern Ethiopia
12	Rustiro	\N	Rwanda
14	Piendamó	Cauca Department	Colombia
16	Kihoya, Mathioya District	Murang’a County	Kenya
17	Volcan Baru	Boquete growing region	Panama
11	Quindio Department	\N	Colombia
15	Cañas Verdes	Boquete	Panama
20	Northern Province	\N	Zambia
21	Nyeri growing region	\N	south-central Kenya
22	St. Andrew Parish	\N	Jamaica
13	La Libertad	Huehuetenango Department	Guatemala
24	Volcán Valley	\N	Panama
25	Antigua Guatemala	Sacatepéquez	Guatemala
26	Tarrazú	\N	Costa Rica
27	San Ignacio	Cajamarca Department	Peru
28	El Bálsamo Quetzaltepec	\N	El Salvador
6	Kaʻū growing region	Hawai’i Island	Hawai’i
31	Guama Village	Kirinyaga County	Kenya
32	\N	\N	Panama; Colombia; Guatemala; Costa Rica; Ethiopia
33	Pijao	Quindio Department	Colombia
35	Santander Department	\N	Colombia
36	Sabanilla de Alajuela growing region	\N	Costa Rica
37	El Bálsamo	Quetzaltepec growing region	El Salvador
38	Bolokan Valley, Tana Toraja Regency	Sulawesi	Indonesia
39	Guji Zone	Oromia region	southern Ethiopia
40	Ka‘ū growing region	\N	Hawai’i Island
42	Cerrado Mineiro	Minas Gerais	Brazil
43	Simpang Renggam	Johor State	Malaysia
44	\N	\N	Ethiopia
29	Huila Department	\N	Colombia
46	Bani Ismail District	Sana'a	Yemen
47	Leye Village, Alishan Township	Chia-yi County	Taiwan
48	Sandy Bay Valley	\N	St. Helena
49	Holualoa, North Kona growing district	Hawai’i Island	Hawai’i
50	Musula, Marcala	La Paz Department	Honduras
\.


--
-- Data for Name: dim_roaster; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dim_roaster (roaster_id, roaster_name, location) FROM stdin;
4	Hula Daddy Kona Coffee	Holualoa, Hawai’i
3	Kakalove Cafe	Chia-Yi, Taiwan
9	Coffee Cycle Roasting	San Diego, California
10	Magnolia Coffee	Charlotte, North Carolina
5	Heady Cup Coffee Roasters	McHenry, Illinois
2	Red Rooster Coffee Roaster	Floyd, Virginia
13	Buon Caffe	Taipei, Taiwan
1	JBC Coffee Roasters	Madison, Wisconsin
16	Speedwell Coffee	Plymouth, Massachusetts
17	Mostra Coffee	San Diego, California
18	SÖT Coffee Roaster	Osaka, Japan
20	City Boy Coffee	Long Island City, New York
21	Roadmap CoffeeWorks	Lexington, Virginia
22	Paradise Roasters	Hilo, Hawai’i Island, Hawai’i
23	Chuck's Roast	San Diego, California
24	Press Coffee	Phoenix, Arizona
25	El Gran Cafe	Antigua Guatemala, Guatemala
15	GK Coffee	Yilan, Taiwan
8	Utopian Coffee	Fort Wayne, Indiana
28	Drink Coffee Do Stuff	Truckee, Califoria
29	Big Shoulders Coffee	Chicago, Illinois
6	Big Island Coffee Roasters	Hilo, Hawai’i Island, Hawai’i
31	Bear Lake Coffee	Barronett, Wisconsin
19	Euphora Coffee	Taipei, Taiwan
33	Corvus Coffee	Denver, Colorado
34	Revel Coffee	Billings, Montana
35	SkyTop Coffee	Manlius, New York
36	Durango Coffee Company	Durango, Colorado
37	Old World Coffee Roasters	Reno, Nevada
38	Rusty Dog Coffee	Madison, Wisconsin
39	1980 CAFE	Tainan, Taiwan
40	Paradise Roasters	Hilo, Hawai’i
41	Klatch Coffee	Los Angeles, California
42	Intuition Coffee	Peoria, Illinois
43	Ghost Bird Coffee	Kuala Lumpur, Malaysia
44	Mystic Monk Coffee	Clark, Wyoming
45	Jaunt Coffee Roasters	San Diego, California
46	Lin Jen Wei’s Black Jar Coffee	Taichung, Taiwan
47	Zouzhouyuan Coffee Estate	Alishan Township, Chia-yi County, Taiwan
48	Sea Island Coffee	London, England
49	Oliver's Custom Coffee	Olympia, Washington
50	Branch Street Coffee Roasters	Youngstown, Ohio
\.


--
-- Data for Name: fact_review; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fact_review (review_id, coffee_id, origin_id, roaster_id, date_id, score, aroma_score, acidity_score, body_score, flavor_score, aftertaste_score) FROM stdin;
1	1	1	1	20250901	98	10	9	9	10	10
2	2	2	2	20251101	97	9	10	9	10	9
3	3	3	3	20251101	97	9	10	9	10	9
4	4	4	4	20251101	97	10	9	9	10	9
5	5	5	5	20251001	96	9	9	9	10	9
6	6	6	6	20250501	97	10	9	9	10	9
7	7	7	3	20250801	96	9	9	9	10	9
8	8	8	8	20250301	96	9	9	9	10	9
9	9	9	9	20251101	96	9	9	9	10	9
10	10	10	10	20251101	96	9	9	9	10	9
11	11	11	5	20250301	97	9	10	9	10	9
12	12	12	2	20250401	95	9	9	9	9	9
13	13	13	13	20251101	97	9	10	9	10	9
14	14	14	1	20251101	97	9	10	9	10	9
15	15	15	15	20251001	97	9	10	9	10	9
16	16	16	16	20250501	96	9	9	9	10	9
17	17	17	17	20251001	97	10	9	9	10	9
18	18	11	18	20251101	96	9	9	9	10	9
19	19	15	19	20250801	97	10	9	9	10	9
20	20	20	20	20250701	94	9	9	9	9	8
21	21	21	21	20250801	96	9	9	9	10	9
22	22	22	22	20251101	94	9	9	9	9	8
23	23	13	23	20250701	95	9	9	9	9	9
24	24	24	24	20251101	96	9	9	9	10	9
25	25	25	25	20251001	94	9	8	9	9	9
26	26	26	15	20251001	96	9	9	9	10	9
27	27	27	8	20251001	95	9	9	9	9	9
28	28	28	28	20251001	95	9	9	9	9	9
29	29	29	29	20251101	96	9	9	9	10	9
30	30	6	6	20251001	96	9	\N	9	9	9
31	31	31	31	20250301	95	9	9	9	9	9
32	32	32	19	20250901	96	9	\N	9	9	9
33	33	33	33	20250701	96	9	9	9	10	9
34	34	29	34	20251001	96	9	9	9	10	9
35	35	35	35	20250101	94	9	9	9	9	8
36	36	36	36	20250601	95	9	9	9	9	9
37	37	37	37	20250201	95	9	9	9	9	9
38	38	38	38	20250801	94	9	8	9	9	9
39	39	39	39	20250701	96	9	9	9	10	9
40	40	40	40	20250901	96	9	9	9	10	9
41	41	29	41	20251101	95	9	9	9	9	9
42	42	42	42	20250501	94	9	8	9	9	9
43	43	43	43	20250601	92	9	8	8	9	8
44	44	44	44	20250801	94	9	9	9	9	8
45	45	29	45	20250401	95	9	9	9	9	9
46	46	46	46	20250301	94	9	8	9	9	9
47	47	47	47	20250701	95	9	9	9	9	9
48	48	48	48	20250701	91	8	8	8	9	8
49	49	49	49	20251101	95	9	9	9	9	9
50	50	50	50	20250701	94	9	9	9	9	8
\.


--
-- Name: dim_coffee_coffee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dim_coffee_coffee_id_seq', 50, true);


--
-- Name: dim_origin_origin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dim_origin_origin_id_seq', 50, true);


--
-- Name: dim_roaster_roaster_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dim_roaster_roaster_id_seq', 50, true);


--
-- Name: fact_review_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fact_review_review_id_seq', 50, true);


--
-- Name: dim_coffee dim_coffee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_coffee
    ADD CONSTRAINT dim_coffee_pkey PRIMARY KEY (coffee_id);


--
-- Name: dim_date dim_date_full_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_date
    ADD CONSTRAINT dim_date_full_date_key UNIQUE (full_date);


--
-- Name: dim_date dim_date_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_date
    ADD CONSTRAINT dim_date_pkey PRIMARY KEY (date_id);


--
-- Name: dim_origin dim_origin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_origin
    ADD CONSTRAINT dim_origin_pkey PRIMARY KEY (origin_id);


--
-- Name: dim_roaster dim_roaster_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_roaster
    ADD CONSTRAINT dim_roaster_pkey PRIMARY KEY (roaster_id);


--
-- Name: fact_review fact_review_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_review
    ADD CONSTRAINT fact_review_pkey PRIMARY KEY (review_id);


--
-- Name: dim_coffee uq_dim_coffee; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_coffee
    ADD CONSTRAINT uq_dim_coffee UNIQUE NULLS NOT DISTINCT (coffee_name, roast_level, agtron, estimated_price);


--
-- Name: dim_origin uq_dim_origin; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_origin
    ADD CONSTRAINT uq_dim_origin UNIQUE NULLS NOT DISTINCT (locality, region, country);


--
-- Name: dim_roaster uq_dim_roaster; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_roaster
    ADD CONSTRAINT uq_dim_roaster UNIQUE (roaster_name, location);


--
-- Name: fact_review uq_fact_review_grain; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_review
    ADD CONSTRAINT uq_fact_review_grain UNIQUE (coffee_id, origin_id, roaster_id, date_id);


--
-- Name: idx_fact_review_date_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fact_review_date_id ON public.fact_review USING btree (date_id);


--
-- Name: idx_fact_review_origin_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fact_review_origin_id ON public.fact_review USING btree (origin_id);


--
-- Name: idx_fact_review_roaster_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fact_review_roaster_id ON public.fact_review USING btree (roaster_id);


--
-- Name: fact_review fk_fact_review_coffee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_review
    ADD CONSTRAINT fk_fact_review_coffee FOREIGN KEY (coffee_id) REFERENCES public.dim_coffee(coffee_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fact_review fk_fact_review_date; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_review
    ADD CONSTRAINT fk_fact_review_date FOREIGN KEY (date_id) REFERENCES public.dim_date(date_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fact_review fk_fact_review_origin; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_review
    ADD CONSTRAINT fk_fact_review_origin FOREIGN KEY (origin_id) REFERENCES public.dim_origin(origin_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fact_review fk_fact_review_roaster; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_review
    ADD CONSTRAINT fk_fact_review_roaster FOREIGN KEY (roaster_id) REFERENCES public.dim_roaster(roaster_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict voSpaQJ7Iag8OX5bNFf6yONXIO6K4TEXeJWgZm268J4Z1BSdFEdnrHKdH7K7f8r

