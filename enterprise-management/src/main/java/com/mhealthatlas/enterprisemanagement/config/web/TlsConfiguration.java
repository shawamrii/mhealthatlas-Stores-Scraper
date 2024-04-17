package com.mhealthatlas.enterprisemanagement.config.web;

import java.io.IOException;

import javax.annotation.PostConstruct;

import com.mhealthatlas.enterprisemanagement.properties.TlsProperties;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

/**
 * Configure the TLS certificate stores.
 */
@Configuration("TlsConfiguration")
@ComponentScan("com.mhealthatlas.enterprisemanagement")
public class TlsConfiguration {
  /** @hidden */
  @Autowired
  TlsProperties tlsProperties;

  /**
   * Register the in
   * {@link com.mhealthatlas.enterprisemanagement.properties.TlsProperties}
   * specified truststore for the services and set the truststore password.
   *
   * @throws IOException if the truststore cannot be found
   */
  @PostConstruct
  public void registerCustomTruststore() throws IOException {
    if (tlsProperties != null) {
      if (StringUtils.isNotBlank(tlsProperties.getTruststore())) {

        if (new ClassPathResource(tlsProperties.getTruststore()).getURI().getPath() == null) {
          System.setProperty("javax.net.ssl.trustStore",
              new ClassPathResource(tlsProperties.getTruststore()).getPath());
        } else {
          System.setProperty("javax.net.ssl.trustStore",
              new ClassPathResource(tlsProperties.getTruststore()).getURI().getPath());
        }
      }

      if (StringUtils.isNotBlank(tlsProperties.getTruststorePassword())) {
        System.setProperty("javax.net.ssl.trustStorePassword", tlsProperties.getTruststorePassword());
      }
    }
  }
}
