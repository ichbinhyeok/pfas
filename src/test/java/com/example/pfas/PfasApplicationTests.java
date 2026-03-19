package com.example.pfas;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.test.web.servlet.MockMvc;

import com.example.pfas.benchmark.BenchmarkService;
import com.example.pfas.certification.CertificationClaimService;
import com.example.pfas.checker.ActionBenchmarkRelation;
import com.example.pfas.checker.ActionCheckerRouteCode;
import com.example.pfas.checker.ActionCheckerService;
import com.example.pfas.checker.ActionCurrentFilterStatus;
import com.example.pfas.decision.PublicWaterDecisionRuleId;
import com.example.pfas.decision.PublicWaterDecisionService;
import com.example.pfas.decision.PublicWaterDecisionStatus;
import com.example.pfas.decision.PublicWaterNextActionCode;
import com.example.pfas.filter.FilterCatalogService;
import com.example.pfas.observation.UtilityObservationService;
import com.example.pfas.privatewell.PrivateWellBenchmarkEvaluatorService;
import com.example.pfas.readiness.ExpansionReadinessService;
import com.example.pfas.readiness.ExpansionReadinessStatus;
import com.example.pfas.result.PrivateWellResultService;
import com.example.pfas.result.PublicWaterResultService;
import com.example.pfas.source.SourceRegistryService;
import com.example.pfas.state.StateGuidanceService;
import com.example.pfas.stateprofile.StateBenchmarkProfileService;
import com.example.pfas.water.PublicWaterSystemService;

@SpringBootTest(properties = {
	"pfas.data.root=./data",
	"pfas.site.base-url=https://pfas.example.test"
})
@AutoConfigureMockMvc
class PfasApplicationTests {

	@Autowired
	private SourceRegistryService sourceRegistryService;

	@Autowired
	private StateGuidanceService stateGuidanceService;

	@Autowired
	private PublicWaterSystemService publicWaterSystemService;

	@Autowired
	private UtilityObservationService utilityObservationService;

	@Autowired
	private CertificationClaimService certificationClaimService;

	@Autowired
	private BenchmarkService benchmarkService;

	@Autowired
	private FilterCatalogService filterCatalogService;

	@Autowired
	private StateBenchmarkProfileService stateBenchmarkProfileService;

	@Autowired
	private ExpansionReadinessService expansionReadinessService;

	@Autowired
	private PrivateWellBenchmarkEvaluatorService privateWellBenchmarkEvaluatorService;

	@Autowired
	private PublicWaterDecisionService publicWaterDecisionService;

	@Autowired
	private PublicWaterResultService publicWaterResultService;

	@Autowired
	private PrivateWellResultService privateWellResultService;

	@Autowired
	private ActionCheckerService actionCheckerService;

	@Autowired
	private MockMvc mockMvc;

	@Test
	void contextLoads() {
	}

	@Test
	void loadsSeededSourceRegistry() {
		var documents = sourceRegistryService.getAllDocuments();

		assertThat(documents).hasSizeGreaterThanOrEqualTo(25);
		assertThat(documents)
			.extracting(document -> document.sourceId())
			.contains(
				"epa-pfas-npdwr-implementation",
				"epa-certified-pfas-filter-guidance",
				"atsdr-testing-for-pfas",
				"nsf-dwtu-listings",
				"lancaster-pfoa-notice-2025",
				"ma-private-wells",
				"wa-pfas-drinking-water",
				"ca-pfas-waterboards",
				"mi-pfas-mcls",
				"me-pfas-well-results-pdf",
				"mn-pfas-values",
				"ny-water-supplier-factsheet-mcls",
				"vt-pfas-drinking-water",
				"wa-pfas-group-a-support",
				"ca-pfas-timeline",
				"alaska-water-home",
				"alaska-dww-golden-heart-system-detail",
				"golden-heart-2025-water-quality-report",
				"alaska-dww-college-utilities-monitoring-summary",
				"college-utilities-2025-water-quality-report",
				"sunshine-water-home",
				"bear-lake-pfas-2023-report",
				"aq-claryum-3-stage-product",
				"aq-clean-water-machine-product"
			);
	}

	@Test
	void loadsSeededStateGuidance() {
		var states = stateGuidanceService.getAll();

		assertThat(states).hasSize(8);
		assertThat(states)
			.extracting(state -> state.stateCode())
			.containsExactly("CA", "MA", "ME", "MI", "MN", "NY", "VT", "WA");
	}

