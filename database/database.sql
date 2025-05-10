--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.8

-- Started on 2025-05-10 00:07:11 UTC




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
-- TOC entry 6 (class 2615 OID 16385)
-- Name: zt-ehealth; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "zt-ehealth";


ALTER SCHEMA "zt-ehealth" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 16386)
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
    reautenticacao boolean DEFAULT false,
    "confiancaContexto" real,
    "confiancaDispositivo" real,
    "confiancaHistorico" real
);


ALTER TABLE "zt-ehealth"."Acesso" OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16390)
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
-- TOC entry 3561 (class 0 OID 0)
-- Dependencies: 217
-- Name: Acesso_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Acesso_id_seq" OWNED BY "zt-ehealth"."Acesso".id;


--
-- TOC entry 218 (class 1259 OID 16391)
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
-- TOC entry 219 (class 1259 OID 16396)
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
-- TOC entry 3562 (class 0 OID 0)
-- Dependencies: 219
-- Name: CaracteristicaDispositivo_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."CaracteristicaDispositivo_id_seq" OWNED BY "zt-ehealth"."CaracteristicaDispositivo".id;


--
-- TOC entry 220 (class 1259 OID 16397)
-- Name: Cliente; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."Cliente" (
    id integer NOT NULL,
    "idUsuario" integer NOT NULL
);


ALTER TABLE "zt-ehealth"."Cliente" OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16400)
-- Name: Dispositivo; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."Dispositivo" (
    id integer NOT NULL,
    "MAC" character varying(18) NOT NULL
);


ALTER TABLE "zt-ehealth"."Dispositivo" OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16403)
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
-- TOC entry 223 (class 1259 OID 16408)
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
-- TOC entry 3563 (class 0 OID 0)
-- Dependencies: 223
-- Name: DispositivoTMP_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."DispositivoTMP_id_seq" OWNED BY "zt-ehealth"."DispositivoTMP".id;


--
-- TOC entry 224 (class 1259 OID 16409)
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
-- TOC entry 3564 (class 0 OID 0)
-- Dependencies: 224
-- Name: Dispositivo_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Dispositivo_id_seq" OWNED BY "zt-ehealth"."Dispositivo".id;


--
-- TOC entry 225 (class 1259 OID 16410)
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
-- TOC entry 3565 (class 0 OID 0)
-- Dependencies: 225
-- Name: Paciente_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Paciente_id_seq" OWNED BY "zt-ehealth"."Cliente".id;


--
-- TOC entry 226 (class 1259 OID 16411)
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
-- TOC entry 227 (class 1259 OID 16414)
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
-- TOC entry 3566 (class 0 OID 0)
-- Dependencies: 227
-- Name: Permissao_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Permissao_id_seq" OWNED BY "zt-ehealth"."Permissao".id;


--
-- TOC entry 228 (class 1259 OID 16415)
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
-- TOC entry 229 (class 1259 OID 16418)
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
-- TOC entry 3567 (class 0 OID 0)
-- Dependencies: 229
-- Name: Profissional_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Profissional_id_seq" OWNED BY "zt-ehealth"."Profissional".id;


--
-- TOC entry 230 (class 1259 OID 16419)
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
-- TOC entry 231 (class 1259 OID 16422)
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
-- TOC entry 3568 (class 0 OID 0)
-- Dependencies: 231
-- Name: Recurso_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Recurso_id_seq" OWNED BY "zt-ehealth"."Recurso".id;


--
-- TOC entry 232 (class 1259 OID 16423)
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
    "scoreECG" real,
    "tipoLogin" character varying(16) NOT NULL,
    "idSenha" integer
);


ALTER TABLE "zt-ehealth"."RegLogin" OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16427)
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
-- TOC entry 3569 (class 0 OID 0)
-- Dependencies: 233
-- Name: RegLogin_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."RegLogin_id_seq" OWNED BY "zt-ehealth"."RegLogin".id;


--
-- TOC entry 234 (class 1259 OID 16428)
-- Name: Senha; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."Senha" (
    id integer NOT NULL,
    senha character varying(255) NOT NULL,
    "idUsuario" integer NOT NULL,
    "dataCriacao" time with time zone NOT NULL,
    status character varying(16)
);


ALTER TABLE "zt-ehealth"."Senha" OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16431)
-- Name: Senha_id_seq; Type: SEQUENCE; Schema: zt-ehealth; Owner: postgres
--

