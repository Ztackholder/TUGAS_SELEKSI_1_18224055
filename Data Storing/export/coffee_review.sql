--
-- PostgreSQL database dump
--

\restrict 3a3bRD3rQkJ9PPeAWVEtxOO42Jnr86gEu6kzYTeHwnanuT692tLBiBantS80xKG

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
-- Name: coffee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coffee (
    coffee_id bigint NOT NULL,
    coffee_name text NOT NULL,
    roast_level text,
    agtron text,
    estimated_price text,
    roaster_id bigint NOT NULL,
    origin_id bigint NOT NULL
);


ALTER TABLE public.coffee OWNER TO postgres;

--
-- Name: coffee_coffee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.coffee ALTER COLUMN coffee_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.coffee_coffee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: origin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.origin (
    origin_id bigint NOT NULL,
    locality text,
    region text,
    country text NOT NULL
);


ALTER TABLE public.origin OWNER TO postgres;

--
-- Name: origin_origin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.origin ALTER COLUMN origin_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.origin_origin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: review; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review (
    review_id bigint NOT NULL,
    coffee_id bigint NOT NULL,
    score integer NOT NULL,
    review_date date NOT NULL,
    aroma_score integer,
    acidity_score integer,
    body_score integer,
    flavor_score integer,
    aftertaste_score integer,
    blind_assessment text NOT NULL,
    CONSTRAINT ck_review_acidity_score CHECK (((acidity_score IS NULL) OR ((acidity_score >= 0) AND (acidity_score <= 10)))),
    CONSTRAINT ck_review_aftertaste_score CHECK (((aftertaste_score IS NULL) OR ((aftertaste_score >= 0) AND (aftertaste_score <= 10)))),
    CONSTRAINT ck_review_aroma_score CHECK (((aroma_score IS NULL) OR ((aroma_score >= 0) AND (aroma_score <= 10)))),
    CONSTRAINT ck_review_body_score CHECK (((body_score IS NULL) OR ((body_score >= 0) AND (body_score <= 10)))),
    CONSTRAINT ck_review_flavor_score CHECK (((flavor_score IS NULL) OR ((flavor_score >= 0) AND (flavor_score <= 10)))),
    CONSTRAINT ck_review_score CHECK (((score >= 0) AND (score <= 100)))
);


ALTER TABLE public.review OWNER TO postgres;

--
-- Name: review_review_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.review ALTER COLUMN review_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.review_review_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: roaster; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roaster (
    roaster_id bigint NOT NULL,
    roaster_name text NOT NULL,
    roaster_location text NOT NULL
);


ALTER TABLE public.roaster OWNER TO postgres;

