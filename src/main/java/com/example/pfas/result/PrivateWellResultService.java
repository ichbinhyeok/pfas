package com.example.pfas.result;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.OffsetDateTime;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.example.pfas.checker.ActionBenchmarkRelation;
import com.example.pfas.checker.ActionCurrentFilterStatus;
import com.example.pfas.filter.FilterCatalogItem;
import com.example.pfas.filter.FilterCatalogService;
import com.example.pfas.privatewell.PrivateWellBenchmarkBatchEvaluation;
import com.example.pfas.privatewell.PrivateWellBenchmarkEvaluation;
import com.example.pfas.privatewell.PrivateWellBenchmarkEvaluatorService;
import com.example.pfas.source.SourceDocument;
import com.example.pfas.source.SourceRegistryService;
import com.example.pfas.state.StateGuidance;
import com.example.pfas.state.StateGuidanceService;
import com.example.pfas.stateprofile.StateBenchmarkProfile;
import com.example.pfas.stateprofile.StateBenchmarkProfileService;

@Service
public class PrivateWellResultService {

	private final StateGuidanceService stateGuidanceService;
	private final StateBenchmarkProfileService stateBenchmarkProfileService;
	private final PrivateWellBenchmarkEvaluatorService privateWellBenchmarkEvaluatorService;
	private final FilterCatalogService filterCatalogService;
	private final SourceRegistryService sourceRegistryService;

	public PrivateWellResultService(
		StateGuidanceService stateGuidanceService,
		StateBenchmarkProfileService stateBenchmarkProfileService,
		PrivateWellBenchmarkEvaluatorService privateWellBenchmarkEvaluatorService,
		FilterCatalogService filterCatalogService,
		SourceRegistryService sourceRegistryService
	) {
		this.stateGuidanceService = stateGuidanceService;
		this.stateBenchmarkProfileService = stateBenchmarkProfileService;
		this.privateWellBenchmarkEvaluatorService = privateWellBenchmarkEvaluatorService;
		this.filterCatalogService = filterCatalogService;
		this.sourceRegistryService = sourceRegistryService;
	}

	public Optional<WaterDecisionResult> get(
		String stateCode,
		ActionBenchmarkRelation benchmarkRelation,
		ActionCurrentFilterStatus currentFilterStatus,
		boolean wholeHouseConsidered
	) {
		return stateGuidanceService.getByStateCode(stateCode)
			.map(guidance -> toResult(guidance, benchmarkRelation, currentFilterStatus, wholeHouseConsidered, null, null));
	}

	public Optional<WaterDecisionResult> getFromMeasurement(
		String stateCode,
		String analyteCode,
		BigDecimal inputValue,
		String inputUnit,
		ActionCurrentFilterStatus currentFilterStatus,
		boolean wholeHouseConsidered
	) {
		return stateGuidanceService.getByStateCode(stateCode)
			.flatMap(guidance -> privateWellBenchmarkEvaluatorService.evaluate(guidance.stateCode(), analyteCode, inputValue, inputUnit)
				.map(evaluation -> toResult(
					guidance,
					evaluation.benchmarkRelation(),
					currentFilterStatus,
					wholeHouseConsidered,
					evaluation,
					null
				)));
	}

	public Optional<WaterDecisionResult> getFromBatchMeasurement(
		String stateCode,
		String batchInput,
		ActionCurrentFilterStatus currentFilterStatus,
		boolean wholeHouseConsidered
	) {
		return stateGuidanceService.getByStateCode(stateCode)
			.flatMap(guidance -> privateWellBenchmarkEvaluatorService.evaluateBatch(guidance.stateCode(), batchInput)
				.map(batchEvaluation -> toResult(
					guidance,
					batchEvaluation.aggregateRelation(),
					currentFilterStatus,
					wholeHouseConsidered,
					null,
					batchEvaluation
				)));
	}

