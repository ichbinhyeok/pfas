package com.example.pfas.web;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URI;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Objects;

import com.example.pfas.checker.ActionBenchmarkRelation;
import com.example.pfas.checker.ActionCurrentFilterStatus;
import com.example.pfas.checker.ActionDirectDataStatus;
import com.example.pfas.checker.ActionIndirectDataStatus;
import com.example.pfas.checker.ActionWaterSource;
import com.example.pfas.decision.BenchmarkComparisonStatus;
import com.example.pfas.filter.FilterCatalogItem;

public final class PresentationText {

	private PresentationText() {
	}

	public static String waterSourceLabel(ActionWaterSource waterSource) {
		if (waterSource == null) {
			return "Not set";
		}
		return switch (waterSource) {
			case PUBLIC_WATER -> "Public water";
			case PRIVATE_WELL -> "Private well";
		};
	}

	public static String directDataLabel(ActionDirectDataStatus directDataStatus) {
		if (directDataStatus == null) {
			return "Not set";
		}
		return switch (directDataStatus) {
			case NONE -> "Not yet available";
			case UTILITY_DOCUMENT -> "Utility document";
			case OFFICIAL_NOTICE -> "Official notice";
			case PRIVATE_WELL_TEST -> "Private-well test";
		};
	}

	public static String indirectDataLabel(ActionIndirectDataStatus indirectDataStatus) {
		if (indirectDataStatus == null) {
			return "None";
		}
		return switch (indirectDataStatus) {
			case NONE -> "None";
			case UCMR_ONLY -> "UCMR only";
			case PFAS_ANALYTIC_TOOL_ONLY -> "PFAS analytic tool only";
			case ZIP_HINT_ONLY -> "ZIP hint only";
		};
	}

	public static String benchmarkRelationLabel(ActionBenchmarkRelation benchmarkRelation) {
		if (benchmarkRelation == null) {
			return "Unknown";
		}
		return benchmarkRelationLabel(benchmarkRelation.name().toLowerCase(Locale.US));
	}

	public static String currentFilterStatusLabel(ActionCurrentFilterStatus currentFilterStatus) {
		if (currentFilterStatus == null) {
			return "Not set";
		}
		return switch (currentFilterStatus) {
			case NONE -> "No current filter";
			case CERTIFIED -> "Certified filter";
			case UNCERTIFIED -> "Uncertified filter";
			case UNKNOWN -> "Filter status unknown";
		};
	}

	public static String benchmarkRelationLabel(String benchmarkRelation) {
		if (benchmarkRelation == null || benchmarkRelation.isBlank()) {
			return "Not set";
		}
		return switch (benchmarkRelation) {
			case "above_reference" -> "Above selected reference";
			case "below_reference" -> "Present below selected reference";
			case "insufficient_benchmark" -> "Benchmark review required";
			case "not_detected" -> "Not detected or zero reported";
			default -> titleCaseUnderscore(benchmarkRelation);
		};
	}

	public static String comparisonStatusLabel(BenchmarkComparisonStatus comparisonStatus) {
		if (comparisonStatus == null) {
			return "Not set";
		}
		return switch (comparisonStatus) {
			case ABOVE_SELECTED_BENCHMARK -> "Above selected benchmark";
			case PRESENT_BELOW_SELECTED_BENCHMARK -> "Present below benchmark";
			case NON_DETECT_OR_ZERO_REPORTED -> "Not detected or zero reported";
			case INSUFFICIENT_BENCHMARK -> "Benchmark review required";
		};
	}

	public static String confidenceLabel(String confidence) {
		return titleCaseUnderscore(confidence);
	}

	public static String systemTypeLabel(String systemType) {
		var value = titleCaseUnderscore(systemType);
		if (value.isBlank()) {
			return "System type not set";
		}
		return value.endsWith("system") ? value : value + " system";
	}

	public static String sourceWaterTypeLabel(String sourceWaterType) {
		var value = titleCaseUnderscore(sourceWaterType);
		return value.isBlank() ? "Source water not set" : value;
	}

