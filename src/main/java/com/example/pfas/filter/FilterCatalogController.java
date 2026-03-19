package com.example.pfas.filter;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/internal/filter-catalog")
public class FilterCatalogController {

	private final FilterCatalogService filterCatalogService;

	public FilterCatalogController(FilterCatalogService filterCatalogService) {
		this.filterCatalogService = filterCatalogService;
	}

	@GetMapping
	public List<FilterCatalogItem> list(@RequestParam(required = false) String coveredPfas) {
		if (coveredPfas == null || coveredPfas.isBlank()) {
			return filterCatalogService.getAll();
		}

		return filterCatalogService.getForPfasCoverage(List.of(coveredPfas));
	}

	@GetMapping("/{productId}")
	public FilterCatalogItem getOne(@PathVariable String productId) {
		return filterCatalogService.getByProductId(productId)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown productId: " + productId));
	}
}
