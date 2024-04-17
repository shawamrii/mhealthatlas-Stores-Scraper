package com.mhealthatlas.enterprisemanagement.dto;

import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO for updating user data.
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UserUpdateDto {
  private UUID userId;
  private String username;
  private String firstname;
  private String lastname;
  private String email;
}
