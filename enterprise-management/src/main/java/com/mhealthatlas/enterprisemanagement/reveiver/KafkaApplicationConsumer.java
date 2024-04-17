package com.mhealthatlas.enterprisemanagement.reveiver;

import java.io.IOException;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mhealthatlas.enterprisemanagement.command.EnterpriseCommandService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Component;

/**
 * Contains the Kafka consumer ({@code KafkaListener}).
 */
@Component
public class KafkaApplicationConsumer {
  /** @hidden */
  @Autowired
  ObjectMapper mapper;
  /** @hidden */
  @Autowired
  EnterpriseCommandService enterpriseCommandService;

  /**
   * Subscribes to the topics {@code user-management} and
   * {@code enterprise-management} and using the
   * {@link com.mhealthatlas.enterprisemanagement.config.kafka.KafkaConsumerConfig#kafkaListenerContainerFactory}
   * as the container factory.
   * <p>
   * The event payload is deserialized in a {@code JsonNode}. This deserialized
   * "eventData" is delegated to a method in a {@code CommandService} based on the
   * "eventType" attribute. If the {@code JsonNode} has no a "eventType" or
   * "eventData" attribute then the event is not processed.
   *
   * @param message the payload of the event
   * @throws IOException if the event payload could not parsed into a json object
   */
  @KafkaListener(topics = { "user-management",
      "enterprise-management" }, containerFactory = "kafkaListenerContainerFactory")
  public void kafkaListener(@Payload byte[] message) throws IOException {
    JsonNode json = mapper.readTree(message);
    JsonNode payload = json.has("schema") ? json.get("payload") : json;

    if (!payload.has("eventType") || !payload.has("eventData")) {
      return;
    }

    switch (payload.get("eventType").asText()) {
    case "user_created":
      enterpriseCommandService.handleUserCreated(payload.get("eventData"));
      break;
    case "user_updated":
      enterpriseCommandService.handleUserUpdated(payload.get("eventData"));
      break;
    case "user_deleted":
      enterpriseCommandService.handleUserDeleted(payload.get("eventData"));
      break;
    case "group_created":
      enterpriseCommandService.handleEnterpriseCreated(payload.get("eventData"));
      break;
    case "group_deleted":
      enterpriseCommandService.handleEnterpriseDeleted(payload.get("eventData"));
      break;
    default:
      break;
    }
  }
}
