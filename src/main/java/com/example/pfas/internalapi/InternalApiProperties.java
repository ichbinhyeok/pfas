package com.example.pfas.internalapi;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "pfas.internal-api")
public record InternalApiProperties(String token, String username, String password) {
}
