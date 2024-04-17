package com.mhealthatlas.enterprisemanagement.dto;

import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO for exchanging the enterprise id via events.
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class EnterpriseIdEventDto {
  private UUID groupId;
}
