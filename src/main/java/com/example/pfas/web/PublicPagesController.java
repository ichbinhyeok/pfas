package com.example.pfas.web;

import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Optional;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;

import com.example.pfas.checker.ActionBenchmarkRelation;
import com.example.pfas.checker.ActionCurrentFilterStatus;
import com.example.pfas.checker.ActionCheckerService;
import com.example.pfas.commercial.CommercialSurfaceService;
import com.example.pfas.decision.PublicWaterDecisionService;
import com.example.pfas.privatewell.InvalidPrivateWellBatchInputException;
import com.example.pfas.privatewell.InvalidPrivateWellMeasurementInputException;
import com.example.pfas.quality.RouteQualityGateService;
import com.example.pfas.result.PrivateWellResultService;
import com.example.pfas.result.PublicWaterResultService;
import com.example.pfas.result.WaterDecisionResult;
import com.example.pfas.site.SiteMetadataService;
import com.example.pfas.source.SourceDocument;
import com.example.pfas.source.SourceRegistryService;
import com.example.pfas.state.StateGuidance;
import com.example.pfas.state.StateGuidanceService;
import com.example.pfas.stateprofile.StateBenchmarkProfileService;
import com.example.pfas.water.PublicWaterSystem;
import com.example.pfas.water.PublicWaterSystemService;

@Controller
public class PublicPagesController {

	private final PublicWaterSystemService publicWaterSystemService;
	private final StateGuidanceService stateGuidanceService;
	private final PublicWaterDecisionService publicWaterDecisionService;
	private final PublicWaterResultService publicWaterResultService;
	private final PrivateWellResultService privateWellResultService;
	private final SourceRegistryService sourceRegistryService;
	private final ActionCheckerService actionCheckerService;
	private final GuidePageService guidePageService;
	private final ComparePageService comparePageService;
	private final StateBenchmarkProfileService stateBenchmarkProfileService;
	private final RouteQualityGateService routeQualityGateService;
	private final CommercialSurfaceService commercialSurfaceService;
	private final SiteMetadataService siteMetadataService;

	public PublicPagesController(
		PublicWaterSystemService publicWaterSystemService,
		StateGuidanceService stateGuidanceService,
		PublicWaterDecisionService publicWaterDecisionService,
		PublicWaterResultService publicWaterResultService,
		PrivateWellResultService privateWellResultService,
		SourceRegistryService sourceRegistryService,
		ActionCheckerService actionCheckerService,
		GuidePageService guidePageService,
		ComparePageService comparePageService,
		StateBenchmarkProfileService stateBenchmarkProfileService,
		RouteQualityGateService routeQualityGateService,
		CommercialSurfaceService commercialSurfaceService,
		SiteMetadataService siteMetadataService
	) {
		this.publicWaterSystemService = publicWaterSystemService;
		this.stateGuidanceService = stateGuidanceService;
		this.publicWaterDecisionService = publicWaterDecisionService;
		this.publicWaterResultService = publicWaterResultService;
		this.privateWellResultService = privateWellResultService;
		this.sourceRegistryService = sourceRegistryService;
		this.actionCheckerService = actionCheckerService;
		this.guidePageService = guidePageService;
		this.comparePageService = comparePageService;
		this.stateBenchmarkProfileService = stateBenchmarkProfileService;
		this.routeQualityGateService = routeQualityGateService;
		this.commercialSurfaceService = commercialSurfaceService;
		this.siteMetadataService = siteMetadataService;
	}

	@GetMapping("/")
	public String home(Model model) {
		var checkerSelection = actionCheckerService.normalize(null, null, null, null, null, null, null, null, null);
		model.addAttribute("systems", publicWaterSystemService.getAll());
		model.addAttribute("featuredSystems", featuredSystems());
		model.addAttribute("featuredPennsylvaniaSystems", featuredPennsylvaniaSystems());
		model.addAttribute("states", stateGuidanceService.getAll());
		model.addAttribute("featuredStates", featuredStates());
		model.addAttribute("guides", guidePageService.getAll());
		model.addAttribute("searchPriorityGuides", guidePageService.getSearchPriorityGuides());
		model.addAttribute("compares", comparePageService.getAll());
		model.addAttribute("checkerSelection", checkerSelection);
		model.addAttribute("checkerRecommendation", actionCheckerService.evaluate(checkerSelection));
		return "pages/home";
	}

