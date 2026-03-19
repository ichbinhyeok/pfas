package com.example.pfas.derived;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

public record RouteManifestRoute(
	@JsonProperty("route_type") String routeType,
	@JsonProperty("route_key") String routeKey,
	@JsonProperty("display_label") String displayLabel,
	@JsonProperty("template_kind") String templateKind,
	@JsonProperty("primary_path") String primaryPath,
	@JsonProperty("supporting_path") String supportingPath,
	@JsonProperty("api_path") String apiPath,
	@JsonProperty("indexable") boolean indexable,
	@JsonProperty("last_verified_date") String lastVerifiedDate,
	@JsonProperty("source_count") int sourceCount,
	@JsonProperty("readiness_basis") String readinessBasis,
	@JsonProperty("keywords") List<String> keywords
) {
}
