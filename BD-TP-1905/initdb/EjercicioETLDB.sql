--
-- PostgreSQL database dump
--

\restrict m5MwYWMmXvrdiERtCFGQZ3ihd41Es10PFzwFMb5B243mceMAYNcUzLR2oJgxMEG

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-05-17 22:22:10

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
-- TOC entry 222 (class 1259 OID 24710)
-- Name: escuelas_recursos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.escuelas_recursos (
    cueanexo character varying(20) NOT NULL,
    id_provincia integer NOT NULL,
    departamento character varying(150),
    sector character varying(50),
    ambito character varying(50),
    tiene_internet boolean,
    tiene_energia_electrica boolean,
    tiene_agua_potable boolean
);


ALTER TABLE public.escuelas_recursos OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24685)
-- Name: provincias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.provincias (
    id_provincia integer NOT NULL,
    nombre character varying(100) NOT NULL
);


ALTER TABLE public.provincias OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24695)
-- Name: vab_economico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vab_economico (
    id_registro integer NOT NULL,
    id_provincia integer NOT NULL,
    anio integer NOT NULL,
    sector_cadena character varying(150),
    valor_vab numeric(18,2) NOT NULL
);


ALTER TABLE public.vab_economico OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24694)
-- Name: vab_economico_id_registro_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vab_economico_id_registro_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vab_economico_id_registro_seq OWNER TO postgres;

--
-- TOC entry 4930 (class 0 OID 0)
-- Dependencies: 220
-- Name: vab_economico_id_registro_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vab_economico_id_registro_seq OWNED BY public.vab_economico.id_registro;


--
-- TOC entry 4763 (class 2604 OID 24698)
-- Name: vab_economico id_registro; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vab_economico ALTER COLUMN id_registro SET DEFAULT nextval('public.vab_economico_id_registro_seq'::regclass);


--
-- TOC entry 4924 (class 0 OID 24710)
-- Dependencies: 222
-- Data for Name: escuelas_recursos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.escuelas_recursos (cueanexo, id_provincia, departamento, sector, ambito, tiene_internet, tiene_energia_electrica, tiene_agua_potable) FROM stdin;
\.


--
-- TOC entry 4921 (class 0 OID 24685)
-- Dependencies: 219
-- Data for Name: provincias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.provincias (id_provincia, nombre) FROM stdin;
\.


--
-- TOC entry 4923 (class 0 OID 24695)
-- Dependencies: 221
-- Data for Name: vab_economico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vab_economico (id_registro, id_provincia, anio, sector_cadena, valor_vab) FROM stdin;
\.


--
-- TOC entry 4931 (class 0 OID 0)
-- Dependencies: 220
-- Name: vab_economico_id_registro_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vab_economico_id_registro_seq', 1, false);


--
-- TOC entry 4771 (class 2606 OID 24716)
-- Name: escuelas_recursos escuelas_recursos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escuelas_recursos
    ADD CONSTRAINT escuelas_recursos_pkey PRIMARY KEY (cueanexo);


--
-- TOC entry 4765 (class 2606 OID 24693)
-- Name: provincias provincias_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provincias
    ADD CONSTRAINT provincias_nombre_key UNIQUE (nombre);


--
-- TOC entry 4767 (class 2606 OID 24691)
-- Name: provincias provincias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provincias
    ADD CONSTRAINT provincias_pkey PRIMARY KEY (id_provincia);


--
-- TOC entry 4769 (class 2606 OID 24704)
-- Name: vab_economico vab_economico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vab_economico
    ADD CONSTRAINT vab_economico_pkey PRIMARY KEY (id_registro);


--
-- TOC entry 4773 (class 2606 OID 24717)
-- Name: escuelas_recursos fk_escuela_provincia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escuelas_recursos
    ADD CONSTRAINT fk_escuela_provincia FOREIGN KEY (id_provincia) REFERENCES public.provincias(id_provincia);


--
-- TOC entry 4772 (class 2606 OID 24705)
-- Name: vab_economico fk_vab_provincia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vab_economico
    ADD CONSTRAINT fk_vab_provincia FOREIGN KEY (id_provincia) REFERENCES public.provincias(id_provincia);


-- Completed on 2026-05-17 22:22:10

--
-- PostgreSQL database dump complete
--

\unrestrict m5MwYWMmXvrdiERtCFGQZ3ihd41Es10PFzwFMb5B243mceMAYNcUzLR2oJgxMEG

