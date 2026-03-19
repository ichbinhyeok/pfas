package com.example.pfas.data;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "pfas.data")
public record PfasDataProperties(String root) {
}
