package com.example.pfas.result;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.OffsetDateTime;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.example.pfas.decision.BenchmarkComparisonStatus;
import com.example.pfas.decision.PublicWaterDecisionContext;
import com.example.pfas.decision.PublicWaterDecisionService;
import com.example.pfas.filter.FilterCatalogItem;
import com.example.pfas.source.SourceDocument;
import com.example.pfas.source.SourceRegistryService;
import com.example.pfas.water.PublicWaterSystemService;

@Service
public class PublicWaterResultService {

	private final PublicWaterDecisionService publicWaterDecisionService;
	private final PublicWaterSystemService publicWaterSystemService;
	private final SourceRegistryService sourceRegistryService;

	public PublicWaterResultService(
		PublicWaterDecisionService publicWaterDecisionService,
		PublicWaterSystemService publicWaterSystemService,
		SourceRegistryService sourceRegistryService
	) {
		this.publicWaterDecisionService = publicWaterDecisionService;
		this.publicWaterSystemService = publicWaterSystemService;
		this.sourceRegistryService = sourceRegistryService;
	}

	public Optional<WaterDecisionResult> getByPwsid(String pwsid) {
		var system = publicWaterSystemService.getByPwsid(pwsid);
		var decision = publicWaterDecisionService.getByPwsid(pwsid);

		if (system.isEmpty() || decision.isEmpty()) {
			return Optional.empty();
		}

		return Optional.of(toResult(system.get().sourceIds(), decision.get()));
	}

	private WaterDecisionResult toResult(List<String> systemSourceIds, PublicWaterDecisionContext decision) {
		var optionCosts = decision.certifiedPouOptions().stream()
			.filter(option -> option.upfrontCostUsd() != null || option.replacementCostUsd() != null)
			.toList();

		var initialCost = buildInitialCost(optionCosts, decision);
		var annualCost = buildAnnualCost(optionCosts, decision);

		return new WaterDecisionResult(
			"public-water:" + decision.pwsid(),
			"v1",
			OffsetDateTime.now().toString(),
			new NextAction(
				decision.nextActionCode().name(),
				decision.nextActionTitle(),
				decision.rationale(),
				confidence(decision),
				"Public water utility interpretation; not a household tap test result."
			),
			whyThis(decision),
			decision.caveats(),
			initialCost,
			annualCost,
			certificationChecklist(),
			bestFitOptions(decision.certifiedPouOptions()),
			whenToEscalate(decision),
			null,
			null,
			null,
			resolveSources(systemSourceIds, decision),
			new ResultMeta(
				"public_water",
				benchmarkRelation(decision),
				decision.decisionRuleId().name(),
				decision.manualReviewRequired()
			)
		);
	}

	private InitialCost buildInitialCost(List<FilterCatalogItem> options, PublicWaterDecisionContext decision) {
		var costs = options.stream()
			.map(FilterCatalogItem::upfrontCostUsd)
			.filter(cost -> cost != null)
			.toList();

		if (costs.isEmpty()) {
			return new InitialCost(
				BigDecimal.ZERO,
				BigDecimal.ZERO,
				decision.certifiedPouOptions().isEmpty() ? "low" : "medium",
				List.of("No normalized upfront cost is available for the current option set.")
			);
		}

		return new InitialCost(
			costs.stream().min(Comparator.naturalOrder()).orElse(BigDecimal.ZERO),
			costs.stream().max(Comparator.naturalOrder()).orElse(BigDecimal.ZERO),
			mergedCostConfidence(options),
			List.of("Upfront cost uses normalized vendor-observed pricing tied to the listed option set.")
		);
	}

