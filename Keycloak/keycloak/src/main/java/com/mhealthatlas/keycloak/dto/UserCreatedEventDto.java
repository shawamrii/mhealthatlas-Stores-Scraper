package com.mhealthatlas.keycloak.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO containing the user created event data
 *
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UserCreatedEventDto {
  private String userId;
  private String username;
  private String email;
}
