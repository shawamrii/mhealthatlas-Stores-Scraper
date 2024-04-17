package com.mhealthatlas.keycloak;

import java.util.Properties;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.keycloak.Config.Scope;
import org.keycloak.events.EventListenerProvider;
import org.keycloak.events.EventListenerProviderFactory;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.KeycloakSessionFactory;

/**
 * Registers the
 * {@link com.mhealthatlas.keycloak.MHealthAtlasEventListenerProvider} as an
 * event SPI.
 */
public class MHealthAtlasEventListenerProviderFactory implements EventListenerProviderFactory {
  /** @hidden */
  private KafkaProducer<String, String> producer;
  /** @hidden */
  private ObjectMapper mapper;

  /**
   * Create a new
   * {@link com.mhealthatlas.keycloak.MHealthAtlasEventListenerProvider} instance
   * and register the instance as the {@code EventListenerProvider}.
   *
   * @param session the keycloak session
   * @return an event listener provider
   */
  @Override
  public EventListenerProvider create(KeycloakSession session) {
    return new MHealthAtlasEventListenerProvider(producer, mapper);
  }

  /**
   * Creates a {@code KafkaProducer} and {@code ObjectMapper}.
   *
   * @param config the configuration for the SPI
   */
  @Override
  public void init(Scope config) {
    Properties properties = new Properties();

    properties.setProperty("bootstrap.servers", System.getenv("KAFKA_SERVER"));
    properties.setProperty("enable.idempotence", "true");
    properties.setProperty("transactional.id", "keycloak-transaction-1");
    try {
      properties.put("key.serializer", Class.forName("org.apache.kafka.common.serialization.StringSerializer"));
      properties.put("value.serializer", Class.forName("org.apache.kafka.common.serialization.StringSerializer"));
    } catch (ClassNotFoundException e) {
      e.printStackTrace();
    }

    this.producer = new KafkaProducer<String, String>(properties);
    this.producer.initTransactions();
    this.mapper = new ObjectMapper();
  }

  @Override
  public void postInit(KeycloakSessionFactory factory) {

  }

  /**
   * Cleans up used resources.
   */
  @Override
  public void close() {
    producer.close();
    mapper = null;
  }

  /**
   * Returns the id of the SPI.
   */
  @Override
  public String getId() {
    return "mhealthatlas_event_listener";
  }
}
