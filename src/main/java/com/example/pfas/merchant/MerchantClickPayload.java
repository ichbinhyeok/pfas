package com.example.pfas.merchant;

public record MerchantClickPayload(
	String productId,
	String merchant,
	String ctaSlot,
	String sourcePage,
	String routeType,
	String targetUrl,
	String pagePath
) {
}
