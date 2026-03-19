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

@SpringBootTest(properties = "pfas.data.root=./data")
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
				"mn-pfas-values",
				"ny-water-supplier-factsheet-mcls",
				"wa-pfas-group-a-support",
				"ca-pfas-timeline"
			);
	}

	@Test
	void loadsSeededStateGuidance() {
		var states = stateGuidanceService.getAll();

		assertThat(states).hasSize(6);
		assertThat(states)
			.extracting(state -> state.stateCode())
			.containsExactly("CA", "MA", "MI", "MN", "NY", "WA");
	}

	@Test
	void loadsSeededStateBenchmarkProfiles() {
		var profiles = stateBenchmarkProfileService.getAll();
		var washington = stateBenchmarkProfileService.getByStateCode("WA").orElseThrow();

		assertThat(profiles).hasSize(6);
		assertThat(profiles)
			.extracting(profile -> profile.stateCode())
			.containsExactly("CA", "MA", "MI", "MN", "NY", "WA");
		assertThat(washington.primaryReferenceLabel()).contains("Washington");
		assertThat(washington.benchmarks())
			.extracting(line -> line.benchmarkDisplay())
			.contains("4 ppt", "10 ppt");
	}

	@Test
	void loadsSeededPublicWaterSystems() {
		var systems = publicWaterSystemService.getAll();
		var phila = publicWaterSystemService.getByPwsid("PA1510001").orElseThrow();
		var lancaster = publicWaterSystemService.getByPwsid("7360058").orElseThrow();

		assertThat(systems).hasSize(2);
		assertThat(systems)
			.extracting(system -> system.pwsid())
			.containsExactly("7360058", "PA1510001");
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
		var philaObservations = utilityObservationService.getByPwsid("PA1510001");
		var lancasterObservations = utilityObservationService.getByPwsid("7360058");

		assertThat(philaObservations).hasSize(6);
		assertThat(lancasterObservations).hasSize(2);
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

		assertThat(eSpringClaims).hasSize(3);
		assertThat(eSpringClaims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction", "Total PFAS Reduction");
		assertThat(eSpringClaims.get(2).coveredPfas())
			.contains("PFOA", "PFOS", "PFBS");
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

		assertThat(items).hasSize(2);
		assertThat(items)
			.extracting(item -> item.productId())
			.containsExactly("espring-122941", "aquasana-aq-mf-1");
		assertThat(items.get(0).listingRecordId()).isEqualTo("122941C");
		assertThat(items.get(0).upfrontCostUsd()).isEqualByComparingTo("1299.00");
		assertThat(items.get(0).replacementCostUsd()).isEqualByComparingTo("280.00");
		assertThat(items.get(0).claimNames())
			.contains("PFOA Reduction", "PFOS Reduction", "Total PFAS Reduction");
		assertThat(items.get(1).upfrontCostUsd()).isEqualByComparingTo("124.99");
		assertThat(items.get(1).replacementCostUsd()).isEqualByComparingTo("78.19");
		assertThat(items.get(1).claimNames()).contains("PFOA Reduction", "PFOS Reduction");
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
			.contains("espring-122941", "aquasana-aq-mf-1");
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
		assertThat(result.annualCostMaintenance().rangeLowUsd()).isEqualByComparingTo("78.19");
		assertThat(result.annualCostMaintenance().rangeHighUsd()).isEqualByComparingTo("280.00");
		assertThat(result.certificationChecklist()).hasSize(3);
		assertThat(result.bestFitOptions())
			.extracting(option -> option.optionCode())
			.contains("ESPRING_122941", "AQUASANA_AQ_MF_1");
		assertThat(result.sources())
			.extracting(source -> source.sourceId())
			.contains("pa-pfas-mcl-rule", "nsf-espring-listing-053", "amway-espring-122941-product");
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

		assertThat(report.readyStateRoutes()).isEqualTo(6);
		assertThat(report.blockedStateRoutes()).isZero();
		assertThat(report.readyPublicWaterRoutes()).isEqualTo(2);
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
			.andExpect(content().string(org.hamcrest.Matchers.containsString("High-intent guides before scaled expansion")));
	}

	@Test
	void rendersActionCheckerPage() throws Exception {
		mockMvc.perform(get("/checker"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Action Checker")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Route the household")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Server-backed routing")));
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
	void returnsReadinessReport() throws Exception {
		mockMvc.perform(get("/internal/readiness/report"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"ready_state_routes\":6")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"ready_public_water_routes\":2")));
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
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/public-water-system/7360058")));
	}

	@Test
	void returnsDerivedRouteManifest() throws Exception {
		mockMvc.perform(get("/internal/derived/route-manifest"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_count\":14")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/private-well/MI\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/7360058\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/guides/read-your-ccr\"")));
	}

	@Test
	void returnsDerivedSearchIndexSeed() throws Exception {
		mockMvc.perform(get("/internal/derived/search-index"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_count\":14")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"state_guidance:MI\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:7360058\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"guide:read-your-ccr\"")));
	}

	@Test
	void returnsDerivedDecisionInputSeed() throws Exception {
		mockMvc.perform(get("/internal/derived/decision-inputs"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_count\":8")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"state_guidance:MI\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"state_code\":\"MI\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"pwsid\":null")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"recommended_route_code\":\"PRIVATE_WELL_TEST_FIRST\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:7360058\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"state_code\":null")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"recommended_route_code\":\"PUBLIC_WATER_CERTIFIED_POU_EVALUATION\"")));
	}

	@Test
	void rendersGuidePage() throws Exception {
		mockMvc.perform(get("/guides/public-water-vs-private-well"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Public water vs private well is the first split, not a small detail")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Decision-intent guide")));
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
