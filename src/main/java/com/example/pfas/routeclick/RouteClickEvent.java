package com.example.pfas.routeclick;

public record RouteClickEvent(
	String recordedAt,
	String clickId,
	String sourcePage,
	String targetPath,
	String ctaSlot,
	String routeFamily,
	String laneLabel,
	String regionCode,
	String userAgent
) {
}
