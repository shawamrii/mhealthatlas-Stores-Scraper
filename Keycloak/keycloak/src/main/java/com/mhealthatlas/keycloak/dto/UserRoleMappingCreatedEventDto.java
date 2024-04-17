package com.mhealthatlas.keycloak.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO containing the user role created event data
 *
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UserRoleMappingCreatedEventDto {
  private String userId;
  private String roleId;
  private String roleName;
}
