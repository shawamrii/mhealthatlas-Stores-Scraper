package com.mhealthatlas.enterprisemanagement.config.web;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;

import org.springframework.core.convert.converter.Converter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;

import lombok.Setter;

/**
 * Convert the attribute of a JWT token into the corresponding java objects.
 */
public class KeycloakAuthenticationConverter implements Converter<Jwt, Collection<GrantedAuthority>> {
  /** Default user role authority prefix used by spring security */
  private static final String DEFAULT_AUTHORITY_PREFIX = "ROLE_";
  /**
   * Keycloak use the claim name {@code realm_access} in the JWT token to transfer
   * the authorities of the user
   */
  private static final String WELL_KNOWN_AUTHORITY_CLAIM_NAME = "realm_access";
  /**
   * Keycloak use in the {@code realm_access} claim the key name {@code roles} to
   * store the authorities of the user
   */
  private static final String WELL_KNOWN_AUTHORITY_KEY_NAME = "roles";
  /**
   * Keycloak use the claim name {@code groups} in the JWT token to transfer the
   * groups of the user
   */
  private static final String WELL_KNOWN_GROUP_CLAIM_NAME = "groups";

  /** @hidden */
  @Setter
  private String authorityPrefix = DEFAULT_AUTHORITY_PREFIX;
  /** @hidden */
  private String authorityClaimName = WELL_KNOWN_AUTHORITY_CLAIM_NAME;
  /** @hidden */
  private String authorityKeyName = WELL_KNOWN_AUTHORITY_KEY_NAME;
  /** @hidden */
  private String groupClaimName = WELL_KNOWN_GROUP_CLAIM_NAME;

  /**
   * Converts the authorities in the JWT token to a {@code GrantedAuthority}
   * collection.
   *
   * @param jwt the JWT token object
   * @return a {@code GrantedAuthority} collection containing all user roles and
   *         groups, if the user have any role or group;<br>
   *         an empty {@code GrantedAuthority} collection otherwise;
   */
  @Override
  public Collection<GrantedAuthority> convert(Jwt jwt) {
    Collection<GrantedAuthority> grantedAuthorities = new ArrayList<>();
    for (String authority : getAuthorities(jwt)) {
      grantedAuthorities.add(new SimpleGrantedAuthority(this.authorityPrefix + authority));
    }

    for (String group : getGroups(jwt)) {
      grantedAuthorities.add(new SimpleGrantedAuthority(group));
    }
    return grantedAuthorities;
  }

  /**
   * Parse the user roles from the jwt token and transform them into a
   * {@code String} collection. Each pared role is prefixed with the
   * {@link DEFAULT_AUTHORITY_PREFIX} to specify that this authority is a user
   * role.
   *
   * @param jwt the JWT token object
   * @return the parsed user roles, if the user have any role;<br>
   *         a empty {@code String} collection;
   */
  private Collection<String> getAuthorities(Jwt jwt) {
    if (this.authorityClaimName == null) {
      return Collections.emptyList();
    }

    Object authorities = jwt.getClaim(this.authorityClaimName);
    if (authorities instanceof HashMap) {
      HashMap<String, ArrayList<String>> authorityHashMap = ((HashMap<String, ArrayList<String>>) authorities);
      if (authorityHashMap.containsKey(this.authorityKeyName)) {
        return authorityHashMap.get(this.authorityKeyName);
      }
    }
    return Collections.emptyList();
  }

  /**
   * Parse the user groups from the jwt token and transform them into a
   * {@code String} collection.
   *
   * @param jwt the JWT token object
   * @return the parsed user groups, if the user have any group;<br>
   *         a empty {@code String} collection otherwise;
   */
  private Collection<String> getGroups(Jwt jwt) {
    if (this.groupClaimName == null) {
      return Collections.emptyList();
    }

    Object groups = jwt.getClaim(this.groupClaimName);
    if (groups instanceof ArrayList<?>) {
      return ((ArrayList<String>) groups);
    }
    return Collections.emptyList();
  }
}
