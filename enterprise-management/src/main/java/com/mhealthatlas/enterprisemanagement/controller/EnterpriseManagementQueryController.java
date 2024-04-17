package com.mhealthatlas.enterprisemanagement.controller;

import java.util.Optional;

import com.mhealthatlas.enterprisemanagement.dto.EnterpriseDetailDto;
import com.mhealthatlas.enterprisemanagement.dto.EnterprisesDto;
import com.mhealthatlas.enterprisemanagement.helper.AuthorizationHelper;
import com.mhealthatlas.enterprisemanagement.query.EnterpriseQueryService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;

/**
 * EnterpriseManagementQueryController is the class containing all API endpoints
 * for quering enterprise informations in the mHealthAtlas system.
 */
@Controller
@RequestMapping("/enterprise-management")
public class EnterpriseManagementQueryController {
  /** @hidden */
  @Autowired
  private EnterpriseQueryService enterpriseQueryService;
  // #region assigned rating endpoints:

  /**
   * Queries the enterprise management service database for all enterprises.
   * <p>
   * The method can be invoked with an HTTP GET request calling /enterprises
   * <p>
   * Only mHealthAtlas administrators are permitted to call this API endpoint.
   *
   * @return the found enterprises
   */
  @Operation(summary = "Get enterprises", security = {
      @SecurityRequirement(name = "bearer-key", scopes = { "Admin" }) })
  @ApiResponses(value = { @ApiResponse(responseCode = "200", description = "users", content = {
      @Content(mediaType = "application/json", schema = @Schema(implementation = EnterprisesDto.class)) }) })
  @GetMapping(value = "/enterprises")
  @ResponseStatus(HttpStatus.OK)
  @PreAuthorize("hasRole('ROLE_Admin')")
  @ResponseBody
  public ResponseEntity<EnterprisesDto> getEnterprises() {
    return new ResponseEntity<EnterprisesDto>(enterpriseQueryService.getEnterprises(), HttpStatus.OK);
  }

  /**
   * Queries the enterprise management service database by an enterprise name to
   * retrieve detailed enterprise informations.
   * <p>
   * The method can be invoked with an HTTP GET request calling
   * /enterprises/{name}
   * <p>
   * Only mHealthAtlas, health insurance and company administrators are permitted
   * to call this API endpoint. Health insurance and company administrators can
   * only call this API endpoint for "their" enterprise.
   *
   * @param name           the enterprise name; not null; required query parameter
   * @param authentication the authentication object, injected by spring security
   * @return 200 OK response containing the enterprise information if the
   *         enterprise was found;<br>
   *         404 NOT_FOUND response if the enterprise was not found;<br>
   *         403 FORBIDDEN response otherwise;
   */
  @Operation(summary = "Get enterprise details", security = {
      @SecurityRequirement(name = "bearer-key", scopes = { "Admin", "HI_Admin", "Company_Admin" }) })
  @ApiResponses(value = { @ApiResponse(responseCode = "200", description = "user details", content = {
      @Content(mediaType = "application/json", schema = @Schema(implementation = EnterpriseDetailDto.class)) }) })
  @GetMapping(value = "/enterprises/{name}")
  @ResponseStatus(HttpStatus.OK)
  @ResponseBody
  public ResponseEntity<EnterpriseDetailDto> getEnterprise(@PathVariable final String name,
      Authentication authentication) {
    if (!(AuthorizationHelper.hasAuthority(authentication, "ROLE_Admin")
        || (AuthorizationHelper.hasAnyAuthorities(authentication, "ROLE_HI_Admin", "ROLE_Company_Admin")
            && AuthorizationHelper.hasAuthority(authentication, name)))) {
      return new ResponseEntity<>(HttpStatus.FORBIDDEN);
    }

    Optional<EnterpriseDetailDto> enterprise = enterpriseQueryService.getEnterprise(name);

    if (enterprise.isEmpty()) {
      return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }
    return new ResponseEntity<EnterpriseDetailDto>(enterprise.get(), HttpStatus.OK);
  }
}
