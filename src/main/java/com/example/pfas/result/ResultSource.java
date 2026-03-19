package com.example.pfas.result;

import com.fasterxml.jackson.annotation.JsonProperty;

public record ResultSource(
	@JsonProperty("source_id") String sourceId,
	@JsonProperty("organization") String organization,
	@JsonProperty("title") String title,
	@JsonProperty("url") String url,
	@JsonProperty("trust_tier") int trustTier
) {
}
