package com.example.pfas.result;

import com.fasterxml.jackson.annotation.JsonProperty;

public record ResultMeta(
	@JsonProperty("water_source_type") String waterSourceType,
	@JsonProperty("benchmark_relation") String benchmarkRelation,
	@JsonProperty("decision_rule_id") String decisionRuleId,
	@JsonProperty("manual_review_required") boolean manualReviewRequired
) {
}
