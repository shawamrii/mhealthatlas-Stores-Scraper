# Enterprise Management Service

The *Enterprise Management* service provides functionalities for manageging enterprises and their users.

## Dependencies

This service depends on the service database (`postgres-enterprise-management-db`), the message broker (`kafka1`) and the identity provider (`keycloak-mhealthatlas`). The service is only functional, if all of these service are running.

## Events

The *Enterprise Management* service (indirect) produces and consumes the following events:

| Topic | Event Name | Produces | Consumes |
| ----  |     ----   |  :----:  |  :----:  |
| user-management | user_created | :x: |:heavy_check_mark: |
| user-management | user_updated | :x: |:heavy_check_mark: |
| user-management | user_deleted | :x: |:heavy_check_mark: |
| enterprise-management | group_created | :x: |:heavy_check_mark: |
| enterprise-management | group_deleted | :x: |:heavy_check_mark: |

## API

The api definition follows the *OpenAPI* format and can be found in the [Enterprise Management Service Api Specification](../Architecture/Api/enterprise-management-api-docs.json) JSON file. The Specification can be visualized using the [Swagger UI](https://swagger.io/tools/swagger-ui/).

## *Enterprise Management* Service Structure

The table below gives an overview of the folder structure of the *Enterprise Management* service. The detailed description of the implemented classes can be found in the [*Enterprise Management* service source code documentation](../Documentation/EnterpriseManagementService/apidocs/index.html).

| Folder | Short Description |
| ----   |     ----          |
| [command](src/main/java/com/mhealthatlas/enterprisemanagement/command) | contains all services which mutates data in the service database |
| [config](src/main/java/com/mhealthatlas/enterprisemanagement/config) | contains the spring security and kafka listener configurations |
| [controller](src/main/java/com/mhealthatlas/enterprisemanagement/controller) | contains all web api endpoints of the service |
| [dto](src/main/java/com/mhealthatlas/enterprisemanagement/dto) | contains all data transfer objects of the service |
| [helper](src/main/java/com/mhealthatlas/enterprisemanagement/helper) | contains all utility methods of the service |
| [model](src/main/java/com/mhealthatlas/enterprisemanagement/model) | contains all entity classes of the service |
| [properties](src/main/java/com/mhealthatlas/enterprisemanagement/properties) | contains the custom service properties |
| [query](src/main/java/com/mhealthatlas/enterprisemanagement/query) | contains all services which queries data in the service database |
| [receiver](src/main/java/com/mhealthatlas/enterprisemanagement/receiver) | contains the kafka event listeners of the service |
| [repository](src/main/java/com/mhealthatlas/enterprisemanagement/repository) | contains the repository interface of the service |
| [services](src/main/java/com/mhealthatlas/enterprisemanagement/services) | contains services which depends on external services |
| [resources](src/main/resources/) | contains configuration properties, the log format configuration and the SSL certificates of the service |

## Configuration Parameters

The table below lists the configuration parameters for the service and describes shortly what each parameter does. Additionally, the configured value is show. Either the listed parameters values are defined directly in the [application.properties](src/main/resources/application.properties) file or set via environment variables. The environment variables used by the docker container are defined in the [.env](.env) file.

| Configuration Parameter | Short Description | Value |
|        ----             |      ----         |  ---- |
| spring.application.name | application name |  enterprise_management |
| logging.level.org.springframework.web | loging level for the spring web package | DEBUG |
| logging.level.org.springframework.web.actuator | loging level for the spring web actuator package | INFO |
| logging.level.org.springframework.web.HttpLogging | loging level for the spring web http logging package | INFO |
| logging.level.org.springframework.management | loging level for the spring management package | INFO |
| spring.zipkin.baseUrl | base url for the distributed tracing service | <http://jaeger:9411> |
| spring.sleuth.opentracing.enabled | enable log tracing using spring sleuth  | true |
| spring.sleuth.traceId128 | enable 128 bit trace id generation  | true |
| spring.sleuth.sampler.probability | the probability that a log message is send to the distributed tracing service  | 0.1 (= 10%) |
| server.servlet.context-path | the default context path for the service; only requests with the `<host>:<port>/<context-path>/**` format are processed | /mhealthatlas/ |
| server.port | the service port  | 5557 |
| spring.security.user.name | the username for accessing the actuator endpoints | ben |
| spring.security.user.password | the password for accessing the actuator endpoints | t |
| spring.security.user.role | the required role for accessing the actuator endpoints | HEALTHCHECK |
| server.ssl.enabled | enables ssl for the service http connections | true |
| server.ssl.key-store | the keystore path | classpath:ssl/keystore.jks |
| server.ssl.key-store-password | the keystore password | mEd@3[-] |
| server.ssl.trust-store | the truststore path | classpath:ssl/truststore.jks |
| server.ssl.trust-store-password | the truststore password | mEd@3[-] |
| spring.jpa.database | the database type | POSTGRESQL |
| spring.datasource.platform | the database type | postgres |
| spring.datasource.url | the database url | jdbc:postgresql://enterprise-management-db:5432/enterpriseManagement |
| spring.datasource.username | the database user name | postgres |
| spring.datasource.password | the database password | mHealthAtlasB@chlor2020_enterpriseManagement |
| spring.security.oauth2.resourceserver.jwt.issuer-uri | the access token issuer url | <https://keycloak-proxy:5506/auth/realms/MHealthAtlas> |
| spring.cloud.consul.discovery.instance-id | the service instance id used by the service discovery provider (consul) | `enterprise_management:<random value>` |
| spring.cloud.consul.host | the service discovery (consul) host name | consul1 |
| spring.cloud.consul.port | the service discovery (consul) port | 8500 |
| spring.cloud.consul.discovery.register-health-check | enables regular healthchecks from consul | true |
| spring.cloud.consul.discovery.scheme | the request protocol name | https |
| spring.cloud.consul.discovery.metadata.secure | enables securing of metadata when the service registers itself by consul | true |
| spring.cloud.consul.discovery.health-check-path | the healthcheck path of the service | /mhealthatlas/actuator/health |
| spring.cloud.consul.discovery.health-check-tls-skip-verify | enable skipping the ssl certificates verification for healthcheck requests | true |
| spring.cloud.consul.discovery.hostname | the service hostname used by consul to resolving the service name | enterprise-management-service |
| spring.cloud.consul.discovery.health-check-headers.Authorization | authorization header added to healthcheck requests | Basic YmVuOnQ= |
| management.endpoints.enabled-by-default | enables all management endpoints by default | false |
| management.endpoints.health.enabled | enables the healthcheck endpoint | true |
| kafka.bootstrap-address | the kafka server host name and port | kafka1:9092 |
| kafka.group-id | the group id of the kafka listeners | read-enterprise-management-topics-1 |
| keycloak.base-address | the base address of keycloak | <https://keycloak-proxy:5506> |
| keycloak.realm-name | the mHealthAtlas realm name | MHealthAtlas |
| keycloak.client-secret | the keycloak client secret | 7a265d75-cad4-4c6f-9206-1985495cdcea |
