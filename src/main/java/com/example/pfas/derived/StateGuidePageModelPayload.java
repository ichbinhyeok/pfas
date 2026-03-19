package com.example.pfas.derived;

import com.example.pfas.state.StateGuidance;
import com.example.pfas.stateprofile.StateBenchmarkProfile;
import com.fasterxml.jackson.annotation.JsonProperty;

public record StateGuidePageModelPayload(
	@JsonProperty("guidance") StateGuidance guidance,
	@JsonProperty("profile") StateBenchmarkProfile profile,
	@JsonProperty("entry_decision_input") DecisionInputSeed entryDecisionInput,
	@JsonProperty("sample_result_path") String sampleResultPath
) {
}
