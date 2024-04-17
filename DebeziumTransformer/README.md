# Debezium Transformer

The *DebeziumTranformer* folder contains a service provider interface (SPI) implementation for Debezium and the Debzium PostgreSQL connector configurations. Additionally, a dockerfile for creating a custom Debezium image using the implemented SPI is defined.

## Dependencies

The Debezium services depends on the service databases and the message broker (`kafka1`).

## *DebeziumTransformer* Folder Structure

The table below gives an overview of the subfolder structure of the *DebeziumTransformer* folder. The detailed description of the implemented SPI classes can be found in the [*Debezium* source code documentation](../Documentation/Debezium/apidocs/index.html).

| Folder | Short Description |
| ----   |     ----          |
| [root folder](./) | contains the Debezium PostgreSQL connector configurations of the services  |
| [DebeziumTransformer](src/main/java/com/mhealthatlas/DebeziumTransformer/) | contains the SPI implementation |

## Debezium PostgreSQL Connector Configuration

The table below lists the configuration parameters.

| Configuration Parameter | Short Description | Value |
|        ----             |      ----         |  ---- |
| connector.class | the Debezium connector class  | io.debezium.connector.postgresql.PostgresConnector |
| <span>plugin.name</span> | the Debezium plugin used for parsing the WAL | pgoutput |
| tasks.max | the tasks use by this connector to monitore the database | 1 |
| database.hostname | the database host name | `service_hostname` |
| database.port | the database port | `database port` |
| database.user | the database user | `database user` |
| database.password | the database password | `database password` |
| database.dbname | the database schema | `database schema` |
| <span>database.server.name</span> | unique namespace for the database used as a prefix for the kafka topics (to store configuration, etc.. of the Debezium Connector) | `<unique-name>-outbox` |
| tombstones.on.delete | enables tombstone events after a delete event | false |
| table.whitelist | tables to monitore | `<database schema>.outbox` |
| transforms | transform type | outbox |
| transforms.outbox.type | register the implemented SPI as outbox transformer | com.mhealthatlas.DebeziumTransformer.CustomTransformation |
