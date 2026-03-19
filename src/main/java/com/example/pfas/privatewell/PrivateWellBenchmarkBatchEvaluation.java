package com.example.pfas.privatewell;

import java.util.List;

import com.example.pfas.checker.ActionBenchmarkRelation;
import com.fasterxml.jackson.annotation.JsonProperty;

public record PrivateWellBenchmarkBatchEvaluation(
	@JsonProperty("state_code") String stateCode,
	@JsonProperty("aggregate_relation") ActionBenchmarkRelation aggregateRelation,
	@JsonProperty("aggregate_summary") String aggregateSummary,
	@JsonProperty("comparable_line_count") int comparableLineCount,
	@JsonProperty("not_comparable_line_count") int notComparableLineCount,
	@JsonProperty("line_evaluations") List<PrivateWellBenchmarkEvaluation> lineEvaluations
) {
}
