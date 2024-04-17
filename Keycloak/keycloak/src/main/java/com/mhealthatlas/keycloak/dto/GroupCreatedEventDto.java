package com.mhealthatlas.keycloak.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO containing the group created event data
 *
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class GroupCreatedEventDto {
  private String groupId;
  private String groupName;
  private String enterpriseType;
}
