package com.example.pfas.privatewell;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Locale;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.stereotype.Service;

import com.example.pfas.checker.ActionBenchmarkRelation;
import com.example.pfas.stateprofile.StateBenchmarkLine;
import com.example.pfas.stateprofile.StateBenchmarkProfile;
import com.example.pfas.stateprofile.StateBenchmarkProfileService;

@Service
public class PrivateWellBenchmarkEvaluatorService {

	private static final Pattern NUMERIC_PATTERN = Pattern.compile("(\\d+(?:\\.\\d+)?)");
	private static final BigDecimal THOUSAND = new BigDecimal("1000");

	private final StateBenchmarkProfileService stateBenchmarkProfileService;

	public PrivateWellBenchmarkEvaluatorService(StateBenchmarkProfileService stateBenchmarkProfileService) {
		this.stateBenchmarkProfileService = stateBenchmarkProfileService;
	}

	public Optional<PrivateWellBenchmarkEvaluation> evaluate(String stateCode, String analyteCode, BigDecimal inputValue, String inputUnit) {
		if (stateCode == null || analyteCode == null || analyteCode.isBlank() || inputValue == null || inputUnit == null || inputUnit.isBlank()) {
			return Optional.empty();
		}

		var profile = stateBenchmarkProfileService.getByStateCode(stateCode.toUpperCase(Locale.ROOT)).orElse(null);
		if (profile == null) {
			return Optional.empty();
		}

		var normalizedAnalyte = analyteCode.trim().toUpperCase(Locale.ROOT);
		var matchedLine = profile.benchmarks().stream()
			.filter(line -> normalizedAnalyte.equals(line.contaminantCode()))
			.findFirst()
			.orElse(null);

		var normalizedValuePpt = toPpt(inputValue, inputUnit);
		if (normalizedValuePpt == null) {
			return Optional.of(new PrivateWellBenchmarkEvaluation(
				profile.stateCode(),
				normalizedAnalyte,
				inputValue,
				inputUnit,
				null,
				matchedLine != null ? matchedLine.label() : profile.primaryReferenceLabel(),
				matchedLine != null ? matchedLine.benchmarkDisplay() : null,
				profile.comparabilityMode(),
				ActionBenchmarkRelation.NOT_COMPARABLE,
				"Unit conversion is not currently supported for " + inputUnit + "."
			));
		}

		if (matchedLine == null) {
			return Optional.of(new PrivateWellBenchmarkEvaluation(
				profile.stateCode(),
				normalizedAnalyte,
				inputValue,
				inputUnit,
				normalizedValuePpt,
				profile.primaryReferenceLabel(),
				null,
				profile.comparabilityMode(),
				ActionBenchmarkRelation.NOT_COMPARABLE,
				"No direct state benchmark line is currently seeded for " + normalizedAnalyte + " in " + profile.stateCode() + "."
			));
		}

		var benchmarkValuePpt = parseBenchmarkPpt(matchedLine);
		if (benchmarkValuePpt == null) {
			return Optional.of(new PrivateWellBenchmarkEvaluation(
				profile.stateCode(),
				normalizedAnalyte,
				inputValue,
				inputUnit,
				normalizedValuePpt,
				matchedLine.label(),
				matchedLine.benchmarkDisplay(),
				profile.comparabilityMode(),
				ActionBenchmarkRelation.NOT_COMPARABLE,
				"The matched reference line is context-only and does not support direct numeric comparison."
			));
		}

		var relation = normalizedValuePpt.compareTo(benchmarkValuePpt) > 0
			? ActionBenchmarkRelation.ABOVE_REFERENCE
			: ActionBenchmarkRelation.BELOW_REFERENCE;

		return Optional.of(new PrivateWellBenchmarkEvaluation(
			profile.stateCode(),
			normalizedAnalyte,
			inputValue,
			inputUnit,
			normalizedValuePpt.stripTrailingZeros(),
			matchedLine.label(),
			matchedLine.benchmarkDisplay(),
			profile.comparabilityMode(),
			relation,
			relation == ActionBenchmarkRelation.ABOVE_REFERENCE
				? "The entered analyte value is above the currently seeded state reference line."
				: "The entered analyte value is at or below the currently seeded state reference line."
		));
	}

	private BigDecimal toPpt(BigDecimal value, String inputUnit) {
		var normalizedUnit = inputUnit.trim().toLowerCase(Locale.ROOT);
		return switch (normalizedUnit) {
			case "ppt", "ng/l" -> value;
			case "ppb", "ug/l" -> value.multiply(THOUSAND);
			default -> null;
		};
	}

	private BigDecimal parseBenchmarkPpt(StateBenchmarkLine line) {
		var matcher = NUMERIC_PATTERN.matcher(line.benchmarkDisplay());
		if (!matcher.find()) {
			return null;
		}

		var numeric = new BigDecimal(matcher.group(1));
		var normalizedUnit = line.unit() == null ? "" : line.unit().trim().toLowerCase(Locale.ROOT);
		return switch (normalizedUnit) {
			case "ppt", "ng/l" -> numeric;
			case "ppb", "ug/l" -> numeric.multiply(THOUSAND);
			default -> null;
		};
	}
}
