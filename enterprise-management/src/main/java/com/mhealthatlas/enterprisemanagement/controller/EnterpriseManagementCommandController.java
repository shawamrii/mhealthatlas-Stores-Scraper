package com.mhealthatlas.enterprisemanagement.controller;

import java.util.Optional;
import java.util.UUID;

import com.fasterxml.jackson.databind.JsonNode;
import com.mhealthatlas.enterprisemanagement.command.EnterpriseCommandService;
import com.mhealthatlas.enterprisemanagement.dto.DepartmentDto;
import com.mhealthatlas.enterprisemanagement.dto.EnterpriseDto;
import com.mhealthatlas.enterprisemanagement.dto.EnterpriseUpdateDto;
import com.mhealthatlas.enterprisemanagement.dto.UserDto;
import com.mhealthatlas.enterprisemanagement.dto.UserUpdateDto;
import com.mhealthatlas.enterprisemanagement.helper.AuthorizationHelper;
import com.mhealthatlas.enterprisemanagement.services.KeycloakApiService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;

/**
 * EnterpriseManagementCommandController is the class containing all API
 * endpoints for mutating enterprise informations.
 */
@Controller
@RequestMapping("/enterprise-management")
public class EnterpriseManagementCommandController {
  /** @hidden */
  @Autowired
  private KeycloakApiService apiServices;
  /** @hidden */
  @Autowired
  private EnterpriseCommandService enterpriseCommandService;

  // #region enterprise
  /**
   * Creates a new enterprise.
   * <p>
   * The method can be invoked with an HTTP POST request calling /enterprises
   * <p>
   * Only mHealthAtlas administrators can access the API endpoint.
   *
   * @param group the enterprise data; not null; required request body parameter
   * @return 201 CREATED response, if the enterprise was created successfully;<br>
   *         500 INTERNAL_SERVER_ERROR otherwise;
   */
  @Operation(summary = "Create Enterprise", security = {
      @SecurityRequirement(name = "bearer-key", scopes = { "Admin" }) })
  @io.swagger.v3.oas.annotations.parameters.RequestBody(description = "enterprise data", required = true, content = {
      @Content(mediaType = "application/json", schema = @Schema(implementation = EnterpriseDto.class)) })
  @PostMapping(value = "/enterprises")
  @PreAuthorize("hasRole('ROLE_Admin')")
  @ResponseStatus(HttpStatus.CREATED)
  @ResponseBody
  public ResponseEntity<Void> postEnterprise(@RequestBody EnterpriseDto group) {
    Boolean success = apiServices.createGroup(group);
    if (success) {
      return new ResponseEntity<>(HttpStatus.CREATED);
    }
    return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
  }

  /**
   * Updates an existing enterprise.
   * <p>
   * The method can be invoked with an HTTP POST request calling
   * /enterprises/{name}
   * <p>
   * Only mHealthAtlas, health insurance and company administrators are permitted
   * to call this API endpoint. Health insurance and company administrators can
   * only call this API endpoint for "their" enterprise.
   *
   * @param name           the enterprise name; not null; request path parameter
   * @param enterprise     the enterprise data; not null; required request body
   *                       parameter
   * @param authentication the authentication object, injected by spring security
   * @return 200 OK response, if the enterprise was updated successfully;<br>
   *         422 UNPROCESSABLE_ENTITY otherwise;
   */
  @Operation(summary = "Update Enterprise", security = {
      @SecurityRequirement(name = "bearer-key", scopes = { "Admin", "HI_Admin", "Company_Admin" }) })
  @io.swagger.v3.oas.annotations.parameters.RequestBody(description = "enterprise data", required = true, content = {
      @Content(mediaType = "application/json", schema = @Schema(implementation = EnterpriseDto.class)) })
  @PostMapping(value = "/enterprises/{name}")
  @ResponseStatus(HttpStatus.OK)
  @ResponseBody
  public ResponseEntity<Void> updateEnterprise(@PathVariable final String name,
      @RequestBody EnterpriseUpdateDto enterprise, Authentication authentication) {
    if (!(AuthorizationHelper.hasAuthority(authentication, "ROLE_Admin")
        || (AuthorizationHelper.hasAnyAuthorities(authentication, "ROLE_HI_Admin", "ROLE_Company_Admin")
            && AuthorizationHelper.hasAuthority(authentication, name)))) {
      return new ResponseEntity<>(HttpStatus.FORBIDDEN);
    }

    Boolean success = enterpriseCommandService.handleEnterpriseUpdated(name, enterprise);
    if (success) {
      return new ResponseEntity<>(HttpStatus.OK);
    }
    return new ResponseEntity<>(HttpStatus.UNPROCESSABLE_ENTITY);
  }

