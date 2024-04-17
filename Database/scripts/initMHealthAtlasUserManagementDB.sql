
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

CREATE SCHEMA user_management;

SET default_table_access_method = heap;

CREATE TYPE user_management.role AS ENUM ('Subscriber', 'Expert', 'Company_Admin', 'HI_Admin', 'Content_Manager', 'Admin');

CREATE TABLE user_management.user (
    id UUID NOT NULL PRIMARY KEY,
    firstname text NOT NULL,
    lastname text NOT NULL,
    username text NOT NULL UNIQUE,
    email text NOT NULL,
    enterprise text
);


CREATE TABLE user_management.discipline (
    discipline_id integer NOT NULL PRIMARY KEY,
    name text NOT NULL UNIQUE
);

ALTER TABLE user_management.discipline ALTER COLUMN discipline_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME user_management.discipline_discipline_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);


CREATE TABLE user_management.specialization (
    specialization_id integer NOT NULL PRIMARY KEY,
    name text NOT NULL UNIQUE,
    abbreviation text NOT NULL UNIQUE,
    discipline_id integer NOT NULL
);

ALTER TABLE user_management.specialization ALTER COLUMN specialization_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME user_management.specialization_specialization_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY user_management.specialization
    ADD CONSTRAINT specialization_discipline_id_fkey FOREIGN KEY (discipline_id) REFERENCES user_management.discipline(discipline_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE user_management.user_role (
    id integer NOT NULL PRIMARY KEY,
    user_id uuid NOT NULL,
    role_type user_management.role NOT NULL,
    UNIQUE(user_id, role_type)
);

ALTER TABLE user_management.user_role ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME user_management.user_role_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY user_management.user_role
    ADD CONSTRAINT user_role_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_management.user(id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE user_management.user_specialization (
    id integer NOT NULL PRIMARY KEY,
    user_id uuid NOT NULL,
    specialization_id integer NOT NULL,
    specialization_validated boolean NOT NULL,
    UNIQUE(user_id, specialization_id)
);

ALTER TABLE user_management.user_specialization ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME user_management.user_specialization_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY user_management.user_specialization
    ADD CONSTRAINT user_specialization_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_management.user(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY user_management.user_specialization
    ADD CONSTRAINT user_specialization_specialization_id_fkey FOREIGN KEY (specialization_id) REFERENCES user_management.specialization(specialization_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE user_management.outbox (
  event_id UUID NOT NULL PRIMARY KEY,
  version integer NOT NULL,
  root_aggregate_type text NOT NULL,
  root_aggregate_id text NOT NULL,
  aggregate_type text NOT NULL,
  aggregate_id text NOT NULL,
  event_type text NOT NULL,
  payload text NOT NULL
);

ALTER TABLE user_management.outbox OWNER TO postgres;


INSERT INTO user_management.discipline OVERRIDING SYSTEM VALUE VALUES (0, 'Content');
INSERT INTO user_management.discipline OVERRIDING SYSTEM VALUE VALUES (1, 'Usability');
INSERT INTO user_management.discipline OVERRIDING SYSTEM VALUE VALUES (2, 'Security');
INSERT INTO user_management.discipline OVERRIDING SYSTEM VALUE VALUES (3, 'Law');

INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (0, 'user', 'E1', 1);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (1, 'professional usability expert', 'E2', 1);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (2, 'mHealth application publisher/developer', 'E3', 1);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (3, 'general practitioner', 'E4', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (4, 'anesthesiologist', 'E5', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (5, 'anatomist', 'E6', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (6, 'public health professional', 'E7', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (7, 'ophthalmologists', 'E8', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (8, 'biochemists', 'E9', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (9, 'general surgeons', 'E10', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (10, 'vascular surgeon', 'E11', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (11, 'cardiac surgeon', 'E12', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (12, 'pediatric and adolescent surgeon', 'E13', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (13, 'orthopaedics and trauma surgeon', 'E14', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (14, 'plastic surgeon', 'E15', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (15, 'thoracic surgeon', 'E16', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (16, 'visceral surgeon', 'E17', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (17, 'gynecologist', 'E18', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (18, 'otorhinolaryngologist', 'E19', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (19, 'dermatologist', 'E20', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (20, 'human geneticist', 'E21', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (21, 'hygienist', 'E22', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (22, 'environmental health practitioner', 'E23', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (23, 'internist', 'E24', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (24, 'angiologist', 'E25', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (25, 'endocrinologist', 'E26', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (26, 'diabetologist', 'E27', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (27, 'gastroenterologist', 'E28', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (28, 'hematologist and  oncologist', 'E29', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (29, 'cardiologist', 'E30', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (30, 'nephrologist', 'E31', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (31, 'pneumologist', 'E32', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (32, 'rheumatologist', 'E33', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (33, 'paediatrician', 'E34', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (34, 'pediatrician and adolescents’ psychologist', 'E35', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (35, 'laboratory physician', 'E36', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (36, 'micro, viro and infection epidemiologist', 'E37', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (37, 'maxillofacial  surgeon', 'E38', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (38, 'neurosurgeon', 'E39', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (39, 'neurologist', 'E40', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (40, 'nuclear physician', 'E41', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (41, 'specialist for public health', 'E42', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (42, 'neuropathologist', 'E43', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (43, 'pathologist', 'E44', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (44, 'clinical pharmacologist', 'E45', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (45, 'pharmacologist and toxicologist', 'E46', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (46, 'phoniatric', 'E47', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (47, 'pediatric  audiologist', 'E48', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (48, 'physical and rehabilitative practitioner', 'E49', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (49, 'physiologist', 'E50', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (50, 'psychiatrist and psychotherapist', 'E51', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (51, 'psychosomatist and  psychotherapist', 'E52', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (52, 'radiologist', 'E53', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (53, 'forensic physician', 'E54', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (54, 'radiation  therapist', 'E55', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (55, 'transfusion physician', 'E56', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (56, 'urologist', 'E57', 0);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (57, 'lawyers', 'E58', 2);
INSERT INTO user_management.specialization(specialization_id, name, abbreviation, discipline_id) OVERRIDING SYSTEM VALUE VALUES (58, 'IT security expert', 'E59', 3);

INSERT INTO user_management.user(id, firstname, lastname, username, email) VALUES ('bdafe60a-35fb-46b5-977c-e64350878402', 'mhealth', 'atlas', 'mhealthatlas', '');
INSERT INTO user_management.user(id, firstname, lastname, username, email, enterprise) VALUES ('6219ff18-e950-4652-89cc-1a4c28eb32fc', 'loadtest', 'loadtest', 'loadtest', 'loadtest@test.com', 'hi_loadtest');
INSERT INTO user_management.user_role(id, user_id, role_type) OVERRIDING SYSTEM VALUE VALUES (0, 'bdafe60a-35fb-46b5-977c-e64350878402', 'Admin');
INSERT INTO user_management.user_role(id, user_id, role_type) OVERRIDING SYSTEM VALUE VALUES (1, '6219ff18-e950-4652-89cc-1a4c28eb32fc', 'Company_Admin');
INSERT INTO user_management.user_role(id, user_id, role_type) OVERRIDING SYSTEM VALUE VALUES (2, '6219ff18-e950-4652-89cc-1a4c28eb32fc', 'Content_Manager');
INSERT INTO user_management.user_role(id, user_id, role_type) OVERRIDING SYSTEM VALUE VALUES (3, '6219ff18-e950-4652-89cc-1a4c28eb32fc', 'Expert');
INSERT INTO user_management.user_role(id, user_id, role_type) OVERRIDING SYSTEM VALUE VALUES (4, '6219ff18-e950-4652-89cc-1a4c28eb32fc', 'HI_Admin');
INSERT INTO user_management.user_role(id, user_id, role_type) OVERRIDING SYSTEM VALUE VALUES (5, '6219ff18-e950-4652-89cc-1a4c28eb32fc', 'Subscriber');


SELECT pg_catalog.setval('user_management.discipline_discipline_id_seq', 3, true);
SELECT pg_catalog.setval('user_management.specialization_specialization_id_seq', 58, true);
SELECT pg_catalog.setval('user_management.user_role_id_seq', 5, true);
