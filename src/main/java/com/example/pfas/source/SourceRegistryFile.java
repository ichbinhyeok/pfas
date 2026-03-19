package com.example.pfas.source;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public record SourceRegistryFile(
	@JsonProperty("schema_version") String schemaVersion,
	@JsonProperty("generated_at") String generatedAt,
	@JsonProperty("documents") List<SourceDocument> documents
) {
}
