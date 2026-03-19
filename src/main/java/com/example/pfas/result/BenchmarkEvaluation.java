package com.example.pfas.result;

import java.math.BigDecimal;

import com.fasterxml.jackson.annotation.JsonProperty;

public record BenchmarkEvaluation(
	@JsonProperty("analyte_code") String analyteCode,
	@JsonProperty("input_value") BigDecimal inputValue,
	@JsonProperty("input_unit") String inputUnit,
	@JsonProperty("normalized_value_ppt") BigDecimal normalizedValuePpt,
	@JsonProperty("matched_reference_label") String matchedReferenceLabel,
	@JsonProperty("matched_reference_display") String matchedReferenceDisplay,
	@JsonProperty("comparison_mode") String comparisonMode,
	@JsonProperty("benchmark_relation") String benchmarkRelation,
	@JsonProperty("note") String note
) {
}