	private AnnualCostMaintenance buildAnnualCost(List<FilterCatalogItem> options, PublicWaterDecisionContext decision) {
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
				List.of("No normalized annual replacement cost is available for the current option set.")
			);
		}

		return new AnnualCostMaintenance(
			costs.stream().min(Comparator.naturalOrder()).orElse(BigDecimal.ZERO),
			costs.stream().max(Comparator.naturalOrder()).orElse(BigDecimal.ZERO),
			maintenanceBurden(options),
			cadenceNotes,
			List.of("Annual maintenance annualizes normalized replacement media pricing by cadence and adds any normalized recurring membrane or service inputs.")
		);
	}

	private List<CertificationChecklistItem> certificationChecklist() {
		return List.of(
			new CertificationChecklistItem(
				"Claim-level listing for the specific PFAS you care about",
				true,
				"Verify the listing record names the PFAS reduction claim directly instead of inferring from a product category.",
				"nsf-dwtu-listings"
			),
			new CertificationChecklistItem(
				"Match the certification standard to the actual claim",
				true,
				"Use NSF ANSI 53 or an equivalent claim-level listing only when the record explicitly carries the reduction claim.",
				"epa-certified-pfas-filter-guidance"
			),
			new CertificationChecklistItem(
				"Check replacement cadence and cartridge capacity before buying",
				true,
				"Cost and maintenance burden change materially if cadence is annual vs more frequent.",
				"amway-espring-100186-cartridge"
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
				"Certified point-of-use option with direct PFOA/PFOS claim coverage in the normalized listing set.",
				"Not for everyone if the upfront cost or annual cartridge cost is too high for the household.",
				costProfile(option),
				maintenanceBurden(List.of(option))
			))
			.toList();
	}

	private List<String> whenToEscalate(PublicWaterDecisionContext decision) {
		return List.of(
			"A current utility notice or updated direct result moves one or more contaminants above the selected benchmark.",
			"You need extra ingestion-focused margin and are willing to maintain a certified point-of-use unit.",
			"Your household goal expands beyond drinking and cooking water, which requires a separate whole-house justification review."
		);
	}

	private List<ResultSource> resolveSources(List<String> systemSourceIds, PublicWaterDecisionContext decision) {
		var sourceIds = new LinkedHashSet<String>();
		sourceIds.addAll(systemSourceIds);
		decision.assessments().forEach(assessment -> {
			if (assessment.benchmarkSourceId() != null && !assessment.benchmarkSourceId().isBlank()) {
				sourceIds.add(assessment.benchmarkSourceId());
			}
		});
		decision.certifiedPouOptions().forEach(option -> sourceIds.addAll(option.sourceIds()));

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

	private List<String> whyThis(PublicWaterDecisionContext decision) {
		var aboveCount = decision.assessments().stream()
			.filter(assessment -> assessment.comparisonStatus() == BenchmarkComparisonStatus.ABOVE_SELECTED_BENCHMARK)
			.count();
		var presentCount = decision.assessments().stream()
			.filter(assessment -> assessment.comparisonStatus() == BenchmarkComparisonStatus.PRESENT_BELOW_SELECTED_BENCHMARK)
			.count();

		return List.of(
			"Public water utility observations are treated as direct official data for this system.",
			"Current normalized assessment counts: " + aboveCount + " above selected benchmark, " + presentCount + " present below selected benchmark.",
			"Point-of-use is treated as the first escalation class when a user wants extra ingestion-focused margin."
		);
	}

	private String benchmarkRelation(PublicWaterDecisionContext decision) {
		if (decision.assessments().stream().anyMatch(assessment -> assessment.comparisonStatus() == BenchmarkComparisonStatus.ABOVE_SELECTED_BENCHMARK)) {
			return "above_reference";
		}
		if (decision.assessments().stream().anyMatch(assessment -> assessment.comparisonStatus() == BenchmarkComparisonStatus.PRESENT_BELOW_SELECTED_BENCHMARK)) {
			return "below_reference";
		}
		return "unknown";
	}

	private String confidence(PublicWaterDecisionContext decision) {
		return decision.manualReviewRequired() ? "medium" : "high";
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
