package com.example.pfas.catalog;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.TreeMap;
import java.util.function.Function;

import org.springframework.stereotype.Service;

import com.example.pfas.filter.FilterCatalogItem;
import com.example.pfas.filter.FilterCatalogService;
import com.example.pfas.site.SiteMetadataService;
import com.example.pfas.web.PresentationText;

@Service
public class FilterSurfaceService {

	public static final String ROUTE_TYPE_FILTER_PRODUCT = "filter_product";
	public static final String ROUTE_TYPE_FILTER_BRAND = "filter_brand";
	public static final String ROUTE_TYPE_FILTER_INSTALLATION = "filter_installation";
	public static final String ROUTE_TYPE_FILTER_TYPE = "filter_type";
	public static final String ROUTE_TYPE_FILTER_MERCHANT = "filter_merchant";

	private final FilterCatalogService filterCatalogService;
	private final SiteMetadataService siteMetadataService;

	public FilterSurfaceService(
		FilterCatalogService filterCatalogService,
		SiteMetadataService siteMetadataService
	) {
		this.filterCatalogService = filterCatalogService;
		this.siteMetadataService = siteMetadataService;
	}

	public List<FilterProductSurface> getProductSurfaces() {
		return filterCatalogService.getAll().stream()
			.sorted(Comparator.comparing(FilterCatalogItem::productId))
			.map(this::toProductSurface)
			.toList();
	}

	public Optional<FilterProductSurface> getProductSurface(String routeKey) {
		return filterCatalogService.getByProductId(routeKey)
			.map(this::toProductSurface);
	}

	public List<FilterCollectionSurface> getCollectionSurfaces() {
		var surfaces = new ArrayList<FilterCollectionSurface>();
		surfaces.addAll(buildCollections(
			ROUTE_TYPE_FILTER_BRAND,
			FilterCatalogItem::brand,
			value -> value,
			value -> "/filters/brands/" + slugify(value),
			value -> value + " PFAS certified filter records",
			value -> "Certified " + value + " PFAS records normalized into one surface so upkeep, installation class, and exclusions stay visible.",
			"Brand lane",
			"Brand"
		));
		surfaces.addAll(buildCollections(
			ROUTE_TYPE_FILTER_INSTALLATION,
			FilterCatalogItem::installationType,
			PresentationText::installationTypeLabel,
			value -> "/filters/installations/" + slugify(value),
			value -> PresentationText.installationTypeLabel(value) + " PFAS filter options",
			value -> "Normalized " + PresentationText.installationTypeLabel(value).toLowerCase(Locale.US)
				+ " PFAS options rendered together with upkeep, cost, and claim scope kept explicit.",
			"Installation lane",
			"Installation class"
		));
		surfaces.addAll(buildCollections(
			ROUTE_TYPE_FILTER_TYPE,
			FilterCatalogItem::filterType,
			PresentationText::filterTypeLabel,
			value -> "/filters/types/" + slugify(value),
			value -> PresentationText.filterTypeLabel(value) + " PFAS filter records",
			value -> "Compare normalized " + PresentationText.filterTypeLabel(value).toLowerCase(Locale.US)
				+ " PFAS records without flattening upkeep, cadence, or installation constraints.",
			"Filter-type lane",
			"Filter type"
		));
		surfaces.addAll(buildCollections(
			ROUTE_TYPE_FILTER_MERCHANT,
			this::merchantLabel,
			Function.identity(),
			value -> "/filters/merchants/" + slugify(value),
			value -> value + " PFAS listings in the normalized catalog",
			value -> "Merchant-facing PFAS listings grouped into one surface so the click path stays attached to certification and upkeep instead of generic marketplace sorting.",
			"Merchant lane",
			"Merchant record set"
		));
		return surfaces.stream()
			.sorted(Comparator.comparing(FilterCollectionSurface::routeType).thenComparing(FilterCollectionSurface::routeKey))
			.toList();
	}

