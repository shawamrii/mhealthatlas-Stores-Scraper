package com.mhealthatlas.gateway.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.reactive.CorsConfigurationSource;
import org.springframework.web.cors.reactive.CorsWebFilter;
import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource;

import com.mhealthatlas.gateway.properties.CorsProperties;

/**
 * Configures a CORS filter.
 */
@Configuration
public class PreFlightCorsConfiguration {
  /** @hidden */
  @Autowired
  CorsProperties corsProperties;

  /**
   * Returns a new cors filter configured with the configuration provided by the
   * {@link #corsConfigurationSource()} method.
   *
   * @return a new cors filter
   */
  @Bean
  public CorsWebFilter corsFilter() {
    return new CorsWebFilter(corsConfigurationSource());
  }

  /**
   * Configures a CORS filter and register this filter for all request.
   *
   * @return the cors filter configuration
   */
  @Bean
  CorsConfigurationSource corsConfigurationSource() {
    final UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    CorsConfiguration config = new CorsConfiguration();

    for (String origin : corsProperties.getAllowedOrigins()) {
      config.addAllowedOrigin(origin);
    }

    for (String method : corsProperties.getAllowedMethods()) {
      config.addAllowedMethod(HttpMethod.resolve(method));
    }

    for (String header : corsProperties.getAllowedHeaders()) {
      config.addAllowedHeader(header);
    }

    source.registerCorsConfiguration("/**", config);
    return source;
  }
}