CREATE SEQUENCE "zt-ehealth"."Senha_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "zt-ehealth"."Senha_id_seq" OWNER TO postgres;

--
-- TOC entry 3570 (class 0 OID 0)
-- Dependencies: 235
-- Name: Senha_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Senha_id_seq" OWNED BY "zt-ehealth"."Senha".id;


--
-- TOC entry 236 (class 1259 OID 16432)
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
-- TOC entry 237 (class 1259 OID 16435)
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
-- TOC entry 3571 (class 0 OID 0)
-- Dependencies: 237
-- Name: SensibilidadeSubRecurso_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."SensibilidadeSubRecurso_id_seq" OWNED BY "zt-ehealth"."SensibilidadeSubRecurso".id;


--
-- TOC entry 238 (class 1259 OID 16436)
-- Name: SubRecurso; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."SubRecurso" (
    id integer NOT NULL,
    "idRecurso" integer NOT NULL,
    nome character varying(150) NOT NULL
);


ALTER TABLE "zt-ehealth"."SubRecurso" OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16439)
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
-- TOC entry 3572 (class 0 OID 0)
-- Dependencies: 239
-- Name: SubRecurso_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."SubRecurso_id_seq" OWNED BY "zt-ehealth"."SubRecurso".id;


--
-- TOC entry 240 (class 1259 OID 16440)
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
-- TOC entry 241 (class 1259 OID 16443)
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
-- TOC entry 3573 (class 0 OID 0)
-- Dependencies: 241
-- Name: Token_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Token_id_seq" OWNED BY "zt-ehealth"."Token".id;


--
-- TOC entry 242 (class 1259 OID 16444)
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
-- TOC entry 243 (class 1259 OID 16448)
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
-- TOC entry 3574 (class 0 OID 0)
-- Dependencies: 243
-- Name: Usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Usuario_id_seq" OWNED BY "zt-ehealth"."Usuario".id;


--
-- TOC entry 3312 (class 2604 OID 16449)
-- Name: Acesso id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Acesso_id_seq"'::regclass);


--
-- TOC entry 3314 (class 2604 OID 16450)
-- Name: CaracteristicaDispositivo id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."CaracteristicaDispositivo" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."CaracteristicaDispositivo_id_seq"'::regclass);


--
-- TOC entry 3315 (class 2604 OID 16451)
-- Name: Cliente id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Cliente" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Paciente_id_seq"'::regclass);


--
-- TOC entry 3316 (class 2604 OID 16452)
-- Name: Dispositivo id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Dispositivo" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Dispositivo_id_seq"'::regclass);


--
-- TOC entry 3317 (class 2604 OID 16453)
-- Name: DispositivoTMP id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."DispositivoTMP" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."DispositivoTMP_id_seq"'::regclass);


--
-- TOC entry 3318 (class 2604 OID 16454)
-- Name: Permissao id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Permissao" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Permissao_id_seq"'::regclass);


--
-- TOC entry 3319 (class 2604 OID 16455)
-- Name: Profissional id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Profissional" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Profissional_id_seq"'::regclass);


--
-- TOC entry 3320 (class 2604 OID 16456)
-- Name: Recurso id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Recurso" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Recurso_id_seq"'::regclass);


--
-- TOC entry 3321 (class 2604 OID 16457)
-- Name: RegLogin id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."RegLogin" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."RegLogin_id_seq"'::regclass);


--
-- TOC entry 3323 (class 2604 OID 16458)
-- Name: Senha id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Senha" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Senha_id_seq"'::regclass);


--
-- TOC entry 3324 (class 2604 OID 16459)
-- Name: SensibilidadeSubRecurso id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."SensibilidadeSubRecurso" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."SensibilidadeSubRecurso_id_seq"'::regclass);


--
-- TOC entry 3325 (class 2604 OID 16460)
-- Name: SubRecurso id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."SubRecurso" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."SubRecurso_id_seq"'::regclass);


--
-- TOC entry 3326 (class 2604 OID 16461)
-- Name: Token id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Token" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Token_id_seq"'::regclass);


--
-- TOC entry 3327 (class 2604 OID 16462)
-- Name: Usuario id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Usuario" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Usuario_id_seq"'::regclass);


