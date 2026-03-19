package com.example.pfas.checker;

public record ActionCheckerSelection(
	ActionWaterSource waterSource,
	ActionDirectDataStatus directData,
	ActionShoppingIntent shoppingIntent,
	boolean wholeHouseConsidered,
	String stateCode,
	String pwsid
) {
}
