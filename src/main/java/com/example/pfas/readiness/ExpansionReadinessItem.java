package com.example.pfas.readiness;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

public record ExpansionReadinessItem(
	@JsonProperty("route_type") String routeType,
	@JsonProperty("route_key") String routeKey,
	@JsonProperty("display_label") String displayLabel,
	@JsonProperty("status") ExpansionReadinessStatus status,
	@JsonProperty("source_count") int sourceCount,
	@JsonProperty("resolved_source_count") int resolvedSourceCount,
	@JsonProperty("observation_count") int observationCount,
	@JsonProperty("last_verified_date") String lastVerifiedDate,
	@JsonProperty("missing_signals") List<String> missingSignals
) {
}
