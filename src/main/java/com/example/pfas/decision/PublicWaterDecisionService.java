package com.example.pfas.decision;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

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

	private final PublicWaterSystemService publicWaterSystemService;
	private final UtilityObservationService utilityObservationService;
	private final FilterCatalogService filterCatalogService;

	public PublicWaterDecisionService(
		PublicWaterSystemService publicWaterSystemService,
		UtilityObservationService utilityObservationService,
		FilterCatalogService filterCatalogService
	) {
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
				"no_direct_observations",
				"find_direct_utility_or_test_data",
				"Find direct utility PFAS data before escalating",
				"No normalized PFAS observations are available for this system yet, so the correct next step is to locate a current utility report or certified test result.",
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

		var hasAbove = assessments.stream().anyMatch(assessment -> assessment.comparisonStatus().equals("above_selected_benchmark"));
		var hasReviewBand = assessments.stream().anyMatch(assessment -> assessment.comparisonStatus().equals("present_below_selected_benchmark"));

		var certifiedOptions = filterCatalogService.getForPfasCoverage(List.of("PFOA", "PFOS"));

		if (hasAbove) {
			return new PublicWaterDecisionContext(
				system.pwsid(),
				system.pwsName(),
				system.stateCode(),
				"above_selected_benchmark",
				"review_utility_notice_and_consider_certified_pou",
				"Review utility response and consider certified point-of-use filtration",
				"At least one normalized utility observation is above the selected benchmark, so the user should review the utility's current PFAS response and consider a certified point-of-use option while utility remediation proceeds.",
				List.of(
					"Benchmark selection here is the benchmark attached to each normalized observation, not a universal federal safety finding.",
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
				"present_below_selected_benchmark",
				"review_utility_updates_and_optionally_add_certified_pou",
				"Review utility updates and add certified point-of-use only if you want extra margin",
				"PFAS is present in the normalized utility observations but remains below the selected benchmark, so the user should monitor utility updates first and treat certified point-of-use filtration as an optional margin choice rather than an automatic escalation.",
				List.of(
					"This is not a safe or unsafe label.",
					"Observation values may reflect running annual averages or utility-specific reporting context.",
					"Certification claims do not automatically equal compliance with every current regulatory benchmark."
				),
				assessments,
				certifiedOptions
			);
		}

		return new PublicWaterDecisionContext(
			system.pwsid(),
			system.pwsName(),
			system.stateCode(),
			"reported_below_selected_benchmark",
			"keep_monitoring_utility_updates",
			"Keep monitoring utility updates; no immediate escalation from current normalized data",
			"The current normalized utility observations are below the selected benchmark, so there is no immediate escalation from this data alone.",
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
		var benchmarkValue = observation.benchmarkValue();
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
			observation.benchmarkType(),
			benchmarkValue,
			observation.benchmarkUnit(),
			observation.benchmarkSourceId(),
			ratio,
			comparisonStatus(value, benchmarkValue)
		);
	}

	private String comparisonStatus(BigDecimal value, BigDecimal benchmarkValue) {
		if (value == null || benchmarkValue == null || benchmarkValue.signum() <= 0) {
			return "insufficient_benchmark";
		}
		if (value.compareTo(benchmarkValue) > 0) {
			return "above_selected_benchmark";
		}
		if (value.signum() == 0) {
			return "non_detect_or_zero_reported";
		}
		return "present_below_selected_benchmark";
	}
}
