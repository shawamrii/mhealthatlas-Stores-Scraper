package com.mhealthatlas.enterprisemanagement.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO containing information of multiple enterprises
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class EnterprisesDto {
  private List<EnterpriseInfoDto> enterprises;
}
