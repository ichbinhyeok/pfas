package com.example.pfas.decision;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.example.pfas.benchmark.BenchmarkService;
import com.example.pfas.filter.FilterCatalogService;
import com.example.pfas.observation.UtilityObservation;
import com.example.pfas.observation.UtilityObservationService;
import com.example.pfas.water.PublicWaterSystem;
import com.example.pfas.water.PublicWaterSystemService;

@Service
public class PublicWaterDecisionService {

	private static final Comparator<ContaminantAssessment> ASSESSMENT_ORDER =
		Comparator.comparing(ContaminantAssessment::comparisonStatus)
			.thenComparing(ContaminantAssessment::sampleContext)
			.thenComparing(ContaminantAssessment::contaminantCode);

	private final BenchmarkService benchmarkService;
	private final PublicWaterSystemService publicWaterSystemService;
	private final UtilityObservationService utilityObservationService;
	private final FilterCatalogService filterCatalogService;

	public PublicWaterDecisionService(
		BenchmarkService benchmarkService,
		PublicWaterSystemService publicWaterSystemService,
		UtilityObservationService utilityObservationService,
		FilterCatalogService filterCatalogService
	) {
		this.benchmarkService = benchmarkService;
		this.publicWaterSystemService = publicWaterSystemService;
		this.utilityObservationService = utilityObservationService;
		this.filterCatalogService = filterCatalogService;
	}

	public Optional<PublicWaterDecisionContext> getByPwsid(String pwsid) {
		return publicWaterSystemService.getByPwsid(pwsid)
			.map(system -> resolve(system, utilityObservationService.getByPwsid(pwsid)));
	}

	private PublicWaterDecisionContext resolve(PublicWaterSystem system, List<UtilityObservation> observations) {
		if (observations.isEmpty()) {
			return new PublicWaterDecisionContext(
				system.pwsid(),
				system.pwsName(),
				system.stateCode(),
				PublicWaterDecisionStatus.NO_DIRECT_OBSERVATIONS,
				PublicWaterNextActionCode.FIND_DIRECT_UTILITY_OR_TEST_DATA,
				PublicWaterDecisionRuleId.PUBLIC_WATER_NO_DIRECT_OBSERVATIONS,
				"Find direct utility PFAS data before escalating",
				"No normalized PFAS observations are available for this system yet, so the correct next step is to locate a current utility report or certified test result.",
				false,
				List.of(
					"This is not a household tap test result.",
					"ZIP or city-level inference is not used here.",
					"Do not treat the absence of observations as a safe or unsafe determination."
				),
				List.of(),
				List.of()
			);
		}

		var assessments = observations.stream()
			.map(this::toAssessment)
			.sorted(ASSESSMENT_ORDER)
			.toList();

		var hasAbove = assessments.stream().anyMatch(assessment -> assessment.comparisonStatus() == BenchmarkComparisonStatus.ABOVE_SELECTED_BENCHMARK);
		var hasReviewBand = assessments.stream().anyMatch(assessment -> assessment.comparisonStatus() == BenchmarkComparisonStatus.PRESENT_BELOW_SELECTED_BENCHMARK);
		var hasInsufficientBenchmark = assessments.stream().anyMatch(assessment -> assessment.comparisonStatus() == BenchmarkComparisonStatus.INSUFFICIENT_BENCHMARK);

		var certifiedOptions = filterCatalogService.getForPfasCoverage(List.of("PFOA", "PFOS"));

		if (hasAbove) {
			return new PublicWaterDecisionContext(
				system.pwsid(),
				system.pwsName(),
				system.stateCode(),
				PublicWaterDecisionStatus.ABOVE_SELECTED_BENCHMARK,
				PublicWaterNextActionCode.REVIEW_UTILITY_NOTICE_AND_CONSIDER_CERTIFIED_POU,
				PublicWaterDecisionRuleId.PUBLIC_WATER_DIRECT_DATA_ABOVE_REFERENCE,
				"Review utility response and consider certified point-of-use filtration",
				"At least one normalized utility observation is above the selected benchmark, so the user should review the utility's current PFAS response and consider a certified point-of-use option while utility remediation proceeds.",
				hasInsufficientBenchmark,
				List.of(
					"Benchmark selection here is the registry-linked benchmark attached to each normalized observation, not a universal federal safety finding.",
					"This is a utility-level signal and does not replace a household tap test.",
					"Whole-house escalation is not the default recommendation from this endpoint."
				),
				assessments,
				certifiedOptions
			);
		}

		if (hasReviewBand) {
			return new PublicWaterDecisionContext(
				system.pwsid(),
				system.pwsName(),
				system.stateCode(),
				PublicWaterDecisionStatus.PRESENT_BELOW_SELECTED_BENCHMARK,
				PublicWaterNextActionCode.REVIEW_UTILITY_UPDATES_AND_OPTIONALLY_ADD_CERTIFIED_POU,
				PublicWaterDecisionRuleId.PUBLIC_WATER_DIRECT_DATA_BELOW_REFERENCE_OPTIONAL_POU,
				"Review utility updates and add certified point-of-use only if you want extra margin",
				"PFAS is present in the normalized utility observations but remains below the selected benchmark, so the user should monitor utility updates first and treat certified point-of-use filtration as an optional margin choice rather than an automatic escalation.",
				hasInsufficientBenchmark,
				List.of(
					"This is not a safe or unsafe label.",
					"Observation values may reflect running annual averages or utility-specific reporting context.",
					"Certification claims do not automatically equal compliance with every current regulatory benchmark."
				),
				assessments,
				certifiedOptions
			);
		}

		if (hasInsufficientBenchmark) {
			return new PublicWaterDecisionContext(
				system.pwsid(),
				system.pwsName(),
				system.stateCode(),
				PublicWaterDecisionStatus.INSUFFICIENT_BENCHMARK_CONTEXT,
				PublicWaterNextActionCode.REVIEW_UTILITY_DATA_WITH_BENCHMARK_CONTEXT,
				PublicWaterDecisionRuleId.PUBLIC_WATER_DIRECT_DATA_NEEDS_BENCHMARK_REVIEW,
				"Review utility data with benchmark context before treating it as below reference",
				"The utility has direct PFAS observations, but one or more benchmark mappings are incomplete, so the route should stay in a manual-review posture instead of defaulting to a below-benchmark interpretation.",
				true,
				List.of(
					"Direct observations exist, but benchmark context is incomplete.",
					"This is not a safe or unsafe label.",
					"Do not treat missing benchmark mappings as evidence that the system is below reference."
				),
				assessments,
				List.of()
			);
		}

		return new PublicWaterDecisionContext(
			system.pwsid(),
			system.pwsName(),
			system.stateCode(),
			PublicWaterDecisionStatus.REPORTED_BELOW_SELECTED_BENCHMARK,
			PublicWaterNextActionCode.KEEP_MONITORING_UTILITY_UPDATES,
			PublicWaterDecisionRuleId.PUBLIC_WATER_DIRECT_DATA_BELOW_REFERENCE_MONITOR,
			"Keep monitoring utility updates; no immediate escalation from current normalized data",
			"The current normalized utility observations are below the selected benchmark, so there is no immediate escalation from this data alone.",
			hasInsufficientBenchmark,
			List.of(
				"This is not a household tap test.",
				"Future utility updates can change the picture.",
				"Do not convert this into a blanket safe or unsafe claim."
			),
			assessments,
			List.of()
		);
	}

