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

CREATE SCHEMA ratings;


SET default_table_access_method = heap;

CREATE TYPE ratings.application_type AS ENUM ('Android', 'Ios', 'Private');
CREATE TYPE ratings.question_type AS ENUM ('MultipleChoice', 'Slider', 'NumberValue', 'Switch');

CREATE TABLE ratings.discipline (
    discipline_id integer NOT NULL PRIMARY KEY,
    name text NOT NULL UNIQUE,
    weight double precision DEFAULT 1 NOT NULL
);


CREATE TABLE ratings.category (
  category_id integer NOT NULL PRIMARY KEY,
  name text NOT NULL UNIQUE,
  abbreviation text NOT NULL UNIQUE,
  layer_id integer NOT NULL,
  is_terminate_node boolean NOT NULL
);


CREATE TABLE ratings.taxonomy_class (
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

ALTER TABLE ratings.taxonomy_class ALTER COLUMN taxonomy_class_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ratings.taxonomy_class_taxonomy_class_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY ratings.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer0_category_id_fkey FOREIGN KEY (layer0_category_id) REFERENCES ratings.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY ratings.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer1_category_id_fkey FOREIGN KEY (layer1_category_id) REFERENCES ratings.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY ratings.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer2_category_id_fkey FOREIGN KEY (layer2_category_id) REFERENCES ratings.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY ratings.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer3_category_id_fkey FOREIGN KEY (layer3_category_id) REFERENCES ratings.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY ratings.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer4_category_id_fkey FOREIGN KEY (layer4_category_id) REFERENCES ratings.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY ratings.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer5_category_id_fkey FOREIGN KEY (layer5_category_id) REFERENCES ratings.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY ratings.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer6_category_id_fkey FOREIGN KEY (layer6_category_id) REFERENCES ratings.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY ratings.taxonomy_class
    ADD CONSTRAINT taxonomy_class_layer7_category_id_fkey FOREIGN KEY (layer7_category_id) REFERENCES ratings.category(category_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE ratings.application_version_taxonomy_class (
    id integer NOT NULL PRIMARY KEY,
    application_version_id integer NOT NULL,
    application_id integer NOT NULL,
    application_type ratings.application_type NOT NULL,
    taxonomy_class_id integer NOT NULL,
    score double precision DEFAULT 0 NOT NULL,
    content_score double precision DEFAULT 0 NOT NULL,
    usability_score double precision DEFAULT 0 NOT NULL,
    security_score double precision DEFAULT 0 NOT NULL,
    law_score double precision DEFAULT 0 NOT NULL,
    is_prescribable boolean,
    UNIQUE(application_version_id, application_type, taxonomy_class_id)
);

ALTER TABLE ratings.application_version_taxonomy_class ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ratings.application_version_taxonomy_class_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY ratings.application_version_taxonomy_class
    ADD CONSTRAINT application_version_taxonomy_class_taxonomy_class_id_fkey FOREIGN KEY (taxonomy_class_id) REFERENCES ratings.taxonomy_class(taxonomy_class_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE ratings.questionnaire (
    questionnaire_id integer NOT NULL PRIMARY KEY,
    name text NOT NULL UNIQUE,
    is_valid boolean NOT NULL
);

ALTER TABLE ratings.questionnaire ALTER COLUMN questionnaire_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ratings.questionnaire_questionnaire_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);


CREATE TABLE ratings.question (
    question_id integer NOT NULL PRIMARY KEY,
    questionnaire_id integer NOT NULL,
    question_type ratings.question_type NOT NULL,
    question_text text NOT NULL,
    question_context text,
    discipline_id integer NOT NULL,
    min_score integer DEFAULT 0 NOT NULL,
    max_score integer NOT NULL,
    step_size double precision DEFAULT 1 NOT NULL,
    weight double precision DEFAULT 1 NOT NULL,
    UNIQUE(questionnaire_id, question_text)
);

ALTER TABLE ratings.question ALTER COLUMN question_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ratings.question_question_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY ratings.question
    ADD CONSTRAINT question_discipline_id_fkey FOREIGN KEY (discipline_id) REFERENCES ratings.discipline(discipline_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY ratings.question
    ADD CONSTRAINT question_questionnaire_id_fkey FOREIGN KEY (questionnaire_id) REFERENCES ratings.questionnaire(questionnaire_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE ratings.questionnaire_taxonomy_class (
    id integer NOT NULL PRIMARY KEY,
    questionnaire_id integer NOT NULL,
    taxonomy_class_id integer NOT NULL,
    UNIQUE(questionnaire_id, taxonomy_class_id)
);

ALTER TABLE ratings.questionnaire_taxonomy_class ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME ratings.questionnaire_taxonomy_class_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY ratings.questionnaire_taxonomy_class
    ADD CONSTRAINT questionnaire_taxonomy_class_questionnaire_id_fkey FOREIGN KEY (questionnaire_id) REFERENCES ratings.questionnaire(questionnaire_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY ratings.questionnaire_taxonomy_class
    ADD CONSTRAINT questionnaire_taxonomy_class_taxonomy_class_id_fkey FOREIGN KEY (taxonomy_class_id) REFERENCES ratings.taxonomy_class(taxonomy_class_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE ratings.rating (
    rating_id integer NOT NULL PRIMARY KEY,
    application_version_taxonomy_class_id integer NOT NULL,
    question_id integer NOT NULL,
    expert_id uuid NOT NULL,
    unweighted_score double precision,
    UNIQUE(application_version_taxonomy_class_id, question_id, expert_id)
);

ALTER TABLE ONLY ratings.rating
    ADD CONSTRAINT rating_question_id_fkey FOREIGN KEY (question_id) REFERENCES ratings.question(question_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ONLY ratings.rating
    ADD CONSTRAINT rating_application_version_taxonomy_class_id_fkey FOREIGN KEY (application_version_taxonomy_class_id) REFERENCES ratings.application_version_taxonomy_class(id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE ratings.outbox (
  event_id UUID NOT NULL PRIMARY KEY,
  version integer NOT NULL,
  root_aggregate_type text NOT NULL,
  root_aggregate_id text NOT NULL,
  aggregate_type text NOT NULL,
  aggregate_id text NOT NULL,
  event_type text NOT NULL,
  payload text NOT NULL
);

ALTER TABLE ratings.outbox OWNER TO postgres;


INSERT INTO ratings.discipline VALUES (0, 'Content', 1);
INSERT INTO ratings.discipline VALUES (1, 'Usability', 1);
INSERT INTO ratings.discipline VALUES (2, 'Security', 1);
INSERT INTO ratings.discipline VALUES (3, 'Law', 1);

INSERT INTO ratings.questionnaire (questionnaire_id, name, is_valid) OVERRIDING SYSTEM VALUE VALUES (0, 'test questionnaire', true);

INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (0, 0, 'MultipleChoice', 'Are common and current units used for displaying and collecting measured values and scores in the application?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (1, 0, 'MultipleChoice', 'Do all values have a unit and are the values correct?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (2, 0, 'MultipleChoice', 'Are the limits used recognized and applicable for the purpose intended by the application? ', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (3, 0, 'MultipleChoice', 'Does the description of the application follow the elements of the PICO scheme (Population - Intervention - Comparison - Outcome)?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (4, 0, 'MultipleChoice', 'Are the scores used common and suitable for the purpose intended by the application?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (5, 0, 'MultipleChoice', 'Is there a high risk that the users will be misled into a wrong treatment?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (6, 0, 'MultipleChoice', 'Do the instructions exclude all persons for whom the application could be a health hazard?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (7, 0, 'MultipleChoice', 'Are the technical information provided in the application up-to-date, complete, correct and verifiable?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (8, 0, 'MultipleChoice', 'Are the collected and calculated health data checked for anomalies, errors and plausibility?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (9, 0, 'MultipleChoice', 'Does the application offer the possibility to integrate an electronic patient and/or health record?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (10, 0, 'MultipleChoice', 'Does the application have a high specificity of risk stratification? ', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (11, 0, 'MultipleChoice', 'Does the application have a high sensitivity of risk stratification? ', 'The sensitivity of the risk stratification offered in the application indicates the probability that persons with these risks are classified in a correspondingly high risk classification by the application.', 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (12, 0, 'MultipleChoice', 'Does the offered diagnostics have a high sensitivity?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (13, 0, 'MultipleChoice', 'Are there useful guidelines/materials with which medical service providers can explain the application to patients?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (14, 0, 'MultipleChoice', 'Are all measures implemented that are indicated in the guidelines relevant for the intended use?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (15, 0, 'MultipleChoice', 'If possible, does the application offer different schemes for users to implement health measures ?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (16, 0, 'MultipleChoice', 'Are instructions for therapeutic exercises explained and presented in such a way that no health problems can arise?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (17, 0, 'MultipleChoice', 'Does the measurement accuracy of the application deviate only slightly from the relevant technical standard?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (18, 0, 'MultipleChoice', 'Is the background information on the effect of the methods used conclusive?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (19, 0, 'MultipleChoice', 'Is the application useful for the purpose described in the description?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (20, 0, 'MultipleChoice', 'Is the provider trustworthy in terms of professional competence?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (21, 0, 'MultipleChoice', 'Are the sources of the content used logical, conclusive and understandable?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (22, 0, 'MultipleChoice', 'Is there a clear distinction between objective specialist information and recommendations and assessments based on this information?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (23, 0, 'MultipleChoice', 'Are there any statements that can be used by the user?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (24, 0, 'MultipleChoice', 'Does the application provide information on how the collected values are to be understood?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (25, 0, 'MultipleChoice', 'How meaningful and conspicuous are the notes/warnings on the reliability of the values that are given in the presentation of calculated values?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (26, 0, 'MultipleChoice', 'If the application is for patients, is the content explained in a way that people without a medical background can understand the information?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (27, 0, 'MultipleChoice', 'Are all necessary notes/warnings about the reliability of results and diagnostic certainty provided? ', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (28, 0, 'MultipleChoice', 'Are accepted methodological models for changing health behaviour taken into account?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (29, 0, 'MultipleChoice', 'Is the application suitable to help with health promotion goals?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (30, 0, 'MultipleChoice', 'Are the risks of the application for users correctly assessable?', NULL, 0, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (31, 0, 'MultipleChoice', 'Does the application give continuous feedback on the health status or progress of the user?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (32, 0, 'MultipleChoice', 'How self-explanatory is the operation of the application?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (33, 0, 'Slider', 'How easy to use and intuitive is the application ?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (34, 0, 'Slider', 'For apps for children and young people: Does the content of the application for children and adolescents tie in with children''s or adolescents'' interests, developmental tasks and life worlds?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (35, 0, 'Slider', 'How easy are the main functions of the application to find and use?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (36, 0, 'Slider', 'How easy is it to learn how to use the application when using it for the first time?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (37, 0, 'Slider', 'How intuitively can the user navigate through the application?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (38, 0, 'Slider', 'How well does the user quickly access help, settings and other advanced functions of the application?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (39, 0, 'Slider', 'Does the user quickly access help, settings and other advanced functions of the application?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (40, 0, 'Slider', 'How useful is the application set up and structured?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (41, 0, 'Slider', ' For mobile applications for children and young people: Does the mobile application take into account the cognitive and motor skills of minors?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (42, 0, 'Slider', 'Is the navigation through the usage history (``forward", ``backward") constant and intuitive ?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (43, 0, 'Slider', 'How well is the content formulated linguistically and is it free of possible ambiguities?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (44, 0, 'Slider', 'Does the application give the user helpful feedback in case of incorrect entries, which makes it clear what the error was and how it can be corrected?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (45, 0, 'Slider', 'Does the application hardly give the user a chance to use it incorrectly and interfere with its functions?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (46, 0, 'Slider', 'Does the application work error-free and reliably?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (47, 0, 'Slider', 'As long as the application detects and evaluates symptoms: Is it ensured that if symptoms are of a high degree of illness, the user is referred to professional medical treatment?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (48, 0, 'Slider', 'Does the application appeal to and capture the curiosity and interests of the user?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (49, 0, 'Slider', 'Does the user quickly get help, settings and other advanced functions of the application?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (50, 0, 'Slider', 'How well does the application address and captivate the user''s curiosity and interests?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (51, 0, 'NumberValue', 'How motivating are the exercises or activities to be performed or guided via the application?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (52, 0, 'NumberValue', 'Does the application remain interesting over a longer period of time and does it repeatedly attract the user''s attention?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (53, 0, 'NumberValue', 'How good is the playful character of the application at motivating users?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (54, 0, 'NumberValue', 'Is it possible to use the mobile application with multiple devices and synchronize the data between them?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (55, 0, 'NumberValue', 'Is it possible for the user to independently access her/his stored personal data?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (56, 0, 'NumberValue', 'Does the mobile application offer the possibility to exercise the right to data transferability? ', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (57, 0, 'NumberValue', 'Does the mobile application offer the provider support that is free of charge and gives satisfactory feedback within 48 hours ?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (58, 0, 'NumberValue', 'Is it possible to contact professional support in the wider context of the mobile application?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (59, 0, 'NumberValue', 'Provided that certain rules must be observed when using the application to ensure the protection of health and safety: Does the mobile application contain instructions for use in German language, which can be called up from the mobile application? (ProdSG2150)', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (60, 0, 'NumberValue', 'How well can the mobile application be operated in German and is there a German user manual/online help and support in German?', NULL, 1, 0, 3, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (61, 0, 'NumberValue', 'Does the mHealth application meet Federal Office for Information Security (Bundesamt für Sicherheit in der Informationstechnik - BSI) certificate level 4 or higher?', NULL, 2, 0, 2, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (62, 0, 'NumberValue', 'Are the requirements of the Telemedia Act observed?', NULL, 3, 0, 2, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (63, 0, 'NumberValue', 'Are consumer rights guaranteed by the manufacturer towards the user?', NULL, 3, 0, 2, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (64, 0, 'NumberValue', 'Is information provided on the use of the product in accordance with commercial law?', NULL, 3, 0, 2, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (65, 0, 'NumberValue', 'Is more data release requested than necessary for the fulfilment of the contract?', NULL, 3, 0, 2, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (66, 0, 'NumberValue', 'Is the purpose of the collected data clearly stated?', NULL, 3, 0, 2, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (67, 0, 'NumberValue', 'Is stated/explained which license model is used?', NULL, 3, 0, 2, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (68, 0, 'NumberValue', 'Are rights of use transferred to the provider or third parties?', NULL, 3, 0, 2, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (69, 0, 'NumberValue', 'Does the mHealth application take into account use by children?', NULL, 3, 0, 2, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (70, 0, 'Switch', 'Does the mHealth application provide for an open procedure of the terms of use/privacy policy?', NULL, 3, 0, 2, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (71, 0, 'Switch', 'Before downloading and in the mHealth application, is information available for the assessment of child- and youth-specific suitability (e.g. reliable age classification, advertising, purchases, data protection, communication risks)?', NULL, 3, 0, 2, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (72, 0, 'Switch', 'Does the general terms and conditions state that personal data is collected for market research, advertising, profile building?', NULL, 3, 0, 2, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (73, 0, 'Switch', 'Is there a transfer of data to third parties that are collected in the application and if so, is this clearly evident?', NULL, 3, 0, 2, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (74, 0, 'Switch', 'Are all relevant requirements of the Product Protection Act observed?', NULL, 3, 0, 2, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (75, 0, 'Switch', 'Are all relevant requirements according to DSGVO fulfilled?', NULL, 3, 0, 2, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (76, 0, 'Switch', 'Are all relevant requirements of ProdSG1350 fulfilled?', NULL, 3, 0, 2, 1, 1);
INSERT INTO ratings.question OVERRIDING SYSTEM VALUE VALUES (77, 0, 'Switch', 'Are all relevant requirements of the Medical Products Act fulfilled?', NULL, 3, 0, 2, 1, 1);

INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (0, 'Medical', 'MDL', 0, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (1, 'Non-medical', 'NMD', 0, true);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (2, 'Medical Care', 'MED', 1, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (3, 'Education', 'EDU', 1, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (4, 'Administration', 'ADM', 1, true);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (5, 'Nervous System: Central nervous system, peripheral nervous system', 'NRV', 2, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (6, 'Eyes', 'EYE', 2, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (7, 'Ears', 'EAR', 2, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (8, 'Throat', 'THR', 2, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (9, 'Nose', 'NOS', 2, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (10, 'Mouth', 'MTH', 2, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (11, 'Voice', 'VOI', 2, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (12, 'Cardiovascular System', 'CVS', 2, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (13, 'Immune System', 'IMS', 2, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (14, 'Respiratory System', 'RES', 2, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (15, 'Digestive Organs', 'DIG', 2, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (16, 'Skin and skin appendages', 'SKN', 2, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (17, 'Endocrine Organs', 'ENC', 2, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (18, 'Urogenital and Reproductive System', 'SEX', 2, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (19, 'Psyche', 'PSY', 2, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (20, 'Nutrition', 'NUT', 2, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (21, 'Movement', 'MOV', 2, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (22, 'Amateur', 'AMA', 3, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (23, 'Medical Professional', 'PRO', 3, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (24, 'Diagnosis', 'DIA', 4, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (25, 'Treatment', 'TRE', 4, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (26, 'Diseases Management', 'DMA', 4, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (27, 'Prevention', 'PRE', 4, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (28, 'Chronic Use', 'CHU', 5, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (29, 'Non-chronic Use', 'NCU', 5, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (30, 'Standalone Product', 'SAP', 6, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (31, 'System Product', 'SYS', 6, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (32, 'Prescription', 'RXP', 7, false);
INSERT INTO ratings.category OVERRIDING SYSTEM VALUE VALUES (33, 'Open', 'OPN', 7, false);

INSERT INTO ratings.taxonomy_class OVERRIDING SYSTEM VALUE VALUES (0, 0, 2, 7, 22, 24, 28, 31, 32);

INSERT INTO ratings.questionnaire_taxonomy_class (questionnaire_id, taxonomy_class_id) VALUES (0, 0);

SELECT pg_catalog.setval('ratings.question_question_id_seq', 77, true);
SELECT pg_catalog.setval('ratings.questionnaire_questionnaire_id_seq', 0, true);
SELECT pg_catalog.setval('ratings.taxonomy_class_taxonomy_class_id_seq', 0, true);
