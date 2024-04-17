package com.mhealthatlas.enterprisemanagement.services;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import javax.annotation.PostConstruct;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mhealthatlas.enterprisemanagement.dto.EnterpriseDto;
import com.mhealthatlas.enterprisemanagement.dto.UserDto;
import com.mhealthatlas.enterprisemanagement.dto.UserUpdateDto;
import com.mhealthatlas.enterprisemanagement.model.EnterpriseType;
import com.mhealthatlas.enterprisemanagement.model.Role;
import com.mhealthatlas.enterprisemanagement.properties.KeycloakProperties;

import org.apache.http.Header;
import org.apache.http.HttpHeaders;
import org.apache.http.HttpHost;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.DependsOn;
import org.springframework.stereotype.Service;

/**
 * Contains the methods which interacts with keycloak.
 */
@Service
@DependsOn("TlsConfiguration")
public class KeycloakApiService {
  /** @hidden */
  private HttpHost targetHost;
  /** @hidden */
  private CloseableHttpClient httpClient;

  /** @hidden */
  @Autowired
  private ObjectMapper mapper;
  /** @hidden */
  @Autowired
  private KeycloakProperties keycloakProperties;

  /**
   * instantiate the http client builder and set the default address to the
   * keycloak service url
   */
  @PostConstruct
  public void init() {
    targetHost = HttpHost.create(keycloakProperties.getBaseAddress());
    httpClient = HttpClientBuilder.create().build();
  }

  /**
   * Creates a HTTP GET request and gets the user data for the given user id from
   * keycloak.
   *
   * @param userId the user id
   * @return the returned user object from keycloak, if the request was
   *         successful;<br>
   *         an empty {@code Optional} otherwise;
   */
  public Optional<JsonNode> getUser(String userId) {
    Optional<String> accessToken = getAccessToken();
    if (accessToken.isEmpty()) {
      return Optional.empty();
    }

    try {
      HttpGet getUserRequest = new HttpGet(
          String.format("/auth/admin/realms/%s/users/%s", keycloakProperties.getRealmName(), userId));
      getUserRequest.setHeader(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken.get());
      getUserRequest.setHeader(HttpHeaders.CONTENT_TYPE, "application/json");

      CloseableHttpResponse userResponse = httpClient.execute(targetHost, getUserRequest);
      JsonNode user = mapper.readTree(userResponse.getEntity().getContent());
      userResponse.close();
      return Optional.of(user);
    } catch (Exception e) {
      e.printStackTrace();
      return Optional.empty();
    }
  }

  /**
   * Creates a HTTP GET request and gets the groups assigned to an user from
   * keycloak.
   *
   * @param userId the user id
   * @return the returned user groups object from keycloak, if the request was
   *         successful;<br>
   *         an empty {@code Optional} otherwise;
   */
  public Optional<JsonNode> getUserGroups(String userId) {
    Optional<String> accessToken = getAccessToken();
    if (accessToken.isEmpty()) {
      return Optional.empty();
    }

    try {
      HttpGet getUserGroupsRequest = new HttpGet(
          String.format("/auth/admin/realms/%s/users/%s/groups", keycloakProperties.getRealmName(), userId));
      getUserGroupsRequest.setHeader(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken.get());
      getUserGroupsRequest.setHeader(HttpHeaders.CONTENT_TYPE, "application/json");

      CloseableHttpResponse userGroupsResponse = httpClient.execute(targetHost, getUserGroupsRequest);
      JsonNode userGroups = mapper.readTree(userGroupsResponse.getEntity().getContent());
      userGroupsResponse.close();
      return Optional.of(userGroups);
    } catch (Exception e) {
      e.printStackTrace();
      return Optional.empty();
    }
  }

