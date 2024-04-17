package com.mhealthatlas.enterprisemanagement.command;

import java.util.Optional;
import java.util.UUID;

import javax.transaction.Transactional;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mhealthatlas.enterprisemanagement.dto.DepartmentDto;
import com.mhealthatlas.enterprisemanagement.dto.EnterpriseEventDto;
import com.mhealthatlas.enterprisemanagement.dto.EnterpriseIdEventDto;
import com.mhealthatlas.enterprisemanagement.dto.EnterpriseUpdateDto;
import com.mhealthatlas.enterprisemanagement.dto.UserDetailEventDto;
import com.mhealthatlas.enterprisemanagement.dto.UserEventDto;
import com.mhealthatlas.enterprisemanagement.dto.UserIdEventDto;
import com.mhealthatlas.enterprisemanagement.model.Enterprise;
import com.mhealthatlas.enterprisemanagement.model.User;
import com.mhealthatlas.enterprisemanagement.repository.EnterpriseRepository;
import com.mhealthatlas.enterprisemanagement.repository.UserRepository;
import com.mhealthatlas.enterprisemanagement.services.KeycloakApiService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class EnterpriseCommandService implements IEnterpriseCommandService {

  @Autowired
  private ObjectMapper mapper;
  @Autowired
  private EnterpriseRepository enterpriseRepository;
  @Autowired
  private UserRepository userRepository;
  @Autowired
  private KeycloakApiService keycloakApiService;

  @Override
  @Transactional
  public void handleEnterpriseCreated(JsonNode enterpriseData) throws JsonProcessingException {
    EnterpriseEventDto enterprise = mapper.treeToValue(mapper.readTree(enterpriseData.asText()),
        EnterpriseEventDto.class);
    enterpriseRepository.save(new Enterprise(enterprise.getGroupId(), enterprise.getGroupName(),
        enterprise.getEnterpriseType(), enterprise.getGroupName(), null, null));
  }

  @Override
  @Transactional
  public Boolean handleEnterpriseUpdated(String enterpriseName, EnterpriseUpdateDto enterprise) {
    Optional<Enterprise> existingEnterprise = enterpriseRepository.findOneByName(enterpriseName);
    if (existingEnterprise.isPresent()) {
      existingEnterprise.get().setDisplayName(enterprise.getDisplayName());
      existingEnterprise.get().setDetails(enterprise.getDetails());
      enterpriseRepository.save(existingEnterprise.get());
      return true;
    }
    return false;
  }

  @Override
  @Transactional
  public void handleEnterpriseDeleted(JsonNode enterpriseData) throws JsonProcessingException {
    EnterpriseIdEventDto enterprise = mapper.treeToValue(mapper.readTree(enterpriseData.asText()),
        EnterpriseIdEventDto.class);
    if (enterpriseRepository.existsById(enterprise.getGroupId())) {
      enterpriseRepository.deleteById(enterprise.getGroupId());
    }
  }

  @Override
  @Transactional
  public void handleUserCreated(JsonNode userData) throws JsonProcessingException {
    UserEventDto user = mapper.treeToValue(mapper.readTree(userData.asText()), UserEventDto.class);
    Optional<JsonNode> userDetails = keycloakApiService.getUser(user.getUserId().toString());
    Optional<JsonNode> userGroups = keycloakApiService.getUserGroups(user.getUserId().toString());

    if (userGroups.isPresent() && userGroups.get().size() == 1 && userGroups.get().get(0).has("name")) {
      Optional<Enterprise> enterprise = enterpriseRepository
          .findOneByName(userGroups.get().get(0).get("name").asText());
      if (enterprise.isPresent()) {
        User newUser = new User(user.getUserId(), enterprise.get(), "", "", user.getUsername(), user.getEmail(), null);

        if (userDetails.isPresent() && userDetails.get().has("firstName") && userDetails.get().has("lastName")) {
          newUser.setFirstName(userDetails.get().get("firstName").asText());
          newUser.setLastName(userDetails.get().get("lastName").asText());
        }

        userRepository.save(newUser);
      }
    }
  }

  @Override
  @Transactional
  public void handleUserUpdated(JsonNode userData) throws JsonProcessingException {
    UserDetailEventDto user = mapper.treeToValue(mapper.readTree(userData.asText()), UserDetailEventDto.class);
    Optional<User> existingUser = userRepository.findById(user.getUserId());
    if (existingUser.isPresent()) {
      User u = existingUser.get();
      u.setFirstName(user.getFirstname());
      u.setLastName(user.getLastname());
      u.setEmail(user.getEmail());
      userRepository.save(u);
    }
  }

  @Override
  @Transactional
  public Boolean handleUserDepartmentUpdated(UUID userId, DepartmentDto department) {
    Optional<User> existingUser = userRepository.findById(userId);
    if (existingUser.isPresent()) {
      existingUser.get().setDepartment(department.getDepartment());
      userRepository.save(existingUser.get());
      return true;
    }
    return false;
  }

  @Override
  @Transactional
  public void handleUserDeleted(JsonNode userData) throws JsonProcessingException {
    UserIdEventDto user = mapper.treeToValue(mapper.readTree(userData.asText()), UserIdEventDto.class);
    if (userRepository.existsById(user.getUserId())) {
      userRepository.deleteById(user.getUserId());
    }
  }
}
