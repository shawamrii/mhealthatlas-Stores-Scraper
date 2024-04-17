package com.mhealthatlas.keycloak.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO containing the user group created event data
 *
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UserGroupMappingCreatedEventDto {
  private String userId;
  private String groupId;
  private String groupName;
}
