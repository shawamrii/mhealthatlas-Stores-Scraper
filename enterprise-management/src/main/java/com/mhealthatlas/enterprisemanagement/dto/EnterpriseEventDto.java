package com.mhealthatlas.enterprisemanagement.dto;

import java.util.UUID;

import com.mhealthatlas.enterprisemanagement.model.EnterpriseType;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO for exchanging enterprise informations via events.
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class EnterpriseEventDto {
  private UUID groupId;
  private String groupName;
  private EnterpriseType enterpriseType;
}