--
-- TOC entry 3527 (class 0 OID 16386)
-- Dependencies: 216
-- Data for Name: Acesso; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

COPY "zt-ehealth"."Acesso" (id, "idUsuario", "idToken", "idPermissao", "idSubRecurso", "idSensibilidadeSubRecurso", "idDispositivo", latitude, longitude, data, resultado, rede, confianca, "idDispositivoTMP", reautenticacao, "confiancaContexto", "confiancaDispositivo", "confiancaHistorico") FROM stdin;
\.


--
-- TOC entry 3529 (class 0 OID 16391)
-- Dependencies: 218
-- Data for Name: CaracteristicaDispositivo; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

COPY "zt-ehealth"."CaracteristicaDispositivo" (id, "deviceFingerPrint", "sistemaOperacional", "versaoSO", data, status, "idDispositivo") FROM stdin;
\.


--
-- TOC entry 3531 (class 0 OID 16397)
-- Dependencies: 220
-- Data for Name: Cliente; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

COPY "zt-ehealth"."Cliente" (id, "idUsuario") FROM stdin;
\.


--
-- TOC entry 3532 (class 0 OID 16400)
-- Dependencies: 221
-- Data for Name: Dispositivo; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

COPY "zt-ehealth"."Dispositivo" (id, "MAC") FROM stdin;
\.


--
-- TOC entry 3533 (class 0 OID 16403)
-- Dependencies: 222
-- Data for Name: DispositivoTMP; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

COPY "zt-ehealth"."DispositivoTMP" (id, "MAC", "deviceFingerPrint", "SistemaOperacional", "versaoSO", data) FROM stdin;
\.


--
-- TOC entry 3537 (class 0 OID 16411)
-- Dependencies: 226
-- Data for Name: Permissao; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

COPY "zt-ehealth"."Permissao" (id, "idUsuario", "idSubRecurso", "tipoAcao", "dataCriacao", status, "dataExclusao", "idDispositivo") FROM stdin;
\.


--
-- TOC entry 3539 (class 0 OID 16415)
-- Dependencies: 228
-- Data for Name: Profissional; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

COPY "zt-ehealth"."Profissional" (id, cargo, "diasTrabalho", "idUsuario", "horarioTrabalhoInicio", "horarioTrabalhoFinal") FROM stdin;
\.


--
-- TOC entry 3541 (class 0 OID 16419)
-- Dependencies: 230
-- Data for Name: Recurso; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

COPY "zt-ehealth"."Recurso" (id, nome, "ipAddress", porta) FROM stdin;
3	Monitoramento Remoto do Paciente	169.254.0.12	7003
4	Portal do Paciente	169.254.0.13	7004
5	Telemedicina	169.254.0.14	7005
1	Registro Eletronico de Saude	169.254.0.10	7001
2	Sistema de Informacao Hospitalar	169.254.0.11	7002
\.


--
-- TOC entry 3543 (class 0 OID 16423)
-- Dependencies: 232
-- Data for Name: RegLogin; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

COPY "zt-ehealth"."RegLogin" (id, "idUsuario", data, resultado, "idDispositivo", completado, "codigoAutorizacao", "scorePPG", "scoreECG", "tipoLogin", "idSenha") FROM stdin;
\.


--
-- TOC entry 3545 (class 0 OID 16428)
-- Dependencies: 234
-- Data for Name: Senha; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

COPY "zt-ehealth"."Senha" (id, senha, "idUsuario", "dataCriacao", status) FROM stdin;
\.


--
-- TOC entry 3547 (class 0 OID 16432)
-- Dependencies: 236
-- Data for Name: SensibilidadeSubRecurso; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