  /**
   * Creates a HTTP GET request and gets the group information from keycloak.
   *
   * @param groupId the group id
   * @return the returned group object from keycloak, if the request was
   *         successful;<br>
   *         an empty {@code Optional} otherwise;
   */
  public Optional<JsonNode> getGroup(String groupId) {
    Optional<String> accessToken = getAccessToken();
    if (accessToken.isEmpty()) {
      return Optional.empty();
    }

    try {
      HttpGet getGroupRequest = new HttpGet(
          String.format("/auth/admin/realms/%s/groups/%s", keycloakProperties.getRealmName(), groupId));
      getGroupRequest.setHeader(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken.get());
      getGroupRequest.setHeader(HttpHeaders.CONTENT_TYPE, "application/json");

      CloseableHttpResponse groupResponse = httpClient.execute(targetHost, getGroupRequest);
      JsonNode group = mapper.readTree(groupResponse.getEntity().getContent());
      groupResponse.close();
      return Optional.of(group);
    } catch (Exception e) {
      e.printStackTrace();
      return Optional.empty();
    }
  }

  /**
   * Creates a HTTP GET request and gets the group information from keycloak.
   *
   * @param name the group name
   * @return the returned group object from keycloak, if the request was
   *         successful;<br>
   *         an empty {@code Optional} otherwise;
   */
  public Optional<JsonNode> getGroupsByName(String name) {
    Optional<String> accessToken = getAccessToken();
    if (accessToken.isEmpty()) {
      return Optional.empty();
    }

    try {
      HttpGet getGroupRequest = new HttpGet(
          String.format("/auth/admin/realms/%s/groups?search=%s", keycloakProperties.getRealmName(), name));
      getGroupRequest.setHeader(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken.get());
      getGroupRequest.setHeader(HttpHeaders.CONTENT_TYPE, "application/json");

      CloseableHttpResponse groupResponse = httpClient.execute(targetHost, getGroupRequest);
      JsonNode group = mapper.readTree(groupResponse.getEntity().getContent());
      groupResponse.close();
      return Optional.of(group);
    } catch (Exception e) {
      e.printStackTrace();
      return Optional.empty();
    }
  }

  /**
   * Creates a HTTP GET request and gets the role information from keycloak.
   *
   * @param roleName the role name
   * @return the returned role object from keycloak, if the request was
   *         successful;<br>
   *         an empty {@code Optional} otherwise;
   */
  public Optional<JsonNode> getRoleByName(String roleName) {
    Optional<String> accessToken = getAccessToken();
    if (accessToken.isEmpty()) {
      return Optional.empty();
    }

    try {
      HttpGet getRoleRequest = new HttpGet(
          String.format("/auth/admin/realms/%s/roles/%s", keycloakProperties.getRealmName(), roleName));
      getRoleRequest.setHeader(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken.get());
      getRoleRequest.setHeader(HttpHeaders.CONTENT_TYPE, "application/json");

      CloseableHttpResponse roleResponse = httpClient.execute(targetHost, getRoleRequest);
      JsonNode role = mapper.readTree(roleResponse.getEntity().getContent());
      roleResponse.close();
      return Optional.of(role);
    } catch (Exception e) {
      e.printStackTrace();
      return Optional.empty();
    }
  }

  /**
   * Creates a HTTP POST request and add a new group to keycloak
   *
   * @param groupDto the group data
   * @return {@code True}, if the request was successful;<br>
   *         {@code False} otherwise;
   */
  public boolean createGroup(EnterpriseDto groupDto) {
    Optional<String> accessToken = getAccessToken();
    if (accessToken.isEmpty()) {
      return false;
    }

    try {
      HttpPost postGroupRequest = new HttpPost(
          String.format("/auth/admin/realms/%s/groups", keycloakProperties.getRealmName()));
      String group = String.format("{\"name\":\"%s\", \"attributes\":{\"enterprise_type\":[\"%s\"]}}",
          groupDto.getName(), groupDto.getType());
      StringEntity entity = new StringEntity(group);

      postGroupRequest.setHeader(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken.get());
      postGroupRequest.setHeader(HttpHeaders.CONTENT_TYPE, "application/json");
      postGroupRequest.setEntity(entity);
      CloseableHttpResponse groupResponse = httpClient.execute(targetHost, postGroupRequest);
      groupResponse.close();
      return true;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }
  }

