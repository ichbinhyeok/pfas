package com.example.pfas.commercial;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.pfas.checker.ActionBenchmarkRelation;
import com.example.pfas.decision.PublicWaterDecisionContext;
import com.example.pfas.filter.FilterCatalogItem;
import com.example.pfas.result.WaterDecisionResult;
import com.example.pfas.web.ComparePage;
import com.example.pfas.web.GuidePage;

@Service
public class CommercialSurfaceService {

	public CommercialSurfaceState forPublicWater(PublicWaterDecisionContext decision, WaterDecisionResult result) {
		var benchmarkRelation = blankToUnknown(result.meta().benchmarkRelation());
		var hasOptions = decision.certifiedPouOptions() != null && !decision.certifiedPouOptions().isEmpty();
		if (!hasOptions) {
			return new CommercialSurfaceState(
				"PUBLIC_WATER_INTERPRET_FIRST_ONLY",
				"Interpret only",
				"Stay in interpretation until the utility reading opens a defendable treatment path.",
				"The current utility posture does not justify a certified product lane yet. Read the record before opening hardware comparison.",
				"The current next action is " + result.nextAction().title().toLowerCase() + ".",
				"Whole-house remains separately justified and no commercial lane should outrun the direct utility record.",
				false
			);
		}
		if ("above_reference".equals(benchmarkRelation) || "mixed".equals(benchmarkRelation)) {
			return new CommercialSurfaceState(
				"PUBLIC_WATER_SHOPPING_UNLOCKED",
				"Shop unlocked",
				"Certified point-of-use comparison is open for this utility route.",
				"The utility dossier already supports an ingestion-focused treatment comparison. Merchant clicks should stay tied to claim scope, maintenance burden, and the current benchmark posture.",
				"The current route is " + result.nextAction().code() + ".",
				"Whole-house still stays guarded. This unlock applies to certified point-of-use only.",
				true
			);
		}
		return new CommercialSurfaceState(
			"PUBLIC_WATER_OPTIONAL_COMPARE",
			"Compare unlocked",
			"Comparison is available, but the route is still interpretive rather than urgent.",
			"Detected PFAS remains below the current benchmark relation, so comparison stays optional and subordinate to the utility reading.",
			"The current route is " + result.nextAction().code() + ".",
			"This is not a signal to overbuy. It keeps certified options visible for households that still want ingestion-focused margin.",
			true
		);
	}

	public CommercialSurfaceState forPrivateWell(
		WaterDecisionResult result,
		ActionBenchmarkRelation benchmarkRelation,
		boolean wholeHouseConsidered
	) {
		if (result.bestFitOptions() != null && !result.bestFitOptions().isEmpty()) {
			var guardrail = wholeHouseConsidered
				? "Whole-house is still a separate escalation case. This unlock applies only to certified point-of-use treatment."
				: "State guidance and certified-lab context still outrank any generalized shopping flow.";
			return new CommercialSurfaceState(
				"PRIVATE_WELL_SHOPPING_UNLOCKED",
				"Shop unlocked",
				"State-guided point-of-use comparison is open for this private-well route.",
				"The benchmark relation is " + benchmarkRelation.name().toLowerCase().replace('_', ' ')
					+ ", so the product layer can open without breaking the state-first interpretation flow.",
				"The current route is " + result.nextAction().code() + ".",
				guardrail,
				true
			);
		}
		return new CommercialSurfaceState(
			"PRIVATE_WELL_INTERPRET_FIRST_ONLY",
			"Interpret only",
			"Private-well treatment comparison stays closed until the state context is clear enough to defend it.",
			"The current benchmark relation is " + benchmarkRelation.name().toLowerCase().replace('_', ' ')
				+ ", so the next step stays anchored to state guidance, lab context, and sampling review.",
			"The current route is " + result.nextAction().code() + ".",
			wholeHouseConsidered
				? "Whole-house concern is noted, but it still does not unlock product comparison ahead of state interpretation."
				: "This result should not open generic shopping until the state route is interpretable.",
			false
		);
	}

	public CommercialSurfaceState forComparePage(ComparePage page, List<FilterCatalogItem> products) {
		var unlocked = products != null && !products.isEmpty();
		return new CommercialSurfaceState(
			unlocked ? "COMPARE_PAGE_UNLOCKED" : "COMPARE_PAGE_CONTEXT_ONLY",
			unlocked ? "Shop unlocked" : "Interpret only",
			unlocked
				? "This comparison can route to merchant records because fit criteria, upkeep, and exclusions are already visible."
				: "This comparison stays informational until the page has a defendable certified lane.",
			page.nextActionSummary(),
			"Query intent is " + page.queryIntent().toLowerCase() + ".",
			unlocked
				? "Clicks should stay tied to the visible criteria on this page, not to generic popularity."
				: "Do not treat this page as a buying signal until a certified lane is attached.",
			unlocked
		);
	}

	public CommercialSurfaceState forGuidePage(GuidePage page, List<FilterCatalogItem> products) {
		var unlocked = products != null && !products.isEmpty();
		return new CommercialSurfaceState(
			unlocked ? "GUIDE_SUPPORTS_COMPARE" : "GUIDE_CONTEXT_ONLY",
			unlocked ? "Compare unlocked" : "Interpret only",
			unlocked
				? "This guide can hand off to a certified compare lane without losing the evidence posture."
				: "This guide is context-first and does not open a commercial lane on its own.",
			page.nextActionSummary(),
			"Guide intent is " + page.queryIntent().toLowerCase() + ".",
			unlocked
				? "The compare lane exists to support the guide, not to outrun it."
				: "Keep the guide in an interpretation role until a product lane is explicitly attached.",
			unlocked
		);
	}

	private String blankToUnknown(String value) {
		return value == null || value.isBlank() ? "unknown" : value;
	}
}
