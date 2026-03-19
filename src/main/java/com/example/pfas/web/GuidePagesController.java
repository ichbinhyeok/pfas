package com.example.pfas.web;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.server.ResponseStatusException;

import com.example.pfas.filter.FilterCatalogService;
import com.example.pfas.readiness.ExpansionReadinessService;
import com.example.pfas.source.SourceDocument;
import com.example.pfas.source.SourceRegistryService;
import com.example.pfas.state.StateGuidanceService;
import com.example.pfas.water.PublicWaterSystemService;

@Controller
public class GuidePagesController {

	private final GuidePageService guidePageService;
	private final SourceRegistryService sourceRegistryService;
	private final StateGuidanceService stateGuidanceService;
	private final PublicWaterSystemService publicWaterSystemService;
	private final FilterCatalogService filterCatalogService;
	private final ExpansionReadinessService expansionReadinessService;

	public GuidePagesController(
		GuidePageService guidePageService,
		SourceRegistryService sourceRegistryService,
		StateGuidanceService stateGuidanceService,
		PublicWaterSystemService publicWaterSystemService,
		FilterCatalogService filterCatalogService,
		ExpansionReadinessService expansionReadinessService
	) {
		this.guidePageService = guidePageService;
		this.sourceRegistryService = sourceRegistryService;
		this.stateGuidanceService = stateGuidanceService;
		this.publicWaterSystemService = publicWaterSystemService;
		this.filterCatalogService = filterCatalogService;
		this.expansionReadinessService = expansionReadinessService;
	}

	@GetMapping("/guides/{slug}")
	public String guide(@PathVariable String slug, Model model) {
		var page = guidePageService.getBySlug(slug)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown guide slug: " + slug));

		model.addAttribute("page", page);
		model.addAttribute("allGuides", guidePageService.getAll());
		return "pages/guide-page";
	}

	@GetMapping("/methodology")
	public String methodology(Model model) {
		addCounts(model);
		return "pages/methodology";
	}

	@GetMapping("/source-policy")
	public String sourcePolicy(Model model) {
		var documents = sourceRegistryService.getAllDocuments();
		model.addAttribute("tier1Sources", filterByTier(documents, 1));
		model.addAttribute("tier2Sources", filterByTier(documents, 2));
		model.addAttribute("tier3Sources", filterByTier(documents, 3));
		model.addAttribute("tier4Sources", filterByTier(documents, 4));
		addCounts(model);
		return "pages/source-policy";
	}

	private void addCounts(Model model) {
		var readiness = expansionReadinessService.getReport();
		model.addAttribute("sourceCount", sourceRegistryService.getAllDocuments().size());
		model.addAttribute("stateCount", stateGuidanceService.getAll().size());
		model.addAttribute("publicWaterCount", publicWaterSystemService.getAll().size());
		model.addAttribute("filterCount", filterCatalogService.getAll().size());
		model.addAttribute("guideCount", guidePageService.getAll().size());
		model.addAttribute("readyStateCount", readiness.readyStateRoutes());
		model.addAttribute("blockedStateCount", readiness.blockedStateRoutes());
		model.addAttribute("readyPublicWaterCount", readiness.readyPublicWaterRoutes());
		model.addAttribute("blockedPublicWaterCount", readiness.blockedPublicWaterRoutes());
	}

	private List<SourceDocument> filterByTier(List<SourceDocument> documents, int trustTier) {
		return documents.stream()
			.filter(document -> document.trustTier() == trustTier)
			.limit(8)
			.toList();
	}
}
