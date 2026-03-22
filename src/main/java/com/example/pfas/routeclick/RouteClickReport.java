package com.example.pfas.routeclick;

import java.util.List;

public record RouteClickReport(
	String generatedAt,
	int totalCount,
	int uniqueSourcePageCount,
	int uniqueTargetPathCount,
	List<RouteClickCountEntry> bySourcePage,
	List<RouteClickCountEntry> byTargetPath,
	List<RouteClickCountEntry> byCtaSlot,
	List<RouteClickCountEntry> byRouteFamily,
	List<RouteClickCountEntry> byLaneLabel,
	List<RouteClickCountEntry> byRegionCode,
	List<RouteClickEvent> recentEvents
) {
}
