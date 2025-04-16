--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.8

-- Started on 2025-04-16 21:35:50 UTC


ALTER DATABASE "zt-ehealth" OWNER TO postgres;

\encoding SQL_ASCII
\connect -reuse-previous=on "dbname='zt-ehealth'"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 24576)
-- Name: zt-ehealth; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "zt-ehealth";


ALTER SCHEMA "zt-ehealth" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 24577)
-- Name: Acesso; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."Acesso" (
    id integer NOT NULL,
    "idUsuario" integer,
    "idToken" integer,
    "idPermissao" integer,
    "idSubRecurso" integer NOT NULL,
    "idSensibilidadeSubRecurso" integer NOT NULL,
    "idDispositivo" integer,
    latitude character varying(16) NOT NULL,
    longitude character varying(16) NOT NULL,
    data timestamp with time zone NOT NULL,
    resultado character varying(16) NOT NULL,
    rede character varying(16) NOT NULL,
    confianca real NOT NULL,
    "idDispositivoTMP" integer,
    reautenticacao boolean DEFAULT false
);


ALTER TABLE "zt-ehealth"."Acesso" OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24581)
-- Name: Acesso_id_seq; Type: SEQUENCE; Schema: zt-ehealth; Owner: postgres
--

CREATE SEQUENCE "zt-ehealth"."Acesso_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "zt-ehealth"."Acesso_id_seq" OWNER TO postgres;

--
-- TOC entry 3549 (class 0 OID 0)
-- Dependencies: 217
-- Name: Acesso_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Acesso_id_seq" OWNED BY "zt-ehealth"."Acesso".id;


--
-- TOC entry 218 (class 1259 OID 24582)
-- Name: CaracteristicaDispositivo; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."CaracteristicaDispositivo" (
    id integer NOT NULL,
    "deviceFingerPrint" character varying(256) NOT NULL,
    "sistemaOperacional" character varying(50) NOT NULL,
    "versaoSO" character varying NOT NULL,
    data timestamp with time zone NOT NULL,
    status character varying(10) NOT NULL,
    "idDispositivo" integer NOT NULL
);


ALTER TABLE "zt-ehealth"."CaracteristicaDispositivo" OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24587)
-- Name: CaracteristicaDispositivo_id_seq; Type: SEQUENCE; Schema: zt-ehealth; Owner: postgres
--

CREATE SEQUENCE "zt-ehealth"."CaracteristicaDispositivo_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "zt-ehealth"."CaracteristicaDispositivo_id_seq" OWNER TO postgres;

--
-- TOC entry 3550 (class 0 OID 0)
-- Dependencies: 219
-- Name: CaracteristicaDispositivo_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."CaracteristicaDispositivo_id_seq" OWNED BY "zt-ehealth"."CaracteristicaDispositivo".id;


--
-- TOC entry 220 (class 1259 OID 24588)
-- Name: Cliente; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."Cliente" (
    id integer NOT NULL,
    "idUsuario" integer NOT NULL
);


ALTER TABLE "zt-ehealth"."Cliente" OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24591)
-- Name: Dispositivo; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."Dispositivo" (
    id integer NOT NULL,
    "MAC" character varying(18) NOT NULL
);


ALTER TABLE "zt-ehealth"."Dispositivo" OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24594)
-- Name: DispositivoTMP; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."DispositivoTMP" (
    id integer NOT NULL,
    "MAC" character varying(18) NOT NULL,
    "deviceFingerPrint" character varying(256) NOT NULL,
    "SistemaOperacional" character varying(50) NOT NULL,
    "versaoSO" character varying NOT NULL,
    data time with time zone NOT NULL
);


ALTER TABLE "zt-ehealth"."DispositivoTMP" OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24599)
-- Name: DispositivoTMP_id_seq; Type: SEQUENCE; Schema: zt-ehealth; Owner: postgres
--

CREATE SEQUENCE "zt-ehealth"."DispositivoTMP_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "zt-ehealth"."DispositivoTMP_id_seq" OWNER TO postgres;

--
-- TOC entry 3551 (class 0 OID 0)
-- Dependencies: 223
-- Name: DispositivoTMP_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."DispositivoTMP_id_seq" OWNED BY "zt-ehealth"."DispositivoTMP".id;


