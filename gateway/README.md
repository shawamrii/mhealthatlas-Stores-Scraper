# Gateway

The *Gateway* provides functionalities for redirecting request to the corresponding services and to apply default filters.

## Dependencies

This service depends on the identity provider (`keycloak-mhealthatlas`). The service is only functional, if these service is running.

## *Gateway* Structure

The table below gives an overview of the folder structure of the *Gateway* service. The detailed description of the implemented classes can be found in the [*Gateway* service source code documentation](../Documentation/Gateway/apidocs/index.html).

| Folder | Short Description |
| ----   |     ----          |
| [config](src/main/java/com/mhealthatlas/gateway/config) | contains the ssl and cors configurations |
| [properties](src/main/java/com/mhealthatlas/gateway/properties) | contains the custom service properties |
| [gateway](src/main/java/com/mhealthatlas/gateway/GatewayApplication.java) | contains the route mappings |
| [resources](src/main/resources/) | contains configuration properties, the log format configuration and the SSL certificates of the service |

## Configuration Parameters

The table below lists the configuration parameters for the service and describes shortly what each parameter does. Additionally, the configured value is show. Either the listed parameters values are defined directly in the [application.yml](src/main/resources/application.yml) file or set via environment variables. The environment variables used by the docker container are defined in the [.env](.env) file.

| Configuration Parameter | Short Description | Value |
|        ----             |      ----         |  ---- |
| spring.application.name | application name |  mhealthatlas-gateway |
| logging.level.reactor.netty | loging level for the reactor netty package | INFO |
| logging.level.org.springframework.cloud.gateway | loging level for the spring cloud gateway package | DEBUG |
| spring.zipkin.baseUrl | base url for the distributed tracing service | <http://jaeger:9411> |
| server.servlet.context-path | the default context path for the service; only requests with the `<host>:<port>/<context-path>/**` format are processed | /mhealthatlas/ |
| server.port | the service port  | 5555 |
| server.ssl.enabled | enables ssl for the service http connections | true |
| server.ssl.key-store | the keystore path | classpath:ssl/keystore.jks |
| server.ssl.key-store-password | the keystore password | mEd@3[-] |
| server.ssl.trust-store | the truststore path | classpath:ssl/truststore.jks |
| server.ssl.trust-store-password | the truststore password | mEd@3[-] |
| spring.security.oauth2.resourceserver.jwt.issuer-uri | the access token issuer url | <https://keycloak-proxy:5506/auth/realms/MHealthAtlas> |
| spring.cloud.consul.host | the service discovery (consul) host name | consul1 |
| spring.cloud.consul.port | the service discovery (consul) port | 8500 |
| spring.cloud.consul.discovery.register | enables service registration in consul | false |
| spring.cloud.consul.discovery.register-health-check | enables regular healthchecks from consul | false |
| spring.cloud.consul.discovery.scheme | the request protocol name | https |
| spring.cloud.consul.discovery.metadata.secure | enables securing of metadata when the service registers itself by consul | true |
| spring.cloud.gateway.httpclient.ssl.use-insecure-trust-manager | enables the use of an insecure trustmanager | true |
| cors.allowed-origins | the allowed origin urls for cors requests | [<https://mhealthatlas:5556>] |
| cors.allowed-headers | the allowed headers for cors requests | [authorization, content-type] |
| cors.allowed-methods | the allowed methods for cors requests | [GET, POST, DELETE] |
