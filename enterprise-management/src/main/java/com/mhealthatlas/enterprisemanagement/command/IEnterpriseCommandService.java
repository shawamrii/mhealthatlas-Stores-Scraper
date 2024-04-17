package com.mhealthatlas.enterprisemanagement.command;

import java.util.UUID;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.mhealthatlas.enterprisemanagement.dto.DepartmentDto;
import com.mhealthatlas.enterprisemanagement.dto.EnterpriseUpdateDto;

/**
 * Contains handler methods for events created by {@code Keycloak} and methods
 * to mutate enterprise informations.
 */
public interface IEnterpriseCommandService {
  /**
   * Handels a "group_created" event.<br>
   * Therefor the event payload is mapped to an {@code EnterpriseEventDto} and
   * transformed in a {@code Enterprise} entity. Then the entity is saved to store
   * the data changes in the database.
   *
   * @param enterpriseData the event enterprise data
   * @throws JsonProcessingException if the {@code enterpriseData} cannot be
   *                                 converted to a {@code EnterpriseEventDto}.
   */
  void handleEnterpriseCreated(JsonNode enterpriseData) throws JsonProcessingException;

  /**
   * Updates an existing enterprise.
   *
   * @param enterpriseName the enterprise name
   * @param enterprise     the enterprise data
   * @return {@code True}, if the enterprise exists and was updated
   *         successfully;<br>
   *         {@code False} otherwise;
   */
  Boolean handleEnterpriseUpdated(String enterpriseName, EnterpriseUpdateDto enterprise);

  /**
   * Handels a "group_deleted" event.<br>
   * Therefor the event payload is mapped to an {@code EnterpriseIdEventDto}. Then
   * the enterprise is deleted using the {@code EnterpriseIdEventDto} object.
   *
   * @param enterpriseData the event enterpriseData data
   * @throws JsonProcessingException if the {@code enterpriseData} cannot be
   *                                 converted to a {@code EnterpriseIdEventDto}.
   */
  void handleEnterpriseDeleted(JsonNode enterpriseData) throws JsonProcessingException;

  /**
   * Handels a "user_created" event.<br>
   * Therefor the event payload is mapped to an {@code UserEventDto} and
   * transformed in a {@code User} entity. Then the entity is saved to store the
   * data changes in the database.
   *
   * @param userData the event user data
   * @throws JsonProcessingException if the {@code userData} cannot be converted
   *                                 to a {@code UserEventDto}.
   */
  void handleUserCreated(JsonNode userData) throws JsonProcessingException;

  /**
   * Handels a "user_updated" event.<br>
   * Therefor the event payload is mapped to an {@code UserDetailEventDto} and
   * transformed in a {@code User} entity. Then the entity is saved to store the
   * data changes in the database.
   *
   * @param userData the event user data
   * @throws JsonProcessingException if the {@code userData} cannot be converted
   *                                 to a {@code UserDetailEventDto}.
   */
  void handleUserUpdated(JsonNode userData) throws JsonProcessingException;

  /**
   * Assigns an existing user a new department.
   *
   * @param userId     the user id
   * @param department the new department
   * @return {@code True} if the user exists and the user department was
   *         successfully updated;<br>
   *         {@code False} otherwise;
   */
  Boolean handleUserDepartmentUpdated(UUID userId, DepartmentDto department);

  /**
   * Handels a "user_deleted" event.<br>
   * Therefor the event payload is mapped to an {@code UserIdEventDto}. Then the
   * user is deleted using the {@code UserIdEventDto} object.
   *
   * @param userData the event user data
   * @throws JsonProcessingException if the {@code userData} cannot be converted
   *                                 to a {@code UserIdEventDto}.
   */
  void handleUserDeleted(JsonNode userData) throws JsonProcessingException;
}