--
-- TOC entry 224 (class 1259 OID 24600)
-- Name: Dispositivo_id_seq; Type: SEQUENCE; Schema: zt-ehealth; Owner: postgres
--

CREATE SEQUENCE "zt-ehealth"."Dispositivo_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "zt-ehealth"."Dispositivo_id_seq" OWNER TO postgres;

--
-- TOC entry 3552 (class 0 OID 0)
-- Dependencies: 224
-- Name: Dispositivo_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Dispositivo_id_seq" OWNED BY "zt-ehealth"."Dispositivo".id;


--
-- TOC entry 225 (class 1259 OID 24601)
-- Name: Paciente_id_seq; Type: SEQUENCE; Schema: zt-ehealth; Owner: postgres
--

CREATE SEQUENCE "zt-ehealth"."Paciente_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "zt-ehealth"."Paciente_id_seq" OWNER TO postgres;

--
-- TOC entry 3553 (class 0 OID 0)
-- Dependencies: 225
-- Name: Paciente_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Paciente_id_seq" OWNED BY "zt-ehealth"."Cliente".id;


--
-- TOC entry 226 (class 1259 OID 24602)
-- Name: Permissao; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."Permissao" (
    id integer NOT NULL,
    "idUsuario" integer,
    "idSubRecurso" integer NOT NULL,
    "tipoAcao" character varying(13) NOT NULL,
    "dataCriacao" timestamp with time zone NOT NULL,
    status character varying(10) NOT NULL,
    "dataExclusao" timestamp with time zone,
    "idDispositivo" integer
);


ALTER TABLE "zt-ehealth"."Permissao" OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 24605)
-- Name: Permissao_id_seq; Type: SEQUENCE; Schema: zt-ehealth; Owner: postgres
--

CREATE SEQUENCE "zt-ehealth"."Permissao_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "zt-ehealth"."Permissao_id_seq" OWNER TO postgres;

--
-- TOC entry 3554 (class 0 OID 0)
-- Dependencies: 227
-- Name: Permissao_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Permissao_id_seq" OWNED BY "zt-ehealth"."Permissao".id;


--
-- TOC entry 228 (class 1259 OID 24606)
-- Name: Profissional; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."Profissional" (
    id integer NOT NULL,
    cargo character varying(50) NOT NULL,
    "diasTrabalho" character varying(50) NOT NULL,
    "idUsuario" integer NOT NULL,
    "horarioTrabalhoInicio" time without time zone NOT NULL,
    "horarioTrabalhoFinal" time without time zone NOT NULL
);


ALTER TABLE "zt-ehealth"."Profissional" OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 24609)
-- Name: Profissional_id_seq; Type: SEQUENCE; Schema: zt-ehealth; Owner: postgres
--

CREATE SEQUENCE "zt-ehealth"."Profissional_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "zt-ehealth"."Profissional_id_seq" OWNER TO postgres;

--
-- TOC entry 3555 (class 0 OID 0)
-- Dependencies: 229
-- Name: Profissional_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Profissional_id_seq" OWNED BY "zt-ehealth"."Profissional".id;


--
-- TOC entry 230 (class 1259 OID 24610)
-- Name: Recurso; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."Recurso" (
    id integer NOT NULL,
    nome character varying(150) NOT NULL,
    "ipAddress" character varying(16) NOT NULL,
    porta integer NOT NULL
);


ALTER TABLE "zt-ehealth"."Recurso" OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 24613)
-- Name: Recurso_id_seq; Type: SEQUENCE; Schema: zt-ehealth; Owner: postgres
--

CREATE SEQUENCE "zt-ehealth"."Recurso_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "zt-ehealth"."Recurso_id_seq" OWNER TO postgres;

--
-- TOC entry 3556 (class 0 OID 0)
-- Dependencies: 231
-- Name: Recurso_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Recurso_id_seq" OWNED BY "zt-ehealth"."Recurso".id;


--
-- TOC entry 232 (class 1259 OID 24614)
-- Name: RegLogin; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."RegLogin" (
    id integer NOT NULL,
    "idUsuario" integer,
    data timestamp with time zone NOT NULL,
    resultado character varying(10),
    "idDispositivo" integer,
    completado boolean DEFAULT false NOT NULL,
    "codigoAutorizacao" character varying(256) NOT NULL,
    "scorePPG" real,
    "scoreECG" real
);


