package com.example.pfas.web;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.server.ResponseStatusException;

import com.example.pfas.commercial.CommercialSurfaceService;
import com.example.pfas.filter.FilterCatalogItem;
import com.example.pfas.filter.FilterCatalogService;
import com.example.pfas.quality.RouteQualityGateService;
import com.example.pfas.readiness.ExpansionReadinessService;
import com.example.pfas.result.PublicWaterResultService;
import com.example.pfas.site.PageStructuredDataService;
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
	private final PublicWaterResultService publicWaterResultService;
	private final FilterCatalogService filterCatalogService;
	private final ComparePageService comparePageService;
	private final ExpansionReadinessService expansionReadinessService;
	private final RouteQualityGateService routeQualityGateService;
	private final PageStructuredDataService pageStructuredDataService;
	private final CommercialSurfaceService commercialSurfaceService;

	public GuidePagesController(
		GuidePageService guidePageService,
		SourceRegistryService sourceRegistryService,
		StateGuidanceService stateGuidanceService,
		PublicWaterSystemService publicWaterSystemService,
		PublicWaterResultService publicWaterResultService,
		FilterCatalogService filterCatalogService,
		ComparePageService comparePageService,
		ExpansionReadinessService expansionReadinessService,
		RouteQualityGateService routeQualityGateService,
		PageStructuredDataService pageStructuredDataService,
		CommercialSurfaceService commercialSurfaceService
	) {
		this.guidePageService = guidePageService;
		this.sourceRegistryService = sourceRegistryService;
		this.stateGuidanceService = stateGuidanceService;
		this.publicWaterSystemService = publicWaterSystemService;
		this.publicWaterResultService = publicWaterResultService;
		this.filterCatalogService = filterCatalogService;
		this.comparePageService = comparePageService;
		this.expansionReadinessService = expansionReadinessService;
		this.routeQualityGateService = routeQualityGateService;
		this.pageStructuredDataService = pageStructuredDataService;
		this.commercialSurfaceService = commercialSurfaceService;
	}

	@GetMapping("/guides/{slug}")
	public String guide(@PathVariable String slug, Model model) {
		var page = guidePageService.getBySlug(slug)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown guide slug: " + slug));
		var guideSources = page.sourceIds().stream()
			.map(sourceRegistryService::getDocument)
			.flatMap(java.util.Optional::stream)
			.sorted(java.util.Comparator.comparingInt(SourceDocument::trustTier).thenComparing(SourceDocument::organization))
			.toList();
		var relatedSystems = page.relatedPwsids() == null
			? List.<GuideSystemExample>of()
			: page.relatedPwsids().stream()
				.map(this::resolveGuideSystemExample)
				.flatMap(java.util.Optional::stream)
				.toList();
		var relatedProducts = page.relatedProductIds() == null
			? List.<FilterCatalogItem>of()
			: page.relatedProductIds().stream()
				.map(filterCatalogService::getByProductId)
				.flatMap(java.util.Optional::stream)
				.toList();

		model.addAttribute("page", page);
		model.addAttribute("allGuides", guidePageService.getAll());
		model.addAttribute("searchPriorityGuides", guidePageService.getSearchPriorityGuides());
		model.addAttribute("guideSources", guideSources);
		model.addAttribute("relatedSystemExamples", relatedSystems);
		model.addAttribute("relatedProducts", relatedProducts);
		model.addAttribute("relatedComparePages", comparePageService.resolveRelatedToGuide(page, 3));
		model.addAttribute("commercialState", commercialSurfaceService.forGuidePage(page, relatedProducts));
		model.addAttribute("pageIndexable", routeQualityGateService.isIndexable("guide", page.slug()));
		model.addAttribute("pageStructuredDataJson", pageStructuredDataService.guidePageJsonLd(page, relatedProducts));
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

	private java.util.Optional<GuideSystemExample> resolveGuideSystemExample(String pwsid) {
		var system = publicWaterSystemService.getByPwsid(pwsid);
		var result = publicWaterResultService.getByPwsid(pwsid);

		if (system.isEmpty() || result.isEmpty()) {
			return java.util.Optional.empty();
		}

		return java.util.Optional.of(new GuideSystemExample(system.get(), result.get()));
	}
}
