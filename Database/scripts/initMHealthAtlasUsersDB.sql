
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

CREATE SCHEMA mhealthatlas_users;

SET default_table_access_method = heap;

CREATE TYPE mhealthatlas_users.platform AS ENUM ('Android', 'Ios', 'Web');

CREATE TABLE mhealthatlas_users.user (
  id UUID NOT NULL PRIMARY KEY
);


CREATE TABLE mhealthatlas_users.setting (
  id integer NOT NULL PRIMARY KEY,
  name text NOT NULL,
  description text NOT NULL,
  platform mhealthatlas_users.platform NOT NULL,
  UNIQUE(name, platform)
);

ALTER TABLE mhealthatlas_users.setting ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
  SEQUENCE NAME mhealthatlas_users.setting_id_seq
  START WITH 0
  INCREMENT BY 1
  MINVALUE 0
  NO MAXVALUE
  CACHE 1
);


CREATE TABLE mhealthatlas_users.user_setting (
  id integer NOT NULL PRIMARY KEY,
  user_id UUID NOT NULL,
  setting_id integer NOT NULL,
  value text NOT NULL,
  UNIQUE(user_id, setting_id)
);

ALTER TABLE mhealthatlas_users.user_setting ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
  SEQUENCE NAME mhealthatlas_users.user_setting_id_seq
  START WITH 0
  INCREMENT BY 1
  MINVALUE 0
  NO MAXVALUE
  CACHE 1
);

ALTER TABLE ONLY mhealthatlas_users.user_setting
    ADD CONSTRAINT user_setting_user_id_fkey FOREIGN KEY (user_id) REFERENCES mhealthatlas_users.user(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY mhealthatlas_users.user_setting
    ADD CONSTRAINT user_setting_setting_id_fkey FOREIGN KEY (setting_id) REFERENCES mhealthatlas_users.setting(id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE mhealthatlas_users.user_query (
  id integer NOT NULL PRIMARY KEY,
  user_id UUID NOT NULL,
  value text NOT NULL
);

ALTER TABLE mhealthatlas_users.user_query ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
  SEQUENCE NAME mhealthatlas_users.user_query_id_seq
  START WITH 0
  INCREMENT BY 1
  MINVALUE 0
  NO MAXVALUE
  CACHE 1
);

ALTER TABLE ONLY mhealthatlas_users.user_query
    ADD CONSTRAINT user_query_user_id_fkey FOREIGN KEY (user_id) REFERENCES mhealthatlas_users.user(id) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE mhealthatlas_users.outbox (
  event_id UUID NOT NULL PRIMARY KEY,
  version integer NOT NULL,
  root_aggregate_type text NOT NULL,
  root_aggregate_id text NOT NULL,
  aggregate_type text NOT NULL,
  aggregate_id text NOT NULL,
  event_type text NOT NULL,
  payload text NOT NULL
);

ALTER TABLE mhealthatlas_users.outbox OWNER TO postgres;

INSERT INTO mhealthatlas_users.user(id) VALUES ('bdafe60a-35fb-46b5-977c-e64350878402');
INSERT INTO mhealthatlas_users.user(id) VALUES ('6219ff18-e950-4652-89cc-1a4c28eb32fc');

INSERT INTO mhealthatlas_users.setting(id, name, description, platform) OVERRIDING SYSTEM VALUE VALUES (0, 'test setting', 'this setting can be found for all supported plattforms', 'Android');
INSERT INTO mhealthatlas_users.setting(id, name, description, platform) OVERRIDING SYSTEM VALUE VALUES (1, 'test setting', 'this setting can be found for all supported plattforms', 'Ios');
INSERT INTO mhealthatlas_users.setting(id, name, description, platform) OVERRIDING SYSTEM VALUE VALUES (2, 'test setting', 'this setting can be found for all supported plattforms', 'Web');
INSERT INTO mhealthatlas_users.setting(id, name, description, platform) OVERRIDING SYSTEM VALUE VALUES (3, 'plattform specific test setting', 'this setting is only for the web application', 'Web');

SELECT pg_catalog.setval('mhealthatlas_users.setting_id_seq', 3, true);
