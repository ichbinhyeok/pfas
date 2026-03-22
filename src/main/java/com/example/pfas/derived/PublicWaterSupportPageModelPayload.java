package com.example.pfas.derived;

import com.example.pfas.water.PublicWaterSystem;
import com.fasterxml.jackson.annotation.JsonProperty;

public record PublicWaterSupportPageModelPayload(
	@JsonProperty("system") PublicWaterSystem system
) {
}
