package com.mhealthatlas.enterprisemanagement.query;

import java.util.Optional;

import com.mhealthatlas.enterprisemanagement.dto.EnterpriseDetailDto;
import com.mhealthatlas.enterprisemanagement.dto.EnterprisesDto;

/**
 * Contains functionalities for quering enterprise informations.
 */
public interface IEnterpriseQueryService {
  /**
   * Gets all enterprises.
   *
   * @return all enterprises
   */
  EnterprisesDto getEnterprises();

  /**
   * Gets an enterprise by the specified name.
   *
   * @param name the name of the enterprise
   * @return the detailed information about the enterprise, if the enterprise
   *         exists;<br>
   *         an empty {@code Optional} otherwise;
   */
  Optional<EnterpriseDetailDto> getEnterprise(String name);
}
