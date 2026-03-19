package com.example.pfas.derived;

import com.fasterxml.jackson.annotation.JsonProperty;

public record DecisionInputSeed(
	@JsonProperty("input_id") String inputId,
	@JsonProperty("route_type") String routeType,
	@JsonProperty("route_key") String routeKey,
	@JsonProperty("water_source") String waterSource,
	@JsonProperty("direct_data_status") String directDataStatus,
	@JsonProperty("indirect_data_status") String indirectDataStatus,
	@JsonProperty("benchmark_relation") String benchmarkRelation,
	@JsonProperty("current_filter_status") String currentFilterStatus,
	@JsonProperty("whole_house_considered") boolean wholeHouseConsidered,
	@JsonProperty("state_code") String stateCode,
	@JsonProperty("pwsid") String pwsid,
	@JsonProperty("recommended_route_code") String recommendedRouteCode,
	@JsonProperty("primary_path") String primaryPath,
	@JsonProperty("secondary_path") String secondaryPath,
	@JsonProperty("summary") String summary
) {
}
