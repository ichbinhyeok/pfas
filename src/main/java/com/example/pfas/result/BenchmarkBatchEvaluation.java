package com.example.pfas.result;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

public record BenchmarkBatchEvaluation(
	@JsonProperty("aggregate_relation") String aggregateRelation,
	@JsonProperty("aggregate_summary") String aggregateSummary,
	@JsonProperty("comparable_line_count") int comparableLineCount,
	@JsonProperty("not_comparable_line_count") int notComparableLineCount,
	@JsonProperty("line_evaluations") List<BenchmarkEvaluation> lineEvaluations
) {
}
