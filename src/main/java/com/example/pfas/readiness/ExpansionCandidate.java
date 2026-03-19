package com.example.pfas.readiness;

import com.fasterxml.jackson.annotation.JsonProperty;

public record ExpansionCandidate(
	@JsonProperty("route_type") String routeType,
	@JsonProperty("route_key") String routeKey,
	@JsonProperty("route_path") String routePath,
	@JsonProperty("display_label") String displayLabel,
	@JsonProperty("readiness_basis") String readinessBasis
) {
}