	@Test
	void loadsSeededStateBenchmarkProfiles() {
		var profiles = stateBenchmarkProfileService.getAll();
		var washington = stateBenchmarkProfileService.getByStateCode("WA").orElseThrow();

		assertThat(profiles).hasSize(8);
		assertThat(profiles)
			.extracting(profile -> profile.stateCode())
			.containsExactly("CA", "MA", "ME", "MI", "MN", "NY", "VT", "WA");
		assertThat(washington.primaryReferenceLabel()).contains("Washington");
		assertThat(washington.benchmarks())
			.extracting(line -> line.benchmarkDisplay())
			.contains("4 ppt", "10 ppt");
	}

	@Test
	void loadsSeededPublicWaterSystems() {
		var systems = publicWaterSystemService.getAll();
		var goldenHeart = publicWaterSystemService.getByPwsid("AK2310730").orElseThrow();
		var collegeUtilities = publicWaterSystemService.getByPwsid("AK2310900").orElseThrow();
		var bearLake = publicWaterSystemService.getByPwsid("FL3590069").orElseThrow();
		var greenRidge = publicWaterSystemService.getByPwsid("MD0120011").orElseThrow();
		var abington = publicWaterSystemService.getByPwsid("NC0234191").orElseThrow();
		var carolinaTrace = publicWaterSystemService.getByPwsid("NC0353101").orElseThrow();
		var phila = publicWaterSystemService.getByPwsid("PA1510001").orElseThrow();
		var lancaster = publicWaterSystemService.getByPwsid("7360058").orElseThrow();

		assertThat(systems).hasSize(8);
		assertThat(systems)
			.extracting(system -> system.pwsid())
			.containsExactly("AK2310900", "AK2310730", "FL3590069", "MD0120011", "NC0234191", "NC0353101", "7360058", "PA1510001");
		assertThat(goldenHeart.sourceIds())
			.contains(
				"alaska-water-home",
				"alaska-water-quality-reports",
				"alaska-dww-golden-heart-system-detail",
				"golden-heart-2025-water-quality-report"
			);
		assertThat(collegeUtilities.sourceIds())
			.contains(
				"alaska-water-home",
				"alaska-water-quality-reports",
				"alaska-dww-college-utilities-monitoring-summary",
				"college-utilities-2025-water-quality-report"
			);
		assertThat(bearLake.sourceIds())
			.contains(
				"sunshine-water-home",
				"sunshine-water-quality-reports",
				"bear-lake-2024-water-quality-report",
				"bear-lake-pfas-2023-report"
			);
		assertThat(greenRidge.sourceIds())
			.contains(
				"maryland-water-home",
				"maryland-water-quality-reports",
				"green-ridge-2024-water-quality-report"
			);
		assertThat(abington.sourceIds())
			.contains(
				"carolina-water-home",
				"carolina-water-quality-reports",
				"abington-2024-water-quality-report"
			);
		assertThat(carolinaTrace.sourceIds())
			.contains(
				"carolina-water-home",
				"carolina-water-quality-reports",
				"carolina-trace-2024-water-quality-report"
			);
		assertThat(phila.sourceIds())
			.contains(
				"phila-pwd-home",
				"phila-2024-water-quality-report",
				"phila-pfas-management"
			);
		assertThat(lancaster.sourceIds())
			.contains(
				"lancaster-water-home",
				"lancaster-2024-water-quality-report",
				"lancaster-pfoa-notice-2025"
			);
	}

