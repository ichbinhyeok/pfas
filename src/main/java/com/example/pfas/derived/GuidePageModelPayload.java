package com.example.pfas.derived;

import com.example.pfas.web.GuidePage;
import com.fasterxml.jackson.annotation.JsonProperty;

public record GuidePageModelPayload(
	@JsonProperty("guide") GuidePage guide
) {
}
