package com.example.pfas.derived;

import com.example.pfas.web.ComparePage;
import com.fasterxml.jackson.annotation.JsonProperty;

public record ComparePageModelPayload(
	@JsonProperty("compare_page") ComparePage comparePage
) {
}
