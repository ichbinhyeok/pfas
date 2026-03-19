package com.example.pfas.stateprofile;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public record StateBenchmarkProfileFile(
	@JsonProperty("schema_version") String schemaVersion,
	@JsonProperty("generated_at") String generatedAt,
	@JsonProperty("profiles") List<StateBenchmarkProfile> profiles
) {
}