	private WaterDecisionResult toResult(
		StateGuidance guidance,
		ActionBenchmarkRelation benchmarkRelation,
		ActionCurrentFilterStatus currentFilterStatus,
		boolean wholeHouseConsidered,
		PrivateWellBenchmarkEvaluation evaluation,
		PrivateWellBenchmarkBatchEvaluation batchEvaluation
	) {
		var profile = stateBenchmarkProfileService.getByStateCode(guidance.stateCode()).orElse(null);
		var options = benchmarkRelation == ActionBenchmarkRelation.ABOVE_REFERENCE
			|| benchmarkRelation == ActionBenchmarkRelation.MIXED
			? filterCatalogService.getForPfasCoverage(List.of("PFOA", "PFOS"))
			: List.<FilterCatalogItem>of();

		return new WaterDecisionResult(
			"private-well:" + guidance.stateCode() + ":" + benchmarkRelation.name(),
			"v1",
			OffsetDateTime.now().toString(),
			nextAction(guidance, profile, benchmarkRelation),
			whyThis(guidance, profile, benchmarkRelation, currentFilterStatus),
			whatThisDoesNotTellYou(guidance, profile),
			buildInitialCost(options),
			buildAnnualCost(options),
			certificationChecklist(),
			bestFitOptions(options),
			whenToEscalate(guidance, benchmarkRelation, wholeHouseConsidered),
			buildReferenceContext(guidance, profile),
			buildBenchmarkEvaluation(evaluation),
			buildBenchmarkBatchEvaluation(batchEvaluation),
			resolveSources(guidance, profile, options),
			new ResultMeta(
				"private_well",
				benchmarkRelation.name().toLowerCase(),
				decisionRuleId(benchmarkRelation),
				benchmarkRelation == ActionBenchmarkRelation.UNKNOWN || benchmarkRelation == ActionBenchmarkRelation.NOT_COMPARABLE
			)
		);
	}

	private NextAction nextAction(
		StateGuidance guidance,
		StateBenchmarkProfile profile,
		ActionBenchmarkRelation benchmarkRelation
	) {
		return switch (benchmarkRelation) {
			case ABOVE_REFERENCE, MIXED -> new NextAction(
				"EVALUATE_CERTIFIED_POU_FILTER_AND_STATE_NEXT_STEPS",
				"Open state next steps and evaluate certified point-of-use",
				"The well owner already has a meaningful result, so the next step is state-guided interpretation plus a certified ingestion-focused treatment option rather than a generic shopping flow.",
				"high",
				"Private-well above-reference results are action signals, not legal compliance findings."
			);
			case BELOW_REFERENCE -> new NextAction(
				"CONTINUE_PERIODIC_TESTING",
				"Keep the result in a monitoring posture and follow state guidance",
				"The well owner has a below-reference result, so the next step is to keep the interpretation state-based and use official guidance for any follow-up testing or optional treatment.",
				"medium",
				"Private-well results remain owner-managed and reference-based."
			);
			case UNKNOWN, NOT_COMPARABLE -> new NextAction(
				"GET_STATE_GUIDANCE_AND_LAB_CONTEXT",
				"Interpret the result against state guidance before acting",
				"The current benchmark relation is still unknown or not comparable, so the next step is to anchor the result in state guidance, lab context, and sampling method before treatment decisions.",
				"medium",
				"State guidance outranks generic PFAS maps or generalized advice."
			);
		};
	}

	private List<String> whyThis(
		StateGuidance guidance,
		StateBenchmarkProfile profile,
		ActionBenchmarkRelation benchmarkRelation,
		ActionCurrentFilterStatus currentFilterStatus
	) {
		var filterLine = currentFilterStatus == ActionCurrentFilterStatus.UNCERTIFIED
			? "The current filter status is uncertified, so it should not be treated as PFAS mitigation until the exact claim is verified."
			: "Any treatment path should stay certification-first and state-guided.";
		var referenceLine = profile == null
			? "State-specific benchmark context is still limited, so the route leans on direct agency guidance before any benchmark claim."
			: profile.primaryReferenceLabel() + " is the current " + guidance.stateCode() + " reference layer for this route.";
		var comparabilityLine = profile == null
			? "Benchmark relation is currently " + benchmarkRelation.name().toLowerCase().replace('_', ' ') + "."
			: "Benchmark relation is currently "
				+ benchmarkRelation.name().toLowerCase().replace('_', ' ')
				+ " under a "
				+ profile.comparabilityMode().replace('_', ' ')
				+ " comparison mode.";

		return List.of(
			"This route is for a private-well owner, so state guidance and lab context outrank any public-water logic or generic shopping flow.",
			referenceLine,
			comparabilityLine,
			filterLine
		);
	}