	@GetMapping("/checker")
	public String checker(
		@RequestParam(required = false) String waterSource,
		@RequestParam(required = false) String directData,
		@RequestParam(required = false) String indirectData,
		@RequestParam(required = false) String benchmarkRelation,
		@RequestParam(required = false) String currentFilterStatus,
		@RequestParam(required = false) String shoppingIntent,
		@RequestParam(required = false) Boolean wholeHouseConsidered,
		@RequestParam(required = false) String stateCode,
		@RequestParam(required = false) String pwsid,
		Model model
	) {
		populateCheckerModel(
			model,
			waterSource,
			directData,
			indirectData,
			benchmarkRelation,
			currentFilterStatus,
			shoppingIntent,
			wholeHouseConsidered,
			stateCode,
			pwsid
		);

		return "pages/action-checker";
	}

	@GetMapping("/checker/panel")
	public String checkerPanel(
		@RequestParam(required = false) String waterSource,
		@RequestParam(required = false) String directData,
		@RequestParam(required = false) String indirectData,
		@RequestParam(required = false) String benchmarkRelation,
		@RequestParam(required = false) String currentFilterStatus,
		@RequestParam(required = false) String shoppingIntent,
		@RequestParam(required = false) Boolean wholeHouseConsidered,
		@RequestParam(required = false) String stateCode,
		@RequestParam(required = false) String pwsid,
		Model model
	) {
		populateCheckerModel(
			model,
			waterSource,
			directData,
			indirectData,
			benchmarkRelation,
			currentFilterStatus,
			shoppingIntent,
			wholeHouseConsidered,
			stateCode,
			pwsid
		);

		return "fragments/checkerPanel";
	}

	@GetMapping("/checker/route")
	public String checkerRoute(
		@RequestParam(required = false) String waterSource,
		@RequestParam(required = false) String directData,
		@RequestParam(required = false) String indirectData,
		@RequestParam(required = false) String benchmarkRelation,
		@RequestParam(required = false) String currentFilterStatus,
		@RequestParam(required = false) String shoppingIntent,
		@RequestParam(required = false) Boolean wholeHouseConsidered,
		@RequestParam(required = false) String stateCode,
		@RequestParam(required = false) String pwsid
	) {
		validateCheckerInputs(
			waterSource,
			directData,
			indirectData,
			benchmarkRelation,
			currentFilterStatus,
			shoppingIntent,
			stateCode,
			pwsid
		);

		var selection = actionCheckerService.normalize(
			waterSource,
			directData,
			indirectData,
			benchmarkRelation,
			currentFilterStatus,
			shoppingIntent,
			wholeHouseConsidered,
			stateCode,
			pwsid
		);

		return "redirect:" + actionCheckerService.evaluate(selection).primaryHref();
	}