--
-- Name: roaster_roaster_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.roaster ALTER COLUMN roaster_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.roaster_roaster_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: coffee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coffee (coffee_id, coffee_name, roast_level, agtron, estimated_price, roaster_id, origin_id) FROM stdin;
1	Flor Blanca Geisha Colombia	Medium-Light	62/84	$25.00/8 ounces	1	1
2	Ethiopia Mehbuba Guji	Medium-Light	64/88	$27.75/12 ounces	2	2
3	Ethiopia Washed Guji Bishala G1 25/02	Medium-Light	62/84	NT $480/8 ounces	3	3
4	Kona Pointu®	Medium	56/78	$169.95/8 ounces	4	4
5	Tanzania Natural Gesha Neel & Kavita Vahora	Medium	60/78	$50.00/12 ounces	5	5
6	Kaʻū Morning Glory	Medium-Light	62/84	$39.00/10 ounces	6	6
7	Taiwan Natural Alishan Lalauya Zou Zhu Yuan Gesha	Medium-Light	62/84	NT $1100/4 ounces	3	7
8	Ecuador La Papaya Geisha Natural	Medium	61/79	$38.00/8 ounces	8	8
9	Honduras Geisha E-F by Pedro Turcios	Medium	58/76	$30.00/150 grams	9	9
10	Ethiopia Natural Durato Bombe	Medium	58/74	$26.00/12 ounces	10	10
11	Colombia Sebastian Ramirez Washed Pink Bourbon	Medium-Light	62/84	$30.00/12 ounces	5	11
12	Rwanda Kungahara Carbonic Maceration	Medium-Light	64/86	$28.00/12 ounces	2	12
13	Guatemala El Injerto Legendary Geisha Los Pinos Washed El-05	Medium	60/80	NT $4569/8 ounces	13	13
14	Wilton Benitez Java	Medium	60/76	$26.00/8 ounces	1	14
15	Panama Esmeralda Nano Nido Geisha Washed	Medium-Light	64/88	NT $5,850/100 grams	15	15
16	Kenya Gondo Peaberry	Medium	58/80	$19.00/12 ounces	16	16
17	Panama Bambito Estate Geisha	Medium-Light	62/88	$60.00/5 ounces	17	17
18	Colombia El Origen Pink Bourbon Thermal Shock Washed	Medium-Light	66/88	$30.00/150 grams	18	11
19	Panama Hacienda La Esmeralda Nano Geisha Nido FC	Medium-Light	64/88	$170/120 grams	19	15
20	Zambia Katheshi Estate Anaerobic Natural	Medium-Light	64/88	$22.00/12 ounces	20	20
21	Kenya Nyeri AA	Medium	58/78	$25.00/12 ounces	21	21
22	Jamaica Blue Mountain Coffea Diversa Reserve Geisha + Bourbon Rey	Medium-Light	62/84	$50.00/4 ounces	22	22
23	Guatemala Finca La Bolsa Natural Pacamara	Medium	58/80	$18.00/150 grams	23	13
24	Panama Volcan Valley Thermolic Gesha	Medium-Light	63/80	$56.00/6 ounces	24	24
25	Finca San Ramon Maragogype	Medium	51/72	$20.00/12 ounces	25	25
26	Costa Rica Mirazù Catajo Geisha Blend	Medium	60/80	NT $680/200 grams	15	26
27	Peru Oscar Abad Geisha	Medium	60/78	$24.00/8 ounces	8	27
28	El Salvador Unicorn	Medium	58/78	$26.00/11 ounces	28	28
29	Colombia Wilder Lazo Pink Bourbon 60-Hour Anaerobic Honey	Medium	59/80	$24.00/115 grams	29	29
30	Moa’ula Ohana Blend	Medium	56/79	$42.00/10 ounces	6	6
31	Kenya Baragwi Guama AA Washed	Medium-Light	61/83	$21.00/12 ounces	31	31
32	Made in Heaven Espresso Blend	Medium	57/81	$17.00/8 ounces	19	32
33	Colombia El Pijao Divisa CM Java	Medium-Light	66/91	$33.00/8 ounces	33	33
34	Colombia Nestor Lasso Natural	Medium	58/80	$26.00/8 ounces	34	29
35	Colombia Hacienda La Pradera Mokka	Medium-Light	64/88	$42.00/12 ounces	35	35
36	Costa Rica Las Lajas Perla Negra	Medium	58/82	$19.95/12 ounces	36	36
37	El Salvador Loma La Gloria Unicorn Natural	Medium-Light	64/88	$29.00/10 ounces	37	37
38	Sulawesi Bolokan	Medium	58/80	$29.00/12 ounces	38	38
39	Ethiopia Guji Blosselle Geisha Washed G1	Medium-Light	64/88	NT $670/227 grams	39	39
40	Ka‘ū Geisha Champagne Natural	Medium	60/78	$200.00/4 ounces	40	40
41	Colombia Acevedo Huila Bourbon Aji Thermo-Shock	Medium	59/79	$24.95/170 grams	41	29
42	Brazil Vinhal Grape Starfruit	Medium	59/77	$21.00/12 ounces	42	42
43	Malaysia Liberica Anaerobic Natural	Medium-Light	58/93	RM85/80 grams	43	43
44	Fair-Trade Ethiopian	Medium-Light	62/80	$14.95/12 ounces	44	44
45	Colombia San Adolfo Huila	Medium-Light	65/87	$40.00/8 ounces	45	29
46	Yemen Ismaili	Medium	57/81	NT $1200/227 grams	46	46
47	Alishan Geisha Washed	Medium-Light	66/76	NT $1000/114 grams	47	47
48	St. Helena Wranghams Estate	Medium	58/74	£75.00/125 grams	48	48
49	Hawai’i Monarch Kona Pacamara Natural Maceration	Medium-Light	64/82	$40.00/6 ounces	49	49
50	Honduras Bryan Bautista	Medium	59/80	$22.00/12 ounces	50	50
\.


