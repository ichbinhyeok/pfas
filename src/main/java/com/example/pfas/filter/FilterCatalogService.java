package com.example.pfas.filter;

import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import org.springframework.stereotype.Service;

import com.example.pfas.certification.CertificationClaimService;

@Service
public class FilterCatalogService {

	private static final Comparator<FilterCatalogItem> ITEM_ORDER =
		Comparator.comparing(FilterCatalogItem::brand)
			.thenComparing(FilterCatalogItem::model);

	private final FilterProductRepository filterProductRepository;
	private final FilterCostRepository filterCostRepository;
	private final FilterCostComponentRepository filterCostComponentRepository;
	private final CertificationClaimService certificationClaimService;

	public FilterCatalogService(
		FilterProductRepository filterProductRepository,
		FilterCostRepository filterCostRepository,
		FilterCostComponentRepository filterCostComponentRepository,
		CertificationClaimService certificationClaimService
	) {
		this.filterProductRepository = filterProductRepository;
		this.filterCostRepository = filterCostRepository;
		this.filterCostComponentRepository = filterCostComponentRepository;
		this.certificationClaimService = certificationClaimService;
	}

	public List<FilterCatalogItem> getAll() {
		return filterProductRepository.findAll().stream()
			.map(this::toCatalogItem)
			.sorted(ITEM_ORDER)
			.toList();
	}

	public Optional<FilterCatalogItem> getByProductId(String productId) {
		return filterProductRepository.findByProductId(productId)
			.map(this::toCatalogItem);
	}

	public List<FilterCatalogItem> getForPfasCoverage(List<String> targetPfas) {
		var targetSet = targetPfas.stream()
			.map(String::toUpperCase)
			.collect(java.util.stream.Collectors.toSet());

		return getAll().stream()
			.filter(item -> item.coveredPfas().stream().map(String::toUpperCase).anyMatch(targetSet::contains))
			.toList();
	}

	private FilterCatalogItem toCatalogItem(FilterProduct product) {
		var cost = filterCostRepository.findByProductId(product.productId()).orElse(null);
		var recurringCostComponents = filterCostComponentRepository.findByProductId(product.productId());
		var claims = certificationClaimService.getByListingRecordId(product.listingRecordId());

		Set<String> sourceIds = new LinkedHashSet<>(product.sourceIds());
		Set<String> claimNames = new LinkedHashSet<>();
		Set<String> coveredPfas = new LinkedHashSet<>(product.coveredPfas());

		claims.forEach(claim -> {
			claimNames.add(claim.claimName());
			coveredPfas.addAll(claim.coveredPfas());
			sourceIds.addAll(claim.sourceIds());
		});

		if (cost != null) {
			sourceIds.addAll(cost.sourceIds());
		}
		recurringCostComponents.forEach(component -> sourceIds.addAll(component.sourceIds()));

		return new FilterCatalogItem(
			product.productId(),
			product.brand(),
			product.model(),
			product.filterType(),
			product.installationType(),
			product.certBody(),
			product.standardCode(),
			product.listingRecordId(),
			List.copyOf(claimNames),
			List.copyOf(coveredPfas),
			product.listingUrl(),
			product.replacementCadenceMonths(),
			product.replacementCapacityGallons(),
			cost != null ? cost.upfrontCostUsd() : null,
			cost != null ? cost.replacementCostUsd() : null,
			cost != null ? cost.membraneCostUsd() : null,
			cost != null ? cost.serviceCostUsd() : null,
			List.copyOf(recurringCostComponents),
			cost != null ? cost.priceObservedAt() : null,
			cost != null ? cost.costConfidence() : null,
			List.copyOf(sourceIds)
		);
	}
}
