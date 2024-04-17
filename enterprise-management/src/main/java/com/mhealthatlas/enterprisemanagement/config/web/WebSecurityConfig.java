package com.mhealthatlas.enterprisemanagement.config.web;

import com.mhealthatlas.enterprisemanagement.config.web.filter.CsrfTokenResponseHeaderBindingFilter;

import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.web.csrf.CsrfFilter;

/**
 * Configures the web security pipeline and enable the oauth2 identity provider
 * integration for the {@code /apps/**} endpoints. Registers the configured
 * pipeline as {@code Order} 2 to not override the configuration for the
 * {@code Actuator} endpoints.
 */
@EnableWebSecurity
@Configuration
@Order(2)
@EnableGlobalMethodSecurity(securedEnabled = true, prePostEnabled = true)
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

  /**
   * Configures the security pipeline for the {@code Application} endpoints and
   * registers the configuration after the
   * {@link com.mhealthatlas.enterprisemanagement.config.web.filter.CsrfTokenResponseHeaderBindingFilter}
   * filter step.
   * <p>
   * Each request have to be authenticated using JWT access token which is
   * validate with the configured identity provider. The JWT access token is pares
   * using the custom {@link #jwtAuthenticationConverter}.
   *
   * @param http the spring security configuration
   */
  @Override
  protected void configure(HttpSecurity http) throws Exception {
    http.addFilterAfter(new CsrfTokenResponseHeaderBindingFilter(), CsrfFilter.class)
        .antMatcher("/enterprise-management/**").authorizeRequests().anyRequest().authenticated().and()
        .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS).and().oauth2ResourceServer().jwt()
        .jwtAuthenticationConverter(jwtAuthenticationConverter());
  }

  /**
   * Configures the {@code JwtAuthenticationConverter} to use the
   * {@link com.mhealthatlas.enterprisemanagement.config.web.KeycloakAuthenticationConverter}
   * as the {@code JwtGrantedAuthoritiesConverter}.
   *
   * @return the configured {@code JwtAuthenticationConverter}
   */
  JwtAuthenticationConverter jwtAuthenticationConverter() {
    KeycloakAuthenticationConverter grantedAuthoritiesConverter = new KeycloakAuthenticationConverter();
    grantedAuthoritiesConverter.setAuthorityPrefix("ROLE_");

    JwtAuthenticationConverter jwtAuthenticationConverter = new JwtAuthenticationConverter();
    jwtAuthenticationConverter.setJwtGrantedAuthoritiesConverter(grantedAuthoritiesConverter);
    return jwtAuthenticationConverter;
  }
}
