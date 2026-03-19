package com.example.pfas.readiness;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

public record ExpansionReadinessReport(
	@JsonProperty("schema_version") String schemaVersion,
	@JsonProperty("generated_at") String generatedAt,
	@JsonProperty("ready_state_routes") int readyStateRoutes,
	@JsonProperty("blocked_state_routes") int blockedStateRoutes,
	@JsonProperty("ready_public_water_routes") int readyPublicWaterRoutes,
	@JsonProperty("blocked_public_water_routes") int blockedPublicWaterRoutes,
	@JsonProperty("items") List<ExpansionReadinessItem> items
) {
}
