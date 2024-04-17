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

CREATE SCHEMA apps;


SET default_table_access_method = heap;


CREATE TABLE apps.mhealthatlas_app (
    app_id integer NOT NULL PRIMARY KEY,
    android_app_id integer,
    ios_app_id integer,
    private_customer_app_id integer
);

ALTER TABLE apps.mhealthatlas_app ALTER COLUMN app_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME apps.mhealthatlas_app_app_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);


CREATE TABLE apps.android_app (
    app_id integer NOT NULL PRIMARY KEY,
    playstore_id text NOT NULL UNIQUE,
    title text NOT NULL,
    description text NOT NULL,
    icon_url text,
    developer text,
    price_in_cent integer,
    mhealthatlas_app_id integer NOT NULL UNIQUE
);


ALTER TABLE apps.android_app ALTER COLUMN app_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME apps.android_app_app_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY apps.android_app
    ADD CONSTRAINT android_app_mhealthatlas_app_id_fkey FOREIGN KEY (mhealthatlas_app_id) REFERENCES apps.mhealthatlas_app(app_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE apps.android_app_version (
    app_version_id integer NOT NULL PRIMARY KEY,
    version text NOT NULL,
    score text,
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

ALTER TABLE apps.android_app_version ALTER COLUMN app_version_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME apps.android_app_version_app_version_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY apps.android_app_version
    ADD CONSTRAINT android_app_version_android_app_id_fkey FOREIGN KEY (android_app_id) REFERENCES apps.android_app(app_id) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE INDEX android_app_version_newest_id
  ON apps.android_app_version (android_app_id, is_latest_version);


CREATE TABLE apps.ios_app (
    app_id integer NOT NULL PRIMARY KEY,
    appstore_id text NOT NULL UNIQUE,
    title text NOT NULL,
    description text NOT NULL,
    icon_url text,
    developer text,
    price_in_cent integer,
    mhealthatlas_app_id integer NOT NULL UNIQUE
);


ALTER TABLE apps.ios_app ALTER COLUMN app_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME apps.ios_app_app_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY apps.ios_app
    ADD CONSTRAINT ios_app_mhealthatlas_app_id_fkey FOREIGN KEY (mhealthatlas_app_id) REFERENCES apps.mhealthatlas_app(app_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE apps.ios_app_version (
    app_version_id integer NOT NULL PRIMARY KEY,
    version text NOT NULL,
    score text,
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

ALTER TABLE apps.ios_app_version ALTER COLUMN app_version_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME apps.ios_app_version_app_version_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY apps.ios_app_version
    ADD CONSTRAINT ios_app_version_ios_app_id_fkey FOREIGN KEY (ios_app_id) REFERENCES apps.ios_app(app_id) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE INDEX ios_app_version_newest_id
  ON apps.ios_app_version (ios_app_id, is_latest_version);


CREATE TABLE apps.private_customer_app (
    app_id integer NOT NULL PRIMARY KEY,
    app_source_url text NOT NULL UNIQUE,
    title text NOT NULL,
    description text NOT NULL,
    icon_url text,
    developer text,
    mhealthatlas_app_id integer NOT NULL UNIQUE
);

ALTER TABLE apps.private_customer_app ALTER COLUMN app_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME apps.private_customer_app_app_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY apps.private_customer_app
    ADD CONSTRAINT private_customer_app_mhealthatlas_app_id_fkey FOREIGN KEY (mhealthatlas_app_id) REFERENCES apps.mhealthatlas_app(app_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE apps.private_customer_app_version (
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

ALTER TABLE apps.private_customer_app_version ALTER COLUMN app_version_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME apps.private_customer_app_version_app_version_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY apps.private_customer_app_version
    ADD CONSTRAINT private_customer_app_version_private_customer_app_id_fkey FOREIGN KEY (private_customer_app_id) REFERENCES apps.private_customer_app(app_id) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE INDEX private_customer_app_version_newest_id
  ON apps.private_customer_app_version (private_customer_app_id, is_latest_version);


CREATE TABLE apps.category (
    category_id integer NOT NULL PRIMARY KEY,
    level_id integer NOT NULL,
    is_terminate_node boolean NOT NULL
);


CREATE TABLE apps.taxonomy_class (
    taxonomy_class_id integer NOT NULL PRIMARY KEY,
    layer0_category_id integer NOT NULL,
    layer1_category_id integer,
    layer2_category_id integer,
    layer3_category_id integer,
    layer4_category_id integer,
    layer5_category_id integer,
    layer6_category_id integer,
    layer7_category_id integer,
    UNIQUE (layer0_category_id, layer1_category_id, layer2_category_id, layer3_category_id,
            layer4_category_id, layer5_category_id, layer6_category_id, layer7_category_id)
);

ALTER TABLE apps.taxonomy_class ALTER COLUMN taxonomy_class_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME apps.taxonomy_class_taxonomy_class_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY apps.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer0_category_id_fkey FOREIGN KEY (layer0_category_id) REFERENCES apps.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY apps.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer1_category_id_fkey FOREIGN KEY (layer1_category_id) REFERENCES apps.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY apps.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer2_category_id_fkey FOREIGN KEY (layer2_category_id) REFERENCES apps.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY apps.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer3_category_id_fkey FOREIGN KEY (layer3_category_id) REFERENCES apps.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY apps.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer4_category_id_fkey FOREIGN KEY (layer4_category_id) REFERENCES apps.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY apps.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer5_category_id_fkey FOREIGN KEY (layer5_category_id) REFERENCES apps.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY apps.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer6_category_id_fkey FOREIGN KEY (layer6_category_id) REFERENCES apps.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY apps.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer7_category_id_fkey FOREIGN KEY (layer7_category_id) REFERENCES apps.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE apps.app_version_taxonomy_class (
    id integer NOT NULL PRIMARY KEY,
    android_version_id integer,
    ios_version_id integer,
    private_customer_version_id integer,
    taxonomy_class_id integer NOT NULL,
    total_score double precision DEFAULT 0 NOT NULL,
    content_score double precision DEFAULT 0 NOT NULL,
    usability_score double precision DEFAULT 0 NOT NULL,
    security_score double precision DEFAULT 0 NOT NULL,
    law_score double precision DEFAULT 0 NOT NULL,
    UNIQUE(android_version_id, taxonomy_class_id),
    UNIQUE(ios_version_id, taxonomy_class_id),
    UNIQUE(private_customer_version_id, taxonomy_class_id),
    CONSTRAINT platform_unique_check CHECK ((((android_version_id IS NOT NULL) AND (ios_version_id IS NULL) AND (private_customer_version_id IS NULL)) OR
                                             ((android_version_id IS NULL) AND (ios_version_id IS NOT NULL) AND (private_customer_version_id IS NULL)) OR
                                             ((android_version_id IS NULL) AND (ios_version_id IS NULL) AND (private_customer_version_id IS NOT NULL))))
);

ALTER TABLE apps.app_version_taxonomy_class ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME apps.app_version_taxonomy_class_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY apps.app_version_taxonomy_class
    ADD CONSTRAINT app_version_taxonomy_class_android_version_id_fkey FOREIGN KEY (android_version_id) REFERENCES apps.android_app_version(app_version_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY apps.app_version_taxonomy_class
    ADD CONSTRAINT app_version_taxonomy_class_ios_version_id_fkey FOREIGN KEY (ios_version_id) REFERENCES apps.ios_app_version(app_version_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY apps.app_version_taxonomy_class
    ADD CONSTRAINT app_version_taxonomy_class_private_customer_version_id_fkey FOREIGN KEY (private_customer_version_id) REFERENCES apps.private_customer_app_version(app_version_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY apps.app_version_taxonomy_class
    ADD CONSTRAINT app_version_taxonomy_class_taxonomy_class_id_fkey FOREIGN KEY (taxonomy_class_id) REFERENCES apps.taxonomy_class(taxonomy_class_id) ON UPDATE CASCADE ON DELETE CASCADE;


CREATE TABLE apps.outbox (
    event_id UUID NOT NULL PRIMARY KEY,
    version integer NOT NULL,
    root_aggregate_type text NOT NULL,
    root_aggregate_id text NOT NULL,
    aggregate_type text NOT NULL,
    aggregate_id text NOT NULL,
    event_type text NOT NULL,
    payload text NOT NULL
);

ALTER TABLE apps.outbox OWNER TO postgres;


CREATE OR REPLACE FUNCTION apps.insert_android_app_mhealthatlas_app_releationship()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	IF NEW.mhealthatlas_app_id is null THEN
		 INSERT INTO apps.mhealthatlas_app(android_app_id)
		 VALUES(new.app_id)
     RETURNING app_id INTO NEW.mhealthatlas_app_id ;
	END IF;

	RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION apps.insert_android_app_latest_version()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
  IF NEW.is_latest_version = TRUE THEN
    update apps.android_app_version
    set is_latest_version = FALSE
    where android_app_id = NEW.android_app_id
    and is_latest_version = TRUE
    and version <> NEW.version;
  END IF;

	RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION apps.insert_ios_app_mhealthatlas_app_releationship()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	IF NEW.mhealthatlas_app_id is null THEN
		 INSERT INTO apps.mhealthatlas_app(ios_app_id)
		 VALUES(new.app_id)
     RETURNING app_id INTO NEW.mhealthatlas_app_id ;
	END IF;

	RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION apps.insert_ios_app_latest_version()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
  IF NEW.is_latest_version = TRUE THEN
    update apps.ios_app_version
    set is_latest_version = FALSE
    where ios_app_id = NEW.ios_app_id
    and is_latest_version = TRUE
    and version <> NEW.version;
  END IF;

	RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION apps.insert_private_customer_app_mhealthatlas_app_releationship()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	IF NEW.mhealthatlas_app_id is null THEN
		 INSERT INTO apps.mhealthatlas_app(private_customer_app_id)
		 VALUES(new.app_id)
     RETURNING app_id INTO NEW.mhealthatlas_app_id ;
	END IF;

	RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION apps.insert_private_customer_app_latest_version()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
  IF NEW.is_latest_version = TRUE THEN
    update apps.private_customer_app_version
    set is_latest_version = FALSE
    where private_customer_app_id = NEW.private_customer_app_id
    and is_latest_version = TRUE
    and version <> NEW.version;
  END IF;

	RETURN NEW;
END;
$$;


CREATE OR REPLACE FUNCTION apps.update_android_app_mhealthatlas_app_releationship()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	IF NEW.mhealthatlas_app_id is not null and (NEW.mhealthatlas_app_id <> OLD.mhealthatlas_app_id or OLD.mhealthatlas_app_id is null) THEN
    update apps.mhealthatlas_app set android_app_id = null where app_id = OLD.mhealthatlas_app_id;
    update apps.mhealthatlas_app set android_app_id = NEW.app_id where app_id = NEW.mhealthatlas_app_id;
	END IF;

	RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION apps.update_android_app_latest_version()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
  IF NEW.is_latest_version = TRUE THEN
    update apps.android_app_version
    set is_latest_version = FALSE
    where android_app_id = NEW.android_app_id
    and is_latest_version = TRUE
    and version <> NEW.version;
  END IF;

	RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION apps.update_ios_app_mhealthatlas_app_releationship()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	IF NEW.mhealthatlas_app_id is not null and (NEW.mhealthatlas_app_id <> OLD.mhealthatlas_app_id or OLD.mhealthatlas_app_id is null) THEN
    update apps.mhealthatlas_app set ios_app_id = null where app_id = OLD.mhealthatlas_app_id;
    update apps.mhealthatlas_app set ios_app_id = NEW.app_id where app_id = NEW.mhealthatlas_app_id;
	END IF;

	RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION apps.update_ios_app_latest_version()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
  IF NEW.is_latest_version = TRUE THEN
    update apps.ios_app_version
    set is_latest_version = FALSE
    where ios_app_id = NEW.ios_app_id
    and is_latest_version = TRUE
    and version <> NEW.version;
  END IF;

	RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION apps.update_private_customer_app_mhealthatlas_app_releationship()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	IF NEW.mhealthatlas_app_id is not null and (NEW.mhealthatlas_app_id <> OLD.mhealthatlas_app_id or OLD.mhealthatlas_app_id is null) THEN
    update apps.mhealthatlas_app set private_customer_app_id = null where app_id = OLD.mhealthatlas_app_id;
    update apps.mhealthatlas_app set private_customer_app_id = NEW.app_id where app_id = NEW.mhealthatlas_app_id;
	END IF;

	RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION apps.update_private_customer_app_latest_version()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
  IF NEW.is_latest_version = TRUE THEN
    update apps.private_customer_app_version
    set is_latest_version = FALSE
    where private_customer_app_id = NEW.private_customer_app_id
    and is_latest_version = TRUE
    and version <> NEW.version;
  END IF;

	RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION apps.delete_android_app_mhealthatlas_app_releationship()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
  update apps.mhealthatlas_app set android_app_id = null where app_id = OLD.mhealthatlas_app_id;

	RETURN OLD;
END;
$$;

CREATE OR REPLACE FUNCTION apps.delete_ios_app_mhealthatlas_app_releationship()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
  update apps.mhealthatlas_app set ios_app_id = null where app_id = OLD.mhealthatlas_app_id;

	RETURN OLD;
END;
$$;

CREATE OR REPLACE FUNCTION apps.delete_private_customer_app_mhealthatlas_app_releationship()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
  update apps.mhealthatlas_app set private_customer_app_id = null where app_id = OLD.mhealthatlas_app_id;

	RETURN OLD;
END;
$$;

CREATE OR REPLACE FUNCTION apps.delete_empty_mhealthatlas_apps()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	IF NEW.android_app_id is null and NEW.ios_app_id is null and NEW.private_customer_app_id is null THEN
     DELETE FROM apps.mhealthatlas_app where app_id = NEW.app_id;
	END IF;

  RETURN NEW;
END;
$$;

CREATE TRIGGER "android_app_trg_bi"
    BEFORE INSERT
    ON apps.android_app
    FOR EACH ROW
    EXECUTE PROCEDURE apps.insert_android_app_mhealthatlas_app_releationship();

CREATE TRIGGER "android_app_version_trg_bi"
    BEFORE INSERT
    ON apps.android_app_version
    FOR EACH ROW
    EXECUTE PROCEDURE apps.insert_android_app_latest_version();

CREATE TRIGGER "ios_app_trg_bi"
    BEFORE INSERT
    ON apps.ios_app
    FOR EACH ROW
    EXECUTE PROCEDURE apps.insert_ios_app_mhealthatlas_app_releationship();

CREATE TRIGGER "ios_app_version_trg_bi"
    BEFORE INSERT
    ON apps.ios_app_version
    FOR EACH ROW
    EXECUTE PROCEDURE apps.insert_ios_app_latest_version();

CREATE TRIGGER "private_customer_app_trg_bi"
    BEFORE INSERT
    ON apps.private_customer_app
    FOR EACH ROW
    EXECUTE PROCEDURE apps.insert_private_customer_app_mhealthatlas_app_releationship();

CREATE TRIGGER "private_customer_app_version_trg_bi"
    BEFORE INSERT
    ON apps.private_customer_app_version
    FOR EACH ROW
    EXECUTE PROCEDURE apps.insert_private_customer_app_latest_version();


CREATE TRIGGER "android_app_trg_au"
    AFTER UPDATE
    ON apps.android_app
    FOR EACH ROW
    EXECUTE PROCEDURE apps.update_android_app_mhealthatlas_app_releationship();

CREATE TRIGGER "android_app_version_trg_au"
    AFTER UPDATE
    ON apps.android_app_version
    FOR EACH ROW
    EXECUTE PROCEDURE apps.update_android_app_latest_version();

CREATE TRIGGER "ios_app_trg_au"
    AFTER UPDATE
    ON apps.ios_app
    FOR EACH ROW
    EXECUTE PROCEDURE apps.update_ios_app_mhealthatlas_app_releationship();

CREATE TRIGGER "ios_app_version_trg_au"
    AFTER UPDATE
    ON apps.ios_app_version
    FOR EACH ROW
    EXECUTE PROCEDURE apps.update_ios_app_latest_version();

CREATE TRIGGER "private_customer_app_trg_au"
    AFTER UPDATE
    ON apps.private_customer_app
    FOR EACH ROW
    EXECUTE PROCEDURE apps.update_private_customer_app_mhealthatlas_app_releationship();

CREATE TRIGGER "private_customer_app_version_trg_au"
    AFTER UPDATE
    ON apps.private_customer_app_version
    FOR EACH ROW
    EXECUTE PROCEDURE apps.update_private_customer_app_latest_version();

CREATE TRIGGER "android_app_trg_ad"
    AFTER DELETE
    ON apps.android_app
    FOR EACH ROW
    EXECUTE PROCEDURE apps.delete_android_app_mhealthatlas_app_releationship();

CREATE TRIGGER "ios_app_trg_ad"
    AFTER DELETE
    ON apps.ios_app
    FOR EACH ROW
    EXECUTE PROCEDURE apps.delete_ios_app_mhealthatlas_app_releationship();

CREATE TRIGGER "private_customer_app_trg_ad"
    AFTER DELETE
    ON apps.private_customer_app
    FOR EACH ROW
    EXECUTE PROCEDURE apps.delete_private_customer_app_mhealthatlas_app_releationship();

CREATE TRIGGER "mhealthatlas_app_trg_au"
    AFTER UPDATE
    ON apps.mhealthatlas_app
    FOR EACH ROW
    EXECUTE PROCEDURE apps.delete_empty_mhealthatlas_apps();


INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (0, 0, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (1, 0, true);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (2, 1, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (3, 1, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (4, 1, true);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (5, 2, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (6, 2, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (7, 2, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (8, 2, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (9, 2, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (10, 2, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (11, 2, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (12, 2, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (13, 2, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (14, 2, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (15, 2, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (16, 2, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (17, 2, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (18, 2, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (19, 2, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (20, 2, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (21, 2, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (22, 3, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (23, 3, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (24, 4, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (25, 4, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (26, 4, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (27, 4, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (28, 5, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (29, 5, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (30, 6, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (31, 6, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (32, 7, false);
INSERT INTO apps.category OVERRIDING SYSTEM VALUE VALUES (33, 7, false);

INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (0, 0, 0, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (1, 1, 1, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (2, 2, 2, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (3, 3, NULL, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (4, NULL, 3, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (5, 4, 4, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (6, 5, 5, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (7, 6, 6, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (8, 7, NULL, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (9, NULL, 7, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (10, 8, NULL, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (11, 9, NULL, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (12, 10, NULL, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (13, 11, NULL, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (14, 12, NULL, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (15, 13, NULL, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (16, 14, NULL, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (17, 15, NULL, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (18, 16, NULL, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (19, 17, NULL, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (20, 18, NULL, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (21, 19, NULL, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (22, 20, NULL, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (23, 21, NULL, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (24, 22, NULL, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (25, 23, NULL, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (26, NULL, 8, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (27, NULL, 9, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (28, NULL, 10, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (29, NULL, 11, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (30, NULL, 12, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (31, NULL, 13, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (32, NULL, 14, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (33, NULL, 15, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (34, NULL, 16, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (35, NULL, 17, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (36, NULL, 18, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (37, NULL, 19, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (38, NULL, 20, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (39, NULL, 21, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (40, NULL, 22, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (41, NULL, 23, NULL);
INSERT INTO apps.mhealthatlas_app (app_id, android_app_id, ios_app_id, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (42, NULL, NULL, 0);

INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (0, 'g_p_id_1', 'a app 1', 'My super first Android app description :D', 'https://images.pexels.com/photos/1440722/pexels-photo-1440722.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 99, 0);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (1, 'g_p_id_2', 'a app 2', 'second Android app description, not so bad...a very long text', 'https://images.pexels.com/photos/1181244/pexels-photo-1181244.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', NULL, 1);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (2, 'g_p_id_3', 'a app 3', 'short description android', 'https://images.pexels.com/photos/1440727/pexels-photo-1440727.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', NULL, 2);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (3, 'g_p_id_4', 'android no ios', 'ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 356, 3);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (4, 'duplicate: g_p_id_1', 'duplicate: a app 1', 'duplicate: My super first Android app description :D', 'https://images.pexels.com/photos/1440722/pexels-photo-1440722.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 99, 5);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (5, 'duplicate: g_p_id_2', 'duplicate: a app 2', 'duplicate: second Android app description, not so bad...a very long text', 'https://images.pexels.com/photos/1181244/pexels-photo-1181244.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', NULL, 6);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (6, 'duplicate: g_p_id_3', 'duplicate: a app 3', 'duplicate: short description android', 'https://images.pexels.com/photos/1440727/pexels-photo-1440727.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', NULL, 7);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (7, 'duplicate: g_p_id_4', 'duplicate: android no ios', 'duplicate: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 356, 8);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (8, 'duplicate 2: g_p_id_4', 'duplicate 2: android no ios', 'duplicate 2: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 356, 10);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (9, 'duplicate 3: g_p_id_4', 'duplicate 3: android no ios', 'duplicate 3: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 356, 11);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (10, 'duplicate 4: g_p_id_4', 'duplicate 4: android no ios', 'duplicate 4: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 356, 12);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (11, 'duplicate 5: g_p_id_4', 'duplicate 5: android no ios', 'duplicate 5: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 356, 13);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (12, 'duplicate 6: g_p_id_4', 'duplicate 6: android no ios', 'duplicate 6: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 356, 14);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (13, 'duplicate 7: g_p_id_4', 'duplicate 7: android no ios', 'duplicate 7: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 356, 15);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (14, 'duplicate 8: g_p_id_4', 'duplicate 8: android no ios', 'duplicate 8: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 356, 16);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (15, 'duplicate 9: g_p_id_4', 'duplicate 9: android no ios', 'duplicate 9: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 356, 17);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (16, 'duplicate 10: g_p_id_4', 'duplicate 10: android no ios', 'duplicate 10: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 356, 18);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (17, 'duplicate 11: g_p_id_4', 'duplicate 11: android no ios', 'duplicate 11: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 356, 19);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (18, 'duplicate 12: g_p_id_4', 'duplicate 12: android no ios', 'duplicate 12: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 356, 20);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (19, 'duplicate 13: g_p_id_4', 'duplicate 13: android no ios', 'duplicate 13: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 356, 21);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (20, 'duplicate 14: g_p_id_4', 'duplicate 14: android no ios', 'duplicate 14: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 356, 22);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (21, 'duplicate 15: g_p_id_4', 'duplicate 15: android no ios', 'duplicate 15: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 356, 23);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (22, 'duplicate 16: g_p_id_4', 'duplicate 16: android no ios', 'duplicate 16: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 356, 24);
INSERT INTO apps.android_app (app_id, playstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (23, 'duplicate 17: g_p_id_4', 'duplicate 17: android no ios', 'duplicate 17: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'healthatlas', 356, 25);

INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (0, 'g_a_id_1', 'appstore app 1', 'My super first Ios app description :D', 'https://images.pexels.com/photos/1440722/pexels-photo-1440722.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', NULL, 0);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (1, 'g_a_id_2', 'appstore app 2', 'second Ios app description, not so bad...a very long text', 'https://images.pexels.com/photos/1181244/pexels-photo-1181244.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 245, 1);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (2, 'g_a_id_3', 'appstore app 3', 'short description ios', 'https://images.pexels.com/photos/1440727/pexels-photo-1440727.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', NULL, 2);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (3, 'g_a_id_4', 'ios no android', 'IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 1000, 4);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (4, 'duplicate: g_a_id_1', 'duplicate: appstore app 1', 'duplicate: My super first Ios app description :D', 'https://images.pexels.com/photos/1440722/pexels-photo-1440722.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', NULL, 5);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (5, 'duplicate: g_a_id_2', 'duplicate: appstore app 2', 'duplicate: second Ios app description, not so bad...a very long text', 'https://images.pexels.com/photos/1181244/pexels-photo-1181244.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 245, 6);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (6, 'duplicate: g_a_id_3', 'duplicate: appstore app 3', 'duplicate: short description ios', 'https://images.pexels.com/photos/1440727/pexels-photo-1440727.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', NULL, 7);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (7, 'duplicate: g_a_id_4', 'duplicate: ios no android', 'duplicate: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 1000, 9);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (8, 'duplicate 2: g_a_id_4', 'duplicate 2: ios no android', 'duplicate 2: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 1000, 26);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (9, 'duplicate 3: g_a_id_4', 'duplicate 3: ios no android', 'duplicate 3: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 1000, 27);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (10, 'duplicate 4: g_a_id_4', 'duplicate 4: ios no android', 'duplicate 4: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 1000, 28);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (11, 'duplicate 5: g_a_id_4', 'duplicate 5: ios no android', 'duplicate 5: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 1000, 29);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (12, 'duplicate 6: g_a_id_4', 'duplicate 6: ios no android', 'duplicate 6: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 1000, 30);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (13, 'duplicate 7: g_a_id_4', 'duplicate 7: ios no android', 'duplicate 7: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 1000, 31);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (14, 'duplicate 8: g_a_id_4', 'duplicate 8: ios no android', 'duplicate 8: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 1000, 32);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (15, 'duplicate 9: g_a_id_4', 'duplicate 9: ios no android', 'duplicate 9: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 1000, 33);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (16, 'duplicate 10: g_a_id_4', 'duplicate 10: ios no android', 'duplicate 10: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 1000, 34);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (17, 'duplicate 11: g_a_id_4', 'duplicate 11: ios no android', 'duplicate 11: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 1000, 35);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (18, 'duplicate 12: g_a_id_4', 'duplicate 12: ios no android', 'duplicate 12: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 1000, 36);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (19, 'duplicate 13: g_a_id_4', 'duplicate 13: ios no android', 'duplicate 13: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 1000, 37);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (20, 'duplicate 14: g_a_id_4', 'duplicate 14: ios no android', 'duplicate 14: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 1000, 38);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (21, 'duplicate 15: g_a_id_4', 'duplicate 15: ios no android', 'duplicate 15: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 1000, 39);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (22, 'duplicate 16: g_a_id_4', 'duplicate 16: ios no android', 'duplicate 16: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 1000, 40);
INSERT INTO apps.ios_app (app_id, appstore_id, title, description, icon_url, developer, price_in_cent, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (23, 'duplicate 17: g_a_id_4', 'duplicate 17: ios no android', 'duplicate 17: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 1000, 41);

INSERT INTO apps.private_customer_app (app_id, app_source_url, title, description, icon_url, developer, mhealthatlas_app_id) OVERRIDING SYSTEM VALUE VALUES (0, 'test url', 'private customer app 1', 'My super first private customer app description :D', 'https://images.pexels.com/photos/1440722/pexels-photo-1440722.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200', 'developer', 42);

INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (0, '1.0', '4.1', 3, '2020-07-07 09:39:27', 'first release', '2020-07-07 09:39:37', false, 0); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (0, '1.0', '4.1', 3, '2020-07-07 09:39:27', 'first release', '2020-07-07 09:39:37', false, 0, 8, 2, 2, 2, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (1, '2.0', '3.1', 16, '2020-07-07 09:49:27', 'bad change', '2020-07-07 09:59:37', true, 0); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (1, '2.0', '3.1', 16, '2020-07-07 09:49:27', 'bad change', '2020-07-07 09:59:37', true, 0, 6, 2, 1, 1, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (2, '1.0', '3.1', 16, '2020-07-07 09:49:27', 'first release', '2020-07-07 09:59:37', true, 1); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (2, '1.0', '3.1', 16, '2020-07-07 09:49:27', 'first release', '2020-07-07 09:59:37', true, 1, 0, 0, 0, 0, 0);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (3, '1.0', '3.1', 16, '2020-07-07 09:49:27', 'first release x_d', '2020-07-07 09:59:37', false, 2); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (3, '1.0', '3.1', 16, '2020-07-07 09:49:27', 'first release x_d', '2020-07-07 09:59:37', false, 2, 0, 0, 0, 0, 0);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (4, '2.0', '5.0', 100, '2020-06-07 09:49:27', 'good change', '2020-07-07 09:59:37', true, 2); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (4, '2.0', '5.0', 100, '2020-06-07 09:49:27', 'good change', '2020-07-07 09:59:37', true, 2, 0, 0, 0, 0, 0);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (5, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 3); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (5, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 3, 7, 1, 3, 1, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (6, '1.0', '4.1', 3, '2020-07-07 09:39:27', 'first release', '2020-07-07 09:39:37', false, 4); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (6, '1.0', '4.1', 3, '2020-07-07 09:39:27', 'first release', '2020-07-07 09:39:37', false, 4, 8, 2, 2, 2, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (7, '2.0', '3.1', 16, '2020-07-07 09:49:27', 'bad change', '2020-07-07 09:59:37', true, 4); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (7, '2.0', '3.1', 16, '2020-07-07 09:49:27', 'bad change', '2020-07-07 09:59:37', true, 4, 6, 2, 1, 1, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (8, '1.0', '3.1', 16, '2020-07-07 09:49:27', 'first release', '2020-07-07 09:59:37', true, 5); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (8, '1.0', '3.1', 16, '2020-07-07 09:49:27', 'first release', '2020-07-07 09:59:37', true, 5, 0, 0, 0, 0, 0);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (9, '1.0', '3.1', 16, '2020-07-07 09:49:27', 'first release x_d', '2020-07-07 09:59:37', false, 6); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (9, '1.0', '3.1', 16, '2020-07-07 09:49:27', 'first release x_d', '2020-07-07 09:59:37', false, 6, 0, 0, 0, 0, 0);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (10, '2.0', '5.0', 100, '2020-06-07 09:49:27', 'good change', '2020-07-07 09:59:37', true, 6); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (10, '2.0', '5.0', 100, '2020-06-07 09:49:27', 'good change', '2020-07-07 09:59:37', true, 6, 0, 0, 0, 0, 0);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (11, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 7); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (11, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 7, 7, 1, 3, 1, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (12, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 8); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (12, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 8, 7, 1, 3, 1, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (13, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 9); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (13, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 9, 7, 1, 3, 1, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (14, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 10); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (14, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 10, 7, 1, 3, 1, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (15, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 11); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (15, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 11, 7, 1, 3, 1, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (16, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 12); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (16, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 12, 7, 1, 3, 1, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (17, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 13); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (17, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 13, 7, 1, 3, 1, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (18, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 14); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (18, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 14, 7, 1, 3, 1, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (19, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 15); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (19, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 15, 7, 1, 3, 1, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (20, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 16); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (20, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 16, 7, 1, 3, 1, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (21, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 17); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (21, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 17, 7, 1, 3, 1, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (22, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 18); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (22, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 18, 7, 1, 3, 1, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (23, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 19); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (23, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 19, 7, 1, 3, 1, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (24, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 20); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (24, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 20, 7, 1, 3, 1, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (25, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 21); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (25, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 21, 7, 1, 3, 1, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (26, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 22); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (26, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 22, 7, 1, 3, 1, 2);
INSERT INTO apps.android_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, android_app_id) OVERRIDING SYSTEM VALUE VALUES (27, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 23); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (27, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 23, 7, 1, 3, 1, 2);

INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (0, '1.0', '2.2', 2, '2020-07-07 09:39:27', 'first ios release', '2020-07-07 09:39:28', false, 0); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (0, '1.0', '2.2', 2, '2020-07-07 09:39:27', 'first ios release', '2020-07-07 09:39:28', false, 0, 4, 2, 1, 0, 1);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (1, '2.0', '3.2', 56, '2020-07-07 10:39:27', 'make ios great again', '2020-07-07 11:39:28', true, 0); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (1, '2.0', '3.2', 56, '2020-07-07 10:39:27', 'make ios great again', '2020-07-07 11:39:28', true, 0, 6, 2, 1, 1, 2);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (2, '1.0', '4.4', 54, '2020-07-06 09:39:27', 'release party', '2020-07-06 09:39:28', false, 1); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (2, '1.0', '4.4', 54, '2020-07-06 09:39:27', 'release party', '2020-07-06 09:39:28', false, 1, 0, 0, 0, 0, 0);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (3, '2.0', '4.6', 2, '2020-07-08 09:39:27', 'buf fixes', '2020-07-08 09:39:28', true, 1); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (3, '2.0', '4.6', 2, '2020-07-08 09:39:27', 'buf fixes', '2020-07-08 09:39:28', true, 1, 0, 0, 0, 0, 0);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (4, '1.0', '1.2', 32, '2020-07-07 09:39:27', 'ios auto generated app', '2020-07-07 09:39:28', true, 2); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (4, '1.0', '1.2', 32, '2020-07-07 09:39:27', 'ios auto generated app', '2020-07-07 09:39:28', true, 2, 0, 0, 0, 0, 0);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (5, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 3); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (5, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 3, 9, 2, 3, 2, 2);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (6, '1.0', '2.2', 2, '2020-07-07 09:39:27', 'first ios release', '2020-07-07 09:39:28', false, 4); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (6, '1.0', '2.2', 2, '2020-07-07 09:39:27', 'first ios release', '2020-07-07 09:39:28', false, 4, 4, 2, 1, 0, 1);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (7, '2.0', '3.2', 56, '2020-07-07 10:39:27', 'make ios great again', '2020-07-07 11:39:28', true, 4); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (7, '2.0', '3.2', 56, '2020-07-07 10:39:27', 'make ios great again', '2020-07-07 11:39:28', true, 4, 6, 2, 1, 1, 2);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (8, '1.0', '4.4', 54, '2020-07-06 09:39:27', 'release party', '2020-07-06 09:39:28', false, 5); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (8, '1.0', '4.4', 54, '2020-07-06 09:39:27', 'release party', '2020-07-06 09:39:28', false, 5, 0, 0, 0, 0, 0);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (9, '2.0', '4.6', 2, '2020-07-08 09:39:27', 'buf fixes', '2020-07-08 09:39:28', true, 5); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (9, '2.0', '4.6', 2, '2020-07-08 09:39:27', 'buf fixes', '2020-07-08 09:39:28', true, 5, 0, 0, 0, 0, 0);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (10, '1.0', '1.2', 32, '2020-07-07 09:39:27', 'ios auto generated app', '2020-07-07 09:39:28', true, 6); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (10, '1.0', '1.2', 32, '2020-07-07 09:39:27', 'ios auto generated app', '2020-07-07 09:39:28', true, 6, 0, 0, 0, 0, 0);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (11, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 7); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (11, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 7, 9, 2, 3, 2, 2);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (12, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 8); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (12, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 8, 9, 2, 3, 2, 2);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (13, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 9); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (13, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 9, 9, 2, 3, 2, 2);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (14, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 10); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (14, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 10, 9, 2, 3, 2, 2);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (15, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 11); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (15, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 11, 9, 2, 3, 2, 2);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (16, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 12); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (16, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 12, 9, 2, 3, 2, 2);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (17, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 13); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (17, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 13, 9, 2, 3, 2, 2);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (18, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 14); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (18, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 14, 9, 2, 3, 2, 2);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (19, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 15); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (19, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 15, 9, 2, 3, 2, 2);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (20, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 16); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (20, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 16, 9, 2, 3, 2, 2);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (21, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 17); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (21, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 17, 9, 2, 3, 2, 2);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (22, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 18); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (22, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 18, 9, 2, 3, 2, 2);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (23, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 19); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (23, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 19, 9, 2, 3, 2, 2);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (24, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 20); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (24, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 20, 9, 2, 3, 2, 2);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (25, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 21); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (25, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 21, 9, 2, 3, 2, 2);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (26, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 22); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (26, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 22, 9, 2, 3, 2, 2);
INSERT INTO apps.ios_app_version (app_version_id, version, score, review_count, release_date, recent_changes, last_access, is_latest_version, ios_app_id) OVERRIDING SYSTEM VALUE VALUES (27, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 23); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (27, '1.0', '3.5', 23, '2020-07-07 09:39:27', 'test app', '2020-07-07 09:39:27', true, 23, 9, 2, 3, 2, 2);

INSERT INTO apps.private_customer_app_version (app_version_id, version, release_date, recent_changes, last_access, is_latest_version, private_customer_app_id) OVERRIDING SYSTEM VALUE VALUES (0, '0.1', '2020-07-07 09:39:27', 'first test release', '2020-07-07 09:39:28', true, 0); --, total_score, content_score, usability_score, security_score, law_score) OVERRIDING SYSTEM VALUE VALUES (0, '0.1', '2020-07-07 09:39:27', 'first test release', '2020-07-07 09:39:28', true, 0, 0, 0, 0, 0, 0);

-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (0, 0, NULL, 0);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (1, 0, NULL, 2);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (2, 0, NULL, 5);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (3, 0, NULL, 6);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (4, 0, NULL, 22);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (5, 0, NULL, 24);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (6, 0, NULL, 29);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (7, 0, NULL, 31);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (8, 0, NULL, 32);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (9, 1, NULL, 0);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (10, 1, NULL, 2);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (11, 1, NULL, 3);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (12, 1, NULL, 5);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (13, 1, NULL, 6);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (14, 1, NULL, 22);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (15, 1, NULL, 24);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (16, 1, NULL, 29);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (17, 1, NULL, 31);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (18, 1, NULL, 32);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (19, 5, NULL, 1);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (20, NULL, 0, 0);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (21, NULL, 0, 2);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (22, NULL, 0, 5);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (23, NULL, 0, 6);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (24, NULL, 0, 22);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (25, NULL, 0, 24);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (26, NULL, 0, 29);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (27, NULL, 0, 31);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (28, NULL, 0, 32);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (29, NULL, 1, 0);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (30, NULL, 1, 2);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (31, NULL, 1, 3);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (32, NULL, 1, 5);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (33, NULL, 1, 6);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (34, NULL, 1, 22);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (35, NULL, 1, 24);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (36, NULL, 1, 29);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (37, NULL, 1, 31);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (38, NULL, 1, 32);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (39, NULL, 5, 0);
-- INSERT INTO apps.app_version_category (id, android_version_id, ios_version_id, category_id) OVERRIDING SYSTEM VALUE VALUES (40, NULL, 5, 4);


SELECT pg_catalog.setval('apps.android_app_app_id_seq', 23, true);
SELECT pg_catalog.setval('apps.android_app_version_app_version_id_seq', 27, true);
SELECT pg_catalog.setval('apps.ios_app_app_id_seq', 23, true);
SELECT pg_catalog.setval('apps.ios_app_version_app_version_id_seq', 27, true);
SELECT pg_catalog.setval('apps.private_customer_app_app_id_seq', 1, true);
SELECT pg_catalog.setval('apps.private_customer_app_version_app_version_id_seq', 1, true);
SELECT pg_catalog.setval('apps.mhealthatlas_app_app_id_seq', 42, true);
-- SELECT pg_catalog.setval('apps.app_version_category_id_seq', 40, true);
