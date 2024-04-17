package com.mhealthatlas.enterprisemanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO for updating an enterprise.
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class EnterpriseUpdateDto {
  private String displayName;
  private String details;
}
