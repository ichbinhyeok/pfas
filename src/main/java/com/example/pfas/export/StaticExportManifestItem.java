package com.example.pfas.export;

import com.fasterxml.jackson.annotation.JsonProperty;

public record StaticExportManifestItem(
	@JsonProperty("path") String path,
	@JsonProperty("output_path") String outputPath,
	@JsonProperty("content_kind") String contentKind,
	@JsonProperty("indexable") boolean indexable,
	@JsonProperty("source_kind") String sourceKind,
	@JsonProperty("last_verified_date") String lastVerifiedDate
) {
}
