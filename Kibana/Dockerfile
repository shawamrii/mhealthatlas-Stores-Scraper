#build stage
FROM docker.elastic.co/kibana/kibana-oss:7.9.1

RUN bin/kibana-plugin install https://d3g5vo6xdbdb9a.cloudfront.net/downloads/kibana-plugins/opendistro-security/opendistro_security_kibana_plugin-1.11.0.0.zip

COPY setupKibana.sh /usr/share/kibana/setupKibana.sh
COPY ./kibanaConfig.ndjson /usr/share/kibana/config/kibanaConfig.ndjson
COPY docker-entrypoint.sh /usr/share/kibana/docker-entrypoint.sh

WORKDIR /usr/share/kibana
CMD ["./docker-entrypoint.sh" ]