	public static String installationTypeLabel(String installationType) {
		var value = titleCaseUnderscore(installationType);
		return value.isBlank() ? "Installation type not set" : value;
	}

	public static String filterTypeLabel(String filterType) {
		if (filterType == null || filterType.isBlank()) {
			return "Filter type not set";
		}
		return switch (filterType) {
			case "reverse_osmosis" -> "Reverse osmosis";
			case "carbon_block" -> "Carbon block";
			case "carbon_fiber" -> "Carbon fiber";
			default -> titleCaseUnderscore(filterType);
		};
	}

	public static String cadenceLabel(Integer months) {
		if (months == null || months <= 0) {
			return "Cadence not normalized";
		}
		return months + "-month replacement cadence";
	}

	public static String previewList(List<String> values, int limit) {
		if (values == null || values.isEmpty()) {
			return "No mapped values";
		}
		var safeLimit = Math.max(limit, 1);
		var preview = values.stream()
			.filter(Objects::nonNull)
			.filter(value -> !value.isBlank())
			.limit(safeLimit)
			.reduce((left, right) -> left + ", " + right)
			.orElse("");
		if (values.size() <= safeLimit) {
			return preview;
		}
		return preview + " +" + (values.size() - safeLimit) + " more";
	}

	public static String currencyLabel(BigDecimal amount) {
		if (amount == null) {
			return "Price not normalized";
		}
		return "$" + amount.setScale(2, RoundingMode.HALF_UP).toPlainString();
	}

	public static String currencyRangeLabel(BigDecimal low, BigDecimal high, String fallback) {
		if (low == null && high == null) {
			return fallback;
		}
		if (low == null || high == null) {
			return currencyLabel(low == null ? high : low);
		}
		if (low.compareTo(high) == 0) {
			return currencyLabel(low);
		}
		return currencyLabel(low) + " - " + currencyLabel(high);
	}

	public static String annualizedMaintenanceLabel(FilterCatalogItem product) {
		var total = annualizedMaintenanceAmount(product);
		return total == null ? "Maintenance not normalized" : currencyLabel(total) + " annualized";
	}

	public static BigDecimal annualizedMaintenanceAmount(FilterCatalogItem product) {
		if (product == null) {
			return null;
		}

		BigDecimal total = null;
		if (product.replacementCostUsd() != null && product.replacementCadenceMonths() != null && product.replacementCadenceMonths() > 0) {
			total = annualize(product.replacementCostUsd(), product.replacementCadenceMonths());
		}
		if (product.membraneCostUsd() != null) {
			total = total == null ? product.membraneCostUsd() : total.add(product.membraneCostUsd());
		}
		if (product.serviceCostUsd() != null) {
			total = total == null ? product.serviceCostUsd() : total.add(product.serviceCostUsd());
		}
		if (product.recurringCostComponents() != null) {
			for (var component : product.recurringCostComponents()) {
				if (component.componentCostUsd() != null && component.cadenceMonths() != null && component.cadenceMonths() > 0) {
					var annualized = annualize(component.componentCostUsd(), component.cadenceMonths());
					total = total == null ? annualized : total.add(annualized);
				}
			}
		}

		return total;
	}

	public static String merchantLabel(FilterCatalogItem product) {
		if (product == null) {
			return "Merchant";
		}
		if (product.brand() != null && !product.brand().isBlank()) {
			return product.brand();
		}
		if (product.listingUrl() == null || product.listingUrl().isBlank()) {
			return "Merchant";
		}
		try {
			var host = URI.create(product.listingUrl()).getHost();
			if (host == null || host.isBlank()) {
				return "Merchant";
			}
			var normalized = host.toLowerCase(Locale.US).replaceFirst("^www\\.", "");
			if (normalized.contains("aquasana")) {
				return "Aquasana";
			}
			if (normalized.contains("aquatru")) {
				return "AquaTru";
			}
			if (normalized.contains("zerowater")) {
				return "ZeroWater";
			}
			if (normalized.contains("waterdrop")) {
				return "Waterdrop";
			}
			if (normalized.contains("amway")) {
				return "Amway";
			}
			return normalized;
		}
		catch (Exception ignored) {
			return "Merchant";
		}
	}

