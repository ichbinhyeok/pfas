package com.example.pfas.checker;

public record ActionCheckerResponse(
	ActionCheckerSelection selection,
	ActionCheckerRecommendation recommendation
) {
}