  /**
   * Deletes an existing enterprise.
   * <p>
   * The method can be invoked with an HTTP DELETE request calling
   * /enterprises/{name}
   * <p>
   * Only mHealthAtlas, health insurance and company administrators are permitted
   * to call this API endpoint. Health insurance and company administrators can
   * only call this API endpoint for "their" enterprise.
   *
   * @param name           the enterprise name; not null; request path parameter
   * @param authentication the authentication object, injected by spring security
   * @return 200 OK response, if the enterprise was deleted successfully;<br>
   *         422 UNPROCESSABLE_ENTITY, if the enterprise is not found;<br>
   *         500 INTERNAL_SERVER_ERROR otherwise;
   */
  @Operation(summary = "Delete Enterprise", security = {
      @SecurityRequirement(name = "bearer-key", scopes = { "Admin", "HI_Admin", "Company_Admin" }) })
  @DeleteMapping(value = "/enterprises/{name}")
  @ResponseStatus(HttpStatus.OK)
  @ResponseBody
  public ResponseEntity<Void> deleteEnterprise(@PathVariable final String name, Authentication authentication) {
    if (!(AuthorizationHelper.hasAuthority(authentication, "ROLE_Admin")
        || (AuthorizationHelper.hasAnyAuthorities(authentication, "ROLE_HI_Admin", "ROLE_Company_Admin")
            && AuthorizationHelper.hasAuthority(authentication, name)))) {
      return new ResponseEntity<>(HttpStatus.FORBIDDEN);
    }

    Optional<UUID> id = getGroupId(name);
    if (id.isEmpty()) {
      return new ResponseEntity<>(HttpStatus.UNPROCESSABLE_ENTITY);
    }

    Boolean success = apiServices.deleteGroup(id.get());
    if (success) {
      return new ResponseEntity<>(HttpStatus.OK);
    }
    return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
  }

  // #endregion

  // #region user

