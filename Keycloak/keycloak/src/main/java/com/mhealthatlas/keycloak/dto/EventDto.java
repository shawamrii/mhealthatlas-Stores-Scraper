package com.mhealthatlas.keycloak.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO for a kafka event.
 *
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class EventDto {
  private String eventType;
  private Integer version;
  private Long timestamp;
  private String aggregateType;
  private String eventData;
}
