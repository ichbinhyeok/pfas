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
		String shoppingIntent,
		Boolean wholeHouseConsidered,
		String stateCode,
		String pwsid
	) {
		var normalizedWaterSource = parseWaterSource(waterSource);
		var normalizedDirectData = parseDirectData(directData);
		var normalizedShoppingIntent = parseShoppingIntent(shoppingIntent);
		var normalizedStateCode = resolveStateCode(stateCode);
		var normalizedPwsid = resolvePwsid(pwsid);

		if (normalizedWaterSource == ActionWaterSource.PUBLIC_WATER
			&& normalizedDirectData == ActionDirectDataStatus.PRIVATE_WELL_TEST) {
			normalizedDirectData = ActionDirectDataStatus.UTILITY_DOCUMENT;
		}

		if (normalizedWaterSource == ActionWaterSource.PRIVATE_WELL
			&& normalizedDirectData == ActionDirectDataStatus.UTILITY_DOCUMENT) {
			normalizedDirectData = ActionDirectDataStatus.NONE;
		}

		return new ActionCheckerSelection(
			normalizedWaterSource,
			normalizedDirectData,
			normalizedShoppingIntent,
			Boolean.TRUE.equals(wholeHouseConsidered),
			normalizedStateCode,
			normalizedPwsid
		);
	}

	public ActionCheckerRecommendation evaluate(ActionCheckerSelection selection) {
		return switch (selection.waterSource()) {
			case PRIVATE_WELL -> evaluatePrivateWell(selection);
			case PUBLIC_WATER -> evaluatePublicWater(selection);
		};
	}

	private ActionCheckerRecommendation evaluatePrivateWell(ActionCheckerSelection selection) {
		var state = resolveState(selection.stateCode());
		var stateLabel = state.map(StateGuidance::stateCode).orElse("state");
		var stateHref = state
			.map(guidance -> "/private-well/" + guidance.stateCode())
			.orElse("/internal/state-guidance");

		if (selection.directData() == ActionDirectDataStatus.NONE) {
			return new ActionCheckerRecommendation(
				ActionCheckerRouteCode.PRIVATE_WELL_TEST_FIRST,
				"Test first",
				"Test the private well before comparing filters",
				"No direct well test is available yet, so the engine should route the household to a state-guided lab and sampling workflow before any product comparison.",
				List.of(
					"Private well interpretation is reference-based, not legal compliance.",
					"State lab lookup and sampling guidance outrank generalized PFAS maps.",
					"Product shopping is secondary until a direct lab result exists."
				),
				stateHref,
				state.isPresent() ? "Open " + stateLabel + " private-well guide" : "Open state guidance list",
				"/internal/state-guidance",
				"Inspect state guidance JSON",
				selection.wholeHouseConsidered(),
				"Whole-house should stay behind a separate rationale even after testing."
			);
		}

		return new ActionCheckerRecommendation(
			ActionCheckerRouteCode.PRIVATE_WELL_INTERPRET_LAB_RESULT,
			"Interpret first",
			"Interpret the lab result against state guidance before shopping",
			"A direct well test exists, so the engine should explain the result against state-specific guidance and only then allow point-of-use comparisons.",
			List.of(
				"Direct private-well data outranks generalized contamination assumptions.",
				"State interpretation context should be shown alongside any PFAS result.",
				"Point-of-use remains the first product class before any whole-house escalation."
			),
			stateHref,
			state.isPresent() ? "Open " + stateLabel + " interpretation guide" : "Open state guidance list",
			"/internal/state-guidance/" + (selection.stateCode() == null ? "" : selection.stateCode()),
			"Inspect state JSON",
			selection.wholeHouseConsidered(),
			"Whole-house remains a separate escalation after the lab result is understood."
		);
	}

	private ActionCheckerRecommendation evaluatePublicWater(ActionCheckerSelection selection) {
		var system = resolveSystem(selection.pwsid());
		var systemName = system.map(PublicWaterSystem::pwsName).orElse("the selected utility");
		var utilityHref = system
			.map(item -> "/public-water-system/" + item.pwsid())
			.orElse("/internal/public-water-systems");
		var interpretationHref = system
			.map(item -> "/public-water/" + item.pwsid())
			.orElse("/internal/results/public-water/PA1510001");
		var resultJsonHref = system
			.map(item -> "/internal/results/public-water/" + item.pwsid())
			.orElse("/internal/results/public-water/PA1510001");

		if (selection.directData() == ActionDirectDataStatus.NONE) {
			return new ActionCheckerRecommendation(
				ActionCheckerRouteCode.PUBLIC_WATER_UTILITY_FIRST,
				"Utility first",
				"Pull the utility report or official notice first",
				"Public-water users should start with a direct utility document. ZIP hints and national PFAS maps are not enough to justify a product recommendation.",
				List.of(
					"Official utility documents outrank generalized location signals.",
					"Use the system document to decide whether interpretation is needed.",
					"Optional filtration comes after the document, not before it."
				),
				utilityHref,
				system.isPresent() ? "Open " + systemName + " context" : "Open public-water systems",
				"/internal/public-water-systems",
				"Inspect system JSON",
				selection.wholeHouseConsidered(),
				"Whole-house is not the default escalation for public-water users without direct evidence."
			);
		}

		if (selection.shoppingIntent() == ActionShoppingIntent.NONE) {
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
				selection.wholeHouseConsidered(),
				"Whole-house still needs a separate justification beyond drinking and cooking use."
			);
		}

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
			selection.wholeHouseConsidered(),
			"Whole-house should only appear after a separate whole-home rationale is established."
		);
	}

	private ActionWaterSource parseWaterSource(String value) {
		if (value == null || value.isBlank()) {
			return ActionWaterSource.PUBLIC_WATER;
		}

		try {
			return ActionWaterSource.valueOf(value.trim().toUpperCase(Locale.ROOT));
		}
		catch (IllegalArgumentException exception) {
			return ActionWaterSource.PUBLIC_WATER;
		}
	}

	private ActionDirectDataStatus parseDirectData(String value) {
		if (value == null || value.isBlank()) {
			return ActionDirectDataStatus.UTILITY_DOCUMENT;
		}

		try {
			return ActionDirectDataStatus.valueOf(value.trim().toUpperCase(Locale.ROOT));
		}
		catch (IllegalArgumentException exception) {
			return ActionDirectDataStatus.UTILITY_DOCUMENT;
		}
	}

	private ActionShoppingIntent parseShoppingIntent(String value) {
		if (value == null || value.isBlank()) {
			return ActionShoppingIntent.NONE;
		}

		try {
			return ActionShoppingIntent.valueOf(value.trim().toUpperCase(Locale.ROOT));
		}
		catch (IllegalArgumentException exception) {
			return ActionShoppingIntent.NONE;
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
