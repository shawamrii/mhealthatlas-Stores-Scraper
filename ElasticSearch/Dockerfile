#build stage
FROM docker.elastic.co/elasticsearch/elasticsearch-oss:7.9.1

RUN bin/elasticsearch-plugin install --verbose --batch https://d3g5vo6xdbdb9a.cloudfront.net/downloads/elasticsearch-plugins/opendistro-security/opendistro_security-1.11.0.0.zip
COPY setupElasticsearch.sh /usr/share/elasticsearch/setupElasticsearch.sh
COPY docker-entrypoint.sh /usr/share/elasticsearch/docker-entrypoint.sh

WORKDIR /usr/share/elasticsearch
RUN chmod a+x plugins/opendistro_security/tools/securityadmin.sh
ENTRYPOINT ["/tini", "--", "./docker-entrypoint.sh" ]