--
-- Data for Name: origin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.origin (origin_id, locality, region, country) FROM stdin;
1	Las Toldas	Huila Department	Colombia
2	Haro Adam, Uraga, Guji Zone	Oromia Region	southern Ethiopia
3	Guji Zone	Oromia Region	southern Ethiopia
4	Holualoa	North Kona growing district	Hawai’i Island
5	Karatu District	Arusha Region	Tanzania
6	Kaʻū growing region	Hawai’i Island	Hawai’i
7	Alishan	Chia-Yi	Taiwan
8	Saraguro	Loja	Ecuador
9	Marcala	\N	Honduras
10	Sidamo growing region	\N	southern Ethiopia
11	Quindio Department	\N	Colombia
12	Rustiro	\N	Rwanda
13	La Libertad	Huehuetenango Department	Guatemala
14	Piendamó	Cauca Department	Colombia
15	Cañas Verdes	Boquete	Panama
16	Kihoya, Mathioya District	Murang’a County	Kenya
17	Volcan Baru	Boquete growing region	Panama
20	Northern Province	\N	Zambia
21	Nyeri growing region	\N	south-central Kenya
22	St. Andrew Parish	\N	Jamaica
24	Volcán Valley	\N	Panama
25	Antigua Guatemala	Sacatepéquez	Guatemala
26	Tarrazú	\N	Costa Rica
27	San Ignacio	Cajamarca Department	Peru
28	El Bálsamo Quetzaltepec	\N	El Salvador
29	Huila Department	\N	Colombia
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
46	Bani Ismail District	Sana'a	Yemen
47	Leye Village, Alishan Township	Chia-yi County	Taiwan
48	Sandy Bay Valley	\N	St. Helena
49	Holualoa, North Kona growing district	Hawai’i Island	Hawai’i
50	Musula, Marcala	La Paz Department	Honduras
\.


