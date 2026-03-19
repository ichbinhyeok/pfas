package com.example.pfas.stateprofile;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public record StateBenchmarkLine(
	@JsonProperty("contaminant_code") String contaminantCode,
	@JsonProperty("label") String label,
	@JsonProperty("benchmark_display") String benchmarkDisplay,
	@JsonProperty("unit") String unit,
	@JsonProperty("benchmark_type") String benchmarkType,
	@JsonProperty("applicability") String applicability,
	@JsonProperty("note") String note
) {
}
