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
	String priceObservedAt,
	String costConfidence,
	List<String> sourceIds
) {
}
