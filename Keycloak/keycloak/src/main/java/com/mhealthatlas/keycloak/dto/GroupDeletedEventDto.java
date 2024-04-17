package com.mhealthatlas.keycloak.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO containing the group deleted event data
 *
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class GroupDeletedEventDto {
  private String groupId;
}
