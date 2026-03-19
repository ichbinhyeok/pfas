package com.example.pfas.filter;

import java.util.List;

public record FilterProduct(
	String productId,
	String brand,
	String model,
	String filterType,
	String installationType,
	String certBody,
	String standardCode,
	String listingRecordId,
	String claimScope,
	List<String> coveredPfas,
	String listingUrl,
	Integer replacementCadenceMonths,
	Integer replacementCapacityGallons,
	String lastVerifiedDate,
	List<String> sourceIds
) {
}