--
-- Data for Name: review; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.review (review_id, coffee_id, score, review_date, aroma_score, acidity_score, body_score, flavor_score, aftertaste_score, blind_assessment) FROM stdin;
1	1	98	2025-09-01	10	9	9	10	10	Elegant, radiant, complex. Narcissus, Meyer lemon, passionfruit, bergamot and wild honey in aroma and cup, with a cocoa nib throughline supporting all. Delicately bright, sparkling acidity; silky, buoyant mouthfeel. The finish is long, resonant, and multi-layered, with complex fruit, floral, and sweet spice notes.
2	2	97	2025-11-01	9	10	9	10	9	Brilliantly transparent, enticingly layered. Bergamot, wild honey, star jasmine, cacao husk, ripe apricot and lemon verbena in aroma and cup. Luminous, lively acidity; satiny body. The finish is persistent, weaving citrus and floral brightness through sweet cocoa undertones.
3	3	97	2025-11-01	9	10	9	10	9	Radiant and precise. Star jasmine, Meyer lemon, white peach, cane sugar, sandalwood in aroma and cup. Crystalline acidity — bright, transparent and finely structured; silky-smooth body. The finish is complex and lingering, balancing citrusy brightness with floral sweetness.
4	4	97	2025-11-01	10	9	9	10	9	Exquisitely structured and perfumed. Honeysuckle, lychee, sandalwood, panela, bergamot in the aroma and cup. Silky, buoyant mouthfeel; floral-saturated, cocoa-tinged finish that persists with grace and clarity.
5	5	96	2025-10-01	9	9	9	10	9	Lushly aromatic and richly layered. Passionfruit, candied violet, bergamot, cocoa, and raw honey in aroma and cup. Juicy-bright acidity; silky, nectar-like mouthfeel. The finish is long and floral-toned, with fruit and cocoa sweetness persisting deep into the long.
6	6	97	2025-05-01	10	9	9	10	9	Lushly sweet, rich-toned, balanced. Cocoa nib, gardenia, honeydew melon, sandalwood, allspice in aroma and cup. Juicy, sparkling acidity; vibrant, satiny-smooth mouthfeel. Resonant, perfumed, engaging and very long finish.
7	7	96	2025-08-01	9	9	9	10	9	Intensely floral-driven, with jasmine, wisteria, and orange blossom up front, supported by layers of Meyer lemon, honey, and cocoa nib Vibrant, balanced acidity; very silky mouthfeel. Exceptionally long finish, echoing the sweet citrus and rich florals of the cup.
8	8	96	2025-03-01	9	9	9	10	9	Richly floral-toned, sweetly citrusy. Wisteria, magrut lime leaf, cocoa butter, pink grapefruit, graphite in aroma and cup. Juicy-bright, balanced acidity; plush, syrupy mouthfeel. Long, harmonious, integrated, satisfying finish.
9	9	96	2025-11-01	9	9	9	10	9	Radiant and intricately layered. Notes of mango, pink grapefruit zest, honeysuckle, vanilla and cocoa nib in aroma and cup. Bright, winey acidity; viscous, buoyant mouthfeel. The finish is long and harmoniously sweet, carrying fruit and floral tones alongside subtle spice and chocolate.
10	10	96	2025-11-01	9	9	9	10	9	Lively, fruit-driven and opulent. Strawberry, mango, pink grapefruit zest, vanilla and cocoa powder in aroma and cup. Juicy, high-toned acidity; plush, syrupy mouthfeel. The finish is resonant and sweet, extending fruit and floral brightness over a deep chocolate undercurrent.
11	11	97	2025-03-01	9	10	9	10	9	High-toned, lushly floral. Red currant, cocoa nib, wisteria, myrrh, pomelo in aroma and cup. Sparkling, balanced, very juicy acidity; taut, satiny mouthfeel. Long, harmonious, integrated and flavor-saturated finish.
12	12	95	2025-04-01	9	9	9	9	9	Brightly sweet, richly tart, deep-toned. Bing cherry, lemongrass, pomelo, agave syrup, frankincense in aroma and cup. High-toned, juicy acidity; full, syrupy mouthfeel. Long, flavor-saturated, complex finish.
13	13	97	2025-11-01	9	10	9	10	9	Radiant and intricately layered. Pink grapefruit zest, white peach, ginger blossom, raw honey and dark chocolate in aroma and cup. Acidity is shimmering and high-toned, body silky and buoyant. The finish is long, carrying citrus, stone fruit and floral sweetness into a resonant, chocolaty long.
14	14	97	2025-11-01	9	10	9	10	9	Aromatic and dazzling. Lychee, blood orange, star jasmine, dark honey, pink peppercorn in aroma and cup. The acidity is electric — bright, tensile and deeply integrated, lush, velour-like mouthfeel. The finish is endlessly layered with stone fruit, floral sweetness and spice dissolving into a honeyed long.
15	15	97	2025-10-01	9	10	9	10	9	Dazzlingly floral, multilayered, exacting. Star jasmine, passionfruit, bergamot, cocoa nib, wild honey in aroma and cup. Bright, integrated acidity; lush, silky mouthfeel. The finish is resonant and harmonious, carrying the full promise of the cup into the long.
16	16	96	2025-05-01	9	9	9	10	9	High-toned, sweetly savory. Pluot, cocoa nib, plumeria, candycap mushroom, wild honey in aroma and cup. Sparkling acidity; plush, satiny mouthfeel. Harmonious, integrated, satiating finish.
17	17	97	2025-10-01	10	9	9	10	9	Dazzling and crystalline. Frangipani, white peach, Meyer lemon, vanilla bean, and wild honey in aroma and cup. Lively, balanced acidity; silky, lilting mouthfeel. The finish is long and harmonious, with fruit and floral sweetness lingering gracefully.
18	18	96	2025-11-01	9	9	9	10	9	Radiant, lyrically complex. Tangerine, gardenia, lychee, white tea, and sugarcane in aroma and cup. Crisp, sparkling acidity; voluptuously silky body. The finish is long, floral, fruit-layered and resonant.
19	19	97	2025-08-01	10	9	9	10	9	Lushly floral-toned, engagingly complex. Guava, star jasmine, magrut lime, cocoa nib, hyssop in aroma and cup. Sparkling, phosphoric acidity; vibrant, syrupy mouthfeel. Decadently long, satiating finish.
20	20	94	2025-07-01	9	9	9	9	8	Bright and juicy-sweet. Lilac, pomegranate, wine barrel, blueberry yogurt, dark chocolate in aroma and cup. Sweetly tart, juicy acidity; syrupy-smooth mouthfeel. Lilac and pomegranate comingle with dark chocolate in the crisp finish.
21	21	96	2025-08-01	9	9	9	10	9	Dazzlingly bright, sweet-tart, and layered. Black currant, sage, cocoa nib, magnolia, magrut lime, maple syrup in aroma and cup. Juicy, vibrant structure with crisp, sweetly tart acidity; plush, syrupy-smooth mouthfeel. The finish is resonant and long, highlighting citrus, currant, and floral tones with a grounding throughline of cocoa nib.
22	22	94	2025-11-01	9	9	9	9	8	Balanced, elegant and quietly luxurious. Notes of Meyer lemon, almond brittle, pink rose, baking chocolate and plum in aroma and cup. Bright, balanced acidity; Silky-smooth body. The finish highlights sweet citrus and floral tones.
23	23	95	2025-07-01	9	9	9	9	9	Complex, fruit-forward, deep-toned. Black cherry, cantaloupe, wild honey, blood orange, lemon balm in aroma and cup. Juicy-bright, balanced acidity; vibrant, satiny-smooth mouthfeel. Resonant, long, integrated, harmonious finish.
24	24	96	2025-11-01	9	9	9	10	9	Seductive and perfumed, with layered sweetness and definition. Pink grapefruit, mango, orange blossom, cocoa nib and sugarcane in aroma and cup. Vibrantly high-toned acidity; silky, buoyant mouthfeel. The finish is long and layered, carrying fruit, floral and cocoa notes in elegant succession.
25	25	94	2025-10-01	9	8	9	9	9	Wide-ranging and juicy. Guava, milk chocolate, cashew, clover honey, Meyer lemon zest in aroma and cup. Briskly sweet acidity; full, creamy-smooth mouthfeel. The finish is long and gently floral, supported by notes of tropical fruit.
26	26	96	2025-10-01	9	9	9	10	9	Richly aromatic, flavor-saturated. Honeysuckle, raspberry, candied kumquat, cocoa nib, vanilla bean in aroma and cup. Juicy, complex acidity; plush syrupy mouthfeel. The finish is long and multilayered, carrying berry and citrus sweetness soft cocoa nib undertones.
27	27	95	2025-10-01	9	9	9	9	9	Vibrant, fruit-saturated, and candy-sweet. Pineapple, mango, cocoa nib, jasmine candy, Meyer lemon zest in aroma and cup. Juicy, balanced acidity; plush, syrupy mouthfeel. The finish is long and resonant, carrying tropical fruit brightness and confectionery sweetness into the chocolaty long.
28	28	95	2025-10-01	9	9	9	9	9	Sweetly fruit-forward, harmoniously rich. Red currant, dark chocolate, brown sugar, tamarind, candied violet in aroma and cup. Crisp, winey acidity; syrupy-smooth body. The finish is long and layered, centering fruit and floral tones over a deep chocolate base into the long.
29	29	96	2025-11-01	9	9	9	10	9	Expressive, fruit-forward, intricately sweet. Notes of dried raspberry, lychee, tea rose, panela, cocoa nib in aroma and cup. Juicy, high-toned acidity; syrupy, very buoyant mouthfeel. The finish is long and saturated with red fruit and floral sweetness.
30	30	96	2025-10-01	9	\N	9	9	9	Evaluated as espresso. Deeply sweet, floral- and fruit-driven. Vanilla orchid, red currant, dark chocolate, brown sugar, almond butter in aroma and small cup. Richly syrupy mouthfeel; integrated, harmonious, richly chocolaty-floral finish. In cappuccino format, lush and dessert-like, with chocolate fudge, currant compote, and floral honey weaving a luxurious balance.
31	31	95	2025-03-01	9	9	9	9	9	Deep-toned, richly sweet-savory. Dark chocolate, boysenberry, almond brittle, sorrel, star jasmine in aroma and cup. Juicy-bright acidity; vibrant, syrupy mouthfeel. Harmonious, integrated, long-lasting finish.
32	32	96	2025-09-01	9	\N	9	9	9	Evaluated as espresso. Resonant and lush. In the straight shot, dark chocolate, black cherry, almond butter, sandalwood, and molasses. Syrupy-smooth mouthfeel; long, harmonious, flavor-saturated finish. In cappuccino format, fruit and chocolate bloom into confectionery harmony reminiscent of cherry truffle and spiced fudge.
33	33	96	2025-07-01	9	9	9	10	9	Tropical-toned, lavishly floral. Passionfruit, orange blossom, maple syrup, turmeric, roasted almond in aroma and cup. Sweet-tart structure with juicy, tropical acidity; plush, creamy mouthfeel. The finish highlights passionfruit and roasted almond, deepening to turmeric and orange blossom in the long.
34	34	96	2025-10-01	9	9	9	10	9	Opulent, fruit-saturated, vibrant. Passionfruit, raspberry liqueur, star jasmine, dark chocolate, and sugarcane in aroma and cup. Sparkling, sweet-tart acidity; plush, syrupy mouthfeel. The finish is long and resonant, carrying berry and floral sweetness with a grounding chocolate depth.
35	35	94	2025-01-01	9	9	9	9	8	Sweetly spice-toned, crisply chocolaty. Clove, Meyer lemon zest, magnolia, baking chocolate, agave syrup in aroma and cup. Bright, juicy acidity; plush, satiny mouthfeel. Finish consolidates to notes of baking chocolate and clove.
36	36	95	2025-06-01	9	9	9	9	9	High-toned, richly sweet-tart. Wild honey, raspberry jam, dark chocolate, lemon verbena, sandalwood in aroma and cup. Crisply sweet-tart, malic (apple-like) acidity; plush, very syrupy-smooth mouthfeel. Long, harmonious, flavor-saturated finish.
37	37	95	2025-02-01	9	9	9	9	9	Juicy-bright, complex, rich-toned. Pomelo, magnolia, cocoa nib, raspberry jam, sandalwood in aroma and cup. Sparkling acidity; full, syrupy-smooth mouthfeel. Resonant, long, satiating finish.
38	38	94	2025-08-01	9	8	9	9	9	Earth-toned, subtly floral. Plum, fresh-cut cedar, muscovado sugar, coriander seed, dark molasses in aroma and cup. Gently tart structure with balanced, winey acidity; dense, satiny mouthfeel. The finish emphasizes plum and molasses, with a faint echo of spice and floral wood.
39	39	96	2025-07-01	9	9	9	10	9	Ethereal, immersive. White tea, lychee, Meyer lemon, Asian pear, ginger blossom in aroma and cup. Crisp, yuzu-like acidity; very silky-smooth mouthfeel. Comprehensive finish that carries over all the notes of the cup into the long.
40	40	96	2025-09-01	9	9	9	10	9	Exuberant, exquisitely articulated. Notes of concord grape, lychee, star jasmine, honeycomb, and cocoa nib in aroma and cup. Structure is bright yet seamless, with a lively, sparkling acidity; plush, silky mouthfeel. The finish is long and perfumed, carrying sweet fruit and floral notes deep into the long.
41	41	95	2025-11-01	9	9	9	9	9	Floral and spice-tinged aromatics lead into flavors of starfruit, hibiscus, panela, sweet basil and cocoa nib. The acidity is juicy and refined, the body silky and cohesive. Long, resonant finish with layered fruit and gentle spice.
42	42	94	2025-05-01	9	8	9	9	9	Gently fruit-toned, crisply chocolaty. Kiwi, lemon verbena, cocoa nib, nougat, myrrh in aroma and cup. Gently bright acidity; very full, satiny-smooth mouthfeel. Harmonious, resonant, rich-toned finish.
43	43	92	2025-06-01	9	8	8	9	8	An intense, densely complex, rather hectic coffee. Spice/herb medley (cardamom, lavender, patchouli, more), cedar, grape candy, hazelnut in aroma and cup. Profoundly sweet-savory in structure, without a hint of brightness or lift but still generous in range of sensation. Satiny in mouthfeel; in the finish flavor consolidates to a dense, rich sweetness.
44	44	94	2025-08-01	9	9	9	9	8	Delicately floral and fruit-toned. Jasmine, lemon curd, ripe blueberry, cocoa nib, sandalwood in aroma and cup. Juicy, lively structure with bright but balanced acidity; plush, satiny mouthfeel. The finish is long and layered, carrying citrus and berry sweetness over a gentle cocoa base.
45	45	95	2025-04-01	9	9	9	9	9	Delicate, tropical, cocoa-toned. Cocoa nib, passion fruit, bergamot, amber, wild honey in aroma and cup. Juicy, malic acidity; smooth, very satiny mouthfeel. The finish fulfills the promise of the cup with rich aromatics that linger.
46	46	94	2025-03-01	9	8	9	9	9	Delicately fruity, deeply sweet. Dried mulberry, almond nougat, freesia, amber, pink grapefruit in aroma and cup. Brisk, winy acidity; full, creamy-smooth mouthfeel. Exceptionally long, fruit-forward, richly floral finish.
47	47	95	2025-07-01	9	9	9	9	9	High-toned, richly sweet. Bergamot, apricot, cocoa nib, star jasmine, pomelo in aroma and cup. Gently bright, floral acidity; lithe, silky, very viscous mouthfeel. Long, lingering, integrated and harmonious finish.
48	48	91	2025-07-01	8	8	8	9	8	Citrus-toned, delicately floral. Lemon zest, elderflower, caramel, white pepper, walnut in aroma and cup. Sweetly bright structure with soft, balanced acidity; medium, silky-smooth mouthfeel. Finish leads with notes of lemon zest and walnut.
49	49	95	2025-11-01	9	9	9	9	9	Expressive and fruit-driven. Pink grapefruit, lychee, white peach and magnolia, anchored by cocoa nib and sugarcane in aroma and cup. Acidity is briskly sweet-tart; mouthfeel is plush and silky. The aftertaste is complex and layered, carrying sweet florals and crisp cocoa into the resonant long.
50	50	94	2025-07-01	9	9	9	9	8	Quietly confident, deep-toned. Wildflower honey, dried apricot, tangerine zest, almond butter, cedar in aroma and cup. Balanced, gently bright acidity; round, viscous mouthfeel. Finish consolidates to notes of wildflower honey and almond butter.
\.


