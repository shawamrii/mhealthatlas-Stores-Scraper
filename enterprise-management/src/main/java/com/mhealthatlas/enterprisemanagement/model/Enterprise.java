package com.mhealthatlas.enterprisemanagement.model;

import java.util.List;
import java.util.UUID;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Entity class for the {@code enterprise} table.
 */
@Entity
@Table(name = "enterprise", schema = "enterprise_management")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Enterprise {

  /**
   * {@code enterprise_id} column; primary key;
   */
  @Id
  @Column(name = "enterprise_id", nullable = false)
  private UUID id;

  /**
   * {@code name} column; not null; unique;
   */
  @Column(name = "name", nullable = false, unique = true)
  private String name;

  /**
   * {@code enterprise_type} column; not null;
   */
  @Enumerated(EnumType.STRING)
  @Column(name = "enterprise_type", nullable = false)
  private EnterpriseType type;

  /**
   * {@code display_name} column;
   */
  @Column(name = "display_name", nullable = true)
  private String displayName;

  /**
   * {@code enterprise_details} column;
   */
  @Column(name = "enterprise_details", nullable = true)
  private String details;

  @OneToMany(mappedBy = "enterprise")
  private List<User> users;
}
