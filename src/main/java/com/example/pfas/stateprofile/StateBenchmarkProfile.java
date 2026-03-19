package com.example.pfas.stateprofile;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public record StateBenchmarkProfile(
	@JsonProperty("state_code") String stateCode,
	@JsonProperty("profile_kind") String profileKind,
	@JsonProperty("primary_reference_label") String primaryReferenceLabel,
	@JsonProperty("comparability_mode") String comparabilityMode,
	@JsonProperty("summary") String summary,
	@JsonProperty("benchmarks") List<StateBenchmarkLine> benchmarks,
	@JsonProperty("private_well_use_note") String privateWellUseNote,
	@JsonProperty("last_verified_date") String lastVerifiedDate,
	@JsonProperty("source_ids") List<String> sourceIds
) {
}
