/**
 * com.mhealthatlas.keycloak contains all functionalities to transform keycloak
 * events in Kafka events and to publish the events on a kafka topic.
 * <p>
 * Produced Events via Outbox Pattern (topic: event type):
 * <ul>
 * <li>user-management: user_created
 * <li>user-management: user_updated
 * <li>user-management: user_deleted
 * <li>user-management: user_role_mapping_created
 * <li>user-management: user_role_mapping_deleted
 * <li>user-management: user_group_mapping_created
 * <li>user-management: user_group_mapping_deleted
 * <li>enterprise-management: group_created
 * <li>enterprise-management: group_updated
 * <li>enterprise-management: group_deleted
 * <li>enterprise-management: user_group_mapping_created
 * <li>enterprise-management: user_group_mapping_deleted
 * </ul>
 * <p>
 * Consumed Events (topic: event type):
 */
package com.mhealthatlas.keycloak;