COPY "zt-ehealth"."SensibilidadeSubRecurso" (id, "idSubRecurso", "tipoAcao", sensibilidade) FROM stdin;
1	1	Leitura	45
2	1	Escrita	48
5	2	Leitura	53
6	2	Escrita	80
9	3	Leitura	38
10	3	Escrita	60
13	4	Leitura	63
14	4	Escrita	95
17	5	Leitura	43
18	5	Escrita	68
21	6	Leitura	58
22	6	Escrita	95
25	7	Leitura	55
26	7	Escrita	95
29	8	Leitura	35
30	8	Escrita	60
33	9	Leitura	45
34	9	Escrita	48
38	10	Escrita	53
41	11	Leitura	48
42	11	Escrita	55
45	12	Leitura	48
46	12	Escrita	50
49	13	Leitura	33
53	14	Leitura	33
54	14	Escrita	85
57	15	Leitura	48
58	15	Escrita	60
61	16	Leitura	23
62	16	Escrita	38
65	17	Leitura	43
66	17	Escrita	65
69	18	Leitura	65
70	19	Leitura	45
71	19	Escrita	48
74	20	Leitura	53
75	20	Escrita	80
78	21	Leitura	23
79	22	Leitura	38
80	22	Escrita	73
83	23	Leitura	55
84	23	Escrita	95
87	24	Leitura	45
88	24	Escrita	48
91	25	Leitura	53
92	25	Escrita	73
94	26	Acesso	90
50	13	Escrita	53
3	1	Modificacao	68
4	1	Exclusao	75
7	2	Modificacao	88
8	2	Exclusao	88
11	3	Modificacao	65
12	3	Exclusao	65
15	4	Modificacao	98
16	4	Exclusao	98
19	5	Modificacao	73
20	5	Exclusao	73
23	6	Modificacao	98
24	6	Exclusao	93
27	7	Modificacao	95
28	7	Exclusao	95
31	8	Modificacao	70
32	8	Exclusao	73
35	9	Modificacao	68
36	9	Exclusao	75
39	10	Modificacao	63
40	10	Exclusao	60
43	11	Modificacao	70
44	11	Exclusao	70
47	12	Modificacao	73
48	12	Exclusao	73
51	13	Modificacao	55
52	13	Exclusao	55
55	14	Modificacao	85
56	14	Exclusao	85
59	15	Modificacao	60
60	15	Exclusao	60
63	16	Modificacao	38
64	16	Exclusao	38
67	17	Modificacao	65
68	17	Exclusao	65
72	19	Modificacao	68
73	19	Exclusao	75
76	20	Modificacao	88
77	20	Exclusao	88
81	22	Modificacao	78
82	22	Exclusao	78
85	23	Modificacao	95
86	23	Exclusao	95
89	24	Modificacao	68
90	24	Exclusao	75
93	25	Exclusao	65
37	10	Leitura	18
95	27	Leitura	44
96	27	Escrita	67
97	27	Modificacao	67
98	27	Exclusao	81
99	28	Leitura	49
100	28	Escrita	55
101	28	Exclusao	89
102	29	Leitura	50
103	29	Modificacao	88
104	29	Exclusao	88
105	31	Leitura	10
106	31	Escrita	16
107	31	Modificacao	49
108	31	Exclusao	49
109	32	Leitura	47
110	32	Escrita	94
111	32	Modificacao	94
112	33	Leitura	40
113	33	Escrita	45
114	33	Modificacao	59
115	33	Exclusao	59
116	34	Leitura	69
117	34	Escrita	89
118	34	Modificacao	89
119	34	Exclusao	95
120	35	Leitura	76
121	36	Leitura	70
122	37	Leitura	48
123	37	Escrita	78
124	37	Modificacao	78
125	38	Leitura	15
126	38	Escrita	51
127	38	Modificacao	59
128	38	Exclusao	41
129	39	Leitura	11
130	39	Escrita	33
131	39	Modificacao	33
132	39	Exclusao	5
133	40	Leitura	35
134	40	Escrita	68
135	40	Modificacao	68
136	41	Leitura	35
137	41	Escrita	61
138	41	Modificacao	61
139	41	Exclusao	76
140	42	Leitura	29
141	42	Escrita	71
142	42	Modificacao	71
143	42	Exclusao	71
144	29	Escrita	88
\.


--
-- TOC entry 3549 (class 0 OID 16436)
-- Dependencies: 238
-- Data for Name: SubRecurso; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