  /**
   * Creates a HTTP DELETE request and remove an existing group from keycloak
   *
   * @param groupId the group id
   * @return {@code True}, if the request was successful;<br>
   *         {@code False} otherwise;
   */
  public boolean deleteGroup(UUID groupId) {
    Optional<String> accessToken = getAccessToken();
    if (accessToken.isEmpty()) {
      return false;
    }

    try {
      HttpDelete deleteGroupRequest = new HttpDelete(
          String.format("/auth/admin/realms/%s/groups/%s", keycloakProperties.getRealmName(), groupId));

      deleteGroupRequest.setHeader(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken.get());
      deleteGroupRequest.setHeader(HttpHeaders.CONTENT_TYPE, "application/json");

      CloseableHttpResponse groupResponse = httpClient.execute(targetHost, deleteGroupRequest);
      groupResponse.close();
      return true;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }
  }

  /**
   * Creates a HTTP POST request and insert a new user into keycloak
   *
   * @param userDto the user data
   * @return the user id, if the request was successful;<br>
   *         an empty {@code Optional} otherwise;
   */
  public Optional<UUID> createUser(UserDto userDto) {
    Optional<String> accessToken = getAccessToken();
    if (accessToken.isEmpty()) {
      return Optional.empty();
    }

    try {
      HttpPost postUserRequest = new HttpPost(
          String.format("/auth/admin/realms/%s/users", keycloakProperties.getRealmName()));
      String user = String.format(
          "{\"username\":\"%s\", \"firstName\":\"%s\", \"lastName\":\"%s\", \"email\":\"%s\", \"groups\":[\"%s\"], \"enabled\":true, \"credentials\":[{\"type\":\"password\", \"value\": \"%s\", \"temporary\":true}]}",
          userDto.getUsername(), userDto.getFirstname(), userDto.getLastname(), userDto.getEmail(),
          userDto.getEnterprise(), String.format("%s_%s", userDto.getEnterprise(), userDto.getUsername()));
      StringEntity entity = new StringEntity(user);

      postUserRequest.setHeader(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken.get());
      postUserRequest.setHeader(HttpHeaders.CONTENT_TYPE, "application/json");
      postUserRequest.setEntity(entity);
      CloseableHttpResponse userResponse = httpClient.execute(targetHost, postUserRequest);

      String resourcePathSeparator = "users/";
      Integer resourceIdLength = 36;
      UUID userId = null;
      for (Header header : userResponse.getAllHeaders()) {
        if (header.getName().equals("Location")) {
          Integer sepPos = header.getValue().indexOf(resourcePathSeparator);
          if (sepPos >= 0) {
            userId = UUID.fromString(header.getValue().substring(sepPos + resourcePathSeparator.length(),
                sepPos + resourcePathSeparator.length() + resourceIdLength));
            userResponse.close();
            return Optional.of(userId);
          }
        }
      }
      userResponse.close();
      return Optional.empty();
    } catch (Exception e) {
      e.printStackTrace();
      return Optional.empty();
    }
  }

  /**
   * Creates a HTTP PUT request and updates an existing user in keycloak
   *
   * @param userDto the new user data
   * @return {@code True}, if the request was successful;<br>
   *         {@code False} otherwise;
   */
  public boolean updateUser(UserUpdateDto userDto) {
    Optional<String> accessToken = getAccessToken();
    if (accessToken.isEmpty()) {
      return false;
    }

    try {
      HttpPut putUserRequest = new HttpPut(
          String.format("/auth/admin/realms/%s/users/%s", keycloakProperties.getRealmName(), userDto.getUserId()));
      String user = String.format(
          "{\"id\":\"%s\", \"username\":\"%s\", \"firstName\":\"%s\", \"lastName\":\"%s\", \"email\":\"%s\"}",
          userDto.getUserId(), userDto.getUsername(), userDto.getFirstname(), userDto.getLastname(),
          userDto.getEmail());
      StringEntity entity = new StringEntity(user);

      putUserRequest.setHeader(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken.get());
      putUserRequest.setHeader(HttpHeaders.CONTENT_TYPE, "application/json");
      putUserRequest.setEntity(entity);
      CloseableHttpResponse userResponse = httpClient.execute(targetHost, putUserRequest);
      userResponse.close();
      return true;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }
  }