ALTER TABLE "zt-ehealth"."RegLogin" OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 24618)
-- Name: RegLogin_id_seq; Type: SEQUENCE; Schema: zt-ehealth; Owner: postgres
--

CREATE SEQUENCE "zt-ehealth"."RegLogin_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "zt-ehealth"."RegLogin_id_seq" OWNER TO postgres;

--
-- TOC entry 3557 (class 0 OID 0)
-- Dependencies: 233
-- Name: RegLogin_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."RegLogin_id_seq" OWNED BY "zt-ehealth"."RegLogin".id;


--
-- TOC entry 234 (class 1259 OID 24619)
-- Name: SensibilidadeSubRecurso; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."SensibilidadeSubRecurso" (
    id integer NOT NULL,
    "idSubRecurso" integer NOT NULL,
    "tipoAcao" character varying(12) NOT NULL,
    sensibilidade real NOT NULL
);


ALTER TABLE "zt-ehealth"."SensibilidadeSubRecurso" OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 24622)
-- Name: SensibilidadeSubRecurso_id_seq; Type: SEQUENCE; Schema: zt-ehealth; Owner: postgres
--

CREATE SEQUENCE "zt-ehealth"."SensibilidadeSubRecurso_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "zt-ehealth"."SensibilidadeSubRecurso_id_seq" OWNER TO postgres;

--
-- TOC entry 3558 (class 0 OID 0)
-- Dependencies: 235
-- Name: SensibilidadeSubRecurso_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."SensibilidadeSubRecurso_id_seq" OWNED BY "zt-ehealth"."SensibilidadeSubRecurso".id;


--
-- TOC entry 236 (class 1259 OID 24623)
-- Name: SubRecurso; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."SubRecurso" (
    id integer NOT NULL,
    "idRecurso" integer NOT NULL,
    nome character varying(150) NOT NULL
);


ALTER TABLE "zt-ehealth"."SubRecurso" OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 24626)
-- Name: SubRecurso_id_seq; Type: SEQUENCE; Schema: zt-ehealth; Owner: postgres
--

CREATE SEQUENCE "zt-ehealth"."SubRecurso_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "zt-ehealth"."SubRecurso_id_seq" OWNER TO postgres;

--
-- TOC entry 3559 (class 0 OID 0)
-- Dependencies: 237
-- Name: SubRecurso_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."SubRecurso_id_seq" OWNED BY "zt-ehealth"."SubRecurso".id;


--
-- TOC entry 238 (class 1259 OID 24627)
-- Name: Token; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."Token" (
    id integer NOT NULL,
    "idUsuario" integer,
    "idRegLogin" integer NOT NULL,
    hash character varying(256) NOT NULL,
    validade timestamp with time zone NOT NULL,
    status character varying(10) NOT NULL,
    "idDispositivo" integer,
    tipo character varying(15)
);


ALTER TABLE "zt-ehealth"."Token" OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 24630)
-- Name: Token_id_seq; Type: SEQUENCE; Schema: zt-ehealth; Owner: postgres
--

CREATE SEQUENCE "zt-ehealth"."Token_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "zt-ehealth"."Token_id_seq" OWNER TO postgres;

--
-- TOC entry 3560 (class 0 OID 0)
-- Dependencies: 239
-- Name: Token_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Token_id_seq" OWNED BY "zt-ehealth"."Token".id;


--
-- TOC entry 240 (class 1259 OID 24631)
-- Name: Usuario; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."Usuario" (
    id integer NOT NULL,
    nome character varying(150) NOT NULL,
    tipo character varying(15) NOT NULL,
    cpf character varying(15) NOT NULL,
    "codigoCriacao" character varying(256) NOT NULL,
    ativado boolean DEFAULT false NOT NULL,
    "dataCriacao" timestamp with time zone NOT NULL
);


ALTER TABLE "zt-ehealth"."Usuario" OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 24635)
-- Name: Usuario_id_seq; Type: SEQUENCE; Schema: zt-ehealth; Owner: postgres
--