COPY "zt-ehealth"."SubRecurso" (id, "idRecurso", nome) FROM stdin;
6	1	Resultados Laboratoriais
10	2	Registros Cadastrais da Enfermagem
12	2	Dados Financeiros
13	2	Dados de Recursos Humanos
14	2	Registro de Estoque
15	3	Registro de Sinais Vitais
26	5	Videoconsulta
1	1	Informacoes Cadastrais do Cliente
2	1	Notas Clinicas
3	1	Dados de Imunizacao
4	1	Historico Medico
5	1	Registro de Alergias
7	1	Informacoes de Consentimento
8	1	Prescricoes Medicas
9	2	Informacoes Cadastrais do Cliente
11	2	Registro de Internacao/Alta
16	3	Dados de Monitoramento de Atividades Fisicas
17	3	Dados de Geolocalizacao
18	3	Dados de Analise de Tendencia
19	4	Informacoes Cadastrais do Cliente
20	4	Notas Clinicas
21	4	Informacoes do Plano de Saude
22	4	Informacoes de Pagamento
23	4	Informacoes de Consentimento
24	5	Informacoes Cadastrais do Cliente
25	5	Gravacoes de Consultas
27	1	Medicacoes em Uso
28	1	Procedimentos Cirurgicos
29	1	Documentos Assinados
31	2	Agendamentos de consultas
32	2	Prontuario Eletronico
33	2	Controle de Medicamentos
34	2	Relatorios Administrativos
35	3	Alertas de Emergencia
36	3	Historico de Monitoramento
37	4	Historico de Consultas
38	4	Mensagens da Equipe
39	4	Feedbacks e Avaliacoes
40	5	Prescricoes Digitais
41	5	Laudos a Distancia
42	5	Chat
\.


--
-- TOC entry 3551 (class 0 OID 16440)
-- Dependencies: 240
-- Data for Name: Token; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

COPY "zt-ehealth"."Token" (id, "idUsuario", "idRegLogin", hash, validade, status, "idDispositivo", tipo) FROM stdin;
\.


--
-- TOC entry 3553 (class 0 OID 16444)
-- Dependencies: 242
-- Data for Name: Usuario; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

COPY "zt-ehealth"."Usuario" (id, nome, tipo, cpf, "codigoCriacao", ativado, "dataCriacao") FROM stdin;
\.


--
-- TOC entry 3575 (class 0 OID 0)
-- Dependencies: 217
-- Name: Acesso_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Acesso_id_seq"', 107514, true);


--
-- TOC entry 3576 (class 0 OID 0)
-- Dependencies: 219
-- Name: CaracteristicaDispositivo_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."CaracteristicaDispositivo_id_seq"', 790, true);


--
-- TOC entry 3577 (class 0 OID 0)
-- Dependencies: 223
-- Name: DispositivoTMP_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."DispositivoTMP_id_seq"', 42469, true);


--
-- TOC entry 3578 (class 0 OID 0)
-- Dependencies: 224
-- Name: Dispositivo_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Dispositivo_id_seq"', 781, true);


--
-- TOC entry 3579 (class 0 OID 0)
-- Dependencies: 225
-- Name: Paciente_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Paciente_id_seq"', 32, true);


--
-- TOC entry 3580 (class 0 OID 0)
-- Dependencies: 227
-- Name: Permissao_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Permissao_id_seq"', 14926, true);


--
-- TOC entry 3581 (class 0 OID 0)
-- Dependencies: 229
-- Name: Profissional_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Profissional_id_seq"', 295, true);


--
-- TOC entry 3582 (class 0 OID 0)
-- Dependencies: 231
-- Name: Recurso_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Recurso_id_seq"', 5, true);


--
-- TOC entry 3583 (class 0 OID 0)
-- Dependencies: 233
-- Name: RegLogin_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."RegLogin_id_seq"', 25619, true);


--
-- TOC entry 3584 (class 0 OID 0)
-- Dependencies: 235
-- Name: Senha_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Senha_id_seq"', 266, true);


--
-- TOC entry 3585 (class 0 OID 0)
-- Dependencies: 237
-- Name: SensibilidadeSubRecurso_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."SensibilidadeSubRecurso_id_seq"', 144, true);


--
-- TOC entry 3586 (class 0 OID 0)
-- Dependencies: 239
-- Name: SubRecurso_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."SubRecurso_id_seq"', 42, true);


--
-- TOC entry 3587 (class 0 OID 0)
-- Dependencies: 241
-- Name: Token_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Token_id_seq"', 23835, true);


--
-- TOC entry 3588 (class 0 OID 0)
-- Dependencies: 243
-- Name: Usuario_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Usuario_id_seq"', 331, true);


--
-- TOC entry 3330 (class 2606 OID 16464)
-- Name: Acesso Acesso_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_pkey" PRIMARY KEY (id);


