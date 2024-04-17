# Keycloak

The *Keycloak* folder contains a service provider interface (SPI) implementation for Keycloak, a customized Keycloak user interface and the Keycloak configurations. Additionally, a dockerfile for creating a custom Keycloak image using the implemented SPI is defined.

## Dependencies

The Keycloak services depends on the keycloak database (`postgres-keycloak-db`).

## *Keycloak* Folder Structure

The table below gives an overview of the subfolder structure of the *Keycloak* folder. The detailed description of the implemented SPI classes can be found in the [*Keycloak* source code documentation](../Documentation/Keycloak/apidocs/index.html).

| Folder | Short Description |
| ----   |     ----          |
| [root folder](./) | contains the Keycloak configurations and the ssl certificates  |
| [themes](themes/) | contains the custom user interface implementation |
| [keycloak](keycloak/src/main/java/com/mhealthatlas/keycloak/) | contains the SPI implementation |
| [dto](keycloak/src/main/java/com/mhealthatlas/keycloak/dto/) | contains all data transfer object |
| [resources](keycloak/src/main/resources/META-INF/services/) | contains the SPI class name |