	public static String bestForLabel(FilterCatalogItem product) {
		if (product == null) {
			return "Best for a narrowly scoped drinking-water intervention.";
		}
		var installationType = safeLower(product.installationType());
		var filterType = safeLower(product.filterType());
		if (installationType.contains("under_sink") && filterType.contains("reverse_osmosis")) {
			return "Best for households that accept installation and higher upkeep to keep a narrow point-of-use route.";
		}
		if (installationType.contains("under_sink")) {
			return "Best for households that want a daily-use under-sink route without jumping straight to whole-house treatment.";
		}
		if (installationType.contains("countertop")) {
			return "Best for renters or low-plumbing households that still want a deliberate point-of-use lane.";
		}
		if (installationType.contains("pitcher") || installationType.contains("dispenser")) {
			return "Best for low-commitment households that prioritize a narrow intervention and simple setup.";
		}
		if (installationType.contains("faucet") || installationType.contains("direct_connect")) {
			return "Best for households that want a lighter-installation route with easier day-one adoption.";
		}
		return "Best for households that need a proportionate point-of-use option tied to direct evidence.";
	}

	public static String notForLabel(FilterCatalogItem product) {
		if (product == null) {
			return "Not for whole-house expectations or zero-maintenance assumptions.";
		}
		var installationType = safeLower(product.installationType());
		var filterType = safeLower(product.filterType());
		if (installationType.contains("pitcher") || installationType.contains("dispenser")) {
			return "Not for households that want high-capacity flow with minimal refill friction.";
		}
		if (installationType.contains("countertop")) {
			return "Not for households that cannot spare counter space or want hidden plumbing integration.";
		}
		if (filterType.contains("reverse_osmosis")) {
			return "Not for households that want the lowest-maintenance ownership path.";
		}
		if (installationType.contains("under_sink")) {
			return "Not for households that cannot install under-sink hardware or only need a very light-touch solution.";
		}
		return "Not for households expecting this page to justify whole-house escalation.";
	}

	public static String sellerChoiceNote(FilterCatalogItem product) {
		if (product == null) {
			return "This click should stay tied to an official record, not a generic roundup link.";
		}
		var listingUrl = safeLower(product.listingUrl());
		if (listingUrl.contains("info.nsf.org")) {
			return "The click goes to the certification listing itself, which keeps the product lane grounded in the listing record.";
		}
		if (listingUrl.endsWith(".pdf") || listingUrl.contains("performance")) {
			return "The click goes to a performance document, which makes the commercial path evidence-forward instead of storefront-first.";
		}
		if (product.sourceIds() != null && product.sourceIds().stream().anyMatch(sourceId -> sourceId != null && sourceId.toLowerCase(Locale.US).contains("performance"))) {
			return "The click goes to the current official product record while the engine keeps the paired performance document in its source set.";
		}
		return "The click goes to the current official product record used in the normalized catalog, not a generic affiliate wrapper.";
	}

	public static String maintenanceBurdenLabel(FilterCatalogItem product) {
		var annualized = annualizedMaintenanceAmount(product);
		if (annualized == null) {
			return "Maintenance burden not normalized";
		}
		if (annualized.compareTo(BigDecimal.valueOf(120)) <= 0) {
			return "Lighter maintenance burden";
		}
		if (annualized.compareTo(BigDecimal.valueOf(220)) <= 0) {
			return "Moderate maintenance burden";
		}
		return "Heavier maintenance burden";
	}

