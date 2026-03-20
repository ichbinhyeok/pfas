package com.example.pfas.web;

import java.math.BigDecimal;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.pfas.filter.FilterCatalogItem;
import com.example.pfas.filter.FilterCatalogService;
import com.example.pfas.result.PublicWaterResultService;
import com.example.pfas.source.SourceDocument;
import com.example.pfas.source.SourceRegistryService;
import com.example.pfas.water.PublicWaterSystemService;

@Service
public class ComparePageService {

	private static final Comparator<ComparePage> PAGE_ORDER = Comparator.comparing(ComparePage::slug);

	private final ComparePageRepository comparePageRepository;
	private final GuidePageService guidePageService;
	private final FilterCatalogService filterCatalogService;
	private final SourceRegistryService sourceRegistryService;
	private final PublicWaterSystemService publicWaterSystemService;
	private final PublicWaterResultService publicWaterResultService;

	public ComparePageService(
		ComparePageRepository comparePageRepository,
		GuidePageService guidePageService,
		FilterCatalogService filterCatalogService,
		SourceRegistryService sourceRegistryService,
		PublicWaterSystemService publicWaterSystemService,
		PublicWaterResultService publicWaterResultService
	) {
		this.comparePageRepository = comparePageRepository;
		this.guidePageService = guidePageService;
		this.filterCatalogService = filterCatalogService;
		this.sourceRegistryService = sourceRegistryService;
		this.publicWaterSystemService = publicWaterSystemService;
		this.publicWaterResultService = publicWaterResultService;
	}

	public List<ComparePage> getAll() {
		return comparePageRepository.findAll().stream()
			.sorted(PAGE_ORDER)
			.toList();
	}

	public Optional<ComparePage> getBySlug(String slug) {
		return comparePageRepository.findAll().stream()
			.filter(page -> page.slug().equals(slug))
			.findFirst();
	}

	public List<GuidePage> resolveRelatedGuides(ComparePage page) {
		if (page.relatedGuideSlugs() == null) {
			return List.of();
		}
		return page.relatedGuideSlugs().stream()
			.map(guidePageService::getBySlug)
			.flatMap(Optional::stream)
			.toList();
	}

	public List<ComparePage> resolveRelatedToGuide(GuidePage guidePage, int limit) {
		var guideProductIds = upperSet(guidePage.relatedProductIds());
		var guidePwsids = upperSet(guidePage.relatedPwsids());
		var guideSources = upperSet(guidePage.sourceIds());
		var guideKeywords = keywordSet(guidePage.targetQueries(), guidePage.title(), guidePage.slug());

		return getAll().stream()
			.map(page -> new java.util.AbstractMap.SimpleEntry<>(page, score(guideProductIds, guidePwsids, guideSources, guideKeywords, page)))
			.filter(entry -> entry.getValue() > 0)
			.sorted(Comparator.<java.util.AbstractMap.SimpleEntry<ComparePage, Integer>>comparingInt(java.util.AbstractMap.SimpleEntry::getValue).reversed()
				.thenComparing(entry -> entry.getKey().slug()))
			.limit(limit)
			.map(java.util.AbstractMap.SimpleEntry::getKey)
			.toList();
	}

	public List<FilterCatalogItem> resolveProducts(ComparePage page) {
		if (page.relatedProductIds() == null) {
			return List.of();
		}
		return page.relatedProductIds().stream()
			.map(filterCatalogService::getByProductId)
			.flatMap(Optional::stream)
			.toList();
	}

	public List<GuideSystemExample> resolveRelatedSystems(ComparePage page) {
		if (page.relatedPwsids() == null) {
			return List.of();
		}
		return page.relatedPwsids().stream()
			.map(this::resolveSystemExample)
			.flatMap(Optional::stream)
			.toList();
	}

	public List<SourceDocument> resolveSources(ComparePage page) {
		if (page.sourceIds() == null) {
			return List.of();
		}
		return page.sourceIds().stream()
			.map(sourceRegistryService::getDocument)
			.flatMap(Optional::stream)
			.sorted(Comparator.comparingInt(SourceDocument::trustTier).thenComparing(SourceDocument::organization))
			.toList();
	}

	public ComparePageMetrics summarize(ComparePage page) {
		var products = resolveProducts(page);
		var annualized = products.stream()
			.map(PresentationText::annualizedMaintenanceAmount)
			.filter(java.util.Objects::nonNull)
			.toList();
		var upfront = products.stream()
			.map(FilterCatalogItem::upfrontCostUsd)
			.filter(java.util.Objects::nonNull)
			.toList();
		var installationMix = products.stream()
			.map(FilterCatalogItem::installationType)
			.map(PresentationText::installationTypeLabel)
			.distinct()
			.toList();
		var standardsMix = products.stream()
			.map(FilterCatalogItem::standardCode)
			.filter(code -> code != null && !code.isBlank())
			.distinct()
			.toList();

		return new ComparePageMetrics(
			products.size(),
			resolveRelatedSystems(page).size(),
			PresentationText.currencyRangeLabel(min(upfront), max(upfront), "Price band not normalized"),
			PresentationText.currencyRangeLabel(min(annualized), max(annualized), "Annualized band not normalized"),
			PresentationText.previewList(installationMix, 3),
			PresentationText.previewList(standardsMix, 3)
		);
	}

	private Optional<GuideSystemExample> resolveSystemExample(String pwsid) {
		var system = publicWaterSystemService.getByPwsid(pwsid);
		var result = publicWaterResultService.getByPwsid(pwsid);
		if (system.isEmpty() || result.isEmpty()) {
			return Optional.empty();
		}
		return Optional.of(new GuideSystemExample(system.get(), result.get()));
	}

	private int score(Set<String> guideProductIds, Set<String> guidePwsids, Set<String> guideSources, Set<String> guideKeywords, ComparePage page) {
		var productOverlap = overlapCount(guideProductIds, upperSet(page.relatedProductIds()));
		var pwsidOverlap = overlapCount(guidePwsids, upperSet(page.relatedPwsids()));
		var sourceOverlap = overlapCount(guideSources, upperSet(page.sourceIds()));
		var keywordOverlap = overlapCount(guideKeywords, keywordSet(page.targetQueries(), page.title(), page.slug()));
		return (productOverlap * 4) + (pwsidOverlap * 3) + (keywordOverlap * 2) + sourceOverlap;
	}

	private int overlapCount(Set<String> left, Set<String> right) {
		if (left.isEmpty() || right.isEmpty()) {
			return 0;
		}
		return (int) left.stream().filter(right::contains).count();
	}

	private Set<String> upperSet(List<String> values) {
		if (values == null) {
			return Set.of();
		}
		return values.stream()
			.filter(value -> value != null && !value.isBlank())
			.map(value -> value.toUpperCase(Locale.US))
			.collect(Collectors.toSet());
	}

	private Set<String> keywordSet(List<String> values, String... extras) {
		var stream = java.util.stream.Stream.concat(
			values == null ? java.util.stream.Stream.<String>empty() : values.stream(),
			java.util.Arrays.stream(extras)
		);
		return stream
			.filter(value -> value != null && !value.isBlank())
			.flatMap(value -> java.util.Arrays.stream(value.toLowerCase(Locale.US).split("[^a-z0-9]+")))
			.filter(token -> token.length() >= 3)
			.collect(Collectors.toSet());
	}

	private BigDecimal min(List<BigDecimal> values) {
		return values.stream().min(BigDecimal::compareTo).orElse(null);
	}

	private BigDecimal max(List<BigDecimal> values) {
		return values.stream().max(BigDecimal::compareTo).orElse(null);
	}
}
