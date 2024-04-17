package com.mhealthatlas.enterprisemanagement.config.kafka;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.mhealthatlas.enterprisemanagement.properties.KafkaConsumerProperties;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.header.Header;
import org.apache.kafka.common.serialization.ByteArrayDeserializer;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.core.DefaultKafkaConsumerFactory;

/**
 * Configures the {@code KafkaListenerContainerFactory} used by the
 * {@code KafkaListener}'s.
 */
@EnableKafka
@Configuration
public class KafkaConsumerConfig {
  /** @hidden */
  @Autowired
  private KafkaConsumerProperties kafkaProperties;

  /**
   * List of all event names processed by the service:
   *
   * <ul>
   * <li>user_created
   * <li>user_updated
   * <li>user_deleted
   * <li>group_created
   * <li>group_deleted
   * </ul>
   */
  private List<String> supportedEventTypes = Arrays.asList("user_created", "user_updated", "user_deleted",
      "group_created", "group_deleted");

  /**
   * Configures a Kafka {@code ConsumerFactory} to use a
   * {@code StringDeserializer} for desrealisation of the event key and a
   * {@code ByteArrayDeserializer} for the event payload.
   * <p>
   * The {@code ByteArrayDeserializer} is used to not allocate objects for event
   * types not listed in {@link #supportedEventTypes} since the event
   * desrealisation is executed before the events are filtered.
   * <p>
   * Also the Kafka server and the consumer group id is set.
   *
   * @return the configured {@code ConsumerFactory}
   */
  public ConsumerFactory<String, byte[]> consumerFactory() {
    Map<String, Object> configProps = new HashMap<>();
    configProps.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, kafkaProperties.getBootstrapAddress());
    configProps.put(ConsumerConfig.GROUP_ID_CONFIG, kafkaProperties.getGroupId());
    return new DefaultKafkaConsumerFactory<>(configProps, new StringDeserializer(), new ByteArrayDeserializer());
  }

  /**
   * Configures a Kafka {@code ConcurrentKafkaListenerContainerFactory} as the
   * used {@code KafkaListenerContainerFactory}. The {@link #consumerFactory} is
   * set as the {@code ConsumerFactory}. Additionally a custom filter strategy is
   * implemented. The filter strategy is used to ensure the only events with an
   * event type listed in {@link #supportedEventTypes} are forwarded to the
   * {@code KafkaListener}'s.
   *
   * @return the configured {@code ConcurrentKafkaListenerContainerFactory}
   */
  @Bean
  public ConcurrentKafkaListenerContainerFactory<String, byte[]> kafkaListenerContainerFactory() {
    ConcurrentKafkaListenerContainerFactory<String, byte[]> factory = new ConcurrentKafkaListenerContainerFactory<String, byte[]>();
    factory.setConsumerFactory(consumerFactory());
    factory.setRecordFilterStrategy(record -> {
      for (Header header : record.headers()) {
        if (header.key().equals("eventType") && supportedEventTypes.contains(new String(header.value()))) {
          return false;
        }
      }
      return true;
    });
    return factory;
  }
}
