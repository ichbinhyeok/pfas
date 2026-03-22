package com.example.pfas.merchant;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

public record MerchantClickReport(
	@JsonProperty("generated_at") String generatedAt,
	@JsonProperty("total_count") int totalCount,
	@JsonProperty("unique_product_count") int uniqueProductCount,
	@JsonProperty("unique_source_page_count") int uniqueSourcePageCount,
	@JsonProperty("merchant_counts") List<MerchantClickCountEntry> merchantCounts,
	@JsonProperty("product_counts") List<MerchantClickCountEntry> productCounts,
	@JsonProperty("source_page_counts") List<MerchantClickCountEntry> sourcePageCounts,
	@JsonProperty("route_type_counts") List<MerchantClickCountEntry> routeTypeCounts,
	@JsonProperty("route_code_counts") List<MerchantClickCountEntry> routeCodeCounts,
	@JsonProperty("unlock_state_counts") List<MerchantClickCountEntry> unlockStateCounts,
	@JsonProperty("recent_events") List<MerchantClickEvent> recentEvents
) {
}
