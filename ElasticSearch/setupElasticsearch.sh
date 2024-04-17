#!/bin/bash

# Wait for Elasticsearch to start up before doing anything.
until curl -u "$ES_ADMIN_USER":"$ES_ADMIN_PASS" -s https://elasticsearch:9200/_cat/health -k -o /dev/null; do
    echo Waiting for Elasticsearch...
    sleep 10
done

echo Configure Security Plugin

plugins/opendistro_security/tools/securityadmin.sh -cn mediqsoft-cluster -h elasticsearch -cd ./plugins/opendistro_security/securityconfig/ -cacert ./config/mediqsoft-root-ca.pem -cert ./config/es-admin.pem -key ./config/es-admin-key.pem

echo Security Plugin configured