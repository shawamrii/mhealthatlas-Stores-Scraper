package com.mhealthatlas.enterprisemanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO containing user information
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UserDto {
  private String username;
  private String firstname;
  private String lastname;
  private String email;
  private String enterprise;
}
