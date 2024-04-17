# mHealthAtlas

MHealthAtlas is a multidisciplinary expert-based evaluation system for mHealth applications. To realize a multidisciplinary expert-based evaluation system for mHealth applications
the system must also receive, manage, and visualize the application data by itself. The evaluation system must also define for all the different types of medical applications a suitable questionnaire and deal with expert verification to ensure qualitative evaluation results for all medical applications.

## More Informations

The mHealthAtlas system was implemented in the bachelor thesis:

* **B. Zick**, "*Redesigning mHealthAtlas to a microservices-based system*", Freie Universität Berlin, Bachelor thesis, 2021

The underlying paper of implementation of the mHealthAtlas system listed below:

* **F. Spielmann**, "*Medicate - Design and implementation of a portal for evaluating medical mobile applications*", Freie Universität Berlin, Bachelor thesis, 2020
* **N. J. Lehmann, M. Karagülle, D. Kmiotek, F. Spielmann, B. George, O. Junk, A. Voisard, and J. W. Fluhr**, "*mROMA - An expert-based approach for the multidisciplinary rating of mHealth applications*", IEEE, 2020  IEEE  International  Conference  on  Healthcare  Informatics (ICHI)
* **N. J. Lehmann, F. Spielmann, B. George, L. Ververs, M. Karagülle, D. Kmiotek, L. Mielke, O. Junk, A. Voisard, and J. W. Fluhr**, "*mHealthAtlas - An Approach for the Multidisciplinary Evaluation of mHealthApplications*", IEEE, International Conference on e-health Networking, Applications and Services (HealthCom), 2020

## System Overview

The mHealthAtlas System is based on the microservices architecture. Therefor the system consists of multiple independent services. The functionalities and dependencies between the services are shown in the image below.

![Functional System Overview](Architecture/images/overview/SystemDesignOverview.png)

Beside the functional services there are also infrastructure service to achieve a more reliable and flexible system behavior. In the image below an overview of the infrastructure service are given.

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

## Setup

Before the system is started the following DNS entries should be set:

* DNS Name: `mhealthatlas-gateway`, IP: `127.0.0.1`
* DNS Name: `keycloak-proxy`, IP: `127.0.0.1`

windows: [https://support.managed.com/kb/a683/how-to-modify-your-hosts-file-so-you-can-work-on-a-site-that-is-not-yet-live.aspx](https://support.managed.com/kb/a683/how-to-modify-your-hosts-file-so-you-can-work-on-a-site-that-is-not-yet-live.aspx)  
linux: [https://www.tecmint.com/setup-local-dns-using-etc-hosts-file-in-linux/](https://www.tecmint.com/setup-local-dns-using-etc-hosts-file-in-linux/)  
macos: [https://www.mactip.net/how-to-edit-the-hosts-file-on-a-mac/](https://www.mactip.net/how-to-edit-the-hosts-file-on-a-mac/)

### SSL Certificates

All used SSL certificates are stored in the [ssl](ssl/) folder. Navigate to this folder and verify that the certificates are not expired using `openssl x509 -in <path-to-certificate>.pem -noout -text`.

If the root certificate is expired use the following commands to renew the the root certificate:

* `openssl req -config caconf.cnf -new -key cakey.pem -out newcsr.csr`
* `openssl x509 -req -in newcsr.csr -signkey cakey.pem -out cacert.pem`
* `rm newcsr.csr`

If another certificate is expired use the `initConfig.sh` script in the root folder.

## Start the mHealthAtlas System

* execute the command `docker-compose -f .\docker-compose.yml up --build -d` in the root folder
* wait until all service are up and **running**
* open the [mHealthAtlas Backend Demo Frontend](https://mhealthatlas:5556/) in a browser
* open the [mHealthAtlas Gateway](https://mhealthatlas-gateway:5555/mhealthatlas/) in a browser
* Trust the self signed certificates
* Log in using the username "mhealthatlas" and password "test" or using the username "loadtest" and password "test123"

## Debugging

* comment out the currently developed service in the `docker-copmose.yml` file (if necessary change `depends-on` constraints)
* execute `docker-compose -f .\docker-compose.yml up --build -d` to build and run the rest of the system
* check that the needed environment variables are set (`/service_name/.env`) when the debugging process starts the services (Warning: `DB_URL` variable should reference `localhost` as the hostname and the exposed database port as the port)
* copy the needed ssl certificates from the `ssl/<service-name>` folder into the `<service-name>/src/main/resources/ssl` folder
  
Mac and Windows:

* set the local DNS Alias for the debugged service to the IP address of `host.docker.internal`
* set the local DNS Alias `kafka1` to the IP address of `host.docker.internal`
* set the local DNS Alias `zookeeper` to the IP address of `host.docker.internal`

Linux:

* open a bash in a container (`docker exec -it <container-name>`) and execute the command `RUN ip -4 route list match 0/0 | awk '{print $3 "host.docker.internal"}'`
* copy the returned IP address
* set the local DNS Alias for the debugged service to the copied IP address
* set the local DNS Alias `kafka1` to the copied IP address
* set the local DNS Alias `zookeeper` to the copied IP address
