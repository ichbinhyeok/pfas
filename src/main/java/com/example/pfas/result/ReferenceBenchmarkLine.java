package com.example.pfas.result;

import com.fasterxml.jackson.annotation.JsonProperty;

public record ReferenceBenchmarkLine(
	@JsonProperty("contaminant_code") String contaminantCode,
	@JsonProperty("label") String label,
	@JsonProperty("benchmark_display") String benchmarkDisplay,
	@JsonProperty("unit") String unit,
	@JsonProperty("benchmark_type") String benchmarkType,
	@JsonProperty("applicability") String applicability,
	@JsonProperty("note") String note
) {
}
