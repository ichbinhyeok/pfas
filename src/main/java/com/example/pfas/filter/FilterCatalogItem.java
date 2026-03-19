package com.example.pfas.filter;

import java.math.BigDecimal;
import java.util.List;

public record FilterCatalogItem(
	String productId,
	String brand,
	String model,
	String filterType,
	String installationType,
	String certBody,
	String standardCode,
	String listingRecordId,
	List<String> claimNames,
	List<String> coveredPfas,
	String listingUrl,
	Integer replacementCadenceMonths,
	Integer replacementCapacityGallons,
	BigDecimal upfrontCostUsd,
	BigDecimal replacementCostUsd,
	BigDecimal membraneCostUsd,
	BigDecimal serviceCostUsd,
	List<RecurringCostComponent> recurringCostComponents,
	String priceObservedAt,
	String costConfidence,
	List<String> sourceIds
) {
}
