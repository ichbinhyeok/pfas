package com.example.pfas.benchmark;

import java.math.BigDecimal;
import java.util.List;

public record BenchmarkRecord(
	String benchmarkId,
	String jurisdiction,
	String benchmarkKind,
	String contaminantCode,
	String benchmarkLabel,
	BigDecimal benchmarkValue,
	String unit,
	String comparisonBasis,
	String referenceStatus,
	String effectiveDate,
	String lastVerifiedDate,
	String primarySourceId,
	List<String> sourceIds,
	String notes
) {
}
