package com.example.pfas.merchant;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "pfas.merchant-clicks")
public record PfasMerchantClickProperties(String root) {
}
