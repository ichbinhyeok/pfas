package com.example.pfas.decision;

import java.math.BigDecimal;

public record ContaminantAssessment(
	String observationId,
	String contaminantCode,
	String contaminantLabel,
	String sampleContext,
	BigDecimal value,
	String unit,
	String benchmarkId,
	String benchmarkLabel,
	String benchmarkType,
	BigDecimal benchmarkValue,
	String benchmarkUnit,
	String benchmarkSourceId,
	String benchmarkReferenceStatus,
	BigDecimal ratioToBenchmark,
	BenchmarkComparisonStatus comparisonStatus
) {
}
