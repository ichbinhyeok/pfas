package com.example.pfas.site;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "pfas.site")
public record PfasSiteProperties(String baseUrl) {
}
