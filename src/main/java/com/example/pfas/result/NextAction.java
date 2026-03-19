package com.example.pfas.result;

import com.fasterxml.jackson.annotation.JsonProperty;

public record NextAction(
	@JsonProperty("code") String code,
	@JsonProperty("title") String title,
	@JsonProperty("summary") String summary,
	@JsonProperty("confidence") String confidence,
	@JsonProperty("scope_note") String scopeNote
) {
}
