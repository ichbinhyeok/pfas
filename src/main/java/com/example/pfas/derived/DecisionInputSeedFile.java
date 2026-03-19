package com.example.pfas.derived;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

public record DecisionInputSeedFile(
	@JsonProperty("schema_version") String schemaVersion,
	@JsonProperty("generated_at") String generatedAt,
	@JsonProperty("input_count") int inputCount,
	@JsonProperty("inputs") List<DecisionInputSeed> inputs
) {
}
