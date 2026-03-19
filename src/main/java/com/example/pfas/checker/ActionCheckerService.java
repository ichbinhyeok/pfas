package com.example.pfas.checker;

import java.util.List;
import java.util.Locale;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.example.pfas.state.StateGuidance;
import com.example.pfas.state.StateGuidanceService;
import com.example.pfas.water.PublicWaterSystem;
import com.example.pfas.water.PublicWaterSystemService;

@Service
public class ActionCheckerService {

	private final StateGuidanceService stateGuidanceService;
	private final PublicWaterSystemService publicWaterSystemService;

	public ActionCheckerService(
		StateGuidanceService stateGuidanceService,
		PublicWaterSystemService publicWaterSystemService
	) {
		this.stateGuidanceService = stateGuidanceService;
		this.publicWaterSystemService = publicWaterSystemService;
	}

	public ActionCheckerSelection normalize(
		String waterSource,
		String directData,
		String indirectData,
		String benchmarkRelation,
		String currentFilterStatus,
		String shoppingIntent,
		Boolean wholeHouseConsidered,
		String stateCode,
		String pwsid
	) {
		var normalizedWaterSource = parseEnum(waterSource, ActionWaterSource.class, ActionWaterSource.PUBLIC_WATER);
		var normalizedDirectData = parseEnum(directData, ActionDirectDataStatus.class, ActionDirectDataStatus.NONE);
		var normalizedIndirectData = parseEnum(indirectData, ActionIndirectDataStatus.class, ActionIndirectDataStatus.NONE);
		var normalizedBenchmarkRelation = parseEnum(benchmarkRelation, ActionBenchmarkRelation.class, ActionBenchmarkRelation.UNKNOWN);
		var normalizedCurrentFilterStatus = parseEnum(currentFilterStatus, ActionCurrentFilterStatus.class, ActionCurrentFilterStatus.NONE);
		var normalizedShoppingIntent = parseEnum(shoppingIntent, ActionShoppingIntent.class, ActionShoppingIntent.NONE);
		var normalizedStateCode = normalizedWaterSource == ActionWaterSource.PRIVATE_WELL
			? resolveStateCode(stateCode)
			: null;
		var normalizedPwsid = normalizedWaterSource == ActionWaterSource.PUBLIC_WATER
			? resolvePwsid(pwsid)
			: null;

		if (normalizedWaterSource == ActionWaterSource.PUBLIC_WATER
			&& normalizedDirectData == ActionDirectDataStatus.PRIVATE_WELL_TEST) {
			normalizedDirectData = ActionDirectDataStatus.UTILITY_DOCUMENT;
		}

		if (normalizedWaterSource == ActionWaterSource.PRIVATE_WELL
			&& (normalizedDirectData == ActionDirectDataStatus.UTILITY_DOCUMENT
				|| normalizedDirectData == ActionDirectDataStatus.OFFICIAL_NOTICE)) {
			normalizedDirectData = ActionDirectDataStatus.NONE;
		}

		if (normalizedDirectData == ActionDirectDataStatus.NONE) {
			normalizedBenchmarkRelation = ActionBenchmarkRelation.UNKNOWN;
		}

		if (normalizedWaterSource == ActionWaterSource.PRIVATE_WELL) {
			normalizedIndirectData = ActionIndirectDataStatus.NONE;
			normalizedPwsid = null;
		}

		if (normalizedWaterSource == ActionWaterSource.PUBLIC_WATER) {
			normalizedStateCode = null;
		}

		return new ActionCheckerSelection(
			normalizedWaterSource,
			normalizedDirectData,
			normalizedIndirectData,
			normalizedBenchmarkRelation,
			normalizedCurrentFilterStatus,
			normalizedShoppingIntent,
			Boolean.TRUE.equals(wholeHouseConsidered),
			normalizedStateCode,
			normalizedPwsid
		);
	}

	public ActionCheckerRecommendation evaluate(ActionCheckerSelection selection) {
		if (selection.shoppingIntent() != ActionShoppingIntent.NONE
			&& selection.directData() == ActionDirectDataStatus.NONE) {
			return selection.waterSource() == ActionWaterSource.PUBLIC_WATER
				? publicWaterUtilityFirst(selection, "Shopping intent cannot outrank missing direct utility evidence.")
				: privateWellTestFirst(selection, "Shopping intent cannot outrank missing direct well-test evidence.");
		}

		if (selection.currentFilterStatus() == ActionCurrentFilterStatus.UNCERTIFIED) {
			return uncertifiedFilterRoute(selection);
		}

		if (selection.wholeHouseConsidered()) {
			if (selection.benchmarkRelation() == ActionBenchmarkRelation.ABOVE_REFERENCE
				|| selection.benchmarkRelation() == ActionBenchmarkRelation.MIXED) {
				return wholeHouseJustifiedEscalation(selection);
			}
			return wholeHouseNotDefault(selection);
		}

		return switch (selection.waterSource()) {
			case PRIVATE_WELL -> evaluatePrivateWell(selection);
			case PUBLIC_WATER -> evaluatePublicWater(selection);
		};
	}

