package com.example.pfas.derived;

import com.example.pfas.catalog.FilterProductSurface;
import com.fasterxml.jackson.annotation.JsonProperty;

public record FilterProductPageModelPayload(
	@JsonProperty("filter_product") FilterProductSurface filterProduct
) {
}