  /**
   * Creates a new enterprise administrator.
   * <p>
   * The method can be invoked with an HTTP POST request calling
   * /enterprises/{name}/admins
   * <p>
   * Only mHealthAtlas administrators are permitted to call this API endpoint.
   *
   * @param name the enterprise name; not null; request path parameter
   * @param user the user data; not null; required request body parameter
   * @return 201 CREATED response, if the enterprise administrator was created
   *         successfully;<br>
   *         422 UNPROCESSABLE_ENTITY, if the enterprise is not found;<br>
   *         500 INTERNAL_SERVER_ERROR otherwise;
   */
  @Operation(summary = "Create admin", security = { @SecurityRequirement(name = "bearer-key", scopes = { "Admin" }) })
  @io.swagger.v3.oas.annotations.parameters.RequestBody(description = "user data", required = true, content = {
      @Content(mediaType = "application/json", schema = @Schema(implementation = UserDto.class)) })
  @PostMapping(value = "/enterprises/{name}/admins")
  @PreAuthorize("hasRole('ROLE_Admin')")
  @ResponseStatus(HttpStatus.CREATED)
  @ResponseBody
  public ResponseEntity<Void> postAdmin(@PathVariable final String name, @RequestBody UserDto user) {
    if (user.getEnterprise() == null || !user.getEnterprise().equals(name)) {
      return new ResponseEntity<>(HttpStatus.UNPROCESSABLE_ENTITY);
    }

    Optional<UUID> userId = apiServices.createUser(user);
    if (userId.isEmpty()) {
      return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
    apiServices.createUserRole(userId.get(), user);
    return new ResponseEntity<>(HttpStatus.CREATED);
  }

  /**
   * Creates a new enterprise user.
   * <p>
   * The method can be invoked with an HTTP POST request calling
   * /enterprises/{name}/users
   * <p>
   * Only mHealthAtlas, health insurance and company administrators are permitted
   * to call this API endpoint. Health insurance and company administrators can
   * only call this API endpoint for "their" enterprise.
   *
   * @param name           the enterprise name; not null; request path parameter
   * @param user           the user data; not null; required request body
   *                       parameter
   * @param authentication the authentication object, injected by spring security
   * @return 201 CREATED response, if the enterprise user was created
   *         successfully;<br>
   *         422 UNPROCESSABLE_ENTITY, if the enterprise is not found;<br>
   *         500 INTERNAL_SERVER_ERROR otherwise;
   */
  @Operation(summary = "Create user", security = {
      @SecurityRequirement(name = "bearer-key", scopes = { "HI_Admin", "Company_Admin" }) })
  @io.swagger.v3.oas.annotations.parameters.RequestBody(description = "user data", required = true, content = {
      @Content(mediaType = "application/json", schema = @Schema(implementation = UserDto.class)) })
  @PostMapping(value = "/enterprises/{name}/users")
  @ResponseStatus(HttpStatus.CREATED)
  @ResponseBody
  public ResponseEntity<Void> postUser(@PathVariable final String name, @RequestBody UserDto user,
      Authentication authentication) {
    if (!(AuthorizationHelper.hasAnyAuthorities(authentication, "ROLE_HI_Admin", "ROLE_Company_Admin")
        && AuthorizationHelper.hasAuthority(authentication, name))) {
      return new ResponseEntity<>(HttpStatus.FORBIDDEN);
    }

    if (user.getEnterprise() == null || !user.getEnterprise().equals(name)) {
      return new ResponseEntity<>(HttpStatus.UNPROCESSABLE_ENTITY);
    }

    Optional<UUID> userId = apiServices.createUser(user);
    if (userId.isPresent()) {
      return new ResponseEntity<>(HttpStatus.CREATED);
    }
    return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
  }

  /**
   * Updates an existing enterprise user.
   * <p>
   * The method can be invoked with an HTTP POST request calling
   * /enterprises/{name}/users/{userId}
   * <p>
   * Only mHealthAtlas, health insurance and company administrators and enterprise
   * users are permitted to call this API endpoint. Health insurance and company
   * administrators can only call this API endpoint for "their" enterprise.
   * Enterprise users can only call this API endpoint for "themseelf".
   *
   * @param name           the enterprise name; not null; request path parameter
   * @param userId         the user id; not null; request path parameter
   * @param user           the user data; not null; required request body
   *                       parameter
   * @param authentication the authentication object, injected by spring security
   * @return 200 OK response, if the enterprise user was updated successfully;<br>
   *         422 UNPROCESSABLE_ENTITY, if the enterprise or the user is not
   *         found;<br>
   *         500 INTERNAL_SERVER_ERROR otherwise;
   */
  @Operation(summary = "Update user", security = {
      @SecurityRequirement(name = "bearer-key", scopes = { "Admin", "HI_Admin", "Company_Admin", "Own User Id" }) })
  @io.swagger.v3.oas.annotations.parameters.RequestBody(description = "user data", required = true, content = {
      @Content(mediaType = "application/json", schema = @Schema(implementation = UserDto.class)) })
  @PostMapping(value = "/enterprises/{name}/users/{userId}")
  @ResponseStatus(HttpStatus.OK)
  @ResponseBody
  public ResponseEntity<Void> updateUser(@PathVariable final String name, @PathVariable final UUID userId,
      @RequestBody UserUpdateDto user, Authentication authentication) {
    if (!(authentication.getName().equals(userId.toString())
        || (AuthorizationHelper.hasAnyAuthorities(authentication, "ROLE_HI_Admin", "ROLE_Company_Admin")
            && AuthorizationHelper.hasAuthority(authentication, name)))) {
      return new ResponseEntity<>(HttpStatus.FORBIDDEN);
    }

    Optional<String> userGroup = getUserGroup(userId);
    if (name == null || userGroup.isEmpty() || !userGroup.get().equals(name)) {
      return new ResponseEntity<>(HttpStatus.UNPROCESSABLE_ENTITY);
    }

    if (!userId.toString().equals(user.getUserId().toString())) {
      return new ResponseEntity<>(HttpStatus.UNPROCESSABLE_ENTITY);
    }

    Boolean success = apiServices.updateUser(user);
    if (success) {
      return new ResponseEntity<>(HttpStatus.OK);
    }
    return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
  }

  /**
   * Updates an existing enterprise users department.
   * <p>
   * The method can be invoked with an HTTP POST request calling
   * /enterprises/{name}/users/{userId}/department
   * <p>
   * Only mHealthAtlas, health insurance and company administrators are permitted
   * to call this API endpoint. Health insurance and company administrators can
   * only call this API endpoint for "their" enterprise.
   *
   * @param name           the enterprise name; not null; request path parameter
   * @param userId         the user id; not null; request path parameter
   * @param department     the department data; not null; required request body
   *                       parameter
   * @param authentication the authentication object, injected by spring security
   * @return 200 OK response, if the enterprise user department was updated
   *         successfully;<br>
   *         422 UNPROCESSABLE_ENTITY, if the enterprise is not found;<br>
   *         500 INTERNAL_SERVER_ERROR otherwise;
   */
  @Operation(summary = "Update user department", security = {
      @SecurityRequirement(name = "bearer-key", scopes = { "Admin", "HI_Admin", "Company_Admin" }) })
  @io.swagger.v3.oas.annotations.parameters.RequestBody(description = "user department data", required = true, content = {
      @Content(mediaType = "application/json", schema = @Schema(implementation = DepartmentDto.class)) })
  @PostMapping(value = "/enterprises/{name}/users/{userId}/department")
  @ResponseStatus(HttpStatus.OK)
  @ResponseBody
  public ResponseEntity<Void> updateUserDepartment(@PathVariable final String name, @PathVariable final UUID userId,
      @RequestBody DepartmentDto department, Authentication authentication) {
    if (!(AuthorizationHelper.hasAnyAuthorities(authentication, "ROLE_HI_Admin", "ROLE_Company_Admin")
        && AuthorizationHelper.hasAuthority(authentication, name))) {
      return new ResponseEntity<>(HttpStatus.FORBIDDEN);
    }

    Optional<String> userGroup = getUserGroup(userId);
    if (name == null || userGroup.isEmpty() || !userGroup.get().equals(name)) {
      return new ResponseEntity<>(HttpStatus.UNPROCESSABLE_ENTITY);
    }

    Boolean success = enterpriseCommandService.handleUserDepartmentUpdated(userId, department);
    if (success) {
      return new ResponseEntity<>(HttpStatus.OK);
    }
    return new ResponseEntity<>(HttpStatus.UNPROCESSABLE_ENTITY);
  }

  /**
   * Deletes an existing enterprise user.
   * <p>
   * The method can be invoked with an HTTP DELETE request calling
   * /enterprises/{name}/users/{userId}
   * <p>
   * Only mHealthAtlas, health insurance and company administrators and enterprise
   * users are permitted to call this API endpoint. Health insurance and company
   * administrators can only call this API endpoint for "their" enterprise.
   * Enterprise users can only call this API endpoint for "themseelf"
   *
   * @param name           the enterprise name; not null; request path parameter
   * @param userId         the user id; not null; request path parameter
   * @param authentication the authentication object, injected by spring security
   * @return 200 OK response, if the enterprise user department was deleted
   *         successfully;<br>
   *         422 UNPROCESSABLE_ENTITY, if the enterprise is not found;<br>
   *         500 INTERNAL_SERVER_ERROR otherwise;
   */
  @Operation(summary = "Delete user", security = {
      @SecurityRequirement(name = "bearer-key", scopes = { "Admin", "HI_Admin", "Company_Admin", "Own User Id" }) })
  @DeleteMapping(value = "/enterprises/{name}/users/{userId}")
  @ResponseStatus(HttpStatus.OK)
  @ResponseBody
  public ResponseEntity<Void> deleteUser(@PathVariable final String name, @PathVariable final UUID userId,
      Authentication authentication) {
    if (!(authentication.getName().equals(userId.toString())
        || (AuthorizationHelper.hasAnyAuthorities(authentication, "ROLE_HI_Admin", "ROLE_Company_Admin")
            && AuthorizationHelper.hasAuthority(authentication, name)))) {
      return new ResponseEntity<>(HttpStatus.FORBIDDEN);
    }

    Optional<String> userGroup = getUserGroup(userId);
    if (name == null || userGroup.isEmpty() || !userGroup.get().equals(name)) {
      return new ResponseEntity<>(HttpStatus.UNPROCESSABLE_ENTITY);
    }

    Boolean success = apiServices.deleteUser(userId);

    if (success) {
      return new ResponseEntity<>(HttpStatus.OK);
    }
    return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
  }

  // #endregion

  /**
   * Utility method to get the user enterprise name of the user.
   *
   * @param userId the user id
   * @return the user enterprise group, if the user exists and is assigned to any
   *         enterprise;<br>
   *         an empty {@code Optional} otherwise;
   */
  private Optional<String> getUserGroup(UUID userId) {
    Optional<JsonNode> userGroups = apiServices.getUserGroups(userId.toString());

    if (userGroups.isPresent() && userGroups.get().size() == 1 && userGroups.get().get(0).has("name")) {
      return Optional.of(userGroups.get().get(0).get("name").asText());
    }
    return Optional.empty();
  }

  /**
   * Utility method to get a enterprise id by name.
   *
   * @param name the enterprise name
   * @return the enterprise id, if the enterprise exists;<br>
   *         an empty {@code Optional} otherwise;
   */
  private Optional<UUID> getGroupId(String name) {
    Optional<JsonNode> groups = apiServices.getGroupsByName(name);
    if (groups.isPresent() && groups.get().isArray()) {
      for (JsonNode group : groups.get()) {
        if (group.has("id") && group.has("name") && group.get("name").asText().equals(name)) {
          return Optional.of(UUID.fromString(group.get("id").asText()));
        }
      }
    }
    return Optional.empty();
  }
}
