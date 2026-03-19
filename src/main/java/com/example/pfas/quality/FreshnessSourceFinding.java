package com.example.pfas.quality;

import com.fasterxml.jackson.annotation.JsonProperty;

public record FreshnessSourceFinding(
	@JsonProperty("source_id") String sourceId,
	@JsonProperty("title") String title,
	@JsonProperty("reference_date") String referenceDate,
	@JsonProperty("days_since_reference") long daysSinceReference,
	@JsonProperty("stale_reason") String staleReason
) {
}
