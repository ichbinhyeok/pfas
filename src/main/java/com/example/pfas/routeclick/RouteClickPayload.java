package com.example.pfas.routeclick;

public record RouteClickPayload(
	String clickId,
	String sourcePage,
	String targetPath,
	String ctaSlot,
	String routeFamily,
	String laneLabel,
	String regionCode
) {
}
