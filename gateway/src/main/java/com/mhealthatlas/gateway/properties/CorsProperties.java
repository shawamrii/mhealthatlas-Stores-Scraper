package com.mhealthatlas.gateway.properties;

import java.util.List;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import lombok.Getter;
import lombok.Setter;

/**
 * Defines custom properties for the CORS configuration.
 */
@ConfigurationProperties("cors")
@Configuration
@Getter
@Setter
public class CorsProperties {
  private List<String> allowedOrigins;
  private List<String> allowedHeaders;
  private List<String> allowedMethods;
}
