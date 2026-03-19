package com.example.pfas.result;

import java.math.BigDecimal;
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
import com.example.pfas.source.SourceDocument;
import com.example.pfas.source.SourceRegistryService;
import com.example.pfas.state.StateGuidance;
import com.example.pfas.state.StateGuidanceService;

@Service
public class PrivateWellResultService {

	private final StateGuidanceService stateGuidanceService;
	private final FilterCatalogService filterCatalogService;
	private final SourceRegistryService sourceRegistryService;

	public PrivateWellResultService(
		StateGuidanceService stateGuidanceService,
		FilterCatalogService filterCatalogService,
		SourceRegistryService sourceRegistryService
	) {
		this.stateGuidanceService = stateGuidanceService;
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
			.map(guidance -> toResult(guidance, benchmarkRelation, currentFilterStatus, wholeHouseConsidered));
	}

	private WaterDecisionResult toResult(
		StateGuidance guidance,
		ActionBenchmarkRelation benchmarkRelation,
		ActionCurrentFilterStatus currentFilterStatus,
		boolean wholeHouseConsidered
	) {
		var options = benchmarkRelation == ActionBenchmarkRelation.ABOVE_REFERENCE
			|| benchmarkRelation == ActionBenchmarkRelation.MIXED
			|| currentFilterStatus == ActionCurrentFilterStatus.UNCERTIFIED
			? filterCatalogService.getForPfasCoverage(List.of("PFOA", "PFOS"))
			: List.<FilterCatalogItem>of();

		return new WaterDecisionResult(
			"private-well:" + guidance.stateCode() + ":" + benchmarkRelation.name(),
			"v1",
			OffsetDateTime.now().toString(),
			nextAction(guidance, benchmarkRelation, currentFilterStatus),
			whyThis(guidance, benchmarkRelation, currentFilterStatus),
			whatThisDoesNotTellYou(guidance),
			buildInitialCost(options),
			buildAnnualCost(options),
			certificationChecklist(),
			bestFitOptions(options),
			whenToEscalate(guidance, benchmarkRelation, wholeHouseConsidered),
			resolveSources(guidance, options),
			new ResultMeta(
				"private_well",
				benchmarkRelation.name().toLowerCase(),
				decisionRuleId(benchmarkRelation, currentFilterStatus),
				benchmarkRelation == ActionBenchmarkRelation.UNKNOWN || benchmarkRelation == ActionBenchmarkRelation.NOT_COMPARABLE
			)
		);
	}

	private NextAction nextAction(
		StateGuidance guidance,
		ActionBenchmarkRelation benchmarkRelation,
		ActionCurrentFilterStatus currentFilterStatus
	) {
		if (currentFilterStatus == ActionCurrentFilterStatus.UNCERTIFIED) {
			return new NextAction(
				"VERIFY_OR_REPLACE_WITH_CERTIFIED_OPTION",
				"Verify or replace the current filter with a certified point-of-use option",
				"The current household filter is not confirmed as certified for PFAS reduction, so certification and replacement cadence should be checked before relying on it.",
				"medium",
				"Private-well interpretation stays reference-based and state-guided."
			);
		}

		return switch (benchmarkRelation) {
			case ABOVE_REFERENCE, MIXED -> new NextAction(
				"EVALUATE_CERTIFIED_POU_FILTER_AND_STATE_NEXT_STEPS",
				"Open state next steps and evaluate certified point-of-use",
				"The result is above the selected reference, so the next step is state-guided interpretation plus a certified ingestion-focused treatment option rather than a generic shopping flow.",
				"high",
				"Private-well above-reference results are action signals, not legal compliance findings."
			);
			case BELOW_REFERENCE -> new NextAction(
				"CONTINUE_PERIODIC_TESTING",
				"Keep the result in a monitoring posture and follow state guidance",
				"The result is below the selected reference, so the next step is to keep the interpretation state-based and use official guidance for any follow-up testing or optional treatment.",
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
		ActionBenchmarkRelation benchmarkRelation,
		ActionCurrentFilterStatus currentFilterStatus
	) {
		var filterLine = currentFilterStatus == ActionCurrentFilterStatus.UNCERTIFIED
			? "The current filter status is uncertified, so certification verification becomes a first-order action."
			: "Any treatment path should stay certification-first and state-guided.";

		return List.of(
			"Private well results are interpreted against " + guidance.stateCode() + " state guidance, not as public-water compliance findings.",
			"Benchmark relation is currently " + benchmarkRelation.name().toLowerCase().replace('_', ' ') + ".",
			filterLine
		);
	}

	private List<String> whatThisDoesNotTellYou(StateGuidance guidance) {
		return List.of(
			"This is not a legal compliance determination for a private well.",
			"It does not replace state lab guidance, local health input, or sample-method review.",
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
			.map(FilterCatalogItem::replacementCostUsd)
			.filter(cost -> cost != null)
			.toList();

		var cadenceNotes = options.stream()
			.filter(option -> option.replacementCadenceMonths() != null)
			.map(option -> option.brand() + " " + option.model() + " replacement cadence: every " + option.replacementCadenceMonths() + " months.")
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
			List.of("Annual maintenance reflects normalized cartridge pricing, not total household ownership cost.")
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
			case "carbon_block" -> "Certified under-sink carbon option with direct PFOA and PFOS claim support for an ingestion-focused private-well path.";
			case "carbon_block_uv" -> "Certified under-sink option for households that want a premium under-sink point-of-use system with PFAS claim coverage.";
			default -> "Certified point-of-use option with PFAS claim support for a private-well treatment path.";
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
			"You need extra ingestion-focused margin and can maintain a certified point-of-use unit.",
			wholeHouseConsidered
				? "Whole-house intent should be reviewed separately against purpose, cost, and maintenance in " + guidance.stateCode() + "."
				: "Whole-house should only be reviewed if the household goal extends beyond drinking and cooking water."
		);
	}

	private List<ResultSource> resolveSources(StateGuidance guidance, List<FilterCatalogItem> options) {
		var sourceIds = new LinkedHashSet<String>(guidance.sourceIds());
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

	private String decisionRuleId(ActionBenchmarkRelation benchmarkRelation, ActionCurrentFilterStatus currentFilterStatus) {
		if (currentFilterStatus == ActionCurrentFilterStatus.UNCERTIFIED) {
			return "PRIVATE_WELL_UNCERTIFIED_FILTER_CHECK";
		}
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
			.map(FilterCatalogItem::replacementCadenceMonths)
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
}