	public Optional<FilterCollectionSurface> getCollectionSurface(String routeType, String routeKey) {
		return getCollectionSurfaces().stream()
			.filter(surface -> surface.routeType().equals(routeType))
			.filter(surface -> surface.routeKey().equalsIgnoreCase(routeKey))
			.findFirst();
	}

	private FilterProductSurface toProductSurface(FilterCatalogItem product) {
		var merchantLabel = merchantLabel(product);
		return new FilterProductSurface(
			ROUTE_TYPE_FILTER_PRODUCT,
			product.productId(),
			product.brand() + " " + product.model() + " PFAS record",
			"Certification scope, upkeep, and seller path for " + product.brand() + " " + product.model()
				+ " are kept on one page so the buying decision stays inspectable.",
			"Product record",
			"/filters/" + product.productId(),
			lastVerifiedDate(product.priceObservedAt()),
			product.sourceIds().size(),
			merchantLabel,
			"/filters/brands/" + slugify(product.brand()),
			"/filters/installations/" + slugify(product.installationType()),
			"/filters/types/" + slugify(product.filterType()),
			"/filters/merchants/" + slugify(merchantLabel),
			productHighlights(product),
			productKeywords(product, merchantLabel),
			product,
			relatedProducts(product)
		);
	}

	private List<FilterCollectionSurface> buildCollections(
		String routeType,
		Function<FilterCatalogItem, String> keyExtractor,
		Function<String, String> displayValueMapper,
		Function<String, String> pathBuilder,
		Function<String, String> titleBuilder,
		Function<String, String> ledeBuilder,
		String eyebrow,
		String groupLabel
	) {
		Map<String, List<FilterCatalogItem>> grouped = new TreeMap<>();
		filterCatalogService.getAll().forEach(product ->
			grouped.computeIfAbsent(keyExtractor.apply(product), ignored -> new ArrayList<>()).add(product)
		);

		return grouped.entrySet().stream()
			.map(entry -> {
				var rawValue = entry.getKey();
				var displayValue = displayValueMapper.apply(rawValue);
				var products = entry.getValue().stream()
					.sorted(Comparator.comparing(FilterCatalogItem::brand).thenComparing(FilterCatalogItem::model))
					.toList();
				var routeKey = slugify(rawValue);
				return new FilterCollectionSurface(
					routeType,
					routeKey,
					titleBuilder.apply(rawValue),
					ledeBuilder.apply(rawValue),
					eyebrow,
					pathBuilder.apply(rawValue),
					lastVerifiedDate(products.stream().map(FilterCatalogItem::priceObservedAt).filter(value -> value != null && !value.isBlank()).findFirst().orElse(null)),
					sourceCount(products),
					groupLabel,
					displayValue,
					currencyBand(products.stream().map(FilterCatalogItem::upfrontCostUsd).toList()),
					currencyBand(products.stream().map(PresentationText::annualizedMaintenanceAmount).toList()),
					maintenanceSummary(products),
					collectionHighlights(products, displayValue),
					collectionKeywords(products, displayValue, titleBuilder.apply(rawValue)),
					products
				);
			})
			.toList();
	}

	private List<FilterCatalogItem> relatedProducts(FilterCatalogItem product) {
		return filterCatalogService.getAll().stream()
			.filter(candidate -> !candidate.productId().equals(product.productId()))
			.sorted(Comparator
				.comparing((FilterCatalogItem candidate) -> !candidate.brand().equals(product.brand()))
				.thenComparing(candidate -> !candidate.filterType().equals(product.filterType()))
				.thenComparing(candidate -> !candidate.installationType().equals(product.installationType()))
				.thenComparing(FilterCatalogItem::brand)
				.thenComparing(FilterCatalogItem::model))
			.limit(4)
			.toList();
	}

	private List<String> productHighlights(FilterCatalogItem product) {
		return List.of(
			product.certBody() + " " + product.standardCode() + " / PFAS coverage " + PresentationText.previewList(product.coveredPfas(), 4),
			"Upfront " + PresentationText.currencyLabel(product.upfrontCostUsd()) + " / Annualized " + PresentationText.annualizedMaintenanceLabel(product),
			"Best for " + PresentationText.bestForLabel(product) + " / Not for " + PresentationText.notForLabel(product)
		);
	}

