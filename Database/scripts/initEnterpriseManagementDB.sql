
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

CREATE SCHEMA enterprise_management;

SET default_table_access_method = heap;

--CREATE TYPE enterprise_management.role AS ENUM ('Subscriber', 'Expert', 'Company_Admin', 'HI_Admin', 'Content_Manager', 'Admin');
CREATE TYPE enterprise_management.enterprise_type AS ENUM ('Health_Insurance', 'Company');


CREATE TABLE enterprise_management.enterprise (
  enterprise_id UUID NOT NULL PRIMARY KEY,
  name text NOT NULL UNIQUE,
  enterprise_type enterprise_management.enterprise_type NOT NULL,
  display_name text,
  enterprise_details text
);


CREATE TABLE enterprise_management.user (
  user_id UUID NOT NULL PRIMARY KEY,
  enterprise_id UUID NOT NULL,
  firstname text NOT NULL,
  lastname text NOT NULL,
  username text NOT NULL UNIQUE,
  email text NOT NULL,
  department text
);

ALTER TABLE ONLY enterprise_management.user
  ADD CONSTRAINT user_enterprise_id_fkey FOREIGN KEY (enterprise_id) REFERENCES enterprise_management.enterprise(enterprise_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE enterprise_management.outbox (
  event_id UUID NOT NULL PRIMARY KEY,
  version integer NOT NULL,
  root_aggregate_type text NOT NULL,
  root_aggregate_id text NOT NULL,
  aggregate_type text NOT NULL,
  aggregate_id text NOT NULL,
  event_type text NOT NULL,
  payload text NOT NULL
);

ALTER TABLE enterprise_management.outbox OWNER TO postgres;

INSERT INTO enterprise_management.enterprise(enterprise_id, name, enterprise_type) VALUES ('8c3463b2-712c-4f74-b287-6490c0d91e6e', 'hi_loadtest', 'Health_Insurance');
INSERT INTO enterprise_management.enterprise(enterprise_id, name, enterprise_type) VALUES ('8c9dfc63-aca5-40a5-bdea-da28d88daf86', 'company_loadtest', 'Company');

INSERT INTO enterprise_management.user(user_id, enterprise_id, firstname, lastname, username, email) VALUES ('6219ff18-e950-4652-89cc-1a4c28eb32fc', '8c3463b2-712c-4f74-b287-6490c0d91e6e', 'loadtest', 'loadtest', 'loadtest', 'loadtest@test.com');