--
-- Data for Name: roaster; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roaster (roaster_id, roaster_name, roaster_location) FROM stdin;
1	JBC Coffee Roasters	Madison, Wisconsin
2	Red Rooster Coffee Roaster	Floyd, Virginia
3	Kakalove Cafe	Chia-Yi, Taiwan
4	Hula Daddy Kona Coffee	Holualoa, Hawai’i
5	Heady Cup Coffee Roasters	McHenry, Illinois
6	Big Island Coffee Roasters	Hilo, Hawai’i Island, Hawai’i
8	Utopian Coffee	Fort Wayne, Indiana
9	Coffee Cycle Roasting	San Diego, California
10	Magnolia Coffee	Charlotte, North Carolina
13	Buon Caffe	Taipei, Taiwan
15	GK Coffee	Yilan, Taiwan
16	Speedwell Coffee	Plymouth, Massachusetts
17	Mostra Coffee	San Diego, California
18	SÖT Coffee Roaster	Osaka, Japan
19	Euphora Coffee	Taipei, Taiwan
20	City Boy Coffee	Long Island City, New York
21	Roadmap CoffeeWorks	Lexington, Virginia
22	Paradise Roasters	Hilo, Hawai’i Island, Hawai’i
23	Chuck's Roast	San Diego, California
24	Press Coffee	Phoenix, Arizona
25	El Gran Cafe	Antigua Guatemala, Guatemala
28	Drink Coffee Do Stuff	Truckee, Califoria
29	Big Shoulders Coffee	Chicago, Illinois
31	Bear Lake Coffee	Barronett, Wisconsin
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
-- Name: coffee_coffee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coffee_coffee_id_seq', 50, true);