  /**
   * Creates a HTTP DELETE request and deletes an existing user in keycloak.
   *
   * @param userId the user id
   * @return {@code True}, if the request was successful;<br>
   *         {@code False} otherwise;
   */
  public boolean deleteUser(UUID userId) {
    Optional<String> accessToken = getAccessToken();
    if (accessToken.isEmpty()) {
      return false;
    }

    try {
      HttpDelete deleteUserRequest = new HttpDelete(
          String.format("/auth/admin/realms/%s/users/%s", keycloakProperties.getRealmName(), userId));

      deleteUserRequest.setHeader(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken.get());
      deleteUserRequest.setHeader(HttpHeaders.CONTENT_TYPE, "application/json");

      CloseableHttpResponse userResponse = httpClient.execute(targetHost, deleteUserRequest);
      userResponse.close();
      return true;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }
  }

  /**
   * Creates a HTTP POST request and insert a new user role in keycloak.
   *
   * @param userId  the user id
   * @param userDto the user data
   * @return {@code True}, if the request was successful;<br>
   *         {@code False} otherwise;
   */
  public boolean createUserRole(UUID userId, UserDto userDto) {
    Optional<String> accessToken = getAccessToken();
    if (accessToken.isEmpty()) {
      return false;
    }

    Optional<JsonNode> userGroups = getUserGroups(userId.toString());
    if (userGroups.isEmpty() || userGroups.get().size() != 1 || !userGroups.get().get(0).has("id")) {
      return false;
    }

    String groupId = userGroups.get().get(0).get("id").asText();
    Optional<JsonNode> group = getGroup(groupId);
    if (group.isEmpty() || !group.get().has("attributes") || !group.get().get("attributes").has("enterprise_type")
        || group.get().get("attributes").get("enterprise_type").size() != 1) {
      return false;
    }

    EnterpriseType type = Enum.valueOf(EnterpriseType.class,
        group.get().get("attributes").get("enterprise_type").get(0).asText());

    Optional<JsonNode> role = getRoleByName(
        type == EnterpriseType.Company ? Role.Company_Admin.name() : Role.HI_Admin.name());
    if (role.isEmpty() || !role.get().has("id") || !role.get().has("name")) {
      return false;
    }

    try {
      HttpPost postUserRoleRequest = new HttpPost(String.format("/auth/admin/realms/%s/users/%s/role-mappings/realm",
          keycloakProperties.getRealmName(), userId.toString()));
      String userRole = String.format("[{\"id\":\"%s\", \"name\":\"%s\"}]", role.get().get("id").asText(),
          role.get().get("name").asText());
      StringEntity entity = new StringEntity(userRole);

      postUserRoleRequest.setHeader(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken.get());
      postUserRoleRequest.setHeader(HttpHeaders.CONTENT_TYPE, "application/json");
      postUserRoleRequest.setEntity(entity);
      CloseableHttpResponse userRoleResponse = httpClient.execute(targetHost, postUserRoleRequest);
      userRoleResponse.close();
      return true;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }
  }

  /**
   * Creates a HTTP POST request and receives an access token
   *
   * @return the received access token, if the request was successful;<br>
   *         an empty {@code Optional} otherwise;
   */
  private Optional<String> getAccessToken() {
    try {
      HttpPost accessTokenPostPostRequest = new HttpPost("/auth/realms/master/protocol/openid-connect/token");

      List<NameValuePair> nvp = new ArrayList<NameValuePair>();
      nvp.add(new BasicNameValuePair("grant_type", "client_credentials"));
      nvp.add(new BasicNameValuePair("client_id", "admin-cli"));
      nvp.add(new BasicNameValuePair("client_secret", keycloakProperties.getClientSecret()));
      accessTokenPostPostRequest.setEntity(new UrlEncodedFormEntity(nvp));
      accessTokenPostPostRequest.setHeader(HttpHeaders.CONTENT_TYPE, "application/x-www-form-urlencoded");

      CloseableHttpResponse response = httpClient.execute(targetHost, accessTokenPostPostRequest);
      JsonNode tokenResponse = mapper.readTree(response.getEntity().getContent());
      response.close();

      if (tokenResponse.has("access_token")) {
        return Optional.of(tokenResponse.get("access_token").asText());
      }
      return Optional.empty();
    } catch (Exception e) {
      e.printStackTrace();
      return Optional.empty();
    }
  }
}
