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

import com.example.pfas.checker.ActionCheckerRouteCode;
import com.example.pfas.checker.ActionCheckerService;
import com.example.pfas.benchmark.BenchmarkService;
import com.example.pfas.certification.CertificationClaimService;
import com.example.pfas.decision.PublicWaterDecisionRuleId;
import com.example.pfas.decision.PublicWaterDecisionStatus;
import com.example.pfas.decision.PublicWaterNextActionCode;
import com.example.pfas.decision.PublicWaterDecisionService;
import com.example.pfas.filter.FilterCatalogService;
import com.example.pfas.observation.UtilityObservationService;
import com.example.pfas.result.PublicWaterResultService;
import com.example.pfas.source.SourceRegistryService;
import com.example.pfas.state.StateGuidanceService;
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
	private PublicWaterDecisionService publicWaterDecisionService;

	@Autowired
	private PublicWaterResultService publicWaterResultService;

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

		assertThat(documents).hasSizeGreaterThanOrEqualTo(10);
		assertThat(documents)
			.extracting(document -> document.sourceId())
			.contains(
				"epa-pfas-npdwr-implementation",
				"epa-certified-pfas-filter-guidance",
				"atsdr-testing-for-pfas",
				"nsf-dwtu-listings"
			);
	}

	@Test
	void loadsSeededStateGuidance() {
		var states = stateGuidanceService.getAll();

		assertThat(states).hasSize(3);
		assertThat(states)
			.extracting(state -> state.stateCode())
			.containsExactly("MI", "MN", "NY");
	}

	@Test
	void loadsSeededPublicWaterSystems() {
		var systems = publicWaterSystemService.getAll();

		assertThat(systems).hasSize(1);
		assertThat(systems.get(0).pwsid()).isEqualTo("PA1510001");
		assertThat(systems.get(0).sourceIds())
			.contains(
				"phila-pwd-home",
				"phila-2024-water-quality-report",
				"phila-pfas-management"
			);
	}

	@Test
	void loadsSeededUtilityObservations() {
		var observations = utilityObservationService.getByPwsid("PA1510001");

		assertThat(observations).hasSize(6);
		assertThat(observations)
			.filteredOn(observation -> observation.observationId().equals("phila-queenlane-pfoa-raa"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("6.8");
				assertThat(observation.benchmarkId()).isEqualTo("pa_pfoa_mcl_2023");
				assertThat(observation.sourceIds()).contains("phila-pfas-management", "pa-pfas-mcl-rule");
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

		assertThat(items).hasSize(1);
		assertThat(items.get(0).productId()).isEqualTo("espring-122941");
		assertThat(items.get(0).listingRecordId()).isEqualTo("122941C");
		assertThat(items.get(0).upfrontCostUsd()).isEqualByComparingTo("1299.00");
		assertThat(items.get(0).replacementCostUsd()).isEqualByComparingTo("280.00");
		assertThat(items.get(0).claimNames())
			.contains("PFOA Reduction", "PFOS Reduction", "Total PFAS Reduction");
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
			.contains("espring-122941");
	}

	@Test
	void buildsTypedPublicWaterResult() {
		var result = publicWaterResultService.getByPwsid("PA1510001").orElseThrow();

		assertThat(result.resultId()).isEqualTo("public-water:PA1510001");
		assertThat(result.schemaVersion()).isEqualTo("v1");
		assertThat(result.nextAction().code()).isEqualTo("REVIEW_UTILITY_UPDATES_AND_OPTIONALLY_ADD_CERTIFIED_POU");
		assertThat(result.initialCost().rangeLowUsd()).isEqualByComparingTo("1299.00");
		assertThat(result.annualCostMaintenance().rangeHighUsd()).isEqualByComparingTo("280.00");
		assertThat(result.certificationChecklist()).hasSize(3);
		assertThat(result.bestFitOptions())
			.extracting(option -> option.optionCode())
			.contains("ESPRING_122941");
		assertThat(result.sources())
			.extracting(source -> source.sourceId())
			.contains("pa-pfas-mcl-rule", "nsf-espring-listing-053", "amway-espring-122941-product");
		assertThat(result.meta().waterSourceType()).isEqualTo("public_water");
		assertThat(result.meta().benchmarkRelation()).isEqualTo("below_reference");
	}

	@Test
	void buildsPrivateWellTestFirstRecommendation() {
		var selection = actionCheckerService.normalize(
			"private_well",
			"none",
			"none",
			true,
			"MI",
			null
		);
		var recommendation = actionCheckerService.evaluate(selection);

		assertThat(recommendation.routeCode()).isEqualTo(ActionCheckerRouteCode.PRIVATE_WELL_TEST_FIRST);
		assertThat(recommendation.primaryHref()).isEqualTo("/private-well/MI");
		assertThat(recommendation.wholeHouseGuardrail()).isTrue();
	}

	@Test
	void rendersHomePage() throws Exception {
		mockMvc.perform(get("/"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Official records,")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Philadelphia Water Department")));
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
				.param("stateCode", "MI")
				.param("wholeHouseConsidered", "true")
		)
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Test the private well before comparing filters")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Whole-house guardrail")));
	}

	@Test
	void rendersPrivateWellStatePage() throws Exception {
		mockMvc.perform(get("/private-well/MI"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Michigan Department of Environment, Great Lakes, and Energy")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Test first, then interpret against state guidance.")));
	}

	@Test
	void rendersPublicWaterSystemPage() throws Exception {
		mockMvc.perform(get("/public-water-system/PA1510001"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Use direct utility data before comparing filters.")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Philadelphia Water Department")));
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
	void rendersPublicWaterResultPage() throws Exception {
		mockMvc.perform(get("/public-water/PA1510001"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Review utility updates and add certified point-of-use only if you want extra margin")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Assessment breakdown")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Pennsylvania state MCL for PFOA")));
	}

}
