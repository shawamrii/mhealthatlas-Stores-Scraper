package com.mhealthatlas.keycloak;

import java.util.Date;
import java.util.Map;
import java.util.UUID;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mhealthatlas.keycloak.dto.EventDto;
import com.mhealthatlas.keycloak.dto.GroupCreatedEventDto;
import com.mhealthatlas.keycloak.dto.GroupDeletedEventDto;
import com.mhealthatlas.keycloak.dto.GroupUpdatedEventDto;
import com.mhealthatlas.keycloak.dto.UserCreatedEventDto;
import com.mhealthatlas.keycloak.dto.UserDeletedEventDto;
import com.mhealthatlas.keycloak.dto.UserGroupMappingCreatedEventDto;
import com.mhealthatlas.keycloak.dto.UserGroupMappingDeletedEventDto;
import com.mhealthatlas.keycloak.dto.UserRoleMappingCreatedEventDto;
import com.mhealthatlas.keycloak.dto.UserRoleMappingDeletedEventDto;
import com.mhealthatlas.keycloak.dto.UserUpdatedEventDto;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.utils.Utils;
import org.keycloak.events.Event;
import org.keycloak.events.EventListenerProvider;
import org.keycloak.events.admin.AdminEvent;
import org.keycloak.events.admin.OperationType;

/**
 * Contains methods to process keycloak events.
 */
public class MHealthAtlasEventListenerProvider implements EventListenerProvider {
  /** @hidden */
  private KafkaProducer<String, String> producer;
  /** @hidden */
  private ObjectMapper mapper;

  private String topic;
  private String eventName;
  private String resourcePathSeparator;
  /** The length of a resource id (uuid) */
  private Integer resourceIdLength = 36;

  public MHealthAtlasEventListenerProvider(KafkaProducer<String, String> producer, ObjectMapper mapper) {
    this.producer = producer;
    this.mapper = mapper;
  }

  @Override
  public void close() {

  }

  /**
   * Listens to user registered events and publishes the corresponding
   * "user_created" kafka event on the "user-management" topic.
   *
   * @param event the keycloak event data
   */
  @Override
  public void onEvent(Event event) {
    switch (event.getType()) {
    case REGISTER:
      topic = "user-management";
      eventName = "user_created";

      if (validateEventDetails(event.getDetails(), "username", "email")) {
        UserCreatedEventDto user = new UserCreatedEventDto(event.getUserId(), event.getDetails().get("username"),
            event.getDetails().get("email"));
        EventDto eventData = new EventDto(eventName, 1, new Date().getTime(), "user",
            mapper.convertValue(user, JsonNode.class).toString());

        ProducerRecord<String, String> r = new ProducerRecord<String, String>(topic,
            generatePartionKey(topic, user.getUserId()), generateKey(user.getUserId(), eventName),
            mapper.convertValue(eventData, JsonNode.class).toString());

        r.headers().add("eventId", UUID.randomUUID().toString().getBytes());
        r.headers().add("eventType", eventName.getBytes());

        this.producer.beginTransaction();
        publishRecord(r);
        this.producer.commitTransaction();
      } else {
        System.out.println("Not all expected values found.");
      }
      break;
    default:
      break;
    }
    System.out.println("Event Occurred:" + toString(event));
  }

