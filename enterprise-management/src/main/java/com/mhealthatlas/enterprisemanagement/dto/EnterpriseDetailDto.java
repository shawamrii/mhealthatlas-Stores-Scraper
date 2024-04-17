package com.mhealthatlas.enterprisemanagement.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO containing information about an enterprise and their users
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class EnterpriseDetailDto {
  private EnterpriseInfoDto enterpriseInfoDto;
  private List<UserDetailDto> users;
}