	private List<String> productKeywords(FilterCatalogItem product, String merchantLabel) {
		return List.of(
			product.productId(),
			product.brand(),
			product.model(),
			product.brand() + " " + product.model(),
			PresentationText.filterTypeLabel(product.filterType()),
			PresentationText.installationTypeLabel(product.installationType()),
			merchantLabel,
			"PFAS filter",
			"certified PFAS filter"
		);
	}

	private List<String> collectionHighlights(List<FilterCatalogItem> products, String displayValue) {
		var standards = products.stream()
			.map(FilterCatalogItem::standardCode)
			.filter(value -> value != null && !value.isBlank())
			.distinct()
			.limit(3)
			.toList();
		var merchants = products.stream()
			.map(this::merchantLabel)
			.distinct()
			.toList();
		var coveredPfas = new LinkedHashSet<String>();
		products.forEach(product -> coveredPfas.addAll(product.coveredPfas()));

		return List.of(
			products.size() + " normalized product records under " + displayValue + ".",
			"Upfront " + currencyBand(products.stream().map(FilterCatalogItem::upfrontCostUsd).toList())
				+ " / Annualized " + currencyBand(products.stream().map(PresentationText::annualizedMaintenanceAmount).toList()) + ".",
			"Standards " + String.join(", ", standards) + " / Merchant set " + String.join(", ", merchants) + " / PFAS coverage "
				+ PresentationText.previewList(List.copyOf(coveredPfas), 4) + "."
		);
	}

	private List<String> collectionKeywords(List<FilterCatalogItem> products, String displayValue, String title) {
		Set<String> keywords = new LinkedHashSet<>();
		keywords.add(displayValue);
		keywords.add(title);
		keywords.add("PFAS");
		keywords.add("certified filter");
		products.forEach(product -> {
			keywords.add(product.brand());
			keywords.add(product.model());
			keywords.add(PresentationText.filterTypeLabel(product.filterType()));
			keywords.add(PresentationText.installationTypeLabel(product.installationType()));
		});
		return List.copyOf(keywords);
	}

	private int sourceCount(List<FilterCatalogItem> products) {
		Set<String> ids = new LinkedHashSet<>();
		products.forEach(product -> ids.addAll(product.sourceIds()));
		return ids.size();
	}

	private String maintenanceSummary(List<FilterCatalogItem> products) {
		var burdens = products.stream()
			.map(PresentationText::maintenanceBurdenLabel)
			.distinct()
			.toList();
		if (burdens.isEmpty()) {
			return "unknown maintenance burden";
		}
		if (burdens.size() == 1) {
			return burdens.get(0) + " maintenance burden";
		}
		return "mixed maintenance burden";
	}

	private String merchantLabel(FilterCatalogItem product) {
		return PresentationText.merchantLabel(product);
	}

	private String currencyBand(List<BigDecimal> values) {
		var normalized = values.stream()
			.filter(value -> value != null)
			.toList();
		if (normalized.isEmpty()) {
			return "price not normalized";
		}
		var min = normalized.stream().min(Comparator.naturalOrder()).orElse(BigDecimal.ZERO);
		var max = normalized.stream().max(Comparator.naturalOrder()).orElse(BigDecimal.ZERO);
		if (min.compareTo(max) == 0) {
			return PresentationText.currencyLabel(min);
		}
		return PresentationText.currencyLabel(min) + " - " + PresentationText.currencyLabel(max);
	}

	private String lastVerifiedDate(String rawValue) {
		return rawValue == null || rawValue.isBlank() ? siteMetadataService.siteLastVerifiedDate() : rawValue;
	}

	private String slugify(String value) {
		var normalized = value == null ? "" : value.toLowerCase(Locale.US);
		normalized = normalized.replace('&', ' ');
		normalized = normalized.replace('|', '-');
		normalized = normalized.replaceAll("[^a-z0-9]+", "-");
		normalized = normalized.replaceAll("(^-+|-+$)", "");
		return normalized.isBlank() ? "unknown" : normalized;
	}
}
