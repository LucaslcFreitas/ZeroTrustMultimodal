--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2025-03-11 11:20:25


ALTER DATABASE "zt-ehealth" OWNER TO postgres;

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
-- TOC entry 6 (class 2615 OID 16398)
-- Name: zt-ehealth; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "zt-ehealth";


ALTER SCHEMA "zt-ehealth" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 16399)
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
-- TOC entry 217 (class 1259 OID 16403)
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
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 217
-- Name: Acesso_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Acesso_id_seq" OWNED BY "zt-ehealth"."Acesso".id;


--
-- TOC entry 218 (class 1259 OID 16404)
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
-- TOC entry 219 (class 1259 OID 16409)
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
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 219
-- Name: CaracteristicaDispositivo_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."CaracteristicaDispositivo_id_seq" OWNED BY "zt-ehealth"."CaracteristicaDispositivo".id;


--
-- TOC entry 220 (class 1259 OID 16410)
-- Name: Cliente; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."Cliente" (
    id integer NOT NULL,
    "idUsuario" integer NOT NULL
);


ALTER TABLE "zt-ehealth"."Cliente" OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16413)
-- Name: Dispositivo; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."Dispositivo" (
    id integer NOT NULL,
    "MAC" character varying(18) NOT NULL
);


ALTER TABLE "zt-ehealth"."Dispositivo" OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16416)
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
-- TOC entry 223 (class 1259 OID 16421)
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
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 223
-- Name: DispositivoTMP_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."DispositivoTMP_id_seq" OWNED BY "zt-ehealth"."DispositivoTMP".id;


--
-- TOC entry 224 (class 1259 OID 16422)
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
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 224
-- Name: Dispositivo_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Dispositivo_id_seq" OWNED BY "zt-ehealth"."Dispositivo".id;


--
-- TOC entry 225 (class 1259 OID 16423)
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
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 225
-- Name: Paciente_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Paciente_id_seq" OWNED BY "zt-ehealth"."Cliente".id;


--
-- TOC entry 226 (class 1259 OID 16424)
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
-- TOC entry 227 (class 1259 OID 16427)
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
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 227
-- Name: Permissao_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Permissao_id_seq" OWNED BY "zt-ehealth"."Permissao".id;


--
-- TOC entry 228 (class 1259 OID 16428)
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
-- TOC entry 229 (class 1259 OID 16431)
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
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 229
-- Name: Profissional_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Profissional_id_seq" OWNED BY "zt-ehealth"."Profissional".id;


--
-- TOC entry 230 (class 1259 OID 16432)
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
-- TOC entry 231 (class 1259 OID 16435)
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
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 231
-- Name: Recurso_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Recurso_id_seq" OWNED BY "zt-ehealth"."Recurso".id;


--
-- TOC entry 232 (class 1259 OID 16436)
-- Name: RegLogin; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."RegLogin" (
    id integer NOT NULL,
    "idUsuario" integer,
    data timestamp with time zone NOT NULL,
    resultado character varying(10) NOT NULL,
    "idSenha" integer,
    "idDispositivo" integer,
    tipo character varying(15)
);


ALTER TABLE "zt-ehealth"."RegLogin" OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16439)
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
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 233
-- Name: RegLogin_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."RegLogin_id_seq" OWNED BY "zt-ehealth"."RegLogin".id;


--
-- TOC entry 234 (class 1259 OID 16440)
-- Name: Senha; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."Senha" (
    id integer NOT NULL,
    "idUsuario" integer NOT NULL,
    senha character varying(256) NOT NULL,
    "dataCriacao" timestamp with time zone NOT NULL,
    status character varying(12) NOT NULL
);


ALTER TABLE "zt-ehealth"."Senha" OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16443)
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
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 235
-- Name: Senha_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Senha_id_seq" OWNED BY "zt-ehealth"."Senha".id;


--
-- TOC entry 236 (class 1259 OID 16444)
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
-- TOC entry 237 (class 1259 OID 16447)
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
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 237
-- Name: SensibilidadeSubRecurso_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."SensibilidadeSubRecurso_id_seq" OWNED BY "zt-ehealth"."SensibilidadeSubRecurso".id;


--
-- TOC entry 238 (class 1259 OID 16448)
-- Name: SubRecurso; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."SubRecurso" (
    id integer NOT NULL,
    "idRecurso" integer NOT NULL,
    nome character varying(150) NOT NULL
);


ALTER TABLE "zt-ehealth"."SubRecurso" OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16451)
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
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 239
-- Name: SubRecurso_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."SubRecurso_id_seq" OWNED BY "zt-ehealth"."SubRecurso".id;


--
-- TOC entry 240 (class 1259 OID 16452)
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
-- TOC entry 241 (class 1259 OID 16455)
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
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 241
-- Name: Token_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Token_id_seq" OWNED BY "zt-ehealth"."Token".id;


