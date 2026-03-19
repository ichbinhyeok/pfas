package com.example.pfas.derived;

import com.fasterxml.jackson.annotation.JsonProperty;

public record DerivedArtifactOutput(
	@JsonProperty("artifact_key") String artifactKey,
	@JsonProperty("path") String path,
	@JsonProperty("item_count") int itemCount
) {
}
