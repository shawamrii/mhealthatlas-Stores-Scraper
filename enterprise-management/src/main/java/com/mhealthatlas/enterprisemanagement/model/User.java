package com.mhealthatlas.enterprisemanagement.model;

import java.util.UUID;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Entity class for the {@code user} table.
 */
@Entity
@Table(name = "user", schema = "enterprise_management")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class User {

  /**
   * {@code user_id} column; primary key;
   */
  @Id
  @Column(name = "user_id", nullable = false)
  private UUID id;

  /**
   * {@code enterprise_id} column; foreign key; {@code enterprise} reference
   * table; {@code enterprise_id} references column; not null; unique;
   */
  @ManyToOne()
  @JoinColumn(name = "enterprise_id", referencedColumnName = "enterprise_id", nullable = false)
  private Enterprise enterprise;

  /**
   * {@code firstname} column; not null;
   */
  @Column(name = "firstname", nullable = false)
  private String firstName;

  /**
   * {@code lastname} column; not null;
   */
  @Column(name = "lastname", nullable = false)
  private String lastName;

  /**
   * {@code username} column; not null;
   */
  @Column(name = "username", nullable = false)
  private String userName;

  /**
   * {@code email} column; not null;
   */
  @Column(name = "email", nullable = false)
  private String email;

  /**
   * {@code department} column; not null;
   */
  @Column(name = "department", nullable = true)
  private String department;
}