	private List<String> whatThisDoesNotTellYou(StateGuidance guidance, StateBenchmarkProfile profile) {
		var profileLimit = profile == null
			? "It does not establish a state benchmark profile where the current evidence layer is still sparse."
			: "It does not turn " + profile.primaryReferenceLabel() + " into a direct legal compliance label for a private well.";
		return List.of(
			"This is not a legal compliance determination for a private well.",
			"It does not replace state lab guidance, sample-method review, or the exact reporting notes from the lab.",
			profileLimit,
			"It does not prove a health outcome or define a universal retesting cadence beyond current " + guidance.stateCode() + " guidance."
		);
	}

	private InitialCost buildInitialCost(List<FilterCatalogItem> options) {
		var costs = options.stream()
			.map(FilterCatalogItem::upfrontCostUsd)
			.filter(cost -> cost != null)
			.toList();

		if (costs.isEmpty()) {
			return new InitialCost(
				BigDecimal.ZERO,
				BigDecimal.ZERO,
				"low",
				List.of("No current treatment cost range is opened until a certified point-of-use path is justified.")
			);
		}

		return new InitialCost(
			costs.stream().min(Comparator.naturalOrder()).orElse(BigDecimal.ZERO),
			costs.stream().max(Comparator.naturalOrder()).orElse(BigDecimal.ZERO),
			mergedCostConfidence(options),
			List.of("Upfront cost uses normalized official vendor pricing for the current option set.")
		);
	}

	private AnnualCostMaintenance buildAnnualCost(List<FilterCatalogItem> options) {
		var costs = options.stream()
			.map(this::annualizedMaintenanceCost)
			.filter(cost -> cost != null)
			.toList();

		var cadenceNotes = options.stream()
			.flatMap(option -> cadenceNotes(option).stream())
			.toList();

		if (costs.isEmpty()) {
			return new AnnualCostMaintenance(
				BigDecimal.ZERO,
				BigDecimal.ZERO,
				"unknown",
				cadenceNotes,
				List.of("Annual treatment cost stays closed until a certified point-of-use path is justified.")
			);
		}

		return new AnnualCostMaintenance(
			costs.stream().min(Comparator.naturalOrder()).orElse(BigDecimal.ZERO),
			costs.stream().max(Comparator.naturalOrder()).orElse(BigDecimal.ZERO),
			maintenanceBurden(options),
			cadenceNotes,
			List.of("Annual maintenance annualizes normalized cartridge pricing by cadence and adds any normalized recurring membrane or service inputs.")
		);
	}

	private List<CertificationChecklistItem> certificationChecklist() {
		return List.of(
			new CertificationChecklistItem(
				"Use a claim-level PFAS reduction record",
				true,
				"Do not infer PFAS coverage from a broad product category without direct claim language.",
				"epa-certified-pfas-filter-guidance"
			),
			new CertificationChecklistItem(
				"Match the listing or performance sheet to the exact model",
				true,
				"Well-treatment shopping should stay tied to the exact certified model and replacement media.",
				"aq-claryum-direct-connect-install-pdf"
			),
			new CertificationChecklistItem(
				"Review cadence and annual replacement cost before buying",
				true,
				"Private-well owners should compare maintenance burden before choosing an ingestion-focused treatment path.",
				"aq-claryum-direct-connect-replacement"
			)
		);
	}

	private List<BestFitOption> bestFitOptions(List<FilterCatalogItem> options) {
		return options.stream()
			.sorted(Comparator
				.comparing(this::annualizedMaintenanceCost, Comparator.nullsLast(Comparator.naturalOrder()))
				.thenComparing(FilterCatalogItem::upfrontCostUsd, Comparator.nullsLast(Comparator.naturalOrder()))
				.thenComparing(FilterCatalogItem::brand)
				.thenComparing(FilterCatalogItem::model))
			.limit(3)
			.map(option -> new BestFitOption(
				option.productId().toUpperCase().replace('-', '_'),
				option.brand() + " " + option.model(),
				fitReason(option),
				notForEveryone(option),
				costProfile(option),
				maintenanceBurden(List.of(option))
			))
			.toList();
	}

