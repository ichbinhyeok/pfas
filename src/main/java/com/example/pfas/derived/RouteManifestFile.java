package com.example.pfas.derived;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

public record RouteManifestFile(
	@JsonProperty("schema_version") String schemaVersion,
	@JsonProperty("generated_at") String generatedAt,
	@JsonProperty("route_count") int routeCount,
	@JsonProperty("indexable_route_count") int indexableRouteCount,
	@JsonProperty("routes") List<RouteManifestRoute> routes
) {
}
