# ssl

The *ssl* folder contains all ssl certificates of the system.

## *ssl* Folder Structure

The table below gives an overview of the subfolder structure of the *ssl* folder.

| Folder | Short Description |
| ----   |     ----          |
| [root folder](./) | contains the mHealthAtlas root certificate authority certificates |
| [.openssl](.openssl/) | contains the index and database of the generated certificates by the mHealthAtlas root certificate authority |
| [app](app/) | contains the ssl certificates for the *Application* service |
| [consul1](consul1/) | contains the ssl certificates for the first *Consul* server |
| [consul2](consul2/) | contains the ssl certificates for the second *Consul* server |
| [consul3](consul3/) | contains the ssl certificates for the third *Consul* server |
| [elasticsearch](elasticsearch/) | contains the ssl certificates for the elastic search database |
| [enterprise](enterprise/) | contains the ssl certificates for the *Enterprise Management* service |
| [enterprise-app](enterprise-app/) | contains the ssl certificates for the *Enterprise* service |
| [filebeat](filebeat/) | contains the ssl certificates for the filebeat service |
| [frontend](frontend/) | contains the ssl certificates for the demo web frontend |
| [gateway](gateway/) | contains the ssl certificates for the mHealthAtlas gateway |
| [keycloak](keycloak/) | contains the ssl certificates for the keycloak server |
| [keycloak_proxy](keycloak_proxy/) | contains the ssl certificates for the keycloak proxy server |
| [kibana](kibana/) | contains the ssl certificates for the kibana server |
| [logstash](logstash/) | contains the ssl certificates for the logstash server |
| [mhealthatlas-user](mhealthatlas-user/) | contains the ssl certificates for the *mHealthAtlas User* service |
| [rating](rating/) | contains the ssl certificates for the *Rating* service |
| [taxonomy](taxonomy/) | contains the ssl certificates for the *Taxonomy* service |
| [user](user/) | contains the ssl certificates for the *User Management* service |
