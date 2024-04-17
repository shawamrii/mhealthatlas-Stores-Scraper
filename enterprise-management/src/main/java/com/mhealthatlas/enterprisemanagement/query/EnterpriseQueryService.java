package com.mhealthatlas.enterprisemanagement.query;

import java.util.Optional;
import java.util.stream.Collectors;

import javax.transaction.Transactional;

import com.mhealthatlas.enterprisemanagement.dto.EnterpriseDetailDto;
import com.mhealthatlas.enterprisemanagement.dto.EnterpriseInfoDto;
import com.mhealthatlas.enterprisemanagement.dto.EnterprisesDto;
import com.mhealthatlas.enterprisemanagement.dto.UserDetailDto;
import com.mhealthatlas.enterprisemanagement.model.Enterprise;
import com.mhealthatlas.enterprisemanagement.repository.EnterpriseRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class EnterpriseQueryService implements IEnterpriseQueryService {
  /** @hidden */
  @Autowired
  EnterpriseRepository enterpriseRepository;

  @Override
  @Transactional
  public EnterprisesDto getEnterprises() {
    return new EnterprisesDto(enterpriseRepository.findAll().stream()
        .map(x -> new EnterpriseInfoDto(x.getName(), x.getDisplayName(), x.getType(), x.getDetails()))
        .collect(Collectors.toList()));
  }

  @Override
  @Transactional
  public Optional<EnterpriseDetailDto> getEnterprise(String name) {
    Optional<Enterprise> enterprise = enterpriseRepository.findOneByName(name);
    if (enterprise.isEmpty()) {
      return Optional.empty();
    }
    return Optional.of(new EnterpriseDetailDto(
        new EnterpriseInfoDto(enterprise.get().getName(), enterprise.get().getDisplayName(), enterprise.get().getType(),
            enterprise.get().getDetails()),
        enterprise.get().getUsers().stream().map(x -> new UserDetailDto(x.getId(), x.getUserName(), x.getFirstName(),
            x.getLastName(), x.getEmail(), x.getDepartment())).collect(Collectors.toList())));
  }
}