	@Test
	void loadsSeededUtilityObservations() {
		var goldenHeartObservations = utilityObservationService.getByPwsid("AK2310730");
		var collegeUtilitiesObservations = utilityObservationService.getByPwsid("AK2310900");
		var bearLakeObservations = utilityObservationService.getByPwsid("FL3590069");
		var greenRidgeObservations = utilityObservationService.getByPwsid("MD0120011");
		var abingtonObservations = utilityObservationService.getByPwsid("NC0234191");
		var carolinaTraceObservations = utilityObservationService.getByPwsid("NC0353101");
		var philaObservations = utilityObservationService.getByPwsid("PA1510001");
		var lancasterObservations = utilityObservationService.getByPwsid("7360058");

		assertThat(goldenHeartObservations).hasSize(4);
		assertThat(collegeUtilitiesObservations).hasSize(4);
		assertThat(bearLakeObservations).hasSize(5);
		assertThat(greenRidgeObservations).hasSize(5);
		assertThat(abingtonObservations).hasSize(5);
		assertThat(carolinaTraceObservations).hasSize(4);
		assertThat(philaObservations).hasSize(6);
		assertThat(lancasterObservations).hasSize(2);
		assertThat(goldenHeartObservations)
			.filteredOn(observation -> observation.observationId().equals("golden-heart-pfoa-average-2024"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("3.8");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("golden-heart-2025-water-quality-report");
			});
		assertThat(collegeUtilitiesObservations)
			.filteredOn(observation -> observation.observationId().equals("college-utilities-pfoa-average-2024"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("3.8");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("college-utilities-2025-water-quality-report");
			});
		assertThat(bearLakeObservations)
			.filteredOn(observation -> observation.observationId().equals("bear-lake-pfoa-average-2023"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("3.25");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("bear-lake-pfas-2023-report");
			});
		assertThat(greenRidgeObservations)
			.filteredOn(observation -> observation.observationId().equals("green-ridge-pfoa-average-2024"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("2.28");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("green-ridge-2024-water-quality-report");
			});
		assertThat(abingtonObservations)
			.filteredOn(observation -> observation.observationId().equals("abington-pfoa-average-2024"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("1.32");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("abington-2024-water-quality-report");
			});
		assertThat(carolinaTraceObservations)
			.filteredOn(observation -> observation.observationId().equals("carolina-trace-pfos-amount-detected-2024"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("10.75");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfos_mcl_2024");
				assertThat(observation.sourceIds()).contains("carolina-trace-2024-water-quality-report");
			});
		assertThat(philaObservations)
			.filteredOn(observation -> observation.observationId().equals("phila-queenlane-pfoa-raa"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("6.8");
				assertThat(observation.benchmarkId()).isEqualTo("pa_pfoa_mcl_2023");
				assertThat(observation.sourceIds()).contains("phila-pfas-management", "pa-pfas-mcl-rule");
			});
		assertThat(lancasterObservations)
			.filteredOn(observation -> observation.observationId().equals("lancaster-conestoga-pfoa-raa-2025q3"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("15");
				assertThat(observation.benchmarkId()).isEqualTo("pa_pfoa_mcl_2023");
				assertThat(observation.sourceIds()).contains("lancaster-pfoa-notice-2025", "pa-pfas-mcl-rule");
			});
	}

