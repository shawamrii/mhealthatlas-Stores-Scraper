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

CREATE SCHEMA store_apps ;


SET default_table_access_method = heap;

--extra just von mir aus
CREATE TABLE store_apps.search_infos (
    title text NOT NULL,
    link text
    link_app_id integer NOT NULL,
    UNIQUE (link_app_id, link)

);
ALTER TABLE ONLY store_apps.search_infos
    ADD CONSTRAINT link_app_id_ios_app_id_fkey FOREIGN KEY (link_app_id) REFERENCES store_apps.ios_app(app_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE store_apps.android_app (
    app_id integer NOT NULL PRIMARY KEY,--wird beim inserten generiert
    playstore_id text NOT NULL UNIQUE,
    title text NOT NULL,
    description text NOT NULL,
    icon_url text,
    developer text,
    price_in_cent integer
    --mhealthatlas_app_id integer NOT NULL UNIQUE
);


ALTER TABLE store_apps.android_app ALTER COLUMN app_id ADD GENERATED ALWAYS AS IDENTITY(
    SEQUENCE NAME store_apps.android_app_app_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE store_apps.android_app_version (
    app_version_id integer NOT NULL PRIMARY KEY,--wird beim inserten generiert
    version text NOT NULL,
    --score text,
    review_count integer,
    release_date timestamp without time zone,
    recent_changes text,
    last_access timestamp without time zone,
    is_latest_version boolean NOT NULL,
    android_app_id integer NOT NULL,
  
    -- total_score double precision DEFAULT 0 NOT NULL,
    -- content_score double precision DEFAULT 0 NOT NULL,
    -- usability_score double precision DEFAULT 0 NOT NULL,
    -- security_score double precision DEFAULT 0 NOT NULL,
    -- law_score double precision DEFAULT 0 NOT NULL,
    UNIQUE (android_app_id, version)
);
ALTER TABLE store_apps.android_app_version ALTER COLUMN app_version_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME store_apps.android_app_version_app_version_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY store_apps.android_app_version
    ADD CONSTRAINT android_app_version_android_app_id_fkey FOREIGN KEY (android_app_id) REFERENCES store_apps.android_app(app_id) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE INDEX android_app_version_newest_id
  ON store_apps.android_app_version (android_app_id, is_latest_version);


CREATE TABLE store_apps.ios_app (
    app_id integer NOT NULL PRIMARY KEY,
    appstore_id text NOT NULL UNIQUE,
    title text NOT NULL,
    description text NOT NULL,
    icon_url text,
    developer text,
    price_in_cent integer
   -- mhealthatlas_app_id integer NOT NULL UNIQUE
);


ALTER TABLE store_apps.ios_app ALTER COLUMN app_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME store_apps.ios_app_app_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);


CREATE TABLE store_apps.ios_app_version (
    app_version_id integer NOT NULL PRIMARY KEY,
    version text NOT NULL,
    --score text,
    review_count integer,
    release_date timestamp without time zone,
    recent_changes text,
    last_access timestamp without time zone,
    is_latest_version boolean NOT NULL,
    ios_app_id integer NOT NULL,
    -- total_score double precision DEFAULT 0 NOT NULL,
    -- content_score double precision DEFAULT 0 NOT NULL,
    -- usability_score double precision DEFAULT 0 NOT NULL,
    -- security_score double precision DEFAULT 0 NOT NULL,
    -- law_score double precision DEFAULT 0 NOT NULL,
    UNIQUE (ios_app_id, version)
);

ALTER TABLE store_apps.ios_app_version ALTER COLUMN app_version_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME store_apps.ios_app_version_app_version_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);
ALTER TABLE ONLY store_apps.ios_app_version
    ADD CONSTRAINT ios_app_version_ios_app_id_fkey FOREIGN KEY (ios_app_id) REFERENCES store_apps.ios_app(app_id) ON DELETE CASCADE ON UPDATE CASCADE  ;

CREATE INDEX ios_app_version_newest_id
  ON store_apps.ios_app_version (ios_app_id, is_latest_version);


CREATE TABLE store_apps.private_customer_app (
    app_id integer NOT NULL PRIMARY KEY,
    app_source_url text NOT NULL UNIQUE,
    title text NOT NULL,
    description text NOT NULL,
    icon_url text,
    developer text
   -- mhealthatlas_app_id integer NOT NULL UNIQUE
);

ALTER TABLE store_apps.private_customer_app ALTER COLUMN app_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME store_apps.private_customer_app_app_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE store_apps.private_customer_app_version (
    app_version_id integer NOT NULL PRIMARY KEY,
    version text NOT NULL,
    release_date timestamp without time zone,
    recent_changes text,
    last_access timestamp without time zone,
    is_latest_version boolean NOT NULL,
    private_customer_app_id integer NOT NULL,
    -- total_score double precision DEFAULT 0 NOT NULL,
    -- content_score double precision DEFAULT 0 NOT NULL,
    -- usability_score double precision DEFAULT 0 NOT NULL,
    -- security_score double precision DEFAULT 0 NOT NULL,
    -- law_score double precision DEFAULT 0 NOT NULL,
    UNIQUE (private_customer_app_id, version)
);

