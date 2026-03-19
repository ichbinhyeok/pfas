package com.example.pfas;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import com.example.pfas.certification.CertificationClaimService;
import com.example.pfas.decision.PublicWaterDecisionService;
import com.example.pfas.filter.FilterCatalogService;
import com.example.pfas.observation.UtilityObservationService;
import com.example.pfas.source.SourceRegistryService;
import com.example.pfas.state.StateGuidanceService;
import com.example.pfas.water.PublicWaterSystemService;

@SpringBootTest(properties = "pfas.data.root=./data")
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
	private FilterCatalogService filterCatalogService;

	@Autowired
	private PublicWaterDecisionService publicWaterDecisionService;

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
				assertThat(observation.benchmarkValue()).isEqualByComparingTo("14");
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

		assertThat(decision.decisionStatus()).isEqualTo("present_below_selected_benchmark");
		assertThat(decision.nextActionCode()).isEqualTo("review_utility_updates_and_optionally_add_certified_pou");
		assertThat(decision.assessments()).hasSize(6);
		assertThat(decision.certifiedPouOptions())
			.extracting(item -> item.productId())
			.contains("espring-122941");
	}

}