	private String fitReason(FilterCatalogItem option) {
		return switch (option.filterType()) {
			case "carbon_block" -> "Useful when a private-well owner needs a narrower certified point-of-use move after the state route already justifies treatment.";
			case "carbon_block_uv" -> "Useful for a household that still wants an under-sink certified point-of-use system with stronger hardware expectations and accepts the upkeep.";
			default -> "Certified point-of-use option with PFAS claim support for a private-well path that already cleared the evidence step.";
		};
	}

	private String notForEveryone(FilterCatalogItem option) {
		if (option.upfrontCostUsd() != null && option.upfrontCostUsd().compareTo(new BigDecimal("800")) >= 0) {
			return "Not for everyone if the upfront system cost is too high for the household.";
		}
		return "Not for everyone if cartridge cadence or under-sink installation does not fit the household.";
	}

	private List<String> whenToEscalate(
		StateGuidance guidance,
		ActionBenchmarkRelation benchmarkRelation,
		boolean wholeHouseConsidered
	) {
		return List.of(
			"A future well result or state interpretation moves the case above the current reference context.",
			"The household still wants extra ingestion-focused margin after the state route and lab context are understood.",
			wholeHouseConsidered
				? "Whole-house intent should be reviewed separately against purpose, cost, and maintenance in " + guidance.stateCode() + "."
				: "Whole-house should only be reviewed if the household goal extends beyond drinking and cooking water."
		);
	}

	private ReferenceContext buildReferenceContext(StateGuidance guidance, StateBenchmarkProfile profile) {
		if (profile == null) {
			return null;
		}

		return new ReferenceContext(
			guidance.stateCode(),
			profile.profileKind(),
			profile.primaryReferenceLabel(),
			profile.comparabilityMode(),
			profile.summary(),
			profile.privateWellUseNote(),
			profile.benchmarks().stream()
				.map(line -> new ReferenceBenchmarkLine(
					line.contaminantCode(),
					line.label(),
					line.benchmarkDisplay(),
					line.unit(),
					line.benchmarkType(),
					line.applicability(),
					line.note()
				))
				.toList(),
			profile.lastVerifiedDate()
		);
	}

	private BenchmarkEvaluation buildBenchmarkEvaluation(PrivateWellBenchmarkEvaluation evaluation) {
		if (evaluation == null) {
			return null;
		}

		return new BenchmarkEvaluation(
			evaluation.analyteCode(),
			evaluation.inputValue(),
			evaluation.inputUnit(),
			evaluation.normalizedValuePpt(),
			evaluation.matchedReferenceLabel(),
			evaluation.matchedReferenceDisplay(),
			evaluation.comparisonMode(),
			evaluation.benchmarkRelation().name().toLowerCase(),
			evaluation.note()
		);
	}

	private BenchmarkBatchEvaluation buildBenchmarkBatchEvaluation(PrivateWellBenchmarkBatchEvaluation batchEvaluation) {
		if (batchEvaluation == null) {
			return null;
		}

		return new BenchmarkBatchEvaluation(
			batchEvaluation.aggregateRelation().name().toLowerCase(),
			batchEvaluation.aggregateSummary(),
			batchEvaluation.comparableLineCount(),
			batchEvaluation.notComparableLineCount(),
			batchEvaluation.lineEvaluations().stream()
				.map(evaluation -> new BenchmarkEvaluation(
					evaluation.analyteCode(),
					evaluation.inputValue(),
					evaluation.inputUnit(),
					evaluation.normalizedValuePpt(),
					evaluation.matchedReferenceLabel(),
					evaluation.matchedReferenceDisplay(),
					evaluation.comparisonMode(),
					evaluation.benchmarkRelation().name().toLowerCase(),
					evaluation.note()
				))
				.toList()
		);
	}

	private List<ResultSource> resolveSources(StateGuidance guidance, StateBenchmarkProfile profile, List<FilterCatalogItem> options) {
		var sourceIds = new LinkedHashSet<String>(guidance.sourceIds());
		if (profile != null) {
			sourceIds.addAll(profile.sourceIds());
		}
		sourceIds.add("epa-pfas-private-wells");
		sourceIds.add("epa-certified-pfas-filter-guidance");
		options.forEach(option -> sourceIds.addAll(option.sourceIds()));

		return sourceIds.stream()
			.map(sourceRegistryService::getDocument)
			.flatMap(Optional::stream)
			.distinct()
			.map(this::toResultSource)
			.sorted(Comparator.comparingInt(ResultSource::trustTier).thenComparing(ResultSource::sourceId))
			.toList();
	}

