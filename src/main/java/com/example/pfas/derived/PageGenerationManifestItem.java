package com.example.pfas.derived;

import com.fasterxml.jackson.annotation.JsonProperty;

public record PageGenerationManifestItem(
	@JsonProperty("model_id") String modelId,
	@JsonProperty("route_type") String routeType,
	@JsonProperty("route_key") String routeKey,
	@JsonProperty("template_kind") String templateKind,
	@JsonProperty("model_path") String modelPath,
	@JsonProperty("render_path") String renderPath,
	@JsonProperty("generation_mode") String generationMode,
	@JsonProperty("indexable") boolean indexable,
	@JsonProperty("last_verified_date") String lastVerifiedDate,
	@JsonProperty("source_count") int sourceCount
) {
}