--
-- TOC entry 3332 (class 2606 OID 16466)
-- Name: CaracteristicaDispositivo CaracteristicaDispositivo_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."CaracteristicaDispositivo"
    ADD CONSTRAINT "CaracteristicaDispositivo_pkey" PRIMARY KEY (id);


--
-- TOC entry 3338 (class 2606 OID 16468)
-- Name: DispositivoTMP DispositivoTMP_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."DispositivoTMP"
    ADD CONSTRAINT "DispositivoTMP_pkey" PRIMARY KEY (id);


--
-- TOC entry 3336 (class 2606 OID 16470)
-- Name: Dispositivo Dispositivo_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Dispositivo"
    ADD CONSTRAINT "Dispositivo_pkey" PRIMARY KEY (id);


--
-- TOC entry 3334 (class 2606 OID 16472)
-- Name: Cliente Paciente_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Cliente"
    ADD CONSTRAINT "Paciente_pkey" PRIMARY KEY (id);


--
-- TOC entry 3340 (class 2606 OID 16474)
-- Name: Permissao Permissao_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Permissao"
    ADD CONSTRAINT "Permissao_pkey" PRIMARY KEY (id);


--
-- TOC entry 3342 (class 2606 OID 16476)
-- Name: Profissional Profissional_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Profissional"
    ADD CONSTRAINT "Profissional_pkey" PRIMARY KEY (id);


--
-- TOC entry 3344 (class 2606 OID 16478)
-- Name: Recurso Recurso_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Recurso"
    ADD CONSTRAINT "Recurso_pkey" PRIMARY KEY (id);


--
-- TOC entry 3346 (class 2606 OID 16480)
-- Name: RegLogin RegLogin_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."RegLogin"
    ADD CONSTRAINT "RegLogin_pkey" PRIMARY KEY (id);


--
-- TOC entry 3350 (class 2606 OID 16482)
-- Name: Senha Senha_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Senha"
    ADD CONSTRAINT "Senha_pkey" PRIMARY KEY (id);


--
-- TOC entry 3352 (class 2606 OID 16484)
-- Name: SensibilidadeSubRecurso SensibilidadeSubRecurso_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."SensibilidadeSubRecurso"
    ADD CONSTRAINT "SensibilidadeSubRecurso_pkey" PRIMARY KEY (id);


--
-- TOC entry 3354 (class 2606 OID 16486)
-- Name: SubRecurso SubRecurso_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."SubRecurso"
    ADD CONSTRAINT "SubRecurso_pkey" PRIMARY KEY (id);


--
-- TOC entry 3356 (class 2606 OID 16488)
-- Name: Token Token_hash_key; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Token"
    ADD CONSTRAINT "Token_hash_key" UNIQUE (hash);


--
-- TOC entry 3358 (class 2606 OID 16490)
-- Name: Token Token_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Token"
    ADD CONSTRAINT "Token_pkey" PRIMARY KEY (id);


--
-- TOC entry 3360 (class 2606 OID 16492)
-- Name: Usuario Usuario_cpf_key; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Usuario"
    ADD CONSTRAINT "Usuario_cpf_key" UNIQUE (cpf);


--
-- TOC entry 3362 (class 2606 OID 16494)
-- Name: Usuario Usuario_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Usuario"
    ADD CONSTRAINT "Usuario_pkey" PRIMARY KEY (id);


--
-- TOC entry 3348 (class 2606 OID 16496)
-- Name: RegLogin codigoAutorizacao; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."RegLogin"
    ADD CONSTRAINT "codigoAutorizacao" UNIQUE ("codigoAutorizacao");