	private ActionCheckerRecommendation evaluatePrivateWell(ActionCheckerSelection selection) {
		if (selection.directData() == ActionDirectDataStatus.NONE) {
			return privateWellTestFirst(selection, "Private well users need a direct lab result before any product comparison.");
		}

		return switch (selection.benchmarkRelation()) {
			case ABOVE_REFERENCE, MIXED -> privateWellCertifiedPouAndStateNextSteps(selection);
			case BELOW_REFERENCE -> privateWellContinuePeriodicTesting(selection);
			case UNKNOWN, NOT_COMPARABLE -> privateWellStateContextRequired(selection);
		};
	}

	private ActionCheckerRecommendation evaluatePublicWater(ActionCheckerSelection selection) {
		if (selection.directData() == ActionDirectDataStatus.NONE) {
			if (selection.indirectData() == ActionIndirectDataStatus.UCMR_ONLY) {
				return publicWaterVerifyWithUtilityAndCcr(selection);
			}
			return publicWaterUtilityFirst(selection, "Indirect signals are not enough to justify shopping or escalation.");
		}

		if (selection.benchmarkRelation() == ActionBenchmarkRelation.ABOVE_REFERENCE
			|| selection.benchmarkRelation() == ActionBenchmarkRelation.MIXED
			|| selection.directData() == ActionDirectDataStatus.OFFICIAL_NOTICE) {
			return publicWaterCertifiedPouEvaluation(selection);
		}

		if (selection.benchmarkRelation() == ActionBenchmarkRelation.BELOW_REFERENCE) {
			return selection.shoppingIntent() == ActionShoppingIntent.NONE
				? publicWaterInterpretDirectData(selection)
				: publicWaterOptionalPouCompare(selection);
		}

		return publicWaterInterpretDirectData(selection);
	}

	private ActionCheckerRecommendation publicWaterUtilityFirst(ActionCheckerSelection selection, String extraPrinciple) {
		var system = resolveSystem(selection.pwsid());
		var systemName = system.map(PublicWaterSystem::pwsName).orElse("the selected utility");
		var utilityHref = system
			.map(item -> "/public-water-system/" + item.pwsid())
			.orElse("/internal/public-water-systems");

		return new ActionCheckerRecommendation(
			ActionCheckerRouteCode.PUBLIC_WATER_UTILITY_FIRST,
			"Utility first",
			"Pull the utility report or official notice first",
			"Public-water users should start with a direct utility document. ZIP hints, PFAS maps, or generic shopping intent are not enough to justify a product recommendation.",
			List.of(
				"Official utility documents outrank generalized location signals.",
				"Use the system document to decide whether interpretation is needed.",
				extraPrinciple
			),
			utilityHref,
			system.isPresent() ? "Open " + systemName + " context" : "Open public-water systems",
			"/guides/read-your-ccr",
			"Read how to use a CCR first",
			selection.wholeHouseConsidered(),
			"Whole-house is not the default escalation for public-water users without direct evidence."
		);
	}

	private ActionCheckerRecommendation publicWaterVerifyWithUtilityAndCcr(ActionCheckerSelection selection) {
		var system = resolveSystem(selection.pwsid());
		var systemName = system.map(PublicWaterSystem::pwsName).orElse("the selected utility");
		var utilityHref = system
			.map(item -> "/public-water-system/" + item.pwsid())
			.orElse("/internal/public-water-systems");

		return new ActionCheckerRecommendation(
			ActionCheckerRouteCode.PUBLIC_WATER_VERIFY_WITH_UTILITY_AND_CCR,
			"Verify UCMR context",
			"Verify with the utility report and CCR before acting",
			"UCMR-only context can help discovery, but it should not be treated as a household compliance or exposure answer without direct utility reporting.",
			List.of(
				"UCMR-only data is screening context, not a compliance determination.",
				"Direct utility records outrank federal screening tables for household routing.",
				"Product comparison should stay closed until direct utility context is reviewed."
			),
			utilityHref,
			system.isPresent() ? "Open " + systemName + " context" : "Open public-water systems",
			"/guides/read-your-ccr",
			"Read how to use a CCR first",
			false,
			"Whole-house should remain out of scope until direct system evidence exists."
		);
	}

