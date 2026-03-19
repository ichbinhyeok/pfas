package com.example.pfas.decision;

import java.math.BigDecimal;

public record ContaminantAssessment(
	String observationId,
	String contaminantCode,
	String contaminantLabel,
	String sampleContext,
	BigDecimal value,
	String unit,
	String benchmarkType,
	BigDecimal benchmarkValue,
	String benchmarkUnit,
	String benchmarkSourceId,
	BigDecimal ratioToBenchmark,
	String comparisonStatus
) {
}
