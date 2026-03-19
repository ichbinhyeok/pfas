package com.example.pfas.filter;

import java.math.BigDecimal;
import java.util.List;

public record FilterCost(
	String productId,
	BigDecimal upfrontCostUsd,
	BigDecimal replacementCostUsd,
	BigDecimal membraneCostUsd,
	BigDecimal serviceCostUsd,
	Integer replacementCadenceMonths,
	String priceObservedAt,
	String priceSourceUrl,
	String costConfidence,
	List<String> sourceIds
) {
}
