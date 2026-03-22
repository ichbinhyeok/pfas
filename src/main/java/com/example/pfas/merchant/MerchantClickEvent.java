package com.example.pfas.merchant;

import com.fasterxml.jackson.annotation.JsonProperty;

public record MerchantClickEvent(
	@JsonProperty("recorded_at") String recordedAt,
	@JsonProperty("product_id") String productId,
	@JsonProperty("merchant") String merchant,
	@JsonProperty("cta_slot") String ctaSlot,
	@JsonProperty("source_page") String sourcePage,
	@JsonProperty("route_type") String routeType,
	@JsonProperty("route_code") String routeCode,
	@JsonProperty("benchmark_relation") String benchmarkRelation,
	@JsonProperty("unlock_state") String unlockState,
	@JsonProperty("next_action_code") String nextActionCode,
	@JsonProperty("target_url") String targetUrl,
	@JsonProperty("page_path") String pagePath,
	@JsonProperty("user_agent") String userAgent
) {
}
