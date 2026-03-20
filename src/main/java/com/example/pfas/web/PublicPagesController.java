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
import com.example.pfas.decision.PublicWaterDecisionService;
import com.example.pfas.quality.RouteQualityGateService;
import com.example.pfas.result.PrivateWellResultService;
import com.example.pfas.result.PublicWaterResultService;
import com.example.pfas.source.SourceDocument;
import com.example.pfas.source.SourceRegistryService;
import com.example.pfas.state.StateGuidanceService;
import com.example.pfas.stateprofile.StateBenchmarkProfileService;
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
	private final StateBenchmarkProfileService stateBenchmarkProfileService;
	private final RouteQualityGateService routeQualityGateService;

	public PublicPagesController(
		PublicWaterSystemService publicWaterSystemService,
		StateGuidanceService stateGuidanceService,
		PublicWaterDecisionService publicWaterDecisionService,
		PublicWaterResultService publicWaterResultService,
		PrivateWellResultService privateWellResultService,
		SourceRegistryService sourceRegistryService,
		ActionCheckerService actionCheckerService,
		GuidePageService guidePageService,
		StateBenchmarkProfileService stateBenchmarkProfileService,
		RouteQualityGateService routeQualityGateService
	) {
		this.publicWaterSystemService = publicWaterSystemService;
		this.stateGuidanceService = stateGuidanceService;
		this.publicWaterDecisionService = publicWaterDecisionService;
		this.publicWaterResultService = publicWaterResultService;
		this.privateWellResultService = privateWellResultService;
		this.sourceRegistryService = sourceRegistryService;
		this.actionCheckerService = actionCheckerService;
		this.guidePageService = guidePageService;
		this.stateBenchmarkProfileService = stateBenchmarkProfileService;
		this.routeQualityGateService = routeQualityGateService;
	}

	@GetMapping("/")
	public String home(Model model) {
		model.addAttribute("systems", publicWaterSystemService.getAll());
		model.addAttribute("guides", guidePageService.getAll());
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
		model.addAttribute("pageIndexable", routeQualityGateService.isIndexable("public_water", system.pwsid()));
		return "pages/public-water-result";
	}

	@GetMapping("/public-water-system/{pwsid}")
	public String publicWaterSystem(@PathVariable String pwsid, Model model) {
		var system = publicWaterSystemService.getByPwsid(pwsid)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown pwsid: " + pwsid));

		model.addAttribute("system", system);
		model.addAttribute("sources", resolveSources(system.sourceIds()));
		model.addAttribute("pageIndexable", routeQualityGateService.isIndexable("public_water", system.pwsid()));
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
		var result = batchInput != null && !batchInput.isBlank()
			? privateWellResultService.getFromBatchMeasurement(guidance.stateCode(), batchInput, currentFilterStatus, wholeHouseConsidered)
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "No private-well result available for state_code: " + stateCode))
			: analyteCode != null && value != null
			? privateWellResultService.getFromMeasurement(guidance.stateCode(), analyteCode, value, unit, currentFilterStatus, wholeHouseConsidered)
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "No private-well result available for state_code: " + stateCode))
			: privateWellResultService.get(guidance.stateCode(), benchmarkRelation, currentFilterStatus, wholeHouseConsidered)
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "No private-well result available for state_code: " + stateCode));

		model.addAttribute("guidance", guidance);
		model.addAttribute("result", result);
		model.addAttribute("benchmarkRelation", result.benchmarkBatchEvaluation() != null
			? ActionBenchmarkRelation.valueOf(result.benchmarkBatchEvaluation().aggregateRelation().toUpperCase())
			: result.benchmarkEvaluation() != null
				? ActionBenchmarkRelation.valueOf(result.benchmarkEvaluation().benchmarkRelation().toUpperCase())
				: benchmarkRelation);
		model.addAttribute("currentFilterStatus", currentFilterStatus);
		model.addAttribute("wholeHouseConsidered", wholeHouseConsidered);
		model.addAttribute("batchInput", batchInput);
		model.addAttribute("encodedBatchInput", batchInput == null ? null : URLEncoder.encode(batchInput, StandardCharsets.UTF_8));
		model.addAttribute("analyteCode", analyteCode);
		model.addAttribute("value", value);
		model.addAttribute("unit", unit);
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
		model.addAttribute("systems", publicWaterSystemService.getAll());
	}

	private List<SourceDocument> resolveSources(List<String> sourceIds) {
		return sourceIds.stream()
			.map(sourceRegistryService::getDocument)
			.flatMap(Optional::stream)
			.toList();
	}
}
