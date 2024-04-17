package com.mhealthatlas.enterprisemanagement.config.web.filter;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.web.filter.OncePerRequestFilter;

/**
 * Configure the Cross-Site-Request-Forgery token.
 */
public class CsrfTokenResponseHeaderBindingFilter extends OncePerRequestFilter {
  protected static final String REQUEST_ATTRIBUTE_NAME = "_csrf";
  protected static final String RESPONSE_TOKEN_NAME = "X-CSRF-TOKEN";

  /**
   * Injects the Cross-Site-Request-Forgery token parsed from the request in the
   * response header object and register the filter in the {@code filterChain}.
   *
   * @param request     the request object
   * @param response    the response object
   * @param filterChain the filter chain
   */
  @Override
  protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
      javax.servlet.FilterChain filterChain) throws ServletException, IOException {
    CsrfToken token = (CsrfToken) request.getAttribute(REQUEST_ATTRIBUTE_NAME);

    if (token != null) {
      response.setHeader(RESPONSE_TOKEN_NAME, token.getToken());
    }

    filterChain.doFilter(request, response);
  }
}
