package com.mhealthatlas.enterprisemanagement.config.web;

import com.mhealthatlas.enterprisemanagement.config.web.filter.CsrfTokenResponseHeaderBindingFilter;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.csrf.CsrfFilter;

/**
 * Configures the web security pipeline for the {@code /actuator/**} endpoints.
 * Registers the configured pipeline as {@code Order} 1 to bypass other filter
 * steps with more strict security requirements.
 */
@Configuration
@Order(1)
public class WebSecurityActuator extends WebSecurityConfigurerAdapter {

  /**
   * User name for the {@code Actuator} endpoints
   */
  @Value("${spring.security.user.name}")
  private String username;

  /**
   * Password for the {@code Actuator} endpoints
   */
  @Value("${spring.security.user.password}")
  private String password;

  /**
   * Authority which is needed to call the {@code Actuator} endpoints
   */
  @Value("${spring.security.user.roles}")
  private String roles;

  /**
   * Configures the security pipeline for the {@code Actuator} endpoints and
   * registers the configuration after the
   * {@link com.mhealthatlas.enterprisemanagement.config.web.filter.CsrfTokenResponseHeaderBindingFilter}
   * filter step.
   * <p>
   * A HTTP Basic authentication is configured for the {@code Actuator} endpoints.
   * Also the role {@code HEALTHCHECK} is needed to successfully authorize the
   * user.
   *
   * @param http the spring security configuration
   */
  @Override
  protected void configure(HttpSecurity http) throws Exception {
    http.addFilterAfter(new CsrfTokenResponseHeaderBindingFilter(), CsrfFilter.class).antMatcher("/actuator/**")
        .authorizeRequests().anyRequest().hasRole("HEALTHCHECK").and().sessionManagement()
        .sessionCreationPolicy(SessionCreationPolicy.STATELESS).and().httpBasic();
  }

  /**
   * Configures an in memory user authentication mechanismen. Only request are
   * authenticated which specifies an user name and a password matching the
   * {@link #username} and {@link #password} fields.
   *
   * @param auth the authentication manager builder
   */
  @Override
  protected void configure(AuthenticationManagerBuilder auth) throws Exception {
    auth.inMemoryAuthentication().withUser(username).password(String.format("{noop}%s", password)).roles(roles);
  }
}