  /**
   * Listens to keycloak admin events and publishes them on kafka.
   * <p>
   * Processed Events (keycloak event resource type, operation -{@literal >}
   * topic: event type):
   * <ul>
   * <li>USER, CREATE -{@literal >} user-management: user_created
   * <li>USER, UPDATE -{@literal >} user-management: user_updated
   * <li>USER, DELETE -{@literal >} user-management: user_deleted
   * <li>REALM_ROLE_MAPPING, CREATE -{@literal >} user-management:
   * user_role_mapping_created
   * <li>REALM_ROLE_MAPPING, DELETE -{@literal >} user-management:
   * user_role_mapping_deleted
   * <li>GROUP_MEMBERSHIP, CREATE -{@literal >} user-management:
   * user_group_mapping_created, enterprise-management: user_group_mapping_created
   * <li>GROUP_MEMBERSHIP, DELETE -{@literal >} user-management:
   * user_group_mapping_deleted, enterprise-management: user_group_mapping_deleted
   * <li>GROUP, CREATE -{@literal >} enterprise-management: group_created
   * <li>GROUP, UPDATE -{@literal >} enterprise-management: group_updated
   * <li>GROUP, DELETE -{@literal >} enterprise-management: group_deleted
   * </ul>
   *
   * @param event                 the keycloak admin event data
   * @param includeRepresentation the flag indicating if an event contains a
   *                              detailed resource representation
   */
  @Override
  public void onEvent(AdminEvent event, boolean includeRepresentation) {
    try {
      switch (event.getResourceType()) {
      case USER:
        topic = "user-management";
        resourcePathSeparator = "users/";

        if (event.getOperationType() == OperationType.CREATE && event.getRepresentation() != null) {
          eventName = "user_created";
          JsonNode representation = this.mapper.readTree(event.getRepresentation());
          Integer sepPos = event.getResourcePath().indexOf(resourcePathSeparator);

          if (validateEventRepresentation(representation, "username", "email") && sepPos >= 0) {
            String userId = event.getResourcePath().substring(sepPos + resourcePathSeparator.length(),
                sepPos + resourcePathSeparator.length() + resourceIdLength);
            UserCreatedEventDto user = new UserCreatedEventDto(userId, representation.get("username").asText(),
                representation.get("email").asText());
            EventDto eventData = new EventDto(eventName, 1, new Date().getTime(), "user",
                mapper.convertValue(user, JsonNode.class).toString());

            ProducerRecord<String, String> r = new ProducerRecord<String, String>(topic,
                generatePartionKey(topic, user.getUserId()), generateKey(user.getUserId(), eventName),
                mapper.convertValue(eventData, JsonNode.class).toString());

            r.headers().add("eventId", UUID.randomUUID().toString().getBytes());
            r.headers().add("eventType", eventName.getBytes());

            this.producer.beginTransaction();
            publishRecord(r);
            this.producer.commitTransaction();
          } else {
            System.out.println("Not all expected values found.");
          }
        }

        if (event.getOperationType() == OperationType.UPDATE && event.getRepresentation() != null) {
          eventName = "user_updated";
          JsonNode representation = this.mapper.readTree(event.getRepresentation());
          Integer sepPos = event.getResourcePath().indexOf(resourcePathSeparator);

          if (validateEventRepresentation(representation, "username", "firstName", "lastName", "email")
              && sepPos >= 0) {
            String userId = event.getResourcePath().substring(sepPos + resourcePathSeparator.length(),
                sepPos + resourcePathSeparator.length() + resourceIdLength);
            UserUpdatedEventDto user = new UserUpdatedEventDto(userId, representation.get("username").asText(),
                representation.get("firstName").asText(), representation.get("lastName").asText(),
                representation.get("email").asText());
            EventDto eventData = new EventDto(eventName, 1, new Date().getTime(), "user",
                mapper.convertValue(user, JsonNode.class).toString());

            ProducerRecord<String, String> r = new ProducerRecord<String, String>(topic,
                generatePartionKey(topic, user.getUserId()), generateKey(user.getUserId(), eventName),
                mapper.convertValue(eventData, JsonNode.class).toString());

            r.headers().add("eventId", UUID.randomUUID().toString().getBytes());
            r.headers().add("eventType", eventName.getBytes());

            this.producer.beginTransaction();
            publishRecord(r);
            this.producer.commitTransaction();
          } else {
            System.out.println("Not all expected values found.");
          }
        }

        if (event.getOperationType() == OperationType.DELETE) {
          eventName = "user_deleted";
          Integer sepPos = event.getResourcePath().indexOf(resourcePathSeparator);

          if (sepPos >= 0) {
            String userId = event.getResourcePath().substring(sepPos + resourcePathSeparator.length(),
                sepPos + resourcePathSeparator.length() + resourceIdLength);
            UserDeletedEventDto user = new UserDeletedEventDto(userId);
            EventDto eventData = new EventDto(eventName, 1, new Date().getTime(), "user",
                mapper.convertValue(user, JsonNode.class).toString());

            ProducerRecord<String, String> r = new ProducerRecord<String, String>(topic,
                generatePartionKey(topic, user.getUserId()), generateKey(user.getUserId(), eventName),
                mapper.convertValue(eventData, JsonNode.class).toString());

            r.headers().add("eventId", UUID.randomUUID().toString().getBytes());
            r.headers().add("eventType", eventName.getBytes());

            this.producer.beginTransaction();
            publishRecord(r);
            this.producer.commitTransaction();
          } else {
            System.out.println("Not all expected values found.");
          }
        }
        break;
      case REALM_ROLE_MAPPING:
        topic = "user-management";
        resourcePathSeparator = "users/";

        if (event.getOperationType() == OperationType.CREATE && event.getRepresentation() != null) {
          eventName = "user_role_mapping_created";
          JsonNode representation = this.mapper.readTree(event.getRepresentation());
          representation = representation.get(0);
          Integer sepPos = event.getResourcePath().indexOf(resourcePathSeparator);

          if (validateEventRepresentation(representation, "id", "name") && sepPos >= 0) {
            String userId = event.getResourcePath().substring(sepPos + resourcePathSeparator.length(),
                sepPos + resourcePathSeparator.length() + resourceIdLength);
            UserRoleMappingCreatedEventDto urMapping = new UserRoleMappingCreatedEventDto(userId,
                representation.get("id").asText(), representation.get("name").asText());
            EventDto eventData = new EventDto(eventName, 1, new Date().getTime(), "user",
                mapper.convertValue(urMapping, JsonNode.class).toString());

            ProducerRecord<String, String> r = new ProducerRecord<String, String>(topic,
                generatePartionKey(topic, urMapping.getUserId()),
                generateKey(String.format("%s#%s", urMapping.getUserId(), representation.get("id").asText()),
                    eventName),
                mapper.convertValue(eventData, JsonNode.class).toString());

            r.headers().add("eventId", UUID.randomUUID().toString().getBytes());
            r.headers().add("eventType", eventName.getBytes());

            this.producer.beginTransaction();
            publishRecord(r);
            this.producer.commitTransaction();
          } else {
            System.out.println("Not all expected values found.");
          }
        }

        if (event.getOperationType() == OperationType.DELETE && event.getRepresentation() != null) {
          eventName = "user_role_mapping_deleted";
          JsonNode representation = this.mapper.readTree(event.getRepresentation());
          representation = representation.get(0);
          Integer sepPos = event.getResourcePath().indexOf(resourcePathSeparator);

          if (validateEventRepresentation(representation, "id", "name") && sepPos >= 0) {
            String userId = event.getResourcePath().substring(sepPos + resourcePathSeparator.length(),
                sepPos + resourcePathSeparator.length() + resourceIdLength);
            UserRoleMappingDeletedEventDto urMapping = new UserRoleMappingDeletedEventDto(userId,
                representation.get("id").asText(), representation.get("name").asText());
            EventDto eventData = new EventDto(eventName, 1, new Date().getTime(), "user",
                mapper.convertValue(urMapping, JsonNode.class).toString());

            ProducerRecord<String, String> r = new ProducerRecord<String, String>(topic,
                generatePartionKey(topic, urMapping.getUserId()),
                generateKey(String.format("%s#%s", urMapping.getUserId(), representation.get("id").asText()),
                    eventName),
                mapper.convertValue(eventData, JsonNode.class).toString());

            r.headers().add("eventId", UUID.randomUUID().toString().getBytes());
            r.headers().add("eventType", eventName.getBytes());

            this.producer.beginTransaction();
            publishRecord(r);
            this.producer.commitTransaction();
          } else {
            System.out.println("Not all expected values found.");
          }
        }
        break;
      case GROUP_MEMBERSHIP:
        resourcePathSeparator = "users/";

        if (event.getOperationType() == OperationType.CREATE && event.getRepresentation() != null) {
          eventName = "user_group_mapping_created";
          JsonNode representation = this.mapper.readTree(event.getRepresentation());
          Integer sepPos = event.getResourcePath().indexOf(resourcePathSeparator);

          if (validateEventRepresentation(representation, "id", "name") && sepPos >= 0) {
            String userId = event.getResourcePath().substring(sepPos + resourcePathSeparator.length(),
                sepPos + resourcePathSeparator.length() + resourceIdLength);
            UserGroupMappingCreatedEventDto ugMapping = new UserGroupMappingCreatedEventDto(userId,
                representation.get("id").asText(), representation.get("name").asText());

            topic = "user-management";
            EventDto eventData1 = new EventDto(eventName, 1, new Date().getTime(), "user",
                mapper.convertValue(ugMapping, JsonNode.class).toString());
            ProducerRecord<String, String> r1 = new ProducerRecord<String, String>(topic,
                generatePartionKey(topic, ugMapping.getUserId()),
                generateKey(String.format("%s#%s", ugMapping.getUserId(), representation.get("id").asText()),
                    eventName),
                mapper.convertValue(eventData1, JsonNode.class).toString());
            r1.headers().add("eventId", UUID.randomUUID().toString().getBytes());
            r1.headers().add("eventType", eventName.getBytes());

            topic = "enterprise-management";
            EventDto eventData2 = new EventDto(eventName, 1, new Date().getTime(), "enterprise",
                mapper.convertValue(ugMapping, JsonNode.class).toString());
            ProducerRecord<String, String> r2 = new ProducerRecord<String, String>(topic,
                generatePartionKey(topic, representation.get("id").asText()),
                generateKey(String.format("%s#%s", ugMapping.getUserId(), representation.get("id").asText()),
                    eventName),
                mapper.convertValue(eventData2, JsonNode.class).toString());
            r2.headers().add("eventId", UUID.randomUUID().toString().getBytes());
            r2.headers().add("eventType", eventName.getBytes());

            this.producer.beginTransaction();
            publishRecord(r1);
            publishRecord(r2);
            this.producer.commitTransaction();
          } else {
            System.out.println("Not all expected values found.");
          }
        }

        if (event.getOperationType() == OperationType.DELETE && event.getRepresentation() != null) {
          eventName = "user_group_mapping_deleted";
          JsonNode representation = this.mapper.readTree(event.getRepresentation());
          Integer sepPos = event.getResourcePath().indexOf(resourcePathSeparator);

          if (validateEventRepresentation(representation, "id", "name") && sepPos >= 0) {
            String userId = event.getResourcePath().substring(sepPos + resourcePathSeparator.length(),
                sepPos + resourcePathSeparator.length() + resourceIdLength);
            UserGroupMappingDeletedEventDto ugMapping = new UserGroupMappingDeletedEventDto(userId,
                representation.get("id").asText(), representation.get("name").asText());

            topic = "user-management";
            EventDto eventData1 = new EventDto(eventName, 1, new Date().getTime(), "user",
                mapper.convertValue(ugMapping, JsonNode.class).toString());
            ProducerRecord<String, String> r1 = new ProducerRecord<String, String>(topic,
                generatePartionKey(topic, ugMapping.getUserId()),
                generateKey(String.format("%s#%s", ugMapping.getUserId(), representation.get("id").asText()),
                    eventName),
                mapper.convertValue(eventData1, JsonNode.class).toString());
            r1.headers().add("eventId", UUID.randomUUID().toString().getBytes());
            r1.headers().add("eventType", eventName.getBytes());

            topic = "enterprise-management";
            EventDto eventData2 = new EventDto(eventName, 1, new Date().getTime(), "enterprise",
                mapper.convertValue(ugMapping, JsonNode.class).toString());
            ProducerRecord<String, String> r2 = new ProducerRecord<String, String>(topic,
                generatePartionKey(topic, representation.get("id").asText()),
                generateKey(String.format("%s#%s", ugMapping.getUserId(), representation.get("id").asText()),
                    eventName),
                mapper.convertValue(eventData2, JsonNode.class).toString());
            r2.headers().add("eventId", UUID.randomUUID().toString().getBytes());
            r2.headers().add("eventType", eventName.getBytes());

            this.producer.beginTransaction();
            publishRecord(r1);
            publishRecord(r2);
            this.producer.commitTransaction();
          } else {
            System.out.println("Not all expected values found.");
          }
        }
        break;
      case GROUP:
        topic = "enterprise-management";
        resourcePathSeparator = "groups/";

        if (event.getOperationType() == OperationType.CREATE && event.getRepresentation() != null) {
          eventName = "group_created";
          JsonNode representation = this.mapper.readTree(event.getRepresentation());
          Integer sepPos = event.getResourcePath().indexOf(resourcePathSeparator);

          if (validateEventRepresentation(representation, "name", "attributes")
              && representation.get("attributes").has("enterprise_type")
              && representation.get("attributes").get("enterprise_type").size() == 1 && sepPos >= 0) {
            String groupId = event.getResourcePath().substring(sepPos + resourcePathSeparator.length(),
                sepPos + resourcePathSeparator.length() + resourceIdLength);
            GroupCreatedEventDto group = new GroupCreatedEventDto(groupId, representation.get("name").asText(),
                representation.get("attributes").get("enterprise_type").get(0).asText());
            EventDto eventData = new EventDto(eventName, 1, new Date().getTime(), "enterprise",
                mapper.convertValue(group, JsonNode.class).toString());

            ProducerRecord<String, String> r = new ProducerRecord<String, String>(topic,
                generatePartionKey(topic, group.getGroupId()), generateKey(group.getGroupId(), eventName),
                mapper.convertValue(eventData, JsonNode.class).toString());

            r.headers().add("eventId", UUID.randomUUID().toString().getBytes());
            r.headers().add("eventType", eventName.getBytes());

            this.producer.beginTransaction();
            publishRecord(r);
            this.producer.commitTransaction();
          } else {
            System.out.println("Not all expected values found.");
          }
        }

        if (event.getOperationType() == OperationType.UPDATE && event.getRepresentation() != null) {
          eventName = "group_updated";
          JsonNode representation = this.mapper.readTree(event.getRepresentation());
          Integer sepPos = event.getResourcePath().indexOf(resourcePathSeparator);

          if (validateEventRepresentation(representation, "name") && sepPos >= 0) {
            String groupId = event.getResourcePath().substring(sepPos + resourcePathSeparator.length(),
                sepPos + resourcePathSeparator.length() + resourceIdLength);
            GroupUpdatedEventDto group = new GroupUpdatedEventDto(groupId, representation.get("name").asText());
            EventDto eventData = new EventDto(eventName, 1, new Date().getTime(), "enterprise",
                mapper.convertValue(group, JsonNode.class).toString());

            ProducerRecord<String, String> r = new ProducerRecord<String, String>(topic,
                generatePartionKey(topic, group.getGroupId()), generateKey(group.getGroupId(), eventName),
                mapper.convertValue(eventData, JsonNode.class).toString());

            r.headers().add("eventId", UUID.randomUUID().toString().getBytes());
            r.headers().add("eventType", eventName.getBytes());

            this.producer.beginTransaction();
            publishRecord(r);
            this.producer.commitTransaction();
          } else {
            System.out.println("Not all expected values found.");
          }
        }

        if (event.getOperationType() == OperationType.DELETE) {
          eventName = "group_deleted";
          Integer sepPos = event.getResourcePath().indexOf(resourcePathSeparator);

          if (sepPos >= 0) {
            String groupId = event.getResourcePath().substring(sepPos + resourcePathSeparator.length(),
                sepPos + resourcePathSeparator.length() + resourceIdLength);
            GroupDeletedEventDto group = new GroupDeletedEventDto(groupId);
            EventDto eventData = new EventDto(eventName, 1, new Date().getTime(), "enterprise",
                mapper.convertValue(group, JsonNode.class).toString());

            ProducerRecord<String, String> r = new ProducerRecord<String, String>(topic,
                generatePartionKey(topic, group.getGroupId()), generateKey(group.getGroupId(), eventName),
                mapper.convertValue(eventData, JsonNode.class).toString());

            r.headers().add("eventId", UUID.randomUUID().toString().getBytes());
            r.headers().add("eventType", eventName.getBytes());

            this.producer.beginTransaction();
            publishRecord(r);
            this.producer.commitTransaction();
          } else {
            System.out.println("Not all expected values found.");
          }
        }
        break;
      default:
        break;
      }
    } catch (JsonProcessingException e) {
      this.producer.abortTransaction();
      e.printStackTrace();
    }
    System.out.println("Admin Event Occurred:" + toString(event));
  }

