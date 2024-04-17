package com.mhealthatlas.enterprisemanagement.dto;

import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO for exchanging detailed user informations via events.
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UserDetailEventDto {
  private UUID userId;
  private String username;
  private String firstname;
  private String lastname;
  private String email;
}
