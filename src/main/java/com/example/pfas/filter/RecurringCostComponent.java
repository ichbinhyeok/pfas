package com.example.pfas.filter;

import java.math.BigDecimal;
import java.util.List;

public record RecurringCostComponent(
	String productId,
	String componentCode,
	String componentLabel,
	String componentType,
	BigDecimal componentCostUsd,
	Integer cadenceMonths,
	String priceObservedAt,
	String priceSourceUrl,
	List<String> sourceIds
) {
}