	private ActionCheckerRecommendation publicWaterInterpretDirectData(ActionCheckerSelection selection) {
		var system = resolveSystem(selection.pwsid());
		var systemName = system.map(PublicWaterSystem::pwsName).orElse("the selected utility");
		var interpretationHref = system
			.map(item -> "/public-water/" + item.pwsid())
			.orElse("/internal/results/public-water/PA1510001");
		var resultJsonHref = system
			.map(item -> "/internal/results/public-water/" + item.pwsid())
			.orElse("/internal/results/public-water/PA1510001");

		return new ActionCheckerRecommendation(
			ActionCheckerRouteCode.PUBLIC_WATER_INTERPRET_DIRECT_DATA,
			"Interpret first",
			"Interpret the utility context before shopping",
			"A direct utility document exists, so the engine should explain benchmark context and optional next steps before any certified filter comparison.",
			List.of(
				"System-level utility observations count as direct official data for the system.",
				"Benchmark-aware interpretation should appear before cost and certification UI.",
				"Optional point-of-use remains the first product class when extra margin is desired."
			),
			interpretationHref,
			system.isPresent() ? "Open " + systemName + " interpretation" : "Open seeded interpretation",
			resultJsonHref,
			"Inspect typed result JSON",
			false,
			"Whole-house still needs a separate justification beyond drinking and cooking use."
		);
	}

	private ActionCheckerRecommendation publicWaterCertifiedPouEvaluation(ActionCheckerSelection selection) {
		var system = resolveSystem(selection.pwsid());
		var systemName = system.map(PublicWaterSystem::pwsName).orElse("the selected utility");
		var interpretationHref = system
			.map(item -> "/public-water/" + item.pwsid())
			.orElse("/internal/results/public-water/PA1510001");

		return new ActionCheckerRecommendation(
			ActionCheckerRouteCode.PUBLIC_WATER_CERTIFIED_POU_EVALUATION,
			"Certified point-of-use",
			"Evaluate certified point-of-use while following the utility response",
			"A direct utility notice or above-reference benchmark relation exists, so the engine can open a certified point-of-use path while keeping utility response and direct notice context in view.",
			List.of(
				"Direct utility notices outrank generalized PFAS content.",
				"Certified point-of-use is the first escalation class for ingestion-focused margin.",
				"Whole-house is still a separate justification path, not the baseline."
			),
			interpretationHref,
			system.isPresent() ? "Open " + systemName + " interpretation" : "Open seeded interpretation",
			"/guides/under-sink-vs-whole-house",
			"Read escalation guardrails",
			false,
			"Whole-house should only open after a separate whole-home purpose and cost review."
		);
	}

	private ActionCheckerRecommendation publicWaterOptionalPouCompare(ActionCheckerSelection selection) {
		var system = resolveSystem(selection.pwsid());
		var interpretationHref = system
			.map(item -> "/public-water/" + item.pwsid())
			.orElse("/internal/results/public-water/PA1510001");
		var resultJsonHref = system
			.map(item -> "/internal/results/public-water/" + item.pwsid())
			.orElse("/internal/results/public-water/PA1510001");

		return new ActionCheckerRecommendation(
			ActionCheckerRouteCode.PUBLIC_WATER_OPTIONAL_POU_COMPARE,
			"Optional point-of-use",
			"Compare certified point-of-use only after the utility context",
			"The user has direct utility data and active shopping intent, so the engine can open the interpretation view and keep certified point-of-use as the first comparison class.",
			List.of(
				"Certification must stay claim-level and PFAS-specific.",
				"Cost and cartridge cadence should appear beside the interpretation, not in isolation.",
				"Whole-house remains a separate escalation path, not the baseline."
			),
			interpretationHref,
			"Open interpreted result",
			resultJsonHref,
			"Inspect typed result JSON",
			false,
			"Whole-house should only appear after a separate whole-home rationale is established."
		);
	}

