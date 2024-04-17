# Recovery Tests

The *recovery-tests* folder contains the recovery tests for the mHealthAtlas system. Make sure that the mHealthAtlas system is **not** running, when executing the recovery tests. (Each recovery test starts the slim version of the system by itself)

## Run Tests

Execute `mvn clean test` to run all recovery tests.

## *recovery-tests* Folder Structure

The table below gives an overview of the subfolder structure of the *recovery-tests* folder.

| Folder | Short Description |
| ----   |     ----          |
| [recoverytests](src/test/java/com/mhealthatlas/recoverytests/) | contains the recovery tests and utility classes for executing the recovery tests. |
| [resources](src/main/resources/) | contains configuration properties of the recovery tests |

## Configuration Parameters

The table below lists the configuration parameters for the service and describes shortly what each parameter does. Additionally, the configured value is show. The listed parameters values are defined directly in the [application.properties](src/main/resources/application.properties) file.

| Configuration Parameter | Short Description | Value |
|        ----             |      ----         |  ---- |
| docker.compose.test.path | the absolute path to the `docker-compose.tests.yml` file |  \<path to the mHealthAtlas folder>/docker-compose.tests.yml |
| docker.host.url | the docker host url (<https://docs.docker.com/desktop/faqs/#how-do-i-connect-to-the-remote-docker-engine-api>) | npipe:////./pipe/docker_engine |
| keycloak.client.secret | the keycloak client secret | 46544c7f-5c91-4985-ada9-b0afc8610514 |
| keycloak.baseaddress | the base address of the keycloak server | <https://keycloak-proxy:5506> |
| mhealthatlas.gateway | the base address of the mHealthAtlas gateway | <https://mhealthatlas-gateway:5555> |