	public static String nextStepLabel(FilterCatalogItem product) {
		if (product == null) {
			return "Verify the exact certification record before taking the commercial path.";
		}
		var installationType = safeLower(product.installationType());
		var filterType = safeLower(product.filterType());
		if (installationType.contains("pitcher") || installationType.contains("dispenser")) {
			return "Use this lane only if a low-commitment point-of-use route matches the household.";
		}
		if (installationType.contains("countertop")) {
			return "Use this lane when fast setup matters more than a hidden install.";
		}
		if (installationType.contains("under_sink") && filterType.contains("reverse_osmosis")) {
			return "Use this lane only if the household accepts installation and a heavier ownership path.";
		}
		if (installationType.contains("under_sink")) {
			return "Use this lane when a daily-use under-sink route fits the household better than a light-touch option.";
		}
		return "Verify the official record before deciding whether this point-of-use path fits the household.";
	}

	public static List<String> productPros(FilterCatalogItem product) {
		if (product == null) {
			return List.of();
		}
		var pros = new java.util.ArrayList<String>();
		pros.add("Keeps the intervention at the point-of-use level.");
		var annualized = annualizedMaintenanceAmount(product);
		if (annualized != null && annualized.compareTo(BigDecimal.valueOf(120)) <= 0) {
			pros.add("Annualized upkeep stays in the lighter range for the current catalog.");
		}
		if (safeLower(product.filterType()).contains("reverse_osmosis")) {
			pros.add("RO route can fit households that explicitly want a higher-burden treatment class.");
		}
		else {
			pros.add("Non-RO ownership path usually stays simpler for households that want proportionate treatment.");
		}
		if (safeLower(product.installationType()).contains("countertop") || safeLower(product.installationType()).contains("pitcher")) {
			pros.add("Lower installation burden makes the lane easier to adopt quickly.");
		}
		else if (safeLower(product.installationType()).contains("under_sink")) {
			pros.add("Under-sink placement reduces daily-use friction once installed.");
		}
		return pros.stream().distinct().limit(3).toList();
	}

	public static List<String> productConstraints(FilterCatalogItem product) {
		if (product == null) {
			return List.of();
		}
		var constraints = new java.util.ArrayList<String>();
		var installationType = safeLower(product.installationType());
		var filterType = safeLower(product.filterType());
		var annualized = annualizedMaintenanceAmount(product);
		if (filterType.contains("reverse_osmosis")) {
			constraints.add("RO ownership usually means more components and more maintenance discipline.");
		}
		if (installationType.contains("under_sink")) {
			constraints.add("Under-sink install effort is real and should not be treated as a zero-friction upgrade.");
		}
		if (installationType.contains("countertop")) {
			constraints.add("Countertop systems trade plumbing simplicity for visible footprint.");
		}
		if (installationType.contains("pitcher") || installationType.contains("dispenser")) {
			constraints.add("Pitcher or dispenser flow usually comes with refill friction.");
		}
		if (annualized != null && annualized.compareTo(BigDecimal.valueOf(180)) > 0) {
			constraints.add("Annualized upkeep sits in the heavier range for the current catalog.");
		}
		constraints.add("This lane does not justify whole-house escalation by itself.");
		return constraints.stream().distinct().limit(3).toList();
	}

	private static String titleCaseUnderscore(String rawValue) {
		if (rawValue == null || rawValue.isBlank()) {
			return "";
		}
		return Arrays.stream(rawValue.trim().split("[_\\s]+"))
			.filter(token -> !token.isBlank())
			.map(PresentationText::titleCaseToken)
			.filter(Objects::nonNull)
			.reduce((left, right) -> left + " " + right)
			.orElse("");
	}

	private static String titleCaseToken(String token) {
		if (token == null || token.isBlank()) {
			return null;
		}
		var lower = token.toLowerCase(Locale.US);
		return Character.toUpperCase(lower.charAt(0)) + lower.substring(1);
	}

	private static BigDecimal annualize(BigDecimal cost, int cadenceMonths) {
		return cost.multiply(BigDecimal.valueOf(12))
			.divide(BigDecimal.valueOf(cadenceMonths), 2, RoundingMode.HALF_UP);
	}

	private static String safeLower(String value) {
		return value == null ? "" : value.toLowerCase(Locale.US);
	}
}