  /**
   * Validates that the event detail contains all necessary data.
   *
   * @param details  the event details
   * @param keyNames the necessary data keys
   * @return {@code True}, if the event details contains all necessary data;<br>
   *         {@code False} otherwise;
   */
  private boolean validateEventDetails(Map<String, String> details, String... keyNames) {
    if (details == null) {
      return false;
    }

    for (String keyName : keyNames) {
      if (details.get(keyName) == null) {
        return false;
      }
    }
    return true;
  }

  /**
   * Validates the the event representation contains all necessary data.
   *
   * @param representation the event representation
   * @param keyNames       the necessary data keys
   * @return {@code True}, if the event representation contains all necessary
   *         data;<br>
   *         {@code False} otherwise;
   */
  private boolean validateEventRepresentation(JsonNode representation, String... keyNames) {
    for (String keyName : keyNames) {
      if (!representation.has(keyName)) {
        return false;
      }
    }
    return true;
  }

  /**
   * Generates the partition key.
   *
   * @param rootAggregateType the root aggregate type (= topic)
   * @param rootAggregateId   the root aggregate id
   * @return the generated partition id
   */
  private Integer generatePartionKey(String rootAggregateType, String rootAggregateId) {
    Integer numberOfPartition = this.producer.partitionsFor(rootAggregateType).size();
    return Utils.toPositive(Utils.murmur2(rootAggregateId.getBytes())) % numberOfPartition;
  }

