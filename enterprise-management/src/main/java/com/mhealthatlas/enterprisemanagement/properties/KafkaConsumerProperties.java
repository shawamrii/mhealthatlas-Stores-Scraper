package com.mhealthatlas.enterprisemanagement.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import lombok.Getter;
import lombok.Setter;

/**
 * Defines custom properties for the Kafka consumer.
 */
@ConfigurationProperties("kafka")
@Configuration
@Getter
@Setter
public class KafkaConsumerProperties {
  /** The url of a kafka broker in the kafka cluster */
  private String bootstrapAddress;
  /** The consumer group id used by the service */
  private String groupId;
}