CREATE SEQUENCE "zt-ehealth"."Usuario_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "zt-ehealth"."Usuario_id_seq" OWNER TO postgres;

--
-- TOC entry 3561 (class 0 OID 0)
-- Dependencies: 241
-- Name: Usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Usuario_id_seq" OWNED BY "zt-ehealth"."Usuario".id;


--
-- TOC entry 3307 (class 2604 OID 24636)
-- Name: Acesso id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Acesso_id_seq"'::regclass);


--
-- TOC entry 3309 (class 2604 OID 24637)
-- Name: CaracteristicaDispositivo id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."CaracteristicaDispositivo" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."CaracteristicaDispositivo_id_seq"'::regclass);


--
-- TOC entry 3310 (class 2604 OID 24638)
-- Name: Cliente id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Cliente" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Paciente_id_seq"'::regclass);


--
-- TOC entry 3311 (class 2604 OID 24639)
-- Name: Dispositivo id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Dispositivo" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Dispositivo_id_seq"'::regclass);


--
-- TOC entry 3312 (class 2604 OID 24640)
-- Name: DispositivoTMP id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."DispositivoTMP" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."DispositivoTMP_id_seq"'::regclass);


--
-- TOC entry 3313 (class 2604 OID 24641)
-- Name: Permissao id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Permissao" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Permissao_id_seq"'::regclass);


--
-- TOC entry 3314 (class 2604 OID 24642)
-- Name: Profissional id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Profissional" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Profissional_id_seq"'::regclass);


--
-- TOC entry 3315 (class 2604 OID 24643)
-- Name: Recurso id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Recurso" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Recurso_id_seq"'::regclass);


--
-- TOC entry 3316 (class 2604 OID 24644)
-- Name: RegLogin id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."RegLogin" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."RegLogin_id_seq"'::regclass);


--
-- TOC entry 3318 (class 2604 OID 24645)
-- Name: SensibilidadeSubRecurso id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."SensibilidadeSubRecurso" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."SensibilidadeSubRecurso_id_seq"'::regclass);


--
-- TOC entry 3319 (class 2604 OID 24646)
-- Name: SubRecurso id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."SubRecurso" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."SubRecurso_id_seq"'::regclass);


--
-- TOC entry 3320 (class 2604 OID 24647)
-- Name: Token id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Token" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Token_id_seq"'::regclass);


--
-- TOC entry 3321 (class 2604 OID 24648)
-- Name: Usuario id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Usuario" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Usuario_id_seq"'::regclass);


--
-- TOC entry 3517 (class 0 OID 24577)
-- Dependencies: 216
-- Data for Name: Acesso; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--



--
-- TOC entry 3519 (class 0 OID 24582)
-- Dependencies: 218
-- Data for Name: CaracteristicaDispositivo; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--



--
-- TOC entry 3521 (class 0 OID 24588)
-- Dependencies: 220
-- Data for Name: Cliente; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--



--
-- TOC entry 3522 (class 0 OID 24591)
-- Dependencies: 221
-- Data for Name: Dispositivo; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--



--
-- TOC entry 3523 (class 0 OID 24594)
-- Dependencies: 222
-- Data for Name: DispositivoTMP; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--



--
-- TOC entry 3527 (class 0 OID 24602)
-- Dependencies: 226
-- Data for Name: Permissao; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--



--
-- TOC entry 3529 (class 0 OID 24606)
-- Dependencies: 228
-- Data for Name: Profissional; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--



--
-- TOC entry 3531 (class 0 OID 24610)
-- Dependencies: 230
-- Data for Name: Recurso; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

INSERT INTO "zt-ehealth"."Recurso" VALUES (3, 'Monitoramento Remoto do Paciente', '169.254.0.12', 7003);
INSERT INTO "zt-ehealth"."Recurso" VALUES (4, 'Portal do Paciente', '169.254.0.13', 7004);
INSERT INTO "zt-ehealth"."Recurso" VALUES (5, 'Telemedicina', '169.254.0.14', 7005);
INSERT INTO "zt-ehealth"."Recurso" VALUES (1, 'Registro Eletronico de Saude', '169.254.0.10', 7001);
INSERT INTO "zt-ehealth"."Recurso" VALUES (2, 'Sistema de Informacao Hospitalar', '169.254.0.11', 7002);


