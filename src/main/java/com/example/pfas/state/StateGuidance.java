package com.example.pfas.state;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public record StateGuidance(
	@JsonProperty("schema_version") String schemaVersion,
	@JsonProperty("state_code") String stateCode,
	@JsonProperty("agency_name") String agencyName,
	@JsonProperty("agency_url") String agencyUrl,
	@JsonProperty("private_well_guidance_url") String privateWellGuidanceUrl,
	@JsonProperty("pfas_guidance_url") String pfasGuidanceUrl,
	@JsonProperty("certified_lab_lookup_url") String certifiedLabLookupUrl,
	@JsonProperty("sampling_guidance_url") String samplingGuidanceUrl,
	@JsonProperty("repeat_testing_guidance") String repeatTestingGuidance,
	@JsonProperty("benchmark_notes") String benchmarkNotes,
	@JsonProperty("last_verified_date") String lastVerifiedDate,
	@JsonProperty("source_ids") List<String> sourceIds
) {
}
