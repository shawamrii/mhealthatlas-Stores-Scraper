package com.mhealthatlas.enterprisemanagement.dto;

import com.mhealthatlas.enterprisemanagement.model.EnterpriseType;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO containing enterprise information
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class EnterpriseInfoDto {
  private String name;
  private String displayName;
  private EnterpriseType type;
  private String details;
}
