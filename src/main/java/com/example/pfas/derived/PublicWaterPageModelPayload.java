package com.example.pfas.derived;

import com.example.pfas.result.WaterDecisionResult;
import com.example.pfas.water.PublicWaterSystem;
import com.fasterxml.jackson.annotation.JsonProperty;

public record PublicWaterPageModelPayload(
	@JsonProperty("system") PublicWaterSystem system,
	@JsonProperty("result") WaterDecisionResult result,
	@JsonProperty("decision_input") DecisionInputSeed decisionInput,
	@JsonProperty("supporting_path") String supportingPath
) {
}
