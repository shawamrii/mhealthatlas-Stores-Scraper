package com.mhealthatlas.keycloak.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO containing the user group deleted event data
 *
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UserGroupMappingDeletedEventDto {
  private String userId;
  private String groupId;
  private String groupName;
}
