package com.mhealthatlas.enterprisemanagement.dto;

import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO for exchanging user informations via events.
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UserEventDto {
  private UUID userId;
  private String username;
  private String email;
}
