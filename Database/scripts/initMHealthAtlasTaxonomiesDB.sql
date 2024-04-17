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

CREATE SCHEMA taxonomies;


SET default_table_access_method = heap;


CREATE TYPE taxonomies.application_type AS ENUM ('Android', 'Ios', 'Private');


CREATE TABLE taxonomies.layer (
    layer_id integer NOT NULL PRIMARY KEY,
    name text NOT NULL UNIQUE,
    min_selected_categories integer NOT NULL,
    max_selected_categories integer NOT NULL
);

ALTER TABLE taxonomies.layer ALTER COLUMN layer_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME taxonomies.layer_layer_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);


CREATE TABLE taxonomies.category (
    category_id integer NOT NULL PRIMARY KEY,
    name text NOT NULL UNIQUE,
    abbreviation text NOT NULL UNIQUE,
    layer_id integer NOT NULL,
    is_terminate_node boolean NOT NULL
);


ALTER TABLE taxonomies.category ALTER COLUMN category_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME taxonomies.category_category_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY taxonomies.category
    ADD CONSTRAINT category_layer_id_fkey FOREIGN KEY (layer_id) REFERENCES taxonomies.layer(layer_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE taxonomies.class (
    class_id integer NOT NULL PRIMARY KEY,
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

ALTER TABLE taxonomies.class ALTER COLUMN class_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME taxonomies.class_class_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY taxonomies.class
    ADD CONSTRAINT class_layer0_category_id_fkey FOREIGN KEY (layer0_category_id) REFERENCES taxonomies.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY taxonomies.class
    ADD CONSTRAINT class_layer1_category_id_fkey FOREIGN KEY (layer1_category_id) REFERENCES taxonomies.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY taxonomies.class
    ADD CONSTRAINT class_layer2_category_id_fkey FOREIGN KEY (layer2_category_id) REFERENCES taxonomies.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY taxonomies.class
    ADD CONSTRAINT class_layer3_category_id_fkey FOREIGN KEY (layer3_category_id) REFERENCES taxonomies.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY taxonomies.class
    ADD CONSTRAINT class_layer4_category_id_fkey FOREIGN KEY (layer4_category_id) REFERENCES taxonomies.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY taxonomies.class
    ADD CONSTRAINT class_layer5_category_id_fkey FOREIGN KEY (layer5_category_id) REFERENCES taxonomies.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY taxonomies.class
    ADD CONSTRAINT class_layer6_category_id_fkey FOREIGN KEY (layer6_category_id) REFERENCES taxonomies.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY taxonomies.class
    ADD CONSTRAINT class_layer7_category_id_fkey FOREIGN KEY (layer7_category_id) REFERENCES taxonomies.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE taxonomies.app_version (
    id integer NOT NULL PRIMARY KEY,
    app_version_id integer NOT NULL,
    app_id integer NOT NULL,
    app_type taxonomies.application_type NOT NULL,
    app_source_url text NOT NULL,
    version text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    recent_changes text,
    icon_url text,
    UNIQUE (app_version_id, app_type)
);

ALTER TABLE taxonomies.app_version ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME taxonomies.app_version_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);


CREATE TABLE taxonomies.app_taxonomy (
    app_taxonomy_id integer NOT NULL PRIMARY KEY,
    app_version_id integer NOT NULL,
    class_id integer NOT NULL,
    UNIQUE(app_version_id, class_id)
);

ALTER TABLE taxonomies.app_taxonomy ALTER COLUMN app_taxonomy_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME taxonomies.app_taxonomy_app_taxonomy_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY taxonomies.app_taxonomy
    ADD CONSTRAINT app_taxonomy_class_id_fkey FOREIGN KEY (class_id) REFERENCES taxonomies.class(class_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY taxonomies.app_taxonomy
    ADD CONSTRAINT app_taxonomy_app_version_id_fkey FOREIGN KEY (app_version_id) REFERENCES taxonomies.app_version(id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE taxonomies.outbox (
    event_id UUID NOT NULL PRIMARY KEY,
    version integer NOT NULL,
    root_aggregate_type text NOT NULL,
    root_aggregate_id text NOT NULL,
    aggregate_type text NOT NULL,
    aggregate_id text NOT NULL,
    event_type text NOT NULL,
    payload text NOT NULL
);

ALTER TABLE taxonomies.outbox OWNER TO postgres;


insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(0, 0, 'Android', 'g_p_id_1', '1.0', 'a app 1', 'My super first Android app description :D', 'first release', 'https://images.pexels.com/photos/1440722/pexels-photo-1440722.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(1, 0, 'Android', 'g_p_id_1', '2.0', 'a app 1', 'My super first Android app description :D', 'bad change', 'https://images.pexels.com/photos/1440722/pexels-photo-1440722.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(2, 1, 'Android', 'g_p_id_2', '1.0', 'a app 2', 'second Android app description, not so bad...a very long text', 'first release', 'https://images.pexels.com/photos/1181244/pexels-photo-1181244.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(3, 2, 'Android', 'g_p_id_3', '1.0', 'a app 3', 'short description android', 'first release x_d', 'https://images.pexels.com/photos/1440727/pexels-photo-1440727.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(4, 2, 'Android', 'g_p_id_3', '2.0', 'a app 3', 'short description android', 'good change', 'https://images.pexels.com/photos/1440727/pexels-photo-1440727.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(5, 3, 'Android', 'g_p_id_4', '1.0', 'android no ios', 'ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(6, 4, 'Android', 'duplicate: g_p_id_1', '1.0', 'duplicate: a app 1', 'duplicate: My super first Android app description :D', 'first release', 'https://images.pexels.com/photos/1440722/pexels-photo-1440722.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(7, 4, 'Android', 'duplicate: g_p_id_1', '2.0', 'duplicate: a app 1', 'duplicate: My super first Android app description :D', 'bad change', 'https://images.pexels.com/photos/1440722/pexels-photo-1440722.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(8, 5, 'Android', 'duplicate: g_p_id_2', '1.0', 'duplicate: a app 2', 'duplicate: second Android app description, not so bad...a very long text', 'first release', 'https://images.pexels.com/photos/1181244/pexels-photo-1181244.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(9, 6, 'Android', 'duplicate: g_p_id_3', '1.0', 'duplicate: a app 3', 'duplicate: short description android', 'first release x_d', 'https://images.pexels.com/photos/1440727/pexels-photo-1440727.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(10, 6, 'Android', 'duplicate: g_p_id_3', '2.0', 'duplicate: a app 3', 'duplicate: short description android', 'good change', 'https://images.pexels.com/photos/1440727/pexels-photo-1440727.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(11, 7, 'Android', 'duplicate: g_p_id_4', '1.0', 'duplicate: android no ios', 'duplicate: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(12, 8, 'Android', 'duplicate 2: g_p_id_4', '1.0', 'duplicate 2: android no ios', 'duplicate 2: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(13, 9, 'Android', 'duplicate 3: g_p_id_4', '1.0', 'duplicate 3: android no ios', 'duplicate 3: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(14, 10, 'Android', 'duplicate 4: g_p_id_4', '1.0', 'duplicate 4: android no ios', 'duplicate 4: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(15, 11, 'Android', 'duplicate 5: g_p_id_4', '1.0', 'duplicate 5: android no ios', 'duplicate 5: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(16, 12, 'Android', 'duplicate 6: g_p_id_4', '1.0', 'duplicate 6: android no ios', 'duplicate 6: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(17, 13, 'Android', 'duplicate 7: g_p_id_4', '1.0', 'duplicate 7: android no ios', 'duplicate 7: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(18, 14, 'Android', 'duplicate 8: g_p_id_4', '1.0', 'duplicate 8: android no ios', 'duplicate 8: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(19, 15, 'Android', 'duplicate 9: g_p_id_4', '1.0', 'duplicate 9: android no ios', 'duplicate 9: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(20, 16, 'Android', 'duplicate 10: g_p_id_4', '1.0', 'duplicate 10: android no ios', 'duplicate 10: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(21, 17, 'Android', 'duplicate 11: g_p_id_4', '1.0', 'duplicate 11: android no ios', 'duplicate 11: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(22, 18, 'Android', 'duplicate 12: g_p_id_4', '1.0', 'duplicate 12: android no ios', 'duplicate 12: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(23, 19, 'Android', 'duplicate 13: g_p_id_4', '1.0', 'duplicate 13: android no ios', 'duplicate 13: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(24, 20, 'Android', 'duplicate 14: g_p_id_4', '1.0', 'duplicate 14: android no ios', 'duplicate 14: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(25, 21, 'Android', 'duplicate 15: g_p_id_4', '1.0', 'duplicate 15: android no ios', 'duplicate 15: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(26, 22, 'Android', 'duplicate 16: g_p_id_4', '1.0', 'duplicate 16: android no ios', 'duplicate 16: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(27, 23, 'Android', 'duplicate 17: g_p_id_4', '1.0', 'duplicate 17: android no ios', 'duplicate 17: ANDROID: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/50614/pexels-photo-50614.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');

insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(0, 0, 'Ios', 'g_a_id_1', '1.0', 'appstore app 1', 'My super first Ios app description :D', 'first ios release', 'https://images.pexels.com/photos/1440722/pexels-photo-1440722.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(1, 0, 'Ios', 'g_a_id_1', '2.0', 'appstore app 1', 'My super first Ios app description :D', 'make ios great again', 'https://images.pexels.com/photos/1440722/pexels-photo-1440722.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(2, 1, 'Ios', 'g_a_id_2', '1.0', 'appstore app 2', 'second Ios app description, not so bad...a very long text', 'release party', 'https://images.pexels.com/photos/1181244/pexels-photo-1181244.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(3, 1, 'Ios', 'g_a_id_2', '2.0', 'appstore app 2', 'second Ios app description, not so bad...a very long text', 'buf fixes', 'https://images.pexels.com/photos/1181244/pexels-photo-1181244.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(4, 2, 'Ios', 'g_a_id_3', '1.0', 'appstore app 3', 'short description ios', 'ios auto generated app', 'https://images.pexels.com/photos/1440727/pexels-photo-1440727.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(5, 3, 'Ios', 'g_a_id_4', '1.0', 'ios no android', 'IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(6, 4, 'Ios', 'duplicate: g_a_id_1', '1.0', 'duplicate: appstore app 1', 'duplicate: My super first Ios app description :D', 'first ios release', 'https://images.pexels.com/photos/1440722/pexels-photo-1440722.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(7, 4, 'Ios', 'duplicate: g_a_id_1', '2.0', 'duplicate: appstore app 1', 'duplicate: My super first Ios app description :D', 'make ios great again', 'https://images.pexels.com/photos/1440722/pexels-photo-1440722.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(8, 5, 'Ios', 'duplicate: g_a_id_2', '1.0', 'duplicate: appstore app 2', 'duplicate: second Ios app description, not so bad...a very long text', 'release party', 'https://images.pexels.com/photos/1181244/pexels-photo-1181244.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(9, 5, 'Ios', 'duplicate: g_a_id_2', '2.0', 'duplicate: appstore app 2', 'duplicate: second Ios app description, not so bad...a very long text', 'buf fixes', 'https://images.pexels.com/photos/1181244/pexels-photo-1181244.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(10, 6, 'Ios', 'duplicate: g_a_id_3', '1.0', 'duplicate: appstore app 3', 'duplicate: short description ios', 'ios auto generated app', 'https://images.pexels.com/photos/1440727/pexels-photo-1440727.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(11, 7, 'Ios', 'duplicate: g_a_id_4', '1.0', 'duplicate: ios no android', 'duplicate: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(12, 8, 'Ios', 'duplicate 2: g_a_id_4', '1.0', 'duplicate 2: ios no android', 'duplicate 2: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(13, 9, 'Ios', 'duplicate 3: g_a_id_4', '1.0', 'duplicate 3: ios no android', 'duplicate 3: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(14, 10, 'Ios', 'duplicate 4: g_a_id_4', '1.0', 'duplicate 4: ios no android', 'duplicate 4: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(15, 11, 'Ios', 'duplicate 5: g_a_id_4', '1.0', 'duplicate 5: ios no android', 'duplicate 5: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(16, 12, 'Ios', 'duplicate 6: g_a_id_4', '1.0', 'duplicate 6: ios no android', 'duplicate 6: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(17, 13, 'Ios', 'duplicate 7: g_a_id_4', '1.0', 'duplicate 7: ios no android', 'duplicate 7: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(18, 14, 'Ios', 'duplicate 8: g_a_id_4', '1.0', 'duplicate 8: ios no android', 'duplicate 8: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(19, 15, 'Ios', 'duplicate 9: g_a_id_4', '1.0', 'duplicate 9: ios no android', 'duplicate 9: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(20, 16, 'Ios', 'duplicate 10: g_a_id_4', '1.0', 'duplicate 10: ios no android', 'duplicate 10: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(21, 17, 'Ios', 'duplicate 11: g_a_id_4', '1.0', 'duplicate 11: ios no android', 'duplicate 11: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(22, 18, 'Ios', 'duplicate 12: g_a_id_4', '1.0', 'duplicate 12: ios no android', 'duplicate 12: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(23, 19, 'Ios', 'duplicate 13: g_a_id_4', '1.0', 'duplicate 13: ios no android', 'duplicate 13: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(24, 20, 'Ios', 'duplicate 14: g_a_id_4', '1.0', 'duplicate 14: ios no android', 'duplicate 14: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(25, 21, 'Ios', 'duplicate 15: g_a_id_4', '1.0', 'duplicate 15: ios no android', 'duplicate 15: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(26, 22, 'Ios', 'duplicate 16: g_a_id_4', '1.0', 'duplicate 16: ios no android', 'duplicate 16: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');
insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(27, 23, 'Ios', 'duplicate 17: g_a_id_4', '1.0', 'duplicate 17: ios no android', 'duplicate 17: IOS: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', 'test app', 'https://images.pexels.com/photos/38544/imac-apple-mockup-app-38544.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');

insert into taxonomies.app_version(app_version_id, app_id, app_type, app_source_url, version, title, description, recent_changes, icon_url) VALUES(0, 0, 'Private', 'test url', '0.1', 'private customer app 1', 'My super first private customer app description :D', 'first test release', 'https://images.pexels.com/photos/1440722/pexels-photo-1440722.jpeg?auto=compress&cs=tinysrgb&dpr=1&h=200');

INSERT INTO taxonomies.layer OVERRIDING SYSTEM VALUE VALUES (0, 'Pre-selection', 1, 1);
INSERT INTO taxonomies.layer OVERRIDING SYSTEM VALUE VALUES (1, 'Purpose of Use', 1, 3);
INSERT INTO taxonomies.layer OVERRIDING SYSTEM VALUE VALUES (2, 'Application Area', 1, 17);
INSERT INTO taxonomies.layer OVERRIDING SYSTEM VALUE VALUES (3, 'Expertise', 1, 1);
INSERT INTO taxonomies.layer OVERRIDING SYSTEM VALUE VALUES (4, 'Med. Application', 1, 4);
INSERT INTO taxonomies.layer OVERRIDING SYSTEM VALUE VALUES (5, 'Term of Application', 1, 1);
INSERT INTO taxonomies.layer OVERRIDING SYSTEM VALUE VALUES (6, 'Operation Mode', 1, 1);
INSERT INTO taxonomies.layer OVERRIDING SYSTEM VALUE VALUES (7, 'Accessibility', 1, 1);


INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (0, 'Medical', 'MDL', 0, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (1, 'Non-medical', 'NMD', 0, true);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (2, 'Medical Care', 'MED', 1, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (3, 'Education', 'EDU', 1, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (4, 'Administration', 'ADM', 1, true);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (5, 'Nervous System: Central nervous system, peripheral nervous system', 'NRV', 2, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (6, 'Eyes', 'EYE', 2, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (7, 'Ears', 'EAR', 2, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (8, 'Throat', 'THR', 2, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (9, 'Nose', 'NOS', 2, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (10, 'Mouth', 'MTH', 2, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (11, 'Voice', 'VOI', 2, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (12, 'Cardiovascular System', 'CVS', 2, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (13, 'Immune System', 'IMS', 2, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (14, 'Respiratory System', 'RES', 2, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (15, 'Digestive Organs', 'DIG', 2, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (16, 'Skin and skin appendages', 'SKN', 2, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (17, 'Endocrine Organs', 'ENC', 2, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (18, 'Urogenital and Reproductive System', 'SEX', 2, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (19, 'Psyche', 'PSY', 2, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (20, 'Nutrition', 'NUT', 2, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (21, 'Movement', 'MOV', 2, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (22, 'Amateur', 'AMA', 3, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (23, 'Medical Professional', 'PRO', 3, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (24, 'Diagnosis', 'DIA', 4, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (25, 'Treatment', 'TRE', 4, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (26, 'Diseases Management', 'DMA', 4, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (27, 'Prevention', 'PRE', 4, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (28, 'Chronic Use', 'CHU', 5, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (29, 'Non-chronic Use', 'NCU', 5, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (30, 'Standalone Product', 'SAP', 6, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (31, 'System Product', 'SYS', 6, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (32, 'Prescription', 'RXP', 7, false);
INSERT INTO taxonomies.category OVERRIDING SYSTEM VALUE VALUES (33, 'Open', 'OPN', 7, false);

SELECT pg_catalog.setval('taxonomies.category_category_id_seq', 33, true);
SELECT pg_catalog.setval('taxonomies.layer_layer_id_seq', 7, true);