--
-- TOC entry 242 (class 1259 OID 16456)
-- Name: Usuario; Type: TABLE; Schema: zt-ehealth; Owner: postgres
--

CREATE TABLE "zt-ehealth"."Usuario" (
    id integer NOT NULL,
    nome character varying(150) NOT NULL,
    tipo character varying(15) NOT NULL,
    cpf character varying(15) NOT NULL
);


ALTER TABLE "zt-ehealth"."Usuario" OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 16459)
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
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 243
-- Name: Usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: zt-ehealth; Owner: postgres
--

ALTER SEQUENCE "zt-ehealth"."Usuario_id_seq" OWNED BY "zt-ehealth"."Usuario".id;


--
-- TOC entry 4801 (class 2604 OID 16460)
-- Name: Acesso id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Acesso_id_seq"'::regclass);


--
-- TOC entry 4803 (class 2604 OID 16461)
-- Name: CaracteristicaDispositivo id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."CaracteristicaDispositivo" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."CaracteristicaDispositivo_id_seq"'::regclass);


--
-- TOC entry 4804 (class 2604 OID 16462)
-- Name: Cliente id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Cliente" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Paciente_id_seq"'::regclass);


--
-- TOC entry 4805 (class 2604 OID 16463)
-- Name: Dispositivo id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Dispositivo" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Dispositivo_id_seq"'::regclass);


--
-- TOC entry 4806 (class 2604 OID 16464)
-- Name: DispositivoTMP id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."DispositivoTMP" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."DispositivoTMP_id_seq"'::regclass);


--
-- TOC entry 4807 (class 2604 OID 16465)
-- Name: Permissao id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Permissao" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Permissao_id_seq"'::regclass);


--
-- TOC entry 4808 (class 2604 OID 16466)
-- Name: Profissional id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Profissional" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Profissional_id_seq"'::regclass);


--
-- TOC entry 4809 (class 2604 OID 16467)
-- Name: Recurso id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Recurso" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Recurso_id_seq"'::regclass);


--
-- TOC entry 4810 (class 2604 OID 16468)
-- Name: RegLogin id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."RegLogin" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."RegLogin_id_seq"'::regclass);


--
-- TOC entry 4811 (class 2604 OID 16469)
-- Name: Senha id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Senha" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Senha_id_seq"'::regclass);


--
-- TOC entry 4812 (class 2604 OID 16470)
-- Name: SensibilidadeSubRecurso id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."SensibilidadeSubRecurso" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."SensibilidadeSubRecurso_id_seq"'::regclass);


--
-- TOC entry 4813 (class 2604 OID 16471)
-- Name: SubRecurso id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."SubRecurso" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."SubRecurso_id_seq"'::regclass);


--
-- TOC entry 4814 (class 2604 OID 16472)
-- Name: Token id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Token" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Token_id_seq"'::regclass);


--
-- TOC entry 4815 (class 2604 OID 16473)
-- Name: Usuario id; Type: DEFAULT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Usuario" ALTER COLUMN id SET DEFAULT nextval('"zt-ehealth"."Usuario_id_seq"'::regclass);


--
-- TOC entry 5012 (class 0 OID 16399)
-- Dependencies: 216
-- Data for Name: Acesso; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--



--
-- TOC entry 5014 (class 0 OID 16404)
-- Dependencies: 218
-- Data for Name: CaracteristicaDispositivo; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--



--
-- TOC entry 5016 (class 0 OID 16410)
-- Dependencies: 220
-- Data for Name: Cliente; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

INSERT INTO "zt-ehealth"."Cliente" VALUES (1, 6);


--
-- TOC entry 5017 (class 0 OID 16413)
-- Dependencies: 221
-- Data for Name: Dispositivo; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--



--
-- TOC entry 5018 (class 0 OID 16416)
-- Dependencies: 222
-- Data for Name: DispositivoTMP; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--



--
-- TOC entry 5022 (class 0 OID 16424)
-- Dependencies: 226
-- Data for Name: Permissao; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