--
-- TOC entry 3533 (class 0 OID 24614)
-- Dependencies: 232
-- Data for Name: RegLogin; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--



--
-- TOC entry 3535 (class 0 OID 24619)
-- Dependencies: 234
-- Data for Name: SensibilidadeSubRecurso; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (1, 1, 'Leitura', 45);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (2, 1, 'Escrita', 48);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (5, 2, 'Leitura', 53);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (6, 2, 'Escrita', 80);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (9, 3, 'Leitura', 38);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (10, 3, 'Escrita', 60);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (13, 4, 'Leitura', 63);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (14, 4, 'Escrita', 95);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (17, 5, 'Leitura', 43);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (18, 5, 'Escrita', 68);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (21, 6, 'Leitura', 58);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (22, 6, 'Escrita', 95);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (25, 7, 'Leitura', 55);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (26, 7, 'Escrita', 95);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (29, 8, 'Leitura', 35);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (30, 8, 'Escrita', 60);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (33, 9, 'Leitura', 45);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (34, 9, 'Escrita', 48);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (38, 10, 'Escrita', 53);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (41, 11, 'Leitura', 48);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (42, 11, 'Escrita', 55);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (45, 12, 'Leitura', 48);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (46, 12, 'Escrita', 50);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (49, 13, 'Leitura', 33);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (53, 14, 'Leitura', 33);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (54, 14, 'Escrita', 85);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (57, 15, 'Leitura', 48);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (58, 15, 'Escrita', 60);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (61, 16, 'Leitura', 23);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (62, 16, 'Escrita', 38);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (65, 17, 'Leitura', 43);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (66, 17, 'Escrita', 65);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (69, 18, 'Leitura', 65);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (70, 19, 'Leitura', 45);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (71, 19, 'Escrita', 48);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (74, 20, 'Leitura', 53);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (75, 20, 'Escrita', 80);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (78, 21, 'Leitura', 23);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (79, 22, 'Leitura', 38);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (80, 22, 'Escrita', 73);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (83, 23, 'Leitura', 55);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (84, 23, 'Escrita', 95);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (87, 24, 'Leitura', 45);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (88, 24, 'Escrita', 48);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (91, 25, 'Leitura', 53);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (92, 25, 'Escrita', 73);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (94, 26, 'Acesso', 90);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (50, 13, 'Escrita', 53);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (3, 1, 'Modificacao', 68);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (4, 1, 'Exclusao', 75);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (7, 2, 'Modificacao', 88);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (8, 2, 'Exclusao', 88);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (11, 3, 'Modificacao', 65);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (12, 3, 'Exclusao', 65);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (15, 4, 'Modificacao', 98);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (16, 4, 'Exclusao', 98);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (19, 5, 'Modificacao', 73);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (20, 5, 'Exclusao', 73);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (23, 6, 'Modificacao', 98);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (24, 6, 'Exclusao', 93);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (27, 7, 'Modificacao', 95);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (28, 7, 'Exclusao', 95);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (31, 8, 'Modificacao', 70);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (32, 8, 'Exclusao', 73);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (35, 9, 'Modificacao', 68);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (36, 9, 'Exclusao', 75);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (39, 10, 'Modificacao', 63);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (40, 10, 'Exclusao', 60);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (43, 11, 'Modificacao', 70);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (44, 11, 'Exclusao', 70);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (47, 12, 'Modificacao', 73);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (48, 12, 'Exclusao', 73);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (51, 13, 'Modificacao', 55);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (52, 13, 'Exclusao', 55);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (55, 14, 'Modificacao', 85);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (56, 14, 'Exclusao', 85);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (59, 15, 'Modificacao', 60);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (60, 15, 'Exclusao', 60);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (63, 16, 'Modificacao', 38);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (64, 16, 'Exclusao', 38);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (67, 17, 'Modificacao', 65);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (68, 17, 'Exclusao', 65);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (72, 19, 'Modificacao', 68);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (73, 19, 'Exclusao', 75);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (76, 20, 'Modificacao', 88);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (77, 20, 'Exclusao', 88);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (81, 22, 'Modificacao', 78);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (82, 22, 'Exclusao', 78);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (85, 23, 'Modificacao', 95);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (86, 23, 'Exclusao', 95);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (89, 24, 'Modificacao', 68);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (90, 24, 'Exclusao', 75);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (93, 25, 'Exclusao', 65);
INSERT INTO "zt-ehealth"."SensibilidadeSubRecurso" VALUES (37, 10, 'Leitura', 18);


