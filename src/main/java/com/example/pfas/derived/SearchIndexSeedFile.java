package com.example.pfas.derived;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

public record SearchIndexSeedFile(
	@JsonProperty("schema_version") String schemaVersion,
	@JsonProperty("generated_at") String generatedAt,
	@JsonProperty("document_count") int documentCount,
	@JsonProperty("documents") List<SearchIndexSeedDocument> documents
) {
}
