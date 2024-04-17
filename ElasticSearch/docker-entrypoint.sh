#!/bin/bash

export JAVA_HOME="/usr/share/elasticsearch/jdk"

./setupElasticsearch.sh &

/usr/local/bin/docker-entrypoint.sh