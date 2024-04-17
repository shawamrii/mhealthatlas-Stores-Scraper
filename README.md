# mHealthAtlas

MHealthAtlas is a multidisciplinary expert-based evaluation system for mHealth applications. To realize a multidisciplinary expert-based evaluation system for mHealth applications
the system must also receive, manage, and visualize the application data by itself. The evaluation system must also define for all the different types of medical applications a suitable questionnaire and deal with expert verification to ensure qualitative evaluation results for all medical applications.

or the Multidisciplinary Evaluation of mHealthApplications*", IEEE, International Conference on e-health Networking, Applications and Services (HealthCom), 2020

## System Overview

The mHealthAtlas System is based on the microservices architecture. Therefor the system consists of multiple independent services. The functionalities and dependencies between the services are shown in the image below.


![Technical System Overview](Architecture/images/overview/SystemOverviewVerticalDiagram.png)

## Project Structure

This repository contains the implementation and configuration of all services. Also the source code documentation and tests are stored in this repository. The table below gives an overview of the folder structure.

| Folder Name          |  Short Description |
| :----               |  :-------------    |
| [StoreApps](StoreApps/README.md) | implementation of the *Application Store* service |
| [apps](apps/README.md) | implementation of the *Application* service |
| [AqeMapping](AqeMapping/README.md) | implementation of the *Expert Mapping* service |
| [Architecture](Architecture/README.md) | contains the api specifications, the schemata of the services and images visualizing various concepts of the mHealthAtlas system |
| [Database](Database/README.md) | contains the schemata and database configurations |
| [DebeziumTransformer](DebeziumTransformer/README.md) | extension and configuration of *Debezium* (database monitoring service) |
| [Documentation](Documentation/README.md) | contains the source code documentation of the mHealthAtlas system in HTML format |
| [ElasticSearch](ElasticSearch/README.md) | configuration of the *Elastic Search* databases (used to store the distributed logs) |
| [enterprise-apps](enterprise-apps/README.md) | implementation of the *Enterprise* service |
| [enterprise-management](enterprise-management/README.md) | implementation of the *Enterprise Management* service |
| [Filebeat](Filebeat/README.md) | configuration of *Filebeat* (used to collect the log messages from multiple docker container) |
| [frontendWeb](frontendWeb/README.md) | implementation of a simple web frontend to show and test the functionalities of the mHealthAtlas backend system |
| [gateway](gateway/README.md) | implementation and configuration of the mHealthAtlas system gateway |
| [Keycloak](Keycloak/README.md) | extension and configuration of *Keycloak* (Identity and Access Management Provider) |
| [KeycloakProxy](KeycloakProxy/README.md) | configuration of the reverse proxy from *Keycloak* |
| [Kibana](Kibana/README.md) | configuration of *Kibana* (GUI for an *Elastic Search* database) |
| [LoadTests](LoadTests/README.md) | implementation an results of the loadtest for the mHealthAtlas system |
| [Logstash](Logstash/README.md) | configuration of *Logstash* (Transforms and filers log messages before stored in elastic search) |
| [mhealthatlas-users](mhealthatlas-users/README.md) | implementation of the *mHealthAtlas User* service |
| [nginx](nginx/README.md) | contains *nginx* server configurations |
| [rating](rating/README.md) | implementation of the *Rating* service |
| [recovery-tests](recovery-tests/README.md) | implementation of the mHealthAtlas system recovery tests |
| [ServiceDiscovery](ServiceDiscovery/README.md) | configuration of the *consul* server agents (used for service discovery) |
| [ssl](ssl/README.md) | contains all ssl certificates of the mHealthAtlas system |
| [taxonomy](taxonomy/README.md) | implementation of the *Taxonomy* service |
| [user-management](user-management/README.md) | implementation of the *User Management* service |

## Description of My Task
The component hosted in this repository, known as the *Store Apps Service*, is engineered to collect metadata from health-related applications available on the Google Play Store and Apple App Store. This service is a crucial component of our extensive microservices architecture and integrates seamlessly with other related services. The names and details of these auxiliary services are cataloged in the main directory. However, to protect proprietary information and maintain privacy, the source codes of these services are not disclosed.

For more detailed information about the functionalities I developed and the codebase, please refer to the README.md file located in the StoreApps directory.