	@GetMapping("/public-water/{pwsid}")
	public String publicWaterResult(@PathVariable String pwsid, Model model) {
		var system = publicWaterSystemService.getByPwsid(pwsid)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown pwsid: " + pwsid));
		var decision = publicWaterDecisionService.getByPwsid(pwsid)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "No decision available for pwsid: " + pwsid));
		var result = publicWaterResultService.getByPwsid(pwsid)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "No result available for pwsid: " + pwsid));

		model.addAttribute("system", system);
		model.addAttribute("decision", decision);
		model.addAttribute("result", result);
		model.addAttribute("commercialState", commercialSurfaceService.forPublicWater(decision, result));
		model.addAttribute("pageIndexable", routeQualityGateService.isIndexable("public_water", system.pwsid()));
		return "pages/public-water-result";
	}

	@GetMapping("/public-water-system/{pwsid}")
	public String publicWaterSystem(@PathVariable String pwsid, Model model) {
		var system = publicWaterSystemService.getByPwsid(pwsid)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown pwsid: " + pwsid));

		model.addAttribute("system", system);
		model.addAttribute("sources", resolveSources(system.sourceIds()));
		model.addAttribute("pageIndexable", routeQualityGateService.isIndexable("public_water_support", system.pwsid()));
		return "pages/public-water-system";
	}

	@GetMapping("/private-well/{stateCode}")
	public String privateWellState(@PathVariable String stateCode, Model model) {
		var guidance = stateGuidanceService.getByStateCode(stateCode.toUpperCase())
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown state_code: " + stateCode));

		model.addAttribute("guidance", guidance);
		model.addAttribute("profile", stateBenchmarkProfileService.getByStateCode(guidance.stateCode()).orElse(null));
		model.addAttribute("sources", resolveSources(guidance.sourceIds()));
		model.addAttribute("pageIndexable", routeQualityGateService.isIndexable("state_guidance", guidance.stateCode()));
		return "pages/private-well-state";
	}

	@GetMapping("/private-well-result/{stateCode}")
	public String privateWellResult(
		@PathVariable String stateCode,
		@RequestParam(defaultValue = "UNKNOWN") ActionBenchmarkRelation benchmarkRelation,
		@RequestParam(defaultValue = "NONE") ActionCurrentFilterStatus currentFilterStatus,
		@RequestParam(required = false) String batchInput,
		@RequestParam(required = false) String analyteCode,
		@RequestParam(required = false) BigDecimal value,
		@RequestParam(defaultValue = "ppt") String unit,
		@RequestParam(defaultValue = "false") boolean wholeHouseConsidered,
		Model model
	) {
		var guidance = stateGuidanceService.getByStateCode(stateCode.toUpperCase())
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown state_code: " + stateCode));
		var result = resolvePrivateWellResult(
			guidance.stateCode(),
			benchmarkRelation,
			currentFilterStatus,
			batchInput,
			analyteCode,
			value,
			unit,
			wholeHouseConsidered
		);
		var routeUrl = buildPrivateWellRouteUrl(
			guidance.stateCode(),
			benchmarkRelation,
			currentFilterStatus,
			batchInput,
			analyteCode,
			value,
			unit,
			wholeHouseConsidered
		);

		model.addAttribute("guidance", guidance);
		model.addAttribute("result", result);
		model.addAttribute("benchmarkRelation", result.benchmarkBatchEvaluation() != null
			? ActionBenchmarkRelation.valueOf(result.benchmarkBatchEvaluation().aggregateRelation().toUpperCase())
			: result.benchmarkEvaluation() != null
				? ActionBenchmarkRelation.valueOf(result.benchmarkEvaluation().benchmarkRelation().toUpperCase())
				: benchmarkRelation);
		model.addAttribute("currentFilterStatus", currentFilterStatus);
		model.addAttribute("wholeHouseConsidered", wholeHouseConsidered);
		model.addAttribute(
			"commercialState",
			commercialSurfaceService.forPrivateWell(
				result,
				result.benchmarkBatchEvaluation() != null
					? ActionBenchmarkRelation.valueOf(result.benchmarkBatchEvaluation().aggregateRelation().toUpperCase())
					: result.benchmarkEvaluation() != null
						? ActionBenchmarkRelation.valueOf(result.benchmarkEvaluation().benchmarkRelation().toUpperCase())
						: benchmarkRelation,
				wholeHouseConsidered
			)
		);
		model.addAttribute("batchInput", batchInput);
		model.addAttribute("analyteCode", analyteCode);
		model.addAttribute("value", value);
		model.addAttribute("unit", unit);
		model.addAttribute("routeId", routeUrl);
		model.addAttribute("routeUrl", routeUrl);
		model.addAttribute("canonicalUrl", siteMetadataService.siteBaseUrl() + routeUrl);
		return "pages/private-well-result";
	}

	private void populateCheckerModel(
		Model model,
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
		validateCheckerInputs(
			waterSource,
			directData,
			indirectData,
			benchmarkRelation,
			currentFilterStatus,
			shoppingIntent,
			stateCode,
			pwsid
		);

		var selection = actionCheckerService.normalize(
			waterSource,
			directData,
			indirectData,
			benchmarkRelation,
			currentFilterStatus,
			shoppingIntent,
			wholeHouseConsidered,
			stateCode,
			pwsid
		);

		model.addAttribute("selection", selection);
		model.addAttribute("recommendation", actionCheckerService.evaluate(selection));
		model.addAttribute("states", stateGuidanceService.getAll());
		model.addAttribute("featuredStates", featuredStates());
		model.addAttribute("systems", publicWaterSystemService.getAll());
		model.addAttribute("featuredSystems", featuredSystems());
		model.addAttribute("featuredPennsylvaniaSystems", featuredPennsylvaniaSystems());
	}

	private List<StateGuidance> featuredStates() {
		return List.of("CA", "MI", "MA", "WA", "PA")
			.stream()
			.map(stateGuidanceService::getByStateCode)
			.flatMap(Optional::stream)
			.toList();
	}

	private List<PublicWaterSystem> featuredSystems() {
		return List.of("3049000", "MI0000220", "WA5377050", "CA3410020", "PA1510001", "7360058", "PA2450065", "PA1460073", "NJ1103001")
			.stream()
			.map(publicWaterSystemService::getByPwsid)
			.flatMap(Optional::stream)
			.toList();
	}

	private List<PublicWaterSystem> featuredPennsylvaniaSystems() {
		return List.of("PA1510001", "7360058", "PA2450065", "PA1460073")
			.stream()
			.map(publicWaterSystemService::getByPwsid)
			.flatMap(Optional::stream)
			.toList();
	}

	private void validateCheckerInputs(
		String waterSource,
		String directData,
		String indirectData,
		String benchmarkRelation,
		String currentFilterStatus,
		String shoppingIntent,
		String stateCode,
		String pwsid
	) {
		try {
			actionCheckerService.validateInputs(
				waterSource,
				directData,
				indirectData,
				benchmarkRelation,
				currentFilterStatus,
				shoppingIntent,
				stateCode,
				pwsid
			);
		}
		catch (IllegalArgumentException exception) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, exception.getMessage(), exception);
		}
	}

	private WaterDecisionResult resolvePrivateWellResult(
		String stateCode,
		ActionBenchmarkRelation benchmarkRelation,
		ActionCurrentFilterStatus currentFilterStatus,
		String batchInput,
		String analyteCode,
		BigDecimal value,
		String unit,
		boolean wholeHouseConsidered
	) {
		try {
			if (batchInput != null && !batchInput.isBlank()) {
				return privateWellResultService.getFromBatchMeasurement(stateCode, batchInput, currentFilterStatus, wholeHouseConsidered)
					.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "No private-well result available for state_code: " + stateCode));
			}

			if (analyteCode != null && value != null) {
				return privateWellResultService.getFromMeasurement(stateCode, analyteCode, value, unit, currentFilterStatus, wholeHouseConsidered)
					.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "No private-well result available for state_code: " + stateCode));
			}
		}
		catch (InvalidPrivateWellBatchInputException | InvalidPrivateWellMeasurementInputException exception) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, exception.getMessage(), exception);
		}

		return privateWellResultService.get(stateCode, benchmarkRelation, currentFilterStatus, wholeHouseConsidered)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "No private-well result available for state_code: " + stateCode));
	}

	private String buildPrivateWellRouteUrl(
		String stateCode,
		ActionBenchmarkRelation benchmarkRelation,
		ActionCurrentFilterStatus currentFilterStatus,
		String batchInput,
		String analyteCode,
		BigDecimal value,
		String unit,
		boolean wholeHouseConsidered
	) {
		var builder = new StringBuilder("/private-well-result/")
			.append(stateCode);
		var queryParts = new java.util.ArrayList<String>();
		if (batchInput != null && !batchInput.isBlank()) {
			queryParts.add("batchInput=" + URLEncoder.encode(batchInput, StandardCharsets.UTF_8));
		}
		else if (analyteCode != null && !analyteCode.isBlank() && value != null) {
			queryParts.add("analyteCode=" + URLEncoder.encode(analyteCode, StandardCharsets.UTF_8));
			queryParts.add("value=" + URLEncoder.encode(value.toPlainString(), StandardCharsets.UTF_8));
			queryParts.add("unit=" + URLEncoder.encode(unit == null || unit.isBlank() ? "ppt" : unit, StandardCharsets.UTF_8));
		}
		else {
			queryParts.add("benchmarkRelation=" + benchmarkRelation.name());
		}
		queryParts.add("currentFilterStatus=" + currentFilterStatus.name());
		queryParts.add("wholeHouseConsidered=" + wholeHouseConsidered);
		builder.append('?').append(String.join("&", queryParts));
		return builder.toString();
	}

	private List<SourceDocument> resolveSources(List<String> sourceIds) {
		return sourceIds.stream()
			.map(sourceRegistryService::getDocument)
			.flatMap(Optional::stream)
			.toList();
	}
}
