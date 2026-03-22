package com.example.pfas.catalog;

import java.util.List;

import com.example.pfas.filter.FilterCatalogItem;

public record FilterCollectionSurface(
	String routeType,
	String routeKey,
	String title,
	String lede,
	String eyebrow,
	String canonicalPath,
	String lastVerifiedDate,
	int sourceCount,
	String groupLabel,
	String groupValue,
	String upfrontBand,
	String annualizedBand,
	String maintenanceSummary,
	List<String> highlights,
	List<String> keywords,
	List<FilterCatalogItem> products
) {
}
