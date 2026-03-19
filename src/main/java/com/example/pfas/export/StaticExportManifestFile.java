package com.example.pfas.export;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

public record StaticExportManifestFile(
	@JsonProperty("schema_version") String schemaVersion,
	@JsonProperty("generated_at") String generatedAt,
	@JsonProperty("item_count") int itemCount,
	@JsonProperty("items") List<StaticExportManifestItem> items
) {
}
