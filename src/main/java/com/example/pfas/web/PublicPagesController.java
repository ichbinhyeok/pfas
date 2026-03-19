package com.example.pfas.web;

import java.util.List;
import java.util.Optional;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;

import com.example.pfas.checker.ActionCheckerService;
import com.example.pfas.decision.PublicWaterDecisionService;
import com.example.pfas.result.PublicWaterResultService;
import com.example.pfas.source.SourceDocument;
import com.example.pfas.source.SourceRegistryService;
import com.example.pfas.state.StateGuidanceService;
import com.example.pfas.water.PublicWaterSystemService;

@Controller
public class PublicPagesController {

	private final PublicWaterSystemService publicWaterSystemService;
	private final StateGuidanceService stateGuidanceService;
	private final PublicWaterDecisionService publicWaterDecisionService;
	private final PublicWaterResultService publicWaterResultService;
	private final SourceRegistryService sourceRegistryService;
	private final ActionCheckerService actionCheckerService;

	public PublicPagesController(
		PublicWaterSystemService publicWaterSystemService,
		StateGuidanceService stateGuidanceService,
		PublicWaterDecisionService publicWaterDecisionService,
		PublicWaterResultService publicWaterResultService,
		SourceRegistryService sourceRegistryService,
		ActionCheckerService actionCheckerService
	) {
		this.publicWaterSystemService = publicWaterSystemService;
		this.stateGuidanceService = stateGuidanceService;
		this.publicWaterDecisionService = publicWaterDecisionService;
		this.publicWaterResultService = publicWaterResultService;
		this.sourceRegistryService = sourceRegistryService;
		this.actionCheckerService = actionCheckerService;
	}

	@GetMapping("/")
	public String home(Model model) {
		model.addAttribute("systems", publicWaterSystemService.getAll());
		return "pages/home";
	}

	@GetMapping("/checker")
	public String checker(
		@RequestParam(required = false) String waterSource,
		@RequestParam(required = false) String directData,
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
		return "pages/public-water-result";
	}

	@GetMapping("/public-water-system/{pwsid}")
	public String publicWaterSystem(@PathVariable String pwsid, Model model) {
		var system = publicWaterSystemService.getByPwsid(pwsid)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown pwsid: " + pwsid));

		model.addAttribute("system", system);
		model.addAttribute("sources", resolveSources(system.sourceIds()));
		return "pages/public-water-system";
	}

	@GetMapping("/private-well/{stateCode}")
	public String privateWellState(@PathVariable String stateCode, Model model) {
		var guidance = stateGuidanceService.getByStateCode(stateCode.toUpperCase())
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown state_code: " + stateCode));

		model.addAttribute("guidance", guidance);
		model.addAttribute("sources", resolveSources(guidance.sourceIds()));
		return "pages/private-well-state";
	}

	private void populateCheckerModel(
		Model model,
		String waterSource,
		String directData,
		String shoppingIntent,
		Boolean wholeHouseConsidered,
		String stateCode,
		String pwsid
	) {
		var selection = actionCheckerService.normalize(
			waterSource,
			directData,
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
