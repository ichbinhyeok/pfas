package com.example.pfas.derived;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

public record SearchIndexSeedDocument(
	@JsonProperty("document_id") String documentId,
	@JsonProperty("route_type") String routeType,
	@JsonProperty("route_key") String routeKey,
	@JsonProperty("url") String url,
	@JsonProperty("title") String title,
	@JsonProperty("summary") String summary,
	@JsonProperty("last_verified_date") String lastVerifiedDate,
	@JsonProperty("indexable") boolean indexable,
	@JsonProperty("source_count") int sourceCount,
	@JsonProperty("keywords") List<String> keywords
) {
}
