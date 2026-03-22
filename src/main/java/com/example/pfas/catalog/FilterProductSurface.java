package com.example.pfas.catalog;

import java.util.List;

import com.example.pfas.filter.FilterCatalogItem;

public record FilterProductSurface(
	String routeType,
	String routeKey,
	String title,
	String lede,
	String eyebrow,
	String canonicalPath,
	String lastVerifiedDate,
	int sourceCount,
	String merchantLabel,
	String brandPath,
	String installationPath,
	String filterTypePath,
	String merchantPath,
	List<String> highlights,
	List<String> keywords,
	FilterCatalogItem product,
	List<FilterCatalogItem> relatedProducts
) {
}
