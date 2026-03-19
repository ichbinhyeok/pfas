package com.example.pfas.derived;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

public record PageGenerationManifestFile(
	@JsonProperty("schema_version") String schemaVersion,
	@JsonProperty("generated_at") String generatedAt,
	@JsonProperty("model_count") int modelCount,
	@JsonProperty("models") List<PageGenerationManifestItem> models
) {
}
