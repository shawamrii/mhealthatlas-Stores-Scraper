package com.mhealthatlas.gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;

/**
 * The entry point of the application.
 */
@SpringBootApplication
public class GatewayApplication {

  /**
   * Starts the application using the spring startup routine.
   *
   * @param args command line arguments
   */
  public static void main(String[] args) {
    SpringApplication.run(GatewayApplication.class, args);
  }

  /**
   * Configures the route mappings. Uses a load balancer to resolve the service
   * names.
   *
   * @param builder the route locator builder
   * @return the build routes
   */
  @Bean
  public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
    return builder.routes().route("apps", r -> r.path("/mhealthatlas/apps/**").uri("lb://mhealthatlas-apps"))

        .route("ratings", r -> r.path("/mhealthatlas/ratings/**").uri("lb://mhealthatlas-rating"))

        .route("taxonomies", r -> r.path("/mhealthatlas/taxonomies/**").uri("lb://mhealthatlas-taxonomy"))

        .route("user-management",
            r -> r.path("/mhealthatlas/user-management/**").uri("lb://mhealthatlas-user-management"))

        .route("enterprise-management",
            r -> r.path("/mhealthatlas/enterprise-management/**").uri("lb://enterprise-management"))

        .route("mhealthatlas-users", r -> r.path("/mhealthatlas/mhealthatlas-users/**").uri("lb://mhealthatlas-users"))

        .route("enterprise-apps", r -> r.path("/mhealthatlas/enterprise-apps/**").uri("lb://enterprise-apps"))

        .build();
  }
}