	private ContaminantAssessment toAssessment(UtilityObservation observation) {
		var benchmark = benchmarkService.getByBenchmarkId(observation.benchmarkId()).orElse(null);
		var benchmarkValue = benchmark != null ? benchmark.benchmarkValue() : null;
		var value = observation.value();
		var ratio = benchmarkValue != null && value != null && benchmarkValue.signum() > 0
			? value.divide(benchmarkValue, 4, RoundingMode.HALF_UP)
			: null;

		return new ContaminantAssessment(
			observation.observationId(),
			observation.contaminantCode(),
			observation.contaminantLabel(),
			observation.sampleContext(),
			value,
			observation.unit(),
			observation.benchmarkId(),
			benchmark != null ? benchmark.benchmarkLabel() : "",
			benchmark != null ? benchmark.benchmarkKind() : "",
			benchmarkValue,
			benchmark != null ? benchmark.unit() : "",
			benchmark != null ? benchmark.primarySourceId() : "",
			benchmark != null ? benchmark.referenceStatus() : "",
			ratio,
			comparisonStatus(value, benchmarkValue)
		);
	}

	private BenchmarkComparisonStatus comparisonStatus(BigDecimal value, BigDecimal benchmarkValue) {
		if (value == null || benchmarkValue == null || benchmarkValue.signum() <= 0) {
			return BenchmarkComparisonStatus.INSUFFICIENT_BENCHMARK;
		}
		if (value.compareTo(benchmarkValue) > 0) {
			return BenchmarkComparisonStatus.ABOVE_SELECTED_BENCHMARK;
		}
		if (value.signum() == 0) {
			return BenchmarkComparisonStatus.NON_DETECT_OR_ZERO_REPORTED;
		}
		return BenchmarkComparisonStatus.PRESENT_BELOW_SELECTED_BENCHMARK;
	}
}
