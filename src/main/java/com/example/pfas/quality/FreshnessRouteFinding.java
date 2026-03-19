package com.example.pfas.quality;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

public record FreshnessRouteFinding(
	@JsonProperty("route_type") String routeType,
	@JsonProperty("route_key") String routeKey,
	@JsonProperty("primary_path") String primaryPath,
	@JsonProperty("last_verified_date") String lastVerifiedDate,
	@JsonProperty("source_count") int sourceCount,
	@JsonProperty("resolved_source_count") Integer resolvedSourceCount,
	@JsonProperty("noindex_candidate") boolean noindexCandidate,
	@JsonProperty("reasons") List<String> reasons
) {
}
