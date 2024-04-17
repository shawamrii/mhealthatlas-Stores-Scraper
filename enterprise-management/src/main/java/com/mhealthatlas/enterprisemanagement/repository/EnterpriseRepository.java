package com.mhealthatlas.enterprisemanagement.repository;

import java.util.Optional;
import java.util.UUID;

import com.mhealthatlas.enterprisemanagement.model.Enterprise;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

/**
 * Contains methods to interact with the database.<br>
 * The query annotations uses the entity classes defined in
 * {@link com.mhealthatlas.enterprisemanagement.model.Enterprise}. Standart
 * actions like {@code save} and {@code findAllById} are automatically
 * generated.
 */
public interface EnterpriseRepository extends JpaRepository<Enterprise, UUID> {
  /**
   * Finds the enterprise with the given name.
   *
   * @param name the enterprise name
   * @return the found enterprise wrapped in an {@code Optional};<br>
   *         an empty {@code Optional} otherwise;
   */
  @Query("select e from Enterprise e where e.name = :name")
  Optional<Enterprise> findOneByName(@Param("name") String name);
}