INSERT INTO "zt-ehealth"."Permissao" VALUES (801, 1, 1, 'Leitura', '2023-05-24 09:42:22.523995-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (802, 1, 2, 'Leitura', '2023-05-24 09:44:09.894398-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (803, 1, 2, 'Escrita', '2023-05-24 09:44:09.894398-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (804, 1, 2, 'Modificacao', '2023-05-24 09:44:09.894398-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (805, 1, 2, 'Exclusao', '2023-05-24 09:44:09.894398-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (806, 1, 3, 'Leitura', '2023-05-24 09:45:26.116141-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (807, 1, 3, 'Escrita', '2023-05-24 09:45:26.116141-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (808, 1, 3, 'Modificacao', '2023-05-24 09:45:26.116141-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (809, 1, 3, 'Exclusao', '2023-05-24 09:45:26.116141-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (810, 1, 4, 'Leitura', '2023-05-24 09:46:39.281641-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (811, 1, 4, 'Escrita', '2023-05-24 09:46:39.281641-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (812, 1, 4, 'Modificacao', '2023-05-24 09:46:39.281641-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (813, 1, 4, 'Exclusao', '2023-05-24 09:46:39.281641-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (814, 1, 5, 'Leitura', '2023-05-24 09:47:36.712956-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (815, 1, 5, 'Escrita', '2023-05-24 09:47:36.712956-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (816, 1, 5, 'Modificacao', '2023-05-24 09:47:36.712956-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (817, 1, 5, 'Exclusao', '2023-05-24 09:47:36.712956-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (818, 1, 6, 'Leitura', '2023-05-24 09:49:22.820335-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (819, 1, 6, 'Escrita', '2023-05-24 09:49:22.820335-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (820, 1, 6, 'Modificacao', '2023-05-24 09:49:22.820335-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (821, 1, 7, 'Leitura', '2023-05-24 09:50:16.313149-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (822, 1, 8, 'Leitura', '2023-05-24 09:50:54.077633-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (823, 1, 8, 'Escrita', '2023-05-24 09:50:54.077633-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (824, 1, 8, 'Modificacao', '2023-05-24 09:50:54.077633-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (825, 1, 8, 'Exclusao', '2023-05-24 09:50:54.077633-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (826, 1, 9, 'Leitura', '2023-05-24 09:53:05.519369-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (827, 1, 10, 'Leitura', '2023-05-24 09:53:41.119501-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (828, 1, 11, 'Leitura', '2023-05-24 09:54:26.269277-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (829, 1, 11, 'Escrita', '2023-05-24 09:54:26.269277-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (830, 1, 11, 'Modificacao', '2023-05-24 09:54:26.269277-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (831, 1, 11, 'Exclusao', '2023-05-24 09:54:26.269277-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (832, 1, 14, 'Leitura', '2023-05-24 09:55:22.541239-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (833, 1, 15, 'Leitura', '2023-05-24 09:56:15.118516-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (834, 1, 16, 'Leitura', '2023-05-24 09:57:19.483106-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (835, 1, 18, 'Leitura', '2023-05-24 09:58:10.641345-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (836, 1, 19, 'Leitura', '2023-05-24 09:58:40.640382-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (837, 1, 20, 'Leitura', '2023-05-24 09:59:19.420575-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (838, 1, 20, 'Escrita', '2023-05-24 09:59:19.420575-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (839, 1, 20, 'Modificacao', '2023-05-24 09:59:19.420575-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (840, 1, 20, 'Exclusao', '2023-05-24 09:59:19.420575-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (841, 1, 23, 'Leitura', '2023-05-24 10:02:54.956769-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (842, 1, 24, 'Leitura', '2023-05-24 10:04:04.705691-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (843, 1, 25, 'Leitura', '2023-05-24 10:04:47.102023-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (844, 1, 25, 'Escrita', '2023-05-24 10:04:47.102023-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (845, 1, 25, 'Exclusao', '2023-05-24 10:04:47.102023-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (846, 1, 26, 'Acesso', '2023-05-24 10:06:01.493265-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (847, 2, 1, 'Leitura', '2023-05-24 10:14:53.22344-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (848, 2, 2, 'Leitura', '2023-05-24 10:15:24.449359-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (849, 2, 2, 'Escrita', '2023-05-24 10:15:24.449359-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (850, 2, 2, 'Modificacao', '2023-05-24 10:15:24.449359-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (851, 2, 2, 'Exclusao', '2023-05-24 10:15:24.449359-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (852, 2, 3, 'Leitura', '2023-05-24 10:16:19.458837-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (853, 2, 3, 'Escrita', '2023-05-24 10:16:19.458837-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (854, 2, 3, 'Modificacao', '2023-05-24 10:16:19.458837-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (855, 2, 3, 'Exclusao', '2023-05-24 10:16:19.458837-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (856, 2, 4, 'Leitura', '2023-05-24 10:17:16.21039-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (857, 2, 4, 'Escrita', '2023-05-24 10:17:16.21039-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (858, 2, 4, 'Modificacao', '2023-05-24 10:17:16.21039-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (859, 2, 4, 'Exclusao', '2023-05-24 10:17:16.21039-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (860, 2, 5, 'Leitura', '2023-05-24 10:18:29.088346-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (861, 2, 5, 'Escrita', '2023-05-24 10:18:29.088346-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (862, 2, 5, 'Modificacao', '2023-05-24 10:18:29.088346-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (863, 2, 5, 'Exclusao', '2023-05-24 10:18:29.088346-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (864, 2, 6, 'Leitura', '2023-05-24 10:19:32.835518-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (865, 2, 6, 'Escrita', '2023-05-24 10:19:32.835518-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (866, 2, 6, 'Modificacao', '2023-05-24 10:19:32.835518-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (867, 2, 7, 'Leitura', '2023-05-24 10:20:24.459465-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (868, 2, 8, 'Leitura', '2023-05-24 10:22:31.571458-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (869, 2, 8, 'Escrita', '2023-05-24 10:22:31.571458-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (870, 2, 8, 'Modificacao', '2023-05-24 10:22:31.571458-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (871, 2, 8, 'Exclusao', '2023-05-24 10:22:31.571458-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (872, 2, 9, 'Leitura', '2023-05-24 10:23:24.062783-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (873, 2, 10, 'Leitura', '2023-05-24 10:23:59.834716-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (874, 2, 11, 'Leitura', '2023-05-24 10:24:32.581292-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (875, 2, 11, 'Escrita', '2023-05-24 10:24:32.581292-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (876, 2, 11, 'Modificacao', '2023-05-24 10:24:32.581292-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (877, 2, 11, 'Exclusao', '2023-05-24 10:24:32.581292-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (878, 2, 14, 'Leitura', '2023-05-24 10:25:42.849148-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (879, 2, 15, 'Leitura', '2023-05-24 10:26:31.595973-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (880, 2, 16, 'Leitura', '2023-05-24 10:27:05.084695-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (881, 2, 18, 'Leitura', '2023-05-24 10:27:39.024299-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (882, 2, 19, 'Leitura', '2023-05-24 10:28:04.233126-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (883, 2, 20, 'Leitura', '2023-05-24 10:28:42.675885-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (884, 2, 20, 'Escrita', '2023-05-24 10:28:42.675885-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (885, 2, 20, 'Modificacao', '2023-05-24 10:28:42.675885-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (886, 2, 20, 'Exclusao', '2023-05-24 10:28:42.675885-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (887, 2, 23, 'Leitura', '2023-05-24 10:29:55.700224-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (888, 2, 24, 'Leitura', '2023-05-24 10:30:31.738012-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (889, 2, 25, 'Leitura', '2023-05-24 10:31:01.961341-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (890, 2, 25, 'Escrita', '2023-05-24 10:31:01.961341-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (891, 2, 25, 'Exclusao', '2023-05-24 10:31:01.961341-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (892, 2, 26, 'Acesso', '2023-05-24 10:31:51.581223-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (893, 3, 1, 'Leitura', '2023-05-24 10:32:57.876515-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (894, 3, 2, 'Leitura', '2023-05-24 10:34:28.906775-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (895, 3, 3, 'Leitura', '2023-05-24 10:35:23.724742-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (896, 3, 3, 'Escrita', '2023-05-24 10:35:23.724742-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (897, 3, 3, 'Modificacao', '2023-05-24 10:35:23.724742-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (898, 3, 3, 'Exclusao', '2023-05-24 10:35:23.724742-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (899, 3, 5, 'Leitura', '2023-05-24 10:39:44.561347-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (900, 3, 7, 'Leitura', '2023-05-24 10:40:20.242879-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (901, 3, 8, 'Leitura', '2023-05-24 10:41:58.838373-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (902, 3, 9, 'Leitura', '2023-05-24 10:42:40.428267-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (903, 3, 10, 'Leitura', '2023-05-24 10:45:28.409437-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (904, 3, 11, 'Leitura', '2023-05-24 10:46:37.215794-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (905, 3, 14, 'Leitura', '2023-05-24 10:47:06.81154-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (906, 3, 15, 'Leitura', '2023-05-24 10:55:15.957319-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (907, 3, 16, 'Leitura', '2023-05-24 10:55:56.066439-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (908, 3, 19, 'Leitura', '2023-05-24 10:56:56.767223-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (909, 3, 20, 'Leitura', '2023-05-24 10:58:10.268207-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (910, 3, 23, 'Leitura', '2023-05-24 10:58:47.336147-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (911, 3, 24, 'Leitura', '2023-05-24 10:59:38.945141-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (912, 4, 1, 'Leitura', '2023-05-24 11:07:10.879409-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (913, 4, 1, 'Escrita', '2023-05-24 11:07:10.879409-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (914, 4, 1, 'Modificacao', '2023-05-24 11:07:10.879409-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (915, 4, 7, 'Leitura', '2023-05-24 11:08:43.321395-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (916, 4, 9, 'Leitura', '2023-05-24 11:09:17.615391-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (917, 4, 9, 'Escrita', '2023-05-24 11:09:17.615391-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (918, 4, 9, 'Modificacao', '2023-05-24 11:09:17.615391-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (919, 4, 11, 'Leitura', '2023-05-24 11:10:16.861504-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (920, 4, 12, 'Leitura', '2023-05-24 11:10:59.208254-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (921, 4, 12, 'Escrita', '2023-05-24 11:10:59.208254-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (922, 4, 12, 'Modificacao', '2023-05-24 11:10:59.208254-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (923, 4, 21, 'Leitura', '2023-05-24 11:17:00.508929-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (924, 4, 22, 'Leitura', '2023-05-24 11:17:32.270578-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (925, 4, 22, 'Escrita', '2023-05-24 11:17:32.270578-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (926, 4, 22, 'Modificacao', '2023-05-24 11:17:32.270578-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (927, 4, 22, 'Exclusao', '2023-05-24 11:17:32.270578-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (928, 4, 23, 'Leitura', '2023-05-24 11:19:35.09776-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (929, 5, 10, 'Leitura', '2023-05-24 11:32:56.116302-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (930, 5, 10, 'Escrita', '2023-05-24 11:32:56.116302-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (931, 5, 10, 'Modificacao', '2023-05-24 11:32:56.116302-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (932, 5, 10, 'Exclusao', '2023-05-24 11:32:56.116302-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (933, 5, 12, 'Leitura', '2023-05-24 11:34:06.426901-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (934, 5, 12, 'Escrita', '2023-05-24 11:34:06.426901-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (935, 5, 12, 'Modificacao', '2023-05-24 11:34:06.426901-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (936, 5, 12, 'Exclusao', '2023-05-24 11:34:06.426901-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (937, 5, 13, 'Leitura', '2023-05-24 11:35:14.588553-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (938, 5, 13, 'Escrita', '2023-05-24 11:35:14.588553-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (939, 5, 13, 'Modificacao', '2023-05-24 11:35:14.588553-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (940, 5, 13, 'Exclusao', '2023-05-24 11:35:14.588553-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (941, 5, 14, 'Leitura', '2023-05-24 11:36:37.086521-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (942, 5, 14, 'Escrita', '2023-05-24 11:36:37.086521-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (943, 5, 14, 'Modificacao', '2023-05-24 11:36:37.086521-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (944, 5, 14, 'Exclusao', '2023-05-24 11:36:37.086521-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (945, 6, 15, 'Leitura', '2023-05-24 11:39:58.211156-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (946, 6, 16, 'Leitura', '2023-05-24 11:40:19.467267-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (947, 6, 18, 'Leitura', '2023-05-24 11:40:40.355389-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (948, 6, 19, 'Leitura', '2023-05-24 11:42:14.584492-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (949, 6, 19, 'Modificacao', '2023-05-24 11:42:14.584492-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (950, 6, 20, 'Leitura', '2023-05-24 11:42:54.813301-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (951, 6, 21, 'Leitura', '2023-05-24 11:43:54.969993-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (952, 6, 22, 'Leitura', '2023-05-24 11:44:30.875866-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (953, 6, 22, 'Escrita', '2023-05-24 11:44:30.875866-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (954, 6, 23, 'Leitura', '2023-05-24 11:45:18.756764-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (955, 6, 23, 'Escrita', '2023-05-24 11:45:18.756764-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (956, 6, 24, 'Leitura', '2023-05-24 11:46:00.181497-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (957, 6, 24, 'Modificacao', '2023-05-24 11:46:00.181497-03', 'Ativo', NULL, NULL);
INSERT INTO "zt-ehealth"."Permissao" VALUES (958, 6, 26, 'Acesso', '2023-05-24 11:46:41.699374-03', 'Ativo', NULL, NULL);


--
-- TOC entry 5024 (class 0 OID 16428)
-- Dependencies: 228
-- Data for Name: Profissional; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

INSERT INTO "zt-ehealth"."Profissional" VALUES (1, 'Médico', 'Wednesday-Thursday-Friday-Saturday-Sunday', 1, '08:00:00', '16:00:00');
INSERT INTO "zt-ehealth"."Profissional" VALUES (2, 'Médico', 'Monday-Tuesday-Wednesday-Thursday-Friday', 2, '21:30:00', '11:00:00');
INSERT INTO "zt-ehealth"."Profissional" VALUES (3, 'Enfermeiro', 'Tuesday-Wednesday-Thursday-Friday-Saturday', 3, '09:00:00', '17:00:00');
INSERT INTO "zt-ehealth"."Profissional" VALUES (5, 'Administrador', 'Thursday-Friday-Saturday-Sunday-Monday', 5, '13:00:00', '22:00:00');
INSERT INTO "zt-ehealth"."Profissional" VALUES (4, 'Atendente', 'Sunday-Monday-Tuesday-Wednesday-Thursday', 4, '15:00:00', '02:00:00');


--
-- TOC entry 5026 (class 0 OID 16432)
-- Dependencies: 230
-- Data for Name: Recurso; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

INSERT INTO "zt-ehealth"."Recurso" VALUES (3, 'Monitoramento Remoto do Paciente', '169.254.0.12', 7003);
INSERT INTO "zt-ehealth"."Recurso" VALUES (4, 'Portal do Paciente', '169.254.0.13', 7004);
INSERT INTO "zt-ehealth"."Recurso" VALUES (5, 'Telemedicina', '169.254.0.14', 7005);
INSERT INTO "zt-ehealth"."Recurso" VALUES (1, 'Registro Eletronico de Saude', '169.254.0.10', 7001);
INSERT INTO "zt-ehealth"."Recurso" VALUES (2, 'Sistema de Informacao Hospitalar', '169.254.0.11', 7002);


--
-- TOC entry 5028 (class 0 OID 16436)
-- Dependencies: 232
-- Data for Name: RegLogin; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--



--
-- TOC entry 5030 (class 0 OID 16440)
-- Dependencies: 234
-- Data for Name: Senha; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

INSERT INTO "zt-ehealth"."Senha" VALUES (2312, 1, 'cf6d058dedf9a66c5b039cec186022aab3f33d7bdd19112f07ed44e513d326fe', '2023-05-23 11:20:08.369516-03', 'Ativo');
INSERT INTO "zt-ehealth"."Senha" VALUES (2313, 2, '0e3eb10df8dd1509b3f86c07974f3681f2fee0d603b5ad58c4e3374302804094', '2023-05-23 11:22:02.776633-03', 'Ativo');
INSERT INTO "zt-ehealth"."Senha" VALUES (2314, 3, '28646fceb3510a46df7b489c7e994b14ab546809ca6e9e4945ccfbd0962e41bd', '2023-05-23 11:22:48.612575-03', 'Ativo');
INSERT INTO "zt-ehealth"."Senha" VALUES (2315, 4, 'e15719bc1fd4d59cacc6a6dd7e1dc7779b80d48cd3fe38692f6f4ca395ff7223', '2023-05-23 11:23:31.749759-03', 'Ativo');
INSERT INTO "zt-ehealth"."Senha" VALUES (2316, 5, 'd5ae99cacd4c196c87bf3fafeecb1a72f7cfcfd3834292b2a41e2fcd2520903e', '2023-05-23 11:24:48.398614-03', 'Ativo');
INSERT INTO "zt-ehealth"."Senha" VALUES (2317, 6, '72863cd1a78bf14f433d6473930a60d21789b1c7655137dce2857f16ae5093e4', '2023-05-23 11:25:20.549288-03', 'Ativo');


--
-- TOC entry 5032 (class 0 OID 16444)
-- Dependencies: 236
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
-- TOC entry 5034 (class 0 OID 16448)
-- Dependencies: 238
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
-- TOC entry 5036 (class 0 OID 16452)
-- Dependencies: 240
-- Data for Name: Token; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--



--
-- TOC entry 5038 (class 0 OID 16456)
-- Dependencies: 242
-- Data for Name: Usuario; Type: TABLE DATA; Schema: zt-ehealth; Owner: postgres
--

INSERT INTO "zt-ehealth"."Usuario" VALUES (6, 'Flávia Tatiane Aragão', 'Cliente', '773.391.700-06');
INSERT INTO "zt-ehealth"."Usuario" VALUES (1, 'Enrico Murilo Viana', 'Profissional', '460.395.930-32');
INSERT INTO "zt-ehealth"."Usuario" VALUES (2, 'Cecília Nair Stefany Dias', 'Profissional', '357.069.500-08');
INSERT INTO "zt-ehealth"."Usuario" VALUES (3, 'Ryan Felipe Martin de Paula', 'Profissional', '649.122.660-35');
INSERT INTO "zt-ehealth"."Usuario" VALUES (4, 'Andreia Juliana Santos', 'Profissional', '859.310.680-31');
INSERT INTO "zt-ehealth"."Usuario" VALUES (5, 'Clarice Sarah da Cunha', 'Profissional', '465.994.610-00');


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 217
-- Name: Acesso_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Acesso_id_seq"', 49123, true);


--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 219
-- Name: CaracteristicaDispositivo_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."CaracteristicaDispositivo_id_seq"', 453, true);


--
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 223
-- Name: DispositivoTMP_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."DispositivoTMP_id_seq"', 17086, true);


--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 224
-- Name: Dispositivo_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Dispositivo_id_seq"', 444, true);


--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 225
-- Name: Paciente_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Paciente_id_seq"', 1, true);


--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 227
-- Name: Permissao_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Permissao_id_seq"', 958, true);


--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 229
-- Name: Profissional_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Profissional_id_seq"', 5, true);


--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 231
-- Name: Recurso_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Recurso_id_seq"', 5, true);


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 233
-- Name: RegLogin_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."RegLogin_id_seq"', 13232, true);


--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 235
-- Name: Senha_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Senha_id_seq"', 2317, true);


--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 237
-- Name: SensibilidadeSubRecurso_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."SensibilidadeSubRecurso_id_seq"', 94, true);


--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 239
-- Name: SubRecurso_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."SubRecurso_id_seq"', 26, true);


--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 241
-- Name: Token_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Token_id_seq"', 12881, true);


--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 243
-- Name: Usuario_id_seq; Type: SEQUENCE SET; Schema: zt-ehealth; Owner: postgres
--

SELECT pg_catalog.setval('"zt-ehealth"."Usuario_id_seq"', 6, true);


--
-- TOC entry 4817 (class 2606 OID 16475)
-- Name: Acesso Acesso_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_pkey" PRIMARY KEY (id);


--
-- TOC entry 4819 (class 2606 OID 16477)
-- Name: CaracteristicaDispositivo CaracteristicaDispositivo_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."CaracteristicaDispositivo"
    ADD CONSTRAINT "CaracteristicaDispositivo_pkey" PRIMARY KEY (id);


--
-- TOC entry 4825 (class 2606 OID 16479)
-- Name: DispositivoTMP DispositivoTMP_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."DispositivoTMP"
    ADD CONSTRAINT "DispositivoTMP_pkey" PRIMARY KEY (id);


--
-- TOC entry 4823 (class 2606 OID 16481)
-- Name: Dispositivo Dispositivo_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Dispositivo"
    ADD CONSTRAINT "Dispositivo_pkey" PRIMARY KEY (id);


--
-- TOC entry 4821 (class 2606 OID 16483)
-- Name: Cliente Paciente_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Cliente"
    ADD CONSTRAINT "Paciente_pkey" PRIMARY KEY (id);


--
-- TOC entry 4827 (class 2606 OID 16485)
-- Name: Permissao Permissao_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Permissao"
    ADD CONSTRAINT "Permissao_pkey" PRIMARY KEY (id);


--
-- TOC entry 4829 (class 2606 OID 16487)
-- Name: Profissional Profissional_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Profissional"
    ADD CONSTRAINT "Profissional_pkey" PRIMARY KEY (id);


--
-- TOC entry 4831 (class 2606 OID 16489)
-- Name: Recurso Recurso_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Recurso"
    ADD CONSTRAINT "Recurso_pkey" PRIMARY KEY (id);


--
-- TOC entry 4833 (class 2606 OID 16491)
-- Name: RegLogin RegLogin_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."RegLogin"
    ADD CONSTRAINT "RegLogin_pkey" PRIMARY KEY (id);


--
-- TOC entry 4835 (class 2606 OID 16493)
-- Name: Senha Senha_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Senha"
    ADD CONSTRAINT "Senha_pkey" PRIMARY KEY (id);


--
-- TOC entry 4837 (class 2606 OID 16495)
-- Name: SensibilidadeSubRecurso SensibilidadeSubRecurso_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."SensibilidadeSubRecurso"
    ADD CONSTRAINT "SensibilidadeSubRecurso_pkey" PRIMARY KEY (id);


--
-- TOC entry 4839 (class 2606 OID 16497)
-- Name: SubRecurso SubRecurso_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."SubRecurso"
    ADD CONSTRAINT "SubRecurso_pkey" PRIMARY KEY (id);


--
-- TOC entry 4841 (class 2606 OID 16499)
-- Name: Token Token_hash_key; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Token"
    ADD CONSTRAINT "Token_hash_key" UNIQUE (hash);


--
-- TOC entry 4843 (class 2606 OID 16501)
-- Name: Token Token_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Token"
    ADD CONSTRAINT "Token_pkey" PRIMARY KEY (id);


--
-- TOC entry 4845 (class 2606 OID 16503)
-- Name: Usuario Usuario_cpf_key; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Usuario"
    ADD CONSTRAINT "Usuario_cpf_key" UNIQUE (cpf);


--
-- TOC entry 4847 (class 2606 OID 16505)
-- Name: Usuario Usuario_pkey; Type: CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Usuario"
    ADD CONSTRAINT "Usuario_pkey" PRIMARY KEY (id);


--
-- TOC entry 4848 (class 2606 OID 16506)
-- Name: Acesso Acesso_idDispositivoTMP_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idDispositivoTMP_fkey" FOREIGN KEY ("idDispositivoTMP") REFERENCES "zt-ehealth"."DispositivoTMP"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4849 (class 2606 OID 16511)
-- Name: Acesso Acesso_idDispositivo_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idDispositivo_fkey" FOREIGN KEY ("idDispositivo") REFERENCES "zt-ehealth"."Dispositivo"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4850 (class 2606 OID 16516)
-- Name: Acesso Acesso_idPermissao_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idPermissao_fkey" FOREIGN KEY ("idPermissao") REFERENCES "zt-ehealth"."Permissao"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4851 (class 2606 OID 16521)
-- Name: Acesso Acesso_idSensibilidadeSubRecurso_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idSensibilidadeSubRecurso_fkey" FOREIGN KEY ("idSensibilidadeSubRecurso") REFERENCES "zt-ehealth"."SensibilidadeSubRecurso"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4852 (class 2606 OID 16526)
-- Name: Acesso Acesso_idSubRecurso_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idSubRecurso_fkey" FOREIGN KEY ("idSubRecurso") REFERENCES "zt-ehealth"."SubRecurso"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4853 (class 2606 OID 16531)
-- Name: Acesso Acesso_idToken_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idToken_fkey" FOREIGN KEY ("idToken") REFERENCES "zt-ehealth"."Token"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4854 (class 2606 OID 16536)
-- Name: Acesso Acesso_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Acesso"
    ADD CONSTRAINT "Acesso_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4855 (class 2606 OID 16541)
-- Name: Cliente Paciente_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Cliente"
    ADD CONSTRAINT "Paciente_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4856 (class 2606 OID 16546)
-- Name: Permissao Permissao_idDispositivo_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Permissao"
    ADD CONSTRAINT "Permissao_idDispositivo_fkey" FOREIGN KEY ("idDispositivo") REFERENCES "zt-ehealth"."Dispositivo"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4857 (class 2606 OID 16551)
-- Name: Permissao Permissao_idSubRecurso_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Permissao"
    ADD CONSTRAINT "Permissao_idSubRecurso_fkey" FOREIGN KEY ("idSubRecurso") REFERENCES "zt-ehealth"."SubRecurso"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4858 (class 2606 OID 16556)
-- Name: Permissao Permissao_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Permissao"
    ADD CONSTRAINT "Permissao_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4859 (class 2606 OID 16561)
-- Name: Profissional Profissional_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Profissional"
    ADD CONSTRAINT "Profissional_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4860 (class 2606 OID 16566)
-- Name: RegLogin RegLogin_idDispositivo_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."RegLogin"
    ADD CONSTRAINT "RegLogin_idDispositivo_fkey" FOREIGN KEY ("idDispositivo") REFERENCES "zt-ehealth"."Dispositivo"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4861 (class 2606 OID 16571)
-- Name: RegLogin RegLogin_idSenha_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."RegLogin"
    ADD CONSTRAINT "RegLogin_idSenha_fkey" FOREIGN KEY ("idSenha") REFERENCES "zt-ehealth"."Senha"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4862 (class 2606 OID 16576)
-- Name: RegLogin RegLogin_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."RegLogin"
    ADD CONSTRAINT "RegLogin_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4863 (class 2606 OID 16581)
-- Name: Senha Senha_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Senha"
    ADD CONSTRAINT "Senha_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4864 (class 2606 OID 16586)
-- Name: SensibilidadeSubRecurso SensibilidadeSubRecurso_idSubRecurso_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."SensibilidadeSubRecurso"
    ADD CONSTRAINT "SensibilidadeSubRecurso_idSubRecurso_fkey" FOREIGN KEY ("idSubRecurso") REFERENCES "zt-ehealth"."SubRecurso"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4865 (class 2606 OID 16591)
-- Name: SubRecurso SubRecurso_idRecurso_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."SubRecurso"
    ADD CONSTRAINT "SubRecurso_idRecurso_fkey" FOREIGN KEY ("idRecurso") REFERENCES "zt-ehealth"."Recurso"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4866 (class 2606 OID 16596)
-- Name: Token Token_idDispositivo_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Token"
    ADD CONSTRAINT "Token_idDispositivo_fkey" FOREIGN KEY ("idDispositivo") REFERENCES "zt-ehealth"."Dispositivo"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4867 (class 2606 OID 16601)
-- Name: Token Token_idRegLogin_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Token"
    ADD CONSTRAINT "Token_idRegLogin_fkey" FOREIGN KEY ("idRegLogin") REFERENCES "zt-ehealth"."RegLogin"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4868 (class 2606 OID 16606)
-- Name: Token Token_idUsuario_fkey; Type: FK CONSTRAINT; Schema: zt-ehealth; Owner: postgres
--

ALTER TABLE ONLY "zt-ehealth"."Token"
    ADD CONSTRAINT "Token_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "zt-ehealth"."Usuario"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


-- Completed on 2025-03-11 11:20:27

--
-- PostgreSQL database dump complete
--