--
-- Name: origin_origin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.origin_origin_id_seq', 50, true);


--
-- Name: review_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.review_review_id_seq', 50, true);


--
-- Name: roaster_roaster_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roaster_roaster_id_seq', 50, true);


--
-- Name: coffee pk_coffee; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coffee
    ADD CONSTRAINT pk_coffee PRIMARY KEY (coffee_id);


--
-- Name: origin pk_origin; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.origin
    ADD CONSTRAINT pk_origin PRIMARY KEY (origin_id);


--
-- Name: review pk_review; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT pk_review PRIMARY KEY (review_id);


--
-- Name: roaster pk_roaster; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roaster
    ADD CONSTRAINT pk_roaster PRIMARY KEY (roaster_id);


--
-- Name: coffee uq_coffee_identity; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coffee
    ADD CONSTRAINT uq_coffee_identity UNIQUE (coffee_name, roaster_id, origin_id);


--
-- Name: origin uq_origin_geography; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.origin
    ADD CONSTRAINT uq_origin_geography UNIQUE NULLS NOT DISTINCT (locality, region, country);


--
-- Name: review uq_review_coffee; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT uq_review_coffee UNIQUE (coffee_id);


--
-- Name: roaster uq_roaster_name_location; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roaster
    ADD CONSTRAINT uq_roaster_name_location UNIQUE (roaster_name, roaster_location);


--
-- Name: idx_coffee_origin_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_coffee_origin_id ON public.coffee USING btree (origin_id);


--
-- Name: idx_coffee_roaster_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_coffee_roaster_id ON public.coffee USING btree (roaster_id);


--
-- Name: coffee fk_coffee_origin; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coffee
    ADD CONSTRAINT fk_coffee_origin FOREIGN KEY (origin_id) REFERENCES public.origin(origin_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: coffee fk_coffee_roaster; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coffee
    ADD CONSTRAINT fk_coffee_roaster FOREIGN KEY (roaster_id) REFERENCES public.roaster(roaster_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: review fk_review_coffee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT fk_review_coffee FOREIGN KEY (coffee_id) REFERENCES public.coffee(coffee_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict 3a3bRD3rQkJ9PPeAWVEtxOO42Jnr86gEu6kzYTeHwnanuT692tLBiBantS80xKG

