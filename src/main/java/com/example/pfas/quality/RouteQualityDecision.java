package com.example.pfas.quality;

import java.util.List;

public record RouteQualityDecision(
	String routeType,
	String routeKey,
	String primaryPath,
	String lastVerifiedDate,
	int sourceCount,
	Integer resolvedSourceCount,
	boolean indexable,
	List<String> blockReasons
) {
}