	private ActionCheckerRecommendation privateWellTestFirst(ActionCheckerSelection selection, String extraPrinciple) {
		var state = resolveState(selection.stateCode());
		var stateLabel = state.map(StateGuidance::stateCode).orElse("state");
		var stateHref = state
			.map(guidance -> "/private-well/" + guidance.stateCode())
			.orElse("/internal/state-guidance");

		return new ActionCheckerRecommendation(
			ActionCheckerRouteCode.PRIVATE_WELL_TEST_FIRST,
			"Test first",
			"Test the private well before comparing filters",
			"No direct well test is available yet, so the engine should route the household to a state-guided lab and sampling workflow before any product comparison.",
			List.of(
				"Private well interpretation is reference-based, not legal compliance.",
				"State lab lookup and sampling guidance outrank generalized PFAS maps.",
				extraPrinciple
			),
			stateHref,
			state.isPresent() ? "Open " + stateLabel + " private-well guide" : "Open state guidance list",
			"/guides/test-first-vs-filter-first",
			"Read test-first reasoning",
			selection.wholeHouseConsidered(),
			"Whole-house should stay behind a separate rationale even after testing."
		);
	}

	private ActionCheckerRecommendation privateWellStateContextRequired(ActionCheckerSelection selection) {
		var state = resolveState(selection.stateCode());
		var stateHref = privateWellResultHref(selection);

		return new ActionCheckerRecommendation(
			ActionCheckerRouteCode.PRIVATE_WELL_STATE_CONTEXT_REQUIRED,
			"State context required",
			"Interpret the lab result against state guidance before shopping",
			"A direct well test exists, but the benchmark relation is still unknown or not comparable. The next step is to anchor the result in state guidance and lab context.",
			List.of(
				"Direct private-well data outranks generalized contamination assumptions.",
				"State interpretation context should be shown alongside any PFAS result.",
				"Point-of-use remains the first product class before any whole-house escalation."
			),
			stateHref,
			state.isPresent() ? "Open " + state.get().stateCode() + " private-well result" : "Open private-well result",
			"/private-well/" + selection.stateCode(),
			"Open state guidance",
			false,
			"Whole-house remains a separate escalation after the lab result is understood."
		);
	}

	private ActionCheckerRecommendation privateWellCertifiedPouAndStateNextSteps(ActionCheckerSelection selection) {
		var stateHref = privateWellResultHref(selection);
		return new ActionCheckerRecommendation(
			ActionCheckerRouteCode.PRIVATE_WELL_CERTIFIED_POU_AND_STATE_NEXT_STEPS,
			"State next steps + certified point-of-use",
			"Open state next steps and certified point-of-use evaluation",
			"A private-well test is above the selected reference, so the engine should pair state-specific next steps with a certified point-of-use comparison and keep whole-house as a separate escalation review.",
			List.of(
				"Private well above-reference readings are action signals, not legal compliance labels.",
				"State next steps and accredited-lab context should appear with the result.",
				"Certified point-of-use stays first for ingestion-focused reduction."
			),
			stateHref,
			"Open private-well interpretation",
			"/guides/nsf-53-vs-58-pfas",
			"Read certification basics",
			false,
			"Whole-house should open only after purpose, cost, and maintenance are separately justified."
		);
	}

	private ActionCheckerRecommendation privateWellContinuePeriodicTesting(ActionCheckerSelection selection) {
		var stateHref = privateWellResultHref(selection);
		return new ActionCheckerRecommendation(
			ActionCheckerRouteCode.PRIVATE_WELL_CONTINUE_PERIODIC_TESTING,
			"Continue periodic testing",
			"Keep interpretation state-based and continue follow-up testing",
			"A private-well test exists and is below the selected reference, so the engine should keep the household in a state-guided monitoring posture instead of pushing immediate escalation.",
			List.of(
				"Below-reference private-well results still need state context and follow-up discipline.",
				"Point-of-use can remain optional rather than automatic.",
				"State guidance should drive repeat testing and lab follow-up."
			),
			stateHref,
			"Open private-well interpretation",
			"/private-well/" + selection.stateCode(),
			"Open state guidance",
			false,
			"Whole-house should not be the default next step for below-reference private-well results."
		);
	}

	private ActionCheckerRecommendation uncertifiedFilterRoute(ActionCheckerSelection selection) {
		var primaryHref = selection.waterSource() == ActionWaterSource.PUBLIC_WATER
			? "/public-water/" + selection.pwsid()
			: privateWellResultHref(selection);
		var secondaryHref = "/guides/nsf-53-vs-58-pfas";

		return new ActionCheckerRecommendation(
			ActionCheckerRouteCode.VERIFY_OR_REPLACE_UNCERTIFIED_FILTER,
			"Certification check",
			"Verify or replace the current filter with a certified option",
			"The current filter status is uncertified, so the engine should move the household into certification verification before assuming any PFAS treatment benefit.",
			List.of(
				"Uncertified filters should not be treated as equivalent to claim-level certified products.",
				"Certification scope, replacement cadence, and PFAS claim coverage must be checked directly.",
				"The next step should stay evidence-first, not brand-first."
			),
			primaryHref,
			"Open current interpretation",
			secondaryHref,
			"Read certification guide",
			selection.wholeHouseConsidered(),
			"Whole-house still needs a separate rationale even when the current filter is uncertified."
		);
	}

