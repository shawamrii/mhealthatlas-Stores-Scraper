package com.mhealthatlas.enterprisemanagement.repository;

import java.util.UUID;

import com.mhealthatlas.enterprisemanagement.model.User;

import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Contains methods to interact with the database.<br>
 * The query annotations uses the entity classes defined in
 * {@link com.mhealthatlas.enterprisemanagement.model.User}. Standart actions
 * like {@code save} and {@code findAllById} are automatically generated.
 */
public interface UserRepository extends JpaRepository<User, UUID> {

}
