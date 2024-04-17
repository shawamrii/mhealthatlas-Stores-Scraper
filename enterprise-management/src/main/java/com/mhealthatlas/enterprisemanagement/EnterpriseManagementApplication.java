package com.mhealthatlas.enterprisemanagement;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

/**
 * The entry point of the application.
 */
@SpringBootApplication
public class EnterpriseManagementApplication {

  /**
   * Starts the application using the spring startup routine.
   *
   * @param args command line arguments
   */
  public static void main(String[] args) {
    SpringApplication.run(EnterpriseManagementApplication.class, args);
  }

  /**
   * Instantiates a reusable instance of an {@code ObjectMapper} and register the
   * {@code ObjectMapper} in the IoC container.
   *
   * @return the instantiated {@code ObjectMapper}
   */
  @Bean
  public ObjectMapper objectMapper() {
    return new ObjectMapper();
  }

}
