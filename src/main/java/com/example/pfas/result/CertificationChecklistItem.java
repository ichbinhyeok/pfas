package com.example.pfas.result;

import com.fasterxml.jackson.annotation.JsonProperty;

public record CertificationChecklistItem(
	@JsonProperty("label") String label,
	@JsonProperty("required") boolean required,
	@JsonProperty("detail") String detail,
	@JsonProperty("source_id") String sourceId
) {
}
