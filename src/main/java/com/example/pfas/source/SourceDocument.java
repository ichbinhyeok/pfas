package com.example.pfas.source;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public record SourceDocument(
	@JsonProperty("source_id") String sourceId,
	@JsonProperty("organization") String organization,
	@JsonProperty("title") String title,
	@JsonProperty("url") String url,
	@JsonProperty("source_kind") String sourceKind,
	@JsonProperty("trust_tier") int trustTier,
	@JsonProperty("jurisdiction") String jurisdiction,
	@JsonProperty("published_date") String publishedDate,
	@JsonProperty("last_updated_date") String lastUpdatedDate,
	@JsonProperty("retrieved_at") String retrievedAt,
	@JsonProperty("effective_date") String effectiveDate,
	@JsonProperty("allowed_uses") List<String> allowedUses,
	@JsonProperty("disallowed_uses") List<String> disallowedUses,
	@JsonProperty("notes") String notes
) {
}
