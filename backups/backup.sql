--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Debian 16.1-1.pgdg120+1)
-- Dumped by pg_dump version 16.1 (Debian 16.1-1.pgdg120+1)

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
-- Name: calculate_net_pay(); Type: FUNCTION; Schema: public; Owner: vvargas
--

CREATE FUNCTION public.calculate_net_pay() RETURNS TABLE(id integer, date date, net_pay numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id,
        p.date,
        p.gross - (p.dental_pre + p.medical_pre + p.fidelity_dcp + p.ltd_post + p.vol_add_post + p.basic_life_imputed_income + p.imputed_famli_ee + p.std_post + p.federal_taxes + p.medicare + p.state_tax + p.state_misc2 + p.tuition + p.park_permit) AS net_pay
    FROM
        pay_advices_csu p;
END;
$$;


ALTER FUNCTION public.calculate_net_pay() OWNER TO vvargas;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: vvargas
--

CREATE TABLE public.accounts (
    id integer NOT NULL,
    bank character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.accounts OWNER TO vvargas;

--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: vvargas
--

CREATE SEQUENCE public.accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.accounts_id_seq OWNER TO vvargas;

--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vvargas
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: vvargas
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO vvargas;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: vvargas
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_group_id_seq OWNER TO vvargas;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vvargas
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: vvargas
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO vvargas;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: vvargas
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_group_permissions_id_seq OWNER TO vvargas;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vvargas
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: vvargas
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO vvargas;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: vvargas
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_permission_id_seq OWNER TO vvargas;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vvargas
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: vvargas
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO vvargas;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: vvargas
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO vvargas;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: vvargas
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_user_groups_id_seq OWNER TO vvargas;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vvargas
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: vvargas
--

CREATE SEQUENCE public.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_user_id_seq OWNER TO vvargas;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vvargas
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: vvargas
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO vvargas;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: vvargas
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNER TO vvargas;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vvargas
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: vvargas
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO vvargas;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: vvargas
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.django_admin_log_id_seq OWNER TO vvargas;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vvargas
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: vvargas
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO vvargas;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: vvargas
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.django_content_type_id_seq OWNER TO vvargas;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vvargas
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: vvargas
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO vvargas;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: vvargas
--

CREATE SEQUENCE public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.django_migrations_id_seq OWNER TO vvargas;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vvargas
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: vvargas
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO vvargas;

--
-- Name: pay_advices; Type: TABLE; Schema: public; Owner: vvargas
--

CREATE TABLE public.pay_advices (
    id integer NOT NULL,
    date date NOT NULL,
    gross numeric DEFAULT 0 NOT NULL,
    dental_pre numeric DEFAULT 0 NOT NULL,
    medical_pre numeric DEFAULT 0 NOT NULL,
    retirement_plan numeric DEFAULT 0 NOT NULL,
    ltd_post numeric DEFAULT 0 NOT NULL,
    vol_add_post numeric DEFAULT 0 NOT NULL,
    basic_life_imputed_income numeric DEFAULT 0 NOT NULL,
    imputed_famli_ee numeric DEFAULT 0 NOT NULL,
    std_post numeric DEFAULT 0 NOT NULL,
    federal_taxes numeric DEFAULT 0 NOT NULL,
    medicare numeric DEFAULT 0 NOT NULL,
    state_tax numeric DEFAULT 0 NOT NULL,
    state_misc2 numeric DEFAULT 0 NOT NULL,
    tuition numeric DEFAULT 0 NOT NULL,
    park_permit numeric DEFAULT 0 NOT NULL,
    user_id integer,
    social_security numeric DEFAULT 0 NOT NULL
);


ALTER TABLE public.pay_advices OWNER TO vvargas;

--
-- Name: pay_advices_vanderlei_id_seq; Type: SEQUENCE; Schema: public; Owner: vvargas
--

CREATE SEQUENCE public.pay_advices_vanderlei_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pay_advices_vanderlei_id_seq OWNER TO vvargas;

--
-- Name: pay_advices_vanderlei_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vvargas
--

ALTER SEQUENCE public.pay_advices_vanderlei_id_seq OWNED BY public.pay_advices.id;


--
-- Name: retirement_fund; Type: TABLE; Schema: public; Owner: vvargas
--

CREATE TABLE public.retirement_fund (
    id integer NOT NULL,
    user_id integer NOT NULL,
    date date NOT NULL,
    employee_contribution numeric(10,2) DEFAULT 0 NOT NULL,
    employer_contribution numeric(10,2) DEFAULT 0 NOT NULL,
    gains_or_losses numeric(10,2) DEFAULT 0 NOT NULL,
    balance numeric(10,2) DEFAULT 0 NOT NULL,
    fees_credit numeric(10,2) DEFAULT 0 NOT NULL
);


ALTER TABLE public.retirement_fund OWNER TO vvargas;

--
-- Name: retirement_fund_id_seq; Type: SEQUENCE; Schema: public; Owner: vvargas
--

CREATE SEQUENCE public.retirement_fund_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.retirement_fund_id_seq OWNER TO vvargas;

--
-- Name: retirement_fund_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vvargas
--

ALTER SEQUENCE public.retirement_fund_id_seq OWNED BY public.retirement_fund.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: vvargas
--

CREATE TABLE public.transactions (
    id integer NOT NULL,
    bank_id integer NOT NULL,
    user_id integer NOT NULL,
    transaction_date date NOT NULL,
    description character varying(255),
    amount numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    category character varying(255),
    tags text[] DEFAULT '{}'::text[]
);


ALTER TABLE public.transactions OWNER TO vvargas;

--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: vvargas
--

CREATE SEQUENCE public.transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transactions_id_seq OWNER TO vvargas;

--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vvargas
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: vvargas
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO vvargas;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: vvargas
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO vvargas;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vvargas
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: pay_advices id; Type: DEFAULT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.pay_advices ALTER COLUMN id SET DEFAULT nextval('public.pay_advices_vanderlei_id_seq'::regclass);


--
-- Name: retirement_fund id; Type: DEFAULT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.retirement_fund ALTER COLUMN id SET DEFAULT nextval('public.retirement_fund_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: vvargas
--

COPY public.accounts (id, bank, type, created_at) FROM stdin;
1	CapitalOne	Credit	2024-01-09 04:55:36.540514+00
2	CapitalOne	Debit	2024-01-09 04:55:44.2822+00
3	WellsFargo	Debit	2024-01-09 04:55:54.122566+00
4	WellsFargo	Credit	2024-01-09 04:55:59.862541+00
5	MissionLane	Credit	2024-01-09 04:56:08.445215+00
6	Discover	Credit	2024-01-09 04:56:22.388325+00
7	CapitalOne	Savings	2024-01-09 04:56:38.822411+00
8	CapitalOne	CD	2024-01-09 04:57:00.500247+00
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: vvargas
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: vvargas
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: vvargas
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: vvargas
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: vvargas
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: vvargas
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: vvargas
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: vvargas
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	auth	user
5	contenttypes	contenttype
6	sessions	session
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: vvargas
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2024-01-05 20:03:53.78527+00
2	auth	0001_initial	2024-01-05 20:03:53.848464+00
3	admin	0001_initial	2024-01-05 20:03:53.861824+00
4	admin	0002_logentry_remove_auto_add	2024-01-05 20:03:53.865216+00
5	admin	0003_logentry_add_action_flag_choices	2024-01-05 20:03:53.868173+00
6	contenttypes	0002_remove_content_type_name	2024-01-05 20:03:53.877084+00
7	auth	0002_alter_permission_name_max_length	2024-01-05 20:03:53.880839+00
8	auth	0003_alter_user_email_max_length	2024-01-05 20:03:53.885011+00
9	auth	0004_alter_user_username_opts	2024-01-05 20:03:53.888407+00
10	auth	0005_alter_user_last_login_null	2024-01-05 20:03:53.891374+00
11	auth	0006_require_contenttypes_0002	2024-01-05 20:03:53.892179+00
12	auth	0007_alter_validators_add_error_messages	2024-01-05 20:03:53.895078+00
13	auth	0008_alter_user_username_max_length	2024-01-05 20:03:53.900403+00
14	auth	0009_alter_user_last_name_max_length	2024-01-05 20:03:53.90427+00
15	auth	0010_alter_group_name_max_length	2024-01-05 20:03:53.907488+00
16	auth	0011_update_proxy_permissions	2024-01-05 20:03:53.910204+00
17	auth	0012_alter_user_first_name_max_length	2024-01-05 20:03:53.913508+00
18	sessions	0001_initial	2024-01-05 20:03:53.919069+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: vvargas
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- Data for Name: pay_advices; Type: TABLE DATA; Schema: public; Owner: vvargas
--

COPY public.pay_advices (id, date, gross, dental_pre, medical_pre, retirement_plan, ltd_post, vol_add_post, basic_life_imputed_income, imputed_famli_ee, std_post, federal_taxes, medicare, state_tax, state_misc2, tuition, park_permit, user_id, social_security) FROM stdin;
32	2022-06-01	6283.730000	10	264	500	28.13000000	0.9500000000	1.600000000	0	4	362.5600000	86.49000000	218	0	0	44.67000000	1	0
42	2024-03-29	9046.100000	0	0	720	40.5	0.95	1.600000000	0	4	668.4700000	131.1700000	330	40.71000000	0	0	1	0
34	2022-08-01	6283.730000	10	264	500	28.13000000	0.9500000000	1.600000000	0	4	367.9200000	87.14000000	220	0	0	0	1	0
35	2022-09-01	6283.730000	10	264	500	28.13000000	0.9500000000	1.600000000	0	4	367.9200000	87.15000000	220	0	0	0	1	0
36	2022-10-01	6283.730000	10	264	500	28.13000000	0.9500000000	1.600000000	0	4	367.9200000	87.14000000	220	0	0	0	1	0
37	2022-11-01	6283.730000	10	264	500	28.13000000	0.9500000000	1.600000000	0	4	367.9200000	87.14000000	220	0	0	0	1	0
38	2022-12-01	6283.730000	10	264	500	28.13000000	0.9500000000	1.600000000	0	4	360.3600000	86.23000000	217	0	0	63	1	0
43	2024-04-30	9046.100000	0	0	720	40.5	0.9500000000	1.600000000	0	4	668.4700000	131.1700000	330	40.71000000	0	0	1	0
33	2022-07-01	2479.380000	10	264	195.6500000	28.13000000	0.9500000000	1.600000000	0	4	0	31.33000000	59	0	0	44.66000000	1	0
1	2023-01-01	6308.4	10.0	277.0	500.0	28.13	0.95	1.6	24.67	4.0	364.72	86.76	219.0	0.0	0.0	38.29	1	0
2	2023-02-01	6308.4	10.0	277.0	500.0	28.13	0.95	1.6	24.67	4.0	344.31	86.75	208.0	0.0	0.0	38.29	1	0
3	2023-03-01	6308.45	10.0	277.0	500.0	28.13	0.95	1.6	24.72	4.0	345.86	86.94	209.0	0.0	0.0	25.42	1	0
4	2023-04-01	6308.57	10.0	277.0	500.0	28.13	0.95	1.6	24.84	4.0	348.92	87.32	210.0	0.0	0.0	0.0	1	0
5	2023-05-01	6309.87	0.0	0.0	500.0	28.13	0.95	1.6	26.14	4.0	383.52	91.49	223.0	0.0	0.0	0.0	1	0
6	2023-06-01	8192.67	0.0	0.0	650.0	28.13	0.95	1.6	33.94	4.0	383.52	118.79	266.0	0.0	0.0	0.0	1	0
7	2023-07-01	10908.73	0.0	0.0	870.0	28.13	0.95	1.6	0.0	4.0	918.6	158.18	409.0	45.17	0.0	0.0	1	0
8	2023-08-01	9033.73	0.0	0.0	720.0	28.13	0.95	1.6	0.0	4.0	683.98	130.99	333.0	37.4	0.0	0.0	1	0
9	2023-09-01	9033.73	0.0	0.0	720.0	28.13	0.95	1.6	0.0	4.0	683.98	130.99	333.0	37.4	0.0	0.0	1	0
10	2023-10-01	9033.73	0.0	0.0	720.0	28.13	0.95	1.6	0.0	4.0	683.98	130.99	333.0	37.4	0.0	0.0	1	0
44	2024-05-31	9046.100000	0	0	720	40.5	0.9500000000	1.600000000	0	4	668.4700000	131.1700000	330	40.71000000	0	0	1	0
12	2023-12-01	9897.1	0.0	0.0	720.0	40.5	0.95	1.6	0.0	4.0	787.59	143.51	371.0	41.29	851.0	0.0	1	0
45	2024-06-28	9046.100000	0	0	720	40.5	0.9500000000	1.600000000	0	4	668.4700000	131.1700000	330	40.71000000	0	0	1	0
13	2023-12-01	4166.67	0	6.25	208.33	0	1.40	0	0	4.62	164.38	60.34	141.00	18.72	0	0	2	257.98
14	2023-09-01	4166.67	0	6.25	208.33	0	1.40	0	0	4.62	164.38	60.33	141.00	18.72	0	0	2	257.98
46	2024-07-31	9136.100000	0	0	727.2000000	40.5	0.9500000000	1.600000000	0	4	678.4000000	132.4700000	333	41.11000000	0	0	1	0
17	2023-08-01	4166.67	0	6.25	208.33	0	1.40	0	0	4.62	164.38	60.34	141	18.72	0	0	2	257.98
18	2023-07-01	4166.67	0	6.25	208.33	0	1.40	0	0	4.62	164.38	60.33	141	18.72	0	0	2	257.98
19	2023-06-01	4166.67	0	6.25	208.33	0	1.40	0	0	4.62	164.38	60.34	141	18.72	0	0	2	257.98
20	2023-05-01	4166.67	0	6.25	0	0	1.40	0	0	4.62	185.58	60.33	150	18.72	0	0	2	257.98
39	2022-03-01	3533.73	0	0	0	28.13000000	0	1.600000000	0	4	137.5400000	55.65000000	130	0	0	0	1	0
21	2022-04-01	17588.08	10	264	804.35	28.13	0.95	1.60	0	4.00	2426.81	251.06	721	0	0	0	1	0
47	2024-08-30	9136.100000	0	0	727.2000000	40.5	0.9500000000	1.600000000	0	4	678.4000000	132.4700000	333	41.11000000	0	0	1	0
48	2024-09-30	9136.100000	0	0	727.2000000	40.5	0.9500000000	1.600000000	0	4	678.4000000	132.4800000	333	41.11000000	0	0	1	0
31	2022-05-01	6283.730000	10	264	500	28.13000000	0.9500000000	1.600000000	0	4	362.5600000	86.49000000	218	0	0	44.67000000	1	0
49	2024-10-31	10854.10000	0	0	727.2000000	40.5	0.9500000000	1.600000000	0	4	884.5600000	157.3800000	409	48.84000000	1718	0	1	0
50	2024-11-29	10854.10000	0	0	727.2000000	40.5	0.9500000000	1.600000000	0	4	884.5600000	157.3900000	409	48.84000000	1718	0	1	0
51	2024-12-29	10854.10000	0	0	727.2000000	40.5	0.9500000000	1.600000000	0	4	884.5600000	157.3800000	409	48.84000000	1718	0	1	0
52	2024-01-31	4408.330000	0	6.25	216.6700000	0	1.400000000	0	0	2.880000000	175.2100000	63.84000000	147	19.84000000	0	0	2	272.9600000
15	2023-10-01	7289.670000	0	6.25	208.3300000	0	1.400000000	0	0	4.620000000	851.4400000	105.6200000	278	32.78000000	3123	0	2	451.6100000
16	2023-11-01	7364.670000	0	6.25	208.3300000	0	1.400000000	0	0	4.620000000	858.9400000	106.7000000	282	32.78000000	3123	0	2	456.2600000
11	2023-11-01	9897.100000	0	0	720	40.5	0.9500000000	1.600000000	0	4	787.5900000	143.5	371	41.29000000	851	0	1	0
40	2024-01-31	9897.100000	0	0	720	40.5	0.9500000000	1.600000000	0	4	787.5900000	143.5100000	371	44.53	851	0	1	0
53	2024-02-29	4333.330000	0	6.25	216.6700000	0	1.400000000	0	0	2.880000000	167.7100000	62.75	144	19.5	0	0	2	268.3200000
41	2024-02-29	9090	0	0	720	40.5	0.9500000000	1.600000000	43.90000000	4	673.73	131.80	332	40.91	0	0	1	0
54	2024-03-29	6333.330000	0	6.25	316.6700000	0	1.400000000	0	0	4.210000000	390.5800000	91.75	228	28.5	0	0	2	392.3100000
55	2024-04-30	4408.330000	0	6.25	216.6700000	0	1.400000000	0	0	2.880000000	175.2100000	63.84000000	147	19.84000000	0	0	2	272.9600000
56	2024-05-31	4333.330000	0	6.25	216.6700000	0	1.400000000	0	0	2.880000000	167.7100000	62.75	144	19.5	0	0	2	268.3200000
58	2024-07-31	4408.330000	0	7	216.6700000	0	1.400000000	0	0	2.880000000	175.1300000	63.83000000	147	19.84000000	0	0	2	272.9200000
59	2024-08-30	4333.330000	0	7	216.6700000	0	1.400000000	0	0	2.880000000	167.6300000	62.74000000	144	19.5	0	0	2	268.2700000
62	2024-11-29	5254.330000	0	7	216.6700000	0	1.400000000	0	0	2.880000000	370.25	76.10000000	185	19.5	921	0	2	325.3700000
63	2024-12-29	6004.330000	0	7	254.1700000	0	1.400000000	0	0	3.380000000	450.6100000	86.97000000	216	22.87000000	921	0	2	371.8700000
57	2024-06-28	4333.330000	0	6.25	216.6700000	0	1.400000000	0	0	2.880000000	167.7100000	62.75	144	19.5	0	0	2	268.3100000
60	2024-09-30	4333.330000	0	7	216.6700000	0	1.400000000	0	0	2.880000000	167.6300000	62.74000000	144	19.5	0	0	2	268.2600000
61	2024-10-31	4408.330000	0	7	216.6700000	0	1.400000000	0	0	2.880000000	175.1300000	63.82000000	147	19.84000000	0	0	2	272.9200000
\.


--
-- Data for Name: retirement_fund; Type: TABLE DATA; Schema: public; Owner: vvargas
--

COPY public.retirement_fund (id, user_id, date, employee_contribution, employer_contribution, gains_or_losses, balance, fees_credit) FROM stdin;
1	1	2022-04-01	804.35	1206.52	0.00	2010.87	0.00
2	1	2022-05-01	500.00	750.00	13.22	3274.09	0.00
3	1	2022-06-01	500.00	750.00	-277.39	4246.70	0.00
22	2	2023-06-01	208.33	416.67	0.00	625.00	0.00
4	1	2022-07-01	195.65	293.48	266.78	5004.19	1.58
23	2	2023-07-01	208.33	416.67	20.66	1270.66	0.00
5	1	2022-08-01	500.00	750.00	-171.21	6082.98	0.00
6	1	2022-09-01	500.00	750.00	-568.14	6764.84	0.00
24	2	2023-08-01	208.33	416.67	-33.89	1861.77	0.00
25	2	2023-09-01	208.33	416.67	-74.46	2412.31	0.00
26	2	2023-10-01	208.33	416.67	-67.02	2970.29	0.00
8	1	2022-11-01	500.00	750.00	727.56	9123.59	0.00
27	2	2023-11-01	208.33	416.67	252.27	3847.56	0.00
9	1	2022-12-01	500.00	750.00	-436.90	11186.69	0.00
28	2	2023-12-01	208.33	416.67	195.02	4667.58	0.00
10	1	2023-01-01	500.00	750.00	897.21	13338.10	4.20
11	1	2023-02-01	500.00	750.00	-433.26	14154.84	0.00
12	1	2023-03-01	500.00	750.00	350.77	15755.61	0.00
13	1	2023-04-01	500.00	750.00	208.94	17219.96	5.41
14	1	2023-05-01	500.00	750.00	-163.84	18306.12	0.00
15	1	2023-08-01	720.00	1080.00	-640.14	24902.62	0.00
16	1	2023-09-01	720.00	1080.00	-992.82	25714.90	5.10
17	1	2023-10-01	720.00	1080.00	-725.24	26789.66	0.00
18	1	2023-11-01	720.00	1080.00	2284.11	30871.77	-2.00
19	1	2023-12-01	720.00	1080.00	1556.04	34227.81	0.00
7	1	2022-10-01	500.00	750.00	378.51	7146.03	2.68
21	1	2023-06-01	0.00	0.00	955.35	19261.48	0.00
20	1	2023-07-01	1520.00	2280.00	681.28	23742.76	0.00
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: vvargas
--

COPY public.transactions (id, bank_id, user_id, transaction_date, description, amount, created_at, category, tags) FROM stdin;
2185	3	2	2023-10-13	PAYOFF DEBIT, NON-INTEREST WITHOUT FEE	0.00	2024-01-20 05:10:56.480938+00	\N	{}
1806	1	1	2023-12-26	WAL-MART #2729	-14.29	2024-01-09 18:57:47.153366+00	\N	{Travel,utah,Household,Grocery}
2186	3	2	2023-10-13	CAPITAL ONE TRANSFER RT0954EBA46A31A Sandra De Vargas	-750.32	2024-01-20 05:10:56.480938+00	\N	{}
2187	3	2	2023-10-10	RECURRING PAYMENT AUTHORIZED ON 10/07 APPLE.COM/BILL 866-712-7753 CA S383281099735831 CARD 9234	-2.99	2024-01-20 05:10:56.480938+00	\N	{}
2188	3	2	2023-10-05	DISCOVER E-PAYMENT 231005 1269 ROCHADEVARGASJUNIS	-261.05	2024-01-20 05:10:56.480938+00	\N	{}
2189	3	2	2023-10-03	DISCOVER E-PAYMENT 231003 1269 ROCHADEVARGASJUNIS	-309.15	2024-01-20 05:10:56.480938+00	\N	{}
1186	6	1	2023-02-28	GRECIAN CORNER SEATTLE WA	-30.56	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,seattle}
2190	3	2	2023-10-03	CAPITAL ONE MOBILE PMT 231003 3SG28XH3C8MKTJS SANDRA ROCHA DE VARGAS	-40.00	2024-01-20 05:10:56.480938+00	\N	{}
2191	3	2	2023-10-03	CAPITAL ONE TRANSFER RT09921E3CC77C5 Sandra De Vargas	-2500.00	2024-01-20 05:10:56.480938+00	\N	{}
2192	3	2	2023-10-02	CAPITAL ONE MOBILE PMT 230930 3SFM76PTR4G0SK8 SANDRA ROCHA DE VARGAS	-12.86	2024-01-20 05:10:56.480938+00	\N	{}
2193	3	2	2023-09-29	UNIVERSITY OF CO DIR DEP 230930 393374 ROCHA DE VARGAS JUNIOR	3303.66	2024-01-20 05:10:56.480938+00	\N	{}
2194	3	2	2023-09-28	CHUZE FIT CLUB FEES 2327000234106 720-210-9723	-24.99	2024-01-20 05:10:56.480938+00	\N	{}
2195	3	2	2023-09-27	DISCOVER E-PAYMENT 230927 1269 ROCHADEVARGASJUNIS	-103.64	2024-01-20 05:10:56.480938+00	\N	{}
2196	3	2	2023-09-27	CAPITAL ONE MOBILE PMT 230927 3SEZP4WH3OF2V14 SANDRA ROCHA DE VARGAS	-66.12	2024-01-20 05:10:56.480938+00	\N	{}
1189	6	1	2023-02-28	ORCA 888-988-6722 WAGOOGLE PAY ENDING IN 9955	-8.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,seattle}
2197	3	2	2023-09-21	CAPITAL ONE TRANSFER RT04398E95BFF76 Sandra De Vargas	-5000.00	2024-01-20 05:10:56.480938+00	\N	{}
1190	6	1	2023-02-28	ORCA 888-988-6722 WA	-8.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,seattle}
2198	3	2	2023-09-20	UNIV OF CO BLDR CU BOULDER 230919 XXXXX5662 Sandra Rocha de Vargas	-55.24	2024-01-20 05:10:56.480938+00	\N	{}
1915	1	1	2023-08-19	WAL-MART #5341	-86.73	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
2199	3	2	2023-09-18	CAPITAL ONE MOBILE PMT 230917 3SCVD3D6B6PQN4O SANDRA ROCHA DE VARGAS	-208.03	2024-01-20 05:10:56.480938+00	\N	{}
2200	3	2	2023-09-14	DISCOVER E-PAYMENT 230914 1269 ROCHADEVARGASJUNIS	-55.86	2024-01-20 05:10:56.480938+00	\N	{}
2201	3	2	2023-09-13	CAPITAL ONE MOBILE PMT 230913 3SC19PD0B9GWAE0 SANDRA ROCHA DE VARGAS	-395.66	2024-01-20 05:10:56.480938+00	\N	{}
2202	3	2	2023-09-13	DISCOVER E-PAYMENT 230913 1269 ROCHADEVARGASJUNIS	-163.20	2024-01-20 05:10:56.480938+00	\N	{}
2203	3	2	2023-09-13	CAPITAL ONE TRANSFER RT0FEDD736D88B9 Sandra De Vargas	-1000.00	2024-01-20 05:10:56.480938+00	\N	{}
2204	3	2	2023-09-12	VENMO PAYMENT 230912 1029359232129 SANDRA VARGAS	-100.00	2024-01-20 05:10:56.480938+00	\N	{}
2205	3	2	2023-09-12	VENMO PAYMENT 230912 1029359220461 SANDRA VARGAS	-100.00	2024-01-20 05:10:56.480938+00	\N	{}
2206	3	2	2023-09-12	REVERSE ZELLE TO VANDERLEI ON 09/11 REF #PP0RK9ZHZC	5.00	2024-01-20 05:10:56.480938+00	\N	{}
2207	3	2	2023-09-11	DISCOVER E-PAYMENT 230911 1269 ROCHADEVARGASJUNIS	-494.50	2024-01-20 05:10:56.480938+00	\N	{}
2208	3	2	2023-09-11	VENMO PAYMENT 230911 1029343877414 SANDRA VARGAS	-5.00	2024-01-20 05:10:56.480938+00	\N	{}
2209	3	2	2023-09-11	CAPITAL ONE MOBILE PMT 230911 3SBF66HYYBRZLW8 SANDRA ROCHA DE VARGAS	-349.24	2024-01-20 05:10:56.480938+00	\N	{}
2210	3	2	2023-09-11	ZELLE TO VANDERLEI ON 09/11 REF #PP0RK9ZVVZ	-5.00	2024-01-20 05:10:56.480938+00	\N	{}
2211	3	2	2023-09-11	ZELLE TO VANDERLEI ON 09/11 REF #PP0RK9ZHZC	-5.00	2024-01-20 05:10:56.480938+00	\N	{}
2212	3	2	2023-09-11	RECURRING PAYMENT AUTHORIZED ON 09/07 APPLE.COM/BILL 866-712-7753 CA S303251099638205 CARD 9234	-2.99	2024-01-20 05:10:56.480938+00	\N	{}
2213	3	2	2023-09-11	eDeposit in Branch 09/11/23 11:35:13 AM 598 SUMMIT BLVD BROOMFIELD CO	1130.00	2024-01-20 05:10:56.480938+00	\N	{}
2214	3	2	2023-09-08	DISCOVER E-PAYMENT 230908 1269 ROCHADEVARGASJUNIS	-578.29	2024-01-20 05:10:56.480938+00	\N	{}
2215	3	2	2023-09-07	CAPITAL ONE N.A. CAPITALONE 000036243934330 DE VARGAS,SANDRA	-250.00	2024-01-20 05:10:56.480938+00	\N	{}
2216	3	2	2023-09-01	DISCOVER E-PAYMENT 230901 1269 ROCHADEVARGASJUNIS	-238.28	2024-01-20 05:10:56.480938+00	\N	{}
2217	3	2	2023-09-01	CAPITAL ONE MOBILE PMT 230901 3S9B3VWX289ZLI0 SANDRA ROCHA DE VARGAS	-178.93	2024-01-20 05:10:56.480938+00	\N	{}
2218	3	2	2023-08-31	UNIVERSITY OF CO DIR DEP 230831 393374 ROCHA DE VARGAS JUNIOR	3303.65	2024-01-20 05:10:56.480938+00	\N	{}
2219	3	2	2023-08-29	CAPITAL ONE N.A. CAPITALONE 000036243934330 DE VARGAS,SANDRA	-250.00	2024-01-20 05:10:56.480938+00	\N	{}
2220	3	2	2023-08-29	CAPITAL ONE TRANSFER RT09F8696E7CE36 Sandra De Vargas	-200.00	2024-01-20 05:10:56.480938+00	\N	{}
2221	3	2	2023-08-28	CHUZE FIT CLUB FEES 2323701088390 720-210-9723	-74.98	2024-01-20 05:10:56.480938+00	\N	{}
2222	3	2	2023-08-23	FACEBOOK INC B9TNAV3L1Z B9TNAV3L1Z RMR*IK*FACEBOOK PAYOUT B9TNAV3L1Z\\	7.63	2024-01-20 05:10:56.480938+00	\N	{}
2223	3	2	2023-08-17	DISCOVER E-PAYMENT 230817 1269 ROCHADEVARGASJUNIS	-36.93	2024-01-20 05:10:56.480938+00	\N	{}
2224	3	2	2023-08-16	VENMO PAYMENT 230816 1028831067362 SANDRA VARGAS	-10.00	2024-01-20 05:10:56.480938+00	\N	{}
2225	3	2	2023-08-14	CAPITAL ONE MOBILE PMT 230813 3S5HJ7I5D7BT5LK SANDRA ROCHA DE VARGAS	-143.63	2024-01-20 05:10:56.480938+00	\N	{}
2226	3	2	2023-08-14	DISCOVER E-PAYMENT 230813 1269 ROCHADEVARGASJUNIS	-42.05	2024-01-20 05:10:56.480938+00	\N	{}
2227	3	2	2023-08-09	RECURRING PAYMENT AUTHORIZED ON 08/07 APPLE.COM/BILL 866-712-7753 CA S583220099633570 CARD 9234	-2.99	2024-01-20 05:10:56.480938+00	\N	{}
2228	3	2	2023-08-08	CAPITAL ONE MOBILE PMT 230808 3S4FGY57MHCFUL4 SANDRA ROCHA DE VARGAS	-179.80	2024-01-20 05:10:56.480938+00	\N	{}
2229	3	2	2023-08-07	DISCOVER E-PAYMENT 230807 1269 ROCHADEVARGASJUNIS	-318.71	2024-01-20 05:10:56.480938+00	\N	{}
2230	3	2	2023-08-02	CAPITAL ONE MOBILE PMT 230802 3S35UWWGNZ4GGPK SANDRA ROCHA DE VARGAS	-235.08	2024-01-20 05:10:56.480938+00	\N	{}
2231	3	2	2023-07-31	DISCOVER E-PAYMENT 230731 1269 ROCHADEVARGASJUNIS	-184.45	2024-01-20 05:10:56.480938+00	\N	{}
1705	2	1	2023-12-28	Withdrawal from CHUZE FIT CLUB FEES	-24.99	2024-01-09 18:34:47.445728+00	\N	{}
1702	2	1	2023-12-29	Withdrawal to Savings XXXXXXX1843	-4000.00	2024-01-09 18:34:47.445728+00	\N	{}
32	7	1	2023-12-31	Monthly Interest Paid	12.02	2024-01-09 05:13:55.402661+00	\N	{}
2232	3	2	2023-07-31	UNIVERSITY OF CO DIR DEP 230731 393374 ROCHA DE VARGAS JUNIOR	3303.66	2024-01-20 05:10:56.480938+00	\N	{}
2233	3	2	2023-07-28	Crowne at Old To Payment XXXXX1758 Sandra Rocha de Vargas	-651.60	2024-01-20 05:10:56.480938+00	\N	{}
2234	3	2	2023-07-24	DISCOVER E-PAYMENT 230724 1269 ROCHADEVARGASJUNIS	-445.86	2024-01-20 05:10:56.480938+00	\N	{}
2235	3	2	2023-07-24	CAPITAL ONE MOBILE PMT 230724 3S12N0JX4Q7E6QG SANDRA ROCHA DE VARGAS	-113.55	2024-01-20 05:10:56.480938+00	\N	{}
2236	3	2	2023-07-13	CAPITAL ONE MOBILE PMT 230713 3RYXXBNQC3H9BQ0 SANDRA ROCHA DE VARGAS	-238.27	2024-01-20 05:10:56.480938+00	\N	{}
1133	6	1	2023-01-21	WALMART MEMBERSHIP 800-966-6546 ARWTWEEIQ50CR3	-13.93	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
2237	3	2	2023-07-10	RECURRING PAYMENT AUTHORIZED ON 07/07 APPLE.COM/BILL 866-712-7753 CA S383189100840808 CARD 9234	-2.99	2024-01-20 05:10:56.480938+00	\N	{}
2238	3	2	2023-07-06	DISCOVER E-PAYMENT 230706 1269 ROCHADEVARGASJUNIS	-419.80	2024-01-20 05:10:56.480938+00	\N	{}
2239	3	2	2023-06-30	Crowne at Old To Payment XXXXX8674 Sandra Rocha de Vargas	-651.60	2024-01-20 05:10:56.480938+00	\N	{}
2240	3	2	2023-06-30	CAPITAL ONE MOBILE PMT 230630 3RW7JY93ICMS5G8 SANDRA ROCHA DE VARGAS	-69.27	2024-01-20 05:10:56.480938+00	\N	{}
2241	3	2	2023-06-30	UNIVERSITY OF CO DIR DEP 230630 393374 ROCHA DE VARGAS JUNIOR	3303.65	2024-01-20 05:10:56.480938+00	\N	{}
2242	3	2	2023-06-29	DISCOVER E-PAYMENT 230629 1269 ROCHADEVARGASJUNIS	-800.00	2024-01-20 05:10:56.480938+00	\N	{}
2243	3	2	2023-06-16	DISCOVER E-PAYMENT 230616 1269 ROCHADEVARGASJUNIS	-100.00	2024-01-20 05:10:56.480938+00	\N	{}
2244	3	2	2023-06-16	CAPITAL ONE MOBILE PMT 230616 3RT92PW1NO0D9CO SANDRA ROCHA DE VARGAS	-20.00	2024-01-20 05:10:56.480938+00	\N	{}
2245	3	2	2023-06-16	RECURRING PAYMENT AUTHORIZED ON 06/15 APPLE.COM/BILL 866-712-7753 CA S303166617124021 CARD 9234	-11.82	2024-01-20 05:10:56.480938+00	\N	{}
1201	6	1	2023-03-06	WALMART.COM 800-966-6546 AR	-90.64	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
2246	3	2	2023-06-13	DISCOVER E-PAYMENT 230613 1269 ROCHADEVARGASJUNIS	-36.46	2024-01-20 05:10:56.480938+00	\N	{}
2247	3	2	2023-06-12	RECURRING PAYMENT AUTHORIZED ON 06/07 APPLE.COM/BILL 866-712-7753 CA S583159100318749 CARD 9234	-2.99	2024-01-20 05:10:56.480938+00	\N	{}
2248	3	2	2023-06-09	CAPITAL ONE MOBILE PMT 230609 3RRS1U5L7KV0O0O SANDRA ROCHA DE VARGAS	-111.78	2024-01-20 05:10:56.480938+00	\N	{}
2249	3	2	2023-06-06	CAPITAL ONE MOBILE PMT 230606 3RR5CEIO5FESNMG SANDRA ROCHA DE VARGAS	-92.95	2024-01-20 05:10:56.480938+00	\N	{}
2250	3	2	2023-05-31	ZELLE TO CATES CORINNE C. ON 05/31 REF #RP0R9MVCP9 INTERNATIONS SANDRA VANDERLEI	-20.00	2024-01-20 05:10:56.480938+00	\N	{}
2251	3	2	2023-05-31	UNIVERSITY OF CO DIR DEP 230531 393374 ROCHA DE VARGAS JUNIOR	3481.79	2024-01-20 05:10:56.480938+00	\N	{}
2252	3	2	2023-05-30	DISCOVER E-PAYMENT 230530 1269 ROCHADEVARGASJUNIS	-239.38	2024-01-20 05:10:56.480938+00	\N	{}
2253	3	2	2023-05-30	CAPITAL ONE MOBILE PMT 230527 3ROTZFTF1MTHPJS SANDRA ROCHA DE VARGAS	-189.39	2024-01-20 05:10:56.480938+00	\N	{}
2254	3	2	2023-05-30	DISCOVER E-PAYMENT 230527 1269 ROCHADEVARGASJUNIS	-134.11	2024-01-20 05:10:56.480938+00	\N	{}
2255	3	2	2023-05-30	CAPITAL ONE MOBILE PMT 230528 3RP8ZIZAEC7YZRS SANDRA ROCHA DE VARGAS	-71.48	2024-01-20 05:10:56.480938+00	\N	{}
2256	3	2	2023-05-17	PURCHASE AUTHORIZED ON 05/15 APPLE.COM/BILL 408-974-1010 CA S463136040313501 CARD 9234	-11.82	2024-01-20 05:10:56.480938+00	\N	{}
2257	3	2	2023-05-11	DISCOVER E-PAYMENT 230511 1269 ROCHADEVARGASJUNIS	-122.65	2024-01-20 05:10:56.480938+00	\N	{}
2258	3	2	2023-05-09	RECURRING PAYMENT AUTHORIZED ON 05/07 APPLE.COM/BILL 866-712-7753 CA S383128099626219 CARD 9234	-2.99	2024-01-20 05:10:56.480938+00	\N	{}
2259	3	2	2023-04-11	Remax Elevate Payment XXXXX8120 P-PKR001-93725-2358	-50.00	2024-01-20 05:10:56.480938+00	\N	{}
2260	3	2	2023-04-11	Remax Elevate Payment XXXXX8119 P-PKR001-93725-2355	-50.00	2024-01-20 05:10:56.480938+00	\N	{}
2261	3	2	2023-04-10	RECURRING PAYMENT AUTHORIZED ON 04/07 APPLE.COM/BILL 866-712-7753 CA S383098100183336 CARD 9234	-2.99	2024-01-20 05:10:56.480938+00	\N	{}
2262	3	2	2023-04-05	DISCOVER E-PAYMENT 230405 1269 ROCHADEVARGASJUNIS	-60.00	2024-01-20 05:10:56.480938+00	\N	{}
2263	3	2	2023-03-09	DISCOVER E-PAYMENT 230309 1269 ROCHADEVARGASJUNIS	-5.15	2024-01-20 05:10:56.480938+00	\N	{}
2264	3	2	2023-03-09	RECURRING PAYMENT AUTHORIZED ON 03/07 APPLE.COM/BILL 866-712-7753 CA S463067137969499 CARD 9234	-2.99	2024-01-20 05:10:56.480938+00	\N	{}
2265	3	2	2023-03-03	DISCOVER E-PAYMENT 230303 1269 ROCHADEVARGASJUNIS	-214.50	2024-01-20 05:10:56.480938+00	\N	{}
2266	3	2	2023-02-22	LANGUAGE TRAINER ACH Pmt 230222 11011466817 Sandra Rocha de Vargas	240.00	2024-01-20 05:10:56.480938+00	\N	{}
2267	3	2	2023-02-09	RECURRING PAYMENT AUTHORIZED ON 02/07 APPLE.COM/BILL 866-712-7753 CA S583039136220375 CARD 9234	-2.99	2024-01-20 05:10:56.480938+00	\N	{}
613	6	1	2022-03-27	WALMART SC 02729 FORT COLLINS CO	-84.63	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
2268	3	2	2023-02-09	LANGUAGE TRAINER ACH Pmt 230209 11010533518 Sandra Rocha de Vargas	423.00	2024-01-20 05:10:56.480938+00	\N	{}
2269	3	2	2023-01-25	FACEBOOK, INC. B9TH8HAOI3 B9TH8HAOI3 RMR*IK*FACEBOOK PAYOUT B9TH8HAOI3\\	150.00	2024-01-20 05:10:56.480938+00	\N	{}
2270	3	2	2023-01-17	LANGUAGE TRAINER ACH Pmt 230117 11008330628 Sandra Rocha de Vargas	304.20	2024-01-20 05:10:56.480938+00	\N	{}
2271	3	2	2023-01-09	RECURRING PAYMENT AUTHORIZED ON 01/07 APPLE.COM/BILL 408-974-1010 CA S303008138735216 CARD 9234	-2.99	2024-01-20 05:10:56.480938+00	\N	{}
2272	3	2	2023-01-03	Wise Inc BICORTEX 230102 BICORTEX From BiCortex Languages Via WISE	120.00	2024-01-20 05:10:56.480938+00	\N	{}
2273	3	2	2022-12-09	RECURRING PAYMENT AUTHORIZED ON 12/07 APPLE.COM/BILL 866-712-7753 CA S382342137959945 CARD 9234	-2.99	2024-01-20 05:10:56.480938+00	\N	{}
2274	3	2	2022-12-08	Wise Inc WISE 221208 From BiCortex Languages Via WISE	210.00	2024-01-20 05:10:56.480938+00	\N	{}
2275	3	2	2022-11-25	INTERNATIONAL PURCHASE TRANSACTION FEE	-5.04	2024-01-20 05:10:56.480938+00	\N	{}
2276	3	2	2022-11-25	PURCHASE INTL AUTHORIZED ON 11/23 US MRV EMBASSY FEE READING GBR S462327638338549 CARD 9234	-168.30	2024-01-20 05:10:56.480938+00	\N	{}
2277	3	2	2022-11-14	RECURRING PAYMENT AUTHORIZED ON 11/07 APPLE.COM/BILL 866-712-7753 CA S582312135827021 CARD 9234	-2.99	2024-01-20 05:10:56.480938+00	\N	{}
647	6	1	2022-04-20	WALMART SC 02729 FORT COLLINS CO	-196.30	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
670	6	1	2022-05-02	WALMART SC 02729 FORT COLLINS CO	-272.06	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
759	6	1	2022-06-03	WALMART SC 02729 FORT COLLINS CO	-53.65	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
199	3	1	2023-03-29	Crowne at Old To Payment XXXXX1452 Vanderlei Rocha De Var	-2211.00	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
1071	6	1	2022-12-09	KING SOOPERS #0099 FORT COLLINS CO	-9.67	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
215	3	1	2023-02-27	Crowne at Old To Payment XXXXX0176 Vanderlei Rocha De Var	-2190.00	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
2278	3	2	2022-10-20	BILL PAY utility Billing Services MOBILE xxxxxxxx022C ON 10-20	-24.86	2024-01-20 05:10:56.480938+00	\N	{}
2279	3	2	2022-10-11	RECURRING PAYMENT AUTHORIZED ON 10/07 APPLE.COM/BILL 866-712-7753 CA S382281102274840 CARD 9234	-2.99	2024-01-20 05:10:56.480938+00	\N	{}
2280	3	2	2022-09-20	PURCHASE RETURN AUTHORIZED ON 09/19 TARGET 0003 FORT COLLINS CO S612263477400805 CARD 9234	26.89	2024-01-20 05:10:56.480938+00	\N	{}
2281	3	2	2022-09-19	PURCHASE AUTHORIZED ON 09/16 TARGET 0003 FORT COLLINS CO S382259804570992 CARD 9234	-81.20	2024-01-20 05:10:56.480938+00	\N	{}
2282	3	2	2022-09-15	BILL PAY utility Billing Services MOBILE xxxxxxxx022C ON 09-15	-30.25	2024-01-20 05:10:56.480938+00	\N	{}
2283	3	2	2022-09-09	RECURRING PAYMENT AUTHORIZED ON 09/07 APPLE.COM/BILL 866-712-7753 CA S582251103683419 CARD 9234	-2.99	2024-01-20 05:10:56.480938+00	\N	{}
2284	3	2	2022-08-25	BILL PAY WATER SYSTEMS - UTILITY BILLING MOBILE No Account Number ON 08-25	-23.86	2024-01-20 05:10:56.480938+00	\N	{}
2285	3	2	2022-08-08	RECURRING PAYMENT AUTHORIZED ON 08/07 APPLE.COM/BILL 866-712-7753 CA S302220099870304 CARD 9234	-2.99	2024-01-20 05:10:56.480938+00	\N	{}
2286	3	2	2022-07-27	Wixcom PAYOUT TX18887166200XT TRN*1*TX18887166200XT**444NB75VOLZC8MAN\\RMR*IK*T	23.97	2024-01-20 05:10:56.480938+00	\N	{}
2287	3	2	2022-07-21	PAYPAL VERIFYBANK 220721 1021334379133 SANDRA VARGAS	-0.18	2024-01-20 05:10:56.480938+00	\N	{}
2288	3	2	2022-07-21	PAYPAL VERIFYBANK 220721 1021334379128 SANDRA VARGAS	0.11	2024-01-20 05:10:56.480938+00	\N	{}
2289	3	2	2022-07-21	PAYPAL VERIFYBANK 220721 1021334379132 SANDRA VARGAS	0.07	2024-01-20 05:10:56.480938+00	\N	{}
2015	1	1	2023-06-09	WAL-MART #2223	-31.79	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1017	6	1	2022-10-30	WALMART SC 01442 PAGE AZ	-43.17	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,"las vegas",Household,Grocery}
1997	1	1	2023-06-29	WALMART.COM 8009666546	-60.49	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
2002	1	1	2023-06-24	WALMART.COM	-89.58	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1037	6	1	2022-11-13	WALMART SC 02729 FORT COLLINS CO	-216.38	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1218	6	1	2023-04-04	WALMART PAY 02729 FORT COLLINS CO	-9.38	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1220	6	1	2023-04-05	WALMART PAY 02729 FORT COLLINS CO	-35.64	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1222	6	1	2023-04-06	WALMART PAY 02729 FORT COLLINS CO	-39.98	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1223	6	1	2023-04-08	WALMART PAY 02729 FORT COLLINS CO	-11.26	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1225	6	1	2023-04-11	WALMART PAY 02729 FORT COLLINS CO	-17.11	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1229	6	1	2023-04-13	WALMART PAY 02729 FORT COLLINS CO	-81.79	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1230	6	1	2023-04-14	WALMART PAY 02729 FORT COLLINS CO	-35.29	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1234	6	1	2023-04-16	WALMART PAY 02729 FORT COLLINS CO	-61.35	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1236	6	1	2023-04-18	WALMART PAY 02729 FORT COLLINS CO	-36.16	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1238	6	1	2023-04-21	WALMART GROCERY 800-966-6546 AR	-13.93	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1239	6	1	2023-04-21	WALMART PAY 02729 FORT COLLINS CO	-66.74	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1244	6	1	2023-04-26	WALMART PAY 02729 FORT COLLINS CO	-141.42	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1250	6	1	2023-04-30	WALMART PAY 02729 FORT COLLINS CO	-71.56	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
211	3	1	2023-03-02	Crowne at Old To Payment XXXXX8615 Vanderlei Rocha De Var	-21.00	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
283	3	1	2022-10-26	Crowne at Old To Payment XXXXX5883 Vanderlei Rocha De Var	-2190.00	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
295	3	1	2022-09-30	Crowne at Old To Payment XXXXX2389 Vanderlei Rocha De Var	-2190.00	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
1772	2	1	2023-10-25	Withdrawal from XCEL ENERGY-PSCO XCELENERGY	-77.81	2024-01-09 18:34:47.445728+00	\N	{Household,Utilities}
240	3	1	2023-01-17	XCEL ENERGY-PSCO XCELENERGY 00139134914 VANDERLEI ROC464948823	-57.96	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
256	3	1	2022-12-12	XCEL ENERGY-PSCO XCELENERGY 00139134914 VANDERLEI ROC460833924	-36.91	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
273	3	1	2022-11-14	XCEL ENERGY-PSCO XCELENERGY 00139134914 VANDERLEI ROC457122587	-20.60	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
140	3	1	2023-07-17	XCEL ENERGY-PSCO XCELENERGY 00139134914 VANDERLEI ROC488691697	-85.10	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
1712	2	1	2023-12-15	Withdrawal from XCEL ENERGY-PSCO XCELENERGY	-65.16	2024-01-09 18:34:47.445728+00	\N	{Household,Utilities}
206	3	1	2023-03-16	XCEL ENERGY-PSCO XCELENERGY 00139134914 VANDERLEI ROC472770745	-51.70	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
203	3	1	2023-03-24	FORTCOLUTILITIES EBILL PAY 230323 7692150 VANDERLEI ROCHA DE VAR	-58.12	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
175	3	1	2023-05-16	XCEL ENERGY-PSCO XCELENERGY 00139134914 VANDERLEI ROC480864941	-23.43	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
190	3	1	2023-04-17	XCEL ENERGY-PSCO XCELENERGY 00139134914 VANDERLEI ROC476839244	-29.59	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
1273	6	1	2023-05-20	WALMART PAY 05341 BROOMFIELD CO	-49.62	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1274	6	1	2023-05-21	WALMART GROCERY 800-966-6546 AR	-13.93	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1275	6	1	2023-05-21	WALMART PAY 05341 BROOMFIELD CO	-68.41	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
877	6	1	2022-08-03	WALMART SC 02729 FORT COLLINS CO	-53.75	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1094	6	1	2022-12-23	WALMART PAY 02729 FORT COLLINS CO	-96.27	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
962	6	1	2022-09-16	WALMART.COM AA 800-966-6546 AR	-117.01	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
965	6	1	2022-09-20	WALMART SC 02729 FORT COLLINS CO	-2.12	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1243	6	1	2023-04-23	WALMART PAY 02729 FORT COLLINS CO	-161.68	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,gleenwood,Household,Grocery}
745	6	1	2022-05-28	WALMART SC 01604 RAPID CITY SD	-33.71	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,badlands,Household,Grocery}
1895	1	1	2023-08-28	KING SOOPERS #0086	-31.02	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
762	6	1	2022-06-04	WALMART SC 02729 FORT COLLINS CO	-53.65	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1156	6	1	2023-02-12	WALMART PAY 02729 FORT COLLINS CO	-48.09	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1157	6	1	2023-02-12	WALMART.COM 800-966-6546 AR	-96.46	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1159	6	1	2023-02-13	WALMART PAY 02729 FORT COLLINS CO	-79.43	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1162	6	1	2023-02-14	WALMART PAY 02729 FORT COLLINS CO	-38.68	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1168	6	1	2023-02-21	WALMART^ MEMBERSHIP BENTONVILLE AR	-13.93	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
1171	6	1	2023-02-24	WALMART.COM 800-966-6546 ARWL4K7IOW25Q5	-160.92	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1211	6	1	2023-03-28	WALMART.COM 8009666546 BENTONVILLE AR	-198.71	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1214	6	1	2023-03-31	WALMART PAY 02729 FORT COLLINS CO	-33.64	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1050	6	1	2022-11-22	WALMART.COM 800-966-6546 ARWAND35U4EXD6	-245.21	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1051	6	1	2022-11-23	WALMART PAY 02729 FORT COLLINS CO	-31.11	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1052	6	1	2022-11-23	WALMART.COM 800-966-6546 ARWNIFM3CSF9IJ	-82.81	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
758	6	1	2022-06-01	KING SOOPERS #0099 FORT COLLINS CO	-146.52	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
1053	6	1	2022-11-23	WALMART.COM 8009666546 BENTONVILLE AR	-42.02	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1058	6	1	2022-11-27	WALMART.COM 8009666546 BENTONVILLE AR	-148.87	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
813	6	1	2022-06-23	WALMART.COM AA 800-966-6546 AR	-21.38	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1068	6	1	2022-12-04	WALMART PAY 02729 FORT COLLINS CO	-58.30	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1070	6	1	2022-12-05	WALMART.COM 800-966-6546 ARWBW12ALJI6H4	-51.36	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1073	6	1	2022-12-10	WALMART PAY 02729 FORT COLLINS CO	-92.31	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1077	6	1	2022-12-12	WALMART.COM 800-966-6546 ARWHQ2OAYC0GKB	-81.35	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1086	6	1	2022-12-18	WALMART PAY 02729 FORT COLLINS CO	-33.88	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1087	6	1	2022-12-18	WALMART.COM 8009666546 BENTONVILLE AR	-22.82	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1089	6	1	2022-12-19	WALMART.COM 800-966-6546 ARWW8OUVNE2QKS	-121.38	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1092	6	1	2022-12-21	WALMART MEMBERSHIP 800-966-6546 ARWK7EEVUK4ZS4	-13.93	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
1152	6	1	2023-02-10	WALMART.COM 8009666546 BENTONVILLE AR	-43.76	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
772	6	1	2022-06-06	KING SOOPERS #0099 FORT COLLINS CO	-1.93	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
862	6	1	2022-07-22	KING SOOPERS #0099 FORT COLLINS CO	-49.23	2024-01-09 18:17:44.325718+00	Supermarkets	{Travel,"dutch george",Household,Grocery}
859	6	1	2022-07-20	KING SOOPERS #0099 FORT COLLINS COCASHOVER $ 60.00 PURCHASES $ 78.32	-138.32	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
866	6	1	2022-07-26	KING SOOPERS #5099 FORT COLLINS CO	-118.04	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
933	6	1	2022-08-30	KING SOOPERS #0009 FT. COLLINS CO	-19.79	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
956	6	1	2022-09-11	KING SOOPERS #0099 FORT COLLINS CO	-12.55	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
231	3	1	2023-01-30	Crowne at Old To Payment XXXXX3474 Vanderlei Rocha De Var	-2190.00	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
1936	1	1	2023-08-05	WAL-MART #4747	-4.58	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
39	7	1	2023-11-30	Monthly Interest Paid	63.07	2024-01-09 05:13:55.402661+00	\N	{}
1704	2	1	2023-12-29	Deposit from COLORADO STATE U payroll	6935.66	2024-01-09 18:34:47.445728+00	\N	{}
1703	2	1	2023-12-29	Deposit from Savings XXXXXXX1843	2000.00	2024-01-09 18:34:47.445728+00	\N	{}
57	7	1	2023-09-01	Preauthorized Deposit from WELLS FARGO BANK NA checking account XXXXXX1493	300.00	2024-01-09 05:13:55.402661+00	\N	{}
49	7	1	2023-10-31	Monthly Interest Paid	37.08	2024-01-09 05:13:55.402661+00	\N	{}
265	3	1	2022-11-29	CAPITAL ONE MOBILE PMT 221128 3MX1ECO5RRJUK60 SANDRA ROCHA DE VARGAS	-328.62	2024-01-09 18:10:05.987144+00	\N	{}
736	6	1	2022-05-28	EXXONMOBIL CUSTER SD	-4.56	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,badlands,Auto,Gas}
1813	1	1	2023-12-09	WAL-MART #5341	-55.00	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1819	1	1	2023-12-02	WAL-MART #5341	-31.11	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1845	1	1	2023-11-05	WAL-MART #2223	-60.13	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
2146	5	1	2023-11-06	Costco Gas #0440	-17.85	2024-01-11 04:43:34.551039+00	\N	{Auto,Gas}
2154	5	1	2023-10-31	Costco Gas #0480	-19.58	2024-01-11 04:43:34.551039+00	\N	{Auto,Gas}
1869	1	1	2023-09-23	WAL-MART #5341	-16.58	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1873	1	1	2023-09-15	WAL-MART #1045	-33.15	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1896	1	1	2023-08-27	WAL-MART #4288	-86.49	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
2030	1	1	2023-05-27	WAL-MART #5341	-2.42	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
961	6	1	2022-09-16	KING SOOPERS #0099 FORT COLLINS CO	-27.15	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
1033	6	1	2022-11-10	KING SOOPERS #0099 FORT COLLINS CO	-104.86	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
1035	6	1	2022-11-11	KING SOOPERS #0099 FORT COLLINS CO	-11.23	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
1950	1	1	2023-07-27	KING SOOPERS #0086	-37.27	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1972	1	1	2023-07-07	KING SOOPERS #0086	-33.33	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
2005	1	1	2023-06-17	KING SOOPERS #0689 FUE	-42.16	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
2006	1	1	2023-06-16	KING SOOPERS #0086	-19.59	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
697	6	1	2022-05-10	KING SOOPERS #0018 FT. COLLINS CO	-76.56	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
766	6	1	2022-06-05	KING SOOPERS #0018 FT. COLLINS CO	-41.10	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
617	6	1	2022-03-29	KING SOOPERS #0018 FT. COLLINS CO	-27.60	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
637	6	1	2022-04-13	KING SOOPERS #0009 FT. COLLINS CO	-114.71	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
713	6	1	2022-05-15	KING SOOPERS #0018 FT. COLLINS CO	-57.90	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
731	6	1	2022-05-26	KING SOOPERS #0099 FORT COLLINS COCASHOVER $ 60.00 PURCHASES $ 101.03	-161.03	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
847	6	1	2022-07-15	KING SOOPERS #0099 FORT COLLINS CO	-36.21	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
639	6	1	2022-04-17	KING SOOPERS #0009 FT. COLLINS CO	-16.85	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
2175	5	1	2023-09-21	Costco Whse #0480	-175.31	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
2176	5	1	2023-09-21	Costco Whse #0480	-120.00	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
2087	5	1	2024-01-04	Costco Whse #0440	-274.52	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
2116	5	1	2023-12-03	Costco Whse #0480	-166.42	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
2100	5	1	2023-12-27	Costco Whse #0480	-16.83	2024-01-11 04:43:34.551039+00	\N	{Travel,utah,Household,Grocery}
2117	5	1	2023-12-03	Costco Whse #0480	-1.63	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
715	6	1	2022-05-15	TARGET 00000794091 FORT COLLINS CO	-38.71	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
716	6	1	2022-05-15	TARGET 00000794091 FORT COLLINS CO	-62.22	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1948	1	1	2023-07-28	TARGET        00017699	-19.23	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
2131	5	1	2023-11-22	Target 00034025	-9.19	2024-01-11 04:43:34.551039+00	\N	{Travel,chicago,Household,Grocery}
2054	1	1	2023-04-21	WHOLEFDS FTC 10147	-9.69	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1088	6	1	2022-12-18	WHOLEFDS FTC 10147 FORT COLLINS CO	-25.46	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
662	6	1	2022-04-29	SAFEWAY #0876 FORT COLLINS CO	-46.74	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
788	6	1	2022-06-14	CENTURYLINK SIMPLE MONROE LA	-65.00	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
107	3	1	2023-09-07	DISCOVER E-PAYMENT 230907 7277 ROCHADEVARGAS V	-98.23	2024-01-09 18:10:05.987144+00	\N	{}
1176	6	1	2023-02-26	KABAB CORNER & GREEK DEL SEATTLE WA	-34.51	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,seattle}
1177	6	1	2023-02-26	ORCA 888-988-6722 WAGOOGLE PAY ENDING IN 9955	-8.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,seattle}
1179	6	1	2023-02-26	BOOKSTORE SEATTLE WA	-7.72	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,seattle}
1180	6	1	2023-02-26	SPACE NEEDLE GIFT SHOP SEATTLE WA	-40.76	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,seattle}
1182	6	1	2023-02-27	ORCA 888-988-6722 WA	-8.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,seattle}
1183	6	1	2023-02-27	ORCA 888-988-6722 WAGOOGLE PAY ENDING IN 9955	-8.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,seattle}
2013	1	1	2023-06-11	WALMART.COM 8009666546	-166.29	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
2019	1	1	2023-06-07	WALMART.COM	-62.17	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
2021	1	1	2023-06-01	WALMART.COM 8009666546	-160.03	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
2034	1	1	2023-05-26	WALMART.COM	-18.34	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
878	6	1	2022-08-03	WALMART SC 02729 FORT COLLINS CO	53.65	2024-01-09 18:17:44.325718+00	Payments and Credits	{Household,Grocery}
884	6	1	2022-08-06	WALMART SC 02729 FORT COLLINS CO	-75.23	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
885	6	1	2022-08-06	WALMART SC 02729 FORT COLLINS CO	53.75	2024-01-09 18:17:44.325718+00	Payments and Credits	{Household,Grocery}
893	6	1	2022-08-11	WALMART.COM AA 800-966-6546 AR	-88.32	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
897	6	1	2022-08-13	WALMART.COM AA 8009666546 AR	-94.68	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
630	6	1	2022-04-09	SPROUTS FARMERS MARSSS FORT COLLINS CO	-15.69	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
245	3	1	2022-12-29	Crowne at Old To Payment XXXXX8424 Vanderlei Rocha De Var	-2190.00	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
264	3	1	2022-11-29	Crowne at Old To Payment XXXXX3312 Vanderlei Rocha De Var	-2190.00	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
111	3	1	2023-08-31	Fox Property Man WEB PMTS 083123 DFVV58 Vanderlei Rocha de Var	-3604.50	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
130	3	1	2023-07-31	Fox Management S WEB PMTS 073123 6R7ZY7 Vanderlei Rocha de Var	-3604.50	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
1791	2	1	2023-09-29	Withdrawal from Fox Property Man WEB PMTS	-3604.50	2024-01-09 18:34:47.445728+00	\N	{Household,Rent}
146	3	1	2023-06-30	Fox Management S WEB PMTS 063023 0T06T7 Vanderlei Rocha de Var	-3604.50	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
298	3	1	2022-09-26	FORTCOLUTILITIES EBILL PAY 220923 7064036 VANDERLEI ROCHA DE VAR	-48.36	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
1261	6	1	2023-05-14	CENTURYLINK LUMEN 800-244-1111 LA001985898282	-40.00	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
843	6	1	2022-07-14	CENTURYLINK SIMPLE MONROE LA	-65.00	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
1160	6	1	2023-02-14	CENTURYLINK LUMEN 800-244-1111 LA000755938903	-40.00	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
957	6	1	2022-09-14	CENTURYLINK SIMPLE MONROE LA	-65.00	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
1038	6	1	2022-11-14	CENTURYLINK SIMPLE MONROE LA	-65.00	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
1078	6	1	2022-12-14	CENTURYLINK LUMEN 800-244-1111 LA000692433300	-40.00	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
1184	6	1	2023-02-27	STARBUCKS 800-782-7282 SEATTLE WAGOOGLE PAY ENDING IN 9955	-25.00	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,seattle}
1185	6	1	2023-02-27	WALGREENS #11856 SEATTLE WA	-6.58	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,seattle}
1016	6	1	2022-10-30	SLEEP INN & SUITES 928-645-2020 AZ	-135.74	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,"las vegas"}
1018	6	1	2022-10-31	SQ *BRIGHT ANGEL BICYC GRAND CANYON AZGOOGLE PAY ENDING IN 99550001152921512106763660	-17.59	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,"las vegas"}
1019	6	1	2022-11-01	BEARIZONA WILDLIFE PARK WILLIAMS AZ	-120.00	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,"las vegas"}
1023	6	1	2022-11-02	BELLAGIO HTL SELF PARK LAS VEGAS NV	-18.00	2024-01-09 18:17:44.325718+00	Services	{Travel,"las vegas"}
1005	6	1	2022-10-29	CNHA - ARCHES NATIONAL P MOAB UTGOOGLE PAY ENDING IN 9955	-6.00	2024-01-09 18:17:44.325718+00	Government Services	{Travel,"las vegas"}
1096	6	1	2022-12-25	WALMART.COM 800-966-6546 ARWIYQTDJK4F90	-52.74	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1099	6	1	2022-12-29	WALMART.COM 8009666546 BENTONVILLE AR	-92.14	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1103	6	1	2023-01-01	WALMART PAY 02729 FORT COLLINS CO	-106.66	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1811	1	1	2023-12-14	WALMART.COM	-132.20	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1815	1	1	2023-12-06	WALMART.COM	-51.25	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1818	1	1	2023-12-03	WALMART.COM	-8.26	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1823	1	1	2023-11-28	WALMART.COM 8009666546	-51.18	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1851	1	1	2023-10-17	WALMART.COM 8009666546	-53.40	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1091	6	1	2022-12-20	KING SOOPERS #0099 FORT COLLINS CO	-73.26	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
1194	6	1	2023-03-02	KING SOOPERS #0099 FORT COLLINS CO	-4.21	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
1196	6	1	2023-03-04	KING SOOPERS #0099 FORT COLLINS CO	-31.01	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
644	6	1	2022-04-19	KING SOOPERS #0018 FT. COLLINS COCASHOVER $ 20.00 PURCHASES $ 32.08	-52.08	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
1027	6	1	2022-11-03	TA/PETRO #331 LAS VEGAS NV	-20.04	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,"las vegas",Auto,Gas}
737	6	1	2022-05-28	EXXONMOBIL RAPID CITY SD	-2.14	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,badlands,Auto,Gas}
2130	5	1	2023-11-23	Costco Gas #0380	-34.75	2024-01-11 04:43:34.551039+00	\N	{Travel,chicago,Auto,Gas}
1006	6	1	2022-10-29	CNHA - CANYONLANDS NATIO MOAB UTGOOGLE PAY ENDING IN 9955	-6.00	2024-01-09 18:17:44.325718+00	Government Services	{Travel,"las vegas"}
1007	6	1	2022-10-29	INN AT THE CANYONS MONTICELLO UT	-93.21	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,"las vegas"}
1010	6	1	2022-10-30	CARL HAYDEN VISITOR CENT PAGE AZGOOGLE PAY ENDING IN 9955	-4.00	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,"las vegas"}
1014	6	1	2022-10-30	MCDONALD'S F31819 PAGE AZ	-9.18	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,"las vegas"}
748	6	1	2022-05-29	DEVILS TOWER TRADING POS DEVILS TOWER WY	-1.99	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,badlands}
31	7	1	2024-01-04	Deposit from Checking XXXXXXX4402	8778.68	2024-01-09 05:13:55.402661+00	\N	{}
741	6	1	2022-05-28	MT RUSHMORE DINING KEYSTONE SD	-7.25	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,badlands}
1858	1	1	2023-10-06	WALMART.COM 8009666546	-83.75	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
742	6	1	2022-05-28	MT RUSHMORE DINING KEYSTONE SD	-12.00	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,badlands}
743	6	1	2022-05-28	MT RUSHMORE GIFT SHOP KEYSTONE SD	-5.29	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,badlands}
744	6	1	2022-05-28	MT RUSHMORE PARKING GARA KEYSTONE SD	-10.00	2024-01-09 18:17:44.325718+00	Services	{Travel,badlands}
1867	1	1	2023-09-26	WALMART.COM	-96.56	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1883	1	1	2023-09-08	WALMART.COM	-35.04	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
696	6	1	2022-05-09	WALMART SC 02729 FORT COLLINS CO	-19.46	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1226	6	1	2023-04-12	WALMART PAY 02729 FORT COLLINS CO	-88.32	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
900	6	1	2022-08-14	WALMART SC 02729 FORT COLLINS CO	-148.61	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
905	6	1	2022-08-21	WALMART SC 02729 FORT COLLINS CO	-73.26	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
610	6	1	2022-03-25	WALMART SC 02729 FORT COLLINS CO	-188.34	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
671	6	1	2022-05-02	WALMART.COM 800-966-6546 AR	-16.00	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
708	6	1	2022-05-13	WALMART SC 02729 FORT COLLINS CO	-376.02	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
726	6	1	2022-05-22	WALMART SC 02729 FORT COLLINS CO	-144.29	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1945	1	1	2023-07-28	KING SOOPERS #0086	-45.30	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1022	6	1	2022-11-01	CIRCA RESORT LAS VEGAS NV	-418.15	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,"las vegas",Hotel}
746	6	1	2022-05-29	BADLANDS NATIONAL PARK INTERIOR SD	-80.00	2024-01-09 18:17:44.325718+00	Government Services	{Travel,badlands}
942	6	1	2022-09-03	AMK PIKES PEAK COMPLEX COLORADO SPGSCO	-8.38	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,"sand dunes"}
944	6	1	2022-09-03	SSA ROYAL GORGE BRIDGE CANON CITY CO	-7.37	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,"sand dunes"}
1043	6	1	2022-11-19	WALMART SC 02729 FORT COLLINS CO	-45.73	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1044	6	1	2022-11-20	WALMART.COM 8009666546 BENTONVILLE AR	-8.15	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1045	6	1	2022-11-21	WALMART GROCERY 800-966-6546 AR	-13.93	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
1106	6	1	2023-01-04	WALMART.COM 8009666546 BENTONVILLE AR	-106.86	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1107	6	1	2023-01-05	WALMART.COM 8009666546 BENTONVILLE AR	-5.00	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1121	6	1	2023-01-13	WALMART PAY 02729 FORT COLLINS CO	-37.50	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1125	6	1	2023-01-15	WALMART PAY 02729 FORT COLLINS CO	-65.11	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
223	3	1	2023-02-13	XCEL ENERGY-PSCO XCELENERGY 00139134914 VANDERLEI ROC468559114	-40.91	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
1723	2	1	2023-12-01	Withdrawal from XCEL ENERGY-PSCO XCELENERGY	-65.16	2024-01-09 18:34:47.445728+00	\N	{Household,Utilities}
1750	2	1	2023-11-15	Withdrawal from XCEL ENERGY-PSCO XCELENERGY	-70.18	2024-01-09 18:34:47.445728+00	\N	{Household,Utilities}
1208	6	1	2023-03-21	WALMART GROCERY 800-966-6546 AR	-13.93	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,switzerland,Household,Grocery}
755	6	1	2022-05-31	KING SOOPERS #0099 FORT COLLINS CO	-38.34	2024-01-09 18:17:44.325718+00	Supermarkets	{Travel,badlands,Household,Grocery}
747	6	1	2022-05-29	DEVILS TOWER NATURAL HIS DEVILS TOWER WY	-6.35	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,badlands}
855	6	1	2022-07-18	KING SOOPERS #0009 FT. COLLINS CO	-72.57	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
606	6	1	2022-03-22	KING SOOPERS #0009 FT. COLLINS CO	-64.52	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
718	6	1	2022-05-17	TARGET 00034165091 FORT COLLINS CO	-38.11	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
798	6	1	2022-06-18	TARGET 00024034091 FORT COLLINS CO	-35.42	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
814	6	1	2022-06-24	TARGET 00034165091 FORT COLLINS CO	-3.98	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
1085	6	1	2022-12-17	TARGET 00034165091 FORT COLLINS CO	-18.55	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
1109	6	1	2023-01-08	TARGET 00032797091 DENVER COGOOGLE PAY ENDING IN 9955	-14.68	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
635	6	1	2022-04-11	TARGET 00034165091 FORT COLLINS CO	-17.81	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
645	6	1	2022-04-19	TARGET 00034165091 FORT COLLINS CO	-18.84	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
1141	6	1	2023-01-30	TARGET 00034165091 FORT COLLINS COGOOGLE PAY ENDING IN 9955	-13.26	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
601	6	1	2022-03-19	TARGET 00000794091 FORT COLLINS CO	-145.09	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
625	6	1	2022-04-04	TARGET 00034165091 FORT COLLINS CO	-40.97	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
626	6	1	2022-04-06	TARGET 00034165091 FORT COLLINS CO	-18.10	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
1875	1	1	2023-09-14	Whole Foods SUP 10445	-16.52	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1885	1	1	2023-09-07	Whole Foods BTM 10785	-8.71	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
2007	1	1	2023-06-14	WHOLEFDS BTM#10785	-3.83	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
2008	1	1	2023-06-14	WHOLEFDS BTM#10785	-12.42	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
2047	1	1	2023-04-26	WHOLEFDS FTC 10147	-34.94	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
979	6	1	2022-10-15	GREEN RIDE CO INC 334 821-3922 CO	-93.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,brazil}
967	6	1	2022-09-22	DOLLARTREE FORT COLLINS CO	-4.03	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,brazil}
968	6	1	2022-09-22	MCDONALD'S F13570 DENVER CO	-5.71	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,brazil}
971	6	1	2022-10-01	GOOGLE *ADS9724932760 CC@GOOGLE.COMCAP0MLOSOH	-94.31	2024-01-09 18:17:44.325718+00	Services	{Travel,brazil}
975	6	1	2022-10-10	SMILE DOCTORS OF COLOR FORT COLLINS CO	-175.00	2024-01-09 18:17:44.325718+00	Medical Services	{Travel,brazil}
773	6	1	2022-06-06	KING SOOPERS #0099 FORT COLLINS CO	-39.77	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
775	6	1	2022-06-07	KING SOOPERS #0099 FORT COLLINS CO	-20.10	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
782	6	1	2022-06-11	KING SOOPERS #0099 FORT COLLINS CO	-65.38	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
162	3	1	2023-05-31	Fox Management S WEB PMTS 053123 RGL4N7 Vanderlei Rocha de Var	-3604.50	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
174	3	1	2023-05-16	Fox Management S WEB PMTS 051623 JGD6M7 Vanderlei Rocha de Var	-1601.11	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
189	3	1	2023-04-18	Fox Management S WEB PMTS 041823 FWLLG7 Vanderlei Rocha de Var	-3595.00	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
1768	2	1	2023-10-31	Withdrawal from Fox Property Man WEB PMTS	-3604.50	2024-01-09 18:34:47.445728+00	\N	{Household,Rent}
290	3	1	2022-10-13	XCEL ENERGY-PSCO XCELENERGY 00139134914 VANDERLEI ROC453315771	-18.56	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
2065	1	1	2023-04-05	CIRCLE K 09859	-28.03	2024-01-09 18:57:47.153366+00	\N	{Auto,Gas}
291	3	1	2022-10-11	DISCOVER E-PAYMENT 221010 7277 ROCHADEVARGAS V	-934.49	2024-01-09 18:10:05.987144+00	\N	{}
292	3	1	2022-10-11	DISCOVER E-PAYMENT 221009 1269 ROCHADEVARGASJUNIS	-180.55	2024-01-09 18:10:05.987144+00	\N	{}
294	3	1	2022-10-07	Mission Lane Vis Mission La ST-T1B1I0S6P7X8 VANDERLEI ROCHA DE VAR	-6.87	2024-01-09 18:10:05.987144+00	\N	{}
297	3	1	2022-09-28	DISCOVER E-PAYMENT 220928 7277 ROCHADEVARGAS V	-104.86	2024-01-09 18:10:05.987144+00	\N	{}
110	3	1	2023-09-01	DISCOVER E-PAYMENT 230901 7277 ROCHADEVARGAS V	-157.38	2024-01-09 18:10:05.987144+00	\N	{}
112	3	1	2023-08-31	CAPITAL ONE TRANSFER RT070FE864B3804 Vanderlei Junior	-200.00	2024-01-09 18:10:05.987144+00	\N	{}
113	3	1	2023-08-31	COLORADO STATE U Payroll 083123 89993-3 ROCHA DE VARGAS JUNIOR	7093.68	2024-01-09 18:10:05.987144+00	\N	{}
114	3	1	2023-08-30	CAPITAL ONE ONLINE PMT 230830 3S92QMDTMQ0U97K VANDERLEI ROCHA DE VAR	-1818.41	2024-01-09 18:10:05.987144+00	\N	{}
763	6	1	2022-06-04	WALMART SC 02729 FORT COLLINS CO	53.65	2024-01-09 18:17:44.325718+00	Payments and Credits	{Household,Grocery}
818	6	1	2022-06-26	WALMART SC 02729 FORT COLLINS CO	-78.32	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
853	6	1	2022-07-17	WALMART SC 02729 FORT COLLINS CO	95.72	2024-01-09 18:17:44.325718+00	Payments and Credits	{Household,Grocery}
870	6	1	2022-07-30	WALMART SC 02729 FORT COLLINS CO	-49.86	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
871	6	1	2022-07-30	WALMART.COM AA 8009666546 AR	-79.85	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1049	6	1	2022-11-22	WALMART.COM 800-966-6546 AR	-39.57	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1900	1	1	2023-08-25	HERTZ #0181011	-266.87	2024-01-09 18:57:47.153366+00	\N	{}
1901	1	1	2023-08-24	COLPARK LOC HQ	-24.00	2024-01-09 18:57:47.153366+00	\N	{}
1902	1	1	2023-08-25	SQ *HUREYA	-10.00	2024-01-09 18:57:47.153366+00	\N	{}
1903	1	1	2023-08-24	SQ *SPICE 6 HYATTSVILL	-26.12	2024-01-09 18:57:47.153366+00	\N	{}
1904	1	1	2023-08-24	CAPTL VISITOR CTR - GI	-14.95	2024-01-09 18:57:47.153366+00	\N	{}
1905	1	1	2023-08-23	AMERICAN METEOROLOGICA	-120.00	2024-01-09 18:57:47.153366+00	\N	{}
1906	1	1	2023-08-22	HANAMI JAPANESE RESTAU	-19.11	2024-01-09 18:57:47.153366+00	\N	{}
1907	1	1	2023-08-23	SQ *SPICE 6 HYATTSVILL	-26.12	2024-01-09 18:57:47.153366+00	\N	{}
1908	1	1	2023-08-23	SQ *CAFE ATRIO	-17.41	2024-01-09 18:57:47.153366+00	\N	{}
92	3	1	2023-09-20	CAPITAL ONE ONLINE PMT 230920 3SDBGG071X2TVDS VANDERLEI ROCHA DE VAR	-83.15	2024-01-09 18:10:05.987144+00	\N	{}
94	3	1	2023-09-15	CAPITAL ONE ONLINE PMT 230915 3SCGANNFJ74IMG0 VANDERLEI ROCHA DE VAR	-379.34	2024-01-09 18:10:05.987144+00	\N	{}
147	3	1	2023-06-30	COLORADO STATE U payroll 063023 89993-3 ROCHA DE VARGAS JUNIOR	5051.04	2024-01-09 18:10:05.987144+00	\N	{}
148	3	1	2023-06-29	DISCOVER E-PAYMENT 230629 7277 ROCHADEVARGAS V	-365.77	2024-01-09 18:10:05.987144+00	\N	{}
149	3	1	2023-06-29	CAPITAL ONE ONLINE PMT 230629 3RVZMTJPRKT45K0 VANDERLEI ROCHA DE VAR	-355.71	2024-01-09 18:10:05.987144+00	\N	{}
108	3	1	2023-09-05	CAPITAL ONE TRANSFER RT01E9500768DE2 Vanderlei Junior	-300.00	2024-01-09 18:10:05.987144+00	\N	{}
109	3	1	2023-09-05	CAPITAL ONE TRANSFER RT093189AEC1E3B Vanderlei Junior	-250.00	2024-01-09 18:10:05.987144+00	\N	{}
2162	5	1	2023-10-24	Costco Gas #0480	-31.02	2024-01-11 04:43:34.551039+00	\N	{Auto,Gas}
151	3	1	2023-06-26	Colorado State U AP Payment 062623 89993 32290140*169.91*169.91*Info: Boone, Austin Danie	169.91	2024-01-09 18:10:05.987144+00	\N	{}
155	3	1	2023-06-15	DISCOVER E-PAYMENT 230615 7277 ROCHADEVARGAS V	-180.80	2024-01-09 18:10:05.987144+00	\N	{}
2164	5	1	2023-10-20	Costco Gas #0480	-37.48	2024-01-11 04:43:34.551039+00	\N	{Auto,Gas}
2168	5	1	2023-10-08	Costco Gas #0480	-38.00	2024-01-11 04:43:34.551039+00	\N	{Auto,Gas}
2171	5	1	2023-10-01	Costco Gas #0440	-28.31	2024-01-11 04:43:34.551039+00	\N	{Auto,Gas}
1130	6	1	2023-01-18	FRONTIER ONLINE DS DENVER CO	-115.92	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,"Flight tickets"}
1746	2	1	2023-11-20	Withdrawal from COMCAST 8497101 401440853	-35.00	2024-01-09 18:34:47.445728+00	\N	{Household,Internet,Utilities}
1304	6	1	2023-07-05	FRONTIER ONLINE DS DENVER CO	-151.92	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,"Flight tickets"}
1055	6	1	2022-11-25	DELTA AIR LINES 18002211212 CA	-533.48	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,"Flight tickets"}
851	6	1	2022-07-17	COPA AIRLINES PANAMA PAN	-1004.57	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,"Flight tickets"}
156	3	1	2023-06-14	CAPITAL ONE MOBILE PMT 230614 3RSU6U9H3CSRORK VANDERLEI ROCHA DE VAR	-263.59	2024-01-09 18:10:05.987144+00	\N	{}
158	3	1	2023-06-08	CAPITAL ONE ONLINE PMT 230608 3RRK8MW3QTP7G2O VANDERLEI ROCHA DE VAR	-671.83	2024-01-09 18:10:05.987144+00	\N	{}
159	3	1	2023-06-08	DISCOVER E-PAYMENT 230608 7277 ROCHADEVARGAS V	-383.97	2024-01-09 18:10:05.987144+00	\N	{}
160	3	1	2023-06-07	COMOTORVEH CO.GO COMOTORVEH 303-534-3468 VANDERLEI ROCHA DE VAR	-476.75	2024-01-09 18:10:05.987144+00	\N	{}
161	3	1	2023-06-07	Mission Lane Vis Mission La ST-K2N9O8X1Z5H5 VANDERLEI ROCHA DE VAR	-16.82	2024-01-09 18:10:05.987144+00	\N	{}
1937	1	1	2023-08-03	WALMART.COM 8009666546	-251.88	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1943	1	1	2023-07-30	WAL-MART #3313	-23.19	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1954	1	1	2023-07-25	WAL-MART #5341	-1.42	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1970	1	1	2023-07-10	WAL-MART #5341	-72.81	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
2031	1	1	2023-05-27	WAL-MART #5341	-102.54	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
2037	1	1	2023-05-22	WAL-MART #5341	-118.49	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
2044	1	1	2023-05-07	WAL-MART #2729	-49.02	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1134	6	1	2023-01-21	WALMART PAY 02729 FORT COLLINS CO	-66.10	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1138	6	1	2023-01-29	WALMART.COM 800-966-6546 ARWMTPSP1F1681	-113.18	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1142	6	1	2023-01-30	WALMART.COM 8009666546 BENTONVILLE AR	-115.22	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1144	6	1	2023-02-03	WALMART PAY 02729 FORT COLLINS CO	-44.82	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
315	3	1	2022-08-31	Crowne at Old To Payment XXXXX0859 Vanderlei Rocha De Var	-2140.00	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
333	3	1	2022-07-29	Crowne at Old To Payment XXXXX7872 Vanderlei Rocha De Var	-2140.00	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
163	3	1	2023-05-31	COLORADO STATE U Payroll 053123 89993-3 ROCHA DE VARGAS JUNIOR	5051.04	2024-01-09 18:10:05.987144+00	\N	{}
164	3	1	2023-05-30	DISCOVER E-PAYMENT 230529 7277 ROCHADEVARGAS V	-666.52	2024-01-09 18:10:05.987144+00	\N	{}
165	3	1	2023-05-30	CAPITAL ONE ONLINE PMT 230527 3RP12J8P9Q7302O VANDERLEI ROCHA DE VAR	-369.70	2024-01-09 18:10:05.987144+00	\N	{}
33	7	1	2023-12-29	Deposit from Checking XXXXXXX4402	4000.00	2024-01-09 05:13:55.402661+00	\N	{}
167	3	1	2023-05-25	CAPITAL ONE MOBILE PMT 230525 3ROLSGFVBJM35I0 SANDRA ROCHA DE VARGAS	-200.00	2024-01-09 18:10:05.987144+00	\N	{}
169	3	1	2023-05-23	CAPITAL ONE ONLINE PMT 230523 3RO6LIEW6QNGKDC VANDERLEI ROCHA DE VAR	-31.60	2024-01-09 18:10:05.987144+00	\N	{}
171	3	1	2023-05-22	DISCOVER E-PAYMENT 230522 7277 ROCHADEVARGAS V	-300.00	2024-01-09 18:10:05.987144+00	\N	{}
172	3	1	2023-05-19	CAPITAL ONE ONLINE PMT 230519 3RNC8AFSSBRGE1S VANDERLEI ROCHA DE VAR	-128.18	2024-01-09 18:10:05.987144+00	\N	{}
191	3	1	2023-04-13	DISCOVER E-PAYMENT 230413 7277 ROCHADEVARGAS V	-288.37	2024-01-09 18:10:05.987144+00	\N	{}
192	3	1	2023-04-13	DISCOVER E-PAYMENT 230413 1269 ROCHADEVARGASJUNIS	-50.00	2024-01-09 18:10:05.987144+00	\N	{}
193	3	1	2023-04-13	BILL PAY Utility Billing Services MOBILE xxxx-xxx-x02-2-C ON 04-13	-29.08	2024-01-09 18:10:05.987144+00	\N	{}
627	6	1	2022-04-08	GILDED GOAT MOUNTAIN FORT COLLINS CO	-2.15	2024-01-09 18:17:44.325718+00	Restaurants	{}
628	6	1	2022-04-08	GILDED GOAT MOUNTAIN FORT COLLINS CO	-8.60	2024-01-09 18:17:44.325718+00	Restaurants	{}
631	6	1	2022-04-09	THE UPS STORE 2718 FORT COLLINS CO	-6.21	2024-01-09 18:17:44.325718+00	Services	{}
1755	2	1	2023-11-08	Deposit from FID BKG SVC LLC MONEYLINE	76.75	2024-01-09 18:34:47.445728+00	\N	{}
945	6	1	2022-09-04	ALTA CONVENIENCE 6122 CANON CITY CO	-34.28	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,"sand dunes",Auto,Gas}
251	3	1	2022-12-27	DISCOVER E-PAYMENT 221224 7277 ROCHADEVARGAS V	-234.03	2024-01-09 18:10:05.987144+00	\N	{}
1145	6	1	2023-02-03	GEICO *AUTO 800-841-3000 DC6103674203000328251752	423.88	2024-01-09 18:17:44.325718+00	Payments and Credits	{Auto,Insurance}
1148	6	1	2023-02-07	SEI 39079 FORT COLLINS CO	-47.88	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
783	6	1	2022-06-11	LOAF N JUG # 0827 FORT COLLINS CO	-40.01	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
943	6	1	2022-09-03	LOAF N JUG # 0827 FORT COLLINS CO	-24.68	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,"sand dunes",Auto,Gas}
946	6	1	2022-09-04	LOAF N JUG #0038 PUEBLO CO	-32.34	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,"sand dunes",Auto,Gas}
2040	1	1	2023-05-17	KING SOOPERS #0099	-47.99	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
2069	1	1	2023-03-29	KING SOOPERS #0099	-75.19	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
883	6	1	2022-08-06	KING SOOPERS #0099 FORT COLLINS CO	-111.24	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
1174	6	1	2023-02-25	TARGET 00027862091 SEATTLE WA	-33.30	2024-01-09 18:17:44.325718+00	Supermarkets	{Travel,seattle,Household,Grocery}
1385	6	1	2023-12-26	MAVERIK #345 GREEN RIVER WY	-23.69	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,utah,Auto,Gas}
1181	6	1	2023-02-26	TARGET 00027862091 SEATTLE WA	-31.02	2024-01-09 18:17:44.325718+00	Supermarkets	{Travel,seattle,Household,Grocery}
992	6	1	2022-10-21	TST* BAR - AVANTI BOUL BOULDER CO00022952009030699129AA	-5.08	2024-01-09 18:17:44.325718+00	Restaurants	{}
1242	6	1	2023-04-22	TARGET 00020297091 GLENWOOD SPRICO	-3.29	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,gleenwood,Household,Grocery}
2179	5	1	2023-06-05	Target 00000489	-18.34	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
1940	1	1	2023-08-01	WHOLEFDS BTM#10785	-19.84	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
2110	5	1	2023-12-07	Exxon Broomfield Plaza #1	-8.27	2024-01-11 04:43:34.551039+00	\N	{Auto,Gas}
1303	6	1	2023-07-04	STATE FARM INSURANCE 800-956-6310 IL	-153.99	2024-01-09 18:17:44.325718+00	Services	{Travel,"new mexico",Auto,Insurance}
924	6	1	2022-08-28	DECO BIKE, LLC. 305-416-7445 FL	-5.30	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,miami}
925	6	1	2022-08-28	DECO BIKE, LLC. 305-416-7445 FL	-5.30	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,miami}
1146	6	1	2023-02-04	STATE FARM INSURANCE 800-956-6310 IL	-163.45	2024-01-09 18:17:44.325718+00	Services	{Auto,Insurance}
1198	6	1	2023-03-04	STATE FARM INSURANCE 800-956-6310 IL	-163.45	2024-01-09 18:17:44.325718+00	Services	{Auto,Insurance}
926	6	1	2022-08-28	MCDONALD'S F20598 MIAMI FL	-10.48	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,miami}
1206	6	1	2023-03-14	CENTURYLINK LUMEN 800-244-1111 LA001838827495	-9.99	2024-01-09 18:17:44.325718+00	Services	{Travel,switzerland,Household,Internet,Utilities}
993	6	1	2022-10-22	RIVERSIDE BOULDER CO	-19.40	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
994	6	1	2022-10-23	E 470 EXPRESS TOLLS AURORA CO	-25.90	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
995	6	1	2022-10-25	GOOGLE *GOOGLE FI G.CO/HELPPAY#CAP0MR3VH2	-29.60	2024-01-09 18:17:44.325718+00	Merchandise	{}
1978	1	1	2023-07-05	BOULDER GAS 2700	-47.85	2024-01-09 18:57:47.153366+00	\N	{Auto,Gas}
996	6	1	2022-10-25	SAMSUNG WWW.SAMSUNG.CO SAMSUNG.COM/UNJ	-17.89	2024-01-09 18:17:44.325718+00	Merchandise	{}
997	6	1	2022-10-26	AMAZON.COM*H06K94FT1 AMZN.COM/BILLWA76GOWXC5IE4	-43.28	2024-01-09 18:17:44.325718+00	Merchandise	{}
998	6	1	2022-10-26	PARKWELL TABOR CENTER DENVER CO	-5.00	2024-01-09 18:17:44.325718+00	Services	{}
999	6	1	2022-10-26	CHEESECAKE 0019 ONEDINE 818-871-3000 CO	-150.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
1974	1	1	2023-07-07	CREDIT-CASH BACK REWARD	22.63	2024-01-09 18:57:47.153366+00	\N	{}
1975	1	1	2023-07-06	WALGREENS #9570	-2.69	2024-01-09 18:57:47.153366+00	\N	{}
1976	1	1	2023-07-06	WALGREENS #9570	-8.41	2024-01-09 18:57:47.153366+00	\N	{}
1977	1	1	2023-07-05	32 MARKET	-2.73	2024-01-09 18:57:47.153366+00	\N	{}
183	3	1	2023-04-28	CAPITAL ONE ONLINE PMT 230428 3RIVZA3V9GV649S VANDERLEI ROCHA DE VAR	-305.60	2024-01-09 18:10:05.987144+00	\N	{}
184	3	1	2023-04-28	COLORADO STATE U Payroll 042823 89993-3 ROCHA DE VARGAS JUNIOR	4815.81	2024-01-09 18:10:05.987144+00	\N	{}
185	3	1	2023-04-27	CAPITAL ONE MOBILE PMT 230427 3RIP1R1F3EMMG0O SANDRA ROCHA DE VARGAS	-294.72	2024-01-09 18:10:05.987144+00	\N	{}
188	3	1	2023-04-20	CAPITAL ONE ONLINE PMT 230420 3RH84D965AJFPK0 VANDERLEI ROCHA DE VAR	-895.87	2024-01-09 18:10:05.987144+00	\N	{}
239	3	1	2023-01-18	CAPITAL ONE CRCARDPMT 230118 3QXS4V19PKRFEHS VANDERLEI ROCHA DE VAR	-80.00	2024-01-09 18:10:05.987144+00	\N	{}
34	7	1	2023-12-29	Withdrawal to Checking XXXXXXX4402	-2000.00	2024-01-09 05:13:55.402661+00	\N	{}
982	6	1	2022-10-17	EMPIRE 3594 FT COLLINS CO	-39.12	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,brazil,Auto,Gas}
2078	6	1	2023-12-29	CASHBACK BONUS REDEMPTION PYMT/STMT CRDT	3.51	2024-01-09 23:00:10.124777+00	Awards and Rebate Credits	{}
2080	6	1	2023-12-29	INTERNET PAYMENT - THANK YOU	55.61	2024-01-09 23:00:10.124777+00	Payments and Credits	{}
2079	6	1	2023-12-29	HIMALAYAN KITCHEN SALT LAKE CITUT	-45.02	2024-01-09 23:00:10.124777+00	Restaurants	{Travel,utah}
2045	1	1	2023-05-02	WALMART.COM 8009666546	-187.73	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1008	6	1	2022-10-29	KUM&GO 0927 NEW CAST NEW CASTLE CO02945R	-23.76	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,"las vegas",Auto,Gas}
1024	6	1	2022-11-03	ARCO #42751 MOAPA NV	-39.46	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,"las vegas",Auto,Gas}
2052	1	1	2023-04-22	QT 4202 OUTSIDE	-18.55	2024-01-09 18:57:47.153366+00	\N	{Travel,gleenwood,Auto,Gas}
753	6	1	2022-05-30	WT GAS & GO LAGRANGE WY	-35.04	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,badlands,Auto,Gas}
2099	5	1	2023-12-27	Costco Gas #0480	-10.20	2024-01-11 04:43:34.551039+00	\N	{Travel,utah,Auto,Gas}
2102	5	1	2023-12-23	Costco Gas #0480	-23.34	2024-01-11 04:43:34.551039+00	\N	{Auto,Gas}
247	3	1	2022-12-28	BILL PAY Utility Billing Services MOBILE xxxxxxxx022C ON 12-28	-25.06	2024-01-09 18:10:05.987144+00	\N	{}
2046	1	1	2023-04-28	CAPITAL ONE ONLINE PYMT	305.60	2024-01-09 18:57:47.153366+00	\N	{}
35	7	1	2023-12-21	Deposit from Checking XXXXXXX4402	111.00	2024-01-09 05:13:55.402661+00	\N	{}
1015	6	1	2022-10-30	MONTICELLO CONOCO MONTICELLO UT	-52.91	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,"las vegas",Auto,Gas}
36	7	1	2023-12-17	Withdrawal to Checking XXXXXXX4402	-100.00	2024-01-09 05:13:55.402661+00	\N	{}
1001	6	1	2022-10-26	LONGMONT TRUCK STOP LONGMONT CO	-28.15	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
1730	2	1	2023-11-29	Deposit from Savings XXXXXXX1843	220.00	2024-01-09 18:34:47.445728+00	\N	{}
1731	2	1	2023-11-28	Deposit from Savings XXXXXXX1843	50.00	2024-01-09 18:34:47.445728+00	\N	{}
1294	6	1	2023-06-19	WALMART.COM 800-966-6546 ARW9VJO0NU0KJH	-238.29	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
241	3	1	2023-01-13	DISCOVER E-PAYMENT 230113 7277 ROCHADEVARGAS V	-783.70	2024-01-09 18:10:05.987144+00	\N	{}
242	3	1	2023-01-06	DISCOVER E-PAYMENT 230106 1269 ROCHADEVARGASJUNIS	-47.39	2024-01-09 18:10:05.987144+00	\N	{}
1296	6	1	2023-06-21	WALMART MEMBERSHIP 800-966-6546 ARW39EGV3T0CRT	-105.99	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
608	6	1	2022-03-24	KING SOOPERS #0018 FT. COLLINS CO	-16.11	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
2091	5	1	2024-01-02	King Soopers #0086	-32.80	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
2106	5	1	2023-12-18	King Soopers #0086	-22.25	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
2107	5	1	2023-12-13	King Soopers #0086	-34.63	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
2108	5	1	2023-12-09	King Soopers #0086	-35.86	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
2159	5	1	2023-10-30	King Soopers #0086	-55.97	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
2161	5	1	2023-10-26	King Soopers #0086	-23.78	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
2163	5	1	2023-10-22	King Soopers #0086	-27.72	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
668	6	1	2022-05-01	KING SOOPERS #0009 FT. COLLINS CO	-87.18	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
674	6	1	2022-05-04	KING SOOPERS #0018 FT. COLLINS CO	-10.97	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
691	6	1	2022-05-08	KING SOOPERS #0018 FT. COLLINS COCASHOVER $ 60.00 PURCHASES $ 75.76	-135.76	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
1042	6	1	2022-11-18	WALMART SC 02729 FORT COLLINS CO	-127.06	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1117	6	1	2023-01-12	WALMART PAY 02729 FORT COLLINS CO	-76.01	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
837	6	1	2022-07-09	KING SOOPERS #0099 FORT COLLINS CO	-47.66	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
1063	6	1	2022-12-02	KING SOOPERS #0099 FORT COLLINS CO	-50.93	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
785	6	1	2022-06-12	KING SOOPERS #0099 FORT COLLINS CO	-3.06	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
792	6	1	2022-06-15	KING SOOPERS #0099 FORT COLLINS CO	-55.05	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
801	6	1	2022-06-19	KING SOOPERS #0009 FT. COLLINS CO	-17.20	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
802	6	1	2022-06-19	KING SOOPERS #0009 FT. COLLINS CO	-40.39	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
115	3	1	2023-08-30	DISCOVER E-PAYMENT 230830 7277 ROCHADEVARGAS V	-104.51	2024-01-09 18:10:05.987144+00	\N	{}
811	6	1	2022-06-22	KING SOOPERS #0099 FORT COLLINS CO	-78.68	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
817	6	1	2022-06-25	KING SOOPERS #0099 FORT COLLINS CO	-6.93	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
827	6	1	2022-07-01	KING SOOPERS #0099 FORT COLLINS CO	-50.45	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
829	6	1	2022-07-02	KING SOOPERS #0099 FORT COLLINS CO	-1.25	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
830	6	1	2022-07-02	KING SOOPERS #0099 FORT COLLINS CO	-35.21	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
833	6	1	2022-07-04	KING SOOPERS #0099 FORT COLLINS CO	-92.93	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
840	6	1	2022-07-12	KING SOOPERS #0009 FT. COLLINS CO	-50.46	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
217	3	1	2023-02-23	CAPITAL ONE MOBILE PMT 230223 3R5EUZUR9LGEAHK SANDRA ROCHA DE VARGAS	-200.00	2024-01-09 18:10:05.987144+00	\N	{}
218	3	1	2023-02-21	DISCOVER E-PAYMENT 230220 7277 ROCHADEVARGAS V	-251.87	2024-01-09 18:10:05.987144+00	\N	{}
220	3	1	2023-02-15	MOBILE DEPOSIT : REF NUMBER :112150116472	29.12	2024-01-09 18:10:05.987144+00	\N	{}
221	3	1	2023-02-14	DISCOVER E-PAYMENT 230214 7277 ROCHADEVARGAS V	-1083.17	2024-01-09 18:10:05.987144+00	\N	{}
222	3	1	2023-02-13	CAPITAL ONE MOBILE PMT 230213 3R3AZIS19106CGO SANDRA ROCHA DE VARGAS	-270.39	2024-01-09 18:10:05.987144+00	\N	{}
116	3	1	2023-08-29	CAPITAL ONE TRANSFER RT0A4D6F35D5349 Vanderlei Junior	-250.00	2024-01-09 18:10:05.987144+00	\N	{}
243	3	1	2023-01-06	CAPITAL ONE MOBILE PMT 230105 3QV2O4C733YYH08 SANDRA ROCHA DE VARGAS	-243.31	2024-01-09 18:10:05.987144+00	\N	{}
244	3	1	2022-12-30	COLORADO STATE U Payroll 123022 89993-3 ROCHA DE VARGAS JUNIOR	4748.46	2024-01-09 18:10:05.987144+00	\N	{}
246	3	1	2022-12-28	DISCOVER E-PAYMENT 221228 7277 ROCHADEVARGAS V	-196.83	2024-01-09 18:10:05.987144+00	\N	{}
224	3	1	2023-02-10	DISCOVER E-PAYMENT 230210 1269 ROCHADEVARGASJUNIS	-35.65	2024-01-09 18:10:05.987144+00	\N	{}
225	3	1	2023-02-07	DISCOVER E-PAYMENT 230207 1269 ROCHADEVARGASJUNIS	-30.00	2024-01-09 18:10:05.987144+00	\N	{}
226	3	1	2023-02-07	Mission Lane Vis Mission La ST-S5N7Y7Z4L1W2 VANDERLEI ROCHA DE VAR	-134.44	2024-01-09 18:10:05.987144+00	\N	{}
861	6	1	2022-07-21	EMPIRE 3591 FORT COLLINS CO	-51.28	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,"dutch george",Auto,Gas}
1011	6	1	2022-10-30	CIRCLE K 00583 PAGE AZ03078R	-31.40	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,"las vegas",Auto,Gas}
1009	6	1	2022-10-29	QT 4202 OUTSIDE FIRESTONE CO0420202TCPA4NNJ	-11.73	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,"las vegas",Auto,Gas}
2092	5	1	2024-01-01	Exxon Broomfield Plaza #1	-15.99	2024-01-11 04:43:34.551039+00	\N	{Auto,Gas}
2085	5	1	2024-01-10	King Soopers #0086	-24.54	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
2071	1	1	2023-03-25	98612 XXXLUTZ FELDKIRC	-14.16	2024-01-09 18:57:47.153366+00	\N	{Travel,switzerland}
2072	1	1	2023-03-25	INTERSPAR DANKT 8840	-27.96	2024-01-09 18:57:47.153366+00	\N	{Travel,switzerland}
2073	1	1	2023-03-19	Bill in Pivovarsky klu	-70.72	2024-01-09 18:57:47.153366+00	\N	{Travel,switzerland}
2119	5	1	2023-12-02	King Soopers #0086	-32.08	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
2123	5	1	2023-11-26	King Soopers #0086	-25.05	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
2149	5	1	2023-11-06	King Soopers #0086	5.72	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
2151	5	1	2023-11-04	King Soopers #0086	-44.71	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
305	3	1	2022-09-14	PURCHASE AUTHORIZED ON 09/12 HILTON FT COLLNS P FORT COLLINS CO S382255762811369 CARD 4174	-2.00	2024-01-09 18:10:05.987144+00	\N	{Travel,Hotel}
306	3	1	2022-09-14	PURCHASE AUTHORIZED ON 09/12 HILTON FT COLLNS P FORT COLLINS CO S302255646849480 CARD 4174	-6.00	2024-01-09 18:10:05.987144+00	\N	{Travel,Hotel}
879	6	1	2022-08-04	LOAF N JUG # 0827 FORT COLLINS CO	-46.36	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
248	3	1	2022-12-27	DISCOVER E-PAYMENT 221227 1269 ROCHADEVARGASJUNIS	-74.93	2024-01-09 18:10:05.987144+00	\N	{}
794	6	1	2022-06-16	LOAF N JUG # 0827 FORT COLLINS CO	-35.03	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
828	6	1	2022-07-01	LOAF N JUG # 0827 FORT COLLINS CO	-52.45	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
249	3	1	2022-12-27	CAPITAL ONE ONLINE PMT 221224 3N2HM9SSF3U1G68 VANDERLEI ROCHA DE VAR	-800.00	2024-01-09 18:10:05.987144+00	\N	{}
874	6	1	2022-08-02	LOAF N JUG # 0827 FORT COLLINS CO	-36.85	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
1084	6	1	2022-12-17	LOAF N JUG # 0810 FORT COLLINS CO	-33.59	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
2177	5	1	2023-07-02	Cash Back Credit	0.28	2024-01-11 04:43:34.551039+00	\N	{}
2180	5	1	2023-03-02	Cash Back Credit	1.52	2024-01-11 04:43:34.551039+00	\N	{}
1798	1	1	2024-01-07	WAL-MART #5341	-37.45	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1961	1	1	2023-07-18	WALMART.COM 8009666546	-15.01	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1971	1	1	2023-07-09	WALMART.COM 8009666546	-216.64	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
2155	5	1	2023-10-31	Costco Whse #0480	-400.75	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
2156	5	1	2023-10-31	Costco Whse #0480	-3.26	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
2166	5	1	2023-10-09	Costco Whse #0480	-107.54	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
2167	5	1	2023-10-09	Costco Whse #0480	-1.63	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
2172	5	1	2023-10-01	Costco Whse #0440	-81.06	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
2174	5	1	2023-09-27	Costco Whse #0440	-291.67	2024-01-11 04:43:34.551039+00	\N	{Household,Grocery}
1699	2	1	2024-01-02	Withdrawal from Fox Property Man WEB PMTS	-3604.50	2024-01-09 18:34:47.445728+00	\N	{Household,Rent}
1725	2	1	2023-11-30	Withdrawal from Fox Property Man WEB PMTS	-3604.50	2024-01-09 18:34:47.445728+00	\N	{Household,Rent}
152	3	1	2023-06-20	XCEL ENERGY-PSCO XCELENERGY 00139134914 VANDERLEI ROC485215877	-37.60	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
303	3	1	2022-09-15	PURCHASE AUTHORIZED ON 09/13 HILTON FT COLLNS P FORT COLLINS CO S462256774974357 CARD 4174	-2.00	2024-01-09 18:10:05.987144+00	\N	{Travel,Hotel}
304	3	1	2022-09-15	PURCHASE AUTHORIZED ON 09/13 HILTON FT COLLNS P FORT COLLINS CO S582256658675491 CARD 4174	-6.00	2024-01-09 18:10:05.987144+00	\N	{Travel,Hotel}
269	3	1	2022-11-22	BILL PAY Utility Billing Services MOBILE xxxxxxxx022C ON 11-22	-24.86	2024-01-09 18:10:05.987144+00	\N	{}
238	3	1	2023-01-19	DISCOVER E-PAYMENT 230119 7277 ROCHADEVARGAS V	-1303.13	2024-01-09 18:10:05.987144+00	\N	{}
1799	1	1	2024-01-06	WM SUPERCENTER #5341	-66.66	2024-01-09 18:57:47.153366+00	\N	{}
250	3	1	2022-12-27	CAPITAL ONE MOBILE PMT 221226 3N2Y9X1NN0VRHJS SANDRA ROCHA DE VARGAS	-250.00	2024-01-09 18:10:05.987144+00	\N	{}
154	3	1	2023-06-16	XCEL ENERGY-PSCO XCELENERGY 00139134914 VANDERLEI ROC484923516	-11.53	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
1710	2	1	2023-12-18	Withdrawal from COMCAST 8497101 401440853	-35.00	2024-01-09 18:34:47.445728+00	\N	{Household,Internet,Utilities}
88	3	1	2023-10-18	COMCAST 8497101 401440853 231017 3274095 VANDERLEI *ROCHA DE VA	-35.00	2024-01-09 18:10:05.987144+00	\N	{Household,Internet,Utilities}
93	3	1	2023-09-18	COMCAST 8497101 401440853 230917 4604631 VANDERLEI *ROCHA DE VA	-35.00	2024-01-09 18:10:05.987144+00	\N	{Household,Internet,Utilities}
76	7	2	2023-09-12	Saving - Preauthorized Deposit from WELLS FARGO BANK NA checking account XXXXXX1165	1000.00	2024-01-09 05:15:00.412025+00	\N	{}
317	3	1	2022-08-29	DISCOVER E-PAYMENT 220829 7277 ROCHADEVARGAS V	-305.80	2024-01-09 18:10:05.987144+00	\N	{}
751	6	1	2022-05-29	PIZZA HUT 035930 NEWCASTLE WY	-26.00	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,badlands}
754	6	1	2022-05-31	AMZN MKTP US*1X0985J52 AMZN.COM/BILLWA1T3J3OX6EU8	-122.59	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,badlands}
121	3	1	2023-08-18	COMCAST 8497101 401440853 230817 6120122 VANDERLEI *ROCHA DE VA	-35.00	2024-01-09 18:10:05.987144+00	\N	{Household,Internet,Utilities}
138	3	1	2023-07-18	COMCAST 8497101 401440853 230717 7663622 VANDERLEI *ROCHA DE VA	-35.00	2024-01-09 18:10:05.987144+00	\N	{Household,Internet,Utilities}
153	3	1	2023-06-20	COMCAST 8497101 401440853 230617 9606454 VANDERLEI *ROCHA DE VA	-10.27	2024-01-09 18:10:05.987144+00	\N	{Household,Internet,Utilities}
150	3	1	2023-06-28	FORTCOLUTILITIES EBILL PAY 230627 2137973 VANDERLEI ROCHA DE VAR	53.58	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
157	3	1	2023-06-09	FORTCOLUTILITIES EBILL PAY 230608 7324879 VANDERLEI ROCHA DE VAR	-88.25	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
170	3	1	2023-05-23	FORTCOLUTILITIES EBILL PAY 230522 2780468 VANDERLEI ROCHA DE VAR	-53.58	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
187	3	1	2023-04-24	FORTCOLUTILITIES EBILL PAY 230421 4586606 VANDERLEI ROCHA DE VAR	-42.16	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
1847	1	1	2023-10-30	GOOGLE *FI DF23PJ	-158.26	2024-01-09 18:57:47.153366+00	\N	{Household,Internet,Utilities}
1319	6	1	2023-07-30	GOOGLE *FI PF7WH5 G.CO/HELPPAY#CAP0TMK6L8	-157.80	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
1344	6	1	2023-08-30	GOOGLE *FI NDWQWX G.CO/HELPPAY#CAP0UCCKR6	-157.38	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
308	3	1	2022-09-08	DISCOVER E-PAYMENT 220908 1269 ROCHADEVARGASJUNIS	-221.45	2024-01-09 18:10:05.987144+00	\N	{}
309	3	1	2022-09-07	DISCOVER E-PAYMENT 220907 7277 ROCHADEVARGAS V	-137.26	2024-01-09 18:10:05.987144+00	\N	{}
1775	2	1	2023-10-19	Preauthorized Withdrawal to WELLS FARGO BANK NA checking account XXXXXX1493	-274.00	2024-01-09 18:34:47.445728+00	\N	{}
1838	1	1	2023-11-16	KING SOOPERS #0086	-84.11	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
216	3	1	2023-02-24	FORTCOLUTILITIES EBILL PAY 230223 0671108 VANDERLEI ROCHA DE VAR	-55.35	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
234	3	1	2023-01-24	FORTCOLUTILITIES EBILL PAY 230123 5307227 VANDERLEI ROCHA DE VAR	-61.87	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
310	3	1	2022-09-07	Mission Lane Vis Mission La ST-R1B6I1O1O2N9 VANDERLEI ROCHA DE VAR	-18.34	2024-01-09 18:10:05.987144+00	\N	{}
311	3	1	2022-09-06	DISCOVER E-PAYMENT 220905 7277 ROCHADEVARGAS V	-192.45	2024-01-09 18:10:05.987144+00	\N	{}
272	3	1	2022-11-15	Colorado State U AP Payment 111522 89993 T-161048 Info: hknutson@colostate.edu 970-491-82	1386.45	2024-01-09 18:10:05.987144+00	\N	{}
275	3	1	2022-11-07	DISCOVER E-PAYMENT 221107 7277 ROCHADEVARGAS V	-720.54	2024-01-09 18:10:05.987144+00	\N	{}
276	3	1	2022-11-07	DISCOVER E-PAYMENT 221105 7277 ROCHADEVARGAS V	-1072.87	2024-01-09 18:10:05.987144+00	\N	{}
277	3	1	2022-11-07	DISCOVER E-PAYMENT 221105 1269 ROCHADEVARGASJUNIS	-263.80	2024-01-09 18:10:05.987144+00	\N	{}
61	7	2	2023-12-29	Deposit from Checking XXXXXXX4330	221.53	2024-01-09 05:15:00.412025+00	\N	{}
62	7	2	2023-12-28	Deposit from Checking XXXXXXX4330	2000.00	2024-01-09 05:15:00.412025+00	\N	{}
339	3	1	2022-07-21	PURCHASE AUTHORIZED ON 07/19 GOOGLE *Domains g.co/helppay# CA S582201123041292 CARD 4174	-7.00	2024-01-09 18:10:05.987144+00	\N	{}
1836	1	1	2023-11-17	WWW.WENDELLABOATS.COM	-54.00	2024-01-09 18:57:47.153366+00	\N	{}
1837	1	1	2023-11-18	360 Chicago	-90.00	2024-01-09 18:57:47.153366+00	\N	{Travel,chicago}
1839	1	1	2023-11-14	CAPITAL ONE ONLINE PYMT	82.82	2024-01-09 18:57:47.153366+00	\N	{}
1862	1	1	2023-09-30	WAL-MART #2223	-40.85	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1863	1	1	2023-09-30	WAL-MART #2223	-14.72	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
970	6	1	2022-09-30	GOOGLE *FI JKZMWX G.CO/HELPPAY#CAP0MJDMZK	-125.42	2024-01-09 18:17:44.325718+00	Services	{Travel,brazil,Household,Internet,Utilities}
1140	6	1	2023-01-30	GOOGLE *FI HB8MV5 G.CO/HELPPAY#CAP0PAA8SP	-119.83	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
1282	6	1	2023-05-30	GOOGLE *FI 4WG24V G.CO/HELPPAY#CAP0SARNX0	-158.13	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
1957	1	1	2023-07-21	CENTURY THEATRES 492	-8.03	2024-01-09 18:57:47.153366+00	\N	{Household,Internet,Utilities}
2058	1	1	2023-04-18	BKGHOTEL AT BOOKING.C	-163.19	2024-01-09 18:57:47.153366+00	\N	{Travel,Hotel}
2105	5	1	2023-12-19	Bkghotel At Booking.c	-391.06	2024-01-11 04:43:34.551039+00	\N	{Travel,Hotel}
931	6	1	2022-08-30	BKGBOOKING.COM HOTEL 470-363-2501 NY	-81.39	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,Hotel}
278	3	1	2022-11-07	ATM CASH DEPOSIT ON 11/06 460 S College Ave Fort Collins CO 0001668 ATM ID 7360M CARD 4174	2.00	2024-01-09 18:10:05.987144+00	\N	{}
279	3	1	2022-11-07	ATM CASH DEPOSIT ON 11/06 460 S College Ave Fort Collins CO 0001667 ATM ID 7360M CARD 4174	511.00	2024-01-09 18:10:05.987144+00	\N	{}
280	3	1	2022-11-04	MOBILE DEPOSIT : REF NUMBER :819040110420	2500.00	2024-01-09 18:10:05.987144+00	\N	{}
1840	1	1	2023-11-11	WM SUPERCENTER #5341	-82.82	2024-01-09 18:57:47.153366+00	\N	{}
281	3	1	2022-10-31	COLORADO STATE U Payroll 103122 89993-3 ROCHA DE VARGAS JUNIOR	4799.99	2024-01-09 18:10:05.987144+00	\N	{}
282	3	1	2022-10-28	DISCOVER E-PAYMENT 221028 7277 ROCHADEVARGAS V	-207.99	2024-01-09 18:10:05.987144+00	\N	{}
284	3	1	2022-10-24	DISCOVER E-PAYMENT 221023 1269 ROCHADEVARGASJUNIS	-242.36	2024-01-09 18:10:05.987144+00	\N	{}
1012	6	1	2022-10-30	GOOGLE *FI G989W9 G.CO/HELPPAY#CAP0MYRF2R	-124.86	2024-01-09 18:17:44.325718+00	Services	{Travel,"las vegas",Household,Internet,Utilities}
286	3	1	2022-10-21	DISCOVER E-PAYMENT 221021 7277 ROCHADEVARGAS V	-842.72	2024-01-09 18:10:05.987144+00	\N	{}
287	3	1	2022-10-20	DISCOVER E-PAYMENT 221020 1269 ROCHADEVARGASJUNIS	-97.03	2024-01-09 18:10:05.987144+00	\N	{}
288	3	1	2022-10-19	ATM WITHDRAWAL AUTHORIZED ON 10/19 623 S Broadway St Boulder CO 0002947 ATM ID 3129C CARD 4174	-40.00	2024-01-09 18:10:05.987144+00	\N	{}
289	3	1	2022-10-17	DISCOVER E-PAYMENT 221015 7277 ROCHADEVARGAS V	-1327.06	2024-01-09 18:10:05.987144+00	\N	{}
293	3	1	2022-10-11	Colorado State U AP Payment 101122 89993 T-160257 Info: hknutson@colostate.edu 970-491-82	16.00	2024-01-09 18:10:05.987144+00	\N	{}
296	3	1	2022-09-30	COLORADO STATE U Payroll 093022 89993-3 ROCHA DE VARGAS JUNIOR	4799.98	2024-01-09 18:10:05.987144+00	\N	{}
299	3	1	2022-09-21	DISCOVER E-PAYMENT 220921 7277 ROCHADEVARGAS V	-204.18	2024-01-09 18:10:05.987144+00	\N	{}
300	3	1	2022-09-20	DISCOVER E-PAYMENT 220920 1269 ROCHADEVARGASJUNIS	-59.62	2024-01-09 18:10:05.987144+00	\N	{}
1701	2	1	2023-12-30	Withdrawal from CAPITAL ONE ONLINE PMT	-141.79	2024-01-09 18:34:47.445728+00	\N	{}
1909	1	1	2023-08-21	MCDONALD'S F13570	-5.08	2024-01-09 18:57:47.153366+00	\N	{}
301	3	1	2022-09-20	CAPITAL ONE CRCARDPMT 220918 3MI0RFGMGMND540 VANDERLEI ROCHA DE VAR	-39.59	2024-01-09 18:10:05.987144+00	\N	{}
302	3	1	2022-09-19	DISCOVER E-PAYMENT 220917 7277 ROCHADEVARGAS V	-336.53	2024-01-09 18:10:05.987144+00	\N	{}
312	3	1	2022-09-01	DISCOVER E-PAYMENT 220901 7277 ROCHADEVARGAS V	-226.60	2024-01-09 18:10:05.987144+00	\N	{}
313	3	1	2022-09-01	Colorado State U AP Payment 090122 89993 T-156639 Info: hknutson@colostate.edu 970-491-82	284.76	2024-01-09 18:10:05.987144+00	\N	{}
314	3	1	2022-08-31	DISCOVER E-PAYMENT 220831 7277 ROCHADEVARGAS V	-699.59	2024-01-09 18:10:05.987144+00	\N	{}
316	3	1	2022-08-31	COLORADO STATE U Payroll 083122 89993-3 ROCHA DE VARGAS JUNIOR	4799.99	2024-01-09 18:10:05.987144+00	\N	{}
59	7	1	2023-08-30	Preauthorized Deposit from WELLS FARGO BANK NA checking account XXXXXX1493	200.00	2024-01-09 05:13:55.402661+00	\N	{}
1910	1	1	2023-08-21	TST* Taqueria Habanero	-17.25	2024-01-09 18:57:47.153366+00	\N	{}
1911	1	1	2023-08-21	LIDL #1159	-15.96	2024-01-09 18:57:47.153366+00	\N	{}
1929	1	1	2023-08-09	MARKLEY MOTORS	-73.95	2024-01-09 18:57:47.153366+00	\N	{Auto,Maintenance}
336	3	1	2022-07-27	BILL PAY Utility Billing Services MOBILE xxxxxxxx022C ON 07-27	-48.61	2024-01-09 18:10:05.987144+00	\N	{}
63	7	2	2023-12-05	Deposit from Checking XXXXXXX4330	8000.00	2024-01-09 05:15:00.412025+00	\N	{}
64	7	2	2023-12-01	Withdrawal to CD 18 Months 5.00 XXXXXXX7004	-20000.00	2024-01-09 05:15:00.412025+00	\N	{}
66	7	2	2023-11-29	Deposit from 360 Checking XXXXXXX4330	1000.00	2024-01-09 05:15:00.412025+00	\N	{}
68	7	2	2023-10-30	Deposit from 360 Checking XXXXXXX4330	1500.00	2024-01-09 05:15:00.412025+00	\N	{}
69	7	2	2023-10-28	Deposit from 360 Checking XXXXXXX4330	800.00	2024-01-09 05:15:00.412025+00	\N	{}
70	7	2	2023-10-14	Deposit from 360 Checking XXXXXXX4330	551.11	2024-01-09 05:15:00.412025+00	\N	{}
71	7	2	2023-10-03	Deposit from 360 Checking XXXXXXX4330	7589.44	2024-01-09 05:15:00.412025+00	\N	{}
72	7	2	2023-10-02	Preauthorized Deposit from WELLS FARGO BANK NA checking account XXXXXX1165	2500.00	2024-01-09 05:15:00.412025+00	\N	{}
74	7	2	2023-09-20	Preauthorized Deposit from WELLS FARGO BANK NA checking account XXXXXX1165	5000.00	2024-01-09 05:15:00.412025+00	\N	{}
75	7	2	2023-09-14	Deposit from 360 Checking XXXXXXX4330	500.00	2024-01-09 05:15:00.412025+00	\N	{}
332	3	1	2022-07-29	DISCOVER E-PAYMENT 220729 7277 ROCHADEVARGAS V	-118.04	2024-01-09 18:10:05.987144+00	\N	{}
334	3	1	2022-07-29	COLORADO STATE U Payroll 072922 89993-3 ROCHA DE VARGAS JUNIOR	1840.06	2024-01-09 18:10:05.987144+00	\N	{}
335	3	1	2022-07-28	DISCOVER E-PAYMENT 220728 7277 ROCHADEVARGAS V	-528.04	2024-01-09 18:10:05.987144+00	\N	{}
81	8	2	2023-12-01	Deposit from Savings XXXXXXX5850	20000.00	2024-01-09 05:16:32.935013+00	\N	{}
84	8	1	2023-11-28	Deposit from Savings XXXXXXX1843	20000.00	2024-01-09 05:16:45.322177+00	\N	{}
338	3	1	2022-07-25	CAPITAL ONE ONLINE PMT 220724 3M68MII3B6OPC80 VANDERLEI ROCHA DE VAR	-279.20	2024-01-09 18:10:05.987144+00	\N	{}
1917	1	1	2023-08-15	CAPITAL ONE ONLINE PYMT	310.18	2024-01-09 18:57:47.153366+00	\N	{}
1918	1	1	2023-08-13	THE HOME DEPOT #1506	-10.75	2024-01-09 18:57:47.153366+00	\N	{}
2115	5	1	2023-12-03	Costco Gas #0480	-28.22	2024-01-11 04:43:34.551039+00	\N	{Auto,Gas}
78	7	2	2023-08-28	Preauthorized Deposit from WELLS FARGO BANK NA checking account XXXXXX1165	200.00	2024-01-09 05:15:00.412025+00	\N	{}
1738	2	1	2023-11-23	Deposit from 360 Performance Savings XXXXXXX1843	430.00	2024-01-09 18:34:47.445728+00	\N	{}
37	7	1	2023-12-08	Withdrawal to Checking XXXXXXX4402	-220.00	2024-01-09 05:13:55.402661+00	\N	{}
38	7	1	2023-12-01	Deposit from Checking XXXXXXX4402	620.00	2024-01-09 05:13:55.402661+00	\N	{}
58	7	1	2023-08-31	Monthly Interest Paid	0.02	2024-01-09 05:13:55.402661+00	\N	{}
1204	6	1	2023-03-09	MCDONALD'S F13570 DENVER CO	-3.72	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,switzerland}
60	7	2	2023-12-31	Monthly Interest Paid	29.06	2024-01-09 05:15:00.412025+00	\N	{}
65	7	2	2023-11-30	Monthly Interest Paid	68.55	2024-01-09 05:15:00.412025+00	\N	{}
1829	1	1	2023-11-22	MCDONALD'S F28291	-5.23	2024-01-09 18:57:47.153366+00	\N	{Travel,chicago}
1923	1	1	2023-08-12	WAL-MART #0905	-36.24	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1921	1	1	2023-08-12	WALMART.COM 8009666546	-79.85	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
930	6	1	2022-08-29	WALMART SC 02729 FORT COLLINS CO	-188.40	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
40	7	1	2023-11-29	Deposit from Checking XXXXXXX4402	2000.00	2024-01-09 05:13:55.402661+00	\N	{}
41	7	1	2023-11-29	Withdrawal to Checking XXXXXXX4402	-220.00	2024-01-09 05:13:55.402661+00	\N	{}
208	3	1	2023-03-08	CAPITAL ONE MOBILE PMT 230308 3R85K9FSA4VDEAG SANDRA ROCHA DE VARGAS	-150.00	2024-01-09 18:10:05.987144+00	\N	{}
209	3	1	2023-03-07	DISCOVER E-PAYMENT 230307 7277 ROCHADEVARGAS V	-1665.79	2024-01-09 18:10:05.987144+00	\N	{}
210	3	1	2023-03-03	CAPITAL ONE MOBILE PMT 230303 3R73G2MNU4IT860 SANDRA ROCHA DE VARGAS	-209.96	2024-01-09 18:10:05.987144+00	\N	{}
205	3	1	2023-03-17	DISCOVER E-PAYMENT 230317 7277 ROCHADEVARGAS V	-314.19	2024-01-09 18:10:05.987144+00	\N	{}
214	3	1	2023-02-28	COLORADO STATE U Payroll 022823 89993-3 ROCHA DE VARGAS JUNIOR	4784.70	2024-01-09 18:10:05.987144+00	\N	{}
1716	2	1	2023-12-08	Deposit from Savings XXXXXXX1843	220.00	2024-01-09 18:34:47.445728+00	\N	{}
1808	1	1	2023-12-24	WM SUPERCENTER #4288	-60.90	2024-01-09 18:57:47.153366+00	\N	{}
1809	1	1	2023-12-21	CAPITAL ONE ONLINE PYMT	212.74	2024-01-09 18:57:47.153366+00	\N	{}
1810	1	1	2023-12-16	WM SUPERCENTER #4288	-17.68	2024-01-09 18:57:47.153366+00	\N	{}
1812	1	1	2023-12-10	SQ *GELATO BOY	-7.86	2024-01-09 18:57:47.153366+00	\N	{}
1814	1	1	2023-12-08	CAPITAL ONE ONLINE PYMT	47.23	2024-01-09 18:57:47.153366+00	\N	{}
1816	1	1	2023-12-06	CREDIT-CASH BACK REWARD	4.02	2024-01-09 18:57:47.153366+00	\N	{}
1817	1	1	2023-12-05	CAPITAL ONE ONLINE PYMT	39.37	2024-01-09 18:57:47.153366+00	\N	{}
1820	1	1	2023-12-02	CAPITAL ONE ONLINE PYMT	219.09	2024-01-09 18:57:47.153366+00	\N	{}
1821	1	1	2023-11-30	CANTEEN VENDING	-1.35	2024-01-09 18:57:47.153366+00	\N	{}
1824	1	1	2023-11-27	CHICK-FIL-A #1290	-18.32	2024-01-09 18:57:47.153366+00	\N	{}
1825	1	1	2023-11-28	CREDIT-CASH BACK REWARD	10.02	2024-01-09 18:57:47.153366+00	\N	{}
1826	1	1	2023-11-27	CAPITAL ONE ONLINE PYMT	74.07	2024-01-09 18:57:47.153366+00	\N	{}
1827	1	1	2023-11-24	WM SUPERCENTER #5341	-68.84	2024-01-09 18:57:47.153366+00	\N	{}
1828	1	1	2023-11-23	CAPITAL ONE ONLINE PYMT	116.85	2024-01-09 18:57:47.153366+00	\N	{}
1832	1	1	2023-11-21	CAPITAL ONE ONLINE PYMT	257.52	2024-01-09 18:57:47.153366+00	\N	{}
2173	5	1	2023-09-28	Payment - Thank You	586.70	2024-01-11 04:43:34.551039+00	\N	{}
1850	1	1	2023-10-18	UCHEALTH	-258.00	2024-01-09 18:57:47.153366+00	\N	{}
67	7	2	2023-10-31	Monthly Interest Paid	59.71	2024-01-09 05:15:00.412025+00	\N	{}
83	8	1	2023-12-27	Monthly Interest Paid	80.37	2024-01-09 05:16:45.322177+00	\N	{}
77	7	2	2023-08-31	Monthly Interest Paid	0.07	2024-01-09 05:15:00.412025+00	\N	{}
1240	6	1	2023-04-22	MARSHALLS #1433 GLENWOOD SPRICO	-6.61	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,gleenwood}
1241	6	1	2023-04-22	STARBUCKS 800-782-7282 SEATTLE WAGOOGLE PAY ENDING IN 9955	-25.00	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,gleenwood}
1852	1	1	2023-10-17	CAPITAL ONE ONLINE PYMT	148.55	2024-01-09 18:57:47.153366+00	\N	{}
1853	1	1	2023-10-15	WM SUPERCENTER #4288	-144.82	2024-01-09 18:57:47.153366+00	\N	{}
1854	1	1	2023-10-15	SQ *CAFE #65141 BOULDE	-3.73	2024-01-09 18:57:47.153366+00	\N	{}
1855	1	1	2023-10-11	CREDIT-CASH BACK REWARD	26.91	2024-01-09 18:57:47.153366+00	\N	{}
1856	1	1	2023-10-11	CAPITAL ONE ONLINE PYMT	86.97	2024-01-09 18:57:47.153366+00	\N	{}
1857	1	1	2023-10-08	TST* Rosetta Hall - Bo	-10.67	2024-01-09 18:57:47.153366+00	\N	{}
1859	1	1	2023-10-03	CO STATE UNIVERSITY	-19.46	2024-01-09 18:57:47.153366+00	\N	{}
1860	1	1	2023-10-03	CAPITAL ONE ONLINE PYMT	512.71	2024-01-09 18:57:47.153366+00	\N	{}
1861	1	1	2023-09-30	ROSS STORES #1704	-17.36	2024-01-09 18:57:47.153366+00	\N	{}
79	8	2	2024-01-01	Monthly Interest Paid	83.04	2024-01-09 05:16:32.935013+00	\N	{}
2023	1	1	2023-06-06	BKGHOTEL AT BOOKING.C	-91.37	2024-01-09 18:57:47.153366+00	\N	{Travel,Hotel}
1994	1	1	2023-07-01	LOVE'S #22	-25.95	2024-01-09 18:57:47.153366+00	\N	{Travel,"new mexico"}
1872	1	1	2023-09-16	PIKES PEAK AMERICA`S M	-50.00	2024-01-09 18:57:47.153366+00	\N	{}
1874	1	1	2023-09-15	CAPITAL ONE ONLINE PYMT	379.34	2024-01-09 18:57:47.153366+00	\N	{}
1327	6	1	2023-08-18	FRONTIER RESERVATIONS DS DENVER CO	-147.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,"Flight tickets"}
1805	1	1	2023-12-27	WM SUPERCENTER #3366	-46.60	2024-01-09 18:57:47.153366+00	\N	{Travel,utah}
1876	1	1	2023-09-12	ASSOCIATES IN FAMILY M	-362.82	2024-01-09 18:57:47.153366+00	\N	{}
1807	1	1	2023-12-26	CHATGPT SUBSCRIPTION	-20.00	2024-01-09 18:57:47.153366+00	\N	{Travel,utah}
1877	1	1	2023-09-12	CAPITAL ONE ONLINE PYMT	20.97	2024-01-09 18:57:47.153366+00	\N	{}
1878	1	1	2023-09-10	CAPITAL ONE ONLINE PYMT	158.26	2024-01-09 18:57:47.153366+00	\N	{}
1879	1	1	2023-09-09	ROCKY MTN GIFT SHOP	-4.14	2024-01-09 18:57:47.153366+00	\N	{}
1880	1	1	2023-09-09	MCDONALD'S F10128	-16.83	2024-01-09 18:57:47.153366+00	\N	{}
1882	1	1	2023-09-08	TST* Bar - Avanti Boul	-5.09	2024-01-09 18:57:47.153366+00	\N	{}
1884	1	1	2023-09-07	WM SUPERCENTER #5341	-107.42	2024-01-09 18:57:47.153366+00	\N	{}
212	3	1	2023-02-28	DISCOVER E-PAYMENT 230228 7277 ROCHADEVARGAS V	-421.73	2024-01-09 18:10:05.987144+00	\N	{}
213	3	1	2023-02-28	CAPITAL ONE ONLINE PMT 230228 3R6FKV9VF2F2TR4 VANDERLEI ROCHA DE VAR	-40.51	2024-01-09 18:10:05.987144+00	\N	{}
1886	1	1	2023-09-07	CAPITAL ONE ONLINE PYMT	363.98	2024-01-09 18:57:47.153366+00	\N	{}
227	3	1	2023-02-06	Colorado State U AP 020623 89993 T-165927 Info: hknutson@colostate.edu 970-491-82	2318.99	2024-01-09 18:10:05.987144+00	\N	{}
228	3	1	2023-02-03	DISCOVER E-PAYMENT 230203 1269 ROCHADEVARGASJUNIS	-30.87	2024-01-09 18:10:05.987144+00	\N	{}
229	3	1	2023-02-01	CAPITAL ONE MOBILE PMT 230201 3R0RN2MWCIRGZ2W SANDRA ROCHA DE VARGAS	-250.00	2024-01-09 18:10:05.987144+00	\N	{}
230	3	1	2023-01-31	COLORADO STATE U Payroll 013123 89993-3 ROCHA DE VARGAS JUNIOR	4753.28	2024-01-09 18:10:05.987144+00	\N	{}
232	3	1	2023-01-30	DISCOVER E-PAYMENT 230128 7277 ROCHADEVARGAS V	-113.38	2024-01-09 18:10:05.987144+00	\N	{}
235	3	1	2023-01-23	CAPITAL ONE MOBILE PMT 230121 3QY8PTLB3NGVGD4 SANDRA ROCHA DE VARGAS	-200.00	2024-01-09 18:10:05.987144+00	\N	{}
236	3	1	2023-01-23	PURCHASE AUTHORIZED ON 01/23 VENMO* Visa Direct NY S383024015447761 CARD 4174	-51.85	2024-01-09 18:10:05.987144+00	\N	{}
237	3	1	2023-01-20	DISCOVER E-PAYMENT 230120 7277 ROCHADEVARGAS V	-254.81	2024-01-09 18:10:05.987144+00	\N	{}
2157	5	1	2023-10-30	Payment - Thank You	180.00	2024-01-11 04:43:34.551039+00	\N	{}
2158	5	1	2023-10-31	Wendys 3888	-13.84	2024-01-11 04:43:34.551039+00	\N	{}
2160	5	1	2023-10-26	Colorado State University	-60.00	2024-01-11 04:43:34.551039+00	\N	{}
2165	5	1	2023-10-11	Payment - Thank You	147.17	2024-01-11 04:43:34.551039+00	\N	{}
2169	5	1	2023-10-03	Payment - Thank You	100.56	2024-01-11 04:43:34.551039+00	\N	{}
2170	5	1	2023-10-02	Cash Back Credit	8.81	2024-01-11 04:43:34.551039+00	\N	{}
1996	1	1	2023-06-29	RING YEARLY PLAN	-39.99	2024-01-09 18:57:47.153366+00	\N	{}
1998	1	1	2023-06-29	CAPITAL ONE ONLINE PYMT	355.71	2024-01-09 18:57:47.153366+00	\N	{}
1999	1	1	2023-06-25	ROCKY MTN GIFT SHOP	-4.14	2024-01-09 18:57:47.153366+00	\N	{}
2000	1	1	2023-06-25	ROCKY MOUNTAIN NATIONA	-80.00	2024-01-09 18:57:47.153366+00	\N	{}
2001	1	1	2023-06-24	WM SUPERCENTER #5341	-28.18	2024-01-09 18:57:47.153366+00	\N	{}
2003	1	1	2023-06-24	TST* NEXT DOOR BOULDER	-44.26	2024-01-09 18:57:47.153366+00	\N	{}
2004	1	1	2023-06-23	SQ *BENTO-RIA SUSHI &	-13.09	2024-01-09 18:57:47.153366+00	\N	{}
2009	1	1	2023-06-13	THE HOME DEPOT #1506	-13.55	2024-01-09 18:57:47.153366+00	\N	{}
2010	1	1	2023-06-13	32 MARKET	-4.91	2024-01-09 18:57:47.153366+00	\N	{}
2011	1	1	2023-06-14	CAPITAL ONE MOBILE PYMT	263.59	2024-01-09 18:57:47.153366+00	\N	{}
2012	1	1	2023-06-13	WINDSCRIBE.COM 81XHC4T	-3.00	2024-01-09 18:57:47.153366+00	\N	{}
2014	1	1	2023-06-09	WM SUPERCENTER #3177	-11.87	2024-01-09 18:57:47.153366+00	\N	{}
2055	1	1	2023-04-21	RIO GRANDE MEXICAN RES	-42.00	2024-01-09 18:57:47.153366+00	\N	{}
2056	1	1	2023-04-19	OLIVE GARDEN 0021376	-27.00	2024-01-09 18:57:47.153366+00	\N	{}
2057	1	1	2023-04-20	CAPITAL ONE ONLINE PYMT	895.87	2024-01-09 18:57:47.153366+00	\N	{}
2029	1	1	2023-05-27	PHILLIPS 66 - LONGMONT	-39.14	2024-01-09 18:57:47.153366+00	\N	{Auto,Gas}
2038	1	1	2023-05-20	PHILLIPS 66 - FLATIRON	-31.60	2024-01-09 18:57:47.153366+00	\N	{Auto,Gas}
2178	5	1	2023-06-06	Payment - Thank You	16.82	2024-01-11 04:43:34.551039+00	\N	{}
42	7	1	2023-11-28	Withdrawal to CD Nov28 - 18m - 5.00 XXXXXXX8210	-20000.00	2024-01-09 05:13:55.402661+00	\N	{}
44	7	1	2023-11-23	Withdrawal to 360 Checking XXXXXXX4402	-430.00	2024-01-09 05:13:55.402661+00	\N	{}
43	7	1	2023-11-28	Withdrawal to Checking XXXXXXX4402	-50.00	2024-01-09 05:13:55.402661+00	\N	{}
45	7	1	2023-11-17	Withdrawal to 360 Checking XXXXXXX4402	-810.00	2024-01-09 05:13:55.402661+00	\N	{}
46	7	1	2023-11-14	Deposit from 360 Checking XXXXXXX4402	1500.00	2024-01-09 05:13:55.402661+00	\N	{}
47	7	1	2023-11-14	Withdrawal to 360 Checking XXXXXXX4402	-2000.00	2024-01-09 05:13:55.402661+00	\N	{}
48	7	1	2023-11-07	Deposit from 360 Checking XXXXXXX4402	8853.16	2024-01-09 05:13:55.402661+00	\N	{}
50	7	1	2023-10-30	Deposit from 360 Checking XXXXXXX4402	2000.00	2024-01-09 05:13:55.402661+00	\N	{}
51	7	1	2023-10-24	Withdrawal to 360 Checking XXXXXXX4402	-50.00	2024-01-09 05:13:55.402661+00	\N	{}
1830	1	1	2023-11-21	TST* FRIENDS STATION-8	-88.24	2024-01-09 18:57:47.153366+00	\N	{Travel,chicago}
1834	1	1	2023-11-19	BP#9496704PASEO PLAQPS	-25.00	2024-01-09 18:57:47.153366+00	\N	{Travel,chicago}
1835	1	1	2023-11-18	24 7 TRAVEL ST	-4.41	2024-01-09 18:57:47.153366+00	\N	{Travel,chicago}
1341	6	1	2023-08-26	WALMART PAY 05341 BROOMFIELD CO	-33.24	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1302	6	1	2023-07-03	MCDONALDS 7139 EASTLAND TX	-6.37	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,"new mexico"}
1342	6	1	2023-08-27	WALMART PAY 05341 BROOMFIELD CO	-27.01	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
2060	1	1	2023-04-16	PHILLIPS 66 - LONGMONT	-28.06	2024-01-09 18:57:47.153366+00	\N	{Auto,Gas}
52	7	1	2023-10-16	Deposit from 360 Checking XXXXXXX4402	1200.00	2024-01-09 05:13:55.402661+00	\N	{}
53	7	1	2023-10-05	Deposit from 360 Checking XXXXXXX4402	7592.36	2024-01-09 05:13:55.402661+00	\N	{}
2059	1	1	2023-04-16	POPEYES 12299 / 419	-5.41	2024-01-09 18:57:47.153366+00	\N	{}
2061	1	1	2023-04-12	ETS ERT	-286.19	2024-01-09 18:57:47.153366+00	\N	{}
2062	1	1	2023-04-10	DOMINO'S 6358	-37.18	2024-01-09 18:57:47.153366+00	\N	{}
2064	1	1	2023-04-06	CO STATE UNIVERSITY	-169.91	2024-01-09 18:57:47.153366+00	\N	{}
2066	1	1	2023-04-04	KFC/TB #436	-25.78	2024-01-09 18:57:47.153366+00	\N	{}
2067	1	1	2023-04-02	SIGNAL WASH ON NORTH C	-6.15	2024-01-09 18:57:47.153366+00	\N	{}
2068	1	1	2023-04-03	THE MT EVEREST CAFE	-37.53	2024-01-09 18:57:47.153366+00	\N	{}
2070	1	1	2023-03-28	CAPITAL ONE ONLINE PYMT	112.84	2024-01-09 18:57:47.153366+00	\N	{}
2074	1	1	2023-02-28	CAPITAL ONE ONLINE PYMT	40.51	2024-01-09 18:57:47.153366+00	\N	{}
2063	1	1	2023-04-09	PHILLIPS 66 - LONGMONT	-33.25	2024-01-09 18:57:47.153366+00	\N	{Auto,Gas}
2075	1	1	2023-02-01	DOMINO'S 6358	-40.51	2024-01-09 18:57:47.153366+00	\N	{}
2076	1	1	2023-01-18	CAPITAL ONE AUTOPAY PYMT	80.00	2024-01-09 18:57:47.153366+00	\N	{}
2077	1	1	2023-01-13	MOUNTAIN STATE DRIVERS	-80.00	2024-01-09 18:57:47.153366+00	\N	{}
880	6	1	2022-08-04	MCDONALD'S F19217 FORT COLLINS CO	-5.26	2024-01-09 18:17:44.325718+00	Restaurants	{}
1347	6	1	2023-09-03	E 470 EXPRESS TOLLS AURORA CO	-29.85	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,texas}
125	3	1	2023-08-09	DISCOVER E-PAYMENT 230809 7277 ROCHADEVARGAS V	-813.58	2024-01-09 18:10:05.987144+00	\N	{}
126	3	1	2023-08-09	CAPITAL ONE ONLINE PMT 230809 3S4N2DK6Q9CA71C VANDERLEI ROCHA DE VAR	-82.74	2024-01-09 18:10:05.987144+00	\N	{}
127	3	1	2023-08-07	CAPITAL ONE ONLINE PMT 230806 3S40FC4VB7X61I8 VANDERLEI ROCHA DE VAR	-260.17	2024-01-09 18:10:05.987144+00	\N	{}
128	3	1	2023-08-03	CAPITAL ONE ONLINE PMT 230803 3S3DJXCLFY04XEO VANDERLEI ROCHA DE VAR	-299.26	2024-01-09 18:10:05.987144+00	\N	{}
881	6	1	2022-08-04	MCDONALD'S F19217 FORT COLLINS CO	-9.02	2024-01-09 18:17:44.325718+00	Restaurants	{}
882	6	1	2022-08-05	INTERNET PAYMENT - THANK YOU	145.06	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
886	6	1	2022-08-07	MCDONALD'S F10128 ESTES PARK CO	-2.17	2024-01-09 18:17:44.325718+00	Restaurants	{}
887	6	1	2022-08-07	MCDONALD'S F10128 ESTES PARK CO	-5.21	2024-01-09 18:17:44.325718+00	Restaurants	{}
888	6	1	2022-08-07	THE CAR PARK PAYBYAPP 2083366597 ID	-4.35	2024-01-09 18:17:44.325718+00	Services	{}
252	3	1	2022-12-27	CAPITAL ONE ONLINE PMT 221225 3N2QKNL1I3GTMAO VANDERLEI ROCHA DE VAR	-160.00	2024-01-09 18:10:05.987144+00	\N	{}
254	3	1	2022-12-20	DISCOVER E-PAYMENT 221220 7277 ROCHADEVARGAS V	-207.35	2024-01-09 18:10:05.987144+00	\N	{}
255	3	1	2022-12-14	DISCOVER E-PAYMENT 221214 7277 ROCHADEVARGAS V	-545.21	2024-01-09 18:10:05.987144+00	\N	{}
129	3	1	2023-08-03	DISCOVER E-PAYMENT 230803 7277 ROCHADEVARGAS V	-226.45	2024-01-09 18:10:05.987144+00	\N	{}
131	3	1	2023-07-31	COLORADO STATE U Payroll 073123 89993-3 ROCHA DE VARGAS JUNIOR	8473.10	2024-01-09 18:10:05.987144+00	\N	{}
133	3	1	2023-07-28	CAPITAL ONE ONLINE PMT 230728 3S23YHDUV4SSCGW VANDERLEI ROCHA DE VAR	-178.91	2024-01-09 18:10:05.987144+00	\N	{}
698	6	1	2022-05-10	RAYS BBQ NORMAN NORMAN OKGOOGLE PAY ENDING IN 4338	-6.26	2024-01-09 18:17:44.325718+00	Restaurants	{}
700	6	1	2022-05-11	INTERNET PAYMENT - THANK YOU	283.00	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
701	6	1	2022-05-11	PEPE DELGADOS BAR NORMAN OKGOOGLE PAY ENDING IN 4338	-16.14	2024-01-09 18:17:44.325718+00	Restaurants	{}
257	3	1	2022-12-09	CAPITAL ONE MOBILE PMT 221208 3MZ4ZPGPUV5E4RC SANDRA ROCHA DE VARGAS	-361.79	2024-01-09 18:10:05.987144+00	\N	{}
258	3	1	2022-12-08	CAPITAL ONE MOBILE PMT 221207 3MYQEQ07GSWWQZC SANDRA ROCHA DE VARGAS	-350.00	2024-01-09 18:10:05.987144+00	\N	{}
259	3	1	2022-12-05	DISCOVER E-PAYMENT 221205 7277 ROCHADEVARGAS V	-269.60	2024-01-09 18:10:05.987144+00	\N	{}
1865	1	1	2023-09-29	RUSHTRANSLATE	-282.40	2024-01-09 18:57:47.153366+00	\N	{}
1866	1	1	2023-09-28	CAPITAL ONE ONLINE PYMT	113.14	2024-01-09 18:57:47.153366+00	\N	{}
1868	1	1	2023-09-25	CAPITAL ONE ONLINE PYMT	27.50	2024-01-09 18:57:47.153366+00	\N	{}
1870	1	1	2023-09-20	CAPITAL ONE ONLINE PYMT	83.15	2024-01-09 18:57:47.153366+00	\N	{}
1881	1	1	2023-09-08	RECREATION.GOV	-2.00	2024-01-09 18:57:47.153366+00	\N	{}
889	6	1	2022-08-08	INTERNET PAYMENT - THANK YOU	273.21	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
890	6	1	2022-08-10	SMILE DOCTORS OF COLOR FORT COLLINS CO	-175.00	2024-01-09 18:17:44.325718+00	Medical Services	{}
891	6	1	2022-08-10	ZOOM.US 888-799-9666 8887999666 CA	-96.73	2024-01-09 18:17:44.325718+00	Services	{}
892	6	1	2022-08-11	VATOS TACOS & TEQUILA FORT COLLINS CO	-23.96	2024-01-09 18:17:44.325718+00	Restaurants	{}
894	6	1	2022-08-12	INTERNET PAYMENT - THANK YOU	283.46	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
895	6	1	2022-08-13	IKEA CENTENNIAL REST CENTENNIAL CO	-19.24	2024-01-09 18:17:44.325718+00	Restaurants	{}
906	6	1	2022-08-22	HARVARD BUS EDUCATION 617-783-7600 MA3573056	-94.44	2024-01-09 18:17:44.325718+00	Merchandise	{}
907	6	1	2022-08-23	INTERNET PAYMENT - THANK YOU	83.02	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
599	6	1	2022-03-19	ATT* BILL PAYMENT 800-331-0500 TX	-112.63	2024-01-09 18:17:44.325718+00	Services	{}
768	6	1	2022-06-05	RECREATION.GOV ALBUQUERQUE NM	-2.00	2024-01-09 18:17:44.325718+00	Government Services	{}
769	6	1	2022-06-05	SQ *BURGERS & GYROS ON ESTES PARK CO0001152921511475124605	-4.87	2024-01-09 18:17:44.325718+00	Restaurants	{}
779	6	1	2022-06-10	LA RUMBA DENVER CO	-2.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
908	6	1	2022-08-25	PRIMO CAFE & MARKET MIAMI BEACH FL	-6.93	2024-01-09 18:17:44.325718+00	Supermarkets	{Travel,miami}
1985	1	1	2023-07-03	STARBUCKS 18625	-14.54	2024-01-09 18:57:47.153366+00	\N	{Travel,"new mexico"}
1986	1	1	2023-07-03	SPEEDWAY 09123 1957 US	-30.57	2024-01-09 18:57:47.153366+00	\N	{Travel,"new mexico"}
1988	1	1	2023-07-02	WM SUPERCENTER #3341	-18.58	2024-01-09 18:57:47.153366+00	\N	{Travel,"new mexico"}
1990	1	1	2023-07-02	GREAT WESTERN INN & SU	-90.11	2024-01-09 18:57:47.153366+00	\N	{Travel,"new mexico"}
1991	1	1	2023-07-02	LOVE'S #270	-31.77	2024-01-09 18:57:47.153366+00	\N	{Travel,"new mexico"}
1992	1	1	2023-07-01	HEARTS DESIRE B&B	-103.83	2024-01-09 18:57:47.153366+00	\N	{Travel,"new mexico"}
1993	1	1	2023-07-01	STARBUCKS 66285	-11.41	2024-01-09 18:57:47.153366+00	\N	{Travel,"new mexico"}
600	6	1	2022-03-19	TAJ MAHAL RESTAURANT FORT COLLINS CO	-23.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
602	6	1	2022-03-20	AMZN MKTP US*1N6FP1KR1 AMZN.COM/BILLWA308CKPJJYMI	-86.03	2024-01-09 18:17:44.325718+00	Merchandise	{}
603	6	1	2022-03-21	044 TORCHYS CF FT COLLIN 5124418900 CO	-12.97	2024-01-09 18:17:44.325718+00	Restaurants	{}
604	6	1	2022-03-21	INTERNET PAYMENT - THANK YOU	145.09	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
605	6	1	2022-03-22	INTERNET PAYMENT - THANK YOU	221.66	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
607	6	1	2022-03-24	INTERNET PAYMENT - THANK YOU	77.49	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
611	6	1	2022-03-27	INTERNET PAYMENT - THANK YOU	60.27	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
2086	5	1	2024-01-06	Payment - Thank You	362.89	2024-01-11 04:43:34.551039+00	\N	{}
2088	5	1	2024-01-03	Payment - Thank You	18.43	2024-01-11 04:43:34.551039+00	\N	{}
2089	5	1	2024-01-02	Payment - Thank You	73.24	2024-01-11 04:43:34.551039+00	\N	{}
2118	5	1	2023-12-02	Cash Back Credit	28.85	2024-01-11 04:43:34.551039+00	\N	{}
2120	5	1	2023-11-30	Payment - Thank You	224.69	2024-01-11 04:43:34.551039+00	\N	{}
260	3	1	2022-12-02	CAPITAL ONE ONLINE PMT 221201 3MXO3PJ48WI01LS VANDERLEI ROCHA DE VAR	-107.45	2024-01-09 18:10:05.987144+00	\N	{}
261	3	1	2022-11-30	DISCOVER E-PAYMENT 221130 7277 ROCHADEVARGAS V	-543.48	2024-01-09 18:10:05.987144+00	\N	{}
262	3	1	2022-11-30	COLORADO STATE U Payroll 113022 89993-3 ROCHA DE VARGAS JUNIOR	4799.99	2024-01-09 18:10:05.987144+00	\N	{}
263	3	1	2022-11-29	DISCOVER E-PAYMENT 221129 1269 ROCHADEVARGASJUNIS	-27.93	2024-01-09 18:10:05.987144+00	\N	{}
1800	1	1	2024-01-03	CAPITAL ONE ONLINE PYMT	185.74	2024-01-09 18:57:47.153366+00	\N	{}
2121	5	1	2023-11-27	Payment - Thank You	49.73	2024-01-11 04:43:34.551039+00	\N	{}
2122	5	1	2023-11-29	Reversed Payment	-224.69	2024-01-11 04:43:34.551039+00	\N	{}
1199	6	1	2023-03-05	IMG INSURANCE 866-347-6673 IN4498236VIC0083599923	-944.28	2024-01-09 18:17:44.325718+00	Services	{}
1200	6	1	2023-03-06	E 470 EXPRESS TOLLS AURORA CO	-11.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
1202	6	1	2023-03-07	INTERNET PAYMENT - THANK YOU	1665.79	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
621	6	1	2022-04-01	INTERNET PAYMENT - THANK YOU	623.97	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
622	6	1	2022-04-02	COOPERSMITHS PUB AND BRE FORT COLLINS CO	-8.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
623	6	1	2022-04-02	THAI STATION RESTAURANT FORT COLLINS CO	-30.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
624	6	1	2022-04-03	AMAZON.COM*1H1M95891 AMZN.COM/BILLWA64S0PY16NCK	-87.42	2024-01-09 18:17:44.325718+00	Merchandise	{}
632	6	1	2022-04-10	COSMOS PIZZA - FORT COLL FORT COLLINS CO	-12.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
633	6	1	2022-04-10	INTERNET PAYMENT - THANK YOU	228.05	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
636	6	1	2022-04-13	INTERNET PAYMENT - THANK YOU	126.31	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
638	6	1	2022-04-16	INTERNET PAYMENT - THANK YOU	132.52	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
640	6	1	2022-04-19	AMZN MKTP US*1O5258UJ1 AMZN.COM/BILLWA18XAYI7F6U2	-24.12	2024-01-09 18:17:44.325718+00	Merchandise	{}
641	6	1	2022-04-19	AMZN MKTP US*1O7KO2UB1 AMZN.COM/BILLWA5TCQWLZ6T1E	-6.39	2024-01-09 18:17:44.325718+00	Merchandise	{}
642	6	1	2022-04-19	DEN PUBLIC PARKING DENVER CO0002E787	-12.00	2024-01-09 18:17:44.325718+00	Services	{}
643	6	1	2022-04-19	E 470 EXPRESS TOLLS AURORA CO	-35.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
646	6	1	2022-04-19	THAI STATION RESTAURANT FORT COLLINS CO	-36.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
648	6	1	2022-04-21	INTERNET PAYMENT - THANK YOU	134.44	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
650	6	1	2022-04-22	INTERNET PAYMENT - THANK YOU	66.84	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
95	3	1	2023-09-14	XCEL ENERGY-PSCO XCELENERGY 00139134914 VANDERLEI ROC496529303	-88.88	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
651	6	1	2022-04-23	044 TORCHYS FT COLLINS FORT COLLINS CO	-26.64	2024-01-09 18:17:44.325718+00	Restaurants	{}
2081	6	1	2023-12-30	AMZN MKTP US*RN1DX0IO3 AMZN.COM/BILLWA4893JQM0HT8	-68.19	2024-01-09 23:00:10.124777+00	Merchandise	{Travel,utah}
122	3	1	2023-08-16	XCEL ENERGY-PSCO XCELENERGY 00139134914 VANDERLEI ROC492798708	-126.70	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
652	6	1	2022-04-23	AUTOWASHMANHATTANAVE FORT COLLINS CO	-4.00	2024-01-09 18:17:44.325718+00	Automotive	{}
654	6	1	2022-04-24	INTERNET PAYMENT - THANK YOU	235.25	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
655	6	1	2022-04-25	INTERNET PAYMENT - THANK YOU	20.83	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
676	6	1	2022-05-04	TURMERIC GROCERY FORT COLLINS CO	-6.21	2024-01-09 18:17:44.325718+00	Supermarkets	{}
678	6	1	2022-05-06	DEN PUBLIC PARKING DENVER CO00013612	-6.00	2024-01-09 18:17:44.325718+00	Services	{}
679	6	1	2022-05-06	E 470 EXPRESS TOLLS AURORA CO	-29.70	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
680	6	1	2022-05-06	INTERNET PAYMENT - THANK YOU	328.60	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
681	6	1	2022-05-06	PARKWELL - 12TH & ACOM DENVER CO00650R	-7.00	2024-01-09 18:17:44.325718+00	Services	{}
682	6	1	2022-05-07	AMZN MKTP US*1L0XW73F1 AMZN.COM/BILLWA72SDHXJEWQA	-31.99	2024-01-09 18:17:44.325718+00	Merchandise	{}
689	6	1	2022-05-08	AROMAS FROZEN YOGURT DENVER CO	-8.56	2024-01-09 18:17:44.325718+00	Supermarkets	{}
690	6	1	2022-05-08	HAAGEN DAZS #1212 DENVER CO	-9.45	2024-01-09 18:17:44.325718+00	Restaurants	{}
692	6	1	2022-05-08	SQ *HIVE GARDEN BISTRO DENVER CO0002305843015610430248	-5.60	2024-01-09 18:17:44.325718+00	Restaurants	{}
693	6	1	2022-05-08	SQ *HIVE GARDEN BISTRO DENVER CO0002305843015610289719	-37.29	2024-01-09 18:17:44.325718+00	Restaurants	{}
694	6	1	2022-05-09	INTERNET PAYMENT - THANK YOU	144.72	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
695	6	1	2022-05-09	THE MULE OKLAHOMA CITYOKGOOGLE PAY ENDING IN 4338	-18.04	2024-01-09 18:17:44.325718+00	Restaurants	{}
702	6	1	2022-05-12	INTERNET PAYMENT - THANK YOU	100.86	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
703	6	1	2022-05-12	OKC TRIP ADVISOR OKLAHOMA CITYOKGOOGLE PAY ENDING IN 433801240R	-9.75	2024-01-09 18:17:44.325718+00	Merchandise	{}
704	6	1	2022-05-12	STARBUCKS 65629 OKLAHOMA CITYOKGOOGLE PAY ENDING IN 4338	-3.53	2024-01-09 18:17:44.325718+00	Restaurants	{}
705	6	1	2022-05-13	INTERNET PAYMENT - THANK YOU	56.14	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
706	6	1	2022-05-13	TST* AVOGADRO S NUMBER FORT COLLINS CO	-6.90	2024-01-09 18:17:44.325718+00	Restaurants	{}
707	6	1	2022-05-13	TST* AVOGADRO S NUMBER FORT COLLINS CO	-34.83	2024-01-09 18:17:44.325718+00	Restaurants	{}
709	6	1	2022-05-14	AMZN MKTP US*1L7NQ5ZA2 AMZN.COM/BILLWAJLEVO43QZTC	-40.70	2024-01-09 18:17:44.325718+00	Merchandise	{}
318	3	1	2022-08-29	CAPITAL ONE ONLINE PMT 220828 3MDMF6UCX77NH9C VANDERLEI ROCHA DE VAR	-48.45	2024-01-09 18:10:05.987144+00	\N	{}
2097	5	1	2023-12-31	Chevron 0071050	-30.26	2024-01-11 04:43:34.551039+00	\N	{Auto,Gas}
2095	5	1	2023-12-31	Pilot_00763	-24.00	2024-01-11 04:43:34.551039+00	\N	{Auto,Gas}
2096	5	1	2023-12-31	Flying J 763	-2.99	2024-01-11 04:43:34.551039+00	\N	{Auto,Gas}
2050	1	1	2023-04-23	PHILLIPS 66 - LONGMONT	-32.28	2024-01-09 18:57:47.153366+00	\N	{Travel,gleenwood,Auto,Gas}
2128	5	1	2023-11-24	Phillips 66 - Speedee Mar	-32.46	2024-01-11 04:43:34.551039+00	\N	{Auto,Gas}
319	3	1	2022-08-29	DISCOVER E-PAYMENT 220827 1269 ROCHADEVARGASJUNIS	-176.90	2024-01-09 18:10:05.987144+00	\N	{}
320	3	1	2022-08-23	DISCOVER E-PAYMENT 220823 7277 ROCHADEVARGAS V	-83.02	2024-01-09 18:10:05.987144+00	\N	{}
322	3	1	2022-08-22	DISCOVER E-PAYMENT 220820 7277 ROCHADEVARGAS V	-94.68	2024-01-09 18:10:05.987144+00	\N	{}
307	3	1	2022-09-13	XCEL ENERGY-PSCO XCELENERGY 00139134914 VANDERLEI ROC449369102	-15.83	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
328	3	1	2022-08-12	XCEL ENERGY-PSCO XCELENERGY 00139134914 VANDERLEI ROC445416218	-15.82	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
323	3	1	2022-08-19	DISCOVER E-PAYMENT 220819 1269 ROCHADEVARGASJUNIS	-236.41	2024-01-09 18:10:05.987144+00	\N	{}
324	3	1	2022-08-19	CAPITAL ONE CRCARDPMT 220818 3MBH88GZN6FBTPC VANDERLEI ROCHA DE VAR	-175.00	2024-01-09 18:10:05.987144+00	\N	{}
325	3	1	2022-08-16	DISCOVER E-PAYMENT 220816 7277 ROCHADEVARGAS V	-232.85	2024-01-09 18:10:05.987144+00	\N	{}
326	3	1	2022-08-15	DISCOVER E-PAYMENT 220815 7277 ROCHADEVARGAS V	-184.62	2024-01-09 18:10:05.987144+00	\N	{}
327	3	1	2022-08-12	DISCOVER E-PAYMENT 220812 7277 ROCHADEVARGAS V	-283.46	2024-01-09 18:10:05.987144+00	\N	{}
329	3	1	2022-08-08	DISCOVER E-PAYMENT 220808 7277 ROCHADEVARGAS V	-273.21	2024-01-09 18:10:05.987144+00	\N	{}
330	3	1	2022-08-08	DISCOVER E-PAYMENT 220806 7277 ROCHADEVARGAS V	-145.06	2024-01-09 18:10:05.987144+00	\N	{}
331	3	1	2022-08-01	DISCOVER E-PAYMENT 220801 7277 ROCHADEVARGAS V	-175.44	2024-01-09 18:10:05.987144+00	\N	{}
1831	1	1	2023-11-22	Whole Foods GOC 10740	-4.08	2024-01-09 18:57:47.153366+00	\N	{Travel,chicago,Household,Grocery}
1833	1	1	2023-11-20	Whole Foods GOC 10740	-24.53	2024-01-09 18:57:47.153366+00	\N	{Travel,chicago,Household,Grocery}
712	6	1	2022-05-14	ROCKY MOUNT SHOOT SU FORT COLLINS CO	-61.69	2024-01-09 18:17:44.325718+00	Merchandise	{}
714	6	1	2022-05-15	STARBUCKS STORE 61117 FT. COLLINS COED1B8B6550BB786870	-13.61	2024-01-09 18:17:44.325718+00	Restaurants	{}
717	6	1	2022-05-16	INTERNET PAYMENT - THANK YOU	646.64	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
719	6	1	2022-05-17	TONYS FT COLLINS CO	-15.98	2024-01-09 18:17:44.325718+00	Restaurants	{}
720	6	1	2022-05-18	INTERNET PAYMENT - THANK YOU	172.44	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
721	6	1	2022-05-19	ODELL BREWING CO. - FORT FORT COLLINS CO	-6.05	2024-01-09 18:17:44.325718+00	Restaurants	{}
723	6	1	2022-05-20	ATT* BILL PAYMENT 800-331-0500 TX	-24.35	2024-01-09 18:17:44.325718+00	Services	{}
724	6	1	2022-05-20	INTERNET PAYMENT - THANK YOU	54.09	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
725	6	1	2022-05-21	044 TORCHYS CF FT COLLIN 5124418900 CO	-29.19	2024-01-09 18:17:44.325718+00	Restaurants	{}
752	6	1	2022-05-30	INTERNET PAYMENT - THANK YOU	648.76	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
756	6	1	2022-06-01	AMZN MKTP US*1X9H190N2 AMZN.COM/BILLWA10A4RP79H4B	-330.62	2024-01-09 18:17:44.325718+00	Merchandise	{}
757	6	1	2022-06-01	INTERNET PAYMENT - THANK YOU	345.22	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
760	6	1	2022-06-03	WONDERSHARE HK HKG	-49.99	2024-01-09 18:17:44.325718+00	Merchandise	{}
761	6	1	2022-06-04	INTERNET PAYMENT - THANK YOU	638.07	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
770	6	1	2022-06-05	SQ *BURGERS & GYROS ON ESTES PARK CO0001152921511475064429	-24.28	2024-01-09 18:17:44.325718+00	Restaurants	{}
771	6	1	2022-06-06	INTERNET PAYMENT - THANK YOU	105.64	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
774	6	1	2022-06-07	AMZN MKTP US*PO2UP6XX3 AMZN.COM/BILLWA5OM52TVZXAG	-46.22	2024-01-09 18:17:44.325718+00	Merchandise	{}
776	6	1	2022-06-08	044 TORCHYS FT COLLINS FORT COLLINS CO	-11.39	2024-01-09 18:17:44.325718+00	Restaurants	{}
777	6	1	2022-06-08	INTERNET PAYMENT - THANK YOU	172.79	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
778	6	1	2022-06-10	INTERNET PAYMENT - THANK YOU	106.09	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
781	6	1	2022-06-11	CHEESECAKE DENVER DENVER CO	-80.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
786	6	1	2022-06-13	INTERNET PAYMENT - THANK YOU	116.78	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1779	2	1	2023-10-16	Withdrawal to 360 Performance Savings XXXXXXX1843	-1200.00	2024-01-09 18:34:47.445728+00	\N	{}
1785	2	1	2023-10-05	Withdrawal to 360 Performance Savings XXXXXXX1843	-7592.36	2024-01-09 18:34:47.445728+00	\N	{}
207	3	1	2023-03-15	IRS TREAS 310 TAX REF 031523 XXXXXXXXXX00918 ROCHA DE VARGAS, VANDE	1390.00	2024-01-09 18:10:05.987144+00	\N	{}
204	3	1	2023-03-20	CAPITAL ONE MOBILE PMT 230318 3RA8GT3YNQ8XXNC SANDRA ROCHA DE VARGAS	-400.00	2024-01-09 18:10:05.987144+00	\N	{}
219	3	1	2023-02-16	BILL PAY Utility Billing Services MOBILE xxxxxxxx022C ON 02-16	-29.06	2024-01-09 18:10:05.987144+00	\N	{}
233	3	1	2023-01-25	BILL PAY Utility Billing Services MOBILE xxxxxxxx022C ON 01-25	-28.10	2024-01-09 18:10:05.987144+00	\N	{}
340	3	1	2022-07-20	DISCOVER E-PAYMENT 220720 7277 ROCHADEVARGAS V	-1041.50	2024-01-09 18:10:05.987144+00	\N	{}
787	6	1	2022-06-14	044 TORCHYS CF FT COLLIN 5124418900 CO	-17.30	2024-01-09 18:17:44.325718+00	Restaurants	{}
790	6	1	2022-06-14	LOWE'S OF FORT COLLINS, FORT COLLINS CO	-79.01	2024-01-09 18:17:44.325718+00	Home Improvement	{}
791	6	1	2022-06-14	SQ *BRIGHT SIDE COFFEE GREELEY CO0001152921511511113656	-7.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
793	6	1	2022-06-15	SMILE DOCTORS OF COLOR FORT COLLINS CO	-500.00	2024-01-09 18:17:44.325718+00	Medical Services	{}
795	6	1	2022-06-17	4610 COLORADO ST UNIV FORT COLLINS CO01721R	-20.35	2024-01-09 18:17:44.325718+00	Restaurants	{}
796	6	1	2022-06-17	INTERNET PAYMENT - THANK YOU	501.25	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
797	6	1	2022-06-18	LOWE'S OF FORT COLLINS, FORT COLLINS CO	-24.87	2024-01-09 18:17:44.325718+00	Home Improvement	{}
1338	6	1	2023-08-25	TACO BELL 033867 BROOMFIELD CO	-18.62	2024-01-09 18:17:44.325718+00	Restaurants	{}
1339	6	1	2023-08-26	CHATGPT SUBSCRIPTION 4158799686 CA	-20.00	2024-01-09 18:17:44.325718+00	Merchandise	{}
1057	6	1	2022-11-27	LOAF N JUG # 0827 FORT COLLINS CO	-10.00	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
1268	6	1	2023-05-19	WALMART SC 02729 FORT COLLINS CO	-6.33	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
735	6	1	2022-05-28	EVEREST CUISINE LLC RAPID CITY SD	-40.00	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,badlands}
1061	6	1	2022-12-01	LOAF N JUG # 0810 FORT COLLINS CO	-36.21	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
1105	6	1	2023-01-04	LOAF N JUG # 0810 FORT COLLINS CO	-33.82	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
1188	6	1	2023-02-28	LONGMONT TRUCK STOP LONGMONT CO	-30.21	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,seattle,Auto,Gas}
2129	5	1	2023-11-24	Kum&go 1443r Williams	-25.52	2024-01-11 04:43:34.551039+00	\N	{Auto,Gas}
972	6	1	2022-10-03	BKGBOOKING.COM HOTEL 470-363-2501 NY	-714.76	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,brazil,Hotel}
976	6	1	2022-10-14	BKGBOOKING.COM HOTEL 470-363-2501 NY	-201.47	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,brazil,Hotel}
2125	5	1	2023-11-25	Caseys #3577	-24.68	2024-01-11 04:43:34.551039+00	\N	{Auto,Gas}
1269	6	1	2023-05-20	E 470 EXPRESS TOLLS AURORA CO	-35.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
1270	6	1	2023-05-20	HAAGEN DAZS 1090 BROOMFIELD CO	-19.36	2024-01-09 18:17:44.325718+00	Merchandise	{}
194	3	1	2023-04-10	CAPITAL ONE MOBILE PMT 230409 3REW8N03BYIJ34O SANDRA ROCHA DE VARGAS	-50.00	2024-01-09 18:10:05.987144+00	\N	{}
195	3	1	2023-04-07	DISCOVER E-PAYMENT 230407 7277 ROCHADEVARGAS V	-651.12	2024-01-09 18:10:05.987144+00	\N	{}
196	3	1	2023-04-03	CAPITAL ONE MOBILE PMT 230403 3RDN9J3OWRVT02G SANDRA ROCHA DE VARGAS	-247.58	2024-01-09 18:10:05.987144+00	\N	{}
197	3	1	2023-03-31	COLORADO STATE U Payroll 033123 89993-3 ROCHA DE VARGAS JUNIOR	4794.83	2024-01-09 18:10:05.987144+00	\N	{}
200	3	1	2023-03-29	BILL PAY Utility Billing Services MOBILE xxxx-xxx-x02-2-C ON 03-29	-24.83	2024-01-09 18:10:05.987144+00	\N	{}
201	3	1	2023-03-28	DISCOVER E-PAYMENT 230328 7277 ROCHADEVARGAS V	-13.93	2024-01-09 18:10:05.987144+00	\N	{}
202	3	1	2023-03-28	CAPITAL ONE ONLINE PMT 230328 3RCC8QUFBXMHK4G VANDERLEI ROCHA DE VAR	-112.84	2024-01-09 18:10:05.987144+00	\N	{}
1340	6	1	2023-08-26	INTERNET PAYMENT - THANK YOU	62.65	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
799	6	1	2022-06-18	TST* PANINO'S FORT COLIN FORT COLLINS CO	-48.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
800	6	1	2022-06-19	GREEN RIDE CO INC 334 821-3922 CO	-40.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
816	6	1	2022-06-24	VATOS TACOS & TEQUILA FORT COLLINS CO	-29.20	2024-01-09 18:17:44.325718+00	Restaurants	{}
820	6	1	2022-06-27	INTERNET PAYMENT - THANK YOU	172.71	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
821	6	1	2022-06-27	DENVER AIRPORT ENTERPRIS DENVER CO	-30.43	2024-01-09 18:17:44.325718+00	Supermarkets	{}
822	6	1	2022-06-27	SQ *LA MIA PIADINA, LL FORT COLLINS CO0001152921511564487584	-16.38	2024-01-09 18:17:44.325718+00	Restaurants	{}
823	6	1	2022-06-27	VATOS TACOS & TEQUILA FORT COLLINS CO	-3.61	2024-01-09 18:17:44.325718+00	Restaurants	{}
824	6	1	2022-06-28	COCA COLA JOHNSTOWN CO JOHNSTOWN CO	-1.75	2024-01-09 18:17:44.325718+00	Restaurants	{}
825	6	1	2022-06-28	INTERNET PAYMENT - THANK YOU	78.32	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1692	2	1	2024-01-04	Withdrawal from Mission Lane LLC EDI PYMNTS	-18.43	2024-01-09 18:34:47.445728+00	\N	{}
1841	1	1	2023-11-09	CAPITAL ONE ONLINE PYMT	76.65	2024-01-09 18:57:47.153366+00	\N	{}
1842	1	1	2023-11-07	ADVANCED MEDICAL IMAGI	-76.75	2024-01-09 18:57:47.153366+00	\N	{}
1843	1	1	2023-11-07	CREDIT-CASH BACK REWARD	2.37	2024-01-09 18:57:47.153366+00	\N	{}
1844	1	1	2023-11-07	CAPITAL ONE ONLINE PYMT	57.86	2024-01-09 18:57:47.153366+00	\N	{}
1849	1	1	2023-10-22	CAPITAL ONE ONLINE PYMT	311.40	2024-01-09 18:57:47.153366+00	\N	{}
1693	2	1	2024-01-04	Withdrawal from CAPITAL ONE ONLINE PMT	-185.74	2024-01-09 18:34:47.445728+00	\N	{}
1694	2	1	2024-01-03	Withdrawal from DISCOVER E-PAYMENT	-68.19	2024-01-09 18:34:47.445728+00	\N	{}
1695	2	1	2024-01-03	Withdrawal from DISCOVER E-PAYMENT	-45.02	2024-01-09 18:34:47.445728+00	\N	{}
1934	1	1	2023-08-06	MURPHY EXPRESS 8723	-47.92	2024-01-09 18:57:47.153366+00	\N	{}
1935	1	1	2023-08-06	CAPITAL ONE ONLINE PYMT	260.17	2024-01-09 18:57:47.153366+00	\N	{}
1938	1	1	2023-08-03	CAPITAL ONE ONLINE PYMT	299.26	2024-01-09 18:57:47.153366+00	\N	{}
1939	1	1	2023-08-02	WM SUPERCENTER #5341	-8.29	2024-01-09 18:57:47.153366+00	\N	{}
1941	1	1	2023-08-01	SQ *BLEA	-25.00	2024-01-09 18:57:47.153366+00	\N	{}
1942	1	1	2023-07-30	THE HOME DEPOT #1509	-67.51	2024-01-09 18:57:47.153366+00	\N	{}
1944	1	1	2023-07-30	IKEA CENTENNIAL REST	-6.05	2024-01-09 18:57:47.153366+00	\N	{}
1949	1	1	2023-07-28	CAPITAL ONE ONLINE PYMT	178.91	2024-01-09 18:57:47.153366+00	\N	{}
1953	1	1	2023-07-26	CAPITAL ONE ONLINE PYMT	232.19	2024-01-09 18:57:47.153366+00	\N	{}
683	6	1	2022-05-07	FEDEX 272867494858 901-4348994 TN	-12.74	2024-01-09 18:17:44.325718+00	Services	{}
1887	1	1	2023-09-03	ACE PARKING 3712	-10.00	2024-01-09 18:57:47.153366+00	\N	{Travel,texas}
132	3	1	2023-07-28	Crowne at Old To Payment XXXXX1770 Vanderlei Rocha De Var	-1954.80	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
1955	1	1	2023-07-23	HALF FAST SUBS	-13.07	2024-01-09 18:57:47.153366+00	\N	{}
144	3	1	2023-07-06	Crowne at Old To Payment XXXXX0183 Vanderlei Rocha De Var	-651.60	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
896	6	1	2022-08-13	LOAF N JUG # 0827 FORT COLLINS CO	-28.28	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
1946	1	1	2023-07-29	CIRCLE K 09861	-45.01	2024-01-09 18:57:47.153366+00	\N	{Auto,Gas}
1956	1	1	2023-07-24	CANTEEN VENDING	-1.35	2024-01-09 18:57:47.153366+00	\N	{}
1958	1	1	2023-07-21	UCAR FINANCE	60.00	2024-01-09 18:57:47.153366+00	\N	{}
1960	1	1	2023-07-19	CNK*CINEMARK.COM 492	-30.66	2024-01-09 18:57:47.153366+00	\N	{}
1962	1	1	2023-07-17	WM SUPERCENTER #5341	-39.44	2024-01-09 18:57:47.153366+00	\N	{}
1963	1	1	2023-07-17	CAPITAL ONE ONLINE PYMT	24.92	2024-01-09 18:57:47.153366+00	\N	{}
1964	1	1	2023-07-16	DENVER ZOO	-10.00	2024-01-09 18:57:47.153366+00	\N	{}
1965	1	1	2023-07-16	ADM/SHOP DENVER MUSEUM	-18.25	2024-01-09 18:57:47.153366+00	\N	{}
1966	1	1	2023-07-15	WM SUPERCENTER #5341	-12.57	2024-01-09 18:57:47.153366+00	\N	{}
1967	1	1	2023-07-13	WM SUPERCENTER #5341	-24.92	2024-01-09 18:57:47.153366+00	\N	{}
1968	1	1	2023-07-12	CAPITAL ONE ONLINE PYMT	498.60	2024-01-09 18:57:47.153366+00	\N	{}
1969	1	1	2023-07-11	UCAR FINANCE	-60.00	2024-01-09 18:57:47.153366+00	\N	{}
1973	1	1	2023-07-06	32 MARKET	-2.73	2024-01-09 18:57:47.153366+00	\N	{}
2016	1	1	2023-06-08	CAPITAL ONE ONLINE PYMT	671.83	2024-01-09 18:57:47.153366+00	\N	{}
2017	1	1	2023-06-08	CREDIT-CASH BACK REWARD	40.14	2024-01-09 18:57:47.153366+00	\N	{}
2018	1	1	2023-06-07	TST* The Bluegrass - O	-28.61	2024-01-09 18:57:47.153366+00	\N	{}
2020	1	1	2023-06-06	CONOCO - UNITED PACIFI	-39.45	2024-01-09 18:57:47.153366+00	\N	{}
2022	1	1	2023-06-06	RECREATION.GOV	-2.00	2024-01-09 18:57:47.153366+00	\N	{}
2024	1	1	2023-06-03	CHAUTAUGUA DINING HALL	-45.00	2024-01-09 18:57:47.153366+00	\N	{}
2025	1	1	2023-06-01	044 TORCHYS FT COLLINS	-12.22	2024-01-09 18:57:47.153366+00	\N	{}
2026	1	1	2023-06-01	TST* ILLEGAL PETE'S -	-7.01	2024-01-09 18:57:47.153366+00	\N	{}
2027	1	1	2023-05-29	WM SUPERCENTER #5341	-30.60	2024-01-09 18:57:47.153366+00	\N	{}
2028	1	1	2023-05-28	WM SUPERCENTER #5341	-12.94	2024-01-09 18:57:47.153366+00	\N	{}
2032	1	1	2023-05-26	THE HOME DEPOT #1506	-108.77	2024-01-09 18:57:47.153366+00	\N	{}
2033	1	1	2023-05-27	CAPITAL ONE ONLINE PYMT	369.70	2024-01-09 18:57:47.153366+00	\N	{}
2035	1	1	2023-05-25	WM SUPERCENTER #5341	-251.21	2024-01-09 18:57:47.153366+00	\N	{}
2036	1	1	2023-05-23	CAPITAL ONE ONLINE PYMT	31.60	2024-01-09 18:57:47.153366+00	\N	{}
1891	1	1	2023-09-01	DEN PUBLIC PARKING	-14.00	2024-01-09 18:57:47.153366+00	\N	{}
1892	1	1	2023-08-31	WM SUPERCENTER #5341	-301.45	2024-01-09 18:57:47.153366+00	\N	{}
1893	1	1	2023-08-30	CREDIT-CASH BACK REWARD	59.64	2024-01-09 18:57:47.153366+00	\N	{}
2039	1	1	2023-05-19	CAPITAL ONE ONLINE PYMT	128.18	2024-01-09 18:57:47.153366+00	\N	{}
2041	1	1	2023-05-15	WM SUPERCENTER #2729	-77.19	2024-01-09 18:57:47.153366+00	\N	{}
2042	1	1	2023-05-13	WINDSCRIBE.COM 81XHC4T	-3.00	2024-01-09 18:57:47.153366+00	\N	{}
2043	1	1	2023-05-11	CAPITAL ONE ONLINE PYMT	236.75	2024-01-09 18:57:47.153366+00	\N	{}
898	6	1	2022-08-13	ZSK*IT DE MIS PAIS MKT AURORA CO	-44.06	2024-01-09 18:17:44.325718+00	Supermarkets	{}
901	6	1	2022-08-15	INTERNET PAYMENT - THANK YOU	184.62	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
2145	5	1	2023-11-07	Payment - Thank You	79.30	2024-01-11 04:43:34.551039+00	\N	{}
2147	5	1	2023-11-06	First Watch - 0429	-54.68	2024-01-11 04:43:34.551039+00	\N	{}
2148	5	1	2023-11-05	Payment - Thank You	30.76	2024-01-11 04:43:34.551039+00	\N	{}
2150	5	1	2023-11-06	Rheinlander Bakery Inc	-12.49	2024-01-11 04:43:34.551039+00	\N	{}
780	6	1	2022-06-10	LA RUMBA DENVER CO	-20.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
612	6	1	2022-03-27	TST* AVOGADRO S NUMBER FORT COLLINS CO	-19.19	2024-01-09 18:17:44.325718+00	Restaurants	{}
614	6	1	2022-03-28	INTERNET PAYMENT - THANK YOU	128.07	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
615	6	1	2022-03-29	CSU CAMPUS RECREATION FORT COLLINS CO	-7.00	2024-01-09 18:17:44.325718+00	Education	{}
616	6	1	2022-03-29	INTERNET PAYMENT - THANK YOU	164.09	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
618	6	1	2022-03-30	AMAZON.COM*1695T3DU0 AMZN.COM/BILLWA74DLUL7AHTN	-589.37	2024-01-09 18:17:44.325718+00	Merchandise	{}
619	6	1	2022-03-31	AMAZON.COM*1603E6SA0 AMZN.COM/BILLWA1EERJ9FHJKC	-33.56	2024-01-09 18:17:44.325718+00	Merchandise	{}
620	6	1	2022-04-01	CSU INTERNATIONAL PROGRA 970-4914931 CO	-10.00	2024-01-09 18:17:44.325718+00	Education	{}
767	6	1	2022-06-05	LOAF N JUG # 0816 FORT COLLINS CO	-43.51	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
1888	1	1	2023-09-03	MCDONALD'S F7711	-3.45	2024-01-09 18:57:47.153366+00	\N	{Travel,texas}
1889	1	1	2023-09-03	MCDONALD'S F13570	-5.08	2024-01-09 18:57:47.153366+00	\N	{Travel,texas}
1890	1	1	2023-09-03	OST FOOD MART	-30.00	2024-01-09 18:57:47.153366+00	\N	{Travel,texas}
656	6	1	2022-04-26	AMAZON.COM*1O3XR0242 AMZN.COM/BILLWA5P75M9T8C9X	-24.72	2024-01-09 18:17:44.325718+00	Merchandise	{}
657	6	1	2022-04-27	INTERNET PAYMENT - THANK YOU	30.64	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
658	6	1	2022-04-28	CSU INTERNATIONAL PROGRA 970-4914931 CO	-10.00	2024-01-09 18:17:44.325718+00	Education	{}
659	6	1	2022-04-28	CSU INTERNATIONAL PROGRA 970-4914931 CO	-10.00	2024-01-09 18:17:44.325718+00	Education	{}
660	6	1	2022-04-28	INTERNET PAYMENT - THANK YOU	24.72	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
661	6	1	2022-04-29	FIVE GUYS CO300 QSR FORT COLLINS CO	-33.73	2024-01-09 18:17:44.325718+00	Restaurants	{}
663	6	1	2022-04-30	AVERY BREWING COMPANY BOULDER CO	-7.63	2024-01-09 18:17:44.325718+00	Restaurants	{}
664	6	1	2022-04-30	AVERY BREWING COMPANY BOULDER CO	-42.67	2024-01-09 18:17:44.325718+00	Restaurants	{}
665	6	1	2022-04-30	CHEESECAKE DENVER DENVER CO	-11.76	2024-01-09 18:17:44.325718+00	Restaurants	{}
666	6	1	2022-04-30	LAZ PARKING 760164 DENVER CO	-7.00	2024-01-09 18:17:44.325718+00	Services	{}
669	6	1	2022-05-02	INTERNET PAYMENT - THANK YOU	137.62	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
672	6	1	2022-05-03	INTERNET PAYMENT - THANK YOU	156.24	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
673	6	1	2022-05-03	NOODLES & CO 131 FORT COLLINS CO	-23.36	2024-01-09 18:17:44.325718+00	Restaurants	{}
1696	2	1	2024-01-03	Withdrawal from Mission Lane LLC EDI PYMNTS	-73.24	2024-01-09 18:34:47.445728+00	\N	{}
1698	2	1	2024-01-02	Withdrawal from DISCOVER E-PAYMENT	-55.61	2024-01-09 18:34:47.445728+00	\N	{}
789	6	1	2022-06-14	COFC WEBTRAC 8667566041 CO	-92.00	2024-01-09 18:17:44.325718+00	Services	{}
803	6	1	2022-06-20	AUNTIE ANNE'S #CO117 FORT COLLINS CO	-17.56	2024-01-09 18:17:44.325718+00	Restaurants	{}
804	6	1	2022-06-20	COSMOS PIZZA - FORT COLL FORT COLLINS CO	-17.04	2024-01-09 18:17:44.325718+00	Restaurants	{}
805	6	1	2022-06-20	INTERNET PAYMENT - THANK YOU	638.80	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
806	6	1	2022-06-21	AMAZON.COM*TY09V1HW3 AMZN.COM/BILLWA6ZHZ5N39093	-29.03	2024-01-09 18:17:44.325718+00	Merchandise	{}
1912	1	1	2023-08-21	CAPITAL ONE ONLINE PYMT	136.22	2024-01-09 18:57:47.153366+00	\N	{}
1913	1	1	2023-08-19	PACSUN #0435	-105.37	2024-01-09 18:57:47.153366+00	\N	{}
1914	1	1	2023-08-19	H&M0233	-141.11	2024-01-09 18:57:47.153366+00	\N	{}
807	6	1	2022-06-21	AMZN MKTP US*IQ4ZC7UF3 AMZN.COM/BILLWA24P7RZ00ZWA	-68.64	2024-01-09 18:17:44.325718+00	Merchandise	{}
808	6	1	2022-06-21	AUTOWASHMANHATTANAVE FORT COLLINS CO	-7.50	2024-01-09 18:17:44.325718+00	Automotive	{}
809	6	1	2022-06-21	COSMOS PIZZA - FORT COLL FORT COLLINS CO	-19.57	2024-01-09 18:17:44.325718+00	Restaurants	{}
810	6	1	2022-06-22	INTERNET PAYMENT - THANK YOU	140.02	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
812	6	1	2022-06-23	INTERNET PAYMENT - THANK YOU	122.21	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
815	6	1	2022-06-24	TST* WAFFLE LAB - THE FORT COLLINS CO00055008007548031395AA	-12.97	2024-01-09 18:17:44.325718+00	Restaurants	{}
1697	2	1	2024-01-02	Withdrawal from Mission Lane LLC EDI PYMNTS	-605.75	2024-01-09 18:34:47.445728+00	\N	{}
1700	2	1	2023-12-31	Monthly Interest Paid	0.07	2024-01-09 18:34:47.445728+00	\N	{}
1706	2	1	2023-12-22	Withdrawal from CAPITAL ONE ONLINE PMT	-212.74	2024-01-09 18:34:47.445728+00	\N	{}
1708	2	1	2023-12-21	Deposit from Colorado State U AP Payment	810.00	2024-01-09 18:34:47.445728+00	\N	{}
1709	2	1	2023-12-19	Withdrawal from DISCOVER E-PAYMENT	-25.35	2024-01-09 18:34:47.445728+00	\N	{}
1690	2	1	2024-01-04	Withdrawal to Savings XXXXXXX1843	-8778.68	2024-01-09 18:34:47.445728+00	\N	{}
1707	2	1	2023-12-21	Withdrawal to Savings XXXXXXX1843	-111.00	2024-01-09 18:34:47.445728+00	\N	{}
1711	2	1	2023-12-17	Deposit from Savings XXXXXXX1843	100.00	2024-01-09 18:34:47.445728+00	\N	{}
1713	2	1	2023-12-11	Withdrawal from DISCOVER E-PAYMENT	-219.63	2024-01-09 18:34:47.445728+00	\N	{}
1714	2	1	2023-12-11	Withdrawal from Mission Lane LLC EDI PYMNTS	-8.27	2024-01-09 18:34:47.445728+00	\N	{}
1715	2	1	2023-12-09	Withdrawal from CAPITAL ONE ONLINE PMT	-47.23	2024-01-09 18:34:47.445728+00	\N	{}
1717	2	1	2023-12-07	Withdrawal from Mission Lane LLC EDI PYMNTS	-37.50	2024-01-09 18:34:47.445728+00	\N	{}
1718	2	1	2023-12-06	Withdrawal from Mission Lane LLC EDI PYMNTS	-222.28	2024-01-09 18:34:47.445728+00	\N	{}
1719	2	1	2023-12-06	Withdrawal from CAPITAL ONE ONLINE PMT	-39.37	2024-01-09 18:34:47.445728+00	\N	{}
1789	2	1	2023-09-30	Monthly Interest Paid	0.05	2024-01-09 18:34:47.445728+00	\N	{}
949	6	1	2022-09-05	BUFFALO WILD WINGS 0122 FT. COLLINS CO	-17.48	2024-01-09 18:17:44.325718+00	Restaurants	{}
950	6	1	2022-09-05	INTERNET PAYMENT - THANK YOU	192.45	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
948	6	1	2022-09-04	TST* BRUES ALEHOUSE BR PUEBLO CO00074129008450856133AA	-48.11	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,"sand dunes"}
902	6	1	2022-08-16	INTERNET PAYMENT - THANK YOU	232.85	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
903	6	1	2022-08-19	SQ *LITTLE MAN ICE CRE FORT COLLINS CO0002305843016157414912	-9.76	2024-01-09 18:17:44.325718+00	Restaurants	{}
904	6	1	2022-08-20	INTERNET PAYMENT - THANK YOU	94.68	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
845	6	1	2022-07-15	FRONTIER ONLINE DS DENVER CO	-431.92	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,"Flight tickets"}
2139	5	1	2023-11-17	Payment - Thank You	810.00	2024-01-11 04:43:34.551039+00	\N	{}
2141	5	1	2023-11-16	American Meteorological	-810.00	2024-01-11 04:43:34.551039+00	\N	{}
2142	5	1	2023-11-14	Payment - Thank You	371.44	2024-01-11 04:43:34.551039+00	\N	{}
2144	5	1	2023-11-13	Tst* Fortissimo	-13.86	2024-01-11 04:43:34.551039+00	\N	{}
2152	5	1	2023-11-02	Cash Back Credit	13.95	2024-01-11 04:43:34.551039+00	\N	{}
2133	5	1	2023-11-21	Gateway Arch	-28.00	2024-01-11 04:43:34.551039+00	\N	{Travel,chicago}
2135	5	1	2023-11-20	Mcdonald's F10540	-7.92	2024-01-11 04:43:34.551039+00	\N	{Travel,chicago}
2136	5	1	2023-11-20	Gateway Arch Museum Store	-19.95	2024-01-11 04:43:34.551039+00	\N	{Travel,chicago}
2137	5	1	2023-11-20	24 7 Travel St	-29.13	2024-01-11 04:43:34.551039+00	\N	{Travel,chicago}
951	6	1	2022-09-07	INTERNET PAYMENT - THANK YOU	137.26	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
952	6	1	2022-09-09	COSMOS PIZZA - FORT COLL FORT COLLINS CO	-30.73	2024-01-09 18:17:44.325718+00	Restaurants	{}
1728	2	1	2023-11-29	Deposit from COLORADO STATE U Payroll	6935.67	2024-01-09 18:34:47.445728+00	\N	{}
1729	2	1	2023-11-29	Withdrawal from DISCOVER E-PAYMENT	-17.05	2024-01-09 18:34:47.445728+00	\N	{}
953	6	1	2022-09-10	4610 COLORADO ST UNIV FORT COLLINS CO01064R	-33.09	2024-01-09 18:17:44.325718+00	Restaurants	{}
954	6	1	2022-09-10	MCDONALD'S F19217 FORT COLLINS CO	-2.68	2024-01-09 18:17:44.325718+00	Restaurants	{}
955	6	1	2022-09-10	SMILE DOCTORS OF COLOR FORT COLLINS CO	-175.00	2024-01-09 18:17:44.325718+00	Medical Services	{}
1793	2	1	2023-09-28	Withdrawal to 360 Performance Savings XXXXXXX1843	-2000.00	2024-01-09 18:34:47.445728+00	\N	{}
1795	2	1	2023-09-11	Withdrawal to 360 Performance Savings XXXXXXX1843	-500.00	2024-01-09 18:34:47.445728+00	\N	{}
1796	2	1	2023-09-01	Preauthorized Deposit from WELLS FARGO BANK NA checking account XXXXXX1493	250.00	2024-01-09 18:34:47.445728+00	\N	{}
1797	2	1	2023-08-28	Preauthorized Deposit from WELLS FARGO BANK NA checking account XXXXXX1493	250.00	2024-01-09 18:34:47.445728+00	\N	{}
958	6	1	2022-09-14	OLIVE GARDE00013763140 FT COLLINS COGOOGLE PAY ENDING IN 4338	-50.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
959	6	1	2022-09-15	AFW - E-STORE #33 720-873-8635 CO	-0.68	2024-01-09 18:17:44.325718+00	Merchandise	{}
960	6	1	2022-09-16	INTERNET PAYMENT - THANK YOU	336.53	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
963	6	1	2022-09-19	APPLE.COM/BILL 866-712-7753 CAMLY73M3T09A0	-9.34	2024-01-09 18:17:44.325718+00	Merchandise	{}
964	6	1	2022-09-20	GREEN RIDE CO INC 334 821-3922 CO	-93.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
966	6	1	2022-09-21	INTERNET PAYMENT - THANK YOU	204.18	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
969	6	1	2022-09-28	INTERNET PAYMENT - THANK YOU	104.86	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
974	6	1	2022-10-10	INTERNET PAYMENT - THANK YOU	934.49	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
980	6	1	2022-10-15	INTERNET PAYMENT - THANK YOU	1327.06	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1919	1	1	2023-08-14	CAPITAL ONE ONLINE PYMT	203.52	2024-01-09 18:57:47.153366+00	\N	{}
1922	1	1	2023-08-12	WM SUPERCENTER #5341	-147.59	2024-01-09 18:57:47.153366+00	\N	{}
1924	1	1	2023-08-11	FLOYD S 99 SUPERIOR	-40.00	2024-01-09 18:57:47.153366+00	\N	{}
1925	1	1	2023-08-11	TST* Rooted Craft Kitc	-20.56	2024-01-09 18:57:47.153366+00	\N	{}
1926	1	1	2023-08-10	USPS PO 0710800147	-36.60	2024-01-09 18:57:47.153366+00	\N	{}
1927	1	1	2023-08-10	THE UPS STORE 1796	-30.00	2024-01-09 18:57:47.153366+00	\N	{}
983	6	1	2022-10-18	RIO GRANDE MEXICAN RES 9702181655 CO	-35.97	2024-01-09 18:17:44.325718+00	Restaurants	{}
984	6	1	2022-10-18	SUBWAY 62877 DENVER CO	-20.62	2024-01-09 18:17:44.325718+00	Restaurants	{}
985	6	1	2022-10-18	TST* BOYCHIK - AVANTI BOULDER CO00002443008993901204AA	-35.48	2024-01-09 18:17:44.325718+00	Restaurants	{}
986	6	1	2022-10-18	TST* RYE SOCIETY - AVA BOULDER CO00002442008993995827AA	-2.18	2024-01-09 18:17:44.325718+00	Restaurants	{}
987	6	1	2022-10-19	UCAR MESA LAB BOULDER CO01966R	-10.08	2024-01-09 18:17:44.325718+00	Restaurants	{}
988	6	1	2022-10-19	UCAR MESA LAB BOULDER CO01925R	10.08	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
989	6	1	2022-10-20	INTERNET PAYMENT - THANK YOU	842.72	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
973	6	1	2022-10-10	GEICO *AUTO 800-841-3000 DC6103674203221010144707	-1152.06	2024-01-09 18:17:44.325718+00	Services	{Auto,Insurance}
981	6	1	2022-10-17	AMAZON.COM*HT8SC9UX0 AMZN.COM/BILLWA7FZWP642D9S	-76.68	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,brazil}
727	6	1	2022-05-24	INTERNET PAYMENT - THANK YOU	165.88	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
728	6	1	2022-05-25	AMZN MKTP US*1R4PN98Y2 AMZN.COM/BILLWA3BTB4UM170V	-41.93	2024-01-09 18:17:44.325718+00	Merchandise	{}
729	6	1	2022-05-25	AMZN MKTP US*1R9XG3GN0 AMZN.COM/BILLWA6PXOHC342MP	-107.54	2024-01-09 18:17:44.325718+00	Merchandise	{}
730	6	1	2022-05-26	AMZN MKTP US*1R0ZU36D2 AMZN.COM/BILLWA1P51N0U8ZV3	-236.58	2024-01-09 18:17:44.325718+00	Merchandise	{}
733	6	1	2022-05-28	BEAR COUNTRY USA INC RAPID CITY SD	-4.23	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,badlands}
734	6	1	2022-05-28	BEAR COUNTRY USA INC RAPID CITY SD	-40.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,badlands}
739	6	1	2022-05-28	MOUNT RUSHMORE BOOKSTORE KEYSTONE SD	-13.73	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,badlands}
740	6	1	2022-05-28	MT RUSHMORE DINING KEYSTONE SD	-5.00	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,badlands}
990	6	1	2022-10-20	TST* ROOTED CRAFT KITC BOULDER CO00023207009016053863AA	-21.06	2024-01-09 18:17:44.325718+00	Restaurants	{}
991	6	1	2022-10-21	SQ *TRIDENT BOOKSELLER BOULDER CO0002305843016490440383	-4.81	2024-01-09 18:17:44.325718+00	Restaurants	{}
1000	6	1	2022-10-26	CHERRY CREEK 5940 DENVER CO	-2.00	2024-01-09 18:17:44.325718+00	Services	{}
1003	6	1	2022-10-28	INTERNET PAYMENT - THANK YOU	207.99	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1004	6	1	2022-10-28	PARKMOBILE 770-818-9036 GA622900387	-5.25	2024-01-09 18:17:44.325718+00	Services	{}
1774	2	1	2023-10-23	Withdrawal from CAPITAL ONE ONLINE PMT	-311.40	2024-01-09 18:34:47.445728+00	\N	{}
1028	6	1	2022-11-04	INTERNET PAYMENT - THANK YOU	1072.87	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1032	6	1	2022-11-10	CSU CAMPUS RECREATION FORT COLLINS CO	-33.00	2024-01-09 18:17:44.325718+00	Education	{}
1034	6	1	2022-11-10	SMILE DOCTORS OF COLOR FORT COLLINS CO	-175.00	2024-01-09 18:17:44.325718+00	Medical Services	{}
1036	6	1	2022-11-13	STARBUCKS 800-782-7282 SEATTLE WAGOOGLE PAY ENDING IN 9955	-25.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
1039	6	1	2022-11-15	INTERNET PAYMENT - THANK YOU	556.97	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1040	6	1	2022-11-17	CHIPOTLE 0250 FORT COLLINS COGOOGLE PAY ENDING IN 9955	-24.20	2024-01-09 18:17:44.325718+00	Restaurants	{}
858	6	1	2022-07-20	INTERNET PAYMENT - THANK YOU	1041.50	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1041	6	1	2022-11-17	DURRELL EXPRESS FORT COLLINS CO	-21.51	2024-01-09 18:17:44.325718+00	Education	{}
1046	6	1	2022-11-22	INTERNET PAYMENT - THANK YOU	308.50	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1047	6	1	2022-11-22	TST* HUHOT MONGOLIAN GRI FORT COLLINS CO	-15.97	2024-01-09 18:17:44.325718+00	Restaurants	{}
1048	6	1	2022-11-22	TST* HUHOT MONGOLIAN GRI FORT COLLINS CO	-19.18	2024-01-09 18:17:44.325718+00	Restaurants	{}
1054	6	1	2022-11-24	GOOGLE *YOUTUBE TV G.CO/HELPPAY#CAP0NYKJ2W	-67.39	2024-01-09 18:17:44.325718+00	Merchandise	{}
1056	6	1	2022-11-26	KFC/TB #436 FORT COLLINS CO	-33.31	2024-01-09 18:17:44.325718+00	Restaurants	{}
1059	6	1	2022-11-28	INTERNET PAYMENT - THANK YOU	598.65	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1060	6	1	2022-11-30	INTERNET PAYMENT - THANK YOU	543.48	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1064	6	1	2022-12-03	COSMOS PIZZA - FORT COLL FORT COLLINS CO	-15.95	2024-01-09 18:17:44.325718+00	Restaurants	{}
1065	6	1	2022-12-03	SQ *DENVER CHRISTKINDL DENVER CO0001152921512248358013	-18.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
1066	6	1	2022-12-04	AMZN MKTP US*3J1FL2843 AMZN.COM/BILLWA5DDSWM3U2F5	-0.43	2024-01-09 18:17:44.325718+00	Merchandise	{}
1930	1	1	2023-08-09	Subway 12813	-8.77	2024-01-09 18:57:47.153366+00	\N	{}
1931	1	1	2023-08-09	CAPITAL ONE ONLINE PYMT	82.74	2024-01-09 18:57:47.153366+00	\N	{}
1932	1	1	2023-08-08	USPS PO 0710800147	-6.47	2024-01-09 18:57:47.153366+00	\N	{}
54	7	1	2023-09-30	Monthly Interest Paid	3.44	2024-01-09 05:13:55.402661+00	\N	{}
1069	6	1	2022-12-05	INTERNET PAYMENT - THANK YOU	269.60	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1072	6	1	2022-12-10	SMILE DOCTORS OF COLOR FORT COLLINS CO	-175.00	2024-01-09 18:17:44.325718+00	Medical Services	{}
1074	6	1	2022-12-12	CSU CAMPUS RECREATION FORT COLLINS CO	-16.50	2024-01-09 18:17:44.325718+00	Education	{}
1075	6	1	2022-12-12	CSU CAMPUS RECREATION FORT COLLINS CO	-33.00	2024-01-09 18:17:44.325718+00	Education	{}
1076	6	1	2022-12-12	THAI STATION RESTAURANT FORT COLLINS CO	-33.81	2024-01-09 18:17:44.325718+00	Restaurants	{}
1079	6	1	2022-12-14	INTERNET PAYMENT - THANK YOU	545.21	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1080	6	1	2022-12-15	MCDONALD'S F19217 FORT COLLINS CO	-3.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
1081	6	1	2022-12-16	044 TORCHYS FT COLLINS FORT COLLINS COGOOGLE PAY ENDING IN 9955	-27.20	2024-01-09 18:17:44.325718+00	Restaurants	{}
1082	6	1	2022-12-17	DUNKIN #353996 LOVELAND CO	-5.32	2024-01-09 18:17:44.325718+00	Restaurants	{}
1083	6	1	2022-12-17	GOOGLE *DOMAINS G.CO/HELPPAY#CAP0O6RHUH	-12.00	2024-01-09 18:17:44.325718+00	Services	{}
166	3	1	2023-05-30	Crowne at Old To Payment XXXXX0997 Vanderlei Rocha De Var	-94.07	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
186	3	1	2023-04-27	Crowne at Old To Payment XXXXX0388 Vanderlei Rocha De Var	-2211.00	2024-01-09 18:10:05.987144+00	\N	{Household,Rent}
1205	6	1	2023-03-10	SMILE DOCTORS OF COLOR FORT COLLINS CO	-175.00	2024-01-09 18:17:44.325718+00	Medical Services	{Travel,switzerland}
1928	1	1	2023-08-09	QT 4202 OUTSIDE	-27.17	2024-01-09 18:57:47.153366+00	\N	{Auto,Gas}
1090	6	1	2022-12-20	INTERNET PAYMENT - THANK YOU	207.35	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1093	6	1	2022-12-22	STARBUCKS 800-782-7282 SEATTLE WAGOOGLE PAY ENDING IN 9955	-25.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
1095	6	1	2022-12-24	INTERNET PAYMENT - THANK YOU	234.03	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1097	6	1	2022-12-28	INTERNET PAYMENT - THANK YOU	196.83	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1098	6	1	2022-12-29	FLOYD'S 99 ELIZABETH FORT COLLINS CO	-40.00	2024-01-09 18:17:44.325718+00	Services	{}
1100	6	1	2023-01-01	CHEESECAKE DENVER DENVER CO	-74.75	2024-01-09 18:17:44.325718+00	Restaurants	{}
1101	6	1	2023-01-01	PARKWELL TABOR CENTER DENVER CO	-7.00	2024-01-09 18:17:44.325718+00	Services	{}
1102	6	1	2023-01-01	TST* VIBE COFFEE & WINE DENVER CO	-14.59	2024-01-09 18:17:44.325718+00	Restaurants	{}
1104	6	1	2023-01-03	COCA COLA JOHNSTOWN CO JOHNSTOWN COGOOGLE PAY ENDING IN 9955	-2.25	2024-01-09 18:17:44.325718+00	Restaurants	{}
1108	6	1	2023-01-07	PARKWELL TABOR CENTER DENVER CO	-7.00	2024-01-09 18:17:44.325718+00	Services	{}
1110	6	1	2023-01-08	TST* 5280 BURGER BAR D 303-825-1020 CO00080973009947614283AA	-53.60	2024-01-09 18:17:44.325718+00	Restaurants	{}
1111	6	1	2023-01-09	MAGGIANOS DWNTWN DENVER 800-983-4637 CO	-50.35	2024-01-09 18:17:44.325718+00	Restaurants	{}
1112	6	1	2023-01-10	SMILE DOCTORS OF COLOR FORT COLLINS CO	-175.00	2024-01-09 18:17:44.325718+00	Medical Services	{}
1113	6	1	2023-01-11	HYATT REG DENVER CC CA DENVER COGOOGLE PAY ENDING IN 9955	-7.48	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
1114	6	1	2023-01-12	CORNER BAKERY CAFE 1510 DENVER COGOOGLE PAY ENDING IN 9955	-12.41	2024-01-09 18:17:44.325718+00	Restaurants	{}
1116	6	1	2023-01-12	RMCF PAVILIONS DENVER CO	-3.74	2024-01-09 18:17:44.325718+00	Merchandise	{}
1118	6	1	2023-01-13	CO DRIVER SERVICES 303-534-3468 CO	-19.70	2024-01-09 18:17:44.325718+00	Government Services	{}
1119	6	1	2023-01-13	INTERNET PAYMENT - THANK YOU	783.70	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1120	6	1	2023-01-13	MOUNTAIN STATE DRIVERS E FORT COLLINS CO	-160.00	2024-01-09 18:17:44.325718+00	Education	{}
1246	6	1	2023-04-28	INTERNET PAYMENT - THANK YOU	174.78	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1123	6	1	2023-01-14	IN *ESTES PARK MOUNTAI ESTES PARK COARCW0WMZ	-10.37	2024-01-09 18:17:44.325718+00	Merchandise	{}
1124	6	1	2023-01-15	CSU CAMPUS RECREATION FORT COLLINS CO	-33.00	2024-01-09 18:17:44.325718+00	Education	{}
1136	6	1	2023-01-28	INTERNET PAYMENT - THANK YOU	113.38	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1137	6	1	2023-01-28	MCDONALD'S F19217 FORT COLLINS COGOOGLE PAY ENDING IN 9955	-3.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
1139	6	1	2023-01-30	CSU CAMPUS RECREATION FORT COLLINS CO	-16.50	2024-01-09 18:17:44.325718+00	Education	{}
1143	6	1	2023-02-01	GOOGLE ADS9724932760 ADS.GOOGLE.COCA	-30.76	2024-01-09 18:17:44.325718+00	Services	{}
1147	6	1	2023-02-05	STARBUCKS 800-782-7282 SEATTLE WAGOOGLE PAY ENDING IN 9955	-25.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
1920	1	1	2023-08-13	KING SOOPERS #0102	-6.50	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1933	1	1	2023-08-07	KING SOOPERS #0086	-30.24	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1149	6	1	2023-02-09	SNOWY RANGE ECOMMERCE 307-745-5750 WY	-122.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
1150	6	1	2023-02-10	MCDONALD'S F19217 FORT COLLINS CO	-15.99	2024-01-09 18:17:44.325718+00	Restaurants	{}
1151	6	1	2023-02-10	SMILE DOCTORS OF COLOR FORT COLLINS CO	-175.00	2024-01-09 18:17:44.325718+00	Medical Services	{}
1153	6	1	2023-02-11	CRISP & GREEN - FORT C 9702843200 CO	-23.08	2024-01-09 18:17:44.325718+00	Restaurants	{}
1154	6	1	2023-02-11	TST* SNOWY JOE HOT CHOCO CENTENNIAL WY	-6.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
1155	6	1	2023-02-12	BONDI BEACH BAR FORT COLLINS CO	-19.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
1161	6	1	2023-02-14	INTERNET PAYMENT - THANK YOU	1083.17	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1163	6	1	2023-02-17	COCA COLA JOHNSTOWN CO JOHNSTOWN CO	-2.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
1164	6	1	2023-02-17	THAI STATION RESTAURAN 970-797-2707 CO	-38.76	2024-01-09 18:17:44.325718+00	Restaurants	{}
1166	6	1	2023-02-18	STORE*TORCHYS TACOS 6506819470 CA	-29.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
1167	6	1	2023-02-20	INTERNET PAYMENT - THANK YOU	251.87	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
73	7	2	2023-09-30	Monthly Interest Paid	9.59	2024-01-09 05:15:00.412025+00	\N	{}
1169	6	1	2023-02-23	MCDONALD'S F19217 FORT COLLINS CO	-6.97	2024-01-09 18:17:44.325718+00	Restaurants	{}
1170	6	1	2023-02-23	MCDONALD'S F19217 FORT COLLINS CO	-12.47	2024-01-09 18:17:44.325718+00	Restaurants	{}
1187	6	1	2023-02-28	INTERNET PAYMENT - THANK YOU	421.73	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1195	6	1	2023-03-04	DICKS SPORTING GOODS FORTCOLLINS TN	-59.26	2024-01-09 18:17:44.325718+00	Merchandise	{}
1197	6	1	2023-03-04	ROSS STORES #1884 FORT COLLINS CO	-69.87	2024-01-09 18:17:44.325718+00	Merchandise	{}
1203	6	1	2023-03-08	MCDONALD'S F19217 FORT COLLINS CO	-23.84	2024-01-09 18:17:44.325718+00	Restaurants	{}
1207	6	1	2023-03-17	INTERNET PAYMENT - THANK YOU	314.19	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1210	6	1	2023-03-28	INTERNET PAYMENT - THANK YOU	13.93	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1212	6	1	2023-03-29	PARKMOBILE 770-818-9036 GA675899264	-10.45	2024-01-09 18:17:44.325718+00	Services	{}
1732	2	1	2023-11-28	Withdrawal from CHUZE FIT CLUB FEES	-24.99	2024-01-09 18:34:47.445728+00	\N	{}
1733	2	1	2023-11-27	Withdrawal from CAPITAL ONE ONLINE PMT	-74.07	2024-01-09 18:34:47.445728+00	\N	{}
1734	2	1	2023-11-27	Withdrawal from WELLS FARGO CARD CCPYMT	-105.16	2024-01-09 18:34:47.445728+00	\N	{}
1735	2	1	2023-11-27	Withdrawal from DISCOVER E-PAYMENT	-21.45	2024-01-09 18:34:47.445728+00	\N	{}
1736	2	1	2023-11-24	Withdrawal from CAPITAL ONE ONLINE PMT	-116.85	2024-01-09 18:34:47.445728+00	\N	{}
1737	2	1	2023-11-24	Withdrawal from Mission Lane Vis Mission La	-256.15	2024-01-09 18:34:47.445728+00	\N	{}
1740	2	1	2023-11-22	Deposit from WELLS FARGO IFI ACCTVERIFY	0.29	2024-01-09 18:34:47.445728+00	\N	{}
1741	2	1	2023-11-22	Deposit from WELLS FARGO IFI ACCTVERIFY	0.27	2024-01-09 18:34:47.445728+00	\N	{}
1747	2	1	2023-11-17	Zelle money received from Sandra De Vargas	430.00	2024-01-09 18:34:47.445728+00	\N	{}
1749	2	1	2023-11-15	Withdrawal from Mission Lane Vis Mission La	-371.44	2024-01-09 18:34:47.445728+00	\N	{}
1215	6	1	2023-04-01	THAI STATION RESTAURAN 970-797-2707 CO	-35.55	2024-01-09 18:17:44.325718+00	Restaurants	{}
1216	6	1	2023-04-03	STARBUCKS 800-782-7282 SEATTLE WAGOOGLE PAY ENDING IN 9955	-25.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
1219	6	1	2023-04-05	PARKMOBILE 770-818-9036 GA678416832	-6.50	2024-01-09 18:17:44.325718+00	Services	{}
1221	6	1	2023-04-06	INTERNET PAYMENT - THANK YOU	651.12	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1224	6	1	2023-04-10	SMILE DOCTORS OF COLOR FORT COLLINS CO	-175.00	2024-01-09 18:17:44.325718+00	Medical Services	{}
1227	6	1	2023-04-13	FLOYD'S 99 ELIZABETH FORT COLLINS CO	-40.00	2024-01-09 18:17:44.325718+00	Services	{}
80	8	2	2023-12-31	Monthly Interest Paid	83.04	2024-01-09 05:16:32.935013+00	\N	{}
82	8	1	2024-01-01	Monthly Interest Paid	80.37	2024-01-09 05:16:45.322177+00	\N	{}
85	3	1	2023-11-15	ACCOUNT CLOSE CASHIER'S CHECK	-500.04	2024-01-09 18:10:05.987144+00	\N	{}
86	3	1	2023-11-15	OUTSTANDING ITEMS CLOSE, NON-INT W/O FEE	0.00	2024-01-09 18:10:05.987144+00	\N	{}
87	3	1	2023-10-20	CAPITAL ONE TRANSFER RT0155DAE49B938 Vanderlei Junior	274.00	2024-01-09 18:10:05.987144+00	\N	{}
89	3	1	2023-09-28	DISCOVER E-PAYMENT 230928 7277 ROCHADEVARGAS V	-15.82	2024-01-09 18:10:05.987144+00	\N	{}
90	3	1	2023-09-28	CHUZE FIT CLUB FEES 2327000234103 720-210-9723	-24.99	2024-01-09 18:10:05.987144+00	\N	{}
91	3	1	2023-09-25	CAPITAL ONE ONLINE PMT 230925 3SEDINKSOOWE23K VANDERLEI ROCHA DE VAR	-27.50	2024-01-09 18:10:05.987144+00	\N	{}
1228	6	1	2023-04-13	INTERNET PAYMENT - THANK YOU	288.37	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1235	6	1	2023-04-17	AMAZON.COM*HV2S10XP0 AMZN.COM/BILLWA5O1R2J4STZU	-43.56	2024-01-09 18:17:44.325718+00	Merchandise	{}
1237	6	1	2023-04-19	PARKMOBILE 770-818-9036 GA684488527	-4.45	2024-01-09 18:17:44.325718+00	Services	{}
1245	6	1	2023-04-28	CASHBACK BONUS REDEMPTION PYMT/STMT CRDT	704.06	2024-01-09 18:17:44.325718+00	Awards and Rebate Credits	{}
1247	6	1	2023-04-29	CHATGPT SUBSCRIPTION 4158799686 CA	-20.00	2024-01-09 18:17:44.325718+00	Merchandise	{}
1248	6	1	2023-04-29	SNOOZE FORT COLLINS 103 858-7035300 CO	-50.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
1251	6	1	2023-05-02	E 470 EXPRESS TOLLS AURORA CO	-30.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
1252	6	1	2023-05-03	AMZN MKTP US*IX5726QD3 AMZN.COM/BILLWA1TLN3735V37	-78.01	2024-01-09 18:17:44.325718+00	Merchandise	{}
1751	2	1	2023-11-15	Withdrawal from CAPITAL ONE ONLINE PMT	-82.82	2024-01-09 18:34:47.445728+00	\N	{}
1916	1	1	2023-08-18	WALMART.COM	-125.47	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1871	1	1	2023-09-19	KING SOOPERS #0086	-27.50	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1254	6	1	2023-05-05	BLUE AGAVE GRILL FORT COLLINS CO	-55.81	2024-01-09 18:17:44.325718+00	Restaurants	{}
1255	6	1	2023-05-06	TRADER JOE S #304 FORT COLLINS CO	-9.18	2024-01-09 18:17:44.325718+00	Supermarkets	{}
1256	6	1	2023-05-10	E 470 EXPRESS TOLLS AURORA CO	-30.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
1257	6	1	2023-05-10	SMILE DOCTORS OF COLOR FORT COLLINS CO	-175.00	2024-01-09 18:17:44.325718+00	Medical Services	{}
1258	6	1	2023-05-11	INTERNET PAYMENT - THANK YOU	691.40	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1259	6	1	2023-05-12	BAWARCHI BIRUANIS FORT COLLINS COGOOGLE PAY ENDING IN 9955	-58.95	2024-01-09 18:17:44.325718+00	Restaurants	{}
1260	6	1	2023-05-13	AMZN MKTP US*AM9VU3423 AMZN.COM/BILLWAOQFZLFISUNC	-143.29	2024-01-09 18:17:44.325718+00	Merchandise	{}
1262	6	1	2023-05-16	PARKMOBILE 770-818-9036 GA695285922	-4.70	2024-01-09 18:17:44.325718+00	Services	{}
1263	6	1	2023-05-18	MCDONALD'S F19217 FORT COLLINS CO	-9.88	2024-01-09 18:17:44.325718+00	Restaurants	{}
1264	6	1	2023-05-18	MCDONALD'S F19217 FORT COLLINS CO	-12.47	2024-01-09 18:17:44.325718+00	Restaurants	{}
1265	6	1	2023-05-19	ELITE AUTOMOTIVE 800-789-3638 CO	-194.43	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
1266	6	1	2023-05-19	KFC/TB #436 FORT COLLINS CO	-20.27	2024-01-09 18:17:44.325718+00	Restaurants	{}
1267	6	1	2023-05-19	PARKMOBILE 770-818-9036 GA696198513	-3.95	2024-01-09 18:17:44.325718+00	Services	{}
1271	6	1	2023-05-20	SARKU JAPAN 162 BROOMFIELD CO	-13.88	2024-01-09 18:17:44.325718+00	Restaurants	{}
1272	6	1	2023-05-20	U-HAUL CO 800-789-3638 CO	-15.31	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
1276	6	1	2023-05-22	E 470 EXPRESS TOLLS AURORA CO	-26.70	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
1277	6	1	2023-05-22	INTERNET PAYMENT - THANK YOU	300.00	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1278	6	1	2023-05-23	PARKMOBILE 770-818-9036 GA697983772	-8.85	2024-01-09 18:17:44.325718+00	Services	{}
1279	6	1	2023-05-23	TST* AVOGADROS NUMBER FORT COLLINS CO00026422011862238410AA	-16.19	2024-01-09 18:17:44.325718+00	Restaurants	{}
1280	6	1	2023-05-29	INTERNET PAYMENT - THANK YOU	666.52	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1281	6	1	2023-05-30	CHATGPT SUBSCRIPTION 4158799686 CA	-20.00	2024-01-09 18:17:44.325718+00	Merchandise	{}
1284	6	1	2023-06-01	PARKMOBILE 770-818-9036 GA701371259	-3.95	2024-01-09 18:17:44.325718+00	Services	{}
1378	6	1	2023-12-07	CANTEEN VENDING DENVER CO	-1.35	2024-01-09 18:17:44.325718+00	Restaurants	{}
1379	6	1	2023-12-08	INTERNET PAYMENT - THANK YOU	219.63	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1285	6	1	2023-06-02	PARKMOBILE 770-818-9036 GA701495697	-2.95	2024-01-09 18:17:44.325718+00	Services	{}
1287	6	1	2023-06-04	PARKMOBILE 770-818-9036 CO702188425	-12.95	2024-01-09 18:17:44.325718+00	Services	{}
1894	1	1	2023-08-30	CAPITAL ONE ONLINE PYMT	1818.41	2024-01-09 18:57:47.153366+00	\N	{}
1898	1	1	2023-08-25	DCA FOOD HALL	-7.28	2024-01-09 18:57:47.153366+00	\N	{}
1899	1	1	2023-08-25	LAZ PARKING 570222	-22.00	2024-01-09 18:57:47.153366+00	\N	{}
96	3	1	2023-09-13	FID BKG SVC LLC MONEYLINE 230913 242275844 58I0E V ROCHA DE VARGAS JUNI	362.82	2024-01-09 18:10:05.987144+00	\N	{}
97	3	1	2023-09-12	CAPITAL ONE ONLINE PMT 230912 3SBTFX2ERLEE04G VANDERLEI ROCHA DE VAR	-20.97	2024-01-09 18:10:05.987144+00	\N	{}
98	3	1	2023-09-12	VENMO CASHOUT 230912 1029359415903 VANDERLEI ROCHA DE VAR	200.00	2024-01-09 18:10:05.987144+00	\N	{}
99	3	1	2023-09-11	CAPITAL ONE ONLINE PMT 230910 3SBENCZXAWCZL7K VANDERLEI ROCHA DE VAR	-158.26	2024-01-09 18:10:05.987144+00	\N	{}
100	3	1	2023-09-11	DISCOVER E-PAYMENT 230910 7277 ROCHADEVARGAS V	-200.65	2024-01-09 18:10:05.987144+00	\N	{}
101	3	1	2023-09-11	LABCORP LABCORP 230909 202309085955054 25571434	-15.60	2024-01-09 18:10:05.987144+00	\N	{}
102	3	1	2023-09-11	VENMO CASHOUT 230911 1029344129373 VANDERLEI ROCHA DE VAR	5.00	2024-01-09 18:10:05.987144+00	\N	{}
103	3	1	2023-09-11	ZELLE FROM DE VARGAS SANDRA ON 09/11 REF # PP0RK9ZVVZ	5.00	2024-01-09 18:10:05.987144+00	\N	{}
104	3	1	2023-09-11	Colorado State U AP Payment 091123 89993 33134381*120.00*120.00*Info: Hutson, Maranda J 0	120.00	2024-01-09 18:10:05.987144+00	\N	{}
105	3	1	2023-09-11	FID BKG SVC LLC MONEYLINE 230911 242275844 538S6 V ROCHA DE VARGAS JUNI	15.60	2024-01-09 18:10:05.987144+00	\N	{}
106	3	1	2023-09-07	CAPITAL ONE ONLINE PMT 230907 3SARGA38YS4QRKW VANDERLEI ROCHA DE VAR	-363.98	2024-01-09 18:10:05.987144+00	\N	{}
1348	6	1	2023-09-03	UBER TRIP 866-576-1039 CA	-64.98	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,texas}
1349	6	1	2023-09-05	PARKMOBILE 770-818-9036 TX739710416	-1.20	2024-01-09 18:17:44.325718+00	Services	{Travel,texas}
1350	6	1	2023-09-05	PARKMOBILE 770-818-9036 TX739675876	-2.20	2024-01-09 18:17:44.325718+00	Services	{Travel,texas}
860	6	1	2022-07-20	LEARN ENGLISH WITH SAN SAN FRANCISCOCA	-25.00	2024-01-09 18:17:44.325718+00	Services	{}
863	6	1	2022-07-23	WIX.COM, INC. SAN FRANCISCOCA	-192.00	2024-01-09 18:17:44.325718+00	Merchandise	{}
864	6	1	2022-07-24	STARBUCKS STORE 06570 FORT COLLINS CO9223CE2D19BF668553	-11.29	2024-01-09 18:17:44.325718+00	Restaurants	{}
865	6	1	2022-07-25	TST* HUHOT MONGOLIAN GRI FORT COLLINS CO	-38.30	2024-01-09 18:17:44.325718+00	Restaurants	{}
1336	6	1	2023-08-25	DCA FOOD HALL ARLINGTON VA	-18.53	2024-01-09 18:17:44.325718+00	Supermarkets	{}
1337	6	1	2023-08-25	PARKMOBILE 770-818-9036 DC735260805	-1.70	2024-01-09 18:17:44.325718+00	Services	{}
1289	6	1	2023-06-08	CASHBACK BONUS REDEMPTION PYMT/STMT CRDT	18.96	2024-01-09 18:17:44.325718+00	Awards and Rebate Credits	{}
1290	6	1	2023-06-08	INTERNET PAYMENT - THANK YOU	383.97	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1291	6	1	2023-06-10	PARKMOBILE 770-818-9036 GA704583822	-5.80	2024-01-09 18:17:44.325718+00	Services	{}
1292	6	1	2023-06-10	SMILE DOCTORS OF COLOR FORT COLLINS CO	-175.00	2024-01-09 18:17:44.325718+00	Medical Services	{}
1293	6	1	2023-06-14	INTERNET PAYMENT - THANK YOU	180.80	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1295	6	1	2023-06-20	BEST BUY MH00002097295 WESTMINSTER COGOOGLE PAY ENDING IN 9955	-16.23	2024-01-09 18:17:44.325718+00	Merchandise	{}
1297	6	1	2023-06-26	STARBUCKS 800-782-7282 800-782-7282 WAGOOGLE PAY ENDING IN 99553BFTIEZ5G7ZNRS4Z	-15.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
1298	6	1	2023-06-29	6412 CHUZE FITNESS BROOMFIELD CO	-1.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
1299	6	1	2023-06-29	CASHBACK BONUS REDEMPTION PYMT/STMT CRDT	9.74	2024-01-09 18:17:44.325718+00	Awards and Rebate Credits	{}
1300	6	1	2023-06-29	INTERNET PAYMENT - THANK YOU	365.77	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1305	6	1	2023-07-05	GOOGLE *DOMAINS G.CO/HELPPAY#CAP0T6RYTT	-7.00	2024-01-09 18:17:44.325718+00	Merchandise	{}
1306	6	1	2023-07-05	INTERNET PAYMENT - THANK YOU	165.12	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1307	6	1	2023-07-14	SQ *GELATO BOY BOULDER CO0001152921512977934321	-8.86	2024-01-09 18:17:44.325718+00	Supermarkets	{}
1308	6	1	2023-07-14	TST* CENTRO MEXICAN BOULDER CO00032776012685511705AA	-85.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
1309	6	1	2023-07-15	KMC DENVER ZOO DENVER CO	-7.01	2024-01-09 18:17:44.325718+00	Merchandise	{}
1310	6	1	2023-07-15	THE HOME DEPOT #1506 LOUISVILLE CO	-238.29	2024-01-09 18:17:44.325718+00	Home Improvement	{}
1311	6	1	2023-07-16	HAPA SUSHI - CHERRY CR DENVER COGOOGLE PAY ENDING IN 9955	-34.56	2024-01-09 18:17:44.325718+00	Restaurants	{}
1314	6	1	2023-07-24	OLIVE GARDEN EC 0021417 303-650-0889 COGOOGLE PAY ENDING IN 9955	-40.60	2024-01-09 18:17:44.325718+00	Restaurants	{}
1316	6	1	2023-07-28	AMAZON.COM*T69875KJ1 AMZN.COM/BILLWA41MDC7I9J31	-65.16	2024-01-09 18:17:44.325718+00	Merchandise	{}
1317	6	1	2023-07-28	GOOGLE *APPYHAPPS G.CO/HELPPAY#CAP0TIGS6C	-3.49	2024-01-09 18:17:44.325718+00	Merchandise	{}
1320	6	1	2023-08-02	COLORADO STATE UNIVERSIT 970-4916909 CO	-70.00	2024-01-09 18:17:44.325718+00	Education	{}
1321	6	1	2023-08-03	INTERNET PAYMENT - THANK YOU	226.45	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1324	6	1	2023-08-06	TST* TANGERINE - LAFAY LAFAYETTE CO00113009013065924562AA	-58.05	2024-01-09 18:17:44.325718+00	Restaurants	{}
1325	6	1	2023-08-09	INTERNET PAYMENT - THANK YOU	813.58	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
134	3	1	2023-07-28	DISCOVER E-PAYMENT 230728 7277 ROCHADEVARGAS V	-60.60	2024-01-09 18:10:05.987144+00	\N	{}
135	3	1	2023-07-26	CAPITAL ONE ONLINE PMT 230726 3S1PCOJW1WS8UU8 VANDERLEI ROCHA DE VAR	-232.19	2024-01-09 18:10:05.987144+00	\N	{}
867	6	1	2022-07-28	INTERNET PAYMENT - THANK YOU	528.04	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1371	6	1	2023-11-20	STARBUCKS 800-782-7282 SEATTLE WA	-15.00	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,chicago}
136	3	1	2023-07-19	DISCOVER E-PAYMENT 230719 7277 ROCHADEVARGAS V	-34.56	2024-01-09 18:10:05.987144+00	\N	{}
137	3	1	2023-07-18	DISCOVER E-PAYMENT 230718 7277 ROCHADEVARGAS V	-652.07	2024-01-09 18:10:05.987144+00	\N	{}
139	3	1	2023-07-17	CAPITAL ONE ONLINE PMT 230717 3RZSE8P6ACAG3Z4 VANDERLEI ROCHA DE VAR	-24.92	2024-01-09 18:10:05.987144+00	\N	{}
141	3	1	2023-07-12	CAPITAL ONE ONLINE PMT 230712 3RYQRDK7GMNJTB4 VANDERLEI ROCHA DE VAR	-498.60	2024-01-09 18:10:05.987144+00	\N	{}
142	3	1	2023-07-07	COLORADO STATE U Payroll 070723 89993-3 ROCHA DE VARGAS JUNIOR	1654.70	2024-01-09 18:10:05.987144+00	\N	{}
143	3	1	2023-07-06	DISCOVER E-PAYMENT 230706 7277 ROCHADEVARGAS V	-165.12	2024-01-09 18:10:05.987144+00	\N	{}
145	3	1	2023-07-06	CAPITAL ONE ONLINE PMT 230706 3RXA444LRQPEEJK VANDERLEI ROCHA DE VAR	-527.92	2024-01-09 18:10:05.987144+00	\N	{}
1326	6	1	2023-08-09	PARKMOBILE 770-818-9036 GA728412592	-1.25	2024-01-09 18:17:44.325718+00	Services	{}
1328	6	1	2023-08-19	AMZN MKTP US*TO32Z2YG1 AMZN.COM/BILLWA41HKUU7ICO7	-126.17	2024-01-09 18:17:44.325718+00	Merchandise	{}
1329	6	1	2023-08-19	CHEESECAKE DENVER DENVER CO	-75.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
1330	6	1	2023-08-19	PARKWELL - TABOR CENTER DENVER CO	-8.00	2024-01-09 18:17:44.325718+00	Services	{}
1331	6	1	2023-08-21	CASHBACK BONUS REDEMPTION PYMT/STMT CRDT	10.79	2024-01-09 18:17:44.325718+00	Awards and Rebate Credits	{}
1332	6	1	2023-08-21	INTERNET PAYMENT - THANK YOU	346.63	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1333	6	1	2023-08-22	HARVARD BUS EDUCATION 617-783-7600 MA4493782	-22.05	2024-01-09 18:17:44.325718+00	Merchandise	{}
1334	6	1	2023-08-24	UBER TRIP 866-576-1039 CA	-38.90	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
1335	6	1	2023-08-25	DCA FOOD HALL ARLINGTON VA	-4.23	2024-01-09 18:17:44.325718+00	Supermarkets	{}
1380	6	1	2023-12-16	GOOGLE *DOMAINS G.CO/HELPPAY#CAP0XRQ2QB	-12.00	2024-01-09 18:17:44.325718+00	Merchandise	{}
1381	6	1	2023-12-17	GOOGLE *DOMAINS G.CO/HELPPAY#CAP0XTSSUK	-12.00	2024-01-09 18:17:44.325718+00	Merchandise	{}
1382	6	1	2023-12-18	INTERNET PAYMENT - THANK YOU	25.35	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1343	6	1	2023-08-30	CASHBACK BONUS REDEMPTION PYMT/STMT CRDT	17.12	2024-01-09 18:17:44.325718+00	Awards and Rebate Credits	{}
1345	6	1	2023-08-30	INTERNET PAYMENT - THANK YOU	104.51	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1346	6	1	2023-09-01	INTERNET PAYMENT - THANK YOU	157.38	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1352	6	1	2023-09-07	INTERNET PAYMENT - THANK YOU	98.23	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1353	6	1	2023-09-10	INTERNET PAYMENT - THANK YOU	200.65	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1354	6	1	2023-09-17	PARKMOBILE 770-818-9036 GA744955434	-1.85	2024-01-09 18:17:44.325718+00	Services	{}
1355	6	1	2023-09-26	CHATGPT SUBSCRIPTION 4158799686 CA	-20.00	2024-01-09 18:17:44.325718+00	Merchandise	{}
1356	6	1	2023-09-28	CASHBACK BONUS REDEMPTION PYMT/STMT CRDT	6.03	2024-01-09 18:17:44.325718+00	Awards and Rebate Credits	{}
835	6	1	2022-07-07	AMZN MKTP US*O48IX7EN3 AMZN.COM/BILLWA4VRMI3AP033	-92.46	2024-01-09 18:17:44.325718+00	Merchandise	{}
836	6	1	2022-07-08	INTERNET PAYMENT - THANK YOU	169.80	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
838	6	1	2022-07-10	SMILE DOCTORS OF COLOR FORT COLLINS CO	-175.00	2024-01-09 18:17:44.325718+00	Medical Services	{}
839	6	1	2022-07-11	GREEN RIDE CO INC 334 821-3922 CO	-40.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
848	6	1	2022-07-15	PARKWAY PARKING 888-399-9267 FL	-48.35	2024-01-09 18:17:44.325718+00	Services	{}
1752	2	1	2023-11-14	Withdrawal to 360 Performance Savings XXXXXXX1843	-1500.00	2024-01-09 18:34:47.445728+00	\N	{}
1753	2	1	2023-11-14	Deposit from 360 Performance Savings XXXXXXX1843	2000.00	2024-01-09 18:34:47.445728+00	\N	{}
1754	2	1	2023-11-10	Withdrawal from CAPITAL ONE ONLINE PMT	-76.65	2024-01-09 18:34:47.445728+00	\N	{}
1357	6	1	2023-09-28	INTERNET PAYMENT - THANK YOU	15.82	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1359	6	1	2023-10-11	INTERNET PAYMENT - THANK YOU	200.65	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1360	6	1	2023-10-26	CHATGPT SUBSCRIPTION 4158799686 CA	-20.00	2024-01-09 18:17:44.325718+00	Merchandise	{}
1361	6	1	2023-10-30	CASHBACK BONUS REDEMPTION PYMT/STMT CRDT	2.21	2024-01-09 18:17:44.325718+00	Awards and Rebate Credits	{}
1362	6	1	2023-10-30	INTERNET PAYMENT - THANK YOU	17.79	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1364	6	1	2023-11-05	GOOGLE YOUTUBE VIDEOS GOOGLE.COM CA	-4.32	2024-01-09 18:17:44.325718+00	Merchandise	{}
1365	6	1	2023-11-06	INTERNET PAYMENT - THANK YOU	204.97	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1366	6	1	2023-11-13	GOOGLE YOUTUBE VIDEOS GOOGLE.COM CA	-4.32	2024-01-09 18:17:44.325718+00	Merchandise	{}
1367	6	1	2023-11-14	STARBUCKS 800-782-7282 SEATTLE WA	-15.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
1368	6	1	2023-11-17	INTERNET PAYMENT - THANK YOU	19.32	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1372	6	1	2023-11-23	INTERNET PAYMENT - THANK YOU	21.45	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1373	6	1	2023-11-26	CHATGPT SUBSCRIPTION 4158799686 CA	-20.00	2024-01-09 18:17:44.325718+00	Merchandise	{}
1374	6	1	2023-11-28	CASHBACK BONUS REDEMPTION PYMT/STMT CRDT	2.95	2024-01-09 18:17:44.325718+00	Awards and Rebate Credits	{}
1375	6	1	2023-11-28	INTERNET PAYMENT - THANK YOU	17.05	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1376	6	1	2023-12-05	CHAUTAUGUA DINING HALL A BOULDER CO	-18.98	2024-01-09 18:17:44.325718+00	Restaurants	{}
1383	6	1	2023-12-21	THE DARK HORSE BOULDER CO	-3.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
1315	6	1	2023-07-26	CHATGPT SUBSCRIPTION 4158799686 CA	-20.00	2024-01-09 18:17:44.325718+00	Merchandise	{}
899	6	1	2022-08-14	CENTURYLINK SIMPLE MONROE LA	-65.00	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
634	6	1	2022-04-11	CENTURYLINK SIMPLE MONROE LA	-40.00	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
947	6	1	2022-09-04	STARBUCKS STORE 55616 CANON CITY COF7FEE38AD89E783066	-14.15	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,"sand dunes"}
1384	6	1	2023-12-24	GOOGLE *YOUTUBE VIDEOS G.CO/HELPPAY#CAP0XFNFQH	-32.43	2024-01-09 18:17:44.325718+00	Merchandise	{}
2124	5	1	2023-11-25	Payment - Thank You	224.69	2024-01-11 04:43:34.551039+00	\N	{}
2126	5	1	2023-11-24	Payment - Thank You	256.15	2024-01-11 04:43:34.551039+00	\N	{}
2132	5	1	2023-11-21	Payment - Thank You	86.82	2024-01-11 04:43:34.551039+00	\N	{}
699	6	1	2022-05-11	CENTURYLINK SIMPLE MONROE LA	-40.00	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
710	6	1	2022-05-14	CENTURYLINK SIMPLE MONROE LA	-65.00	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
722	6	1	2022-05-19	CENTURYLINK SIMPLE MONROE LA	38.00	2024-01-09 18:17:44.325718+00	Payments and Credits	{Household,Internet,Utilities}
609	6	1	2022-03-24	LOAF N JUG # 0812 FORT COLLINS CO	-44.16	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
749	6	1	2022-05-29	LOAF N JUG #0449 BOX ELDER SD	-3.17	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,badlands,Auto,Gas}
1947	1	1	2023-07-28	TARGET        00017699	-10.86	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1165	6	1	2023-02-18	SAFEWAY #0876 FORT COLLINS CO	-3.77	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
1283	6	1	2023-05-30	SAFEWAY #2911 BOULDER COGOOGLE PAY ENDING IN 9955	-16.33	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
764	6	1	2022-06-05	HELLOFRESH 347-200-0291 NY	-8.14	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
2090	5	1	2024-01-02	Cash Back Credit	14.37	2024-01-11 04:43:34.551039+00	\N	{}
2101	5	1	2023-12-24	Taco Bell 033867	-28.23	2024-01-11 04:43:34.551039+00	\N	{}
2103	5	1	2023-12-23	The Dark Horse	-10.80	2024-01-11 04:43:34.551039+00	\N	{}
2104	5	1	2023-12-21	Staples 00114462	-32.55	2024-01-11 04:43:34.551039+00	\N	{}
2109	5	1	2023-12-08	Payment - Thank You	8.27	2024-01-11 04:43:34.551039+00	\N	{}
2111	5	1	2023-12-06	Payment - Thank You	37.50	2024-01-11 04:43:34.551039+00	\N	{}
2112	5	1	2023-12-05	Payment - Thank You	222.28	2024-01-11 04:43:34.551039+00	\N	{}
2098	5	1	2023-12-29	Payment - Thank You	605.75	2024-01-11 04:43:34.551039+00	\N	{}
2113	5	1	2023-12-05	Styria Catering & German	-37.50	2024-01-11 04:43:34.551039+00	\N	{}
2114	5	1	2023-12-04	The Home Depot #1506	-22.78	2024-01-11 04:43:34.551039+00	\N	{}
684	6	1	2022-05-07	GREEN RIDE CO INC 334 821-3922 CO	-45.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
685	6	1	2022-05-07	INTERNET PAYMENT - THANK YOU	74.26	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
765	6	1	2022-06-05	HELLOFRESH 646-846-3663 NYHELLOFRESH	-48.96	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
784	6	1	2022-06-12	HELLOFRESH 646-846-3663 NYMR02776663589300217528	-80.83	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
675	6	1	2022-05-04	SPROUTS FARMERS MARSSS FORT COLLINS CO	-27.88	2024-01-09 18:17:44.325718+00	Supermarkets	{Household,Grocery}
1846	1	1	2023-11-01	CAPITAL ONE ONLINE PYMT	151.20	2024-01-09 18:57:47.153366+00	\N	{}
1848	1	1	2023-10-30	CREDIT-CASH BACK REWARD	7.06	2024-01-09 18:57:47.153366+00	\N	{}
55	7	1	2023-09-28	Deposit from 360 Checking XXXXXXX4402	2000.00	2024-01-09 05:13:55.402661+00	\N	{}
826	6	1	2022-06-30	GOOGLE *GOOGLE FI G.CO/HELPPAY#CAP0KH0GRG	-129.56	2024-01-09 18:17:44.325718+00	Services	{}
831	6	1	2022-07-04	AMZN MKTP US*VG0IP47E3 AMZN.COM/BILLWA3BR48OBXZM3	-14.24	2024-01-09 18:17:44.325718+00	Merchandise	{}
832	6	1	2022-07-04	INTERNET PAYMENT - THANK YOU	324.40	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
834	6	1	2022-07-05	AMZN MKTP US*556YZ0BK3 AMZN.COM/BILLWA3H16U8QF1EJ	-62.63	2024-01-09 18:17:44.325718+00	Merchandise	{}
841	6	1	2022-07-12	TST* KABOD COFFEE - 2ND DENVER CO	-14.01	2024-01-09 18:17:44.325718+00	Restaurants	{}
1288	6	1	2023-06-06	STATE FARM INSURANCE 800-956-6310 IL	-138.63	2024-01-09 18:17:44.325718+00	Services	{Auto,Insurance}
2084	6	1	2024-01-05	STATE FARM INSURANCE 800-956-6310 IL	-200.67	2024-01-09 23:00:10.124777+00	Services	{Auto,Insurance}
738	6	1	2022-05-28	EXXONMOBIL RAPID CITY SD	-45.26	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,badlands,Auto,Gas}
1178	6	1	2023-02-26	ORCA 888-988-6722 WA	-8.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,seattle}
842	6	1	2022-07-13	INTERNET PAYMENT - THANK YOU	315.12	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
844	6	1	2022-07-15	COCA COLA JOHNSTOWN CO JOHNSTOWN CO	-2.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
846	6	1	2022-07-15	INTERNET PAYMENT - THANK YOU	104.47	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1689	2	1	2024-01-08	Withdrawal from Mission Lane LLC EDI PYMNTS	-362.89	2024-01-09 18:34:47.445728+00	\N	{}
1691	2	1	2024-01-04	Deposit from Wise Inc WISE	8778.68	2024-01-09 18:34:47.445728+00	\N	{}
1720	2	1	2023-12-04	Withdrawal from CAPITAL ONE ONLINE PMT	-219.09	2024-01-09 18:34:47.445728+00	\N	{}
1722	2	1	2023-12-01	Withdrawal from Mission Lane Vis Mission La	-224.69	2024-01-09 18:34:47.445728+00	\N	{}
1724	2	1	2023-11-30	Monthly Interest Paid	0.08	2024-01-09 18:34:47.445728+00	\N	{}
1726	2	1	2023-11-29	Withdrawal from Mission Lane Vis Mission La	-49.73	2024-01-09 18:34:47.445728+00	\N	{}
1756	2	1	2023-11-08	Withdrawal from Mission Lane Vis Mission La	-79.30	2024-01-09 18:34:47.445728+00	\N	{}
1757	2	1	2023-11-08	Withdrawal from CAPITAL ONE ONLINE PMT	-57.86	2024-01-09 18:34:47.445728+00	\N	{}
1759	2	1	2023-11-07	Withdrawal from DISCOVER E-PAYMENT	-204.97	2024-01-09 18:34:47.445728+00	\N	{}
1760	2	1	2023-11-07	Deposit from Wise Inc WISE	8853.16	2024-01-09 18:34:47.445728+00	\N	{}
1761	2	1	2023-11-06	Withdrawal from Mission Lane Vis Mission La	-30.76	2024-01-09 18:34:47.445728+00	\N	{}
1762	2	1	2023-11-02	Withdrawal from Mission Lane Vis Mission La	-493.40	2024-01-09 18:34:47.445728+00	\N	{}
1763	2	1	2023-11-02	Withdrawal from CAPITAL ONE ONLINE PMT	-151.20	2024-01-09 18:34:47.445728+00	\N	{}
1764	2	1	2023-10-31	Monthly Interest Paid	0.04	2024-01-09 18:34:47.445728+00	\N	{}
1766	2	1	2023-10-31	Withdrawal from DISCOVER E-PAYMENT	-17.79	2024-01-09 18:34:47.445728+00	\N	{}
1767	2	1	2023-10-31	Withdrawal from Mission Lane Vis Mission La	-180.00	2024-01-09 18:34:47.445728+00	\N	{}
1770	2	1	2023-10-30	Deposit from COLORADO STATE U Payroll	7093.68	2024-01-09 18:34:47.445728+00	\N	{}
1771	2	1	2023-10-30	Withdrawal from CHUZE FIT CLUB FEES	-24.99	2024-01-09 18:34:47.445728+00	\N	{}
1739	2	1	2023-11-22	Withdrawal from WELLS FARGO IFI ACCTVERIFY	-0.56	2024-01-09 18:34:47.445728+00	\N	{}
1742	2	1	2023-11-22	Withdrawal from Mission Lane Vis Mission La	-86.82	2024-01-09 18:34:47.445728+00	\N	{}
1743	2	1	2023-11-22	Withdrawal from CAPITAL ONE ONLINE PMT	-257.52	2024-01-09 18:34:47.445728+00	\N	{}
1744	2	1	2023-11-20	Withdrawal from Mission Lane Vis Mission La	-810.00	2024-01-09 18:34:47.445728+00	\N	{}
1745	2	1	2023-11-20	Withdrawal from DISCOVER E-PAYMENT	-19.32	2024-01-09 18:34:47.445728+00	\N	{}
1776	2	1	2023-10-18	Withdrawal from CAPITAL ONE ONLINE PMT	-148.55	2024-01-09 18:34:47.445728+00	\N	{}
1777	2	1	2023-10-17	Deposit from FID BKG SVC LLC MONEYLINE	516.00	2024-01-09 18:34:47.445728+00	\N	{}
1778	2	1	2023-10-16	Withdrawal from FID BKG SVC LLC MONEYLINE BPF_DSS_0_1016115503.txt	-258.00	2024-01-09 18:34:47.445728+00	\N	{}
1780	2	1	2023-10-16	Deposit from Colorado State U AP Payment	1639.95	2024-01-09 18:34:47.445728+00	\N	{}
1781	2	1	2023-10-12	Withdrawal from DISCOVER E-PAYMENT	-200.65	2024-01-09 18:34:47.445728+00	\N	{}
1782	2	1	2023-10-12	Withdrawal from Mission Lane Vis Mission La	-147.17	2024-01-09 18:34:47.445728+00	\N	{}
1783	2	1	2023-10-12	Withdrawal from CAPITAL ONE ONLINE PMT	-86.97	2024-01-09 18:34:47.445728+00	\N	{}
1784	2	1	2023-10-10	Cha-Ching! New account bonus	350.00	2024-01-09 18:34:47.445728+00	\N	{}
1786	2	1	2023-10-05	Deposit from Wise Inc WISE	7592.36	2024-01-09 18:34:47.445728+00	\N	{}
1787	2	1	2023-10-04	Withdrawal from Mission Lane Vis Mission La	-100.56	2024-01-09 18:34:47.445728+00	\N	{}
1788	2	1	2023-10-04	Withdrawal from CAPITAL ONE ONLINE PMT	-512.71	2024-01-09 18:34:47.445728+00	\N	{}
1790	2	1	2023-09-29	Withdrawal from Mission Lane Vis Mission La	-586.70	2024-01-09 18:34:47.445728+00	\N	{}
1792	2	1	2023-09-29	Withdrawal from CAPITAL ONE ONLINE PMT	-113.14	2024-01-09 18:34:47.445728+00	\N	{}
1794	2	1	2023-09-28	Deposit from COLORADO STATE U Payroll	7093.68	2024-01-09 18:34:47.445728+00	\N	{}
852	6	1	2022-07-17	LUCILES FORT COLLINS CO	-60.08	2024-01-09 18:17:44.325718+00	Restaurants	{}
854	6	1	2022-07-18	INTERNET PAYMENT - THANK YOU	1115.35	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
856	6	1	2022-07-18	WALGREENS #18340 FORT COLLINS CO	-5.37	2024-01-09 18:17:44.325718+00	Merchandise	{}
857	6	1	2022-07-20	COSMOS PIZZA - FORT COLL FORT COLLINS CO	-17.25	2024-01-09 18:17:44.325718+00	Restaurants	{}
868	6	1	2022-07-29	INTERNET PAYMENT - THANK YOU	118.04	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
869	6	1	2022-07-30	GOOGLE *GOOGLE FI G.CO/HELPPAY#CAP0KVBAWA	-125.58	2024-01-09 18:17:44.325718+00	Services	{}
872	6	1	2022-08-01	GOOGLE *ADS9724932760 CC@GOOGLE.COMCAP0KYY6TT	-69.19	2024-01-09 18:17:44.325718+00	Services	{}
873	6	1	2022-08-01	INTERNET PAYMENT - THANK YOU	175.44	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
875	6	1	2022-08-02	NOODLES & CO 150 BOULDER CO	-14.61	2024-01-09 18:17:44.325718+00	Restaurants	{}
876	6	1	2022-08-02	TST* GRANGE HALL - BUB GREENWOOD VILCO00003423008025403820AA	-24.31	2024-01-09 18:17:44.325718+00	Restaurants	{}
928	6	1	2022-08-29	GOOGLE *ADS9724932760 CC@GOOGLE.COMCAP0LAKU8E	-350.00	2024-01-09 18:17:44.325718+00	Services	{}
929	6	1	2022-08-29	INTERNET PAYMENT - THANK YOU	305.80	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
932	6	1	2022-08-30	GOOGLE *GOOGLE FI G.CO/HELPPAY#CAP0LBVZBP	-125.42	2024-01-09 18:17:44.325718+00	Services	{}
934	6	1	2022-08-31	INTERNET PAYMENT - THANK YOU	699.59	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
935	6	1	2022-08-31	PIKES PEAK AMERICA S MOU 719-385-7705 CO	-32.00	2024-01-09 18:17:44.325718+00	Government Services	{}
936	6	1	2022-09-01	FLOYD'S 99 ELIZABETH FORT COLLINS CO	-32.00	2024-01-09 18:17:44.325718+00	Services	{}
937	6	1	2022-09-01	GOOGLE *ADS9724932760 CC@GOOGLE.COMCAP0LFMBJZ	-23.42	2024-01-09 18:17:44.325718+00	Services	{}
2138	5	1	2023-11-19	Mcdonald's F35803	-10.82	2024-01-11 04:43:34.551039+00	\N	{Travel,chicago}
850	6	1	2022-07-16	WALMART SC 02729 FORT COLLINS CO	-54.02	2024-01-09 18:17:44.325718+00	Merchandise	{Household,Grocery}
1765	2	1	2023-10-31	Withdrawal from XCEL ENERGY-PSCO XCELENERGY	-70.18	2024-01-09 18:34:47.445728+00	\N	{Household,Utilities}
938	6	1	2022-09-01	INTERNET PAYMENT - THANK YOU	226.60	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
939	6	1	2022-09-01	ROYAL GORGE COMPANY OF 719-275-7507 CO3836825	-60.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{}
940	6	1	2022-09-01	SIGNAL WASH ON NORTH COL FORT COLLINS CO	-6.28	2024-01-09 18:17:44.325718+00	Automotive	{}
941	6	1	2022-09-02	PARKMOBILE 770-818-9036 GA598436859	-6.70	2024-01-09 18:17:44.325718+00	Services	{}
1030	6	1	2022-11-07	INTERNET PAYMENT - THANK YOU	720.54	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1031	6	1	2022-11-10	CSU CAMPUS RECREATION FORT COLLINS CO	-16.50	2024-01-09 18:17:44.325718+00	Education	{}
1029	6	1	2022-11-05	SPRINGHILL SUITES BY MAR 8013730073 UT	-208.51	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,"las vegas"}
927	6	1	2022-08-28	SQ *CREMA GOURMET ESPR MIAMI BEACH FL0002305843016202845023	-14.18	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,miami}
1126	6	1	2023-01-16	IN *ESTES PARK MOUNTAI ESTES PARK COARD2PTM7	-51.85	2024-01-09 18:17:44.325718+00	Merchandise	{}
1191	6	1	2023-02-28	SEA CAP FD HALL CA10 145 TUKWILA WA	-3.51	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,seattle}
1192	6	1	2023-02-28	SEA CAP FD HALL CA10 145 TUKWILA WA	-27.50	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,seattle}
1173	6	1	2023-02-25	ORCA SEATTLE WA	-22.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,seattle}
1172	6	1	2023-02-25	E 470 EXPRESS TOLLS AURORA CO	-29.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,seattle}
1175	6	1	2023-02-25	TST* KANAK SEATTLE WA00040364010573597719AA	-50.10	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,seattle}
1026	6	1	2022-11-03	NEPHI OIL INC SALINA UT	-30.58	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,"las vegas",Auto,Gas}
1013	6	1	2022-10-30	MCDONALD'S F31819 PAGE AZGOOGLE PAY ENDING IN 9955	-5.54	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,"las vegas"}
2048	1	1	2023-04-23	SIGNAL WASH ON NORTH C	-20.00	2024-01-09 18:57:47.153366+00	\N	{Travel,gleenwood}
2049	1	1	2023-04-22	MAY PALACE RESTAURANT	-36.00	2024-01-09 18:57:47.153366+00	\N	{Travel,gleenwood}
2051	1	1	2023-04-22	GLWD HOT SPRINGS POOL	-78.00	2024-01-09 18:57:47.153366+00	\N	{Travel,gleenwood}
2053	1	1	2023-04-22	CITY-MARKET #0420	-7.14	2024-01-09 18:57:47.153366+00	\N	{Travel,gleenwood}
1209	6	1	2023-03-27	JFK FIVEBOR FOODHALL 138 JAMAICA NY	-18.16	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,switzerland}
1369	6	1	2023-11-18	KTA - TRANSA TEMP - RET WICHITA KS	-4.00	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,chicago}
1370	6	1	2023-11-18	PARKMOBILE 770-818-9036 CO770006814	-2.45	2024-01-09 18:17:44.325718+00	Services	{Travel,chicago}
909	6	1	2022-08-25	SQ *CREMA GOURMET ESPR MIAMI BEACH FL0002305843016182681529	-33.01	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,miami}
910	6	1	2022-08-25	UBER TRIP 866-576-1039 CA	-23.02	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,miami}
911	6	1	2022-08-26	AMZN MKTP US*I29202HX3 AMZN.COM/BILLWA3L6V8ORFSK0	-11.78	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,miami}
912	6	1	2022-08-26	AMZN MKTP US*X48UO5GC3 AMZN.COM/BILLWA47M6NQBEVNU	-25.00	2024-01-09 18:17:44.325718+00	Merchandise	{Travel,miami}
913	6	1	2022-08-26	RAKIJA LOUNGE MIAMI BEACH FL	-83.24	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,miami}
914	6	1	2022-08-26	SQ *CREMA GOURMET ESPR MIAMI BEACH FL0002305843016188866674	-23.42	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,miami}
915	6	1	2022-08-27	CITY SIGHTSEEING WASHI BIGBUSTOURS.CVA	-88.20	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,miami}
916	6	1	2022-08-27	DECO BIKE, LLC. 305-416-7445 FL	-5.30	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,miami}
917	6	1	2022-08-27	DECO BIKE, LLC. 305-416-7445 FL	-5.30	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,miami}
918	6	1	2022-08-27	DECO BIKE, LLC. 305-416-7445 FL	-5.30	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,miami}
1987	1	1	2023-07-03	CHEVRON 0201458	-34.02	2024-01-09 18:57:47.153366+00	\N	{Travel,"new mexico",Auto,Gas}
1995	1	1	2023-06-30	PHILLIPS 66 - QUEBEC P	-47.06	2024-01-09 18:57:47.153366+00	\N	{Travel,"new mexico",Auto,Gas}
1989	1	1	2023-07-01	CASEYS #4071	-34.14	2024-01-09 18:57:47.153366+00	\N	{Travel,"new mexico",Auto,Gas}
750	6	1	2022-05-29	LOAF N JUG #0449 BOX ELDER SD	-49.50	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,badlands,Auto,Gas}
1025	6	1	2022-11-03	JUNCTION PIT STOP JUNCTION UT	-3.80	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,"las vegas",Auto,Gas}
1020	6	1	2022-11-01	BELEN AND STAR FUEL ASH FORK AZ	-32.42	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,"las vegas",Auto,Gas}
1286	6	1	2023-06-03	WONDERSHARE HK HKG	-49.99	2024-01-09 18:17:44.325718+00	Merchandise	{}
919	6	1	2022-08-27	DECO BIKE, LLC. 305-416-7445 FL	-5.30	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,miami}
920	6	1	2022-08-27	MCDONALD'S F12932 MIAMI FL	-2.34	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,miami}
921	6	1	2022-08-27	MCDONALD'S F12932 MIAMI FL	-4.27	2024-01-09 18:17:44.325718+00	Restaurants	{Travel,miami}
922	6	1	2022-08-28	DECO BIKE MIAMI, LLC. 305-416-7445 FL	-7.44	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,miami}
629	6	1	2022-04-09	LOAF N JUG # 0827 FORT COLLINS CO	-41.66	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
649	6	1	2022-04-21	LOAF N JUG # 0812 FORT COLLINS CO	-38.95	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
56	7	1	2023-09-11	Deposit from 360 Checking XXXXXXX4402	500.00	2024-01-09 05:13:55.402661+00	\N	{}
653	6	1	2022-04-23	LOAF N JUG # 0812 FORT COLLINS CO	-20.83	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
667	6	1	2022-04-30	LOAF N JUG # 0812 FORT COLLINS CO	-37.15	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
677	6	1	2022-05-05	LOAF N JUG # 0812 FORT COLLINS CO	-46.38	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
711	6	1	2022-05-14	LOAF N JUG # 0812 FORT COLLINS CO	-48.22	2024-01-09 18:17:44.325718+00	Gasoline	{Auto,Gas}
732	6	1	2022-05-27	LOAF N JUG # 0812 FORT COLLINS CO	-21.68	2024-01-09 18:17:44.325718+00	Gasoline	{Travel,badlands,Auto,Gas}
1122	6	1	2023-01-14	CENTURYLINK LUMEN 800-244-1111 LA000722073412	-40.00	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
1232	6	1	2023-04-16	CENTURYLINK LUMEN 800-244-1111 LA001921044808	-40.00	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
977	6	1	2022-10-14	CENTURYLINK SIMPLE MONROE LA	-65.00	2024-01-09 18:17:44.325718+00	Services	{Travel,brazil,Household,Internet,Utilities}
168	3	1	2023-05-24	COMCAST CABLE 230523 2926620 VANDERLEI *ROCHA DE VA	-25.00	2024-01-09 18:10:05.987144+00	\N	{Household,Internet,Utilities}
321	3	1	2022-08-23	FORTCOLUTILITIES EBILL PAY 220822 4778896 VANDERLEI ROCHA DE VAR	-49.35	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
337	3	1	2022-07-26	FORTCOLUTILITIES EBILL PAY 220725 3762438 VANDERLEI ROCHA DE VAR	-47.82	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
253	3	1	2022-12-23	FORTCOLUTILITIES EBILL PAY 221222 7982252 VANDERLEI ROCHA DE VAR	-52.20	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
268	3	1	2022-11-22	FORTCOLUTILITIES EBILL PAY 221121 0550161 VANDERLEI ROCHA DE VAR	-30.72	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
285	3	1	2022-10-24	FORTCOLUTILITIES EBILL PAY 221021 3383609 VANDERLEI ROCHA DE VAR	-36.17	2024-01-09 18:10:05.987144+00	\N	{Household,Utilities}
1822	1	1	2023-11-30	GOOGLE *FI GWR98H	-158.26	2024-01-09 18:57:47.153366+00	\N	{Household,Internet,Utilities}
1864	1	1	2023-09-30	GOOGLE *FI P2B9Hw	-157.38	2024-01-09 18:57:47.153366+00	\N	{Household,Internet,Utilities}
1193	6	1	2023-03-02	GOOGLE *FI WXJ77N G.CO/HELPPAY#CAP0PW1GLT	-158.85	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
1213	6	1	2023-03-30	GOOGLE *FI ZZWWXH G.CO/HELPPAY#CAP0QCURMW	-159.66	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
1951	1	1	2023-07-27	WALMART OFFER F7BB74	1.25	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1952	1	1	2023-07-26	WALMART.COM	-164.32	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1959	1	1	2023-07-19	WALMART.COM	-158.23	2024-01-09 18:57:47.153366+00	\N	{Household,Grocery}
1249	6	1	2023-04-30	GOOGLE *FI F5W832 G.CO/HELPPAY#CAP0RPPK6A	-158.13	2024-01-09 18:17:44.325718+00	Services	{Household,Internet,Utilities}
1802	1	1	2023-12-30	GOOGLE *FI W7Kx8x	-158.26	2024-01-09 18:57:47.153366+00	\N	{Travel,utah,Household,Internet,Utilities}
1301	6	1	2023-06-30	GOOGLE *FI VDP2DV G.CO/HELPPAY#CAP0SXSKBB	-157.75	2024-01-09 18:17:44.325718+00	Services	{Travel,"new mexico",Household,Internet,Utilities}
1322	6	1	2023-08-04	STATE FARM INSURANCE 800-956-6310 IL	-200.65	2024-01-09 18:17:44.325718+00	Services	{Auto,Insurance}
1358	6	1	2023-10-04	STATE FARM INSURANCE 800-956-6310 IL	-200.65	2024-01-09 18:17:44.325718+00	Services	{Auto,Insurance}
1363	6	1	2023-11-04	STATE FARM INSURANCE 800-956-6310 IL	-200.65	2024-01-09 18:17:44.325718+00	Services	{Auto,Insurance}
1377	6	1	2023-12-05	STATE FARM INSURANCE 800-956-6310 IL	-200.65	2024-01-09 18:17:44.325718+00	Services	{Auto,Insurance}
978	6	1	2022-10-14	CIRCA RESORT LAS VEGAS NV	-309.17	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,brazil,Hotel}
1002	6	1	2022-10-27	BKGBOOKING.COM HOTEL 470-363-2501 NY	-136.96	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,Hotel}
2127	5	1	2023-11-24	Hilton Garden Inn Omh Dt	-131.96	2024-01-11 04:43:34.551039+00	\N	{Travel,Hotel}
2143	5	1	2023-11-13	Airbnb Hmjsrn3dsf	-357.58	2024-01-11 04:43:34.551039+00	\N	{Travel,Hotel}
849	6	1	2022-07-16	AIRBNB HMFHRX3AZD 855-424-7262 CA	-477.85	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,Hotel}
1129	6	1	2023-01-18	AIRBNB HMP2C35AKD 855-424-7262 CA	-81.89	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,Hotel}
1158	6	1	2023-02-13	AIRBNB HMP2C35AKD 855-424-7262 CA	-327.53	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,Hotel}
1323	6	1	2023-08-06	AIRBNB HMXT5WPAJP 855-424-7262 CA	-484.88	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,Hotel}
1897	1	1	2023-08-25	HOLIDAY INN EXP & SUIT	-835.18	2024-01-09 18:57:47.153366+00	\N	{Travel,Hotel}
2093	5	1	2024-01-03	Holiday Inn Express	-8.37	2024-01-11 04:43:34.551039+00	\N	{Travel,Hotel}
2094	5	1	2024-01-03	Holiday Inn Express	-80.00	2024-01-11 04:43:34.551039+00	\N	{Travel,Hotel}
1115	6	1	2023-01-12	HOLIDAY INN EXP DENVER DENVER CO	-837.81	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,Hotel}
2134	5	1	2023-11-21	Holiday Inn Kansas City	-218.96	2024-01-11 04:43:34.551039+00	\N	{Travel,chicago,Hotel}
117	3	1	2023-08-28	DISCOVER E-PAYMENT 230826 7277 ROCHADEVARGAS V	-62.65	2024-01-09 18:10:05.987144+00	\N	{}
118	3	1	2023-08-28	CHUZE FIT CLUB FEES 2323701088386 720-210-9723	-74.98	2024-01-09 18:10:05.987144+00	\N	{}
119	3	1	2023-08-21	DISCOVER E-PAYMENT 230821 7277 ROCHADEVARGAS V	-346.63	2024-01-09 18:10:05.987144+00	\N	{}
120	3	1	2023-08-21	CAPITAL ONE ONLINE PMT 230821 3S762UBSOWUKS9S VANDERLEI ROCHA DE VAR	-136.22	2024-01-09 18:10:05.987144+00	\N	{}
123	3	1	2023-08-15	CAPITAL ONE ONLINE PMT 230815 3S5WPFH0OOQUQ74 VANDERLEI ROCHA DE VAR	-310.18	2024-01-09 18:10:05.987144+00	\N	{}
124	3	1	2023-08-14	CAPITAL ONE ONLINE PMT 230814 3S5PD3YC0ZOETR4 VANDERLEI ROCHA DE VAR	-203.52	2024-01-09 18:10:05.987144+00	\N	{}
173	3	1	2023-05-17	BILL PAY Utility Billing Services ON-LINE xxxx-xxx-x02-2-C ON 05-17	-24.08	2024-01-09 18:10:05.987144+00	\N	{}
176	3	1	2023-05-11	DISCOVER E-PAYMENT 230511 7277 ROCHADEVARGAS V	-691.40	2024-01-09 18:10:05.987144+00	\N	{}
177	3	1	2023-05-11	VENMO PAYMENT 230511 1026960626443 VANDERLEI ROCHA DE VAR	-16.00	2024-01-09 18:10:05.987144+00	\N	{}
178	3	1	2023-05-11	CAPITAL ONE ONLINE PMT 230511 3RLMJEM236BZ40W VANDERLEI ROCHA DE VAR	-236.75	2024-01-09 18:10:05.987144+00	\N	{}
179	3	1	2023-05-05	CAPITAL ONE MOBILE PMT 230505 3RKDU38XSTTDAQG SANDRA ROCHA DE VARGAS	-300.00	2024-01-09 18:10:05.987144+00	\N	{}
180	3	1	2023-05-05	DISCOVER E-PAYMENT 230505 1269 ROCHADEVARGASJUNIS	-60.00	2024-01-09 18:10:05.987144+00	\N	{}
181	3	1	2023-05-05	MOBILE DEPOSIT : REF NUMBER :618050416134	923.00	2024-01-09 18:10:05.987144+00	\N	{}
182	3	1	2023-04-28	DISCOVER E-PAYMENT 230428 7277 ROCHADEVARGAS V	-174.78	2024-01-09 18:10:05.987144+00	\N	{}
266	3	1	2022-11-28	DISCOVER E-PAYMENT 221128 7277 ROCHADEVARGAS V	-598.65	2024-01-09 18:10:05.987144+00	\N	{}
267	3	1	2022-11-22	DISCOVER E-PAYMENT 221122 7277 ROCHADEVARGAS V	-308.50	2024-01-09 18:10:05.987144+00	\N	{}
270	3	1	2022-11-21	CAPITAL ONE MOBILE PMT 221119 3MV4WW0EYULUIZC SANDRA ROCHA DE VARGAS	-328.62	2024-01-09 18:10:05.987144+00	\N	{}
271	3	1	2022-11-16	DISCOVER E-PAYMENT 221116 7277 ROCHADEVARGAS V	-556.97	2024-01-09 18:10:05.987144+00	\N	{}
274	3	1	2022-11-10	DISCOVER E-PAYMENT 221110 1269 ROCHADEVARGASJUNIS	-73.17	2024-01-09 18:10:05.987144+00	\N	{}
1721	2	1	2023-12-01	Withdrawal to Savings XXXXXXX1843	-620.00	2024-01-09 18:34:47.445728+00	\N	{}
1727	2	1	2023-11-29	Withdrawal to Savings XXXXXXX1843	-2000.00	2024-01-09 18:34:47.445728+00	\N	{}
1748	2	1	2023-11-17	Deposit from 360 Performance Savings XXXXXXX1843	810.00	2024-01-09 18:34:47.445728+00	\N	{}
1758	2	1	2023-11-07	Withdrawal to 360 Performance Savings XXXXXXX1843	-8853.16	2024-01-09 18:34:47.445728+00	\N	{}
1769	2	1	2023-10-30	Withdrawal to 360 Performance Savings XXXXXXX1843	-2000.00	2024-01-09 18:34:47.445728+00	\N	{}
1773	2	1	2023-10-24	Deposit from 360 Performance Savings XXXXXXX1843	50.00	2024-01-09 18:34:47.445728+00	\N	{}
1804	1	1	2023-12-29	CAPITAL ONE ONLINE PYMT	141.79	2024-01-09 18:57:47.153366+00	\N	{}
341	3	1	2022-07-18	DISCOVER E-PAYMENT 220718 7277 ROCHADEVARGAS V	-1115.35	2024-01-09 18:10:05.987144+00	\N	{}
1801	1	1	2024-01-02	CREDIT-CASH BACK REWARD	6.09	2024-01-09 18:57:47.153366+00	\N	{}
1803	1	1	2023-12-31	WM SUPERCENTER #4288	-33.57	2024-01-09 18:57:47.153366+00	\N	{}
1979	1	1	2023-07-06	CAPITAL ONE ONLINE PYMT	527.92	2024-01-09 18:57:47.153366+00	\N	{}
1062	6	1	2022-12-01	TST* LUCKY JOES SIDEWA FORT COLLINS CO00025440009519126468AA	-15.59	2024-01-09 18:17:44.325718+00	Restaurants	{}
1067	6	1	2022-12-04	CHEESECAKE DENVER DENVER CO	-11.34	2024-01-09 18:17:44.325718+00	Restaurants	{}
1980	1	1	2023-07-04	WNPA - WHITE SANDS	-4.99	2024-01-09 18:57:47.153366+00	\N	{Travel,"new mexico"}
1981	1	1	2023-07-04	SPEEDWAY 09000 1009 ST	-29.15	2024-01-09 18:57:47.153366+00	\N	{Travel,"new mexico"}
1982	1	1	2023-07-04	STARBUCKS STORE 10119	-11.88	2024-01-09 18:57:47.153366+00	\N	{Travel,"new mexico"}
1983	1	1	2023-07-03	WNPA - GUADALUPE MOUNT	-8.49	2024-01-09 18:57:47.153366+00	\N	{Travel,"new mexico"}
1984	1	1	2023-07-03	WNPA - CARLSBAD CAVERN	-4.99	2024-01-09 18:57:47.153366+00	\N	{Travel,"new mexico"}
1131	6	1	2023-01-18	INTERNET PAYMENT - THANK YOU	1303.13	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1132	6	1	2023-01-20	INTERNET PAYMENT - THANK YOU	254.81	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
2082	6	1	2024-01-01	INTERNET PAYMENT - THANK YOU	68.19	2024-01-09 23:00:10.124777+00	Payments and Credits	{}
2083	6	1	2024-01-02	INTERNET PAYMENT - THANK YOU	45.02	2024-01-09 23:00:10.124777+00	Payments and Credits	{}
923	6	1	2022-08-28	DECO BIKE MIAMI, LLC. 305-416-7445 FL	-7.44	2024-01-09 18:17:44.325718+00	Travel/ Entertainment	{Travel,miami}
686	6	1	2022-05-07	SQ *TOM'S OLD TOWN LUC FORT COLLINS CO0001152921511370473200	-30.03	2024-01-09 18:17:44.325718+00	Services	{}
687	6	1	2022-05-07	STARBUCKS STORE 06570 FORT COLLINS CO695474	-9.14	2024-01-09 18:17:44.325718+00	Restaurants	{}
688	6	1	2022-05-07	YARD HOUSE 00083295574 DENVER CO	-40.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
198	3	1	2023-03-30	CAPITAL ONE MOBILE PMT 230330 3RCSVIPB8QYRNA0 SANDRA ROCHA DE VARGAS	-250.00	2024-01-09 18:10:05.987144+00	\N	{}
819	6	1	2022-06-26	SIGNAL WASH CO FORT COLLINS CO	-3.31	2024-01-09 18:17:44.325718+00	Automotive	{}
2153	5	1	2023-11-01	Payment - Thank You	493.40	2024-01-11 04:43:34.551039+00	\N	{}
2140	5	1	2023-11-17	Charleys Philly Steaks 65	-19.00	2024-01-11 04:43:34.551039+00	\N	{}
2181	5	1	2023-02-06	Payment - Thank You	134.44	2024-01-11 04:43:34.551039+00	\N	{}
2182	5	1	2023-02-03	Amzn Mktp Us*0669f3ed3	-101.31	2024-01-11 04:43:34.551039+00	\N	{}
2183	5	1	2023-02-02	Cash Back Credit	0.50	2024-01-11 04:43:34.551039+00	\N	{}
2184	5	1	2023-01-28	Thai Station Restaurant	-33.63	2024-01-11 04:43:34.551039+00	\N	{}
1021	6	1	2022-11-01	BELLAGIO HTL SELF PARK LAS VEGAS NV	-15.00	2024-01-09 18:17:44.325718+00	Services	{Travel,"las vegas"}
1127	6	1	2023-01-16	MCDONALD'S F19217 FORT COLLINS COGOOGLE PAY ENDING IN 9955	-2.15	2024-01-09 18:17:44.325718+00	Restaurants	{}
1128	6	1	2023-01-16	MCDONALD'S F19217 FORT COLLINS COGOOGLE PAY ENDING IN 9955	-3.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
1135	6	1	2023-01-24	CO DRIVER SERVI EMV DENVER CO	-33.35	2024-01-09 18:17:44.325718+00	Government Services	{}
1231	6	1	2023-04-15	STARBUCKS 800-782-7282 SEATTLE WAGOOGLE PAY ENDING IN 9955	-25.00	2024-01-09 18:17:44.325718+00	Restaurants	{}
1233	6	1	2023-04-16	RMCF - BOULDER CO 5049 BOULDER CO	-4.25	2024-01-09 18:17:44.325718+00	Merchandise	{}
1312	6	1	2023-07-18	INTERNET PAYMENT - THANK YOU	652.07	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1313	6	1	2023-07-19	INTERNET PAYMENT - THANK YOU	34.56	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1318	6	1	2023-07-28	INTERNET PAYMENT - THANK YOU	60.60	2024-01-09 18:17:44.325718+00	Payments and Credits	{}
1351	6	1	2023-09-06	STATE FARM INSURANCE 800-956-6310 IL	-200.65	2024-01-09 18:17:44.325718+00	Services	{Auto,Insurance}
1217	6	1	2023-04-04	STATE FARM INSURANCE 800-956-6310 IL	-163.45	2024-01-09 18:17:44.325718+00	Services	{Auto,Insurance}
1253	6	1	2023-05-04	STATE FARM INSURANCE 800-956-6310 IL	-218.71	2024-01-09 18:17:44.325718+00	Services	{Auto,Insurance}
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: vvargas
--

COPY public.users (id, username, created_at) FROM stdin;
1	Vanderlei	2024-01-06 03:39:44.740378+00
2	Sandra	2024-01-06 03:39:50.256635+00
\.


--
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vvargas
--

SELECT pg_catalog.setval('public.accounts_id_seq', 8, true);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vvargas
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vvargas
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vvargas
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 24, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vvargas
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vvargas
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 1, false);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vvargas
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vvargas
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vvargas
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 6, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vvargas
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 18, true);


--
-- Name: pay_advices_vanderlei_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vvargas
--

SELECT pg_catalog.setval('public.pay_advices_vanderlei_id_seq', 63, true);


--
-- Name: retirement_fund_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vvargas
--

SELECT pg_catalog.setval('public.retirement_fund_id_seq', 28, true);


--
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vvargas
--

SELECT pg_catalog.setval('public.transactions_id_seq', 2289, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vvargas
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: pay_advices pay_advices_vanderlei_pkey; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.pay_advices
    ADD CONSTRAINT pay_advices_vanderlei_pkey PRIMARY KEY (id);


--
-- Name: retirement_fund retirement_fund_pkey; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.retirement_fund
    ADD CONSTRAINT retirement_fund_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: vvargas
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: vvargas
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: vvargas
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: vvargas
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: vvargas
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: vvargas
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: vvargas
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: vvargas
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: vvargas
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: vvargas
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: vvargas
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: vvargas
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: vvargas
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pay_advices fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.pay_advices
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: retirement_fund retirement_fund_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.retirement_fund
    ADD CONSTRAINT retirement_fund_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: transactions transactions_bank_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_bank_id_fkey FOREIGN KEY (bank_id) REFERENCES public.accounts(id);


--
-- Name: transactions transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vvargas
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

