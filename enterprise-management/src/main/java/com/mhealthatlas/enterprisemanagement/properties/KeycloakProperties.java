package com.mhealthatlas.enterprisemanagement.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import lombok.Getter;
import lombok.Setter;

/**
 * Defines custom properties for the Keycloak client configuration
 */
@ConfigurationProperties("keycloak")
@Configuration
@Getter
@Setter
public class KeycloakProperties {
  /** The url of the keycloak server */
  private String baseAddress;
  /**
   * client secret, used by this service to authenticate as mHealthAtlas
   * administrator
   */
  private String clientSecret;
  /** the realm name */
  private String realmName;
}
