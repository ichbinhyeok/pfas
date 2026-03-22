package com.example.pfas.commercial;

public record CommercialSurfaceState(
	String code,
	String statusLabel,
	String title,
	String summary,
	String primaryReason,
	String guardrail,
	boolean shoppingUnlocked
) {
}
