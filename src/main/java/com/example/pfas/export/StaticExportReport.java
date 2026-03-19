package com.example.pfas.export;

import com.fasterxml.jackson.annotation.JsonProperty;

public record StaticExportReport(
	@JsonProperty("schema_version") String schemaVersion,
	@JsonProperty("generated_at") String generatedAt,
	@JsonProperty("output_root") String outputRoot,
	@JsonProperty("item_count") int itemCount
) {
}
