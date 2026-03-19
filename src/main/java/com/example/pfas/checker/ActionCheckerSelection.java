package com.example.pfas.checker;

public record ActionCheckerSelection(
	ActionWaterSource waterSource,
	ActionDirectDataStatus directData,
	ActionIndirectDataStatus indirectData,
	ActionBenchmarkRelation benchmarkRelation,
	ActionCurrentFilterStatus currentFilterStatus,
	ActionShoppingIntent shoppingIntent,
	boolean wholeHouseConsidered,
	String stateCode,
	String pwsid
) {
}
