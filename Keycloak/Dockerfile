#build stage
FROM maven:3.6.3-adoptopenjdk-14 as build

WORKDIR /tmp/
COPY keycloak/pom.xml /tmp/pom.xml
COPY keycloak/src /tmp/src

RUN mvn package -DskipTests

FROM jboss/keycloak
COPY --from=build /tmp/target/keycloak-mhealthatlas-event-listener.jar /opt/jboss/keycloak/standalone/deployments/keycloak-mhealthatlas-event-listener.jar
