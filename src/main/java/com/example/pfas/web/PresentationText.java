package com.example.pfas.web;

import java.math.BigDecimal;
import java.math.RoundingMode;
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
}