  /**
   * Generates the event key.
   *
   * @param aggregateId the aggregate id
   * @param eventType   the event type
   * @return the generated event key
   */
  private String generateKey(String aggregateId, String eventType) {
    return String.format("%s#%s", aggregateId, eventType);
  }

  /**
   * Publishes a kafka event.
   *
   * @param record the event to publish
   */
  private void publishRecord(ProducerRecord<String, String> record) {
    this.producer.send(record);
    this.producer.flush();
  }

  /**
   * Utility method to transform a keycloak event to a string representation.
   *
   * @param event the keycloak event
   * @return the string representation of the event
   */
  private String toString(Event event) {
    StringBuilder sb = new StringBuilder();
    sb.append("type=");
    sb.append(event.getType());
    sb.append(", realmId=");
    sb.append(event.getRealmId());
    sb.append(", clientId=");
    sb.append(event.getClientId());
    sb.append(", userId=");
    sb.append(event.getUserId());
    sb.append(", ipAddress=");
    sb.append(event.getIpAddress());

    if (event.getError() != null) {
      sb.append(", error=");
      sb.append(event.getError());
    }

    if (event.getDetails() != null) {
      for (Map.Entry<String, String> e : event.getDetails().entrySet()) {
        sb.append(", ");
        sb.append(e.getKey());
        if (e.getValue() == null || e.getValue().indexOf(' ') == -1) {
          sb.append("=");
          sb.append(e.getValue());
        } else {
          sb.append("='");
          sb.append(e.getValue());
          sb.append("'");
        }
      }
    }
    return sb.toString();
  }

  /**
   * Utility method to transform a keycloak admin event to a string
   * representation.
   *
   * @param adminEvent the keycloak admin event
   * @return the string representation of the admin event
   */
  private String toString(AdminEvent adminEvent) {
    StringBuilder sb = new StringBuilder();

    sb.append("operationType=");
    sb.append(adminEvent.getOperationType());
    sb.append(", realmId=");
    sb.append(adminEvent.getAuthDetails().getRealmId());
    sb.append(", clientId=");
    sb.append(adminEvent.getAuthDetails().getClientId());
    sb.append(", userId=");
    sb.append(adminEvent.getAuthDetails().getUserId());
    sb.append(", ipAddress=");
    sb.append(adminEvent.getAuthDetails().getIpAddress());
    sb.append(", resourceType=");
    sb.append(adminEvent.getResourceType());
    sb.append(", resourcePath=");
    sb.append(adminEvent.getResourcePath());
    sb.append(", representation=");
    sb.append(adminEvent.getRepresentation());

    if (adminEvent.getError() != null) {
      sb.append(", error=");
      sb.append(adminEvent.getError());
    }
    return sb.toString();
  }
}
