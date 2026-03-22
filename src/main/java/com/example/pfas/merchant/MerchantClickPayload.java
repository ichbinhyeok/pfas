package com.example.pfas.merchant;

public record MerchantClickPayload(
	String productId,
	String merchant,
	String ctaSlot,
	String sourcePage,
	String routeType,
	String routeCode,
	String benchmarkRelation,
	String unlockState,
	String nextActionCode,
	String targetUrl,
	String pagePath
) {
}
