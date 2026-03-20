package com.example.pfas.web;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public record ComparePage(
	String slug,
	String eyebrow,
	String title,
	String lede,
	String queryIntent,
	String nextActionTitle,
	String nextActionSummary,
	List<String> comparisonAxes,
	List<String> whyThis,
	List<String> whatThisDoesNotTellYou,
	List<String> evidenceHighlights,
	List<String> targetQueries,
	List<String> relatedGuideSlugs,
	List<String> relatedPwsids,
	List<String> relatedProductIds,
	List<String> sourceIds,
	String primaryHref,
	String primaryLabel,
	String secondaryHref,
	String secondaryLabel,
	String lastVerifiedDate,
	List<GuideSection> sections
) {
}
