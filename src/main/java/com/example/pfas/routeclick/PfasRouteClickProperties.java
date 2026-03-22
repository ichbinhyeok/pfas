package com.example.pfas.routeclick;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "pfas.route-clicks")
public record PfasRouteClickProperties(String root) {
}
