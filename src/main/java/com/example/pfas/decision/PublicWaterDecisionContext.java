package com.example.pfas.decision;

import java.util.List;

import com.example.pfas.filter.FilterCatalogItem;

public record PublicWaterDecisionContext(
	String pwsid,
	String pwsName,
	String stateCode,
	String decisionStatus,
	String nextActionCode,
	String nextActionTitle,
	String rationale,
	List<String> caveats,
	List<ContaminantAssessment> assessments,
	List<FilterCatalogItem> certifiedPouOptions
) {
}
