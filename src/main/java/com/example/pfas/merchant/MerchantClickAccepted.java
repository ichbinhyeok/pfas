package com.example.pfas.merchant;

import com.fasterxml.jackson.annotation.JsonProperty;

public record MerchantClickAccepted(
	@JsonProperty("accepted") boolean accepted,
	@JsonProperty("recorded_at") String recordedAt
) {
}