--
-- TOC entry 3537 (class 0 OID 24623)
-- Dependencies: 236
-- Data for Name: SubRecurso; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

INSERT INTO "zt-ehealth"."SubRecurso" VALUES (6, 1, 'Resultados Laboratoriais');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (10, 2, 'Registros Cadastrais da Enfermagem');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (12, 2, 'Dados Financeiros');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (13, 2, 'Dados de Recursos Humanos');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (14, 2, 'Registro de Estoque');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (15, 3, 'Registro de Sinais Vitais');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (26, 5, 'Videoconsulta');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (1, 1, 'Informacoes Cadastrais do Cliente');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (2, 1, 'Notas Clinicas');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (3, 1, 'Dados de Imunizacao');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (4, 1, 'Historico Medico');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (5, 1, 'Registro de Alergias');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (7, 1, 'Informacoes de Consentimento');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (8, 1, 'Prescricoes Medicas');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (9, 2, 'Informacoes Cadastrais do Cliente');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (11, 2, 'Registro de Internacao/Alta');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (16, 3, 'Dados de Monitoramento de Atividades Fisicas');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (17, 3, 'Dados de Geolocalizacao');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (18, 3, 'Dados de Analise de Tendencia');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (19, 4, 'Informacoes Cadastrais do Cliente');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (20, 4, 'Notas Clinicas');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (21, 4, 'Informacoes do Plano de Saude');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (22, 4, 'Informacoes de Pagamento');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (23, 4, 'Informacoes de Consentimento');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (24, 5, 'Informacoes Cadastrais do Cliente');
INSERT INTO "zt-ehealth"."SubRecurso" VALUES (25, 5, 'Gravacoes de Consultas');


--
-- TOC entry 3539 (class 0 OID 24627)
-- Dependencies: 238
-- Data for Name: Token; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--



--
-- TOC entry 3541 (class 0 OID 24631)
-- Dependencies: 240
-- Data for Name: Usuario; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--



--
-- TOC entry 3562 (class 0 OID 0)
-- Dependencies: 217
-- Name: Acesso_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Acesso_id_seq"', 50633, true);


--
-- TOC entry 3563 (class 0 OID 0)
-- Dependencies: 219
-- Name: CaracteristicaDispositivo_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."CaracteristicaDispositivo_id_seq"', 471, true);


--
-- TOC entry 3564 (class 0 OID 0)
-- Dependencies: 223
-- Name: DispositivoTMP_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."DispositivoTMP_id_seq"', 17482, true);


--
-- TOC entry 3565 (class 0 OID 0)
-- Dependencies: 224
-- Name: Dispositivo_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Dispositivo_id_seq"', 462, true);


--
-- TOC entry 3566 (class 0 OID 0)
-- Dependencies: 225
-- Name: Paciente_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Paciente_id_seq"', 1, true);


--
-- TOC entry 3567 (class 0 OID 0)
-- Dependencies: 227
-- Name: Permissao_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Permissao_id_seq"', 958, true);


--
-- TOC entry 3568 (class 0 OID 0)
-- Dependencies: 229
-- Name: Profissional_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Profissional_id_seq"', 6, true);


--
-- TOC entry 3569 (class 0 OID 0)
-- Dependencies: 231
-- Name: Recurso_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Recurso_id_seq"', 5, true);


--
-- TOC entry 3570 (class 0 OID 0)
-- Dependencies: 233
-- Name: RegLogin_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."RegLogin_id_seq"', 13570, true);


--
-- TOC entry 3571 (class 0 OID 0)
-- Dependencies: 235
-- Name: SensibilidadeSubRecurso_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."SensibilidadeSubRecurso_id_seq"', 94, true);


--
-- TOC entry 3572 (class 0 OID 0)
-- Dependencies: 237
-- Name: SubRecurso_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."SubRecurso_id_seq"', 26, true);