	private ActionCheckerRecommendation wholeHouseNotDefault(ActionCheckerSelection selection) {
		return new ActionCheckerRecommendation(
			ActionCheckerRouteCode.WHOLE_HOUSE_NOT_DEFAULT,
			"Whole-house guarded",
			"Do not default to whole-house from the current evidence",
			"The current benchmark relation does not justify a whole-house default. The engine should keep the household in a point-of-use-first posture unless the use case clearly exceeds drinking and cooking water.",
			List.of(
				"Whole-house is not a default upgrade path.",
				"Below-reference or unknown evidence should not be used to force a whole-home install.",
				"Purpose, cost, and maintenance need separate justification."
			),
			"/guides/under-sink-vs-whole-house",
			"Read whole-house guardrails",
			selection.waterSource() == ActionWaterSource.PUBLIC_WATER ? "/public-water/" + selection.pwsid() : privateWellResultHref(selection),
			"Open current interpretation",
			true,
			"Stay point-of-use first until a whole-home objective is clearly justified."
		);
	}

	private ActionCheckerRecommendation wholeHouseJustifiedEscalation(ActionCheckerSelection selection) {
		return new ActionCheckerRecommendation(
			ActionCheckerRouteCode.WHOLE_HOUSE_JUSTIFIED_ESCALATION_REVIEW,
			"Whole-house review",
			"Review whole-house only as a justified escalation",
			"The current evidence is strong enough to review whole-house as an escalation path, but the engine should still compare purpose, cost, maintenance, and certified point-of-use alternatives before recommending it.",
			List.of(
				"Whole-house remains an escalation, not an automatic result.",
				"Point-of-use alternatives should still be compared explicitly.",
				"Maintenance and annual ownership burden need to be visible before escalation."
			),
			"/guides/under-sink-vs-whole-house",
			"Read escalation guide",
			selection.waterSource() == ActionWaterSource.PUBLIC_WATER ? "/public-water/" + selection.pwsid() : privateWellResultHref(selection),
			"Open current interpretation",
			true,
			"A justified escalation still requires purpose, cost, and maintenance review."
		);
	}

	private String privateWellResultHref(ActionCheckerSelection selection) {
		var stateCode = selection.stateCode() == null ? "" : selection.stateCode();
		return "/private-well-result/" + stateCode
			+ "?benchmarkRelation=" + selection.benchmarkRelation().name()
			+ "&currentFilterStatus=" + selection.currentFilterStatus().name()
			+ "&wholeHouseConsidered=" + selection.wholeHouseConsidered();
	}

	private <T extends Enum<T>> T parseEnum(String value, Class<T> enumType, T defaultValue) {
		if (value == null || value.isBlank()) {
			return defaultValue;
		}

		try {
			return Enum.valueOf(enumType, value.trim().toUpperCase(Locale.ROOT));
		}
		catch (IllegalArgumentException exception) {
			return defaultValue;
		}
	}

	private String resolveStateCode(String stateCode) {
		if (stateCode != null && !stateCode.isBlank()) {
			var normalized = stateCode.trim().toUpperCase(Locale.ROOT);
			if (stateGuidanceService.getByStateCode(normalized).isPresent()) {
				return normalized;
			}
		}

		return stateGuidanceService.getAll().stream()
			.findFirst()
			.map(StateGuidance::stateCode)
			.orElse(null);
	}

	private String resolvePwsid(String pwsid) {
		if (pwsid != null && !pwsid.isBlank()) {
			var normalized = pwsid.trim().toUpperCase(Locale.ROOT);
			if (publicWaterSystemService.getByPwsid(normalized).isPresent()) {
				return normalized;
			}
		}

		return publicWaterSystemService.getAll().stream()
			.findFirst()
			.map(PublicWaterSystem::pwsid)
			.orElse(null);
	}

	private Optional<StateGuidance> resolveState(String stateCode) {
		if (stateCode == null || stateCode.isBlank()) {
			return Optional.empty();
		}

		return stateGuidanceService.getByStateCode(stateCode);
	}

	private Optional<PublicWaterSystem> resolveSystem(String pwsid) {
		if (pwsid == null || pwsid.isBlank()) {
			return Optional.empty();
		}

		return publicWaterSystemService.getByPwsid(pwsid);
	}
}
