package com.mhealthatlas.enterprisemanagement.dto;

import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO for exchanging the user id via events.
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UserIdEventDto {
  private UUID userId;
}
