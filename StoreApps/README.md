# Store Apps Service

The *Store Apps* service provides functionalities for the scraping of Apple store applications and Google store applications and storing them in the database(`storeApps`).

## Dependencies

This service depends on the service database (`postgres-store-apps-db`).the message broker (`kafka1`) and the identity provider (`keycloak-mhealthatlas`). The service is only functional, if all of these service are running.

## Events

The *Application* service (indirect) produces and consumes the following events:

| Topic | Event Name | Produces | Consumes |
| ----  |     ----   |  :----:  |  :----:  |
| android-application | android_application_added | :heavy_check_mark: | :x: |
| android-application | android_application_changed | :heavy_check_mark: | :x: |
| android-application | android_application_version_added | :heavy_check_mark: | :x: |
| android-application | android_application_version_changed | :heavy_check_mark: | :x: |
| android-application | android_application_deleted | :heavy_check_mark: | :x: |
| android-application | android_application_relation_changed | :heavy_check_mark: | :x: |
| android-application | android_application_relation_deleted | :heavy_check_mark: | :x: |
| ios-application | ios_application_added | :heavy_check_mark: | :x: |
| ios-application | ios_application_changed | :heavy_check_mark: | :x: |
| ios-application | ios_application_version_added | :heavy_check_mark: | :x: |
| ios-application | ios_application_version_changed | :heavy_check_mark: | :x: |
| ios-application | ios_application_deleted | :heavy_check_mark: | :x: |
| ios-application | ios_application_relation_changed | :heavy_check_mark: | :x: |
| ios-application | ios_application_relation_deleted | :heavy_check_mark: | :x: |
| private-application | private_application_added | :heavy_check_mark: | :x: |
| private-application | private_application_changed | :heavy_check_mark: | :x: |
| private-application | private_application_version_added | :heavy_check_mark: | :x: |
| private-application | private_application_version_changed | :heavy_check_mark: | :x: |
| private-application | private_application_deleted | :heavy_check_mark: | :x: |
| android-application | android_application_version_taxonomy_class_added | :x: | :heavy_check_mark: |
| android-application | android_application_version_taxonomy_class_deleted | :x: | :heavy_check_mark: |
| android-application | score_changed | :x: | :heavy_check_mark: |
| ios-application | ios_application_version_taxonomy_class_added | :x: | :heavy_check_mark: |
| ios-application | ios_application_version_taxonomy_class_deleted | :x: | :heavy_check_mark: |
| ios-application | score_changed | :x: | :heavy_check_mark: |
| private-application | private_application_version_taxonomy_class_added | :x: | :heavy_check_mark: |
| private-application | private_application_version_taxonomy_class_deleted | :x: | :heavy_check_mark: |
| private-application | score_changed | :x: | :heavy_check_mark: |

## *Store Apps* Service Structure

The table below gives an overview of the file structure of the *Store Apps* service. .

| File | Short Description |
| ----   |     ----          |
| [storeCommandService](src/storeCommandService.py) | contains methods for storing the Data in database |
| [kafkaProducer](src/kafkaProducer.py) | contains a method to produce kafka messages |
| [chromeOptions](src/chromeOptions.py) | chrome options for Selenium |
| [appleAppScraper](src/appleAppScraper.py) | a method to scrape an ios app |
| [appleStoreScraper](src/appleStoreScraper.py) | contains methods to collect ios apps from apple_store |
| [googleAppScraper](src/googleAppScraper.py) | a method to scrape an android app |
| [playStoreScraper](src/playStoreScraper.py) | contains methods to collect ios apps from play_store |


<!--| [KafkaListener](src/KafkaListener.py) | starts a kafka listener and listen for new events; the events are delegated to the corresponding methods based on the event type |
| [RatingEventDto](src/RatingEventDto.py) | rating data transfer object used to exchange rating data if a new rating is planned |
| [RatingIdEventDto](src/RatingIdEventDto.py) | rating id data transfer object used to exchange the rating id if an existing rating is deleted |-->

## Configuration Parameters

The table below lists the configuration parameters for the service and describes shortly what each parameter does. Additionally, the configured value is show. The parameters are set via environment variables. The environment variables used by the docker container are defined in the [.env](.env) file.

| Configuration Parameter | Short Description | Value |
|        ----             |      ----         |  ---- |
| DB_HOST | the database host name | store-apps-db |
| DB_PORT | the database port | 5432 |
| DB_NAME | the database schema | storeApps |
| DB_USERNAME | the database user name | postgres |
| DB_PASSWORD | the database password | mHealthAtlasB@chlor2020_storeApps |
| KAFKA_SERVER | the kafka server host name and port | kafka1:9092 |
<!---| KAFKA_GROUP_ID | the group id of the kafka listeners | read-application-topics-2 |--->

