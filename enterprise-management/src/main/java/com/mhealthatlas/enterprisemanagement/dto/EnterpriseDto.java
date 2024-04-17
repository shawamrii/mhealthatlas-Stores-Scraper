package com.mhealthatlas.enterprisemanagement.dto;

import com.mhealthatlas.enterprisemanagement.model.EnterpriseType;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO containing enterprise short information
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class EnterpriseDto {
  private String name;
  private EnterpriseType type;
}
