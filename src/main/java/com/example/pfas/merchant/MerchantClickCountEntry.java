package com.example.pfas.merchant;

import com.fasterxml.jackson.annotation.JsonProperty;

public record MerchantClickCountEntry(
	@JsonProperty("key") String key,
	@JsonProperty("count") long count
) {
}
