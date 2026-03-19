package com.example.pfas.result;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

public record ReferenceContext(
	@JsonProperty("jurisdiction_code") String jurisdictionCode,
	@JsonProperty("profile_kind") String profileKind,
	@JsonProperty("primary_reference_label") String primaryReferenceLabel,
	@JsonProperty("comparability_mode") String comparabilityMode,
	@JsonProperty("summary") String summary,
	@JsonProperty("private_well_use_note") String privateWellUseNote,
	@JsonProperty("benchmark_lines") List<ReferenceBenchmarkLine> benchmarkLines,
	@JsonProperty("last_verified_date") String lastVerifiedDate
) {
}