--
-- TOC entry 3363 (class 2606 OID 16497)
-- Name: Acesso Acesso_idDispositivoTMP_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idDispositivoTMP_fkey" FOREIGN KEY ("idDispositivoTMP") REFERENCES "zt-ehealth"."DispositivoTMP"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3364 (class 2606 OID 16502)
-- Name: Acesso Acesso_idDispositivo_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idDispositivo_fkey" FOREIGN KEY ("idDispositivo") REFERENCES "zt-ehealth"."Dispositivo"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3365 (class 2606 OID 16507)
-- Name: Acesso Acesso_idPermissao_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idPermissao_fkey" FOREIGN KEY ("idPermissao") REFERENCES "zt-ehealth"."Permissao"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3366 (class 2606 OID 16512)
-- Name: Acesso Acesso_idSensibilidadeSubRecurso_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idSensibilidadeSubRecurso_fkey" FOREIGN KEY ("idSensibilidadeSubRecurso") REFERENCES "zt-ehealth"."SensibilidadeSubRecurso"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3367 (class 2606 OID 16517)
-- Name: Acesso Acesso_idSubRecurso_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idSubRecurso_fkey" FOREIGN KEY ("idSubRecurso") REFERENCES "zt-ehealth"."SubRecurso"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3368 (class 2606 OID 16522)
-- Name: Acesso Acesso_idToken_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idToken_fkey" FOREIGN KEY ("idToken") REFERENCES "zt-ehealth"."Token"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3369 (class 2606 OID 16527)
-- Name: Acesso Acesso_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3370 (class 2606 OID 16532)
-- Name: Cliente Paciente_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Cliente"
    ADD CONSTRAINT "Paciente_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3371 (class 2606 OID 16537)
-- Name: Permissao Permissao_idDispositivo_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Permissao"
    ADD CONSTRAINT "Permissao_idDispositivo_fkey" FOREIGN KEY ("idDispositivo") REFERENCES "zt-ehealth"."Dispositivo"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3372 (class 2606 OID 16542)
-- Name: Permissao Permissao_idSubRecurso_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Permissao"
    ADD CONSTRAINT "Permissao_idSubRecurso_fkey" FOREIGN KEY ("idSubRecurso") REFERENCES "zt-ehealth"."SubRecurso"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3373 (class 2606 OID 16547)
-- Name: Permissao Permissao_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Permissao"
    ADD CONSTRAINT "Permissao_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3374 (class 2606 OID 16552)
-- Name: Profissional Profissional_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Profissional"
    ADD CONSTRAINT "Profissional_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3375 (class 2606 OID 16557)
-- Name: RegLogin RegLogin_idDispositivo_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."RegLogin"
    ADD CONSTRAINT "RegLogin_idDispositivo_fkey" FOREIGN KEY ("idDispositivo") REFERENCES "zt-ehealth"."Dispositivo"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3376 (class 2606 OID 16562)
-- Name: RegLogin RegLogin_idSenha_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."RegLogin"
    ADD CONSTRAINT "RegLogin_idSenha_fkey" FOREIGN KEY ("idSenha") REFERENCES "zt-ehealth"."Senha"(id) NOT VALID;


--
-- TOC entry 3377 (class 2606 OID 16567)
-- Name: RegLogin RegLogin_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."RegLogin"
    ADD CONSTRAINT "RegLogin_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3378 (class 2606 OID 16572)
-- Name: Senha Senha_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Senha"
    ADD CONSTRAINT "Senha_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) NOT VALID;


--
-- TOC entry 3379 (class 2606 OID 16577)
-- Name: SensibilidadeSubRecurso SensibilidadeSubRecurso_idSubRecurso_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."SensibilidadeSubRecurso"
    ADD CONSTRAINT "SensibilidadeSubRecurso_idSubRecurso_fkey" FOREIGN KEY ("idSubRecurso") REFERENCES "zt-ehealth"."SubRecurso"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3380 (class 2606 OID 16582)
-- Name: SubRecurso SubRecurso_idRecurso_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."SubRecurso"
    ADD CONSTRAINT "SubRecurso_idRecurso_fkey" FOREIGN KEY ("idRecurso") REFERENCES "zt-ehealth"."Recurso"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3381 (class 2606 OID 16587)
-- Name: Token Token_idDispositivo_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Token"
    ADD CONSTRAINT "Token_idDispositivo_fkey" FOREIGN KEY ("idDispositivo") REFERENCES "zt-ehealth"."Dispositivo"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3382 (class 2606 OID 16592)
-- Name: Token Token_idRegLogin_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Token"
    ADD CONSTRAINT "Token_idRegLogin_fkey" FOREIGN KEY ("idRegLogin") REFERENCES "zt-ehealth"."RegLogin"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3383 (class 2606 OID 16597)
-- Name: Token Token_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Token"
    ADD CONSTRAINT "Token_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


-- Completed on 2025-05-10 00:07:12 UTC

--
-- PostgreSQL database dump complete
--

-- Completed on 2025-05-10 00:07:12 UTC

--
-- PostgreSQL database cluster dump complete
--

