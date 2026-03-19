package com.example.pfas.web;

import java.util.List;

public record GuidePage(
	String slug,
	String eyebrow,
	String title,
	String lede,
	String nextActionTitle,
	String nextActionSummary,
	List<String> whyThis,
	List<String> whatThisDoesNotTellYou,
	List<String> checklist,
	List<String> evidenceHighlights,
	List<String> sourceIds,
	String primaryHref,
	String primaryLabel,
	String secondaryHref,
	String secondaryLabel,
	String lastVerifiedDate
) {
}