--
-- TOC entry 3573 (class 0 OID 0)
-- Dependencies: 239
-- Name: Token_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Token_id_seq"', 13216, true);


--
-- TOC entry 3574 (class 0 OID 0)
-- Dependencies: 241
-- Name: Usuario_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Usuario_id_seq"', 7, true);


--
-- TOC entry 3324 (class 2606 OID 24650)
-- Name: Acesso Acesso_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_pkey" PRIMARY KEY (id);


--
-- TOC entry 3326 (class 2606 OID 24652)
-- Name: CaracteristicaDispositivo CaracteristicaDispositivo_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."CaracteristicaDispositivo"
    ADD CONSTRAINT "CaracteristicaDispositivo_pkey" PRIMARY KEY (id);


--
-- TOC entry 3332 (class 2606 OID 24654)
-- Name: DispositivoTMP DispositivoTMP_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."DispositivoTMP"
    ADD CONSTRAINT "DispositivoTMP_pkey" PRIMARY KEY (id);


--
-- TOC entry 3330 (class 2606 OID 24656)
-- Name: Dispositivo Dispositivo_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Dispositivo"
    ADD CONSTRAINT "Dispositivo_pkey" PRIMARY KEY (id);


--
-- TOC entry 3328 (class 2606 OID 24658)
-- Name: Cliente Paciente_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Cliente"
    ADD CONSTRAINT "Paciente_pkey" PRIMARY KEY (id);


--
-- TOC entry 3334 (class 2606 OID 24660)
-- Name: Permissao Permissao_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Permissao"
    ADD CONSTRAINT "Permissao_pkey" PRIMARY KEY (id);


--
-- TOC entry 3336 (class 2606 OID 24662)
-- Name: Profissional Profissional_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Profissional"
    ADD CONSTRAINT "Profissional_pkey" PRIMARY KEY (id);


--
-- TOC entry 3338 (class 2606 OID 24664)
-- Name: Recurso Recurso_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Recurso"
    ADD CONSTRAINT "Recurso_pkey" PRIMARY KEY (id);


--
-- TOC entry 3340 (class 2606 OID 24666)
-- Name: RegLogin RegLogin_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."RegLogin"
    ADD CONSTRAINT "RegLogin_pkey" PRIMARY KEY (id);


--
-- TOC entry 3344 (class 2606 OID 24668)
-- Name: SensibilidadeSubRecurso SensibilidadeSubRecurso_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."SensibilidadeSubRecurso"
    ADD CONSTRAINT "SensibilidadeSubRecurso_pkey" PRIMARY KEY (id);


--
-- TOC entry 3346 (class 2606 OID 24670)
-- Name: SubRecurso SubRecurso_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."SubRecurso"
    ADD CONSTRAINT "SubRecurso_pkey" PRIMARY KEY (id);


--
-- TOC entry 3348 (class 2606 OID 24672)
-- Name: Token Token_hash_key; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Token"
    ADD CONSTRAINT "Token_hash_key" UNIQUE (hash);


--
-- TOC entry 3350 (class 2606 OID 24674)
-- Name: Token Token_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Token"
    ADD CONSTRAINT "Token_pkey" PRIMARY KEY (id);


--
-- TOC entry 3352 (class 2606 OID 24676)
-- Name: Usuario Usuario_cpf_key; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Usuario"
    ADD CONSTRAINT "Usuario_cpf_key" UNIQUE (cpf);


--
-- TOC entry 3354 (class 2606 OID 24678)
-- Name: Usuario Usuario_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Usuario"
    ADD CONSTRAINT "Usuario_pkey" PRIMARY KEY (id);


--
-- TOC entry 3342 (class 2606 OID 24680)
-- Name: RegLogin codigoAutorizacao; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."RegLogin"
    ADD CONSTRAINT "codigoAutorizacao" UNIQUE ("codigoAutorizacao");


