package com.example.pfas.derived;

import com.example.pfas.catalog.FilterCollectionSurface;
import com.fasterxml.jackson.annotation.JsonProperty;

public record FilterCollectionPageModelPayload(
	@JsonProperty("filter_collection") FilterCollectionSurface filterCollection
) {
}
