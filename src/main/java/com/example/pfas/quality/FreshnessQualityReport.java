package com.example.pfas.quality;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

public record FreshnessQualityReport(
	@JsonProperty("schema_version") String schemaVersion,
	@JsonProperty("generated_at") String generatedAt,
	@JsonProperty("source_document_count") int sourceDocumentCount,
	@JsonProperty("stale_source_count") int staleSourceCount,
	@JsonProperty("indexable_route_count") int indexableRouteCount,
	@JsonProperty("stale_indexable_route_count") int staleIndexableRouteCount,
	@JsonProperty("low_source_count_route_count") int lowSourceCountRouteCount,
	@JsonProperty("unresolved_readiness_route_count") int unresolvedReadinessRouteCount,
	@JsonProperty("noindex_candidate_count") int noindexCandidateCount,
	@JsonProperty("stale_sources") List<FreshnessSourceFinding> staleSources,
	@JsonProperty("route_findings") List<FreshnessRouteFinding> routeFindings
) {
}
