#!/bin/bash

KIBANA_USER="kibanaserver"
KIBANA_PASS="MHealthAtlasESKibanaserver"
kibanaNotReadyString="Kibana server is not ready yet"
elasticsearchUrl="https://elasticsearch:9200"
kibanaUrl="https://localhost:5601"
kibanaStatus=$(curl -s -k -u "$KIBANA_USER":"$KIBANA_PASS" "$kibanaUrl"/status)

# Wait for Elasticsearch to start up before doing anything.
until curl -s -k -u "$KIBANA_USER":"$KIBANA_PASS" "${elasticsearchUrl}/_cat/health" -o /dev/null; do
    echo Waiting for Elasticsearch...
    sleep 10
done

# Wait for Kibana to start up before doing anything.
until [[ -n "$kibanaStatus" && "$kibanaStatus" != "$kibanaNotReadyString" ]]; do
    echo Waiting for Kibana...
    sleep 10
    kibanaStatus=$(curl -s -k -u "$KIBANA_USER":"$KIBANA_PASS" "${kibanaUrl}/status")
done

# load kibana config
(
    cd /usr/share/kibana/config || exit
    curl -k -X POST -s "${kibanaUrl}/api/saved_objects/_import?overwrite=true" -u "$KIBANA_USER":"$KIBANA_PASS" -H "kbn-xsrf: true" --form file=@kibanaConfig.ndjson
)

echo -e '\nConfigurations restored'