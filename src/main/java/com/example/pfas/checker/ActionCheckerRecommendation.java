package com.example.pfas.checker;

import java.util.List;

public record ActionCheckerRecommendation(
	ActionCheckerRouteCode routeCode,
	String tag,
	String title,
	String summary,
	List<String> principles,
	String primaryHref,
	String primaryLabel,
	String secondaryHref,
	String secondaryLabel,
	boolean wholeHouseGuardrail,
	String wholeHouseMessage
) {
}
