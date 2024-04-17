package com.mhealthatlas.keycloak.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO containing the group updated event data
 *
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class GroupUpdatedEventDto {
  private String groupId;
  private String groupName;
}