	private ResultSource toResultSource(SourceDocument document) {
		return new ResultSource(
			document.sourceId(),
			document.organization(),
			document.title(),
			document.url(),
			document.trustTier()
		);
	}

	private String decisionRuleId(ActionBenchmarkRelation benchmarkRelation) {
		return switch (benchmarkRelation) {
			case ABOVE_REFERENCE, MIXED -> "PRIVATE_WELL_ABOVE_REFERENCE_CERTIFIED_POU";
			case BELOW_REFERENCE -> "PRIVATE_WELL_BELOW_REFERENCE_MONITOR";
			case UNKNOWN, NOT_COMPARABLE -> "PRIVATE_WELL_STATE_CONTEXT_REQUIRED";
		};
	}

	private String mergedCostConfidence(List<FilterCatalogItem> options) {
		if (options.stream().allMatch(option -> "high".equalsIgnoreCase(option.costConfidence()))) {
			return "high";
		}
		if (options.stream().anyMatch(option -> option.costConfidence() != null && !option.costConfidence().isBlank())) {
			return "medium";
		}
		return "low";
	}

	private String maintenanceBurden(List<FilterCatalogItem> options) {
		var cadence = options.stream()
			.flatMap(option -> cadenceValues(option).stream())
			.filter(value -> value != null)
			.min(Integer::compareTo)
			.orElse(null);

		if (cadence == null) {
			return "unknown";
		}
		if (cadence <= 6) {
			return "high";
		}
		if (cadence <= 12) {
			return "medium";
		}
		return "low";
	}

	private String costProfile(FilterCatalogItem option) {
		if (option.upfrontCostUsd() == null) {
			return "unknown";
		}
		if (option.upfrontCostUsd().compareTo(new BigDecimal("800")) >= 0) {
			return "high";
		}
		if (option.upfrontCostUsd().compareTo(new BigDecimal("300")) >= 0) {
			return "medium";
		}
		return "low";
	}

	private BigDecimal annualizedMaintenanceCost(FilterCatalogItem option) {
		BigDecimal total = null;

		if (option.replacementCostUsd() != null && option.replacementCadenceMonths() != null && option.replacementCadenceMonths() > 0) {
			total = annualize(option.replacementCostUsd(), option.replacementCadenceMonths());
		}
		if (option.membraneCostUsd() != null) {
			total = sumOrValue(total, option.membraneCostUsd());
		}
		if (option.serviceCostUsd() != null) {
			total = sumOrValue(total, option.serviceCostUsd());
		}
		for (var component : option.recurringCostComponents()) {
			if (component.componentCostUsd() != null && component.cadenceMonths() != null && component.cadenceMonths() > 0) {
				total = sumOrValue(total, annualize(component.componentCostUsd(), component.cadenceMonths()));
			}
		}

		return total;
	}

	private List<String> cadenceNotes(FilterCatalogItem option) {
		var notes = new java.util.ArrayList<String>();
		if (option.replacementCadenceMonths() != null) {
			notes.add(option.brand() + " " + option.model() + " primary replacement cadence: every " + option.replacementCadenceMonths() + " months.");
		}
		option.recurringCostComponents().stream()
			.filter(component -> component.cadenceMonths() != null)
			.map(component -> option.brand() + " " + option.model() + " " + component.componentLabel() + ": every " + component.cadenceMonths() + " months.")
			.forEach(notes::add);
		return List.copyOf(notes);
	}

	private List<Integer> cadenceValues(FilterCatalogItem option) {
		var values = new java.util.ArrayList<Integer>();
		if (option.replacementCadenceMonths() != null) {
			values.add(option.replacementCadenceMonths());
		}
		option.recurringCostComponents().stream()
			.map(com.example.pfas.filter.RecurringCostComponent::cadenceMonths)
			.filter(value -> value != null)
			.forEach(values::add);
		return List.copyOf(values);
	}

	private BigDecimal annualize(BigDecimal cost, int cadenceMonths) {
		return cost.multiply(BigDecimal.valueOf(12))
			.divide(BigDecimal.valueOf(cadenceMonths), 2, RoundingMode.HALF_UP);
	}

	private BigDecimal sumOrValue(BigDecimal current, BigDecimal value) {
		return current == null ? value : current.add(value);
	}
}