ALTER TABLE store_apps.private_customer_app_version ALTER COLUMN app_version_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME store_apps.private_customer_app_version_app_version_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);
ALTER TABLE ONLY store_apps.private_customer_app_version
    ADD CONSTRAINT private_customer_app_version_private_customer_app_id_fkey FOREIGN KEY (private_customer_app_id) REFERENCES store_apps.private_customer_app(app_id) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE INDEX private_customer_app_version_newest_id
  ON store_apps.private_customer_app_version (private_customer_app_id, is_latest_version);


CREATE TABLE store_apps.outbox (
    event_id UUID NOT NULL PRIMARY KEY,
    version integer NOT NULL,
    root_aggregate_type text NOT NULL,
    root_aggregate_id text NOT NULL,
    aggregate_type text NOT NULL,
    aggregate_id text NOT NULL,
    event_type text NOT NULL,
    payload text NOT NULL
);

ALTER TABLE store_apps.outbox OWNER TO postgres;

CREATE OR REPLACE FUNCTION store_apps.insert_android_app_version_android_app_releationship()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	IF NEW.android_app_id is null THEN
		 INSERT INTO store_apps.android_app_version(android_app_id)
		 VALUES(new.app_id)
     RETURNING app_id INTO NEW.android_app_id ;
	END IF;

	RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION store_apps.insert_android_app_latest_version()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
  IF NEW.is_latest_version = TRUE THEN
    update store_apps.android_app_version
    set is_latest_version = FALSE
    where android_app_id = NEW.android_app_id
    and is_latest_version = TRUE
    and version <> NEW.version;
  END IF;

	RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION store_apps.insert_ios_app_version_ios_app_releationship()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	IF NEW.ios_app_id is null THEN
		 INSERT INTO store_apps.ios_app_version(ios_app_id)
		 VALUES(new.app_id)
     RETURNING app_id INTO NEW.ios_app_id ;
	END IF;

	RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION store_apps.insert_ios_app_latest_version()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
  IF NEW.is_latest_version = TRUE THEN
    update store_apps.ios_app_version
    set is_latest_version = FALSE
    where ios_app_id = NEW.ios_app_id
    and is_latest_version = TRUE
    and version <> NEW.version;
  END IF;

	RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION store_apps.insert_private_customer_app_private_customer_app_version_releationship()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	IF NEW.private_customer_app_id is null THEN
		 INSERT INTO store_apps.private_customer_app_version(private_customer_app_id)
		 VALUES(new.app_id)
     RETURNING app_id INTO NEW.private_customer_app_id ;
	END IF;

	RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION store_apps.insert_private_customer_app_latest_version()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
  IF NEW.is_latest_version = TRUE THEN
    update store_apps.private_customer_app_version
    set is_latest_version = FALSE
    where private_customer_app_id = NEW.private_customer_app_id
    and is_latest_version = TRUE
    and version <> NEW.version;
  END IF;

	RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION store_apps.update_android_app_latest_version()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
  IF NEW.is_latest_version = TRUE THEN
    update store_apps.android_app_version
    set is_latest_version = FALSE
    where android_app_id = NEW.android_app_id
    and is_latest_version = TRUE
    and version <> NEW.version;
  END IF;

	RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION store_apps.update_ios_app_latest_version()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
  IF NEW.is_latest_version = TRUE THEN
    update store_apps.ios_app_version
    set is_latest_version = FALSE
    where ios_app_id = NEW.ios_app_id
    and is_latest_version = TRUE
    and version <> NEW.version;
  END IF;

	RETURN NEW;
END;
$$;



CREATE OR REPLACE FUNCTION store_apps.update_private_customer_app_latest_version()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
  IF NEW.is_latest_version = TRUE THEN
    update store_apps.private_customer_app_version
    set is_latest_version = FALSE
    where private_customer_app_id = NEW.private_customer_app_id
    and is_latest_version = TRUE
    and version <> NEW.version;
  END IF;

	RETURN NEW;
END;
$$;


CREATE TRIGGER "android_app_version_trg_bi"
    BEFORE INSERT
    ON store_apps.android_app_version
    FOR EACH ROW
    EXECUTE PROCEDURE store_apps.insert_android_app_latest_version();



CREATE TRIGGER "ios_app_version_trg_bi"
    BEFORE INSERT
    ON store_apps.ios_app_version
    FOR EACH ROW
    EXECUTE PROCEDURE store_apps.insert_ios_app_latest_version();


CREATE TRIGGER "private_customer_app_version_trg_bi"
    BEFORE INSERT
    ON store_apps.private_customer_app_version
    FOR EACH ROW
    EXECUTE PROCEDURE store_apps.insert_private_customer_app_latest_version();


CREATE TRIGGER "android_app_version_trg_au"
    AFTER UPDATE
    ON store_apps.android_app_version
    FOR EACH ROW
    EXECUTE PROCEDURE store_apps.update_android_app_latest_version();


CREATE TRIGGER "ios_app_version_trg_au"
    AFTER UPDATE
    ON store_apps.ios_app_version
    FOR EACH ROW
    EXECUTE PROCEDURE store_apps.update_ios_app_latest_version();

CREATE TRIGGER "private_customer_app_version_trg_au"
    AFTER UPDATE
    ON store_apps.private_customer_app_version
    FOR EACH ROW
    EXECUTE PROCEDURE store_apps.update_private_customer_app_latest_version();
