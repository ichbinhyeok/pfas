package com.example.pfas.observation;

import java.math.BigDecimal;
import java.util.List;

public record UtilityObservation(
	String observationId,
	String pwsid,
	String contaminantCode,
	String contaminantLabel,
	String sampleContext,
	String periodStart,
	String periodEnd,
	String sampleDate,
	BigDecimal value,
	String unit,
	String resultFlag,
	BigDecimal minimumReportingLevel,
	String benchmarkType,
	BigDecimal benchmarkValue,
	String benchmarkUnit,
	String benchmarkSourceId,
	List<String> sourceIds
) {
}
