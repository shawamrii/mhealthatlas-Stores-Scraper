# Expert Mapping Service

The *Expert Mapping* service provides functionalities for the mapping of categorized application to experts. Therefor experts are assigned multiple question for each mapped application. The current implementation create such a mapping when an application is categorized randomly. A more suitable algorithm should be implemented.

## Dependencies

This service depends on the service database (`postgres-aqe-mapping-db`), the message broker (`kafka1`) and the identity provider (`keycloak-mhealthatlas`). The service is only functional, if all of these service are running.

## Events

The *Application* service (indirect) produces and consumes the following events:

| Topic | Event Name | Produces | Consumes |
| ----  |     ----   |  :----:  |  :----:  |
| rating | rating_planned | :heavy_check_mark: | :x: |
| rating | rating_deleted | :heavy_check_mark: | :x: |
| android-application | android_application_deleted | :x: | :heavy_check_mark: |
| android-application | android_application_version_added | :x: | :heavy_check_mark: |
| android-application | android_application_added | :x: | :heavy_check_mark: |
| android-application | android_application_version_taxonomy_class_added | :x: | :heavy_check_mark: |
| android-application | android_application_version_taxonomy_class_deleted | :x: | :heavy_check_mark: |
| ios-application | ios_application_deleted | :x: | :heavy_check_mark: |
| ios-application | ios_application_version_added | :x: | :heavy_check_mark: |
| ios-application | ios_application_added | :x: | :heavy_check_mark: |
| ios-application | ios_application_version_taxonomy_class_added | :x: | :heavy_check_mark: |
| ios-application | ios_application_version_taxonomy_class_deleted | :x: | :heavy_check_mark: |
| private-application | private_application_version_added | :x: | :heavy_check_mark: |
| private-application | private_application_added | :x: | :heavy_check_mark: |
| private-application | private_application_version_taxonomy_class_added | :x: | :heavy_check_mark: |
| private-application | private_application_version_taxonomy_class_deleted | :x: | :heavy_check_mark: |
| private-application | private_application_deleted | :x: | :heavy_check_mark: |
| user-management | user_specialization_mapping_verified | :x: | :heavy_check_mark: |
| user-management | user_specialization_mapping_challenged | :x: | :heavy_check_mark: |
| user-management | user_specialization_mapping_deleted | :x: | :heavy_check_mark: |
| user-management | user_role_mapping_created | :x: | :heavy_check_mark: |
| user-management | user_role_mapping_deleted | :x: | :heavy_check_mark: |
| user-management | user_deleted | :x: | :heavy_check_mark: |
| rating | questionnaire_added | :x: | :heavy_check_mark: |
| rating | questionnaire_status_changed | :x: | :heavy_check_mark: |
| rating | questionnaire_deleted | :x: | :heavy_check_mark: |
| rating | question_added | :x: | :heavy_check_mark: |
| rating | rating_added | :x: | :heavy_check_mark: |

## *Expert Mapping* Service Structure

The table below gives an overview of the file structure of the *Expert Mapping* service. .

| File | Short Description |
| ----   |     ----          |
| [AppType](src/AppType.py) | enum for the different application types(Android, Ios, Private) |
| [AqeCommandService](src/AqeCommandService.py) | contains methods for mutating the *Expert Mapping* service database; creates also outbox entities with the event type `rating_planned` and `rating_deleted` |
| [KafkaListener](src/KafkaListener.py) | starts a kafka listener and listen for new events; the events are delegated to the corresponding methods based on the event type |
| [RatingEventDto](src/RatingEventDto.py) | rating data transfer object used to exchange rating data if a new rating is planned |
| [RatingIdEventDto](src/RatingIdEventDto.py) | rating id data transfer object used to exchange the rating id if an existing rating is deleted |

## Configuration Parameters

The table below lists the configuration parameters for the service and describes shortly what each parameter does. Additionally, the configured value is show. The parameters are set via environment variables. The environment variables used by the docker container are defined in the [.env](.env) file.

| Configuration Parameter | Short Description | Value |
|        ----             |      ----         |  ---- |
| DB_HOST | the database host name | aqe-mapping-db |
| DB_PORT | the database port | 5432 |
| DB_NAME | the database schema | aqeMapping |
| DB_USERNAME | the database user name | postgres |
| DB_PASSWORD | the database password | mHealthAtlasB@chlor2020_aqeMapping |
| KAFKA_SERVER | the kafka server host name and port | kafka1:9092 |
| KAFKA_GROUP_ID | the group id of the kafka listeners | read-application-topics-2 |
