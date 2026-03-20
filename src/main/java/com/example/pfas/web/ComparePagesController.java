package com.example.pfas.web;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.server.ResponseStatusException;

import com.example.pfas.quality.RouteQualityGateService;
import com.example.pfas.site.PageStructuredDataService;

@Controller
public class ComparePagesController {

	private final ComparePageService comparePageService;
	private final GuidePageService guidePageService;
	private final RouteQualityGateService routeQualityGateService;
	private final PageStructuredDataService pageStructuredDataService;

	public ComparePagesController(
		ComparePageService comparePageService,
		GuidePageService guidePageService,
		RouteQualityGateService routeQualityGateService,
		PageStructuredDataService pageStructuredDataService
	) {
		this.comparePageService = comparePageService;
		this.guidePageService = guidePageService;
		this.routeQualityGateService = routeQualityGateService;
		this.pageStructuredDataService = pageStructuredDataService;
	}

	@GetMapping("/compare/{slug}")
	public String compare(@PathVariable String slug, Model model) {
		var page = comparePageService.getBySlug(slug)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown compare slug: " + slug));

		model.addAttribute("page", page);
		model.addAttribute("compareSources", comparePageService.resolveSources(page));
		model.addAttribute("relatedProducts", comparePageService.resolveProducts(page));
		model.addAttribute("relatedSystems", comparePageService.resolveRelatedSystems(page));
		model.addAttribute("relatedGuides", comparePageService.resolveRelatedGuides(page));
		model.addAttribute("allGuides", guidePageService.getAll());
		model.addAttribute("metrics", comparePageService.summarize(page));
		model.addAttribute("pageIndexable", routeQualityGateService.isIndexable("compare", page.slug()));
		model.addAttribute("pageStructuredDataJson", pageStructuredDataService.comparePageJsonLd(page, comparePageService.resolveProducts(page)));
		return "pages/compare-page";
	}
}
