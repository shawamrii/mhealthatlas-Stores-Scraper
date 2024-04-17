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

CREATE SCHEMA aqe_mapping;


SET default_table_access_method = heap;

CREATE TYPE aqe_mapping.application_type AS ENUM ('Android', 'Ios', 'Private');

CREATE TABLE aqe_mapping.discipline (
    discipline_id integer NOT NULL PRIMARY KEY
);

CREATE TABLE aqe_mapping.questionnaire (
    questionnaire_id integer NOT NULL PRIMARY KEY,
    is_valid boolean NOT NULL
);

CREATE TABLE aqe_mapping.question (
    question_id integer NOT NULL PRIMARY KEY,
    questionnaire_id integer NOT NULL,
    discipline_id integer NOT NULL
);

ALTER TABLE ONLY aqe_mapping.question
    ADD CONSTRAINT question_discipline_id_fkey FOREIGN KEY (discipline_id) REFERENCES aqe_mapping.discipline(discipline_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY aqe_mapping.question
    ADD CONSTRAINT question_questionnaire_id_fkey FOREIGN KEY (questionnaire_id) REFERENCES aqe_mapping.questionnaire(questionnaire_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE aqe_mapping.expert (
    expert_id UUID NOT NULL PRIMARY KEY
);


CREATE TABLE aqe_mapping.specialization (
    specialization_id integer NOT NULL PRIMARY KEY,
    discipline_id integer NOT NULL
);

ALTER TABLE ONLY aqe_mapping.specialization
    ADD CONSTRAINT specialization_discipline_id_fkey FOREIGN KEY (discipline_id) REFERENCES aqe_mapping.discipline(discipline_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE aqe_mapping.category (
    category_id integer NOT NULL PRIMARY KEY,
    priority integer,
    level_id integer NOT NULL,
    is_terminate_node boolean NOT NULL
);


CREATE TABLE aqe_mapping.taxonomy_class (
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

ALTER TABLE aqe_mapping.taxonomy_class ALTER COLUMN taxonomy_class_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aqe_mapping.taxonomy_class_taxonomy_class_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY aqe_mapping.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer0_category_id_fkey FOREIGN KEY (layer0_category_id) REFERENCES aqe_mapping.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY aqe_mapping.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer1_category_id_fkey FOREIGN KEY (layer1_category_id) REFERENCES aqe_mapping.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY aqe_mapping.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer2_category_id_fkey FOREIGN KEY (layer2_category_id) REFERENCES aqe_mapping.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY aqe_mapping.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer3_category_id_fkey FOREIGN KEY (layer3_category_id) REFERENCES aqe_mapping.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY aqe_mapping.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer4_category_id_fkey FOREIGN KEY (layer4_category_id) REFERENCES aqe_mapping.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY aqe_mapping.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer5_category_id_fkey FOREIGN KEY (layer5_category_id) REFERENCES aqe_mapping.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY aqe_mapping.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer6_category_id_fkey FOREIGN KEY (layer6_category_id) REFERENCES aqe_mapping.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY aqe_mapping.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer7_category_id_fkey FOREIGN KEY (layer7_category_id) REFERENCES aqe_mapping.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE aqe_mapping.application_version (
    id integer NOT NULL PRIMARY KEY,
    application_version_id integer NOT NULL,
    application_id integer NOT NULL,
    application_type aqe_mapping.application_type NOT NULL,
    is_payed boolean,
    UNIQUE(application_version_id, application_type)
);

ALTER TABLE aqe_mapping.application_version ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aqe_mapping.application_version_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);


CREATE TABLE aqe_mapping.questionnaire_taxonomy_class (
    id integer NOT NULL PRIMARY KEY,
    questionnaire_id integer NOT NULL,
    taxonomy_class_id integer NOT NULL,
    UNIQUE(questionnaire_id, taxonomy_class_id)
);

ALTER TABLE aqe_mapping.questionnaire_taxonomy_class ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aqe_mapping.questionnaire_taxonomy_class_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY aqe_mapping.questionnaire_taxonomy_class
    ADD CONSTRAINT questionnaire_taxonomy_class_questionnaire_id_fkey FOREIGN KEY (questionnaire_id) REFERENCES aqe_mapping.questionnaire(questionnaire_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY aqe_mapping.questionnaire_taxonomy_class
    ADD CONSTRAINT questionnaire_taxonomy_class_taxonomy_class_id_fkey FOREIGN KEY (taxonomy_class_id) REFERENCES aqe_mapping.taxonomy_class(taxonomy_class_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE aqe_mapping.category_specialization (
    id integer NOT NULL PRIMARY KEY,
    category_id integer NOT NULL,
    specialization_id integer,
    UNIQUE(category_id, specialization_id)
);

ALTER TABLE aqe_mapping.category_specialization ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aqe_mapping.category_specialization_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY aqe_mapping.category_specialization
    ADD CONSTRAINT category_specialization_category_id_fkey FOREIGN KEY (category_id) REFERENCES aqe_mapping.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY aqe_mapping.category_specialization
    ADD CONSTRAINT category_specialization_specialization_id_fkey FOREIGN KEY (specialization_id) REFERENCES aqe_mapping.specialization(specialization_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE aqe_mapping.expert_specialization (
    id integer NOT NULL PRIMARY KEY,
    expert_id uuid NOT NULL,
    specialization_id integer NOT NULL,
    UNIQUE(expert_id, specialization_id)
);

ALTER TABLE aqe_mapping.expert_specialization ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aqe_mapping.expert_specialization_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY aqe_mapping.expert_specialization
    ADD CONSTRAINT expert_specialization_expert_id_fkey FOREIGN KEY (expert_id) REFERENCES aqe_mapping.expert(expert_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY aqe_mapping.expert_specialization
    ADD CONSTRAINT expert_specialization_specialization_id_fkey FOREIGN KEY (specialization_id) REFERENCES aqe_mapping.specialization(specialization_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE aqe_mapping.application_taxonomy_class (
    id integer NOT NULL PRIMARY KEY,
    application_version_id integer NOT NULL,
    taxonomy_class_id integer NOT NULL,
    UNIQUE(application_version_id, taxonomy_class_id)
);

ALTER TABLE aqe_mapping.application_taxonomy_class ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aqe_mapping.application_taxonomy_class_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY aqe_mapping.application_taxonomy_class
    ADD CONSTRAINT application_taxonomy_class_application_version_id_fkey FOREIGN KEY (application_version_id) REFERENCES aqe_mapping.application_version(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY aqe_mapping.application_taxonomy_class
    ADD CONSTRAINT application_taxonomy_class_taxonomy_class_id_fkey FOREIGN KEY (taxonomy_class_id) REFERENCES aqe_mapping.taxonomy_class(taxonomy_class_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE aqe_mapping.application_question_expert (
    id integer NOT NULL PRIMARY KEY,
    application_taxonomy_class_id integer NOT NULL,
    question_id integer NOT NULL,
    expert_id uuid NOT NULL,
    rating_pending boolean NOT NULL,
    UNIQUE(application_taxonomy_class_id, question_id, expert_id)
);

ALTER TABLE aqe_mapping.application_question_expert ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aqe_mapping.application_question_expert_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY aqe_mapping.application_question_expert
    ADD CONSTRAINT application_question_expert_application_taxonomy_class_id_fkey FOREIGN KEY (application_taxonomy_class_id) REFERENCES aqe_mapping.application_taxonomy_class(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY aqe_mapping.application_question_expert
    ADD CONSTRAINT application_question_expert_question_id_fkey FOREIGN KEY (question_id) REFERENCES aqe_mapping.question(question_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY aqe_mapping.application_question_expert
    ADD CONSTRAINT application_question_expert_expert_id_fkey FOREIGN KEY (expert_id) REFERENCES aqe_mapping.expert(expert_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE aqe_mapping.outbox (
    event_id UUID NOT NULL PRIMARY KEY,
    version integer NOT NULL,
    root_aggregate_type text NOT NULL,
    root_aggregate_id text NOT NULL,
    aggregate_type text NOT NULL,
    aggregate_id text NOT NULL,
    event_type text NOT NULL,
    payload text NOT NULL
);

ALTER TABLE aqe_mapping.outbox OWNER TO postgres;


INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (0, 0, 'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (1, 0, 'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (2, 1, 'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (3, 2, 'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (4, 2, 'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (5, 3, 'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (6, 4, 'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (7, 4, 'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (8, 5, 'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (9, 6, 'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (10, 6, 'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (11, 7, 'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (12, 8, 'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (13, 9, 'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (14, 10,'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (15, 11,'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (16, 12,'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (17, 13,'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (18, 14,'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (19, 15,'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (20, 16,'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (21, 17,'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (22, 18,'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (23, 19,'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (24, 20,'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (25, 21,'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (26, 22,'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (27, 23,'Android', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (0, 0, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (1, 0, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (2, 1, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (3, 1, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (4, 2, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (5, 3, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (6, 4, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (7, 4, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (8, 5, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (9, 5, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (10,6, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (11, 7, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (12, 8, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (13, 9, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (14, 10, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (15, 11, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (16, 12, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (17, 13, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (18, 14, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (19, 15, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (20, 16, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (21, 17, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (22, 18, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (23, 19, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (24, 20, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (25, 21, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (26, 22, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (27, 23, 'Ios', false);
INSERT INTO aqe_mapping.application_version (application_version_id, application_id, application_type, is_payed) VALUES (0, 0, 'Private', false);



INSERT INTO aqe_mapping.discipline (discipline_id) VALUES (0); --content
INSERT INTO aqe_mapping.discipline (discipline_id) VALUES (1); --usability
INSERT INTO aqe_mapping.discipline (discipline_id) VALUES (2); --law
INSERT INTO aqe_mapping.discipline (discipline_id) VALUES (3); --security

-- temporary
INSERT INTO aqe_mapping.questionnaire (questionnaire_id, is_valid) VALUES (0, true);

-- temporary
INSERT INTO aqe_mapping.question (question_id, questionnaire_id, discipline_id) VALUES (0, 0, 0);
INSERT INTO aqe_mapping.question (question_id, questionnaire_id, discipline_id) VALUES (1, 0, 0);
INSERT INTO aqe_mapping.question (question_id, questionnaire_id, discipline_id) VALUES (2, 0, 1);
INSERT INTO aqe_mapping.question (question_id, questionnaire_id, discipline_id) VALUES (3, 0, 2);
INSERT INTO aqe_mapping.question (question_id, questionnaire_id, discipline_id) VALUES (4, 0, 3);

INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (0, 1);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (1, 1);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (2, 1);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (3, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (4, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (5, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (6, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (7, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (8, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (9, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (10, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (11, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (12, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (13, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (14, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (15, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (16, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (17, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (18, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (19, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (20, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (21, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (22, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (23, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (24, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (25, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (26, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (27, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (28, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (29, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (30, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (31, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (32, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (33, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (34, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (35, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (36, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (37, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (38, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (39, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (40, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (41, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (42, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (43, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (44, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (45, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (46, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (47, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (48, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (49, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (50, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (51, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (52, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (53, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (54, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (55, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (56, 0);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (57, 2);
INSERT INTO aqe_mapping.specialization (specialization_id, discipline_id) VALUES (58, 3);

INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (0, 0, false); -- MDL
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (1, 0, true); -- NMD
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (2, 1, false); -- MED
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (3, 1, false); -- EDU
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (4, 1, true); -- ADM
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (5, 2, false); -- NRV
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (6, 2, false); -- EYE
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (7, 2, false); -- EAR
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (8, 2, false); -- THR
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (9, 2, false); -- NOS
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (10, 2, false); -- MTH
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (11, 2, false); -- VOI
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (12, 2, false); -- CVS
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (13, 2, false); -- IMS
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (14, 2, false); -- RES
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (15, 2, false); -- DIG
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (16, 2, false); -- SKN
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (17, 2, false); -- ENC
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (18, 2, false); -- SEX
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (19, 2, false); -- PSY
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (20, 2, false); -- NUT
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (21, 2, false); -- MOV
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (22, 3, false); -- AMA
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (23, 3, false); -- PRO
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (24, 4, false); -- DIA
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (25, 4, false); -- TRE
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (26, 4, false); -- DMA
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (27, 4, false); -- PRE
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (28, 5, false); -- CHU
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (29, 5, false); -- NCU
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (30, 6, false); -- SAP
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (31, 6, false); -- SYS
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (32, 7, false); -- RXP
INSERT INTO aqe_mapping.category (category_id, level_id, is_terminate_node) VALUES (33, 7, false); -- OPN

-- temporary
INSERT INTO aqe_mapping.taxonomy_class OVERRIDING SYSTEM VALUE VALUES (0, 0, 2, 7, 22, 24, 28, 31, 32);

-- temporary
INSERT INTO aqe_mapping.questionnaire_taxonomy_class (questionnaire_id, taxonomy_class_id) VALUES (0, 0);

INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (5, 0);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (6, 0);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (7, 0);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (8, 0);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (9, 0);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (10, 0);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (11, 0);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (12, 0);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (13, 0);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (14, 0);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (15, 0);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (16, 0);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (17, 0);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (18, 0);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (19, 0);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (20, 0);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (21, 0);

INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (5, 1);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (6, 1);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (7, 1);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (8, 1);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (9, 1);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (10, 1);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (11, 1);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (12, 1);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (13, 1);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (14, 1);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (15, 1);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (16, 1);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (17, 1);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (18, 1);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (19, 1);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (20, 1);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (21, 1);

INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (5, 2);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (6, 2);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (7, 2);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (8, 2);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (9, 2);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (10, 2);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (11, 2);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (12, 2);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (13, 2);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (14, 2);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (15, 2);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (16, 2);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (17, 2);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (18, 2);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (19, 2);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (20, 2);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (21, 2);

INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (5, 3);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (6, 3);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (7, 3);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (8, 3);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (9, 3);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (10, 3);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (11, 3);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (12, 3);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (13, 3);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (14, 3);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (15, 3);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (16, 3);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (17, 3);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (18, 3);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (19, 3);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (20, 3);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (21, 3);

INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (5, 4);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (6, 4);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (7, 4);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (8, 4);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (9, 4);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (10, 4);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (11, 4);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (12, 4);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (14, 4);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (15, 4);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (21, 4);

INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (5, 5);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (6, 5);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (7, 5);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (8, 5);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (9, 5);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (10, 5);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (11, 5);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (12, 5);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (16, 5);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (21, 5);

INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (5, 57);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (6, 57);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (7, 57);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (8, 57);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (9, 57);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (10, 57);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (11, 57);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (12, 57);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (13, 57);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (14, 57);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (15, 57);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (16, 57);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (17, 57);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (18, 57);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (19, 57);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (20, 57);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (21, 57);

INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (5, 58);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (6, 58);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (7, 58);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (8, 58);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (9, 58);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (10, 58);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (11, 58);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (12, 58);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (13, 58);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (14, 58);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (15, 58);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (16, 58);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (17, 58);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (18, 58);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (19, 58);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (20, 58);
INSERT INTO aqe_mapping.category_specialization (category_id, specialization_id) VALUES (21, 58);

SELECT pg_catalog.setval('aqe_mapping.taxonomy_class_taxonomy_class_id_seq', 0, true);
