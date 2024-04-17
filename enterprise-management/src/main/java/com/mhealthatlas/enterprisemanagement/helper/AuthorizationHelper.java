package com.mhealthatlas.enterprisemanagement.helper;

import org.springframework.security.core.Authentication;

/**
 * Utility class to validate that an user has the needed roles and group
 * assigned.
 */
public class AuthorizationHelper {
  /**
   * Checks if an user has the given authority.
   *
   * @param authentication the authorities of the user
   * @param authority      the needed authority
   * @return {@code True} if the user has the given authority;<br>
   *         {@code False} otherwise;
   */
  public static Boolean hasAuthority(Authentication authentication, String authority) {
    if (authority == null) {
      return false;
    }

    return authentication.getAuthorities().stream().anyMatch(x -> x.getAuthority().equals(authority));
  }

  /**
   * Checks if an user has all given authorities.
   *
   * @param authentication the authorities of the user
   * @param authorities    the needed authorities
   * @return {@code True} if the user has all given authorities;<br>
   *         {@code False} otherwise;
   */
  public static Boolean hasAllAuthorities(Authentication authentication, String... authorities) {
    for (String authority : authorities) {
      if (!hasAuthority(authentication, authority)) {
        return false;
      }
    }
    return true;
  }

  /**
   * Checks if an user has any of the given authorities.
   *
   * @param authentication the authorities of the user
   * @param authorities    the authorities
   * @return {@code True} if the user has any of the given authorities;<br>
   *         {@code False} otherwise;
   */
  public static Boolean hasAnyAuthorities(Authentication authentication, String... authorities) {
    for (String authority : authorities) {
      if (hasAuthority(authentication, authority)) {
        return true;
      }
    }
    return false;
  }
}
