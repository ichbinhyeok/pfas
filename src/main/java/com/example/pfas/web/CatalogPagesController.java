package com.example.pfas.web;

import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Optional;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.server.ResponseStatusException;

import com.example.pfas.catalog.FilterCollectionSurface;
import com.example.pfas.catalog.FilterProductSurface;
import com.example.pfas.catalog.FilterSurfaceService;
import com.example.pfas.commercial.CommercialSurfaceState;
import com.example.pfas.quality.RouteQualityGateService;
import com.example.pfas.source.SourceDocument;
import com.example.pfas.source.SourceRegistryService;

@Controller
public class CatalogPagesController {

	private final FilterSurfaceService filterSurfaceService;
	private final SourceRegistryService sourceRegistryService;
	private final RouteQualityGateService routeQualityGateService;

	public CatalogPagesController(
		FilterSurfaceService filterSurfaceService,
		SourceRegistryService sourceRegistryService,
		RouteQualityGateService routeQualityGateService
	) {
		this.filterSurfaceService = filterSurfaceService;
		this.sourceRegistryService = sourceRegistryService;
		this.routeQualityGateService = routeQualityGateService;
	}

	@GetMapping("/filters/{productId}")
	public String product(@PathVariable String productId, Model model) {
		var surface = filterSurfaceService.getProductSurface(productId)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown product route: " + productId));
		model.addAttribute("surface", surface);
		model.addAttribute("sources", resolveSources(surface.product().sourceIds()));
		model.addAttribute("commercialState", new CommercialSurfaceState(
			"FILTER_PRODUCT:" + surface.routeKey().toUpperCase(),
			"Shop unlocked",
			"This product record is ready to hand off because certification, upkeep, and exclusions are already visible.",
			"Certification scope, upkeep, and seller path are already on this page, so the merchant handoff stays inspectable.",
			"Merchant path is " + surface.merchantLabel().toLowerCase() + ".",
			"Use the route details here before clicking out to the merchant record.",
			true
		));
		model.addAttribute("pageIndexable", routeQualityGateService.isIndexable(surface.routeType(), surface.routeKey()));
		return "pages/filter-product-page";
	}

	@GetMapping("/filters/brands/{slug}")
	public String brand(@PathVariable String slug, Model model) {
		return collection(FilterSurfaceService.ROUTE_TYPE_FILTER_BRAND, slug, model);
	}

	@GetMapping("/filters/installations/{slug}")
	public String installation(@PathVariable String slug, Model model) {
		return collection(FilterSurfaceService.ROUTE_TYPE_FILTER_INSTALLATION, slug, model);
	}

	@GetMapping("/filters/types/{slug}")
	public String filterType(@PathVariable String slug, Model model) {
		return collection(FilterSurfaceService.ROUTE_TYPE_FILTER_TYPE, slug, model);
	}

	@GetMapping("/filters/merchants/{slug}")
	public String merchant(@PathVariable String slug, Model model) {
		return collection(FilterSurfaceService.ROUTE_TYPE_FILTER_MERCHANT, slug, model);
	}

	private String collection(String routeType, String routeKey, Model model) {
		var surface = filterSurfaceService.getCollectionSurface(routeType, routeKey)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown catalog route: " + routeType + ":" + routeKey));
		model.addAttribute("surface", surface);
		model.addAttribute("sources", resolveSources(sourceIds(surface.products())));
		model.addAttribute("commercialState", new CommercialSurfaceState(
			surface.routeType().toUpperCase() + ":" + surface.routeKey().toUpperCase(),
			"Shop unlocked",
			"Merchant comparison is open because this collection already keeps certification, upkeep, and exclusions visible.",
			"This collection narrows the catalog without hiding upkeep, certification scope, or installation constraints.",
			surface.groupLabel() + " is " + surface.groupValue().toLowerCase() + ".",
			"Use this collection to narrow the lane, then inspect the exact product record before clicking out.",
			true
		));
		model.addAttribute("pageIndexable", routeQualityGateService.isIndexable(surface.routeType(), surface.routeKey()));
		return "pages/filter-collection-page";
	}

	private List<SourceDocument> resolveSources(List<String> sourceIds) {
		return sourceIds.stream()
			.map(sourceRegistryService::getDocument)
			.flatMap(Optional::stream)
			.sorted(Comparator.comparingInt(SourceDocument::trustTier).thenComparing(SourceDocument::organization))
			.limit(8)
			.toList();
	}

	private List<String> sourceIds(List<com.example.pfas.filter.FilterCatalogItem> products) {
		var ids = new LinkedHashSet<String>();
		products.forEach(product -> ids.addAll(product.sourceIds()));
		return List.copyOf(ids);
	}
}