--
-- TOC entry 3355 (class 2606 OID 24681)
-- Name: Acesso Acesso_idDispositivoTMP_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idDispositivoTMP_fkey" FOREIGN KEY ("idDispositivoTMP") REFERENCES "zt-ehealth"."DispositivoTMP"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3356 (class 2606 OID 24686)
-- Name: Acesso Acesso_idDispositivo_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idDispositivo_fkey" FOREIGN KEY ("idDispositivo") REFERENCES "zt-ehealth"."Dispositivo"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3357 (class 2606 OID 24691)
-- Name: Acesso Acesso_idPermissao_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idPermissao_fkey" FOREIGN KEY ("idPermissao") REFERENCES "zt-ehealth"."Permissao"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3358 (class 2606 OID 24696)
-- Name: Acesso Acesso_idSensibilidadeSubRecurso_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idSensibilidadeSubRecurso_fkey" FOREIGN KEY ("idSensibilidadeSubRecurso") REFERENCES "zt-ehealth"."SensibilidadeSubRecurso"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3359 (class 2606 OID 24701)
-- Name: Acesso Acesso_idSubRecurso_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idSubRecurso_fkey" FOREIGN KEY ("idSubRecurso") REFERENCES "zt-ehealth"."SubRecurso"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3360 (class 2606 OID 24706)
-- Name: Acesso Acesso_idToken_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idToken_fkey" FOREIGN KEY ("idToken") REFERENCES "zt-ehealth"."Token"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3361 (class 2606 OID 24711)
-- Name: Acesso Acesso_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3362 (class 2606 OID 24716)
-- Name: Cliente Paciente_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Cliente"
    ADD CONSTRAINT "Paciente_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3363 (class 2606 OID 24721)
-- Name: Permissao Permissao_idDispositivo_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Permissao"
    ADD CONSTRAINT "Permissao_idDispositivo_fkey" FOREIGN KEY ("idDispositivo") REFERENCES "zt-ehealth"."Dispositivo"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3364 (class 2606 OID 24726)
-- Name: Permissao Permissao_idSubRecurso_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Permissao"
    ADD CONSTRAINT "Permissao_idSubRecurso_fkey" FOREIGN KEY ("idSubRecurso") REFERENCES "zt-ehealth"."SubRecurso"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3365 (class 2606 OID 24731)
-- Name: Permissao Permissao_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Permissao"
    ADD CONSTRAINT "Permissao_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3366 (class 2606 OID 24736)
-- Name: Profissional Profissional_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Profissional"
    ADD CONSTRAINT "Profissional_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3367 (class 2606 OID 24741)
-- Name: RegLogin RegLogin_idDispositivo_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."RegLogin"
    ADD CONSTRAINT "RegLogin_idDispositivo_fkey" FOREIGN KEY ("idDispositivo") REFERENCES "zt-ehealth"."Dispositivo"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3368 (class 2606 OID 24746)
-- Name: RegLogin RegLogin_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."RegLogin"
    ADD CONSTRAINT "RegLogin_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3369 (class 2606 OID 24751)
-- Name: SensibilidadeSubRecurso SensibilidadeSubRecurso_idSubRecurso_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."SensibilidadeSubRecurso"
    ADD CONSTRAINT "SensibilidadeSubRecurso_idSubRecurso_fkey" FOREIGN KEY ("idSubRecurso") REFERENCES "zt-ehealth"."SubRecurso"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3370 (class 2606 OID 24756)
-- Name: SubRecurso SubRecurso_idRecurso_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."SubRecurso"
    ADD CONSTRAINT "SubRecurso_idRecurso_fkey" FOREIGN KEY ("idRecurso") REFERENCES "zt-ehealth"."Recurso"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3371 (class 2606 OID 24761)
-- Name: Token Token_idDispositivo_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Token"
    ADD CONSTRAINT "Token_idDispositivo_fkey" FOREIGN KEY ("idDispositivo") REFERENCES "zt-ehealth"."Dispositivo"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3372 (class 2606 OID 24766)
-- Name: Token Token_idRegLogin_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Token"
    ADD CONSTRAINT "Token_idRegLogin_fkey" FOREIGN KEY ("idRegLogin") REFERENCES "zt-ehealth"."RegLogin"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3373 (class 2606 OID 24771)
-- Name: Token Token_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Token"
    ADD CONSTRAINT "Token_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


-- Completed on 2025-04-16 21:35:51 UTC

--
-- PostgreSQL database dump complete
--

-- Completed on 2025-04-16 21:35:51 UTC

--
-- PostgreSQL database cluster dump complete
--

