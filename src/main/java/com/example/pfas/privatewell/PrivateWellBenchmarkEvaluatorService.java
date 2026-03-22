package com.example.pfas.privatewell;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
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
	private static final Pattern BATCH_LINE_PATTERN = Pattern.compile("^\\s*([A-Za-z0-9_\\-]+)\\s*[:=]\\s*(\\d+(?:\\.\\d+)?)\\s*([A-Za-z/]+)?\\s*$");
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

		return Optional.of(evaluateAgainstProfile(profile, analyteCode, inputValue, inputUnit));
	}

	public Optional<PrivateWellBenchmarkBatchEvaluation> evaluateBatch(String stateCode, String batchInput) {
		if (stateCode == null || batchInput == null || batchInput.isBlank()) {
			return Optional.empty();
		}

		var profile = stateBenchmarkProfileService.getByStateCode(stateCode.toUpperCase(Locale.ROOT)).orElse(null);
		if (profile == null) {
			return Optional.empty();
		}

		var measurements = parseBatchInput(batchInput);
		if (measurements.isEmpty()) {
			throw new InvalidPrivateWellBatchInputException("batchInput did not contain any parseable analyte lines.");
		}

		var evaluations = measurements.stream()
			.map(input -> evaluateAgainstProfile(profile, input.analyteCode(), input.inputValue(), input.inputUnit()))
			.toList();

		var comparableCount = (int) evaluations.stream()
			.filter(evaluation -> evaluation.benchmarkRelation() == ActionBenchmarkRelation.ABOVE_REFERENCE
				|| evaluation.benchmarkRelation() == ActionBenchmarkRelation.BELOW_REFERENCE)
			.count();
		var notComparableCount = evaluations.size() - comparableCount;
		var aggregateRelation = aggregateRelation(evaluations);

		return Optional.of(new PrivateWellBenchmarkBatchEvaluation(
			profile.stateCode(),
			aggregateRelation,
			aggregateSummary(evaluations, aggregateRelation),
			comparableCount,
			notComparableCount,
			evaluations
		));
	}

	public List<PrivateWellMeasurementInput> parseBatchInput(String batchInput) {
		if (batchInput == null || batchInput.isBlank()) {
			return List.of();
		}

		var results = new ArrayList<PrivateWellMeasurementInput>();
		var invalidLines = new ArrayList<String>();
		for (var rawLine : batchInput.split("[;\\r\\n]+")) {
			if (rawLine.isBlank()) {
				continue;
			}

			var matcher = BATCH_LINE_PATTERN.matcher(rawLine.trim());
			if (!matcher.matches()) {
				invalidLines.add(rawLine.trim());
				continue;
			}

			results.add(new PrivateWellMeasurementInput(
				matcher.group(1).trim().toUpperCase(Locale.ROOT),
				new BigDecimal(matcher.group(2)),
				matcher.group(3) == null || matcher.group(3).isBlank() ? "ppt" : matcher.group(3).trim()
			));
		}

		if (!invalidLines.isEmpty()) {
			throw new InvalidPrivateWellBatchInputException(
				"batchInput contains invalid lines: " + String.join(", ", invalidLines)
			);
		}

		return List.copyOf(results);
	}

	private PrivateWellBenchmarkEvaluation evaluateAgainstProfile(StateBenchmarkProfile profile, String analyteCode, BigDecimal inputValue, String inputUnit) {
		var normalizedAnalyte = normalizeAnalyteCode(analyteCode);
		var matchedLine = profile.benchmarks().stream()
			.filter(line -> normalizedAnalyte.equals(normalizeAnalyteCode(line.contaminantCode())))
			.findFirst()
			.orElse(null);

		var normalizedValuePpt = toPpt(inputValue, inputUnit);
		if (normalizedValuePpt == null) {
			return new PrivateWellBenchmarkEvaluation(
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
			);
		}

		if (matchedLine == null) {
			return new PrivateWellBenchmarkEvaluation(
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
			);
		}

		var benchmarkValuePpt = parseBenchmarkPpt(matchedLine);
		if (benchmarkValuePpt == null) {
			return new PrivateWellBenchmarkEvaluation(
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
			);
		}

		var relation = normalizedValuePpt.compareTo(benchmarkValuePpt) > 0
			? ActionBenchmarkRelation.ABOVE_REFERENCE
			: ActionBenchmarkRelation.BELOW_REFERENCE;

		return new PrivateWellBenchmarkEvaluation(
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
		);
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

	private ActionBenchmarkRelation aggregateRelation(List<PrivateWellBenchmarkEvaluation> evaluations) {
		var hasAbove = evaluations.stream().anyMatch(evaluation -> evaluation.benchmarkRelation() == ActionBenchmarkRelation.ABOVE_REFERENCE);
		var hasBelow = evaluations.stream().anyMatch(evaluation -> evaluation.benchmarkRelation() == ActionBenchmarkRelation.BELOW_REFERENCE);
		var hasNotComparable = evaluations.stream().anyMatch(evaluation -> evaluation.benchmarkRelation() == ActionBenchmarkRelation.NOT_COMPARABLE);

		if (hasAbove && (hasBelow || hasNotComparable)) {
			return ActionBenchmarkRelation.MIXED;
		}
		if (hasAbove) {
			return ActionBenchmarkRelation.ABOVE_REFERENCE;
		}
		if (hasBelow && !hasNotComparable) {
			return ActionBenchmarkRelation.BELOW_REFERENCE;
		}
		if (hasBelow) {
			return ActionBenchmarkRelation.NOT_COMPARABLE;
		}
		return ActionBenchmarkRelation.NOT_COMPARABLE;
	}

	private String aggregateSummary(List<PrivateWellBenchmarkEvaluation> evaluations, ActionBenchmarkRelation aggregateRelation) {
		var aboveCount = evaluations.stream().filter(evaluation -> evaluation.benchmarkRelation() == ActionBenchmarkRelation.ABOVE_REFERENCE).count();
		var belowCount = evaluations.stream().filter(evaluation -> evaluation.benchmarkRelation() == ActionBenchmarkRelation.BELOW_REFERENCE).count();
		var notComparableCount = evaluations.stream().filter(evaluation -> evaluation.benchmarkRelation() == ActionBenchmarkRelation.NOT_COMPARABLE).count();

		return "Aggregate relation is "
			+ aggregateRelation.name().toLowerCase().replace('_', ' ')
			+ " across "
			+ evaluations.size()
			+ " line(s): "
			+ aboveCount
			+ " above, "
			+ belowCount
			+ " below, "
			+ notComparableCount
			+ " not comparable.";
	}

	private String normalizeAnalyteCode(String analyteCode) {
		return analyteCode == null ? "" : analyteCode.trim().toUpperCase(Locale.ROOT);
	}
}
