package com.mhealthatlas.enterprisemanagement.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import lombok.Getter;
import lombok.Setter;

/**
 * Defines custom properties for the TLS configuration..
 */
@ConfigurationProperties("tls")
@Configuration
@Getter
@Setter
public class TlsProperties {
  /** the truststore path */
  private String truststore;
  /** the truststore password */
  private String truststorePassword;
}