	@Test
	void loadsSeededCertificationClaims() {
		var eSpringClaims = certificationClaimService.getByListingRecordId("122941C");
		var aqCwm2Claims = certificationClaimService.getByListingRecordId("AQ-CWM2");
		var aq6200Claims = certificationClaimService.getByListingRecordId("AQ-6200");
		var aq6300Claims = certificationClaimService.getByListingRecordId("AQ-6300");

		assertThat(eSpringClaims).hasSize(3);
		assertThat(eSpringClaims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction", "Total PFAS Reduction");
		assertThat(eSpringClaims.get(2).coveredPfas())
			.contains("PFOA", "PFOS", "PFBS");
		assertThat(aqCwm2Claims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(aq6200Claims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(aq6300Claims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
	}

	@Test
	void loadsSeededBenchmarks() {
		var benchmarks = benchmarkService.getAll();

		assertThat(benchmarks).hasSizeGreaterThanOrEqualTo(7);
		assertThat(benchmarkService.getByBenchmarkId("pa_pfoa_mcl_2023")).isPresent();
		assertThat(benchmarkService.getByBenchmarkId("us_pfoa_mcl_2024"))
			.get()
			.satisfies(record -> {
				assertThat(record.benchmarkValue()).isEqualByComparingTo("4");
				assertThat(record.referenceStatus()).isEqualTo("active_for_pfoa_pfos_only_after_2025_05_14");
			});
	}

	@Test
	void loadsSeededFilterCatalog() {
		var items = filterCatalogService.getAll();
		var cleanWaterMachine = filterCatalogService.getByProductId("aquasana-aq-cwm2").orElseThrow();
		var smartFlow = filterCatalogService.getByProductId("aquasana-aq-sfro2").orElseThrow();

		assertThat(items).hasSize(7);
		assertThat(items)
			.extracting(item -> item.productId())
			.containsExactly(
				"espring-122941",
				"aquasana-aq-6200",
				"aquasana-aq-6300",
				"aquasana-aq-6300m",
				"aquasana-aq-mf-1",
				"aquasana-aq-cwm2",
				"aquasana-aq-sfro2"
			);
		assertThat(items.get(0).listingRecordId()).isEqualTo("122941C");
		assertThat(items.get(0).upfrontCostUsd()).isEqualByComparingTo("1299.00");
		assertThat(items.get(0).replacementCostUsd()).isEqualByComparingTo("280.00");
		assertThat(items.get(1).listingRecordId()).isEqualTo("AQ-6200");
		assertThat(items.get(1).upfrontCostUsd()).isEqualByComparingTo("162.49");
		assertThat(items.get(1).replacementCostUsd()).isEqualByComparingTo("73.99");
		assertThat(items.get(1).claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(items.get(2).listingRecordId()).isEqualTo("AQ-6300");
		assertThat(items.get(2).upfrontCostUsd()).isEqualByComparingTo("174.99");
		assertThat(items.get(2).replacementCostUsd()).isEqualByComparingTo("83.99");
		assertThat(items.get(2).claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(items.get(0).claimNames())
			.contains("PFOA Reduction", "PFOS Reduction", "Total PFAS Reduction");
		assertThat(items.get(3).listingRecordId()).isEqualTo("AQ-6300M");
		assertThat(items.get(3).upfrontCostUsd()).isEqualByComparingTo("224.99");
		assertThat(items.get(3).replacementCostUsd()).isEqualByComparingTo("91.99");
		assertThat(items.get(3).claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(items.get(4).upfrontCostUsd()).isEqualByComparingTo("124.99");
		assertThat(items.get(4).replacementCostUsd()).isEqualByComparingTo("78.19");
		assertThat(items.get(4).claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(items.get(5).listingRecordId()).isEqualTo("AQ-CWM2");
		assertThat(items.get(5).upfrontCostUsd()).isEqualByComparingTo("279.99");
		assertThat(items.get(5).replacementCostUsd()).isEqualByComparingTo("73.49");
		assertThat(items.get(5).claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(cleanWaterMachine.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(smartFlow.listingRecordId()).isEqualTo("AQ-SFRO2");
		assertThat(smartFlow.upfrontCostUsd()).isEqualByComparingTo("224.99");
		assertThat(smartFlow.replacementCostUsd()).isNull();
		assertThat(smartFlow.recurringCostComponents()).hasSize(3);
		assertThat(smartFlow.recurringCostComponents())
			.extracting(component -> component.componentCode())
			.containsExactly("carbon-block-pair", "membrane", "remineralizer");
		assertThat(smartFlow.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
	}

	@Test
	void buildsPublicWaterDecisionContext() {
		var decision = publicWaterDecisionService.getByPwsid("PA1510001").orElseThrow();

		assertThat(decision.decisionStatus()).isEqualTo(PublicWaterDecisionStatus.PRESENT_BELOW_SELECTED_BENCHMARK);
		assertThat(decision.nextActionCode()).isEqualTo(PublicWaterNextActionCode.REVIEW_UTILITY_UPDATES_AND_OPTIONALLY_ADD_CERTIFIED_POU);
		assertThat(decision.decisionRuleId()).isEqualTo(PublicWaterDecisionRuleId.PUBLIC_WATER_DIRECT_DATA_BELOW_REFERENCE_OPTIONAL_POU);
		assertThat(decision.manualReviewRequired()).isFalse();
		assertThat(decision.assessments()).hasSize(6);
		assertThat(decision.assessments().get(0).benchmarkId()).isNotBlank();
		assertThat(decision.certifiedPouOptions())
			.extracting(item -> item.productId())
			.contains("espring-122941", "aquasana-aq-cwm2", "aquasana-aq-6200", "aquasana-aq-6300", "aquasana-aq-6300m", "aquasana-aq-mf-1");
	}

	@Test
	void buildsLancasterDecisionContextAboveReference() {
		var decision = publicWaterDecisionService.getByPwsid("7360058").orElseThrow();

		assertThat(decision.decisionStatus()).isEqualTo(PublicWaterDecisionStatus.ABOVE_SELECTED_BENCHMARK);
		assertThat(decision.nextActionCode()).isEqualTo(PublicWaterNextActionCode.REVIEW_UTILITY_NOTICE_AND_CONSIDER_CERTIFIED_POU);
		assertThat(decision.decisionRuleId()).isEqualTo(PublicWaterDecisionRuleId.PUBLIC_WATER_DIRECT_DATA_ABOVE_REFERENCE);
		assertThat(decision.manualReviewRequired()).isFalse();
		assertThat(decision.assessments())
			.anySatisfy(assessment -> {
				assertThat(assessment.observationId()).isEqualTo("lancaster-conestoga-pfoa-raa-2025q3");
				assertThat(assessment.value()).isEqualByComparingTo("15");
			});
	}

	@Test
	void buildsTypedPublicWaterResult() {
		var result = publicWaterResultService.getByPwsid("PA1510001").orElseThrow();

		assertThat(result.resultId()).isEqualTo("public-water:PA1510001");
		assertThat(result.schemaVersion()).isEqualTo("v1");
		assertThat(result.nextAction().code()).isEqualTo("REVIEW_UTILITY_UPDATES_AND_OPTIONALLY_ADD_CERTIFIED_POU");
		assertThat(result.initialCost().rangeLowUsd()).isEqualByComparingTo("124.99");
		assertThat(result.initialCost().rangeHighUsd()).isEqualByComparingTo("1299.00");
		assertThat(result.annualCostMaintenance().rangeLowUsd()).isEqualByComparingTo("146.98");
		assertThat(result.annualCostMaintenance().rangeHighUsd()).isEqualByComparingTo("280.00");
		assertThat(result.certificationChecklist()).hasSize(3);
		assertThat(result.bestFitOptions())
			.extracting(option -> option.optionCode())
			.containsExactly("AQUASANA_AQ_CWM2", "AQUASANA_AQ_6200", "AQUASANA_AQ_MF_1");
		assertThat(result.sources())
			.extracting(source -> source.sourceId())
			.contains(
				"pa-pfas-mcl-rule",
				"nsf-espring-listing-053",
				"amway-espring-122941-product",
				"aq-clean-water-machine-product",
				"aq-claryum-2-stage-product",
				"aq-claryum-3-stage-product",
				"aq-claryum-3-stage-max-flow-product"
			);
		assertThat(result.meta().waterSourceType()).isEqualTo("public_water");
		assertThat(result.meta().benchmarkRelation()).isEqualTo("below_reference");
	}

	@Test
	void buildsTypedLancasterPublicWaterResult() {
		var result = publicWaterResultService.getByPwsid("7360058").orElseThrow();

		assertThat(result.resultId()).isEqualTo("public-water:7360058");
		assertThat(result.nextAction().code()).isEqualTo("REVIEW_UTILITY_NOTICE_AND_CONSIDER_CERTIFIED_POU");
		assertThat(result.meta().benchmarkRelation()).isEqualTo("above_reference");
		assertThat(result.sources())
			.extracting(source -> source.sourceId())
			.contains("lancaster-pfoa-notice-2025", "pa-pfas-mcl-rule");
	}

	@Test
	void buildsTypedPrivateWellResult() {
		var result = privateWellResultService
			.get("MI", ActionBenchmarkRelation.ABOVE_REFERENCE, ActionCurrentFilterStatus.NONE, false)
			.orElseThrow();

		assertThat(result.resultId()).startsWith("private-well:MI");
		assertThat(result.nextAction().code()).isEqualTo("EVALUATE_CERTIFIED_POU_FILTER_AND_STATE_NEXT_STEPS");
		assertThat(result.bestFitOptions()).isNotEmpty();
		assertThat(result.referenceContext()).isNotNull();
		assertThat(result.referenceContext().primaryReferenceLabel()).contains("Michigan");
		assertThat(result.referenceContext().benchmarkLines())
			.extracting(line -> line.benchmarkDisplay())
			.contains("8 ppt", "16 ppt");
		assertThat(result.meta().waterSourceType()).isEqualTo("private_well");
		assertThat(result.meta().benchmarkRelation()).isEqualTo("above_reference");
	}

	@Test
	void evaluatesPrivateWellMeasurementAgainstStateProfile() {
		var evaluation = privateWellBenchmarkEvaluatorService.evaluate("MI", "PFOA", new java.math.BigDecimal("12"), "ppt").orElseThrow();

		assertThat(evaluation.stateCode()).isEqualTo("MI");
		assertThat(evaluation.benchmarkRelation()).isEqualTo(ActionBenchmarkRelation.ABOVE_REFERENCE);
		assertThat(evaluation.matchedReferenceLabel()).isEqualTo("Michigan MCL for PFOA");
		assertThat(evaluation.normalizedValuePpt()).isEqualByComparingTo("12");
	}

	@Test
	void evaluatesPrivateWellBatchAgainstStateProfile() {
		var batch = privateWellBenchmarkEvaluatorService.evaluateBatch("MI", "PFOA=12ppt;PFOS=3ppt").orElseThrow();
		var maBatch = privateWellBenchmarkEvaluatorService.evaluateBatch("MA", "PFAS6=18ppt").orElseThrow();

		assertThat(batch.aggregateRelation()).isEqualTo(ActionBenchmarkRelation.MIXED);
		assertThat(batch.lineEvaluations()).hasSize(2);
		assertThat(maBatch.aggregateRelation()).isEqualTo(ActionBenchmarkRelation.BELOW_REFERENCE);
		assertThat(maBatch.lineEvaluations().get(0).matchedReferenceLabel()).isEqualTo("PFAS6 maximum contaminant level");
	}

	@Test
	void buildsExpansionReadinessReport() {
		var report = expansionReadinessService.getReport();

		assertThat(report.readyStateRoutes()).isEqualTo(8);
		assertThat(report.blockedStateRoutes()).isZero();
		assertThat(report.readyPublicWaterRoutes()).isEqualTo(8);
		assertThat(report.blockedPublicWaterRoutes()).isZero();
		assertThat(report.items())
			.filteredOn(item -> item.routeType().equals("state_guidance"))
			.allSatisfy(item -> assertThat(item.status()).isEqualTo(ExpansionReadinessStatus.READY));
	}

	@Test
	void buildsPrivateWellTestFirstRecommendation() {
		var selection = actionCheckerService.normalize(
			"private_well",
			"none",
			"none",
			"unknown",
			"none",
			"none",
			false,
			"MI",
			null
		);
		var recommendation = actionCheckerService.evaluate(selection);

		assertThat(recommendation.routeCode()).isEqualTo(ActionCheckerRouteCode.PRIVATE_WELL_TEST_FIRST);
		assertThat(recommendation.primaryHref()).isEqualTo("/private-well/MI");
		assertThat(recommendation.wholeHouseGuardrail()).isFalse();
		assertThat(selection.pwsid()).isNull();
	}

	@Test
	void clearsIrrelevantCheckerDimensions() {
		var privateWellSelection = actionCheckerService.normalize(
			"private_well",
			"none",
			"none",
			"unknown",
			"none",
			"none",
			false,
			"MI",
			null
		);
		var publicWaterSelection = actionCheckerService.normalize(
			"public_water",
			"utility_document",
			"none",
			"below_reference",
			"none",
			"none",
			false,
			null,
			"7360058"
		);

		assertThat(privateWellSelection.pwsid()).isNull();
		assertThat(publicWaterSelection.stateCode()).isNull();
	}

	@Test
	void rendersHomePage() throws Exception {
		mockMvc.perform(get("/"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Official records,")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Philadelphia Water Department")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("High-intent guides before scaled expansion")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<link rel=\"canonical\" href=\"https://pfas.example.test/\">")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<meta name=\"robots\" content=\"index, follow\">")));
	}

	@Test
	void rendersActionCheckerPage() throws Exception {
		mockMvc.perform(get("/checker"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Action Checker")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Route the household")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Server-backed routing")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<link rel=\"canonical\" href=\"https://pfas.example.test/checker\">")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<meta name=\"robots\" content=\"noindex, nofollow\">")));
	}

	@Test
	void rendersCheckerSummaryFragment() throws Exception {
		mockMvc.perform(
			get("/checker/panel")
				.param("waterSource", "PRIVATE_WELL")
				.param("directData", "NONE")
				.param("benchmarkRelation", "UNKNOWN")
				.param("currentFilterStatus", "NONE")
				.param("stateCode", "MI")
				.param("wholeHouseConsidered", "false")
		)
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Test the private well before comparing filters")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("PRIVATE_WELL_TEST_FIRST")));
	}

	@Test
	void rendersPrivateWellStatePage() throws Exception {
		mockMvc.perform(get("/private-well/MI"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Michigan Department of Environment, Great Lakes, and Energy")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Test first, then interpret against state guidance.")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("State reference context")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Michigan MCL for PFOA")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Private-well state guide")));
	}

	@Test
	void rendersVermontPrivateWellStatePage() throws Exception {
		mockMvc.perform(get("/private-well/VT"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Vermont Department of Health")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("How to Test Your Drinking Water")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Vermont MCL for PFOA")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Private-well state guide")));
	}

	@Test
	void rendersPublicWaterSystemPage() throws Exception {
		mockMvc.perform(get("/public-water-system/PA1510001"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Use direct utility data before comparing filters.")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Philadelphia Water Department")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Public-water utility context")));
	}

	@Test
	void returnsInternalActionCheckerRecommendation() throws Exception {
		mockMvc.perform(
			get("/internal/action-checker/recommendation")
				.param("waterSource", "PUBLIC_WATER")
				.param("directData", "NONE")
				.param("pwsid", "PA1510001")
		)
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("PUBLIC_WATER_UTILITY_FIRST")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/public-water-system/PA1510001")));
	}

	@Test
	void returnsPrivateWellActionCheckerRecommendation() throws Exception {
		mockMvc.perform(
			get("/internal/action-checker/recommendation")
				.param("waterSource", "PRIVATE_WELL")
				.param("directData", "PRIVATE_WELL_TEST")
				.param("benchmarkRelation", "ABOVE_REFERENCE")
				.param("currentFilterStatus", "NONE")
				.param("stateCode", "MI")
		)
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("PRIVATE_WELL_CERTIFIED_POU_AND_STATE_NEXT_STEPS")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/private-well-result/MI")));
	}

	@Test
	void rendersPublicWaterResultPage() throws Exception {
		mockMvc.perform(get("/public-water/PA1510001"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Review utility updates and add certified point-of-use only if you want extra margin")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Assessment ledger")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Pennsylvania state MCL for PFOA")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Public-water interpretation")));
	}

	@Test
	void rendersLancasterPublicWaterResultPage() throws Exception {
		mockMvc.perform(get("/public-water/7360058"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("City of Lancaster Water Department")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Review utility response and consider certified point-of-use filtration")));
	}

	@Test
	void returnsInternalPrivateWellResult() throws Exception {
		mockMvc.perform(
			get("/internal/results/private-well/MI")
				.param("benchmarkRelation", "ABOVE_REFERENCE")
				.param("currentFilterStatus", "NONE")
		)
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("EVALUATE_CERTIFIED_POU_FILTER_AND_STATE_NEXT_STEPS")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"reference_context\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"water_source_type\":\"private_well\"")));
	}

	@Test
	void returnsInternalPrivateWellResultFromMeasurement() throws Exception {
		mockMvc.perform(
			get("/internal/results/private-well/MI")
				.param("analyteCode", "PFOA")
				.param("value", "12")
				.param("unit", "ppt")
				.param("currentFilterStatus", "NONE")
		)
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"benchmark_evaluation\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"matched_reference_label\":\"Michigan MCL for PFOA\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"benchmark_relation\":\"above_reference\"")));
	}

	@Test
	void returnsInternalPrivateWellResultFromBatchMeasurement() throws Exception {
		mockMvc.perform(
			get("/internal/results/private-well/MI")
				.param("batchInput", "PFOA=12ppt;PFOS=3ppt")
				.param("currentFilterStatus", "NONE")
		)
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"benchmark_batch_evaluation\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"aggregate_relation\":\"mixed\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"line_evaluations\"")));
	}

	@Test
	void rendersPrivateWellResultPage() throws Exception {
		mockMvc.perform(
			get("/private-well-result/MI")
				.param("benchmarkRelation", "ABOVE_REFERENCE")
				.param("currentFilterStatus", "NONE")
		)
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Open state next steps and evaluate certified point-of-use")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Michigan PFAS drinking-water MCLs used with other private-well factors")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Private-well interpretation")));
	}

	@Test
	void rendersPrivateWellResultPageFromMeasurement() throws Exception {
		mockMvc.perform(
			get("/private-well-result/MI")
				.param("analyteCode", "PFOA")
				.param("value", "12")
				.param("unit", "ppt")
		)
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Benchmark check used for this route")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Michigan MCL for PFOA")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Normalized value: 12")));
	}

	@Test
	void rendersPrivateWellResultPageFromBatchMeasurement() throws Exception {
		mockMvc.perform(
			get("/private-well-result/MI")
				.param("batchInput", "PFOA=12ppt;PFOS=3ppt")
		)
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Batch benchmark check used for this route")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Aggregate relation: mixed")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("PFOA")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("PFOS")));
	}

	@Test
	void returnsStateBenchmarkProfiles() throws Exception {
		mockMvc.perform(get("/internal/state-benchmark-profiles/NY"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("New York PFOA and PFOS MCLs")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("10 ppt")));
	}

	@Test
	void returnsMaineStateBenchmarkProfile() throws Exception {
		mockMvc.perform(get("/internal/state-benchmark-profiles/ME"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Maine interim PFAS6 drinking-water standard")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("20 ppt")));
	}

	@Test
	void returnsReadinessReport() throws Exception {
		mockMvc.perform(get("/internal/readiness/report"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"ready_state_routes\":8")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"ready_public_water_routes\":8")));
	}

	@Test
	void returnsPrivateWellBenchmarkEvaluation() throws Exception {
		mockMvc.perform(
			get("/internal/private-well-benchmark-evaluation/WA")
				.param("analyteCode", "PFOA")
				.param("value", "5")
				.param("unit", "ppt")
		)
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"matched_reference_label\":\"Washington SAL for PFOA\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"benchmark_relation\":\"ABOVE_REFERENCE\"")));
	}

	@Test
	void returnsPrivateWellBatchBenchmarkEvaluation() throws Exception {
		mockMvc.perform(
			get("/internal/private-well-benchmark-evaluation/MA/batch")
				.param("batchInput", "PFAS6=18ppt")
		)
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"aggregate_relation\":\"BELOW_REFERENCE\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"matched_reference_label\":\"PFAS6 maximum contaminant level\"")));
	}

	@Test
	void returnsExpansionCandidates() throws Exception {
		mockMvc.perform(get("/internal/expansion/candidates"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/private-well/MI")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/public-water-system/AK2310900")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/public-water-system/FL3590069")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/public-water-system/7360058")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/public-water-system/NC0234191")));
	}

	@Test
	void returnsDerivedRouteManifest() throws Exception {
		mockMvc.perform(get("/internal/derived/route-manifest"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_count\":22")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/AK2310730\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/AK2310900\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/FL3590069\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/MD0120011\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/private-well/MI\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/NC0234191\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/7360058\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/guides/read-your-ccr\"")));
	}

	@Test
	void returnsDerivedSearchIndexSeed() throws Exception {
		mockMvc.perform(get("/internal/derived/search-index"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_count\":22")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"state_guidance:MI\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:AK2310730\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:AK2310900\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:FL3590069\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:MD0120011\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:NC0234191\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:7360058\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"guide:read-your-ccr\"")));
	}

	@Test
	void returnsDerivedDecisionInputSeed() throws Exception {
		mockMvc.perform(get("/internal/derived/decision-inputs"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_count\":16")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"state_guidance:MI\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"state_code\":\"MI\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"pwsid\":null")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"recommended_route_code\":\"PRIVATE_WELL_TEST_FIRST\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:AK2310730\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:AK2310900\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:FL3590069\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:MD0120011\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:NC0234191\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"recommended_route_code\":\"PUBLIC_WATER_INTERPRET_DIRECT_DATA\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:7360058\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"state_code\":null")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"recommended_route_code\":\"PUBLIC_WATER_CERTIFIED_POU_EVALUATION\"")));
	}

	@Test
	void returnsDerivedPageGenerationManifest() throws Exception {
		mockMvc.perform(get("/internal/derived/page-generation-manifest"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_count\":22")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/AK2310730.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/AK2310900.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/FL3590069.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/MD0120011.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/NC0234191.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/7360058.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/state_guidance/MI.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/guide/read-your-ccr.json\"")));
	}

	@Test
	void returnsDerivedPublicWaterPageModel() throws Exception {
		mockMvc.perform(get("/internal/derived/page-models/public_water/7360058"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_id\":\"public_water:7360058\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"template_kind\":\"public_water_result_page\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"decision_input\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"next_action\"")));
	}

	@Test
	void returnsDerivedStateGuidePageModel() throws Exception {
		mockMvc.perform(get("/internal/derived/page-models/state_guidance/MI"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_id\":\"state_guidance:MI\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"template_kind\":\"private_well_state_page\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"entry_decision_input\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"sample_result_path\":\"/private-well-result/MI?benchmarkRelation=UNKNOWN&currentFilterStatus=NONE&wholeHouseConsidered=false\"")));
	}

	@Test
	void returnsStaticExportManifest() throws Exception {
		mockMvc.perform(get("/internal/derived/static-export-manifest"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"item_count\":38")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/checker\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/robots.txt\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/sitemap.xml\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/AK2310730\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/AK2310900\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/FL3590069\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/MD0120011\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/NC0234191\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/7360058\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"output_path\":\"guides/read-your-ccr/index.html\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"output_path\":\"css/app.css\"")));
	}

	@Test
	void returnsRobotsTxt() throws Exception {
		mockMvc.perform(get("/robots.txt"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Disallow: /internal/")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Disallow: /checker")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Sitemap: https://pfas.example.test/sitemap.xml")));
	}

	@Test
	void returnsSitemapXml() throws Exception {
		mockMvc.perform(get("/sitemap.xml"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/guides/read-your-ccr</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/FL3590069</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/7360058</loc>")));
	}

	@Test
	void rendersGuidePage() throws Exception {
		mockMvc.perform(get("/guides/public-water-vs-private-well"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Public water vs private well is the first split, not a small detail")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Decision-intent guide")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Use source type as the first decision boundary")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("How this guide was built")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Primary source ledger")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("CCR Information for Consumers")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("PFAS in Private Wells")));
	}

	@Test
	void rendersMethodologyPage() throws Exception {
		mockMvc.perform(get("/methodology"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("How the engine turns evidence into next actions")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Current operating surface")));
	}

	@Test
	void rendersSourcePolicyPage() throws Exception {
		mockMvc.perform(get("/source-policy"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("The project ranks sources before it ranks products")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Trust tiers")));
	}
}
