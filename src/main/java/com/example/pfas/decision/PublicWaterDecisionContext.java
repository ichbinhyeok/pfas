package com.example.pfas.decision;

import java.util.List;

import com.example.pfas.filter.FilterCatalogItem;

public record PublicWaterDecisionContext(
	String pwsid,
	String pwsName,
	String stateCode,
	PublicWaterDecisionStatus decisionStatus,
	PublicWaterNextActionCode nextActionCode,
	PublicWaterDecisionRuleId decisionRuleId,
	String nextActionTitle,
	String rationale,
	boolean manualReviewRequired,
	List<String> caveats,
	List<ContaminantAssessment> assessments,
	List<FilterCatalogItem> certifiedPouOptions
) {
}
