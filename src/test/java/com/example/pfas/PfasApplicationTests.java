package com.example.pfas;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Comparator;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
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
import com.example.pfas.web.GuidePageService;

@SpringBootTest(properties = {
	"pfas.data.root=./data",
	"pfas.site.base-url=https://pfas.example.test",
	"pfas.merchant-clicks.root=./build/test-merchant-clicks"
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
	private GuidePageService guidePageService;

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
				"georgia-water-home",
				"alpine-terrace-pfas-2023-report",
				"alaska-dww-college-utilities-monitoring-summary",
				"college-utilities-2025-water-quality-report",
				"green-ridge-pfas-2023-report",
				"bermuda-water-pfas-2023-report",
				"abington-pfas-2023-report",
				"apple-canyon-pfas-2023-report",
				"calvada-meadows-pfas-2023-report",
				"new-jersey-water-home",
				"montague-pfas-2023-report",
				"sunshine-water-home",
				"bear-lake-pfas-2023-report",
				"crescent-heights-pfas-2023-report",
				"cypress-lakes-pfas-2023-report",
				"four-lakes-pfas-2023-report",
				"golden-hills-pfas-2023-report",
				"lusi-north-umcr5-2024-notice",
				"sanlando-umcr5-2024-notice",
				"aquatru-classic-product",
				"aquatru-carafe-product",
				"aquatru-under-sink-product",
				"aquatru-model-1-product",
				"aquatru-model-1-performance-pdf",
				"zerowater-performance-certification",
				"zerowater-certified-devices-performance-pdf",
				"zerowater-10-cup-pitcher-product",
				"zerowater-faucet-mount-faq",
				"zerowater-7-cup-pitcher-product",
				"zerowater-23-cup-dispenser-product",
				"aq-claryum-3-stage-product",
				"aq-clean-water-machine-product",
				"aq-optimh2o-ro-product",
				"waterdrop-g3p600-product",
				"waterdrop-g3p800-product",
				"waterdrop-g2-product",
				"waterdrop-a2-product",
				"waterdrop-g5p700a-product",
				"waterdrop-k19-sfk-product",
				"waterdrop-x8-a-product",
				"waterdrop-x10-product",
				"waterdrop-x12-product",
				"waterdrop-x16-product",
				"cold-springs-pfas-2023-report",
				"spanish-springs-pfas-2023-report",
				"spring-creek-mobile-home-2024-water-quality-report",
				"galena-2024-water-quality-report",
				"little-wekiva-pfas-2023-report",
				"oakland-shores-pfas-2023-report",
				"iws-2024-water-quality-report"
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
		var bermuda = publicWaterSystemService.getByPwsid("AZ0408063").orElseThrow();
		var fourLakes = publicWaterSystemService.getByPwsid("FL3354647").orElseThrow();
		var lakeSaunders = publicWaterSystemService.getByPwsid("FL3354695").orElseThrow();
		var crescentHeights = publicWaterSystemService.getByPwsid("FL3480255").orElseThrow();
		var bearLake = publicWaterSystemService.getByPwsid("FL3590069").orElseThrow();
		var jansen = publicWaterSystemService.getByPwsid("FL3590615").orElseThrow();
		var goldenHills = publicWaterSystemService.getByPwsid("FL6424076").orElseThrow();
		var cypressLakes = publicWaterSystemService.getByPwsid("FL6535055").orElseThrow();
		var lakeTarpon = publicWaterSystemService.getByPwsid("FL6521000").orElseThrow();
		var littleWekiva = publicWaterSystemService.getByPwsid("FL3590762").orElseThrow();
		var oaklandShores = publicWaterSystemService.getByPwsid("FL3590912").orElseThrow();
		var labrador = publicWaterSystemService.getByPwsid("FL6514842").orElseThrow();
		var weathersfield = publicWaterSystemService.getByPwsid("FL3591451").orElseThrow();
		var alpineTerrace = publicWaterSystemService.getByPwsid("GA3110075").orElseThrow();
		var galena = publicWaterSystemService.getByPwsid("IL0855050").orElseThrow();
		var appleCanyon = publicWaterSystemService.getByPwsid("IL0855150").orElseThrow();
		var oakwood = publicWaterSystemService.getByPwsid("IL1830600").orElseThrow();
		var camelot = publicWaterSystemService.getByPwsid("IL1975200").orElseThrow();
		var coventryCreek = publicWaterSystemService.getByPwsid("IL2015160").orElseThrow();
		var indianaWater = publicWaterSystemService.getByPwsid("IN5245057").orElseThrow();
		var greenRidge = publicWaterSystemService.getByPwsid("MD0120011").orElseThrow();
		var montague = publicWaterSystemService.getByPwsid("NJ1914002").orElseThrow();
		var springCreekHousing = publicWaterSystemService.getByPwsid("NV0000036").orElseThrow();
		var coldSprings = publicWaterSystemService.getByPwsid("NV0000207").orElseThrow();
		var calvadaMeadows = publicWaterSystemService.getByPwsid("NV0000408").orElseThrow();
		var spanishSprings = publicWaterSystemService.getByPwsid("NV0001086").orElseThrow();
		var springCreekMobileHome = publicWaterSystemService.getByPwsid("NV0005027").orElseThrow();
		var abington = publicWaterSystemService.getByPwsid("NC0234191").orElseThrow();
		var carolinaTrace = publicWaterSystemService.getByPwsid("NC0353101").orElseThrow();
		var lusiNorth = publicWaterSystemService.getByPwsid("FL3354883").orElseThrow();
		var sanlando = publicWaterSystemService.getByPwsid("FL3591121").orElseThrow();
		var phila = publicWaterSystemService.getByPwsid("PA1510001").orElseThrow();
		var lancaster = publicWaterSystemService.getByPwsid("7360058").orElseThrow();

		assertThat(systems).hasSize(35);
		assertThat(systems)
			.extracting(system -> system.pwsid())
			.contains(
				"AK2310900",
				"AK2310730",
				"AZ0408063",
				"FL3354647",
				"FL3354695",
				"FL3354883",
				"FL3480255",
				"FL3590069",
				"FL3590615",
				"FL3590762",
				"FL3590912",
				"FL3591121",
				"FL3591451",
				"FL6424076",
				"FL6514842",
				"FL6521000",
				"FL6535055",
				"GA3110075",
				"IL0855050",
				"IL0855150",
				"IL1830600",
				"IL1975200",
				"IL2015160",
				"IN5245057",
				"MD0120011",
				"NC0234191",
				"NC0353101",
				"NJ1914002",
				"NV0000036",
				"NV0000207",
				"NV0000408",
				"NV0001086",
				"NV0005027",
				"7360058",
				"PA1510001"
			);
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
		assertThat(bermuda.sourceIds())
			.contains(
				"bermuda-water-home",
				"bermuda-water-quality-reports",
				"bermuda-water-2024-water-quality-report",
				"bermuda-water-pfas-2023-report"
			);
		assertThat(fourLakes.sourceIds())
			.contains(
				"sunshine-water-home",
				"sunshine-water-quality-reports",
				"four-lakes-2024-water-quality-report",
				"four-lakes-pfas-2023-report"
			);
		assertThat(lakeSaunders.sourceIds())
			.contains(
				"sunshine-water-home",
				"sunshine-water-quality-reports",
				"lake-saunders-2024-water-quality-report",
				"lake-saunders-pfas-2023-report"
			);
		assertThat(crescentHeights.sourceIds())
			.contains(
				"sunshine-water-home",
				"sunshine-water-quality-reports",
				"crescent-heights-2024-water-quality-report",
				"crescent-heights-pfas-2023-report"
			);
		assertThat(bearLake.sourceIds())
			.contains(
				"sunshine-water-home",
				"sunshine-water-quality-reports",
				"bear-lake-2024-water-quality-report",
				"bear-lake-pfas-2023-report"
			);
		assertThat(jansen.sourceIds())
			.contains(
				"sunshine-water-home",
				"sunshine-water-quality-reports",
				"jansen-2024-water-quality-report",
				"jansen-pfas-2023-report"
			);
		assertThat(goldenHills.sourceIds())
			.contains(
				"sunshine-water-home",
				"sunshine-water-quality-reports",
				"golden-hills-2024-water-quality-report",
				"golden-hills-pfas-2023-report"
			);
		assertThat(labrador.sourceIds())
			.contains(
				"sunshine-water-home",
				"sunshine-water-quality-reports",
				"labrador-2024-water-quality-report",
				"labrador-pfas-2023-report"
			);
		assertThat(lakeTarpon.sourceIds())
			.contains(
				"sunshine-water-home",
				"sunshine-water-quality-reports",
				"lake-tarpon-2024-water-quality-report",
				"lake-tarpon-pfas-2023-report"
			);
		assertThat(littleWekiva.sourceIds())
			.contains(
				"sunshine-water-home",
				"sunshine-water-quality-reports",
				"little-wekiva-2024-water-quality-report",
				"little-wekiva-pfas-2023-report"
			);
		assertThat(oaklandShores.sourceIds())
			.contains(
				"sunshine-water-home",
				"sunshine-water-quality-reports",
				"oakland-shores-2024-water-quality-report",
				"oakland-shores-pfas-2023-report"
			);
		assertThat(weathersfield.sourceIds())
			.contains(
				"sunshine-water-home",
				"sunshine-water-quality-reports",
				"weathersfield-2024-water-quality-report",
				"weathersfield-pfas-2023-report"
			);
		assertThat(cypressLakes.sourceIds())
			.contains(
				"sunshine-water-home",
				"sunshine-water-quality-reports",
				"cypress-lakes-2024-water-quality-report",
				"cypress-lakes-pfas-2023-report"
			);
		assertThat(alpineTerrace.sourceIds())
			.contains(
				"georgia-water-home",
				"alpine-terrace-2024-water-quality-report",
				"alpine-terrace-pfas-2023-report"
			);
		assertThat(galena.sourceIds())
			.contains(
				"prairie-path-water-home",
				"prairie-path-water-quality-reports",
				"galena-2024-water-quality-report"
			);
		assertThat(appleCanyon.sourceIds())
			.contains(
				"prairie-path-water-home",
				"prairie-path-water-quality-reports",
				"apple-canyon-2024-water-quality-report",
				"apple-canyon-pfas-2023-report"
			);
		assertThat(oakwood.sourceIds())
			.contains(
				"prairie-path-water-home",
				"prairie-path-water-quality-reports",
				"oakwood-2024-water-quality-report",
				"oakwood-pfas-2023-report"
			);
		assertThat(camelot.sourceIds())
			.contains(
				"prairie-path-water-home",
				"prairie-path-water-quality-reports",
				"camelot-2024-water-quality-report",
				"camelot-pfas-2023-report"
			);
		assertThat(coventryCreek.sourceIds())
			.contains(
				"prairie-path-water-home",
				"prairie-path-water-quality-reports",
				"coventry-creek-2024-water-quality-report",
				"coventry-creek-pfas-2023-report"
			);
		assertThat(indianaWater.sourceIds())
			.contains(
				"indiana-water-home",
				"indiana-water-quality-reports",
				"iws-2024-water-quality-report"
			);
		assertThat(greenRidge.sourceIds())
			.contains(
				"maryland-water-home",
				"maryland-water-quality-reports",
				"green-ridge-2024-water-quality-report",
				"green-ridge-pfas-2023-report"
			);
		assertThat(montague.sourceIds())
			.contains(
				"new-jersey-water-home",
				"new-jersey-water-quality-reports",
				"montague-2024-water-quality-report",
				"montague-pfas-2023-report"
			);
		assertThat(springCreekHousing.sourceIds())
			.contains(
				"great-basin-water-home",
				"great-basin-water-quality-reports",
				"spring-creek-housing-2024-water-quality-report"
			);
		assertThat(coldSprings.sourceIds())
			.contains(
				"great-basin-water-home",
				"great-basin-water-quality-reports",
				"cold-springs-2024-water-quality-report",
				"cold-springs-pfas-2023-report"
			);
		assertThat(calvadaMeadows.sourceIds())
			.contains(
				"great-basin-water-home",
				"great-basin-water-quality-reports",
				"calvada-meadows-2024-water-quality-report",
				"calvada-meadows-pfas-2023-report"
			);
		assertThat(spanishSprings.sourceIds())
			.contains(
				"great-basin-water-home",
				"great-basin-water-quality-reports",
				"spanish-springs-2024-water-quality-report",
				"spanish-springs-pfas-2023-report"
			);
		assertThat(springCreekMobileHome.sourceIds())
			.contains(
				"great-basin-water-home",
				"great-basin-water-quality-reports",
				"spring-creek-mobile-home-2024-water-quality-report"
			);
		assertThat(abington.sourceIds())
			.contains(
				"carolina-water-home",
				"carolina-water-quality-reports",
				"abington-2024-water-quality-report",
				"abington-pfas-2023-report"
			);
		assertThat(carolinaTrace.sourceIds())
			.contains(
				"carolina-water-home",
				"carolina-water-quality-reports",
				"carolina-trace-2024-water-quality-report"
			);
		assertThat(lusiNorth.sourceIds())
			.contains(
				"sunshine-water-home",
				"sunshine-water-quality-reports",
				"lusi-north-umcr5-2024-notice"
			);
		assertThat(sanlando.sourceIds())
			.contains(
				"sunshine-water-home",
				"sunshine-water-quality-reports",
				"sanlando-umcr5-2024-notice"
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
		var bermudaObservations = utilityObservationService.getByPwsid("AZ0408063");
		var fourLakesObservations = utilityObservationService.getByPwsid("FL3354647");
		var lakeSaundersObservations = utilityObservationService.getByPwsid("FL3354695");
		var crescentHeightsObservations = utilityObservationService.getByPwsid("FL3480255");
		var bearLakeObservations = utilityObservationService.getByPwsid("FL3590069");
		var jansenObservations = utilityObservationService.getByPwsid("FL3590615");
		var weathersfieldObservations = utilityObservationService.getByPwsid("FL3591451");
		var goldenHillsObservations = utilityObservationService.getByPwsid("FL6424076");
		var labradorObservations = utilityObservationService.getByPwsid("FL6514842");
		var lakeTarponObservations = utilityObservationService.getByPwsid("FL6521000");
		var littleWekivaObservations = utilityObservationService.getByPwsid("FL3590762");
		var oaklandShoresObservations = utilityObservationService.getByPwsid("FL3590912");
		var cypressLakesObservations = utilityObservationService.getByPwsid("FL6535055");
		var alpineTerraceObservations = utilityObservationService.getByPwsid("GA3110075");
		var galenaObservations = utilityObservationService.getByPwsid("IL0855050");
		var appleCanyonObservations = utilityObservationService.getByPwsid("IL0855150");
		var oakwoodObservations = utilityObservationService.getByPwsid("IL1830600");
		var camelotObservations = utilityObservationService.getByPwsid("IL1975200");
		var coventryCreekObservations = utilityObservationService.getByPwsid("IL2015160");
		var indianaWaterObservations = utilityObservationService.getByPwsid("IN5245057");
		var greenRidgeObservations = utilityObservationService.getByPwsid("MD0120011");
		var montagueObservations = utilityObservationService.getByPwsid("NJ1914002");
		var springCreekHousingObservations = utilityObservationService.getByPwsid("NV0000036");
		var coldSpringsObservations = utilityObservationService.getByPwsid("NV0000207");
		var calvadaObservations = utilityObservationService.getByPwsid("NV0000408");
		var spanishSpringsObservations = utilityObservationService.getByPwsid("NV0001086");
		var springCreekMobileHomeObservations = utilityObservationService.getByPwsid("NV0005027");
		var abingtonObservations = utilityObservationService.getByPwsid("NC0234191");
		var carolinaTraceObservations = utilityObservationService.getByPwsid("NC0353101");
		var lusiNorthObservations = utilityObservationService.getByPwsid("FL3354883");
		var sanlandoObservations = utilityObservationService.getByPwsid("FL3591121");
		var philaObservations = utilityObservationService.getByPwsid("PA1510001");
		var lancasterObservations = utilityObservationService.getByPwsid("7360058");

		assertThat(goldenHeartObservations).hasSize(4);
		assertThat(collegeUtilitiesObservations).hasSize(4);
		assertThat(bermudaObservations).hasSize(4);
		assertThat(fourLakesObservations).hasSize(4);
		assertThat(lakeSaundersObservations).hasSize(4);
		assertThat(crescentHeightsObservations).hasSize(4);
		assertThat(bearLakeObservations).hasSize(5);
		assertThat(jansenObservations).hasSize(4);
		assertThat(weathersfieldObservations).hasSize(4);
		assertThat(goldenHillsObservations).hasSize(4);
		assertThat(labradorObservations).hasSize(4);
		assertThat(lakeTarponObservations).hasSize(4);
		assertThat(littleWekivaObservations).hasSize(4);
		assertThat(oaklandShoresObservations).hasSize(4);
		assertThat(cypressLakesObservations).hasSize(4);
		assertThat(alpineTerraceObservations).hasSize(5);
		assertThat(galenaObservations).hasSize(4);
		assertThat(appleCanyonObservations).hasSize(5);
		assertThat(oakwoodObservations).hasSize(4);
		assertThat(camelotObservations).hasSize(4);
		assertThat(coventryCreekObservations).hasSize(4);
		assertThat(indianaWaterObservations).hasSize(4);
		assertThat(greenRidgeObservations).hasSize(5);
		assertThat(montagueObservations).hasSize(5);
		assertThat(springCreekHousingObservations).hasSize(4);
		assertThat(coldSpringsObservations).hasSize(4);
		assertThat(calvadaObservations).hasSize(5);
		assertThat(spanishSpringsObservations).hasSize(4);
		assertThat(springCreekMobileHomeObservations).hasSize(4);
		assertThat(abingtonObservations).hasSize(5);
		assertThat(carolinaTraceObservations).hasSize(4);
		assertThat(lusiNorthObservations).hasSize(4);
		assertThat(sanlandoObservations).hasSize(4);
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
		assertThat(jansenObservations)
			.filteredOn(observation -> observation.observationId().equals("jansen-pfoa-average-2023"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("1.3");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("jansen-pfas-2023-report");
			});
		assertThat(alpineTerraceObservations)
			.filteredOn(observation -> observation.observationId().equals("alpine-terrace-pfoa-nd-2023"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("0");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("alpine-terrace-pfas-2023-report");
			});
		assertThat(galenaObservations)
			.filteredOn(observation -> observation.observationId().equals("galena-pfoa-nd-2024"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("0");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("galena-2024-water-quality-report");
			});
		assertThat(bermudaObservations)
			.filteredOn(observation -> observation.observationId().equals("bermuda-water-pfoa-average-2023"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("0.3");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("bermuda-water-pfas-2023-report");
			});
		assertThat(fourLakesObservations)
			.filteredOn(observation -> observation.observationId().equals("four-lakes-pfoa-average-2023"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("1.33");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("four-lakes-pfas-2023-report");
			});
		assertThat(lakeSaundersObservations)
			.filteredOn(observation -> observation.observationId().equals("lake-saunders-pfoa-average-2023"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("8.03");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("lake-saunders-pfas-2023-report");
			});
		assertThat(crescentHeightsObservations)
			.filteredOn(observation -> observation.observationId().equals("crescent-heights-pfoa-nd-2023"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("0");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("crescent-heights-pfas-2023-report");
			});
		assertThat(appleCanyonObservations)
			.filteredOn(observation -> observation.observationId().equals("apple-canyon-pfoa-nd-2023"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("0");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("apple-canyon-pfas-2023-report");
			});
		assertThat(indianaWaterObservations)
			.filteredOn(observation -> observation.observationId().equals("iws-pfoa-nd-2024"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("0");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("iws-2024-water-quality-report");
			});
		assertThat(greenRidgeObservations)
			.filteredOn(observation -> observation.observationId().equals("green-ridge-pfoa-average-2024"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("2.28");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("green-ridge-2024-water-quality-report");
			});
		assertThat(goldenHillsObservations)
			.filteredOn(observation -> observation.observationId().equals("golden-hills-pfos-average-2023"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("2.76");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfos_mcl_2024");
				assertThat(observation.sourceIds()).contains("golden-hills-pfas-2023-report");
			});
		assertThat(labradorObservations)
			.filteredOn(observation -> observation.observationId().equals("labrador-pfos-average-2023"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("1.26");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfos_mcl_2024");
				assertThat(observation.sourceIds()).contains("labrador-pfas-2023-report");
			});
		assertThat(lakeTarponObservations)
			.filteredOn(observation -> observation.observationId().equals("lake-tarpon-pfos-average-2023"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("10.96");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfos_mcl_2024");
				assertThat(observation.sourceIds()).contains("lake-tarpon-pfas-2023-report");
			});
		assertThat(littleWekivaObservations)
			.filteredOn(observation -> observation.observationId().equals("little-wekiva-pfoa-average-2023"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("2.9");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("little-wekiva-pfas-2023-report");
			});
		assertThat(oaklandShoresObservations)
			.filteredOn(observation -> observation.observationId().equals("oakland-shores-pfoa-average-2023"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("11.07");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("oakland-shores-pfas-2023-report");
			});
		assertThat(weathersfieldObservations)
			.filteredOn(observation -> observation.observationId().equals("weathersfield-pfoa-average-2023"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("11");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("weathersfield-pfas-2023-report");
			});
		assertThat(cypressLakesObservations)
			.filteredOn(observation -> observation.observationId().equals("cypress-lakes-pfoa-average-2023"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("0.55");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("cypress-lakes-pfas-2023-report");
			});
		assertThat(montagueObservations)
			.filteredOn(observation -> observation.observationId().equals("montague-pfoa-nd-2023"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("0");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("montague-pfas-2023-report");
			});
		assertThat(coldSpringsObservations)
			.filteredOn(observation -> observation.observationId().equals("cold-springs-pfoa-average-2023"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("1.92");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("cold-springs-pfas-2023-report");
			});
		assertThat(spanishSpringsObservations)
			.filteredOn(observation -> observation.observationId().equals("spanish-springs-pfoa-average-2023"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("3.6");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("spanish-springs-pfas-2023-report");
			});
		assertThat(springCreekMobileHomeObservations)
			.filteredOn(observation -> observation.observationId().equals("spring-creek-mobile-home-pfos-average-2024"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("124000");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfos_mcl_2024");
				assertThat(observation.sourceIds()).contains("spring-creek-mobile-home-2024-water-quality-report");
			});
		assertThat(calvadaObservations)
			.filteredOn(observation -> observation.observationId().equals("calvada-meadows-pfoa-nd-2023"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("0");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("calvada-meadows-pfas-2023-report");
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
		assertThat(lusiNorthObservations)
			.filteredOn(observation -> observation.observationId().equals("lusi-north-pfoa-average-2024"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("4.51");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfoa_mcl_2024");
				assertThat(observation.sourceIds()).contains("lusi-north-umcr5-2024-notice");
			});
		assertThat(sanlandoObservations)
			.filteredOn(observation -> observation.observationId().equals("sanlando-pfos-average-2024"))
			.singleElement()
			.satisfies(observation -> {
				assertThat(observation.value()).isEqualByComparingTo("1.43");
				assertThat(observation.benchmarkId()).isEqualTo("us_pfos_mcl_2024");
				assertThat(observation.sourceIds()).contains("sanlando-umcr5-2024-notice");
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
		var aquaTruClaims = certificationClaimService.getByListingRecordId("AT2000-AT2050");
		var aquaTruCarafeClaims = certificationClaimService.getByListingRecordId("AT100-AT140");
		var aquaTruUnderSinkClaims = certificationClaimService.getByListingRecordId("ATU100");
		var aquaTruModel1Claims = certificationClaimService.getByListingRecordId("ATW-1-FAC|ATW-1-FBAC|ATW-1-FBLAC");
		var aqCwm2Claims = certificationClaimService.getByListingRecordId("AQ-CWM2");
		var aq6200Claims = certificationClaimService.getByListingRecordId("AQ-6200");
		var aq6300Claims = certificationClaimService.getByListingRecordId("AQ-6300");
		var aqRo3Claims = certificationClaimService.getByListingRecordId("AQ-RO-3");
		var zeroWater23CupClaims = certificationClaimService.getByListingRecordId("zerowater-23-cup-dispenser");
		var zeroWaterPitcherClaims = certificationClaimService.getByListingRecordId("zerowater-7-cup-pitcher");
		var zeroWater10CupClaims = certificationClaimService.getByListingRecordId("zerowater-10-cup-pitcher");
		var extremeLifeClaims = certificationClaimService.getByListingRecordId("zerowater-extremelife-faucet-mount");
		var g3p600Claims = certificationClaimService.getByListingRecordId("WD-G3P600");
		var g3p800Claims = certificationClaimService.getByListingRecordId("WD-G3P800");
		var g5p700aClaims = certificationClaimService.getByListingRecordId("WD-G5P700A");
		var k19Claims = certificationClaimService.getByListingRecordId("WD-K19-SFK");
		var x8aClaims = certificationClaimService.getByListingRecordId("WD-X8-A");
		var x12Claims = certificationClaimService.getByListingRecordId("WD-X12");
		var x16Claims = certificationClaimService.getByListingRecordId("WD-X16");

		assertThat(eSpringClaims).hasSize(3);
		assertThat(eSpringClaims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction", "Total PFAS Reduction");
		assertThat(eSpringClaims.get(2).coveredPfas())
			.contains("PFOA", "PFOS", "PFBS");
		assertThat(aquaTruClaims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(aquaTruCarafeClaims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(aquaTruUnderSinkClaims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(aquaTruModel1Claims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(aqCwm2Claims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(aq6200Claims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(aq6300Claims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(aqRo3Claims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(zeroWater23CupClaims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(zeroWaterPitcherClaims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(zeroWater10CupClaims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(extremeLifeClaims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(g3p600Claims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(g3p800Claims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(g5p700aClaims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(k19Claims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(x8aClaims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(x12Claims)
			.extracting(claim -> claim.claimName())
			.containsExactly("PFOA Reduction", "PFOS Reduction");
		assertThat(x16Claims)
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
		var aquaTruCarafe = filterCatalogService.getByProductId("aquatru-carafe").orElseThrow();
		var aquaTruClassic = filterCatalogService.getByProductId("aquatru-classic").orElseThrow();
		var aquaTruUnderSink = filterCatalogService.getByProductId("aquatru-under-sink").orElseThrow();
		var aquaTruModel1 = filterCatalogService.getByProductId("aquatru-model-1").orElseThrow();
		var cleanWaterMachine = filterCatalogService.getByProductId("aquasana-aq-cwm2").orElseThrow();
		var aq6200 = filterCatalogService.getByProductId("aquasana-aq-6200").orElseThrow();
		var aq6300 = filterCatalogService.getByProductId("aquasana-aq-6300").orElseThrow();
		var aq6300m = filterCatalogService.getByProductId("aquasana-aq-6300m").orElseThrow();
		var aqMf1 = filterCatalogService.getByProductId("aquasana-aq-mf-1").orElseThrow();
		var optimH2o = filterCatalogService.getByProductId("aquasana-aq-ro-3").orElseThrow();
		var smartFlow = filterCatalogService.getByProductId("aquasana-aq-sfro2").orElseThrow();
		var zeroWaterPitcher = filterCatalogService.getByProductId("zerowater-7-cup-pitcher").orElseThrow();
		var zeroWater23Cup = filterCatalogService.getByProductId("zerowater-23-cup-dispenser").orElseThrow();
		var zeroWater5Gallon = filterCatalogService.getByProductId("zerowater-5-gallon-cooler").orElseThrow();
		var zeroWater30Cup = filterCatalogService.getByProductId("zerowater-30-cup-dispenser-bundle").orElseThrow();
		var zeroWater10Cup = filterCatalogService.getByProductId("zerowater-10-cup-pitcher").orElseThrow();
		var zeroWaterFaucetMount = filterCatalogService.getByProductId("zerowater-extremelife-faucet-mount").orElseThrow();
		var waterdropG3p600 = filterCatalogService.getByProductId("waterdrop-g3p600").orElseThrow();
		var waterdropG3p800 = filterCatalogService.getByProductId("waterdrop-g3p800").orElseThrow();
		var waterdropG2 = filterCatalogService.getByProductId("waterdrop-g2").orElseThrow();
		var waterdropH9 = filterCatalogService.getByProductId("waterdrop-h9").orElseThrow();
		var waterdropA1 = filterCatalogService.getByProductId("waterdrop-a1").orElseThrow();
		var waterdropA2 = filterCatalogService.getByProductId("waterdrop-a2").orElseThrow();
		var waterdrop10ubPro = filterCatalogService.getByProductId("waterdrop-10ub-pro").orElseThrow();
		var waterdropC1h = filterCatalogService.getByProductId("waterdrop-c1h").orElseThrow();
		var waterdropC1s = filterCatalogService.getByProductId("waterdrop-c1s").orElseThrow();
		var waterdropEd01 = filterCatalogService.getByProductId("waterdrop-ed01").orElseThrow();
		var waterdropG5p500a = filterCatalogService.getByProductId("waterdrop-g5p500a").orElseThrow();
		var waterdropG5p700a = filterCatalogService.getByProductId("waterdrop-g5p700a").orElseThrow();
		var waterdropG5p700 = filterCatalogService.getByProductId("waterdrop-g5p700").orElseThrow();
		var waterdropK19Sfk = filterCatalogService.getByProductId("waterdrop-k19-sfk").orElseThrow();
		var waterdropX10 = filterCatalogService.getByProductId("waterdrop-x10").orElseThrow();
		var waterdropX14 = filterCatalogService.getByProductId("waterdrop-x14").orElseThrow();
		var waterdropX8a = filterCatalogService.getByProductId("waterdrop-x8-a").orElseThrow();
		var waterdropX8Pro = filterCatalogService.getByProductId("waterdrop-x8-pro").orElseThrow();
		var waterdropX12 = filterCatalogService.getByProductId("waterdrop-x12").orElseThrow();
		var waterdropX12Pro = filterCatalogService.getByProductId("waterdrop-x12-pro").orElseThrow();
		var waterdropX16 = filterCatalogService.getByProductId("waterdrop-x16").orElseThrow();
		var waterdropG5p700aPro = filterCatalogService.getByProductId("waterdrop-g5p700a-pro").orElseThrow();

		assertThat(items).hasSize(40);
		assertThat(items)
			.extracting(item -> item.productId())
			.contains(
				"espring-122941",
				"aquatru-carafe",
				"aquatru-classic",
				"aquatru-model-1",
				"aquatru-under-sink",
				"aquasana-aq-cwm2",
				"aquasana-aq-6200",
				"aquasana-aq-6300",
				"aquasana-aq-6300m",
				"aquasana-aq-mf-1",
				"aquasana-aq-ro-3",
				"aquasana-aq-sfro2",
				"zerowater-10-cup-pitcher",
				"zerowater-extremelife-faucet-mount",
				"zerowater-7-cup-pitcher",
				"zerowater-23-cup-dispenser",
				"zerowater-5-gallon-cooler",
				"zerowater-30-cup-dispenser-bundle",
				"waterdrop-g3p600",
				"waterdrop-g3p800",
				"waterdrop-g2",
				"waterdrop-h9",
				"waterdrop-a1",
				"waterdrop-a2",
				"waterdrop-10ub-pro",
				"waterdrop-c1h",
				"waterdrop-c1s",
				"waterdrop-ed01",
				"waterdrop-g5p500a",
				"waterdrop-g5p700a",
				"waterdrop-g5p700",
				"waterdrop-k19-sfk",
				"waterdrop-x10",
				"waterdrop-x14",
				"waterdrop-x8-a",
				"waterdrop-x8-pro",
				"waterdrop-x12",
				"waterdrop-x12-pro",
				"waterdrop-x16",
				"waterdrop-g5p700a-pro"
			);
		assertThat(items.get(0).listingRecordId()).isEqualTo("122941C");
		assertThat(items.get(0).upfrontCostUsd()).isEqualByComparingTo("1299.00");
		assertThat(items.get(0).replacementCostUsd()).isEqualByComparingTo("280.00");
		assertThat(aquaTruCarafe.listingRecordId()).isEqualTo("AT100-AT140");
		assertThat(aquaTruCarafe.upfrontCostUsd()).isEqualByComparingTo("375.00");
		assertThat(aquaTruCarafe.replacementCostUsd()).isNull();
		assertThat(aquaTruCarafe.recurringCostComponents()).hasSize(3);
		assertThat(aquaTruCarafe.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(aquaTruClassic.listingRecordId()).isEqualTo("AT2000-AT2050");
		assertThat(aquaTruClassic.upfrontCostUsd()).isEqualByComparingTo("475.00");
		assertThat(aquaTruClassic.replacementCostUsd()).isNull();
		assertThat(aquaTruClassic.recurringCostComponents()).hasSize(3);
		assertThat(aquaTruClassic.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(aquaTruUnderSink.listingRecordId()).isEqualTo("ATU100");
		assertThat(aquaTruUnderSink.upfrontCostUsd()).isEqualByComparingTo("375.00");
		assertThat(aquaTruUnderSink.replacementCostUsd()).isNull();
		assertThat(aquaTruUnderSink.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(aquaTruModel1.listingRecordId()).isEqualTo("ATW-1-FAC|ATW-1-FBAC|ATW-1-FBLAC");
		assertThat(aquaTruModel1.upfrontCostUsd()).isEqualByComparingTo("1499.00");
		assertThat(aquaTruModel1.replacementCostUsd()).isNull();
		assertThat(aquaTruModel1.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(items.get(0).claimNames())
			.contains("PFOA Reduction", "PFOS Reduction", "Total PFAS Reduction");
		assertThat(aq6200.listingRecordId()).isEqualTo("AQ-6200");
		assertThat(aq6200.upfrontCostUsd()).isEqualByComparingTo("162.49");
		assertThat(aq6200.replacementCostUsd()).isEqualByComparingTo("73.99");
		assertThat(aq6200.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(aq6300.listingRecordId()).isEqualTo("AQ-6300");
		assertThat(aq6300.upfrontCostUsd()).isEqualByComparingTo("174.99");
		assertThat(aq6300.replacementCostUsd()).isEqualByComparingTo("83.99");
		assertThat(aq6300.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(aq6300m.listingRecordId()).isEqualTo("AQ-6300M");
		assertThat(aq6300m.upfrontCostUsd()).isEqualByComparingTo("224.99");
		assertThat(aq6300m.replacementCostUsd()).isEqualByComparingTo("91.99");
		assertThat(aq6300m.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(aqMf1.upfrontCostUsd()).isEqualByComparingTo("124.99");
		assertThat(aqMf1.replacementCostUsd()).isEqualByComparingTo("78.19");
		assertThat(aqMf1.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(cleanWaterMachine.listingRecordId()).isEqualTo("AQ-CWM2");
		assertThat(cleanWaterMachine.upfrontCostUsd()).isEqualByComparingTo("279.99");
		assertThat(cleanWaterMachine.replacementCostUsd()).isEqualByComparingTo("73.49");
		assertThat(cleanWaterMachine.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(optimH2o.listingRecordId()).isEqualTo("AQ-RO-3");
		assertThat(optimH2o.upfrontCostUsd()).isEqualByComparingTo("224.99");
		assertThat(optimH2o.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(smartFlow.listingRecordId()).isEqualTo("AQ-SFRO2");
		assertThat(smartFlow.upfrontCostUsd()).isEqualByComparingTo("224.99");
		assertThat(smartFlow.replacementCostUsd()).isNull();
		assertThat(smartFlow.recurringCostComponents()).hasSize(3);
		assertThat(smartFlow.recurringCostComponents())
			.extracting(component -> component.componentCode())
			.containsExactly("carbon-block-pair", "membrane", "remineralizer");
		assertThat(smartFlow.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(zeroWaterPitcher.upfrontCostUsd()).isEqualByComparingTo("24.99");
		assertThat(zeroWater23Cup.upfrontCostUsd()).isEqualByComparingTo("39.99");
		assertThat(zeroWater5Gallon.upfrontCostUsd()).isEqualByComparingTo("69.99");
		assertThat(zeroWater30Cup.upfrontCostUsd()).isEqualByComparingTo("71.98");
		assertThat(zeroWater10Cup.listingRecordId()).isEqualTo("zerowater-10-cup-pitcher");
		assertThat(zeroWater10Cup.upfrontCostUsd()).isEqualByComparingTo("37.99");
		assertThat(zeroWater10Cup.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(zeroWaterFaucetMount.listingRecordId()).isEqualTo("zerowater-extremelife-faucet-mount");
		assertThat(zeroWaterFaucetMount.recurringCostComponents()).isEmpty();
		assertThat(zeroWaterFaucetMount.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(zeroWaterPitcher.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(zeroWater23Cup.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropG3p600.listingRecordId()).isEqualTo("WD-G3P600");
		assertThat(waterdropG3p600.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropG3p800.listingRecordId()).isEqualTo("WD-G3P800");
		assertThat(waterdropG3p800.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropG2.listingRecordId()).isEqualTo("WD-G2");
		assertThat(waterdropG2.upfrontCostUsd()).isEqualByComparingTo("299.99");
		assertThat(waterdropG2.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropH9.listingRecordId()).isEqualTo("WD-H9");
		assertThat(waterdropH9.upfrontCostUsd()).isEqualByComparingTo("539.00");
		assertThat(waterdropH9.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropA1.listingRecordId()).isEqualTo("WD-A1");
		assertThat(waterdropA1.upfrontCostUsd()).isEqualByComparingTo("649.00");
		assertThat(waterdropA1.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropA2.listingRecordId()).isEqualTo("WD-A2");
		assertThat(waterdropA2.upfrontCostUsd()).isEqualByComparingTo("499.00");
		assertThat(waterdropA2.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdrop10ubPro.listingRecordId()).isEqualTo("WD-10UB-PRO");
		assertThat(waterdrop10ubPro.upfrontCostUsd()).isEqualByComparingTo("69.99");
		assertThat(waterdrop10ubPro.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropC1h.listingRecordId()).isEqualTo("WD-C1H");
		assertThat(waterdropC1h.upfrontCostUsd()).isEqualByComparingTo("299.00");
		assertThat(waterdropC1h.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropC1s.listingRecordId()).isEqualTo("WD-C1S");
		assertThat(waterdropC1s.upfrontCostUsd()).isEqualByComparingTo("249.00");
		assertThat(waterdropC1s.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropEd01.listingRecordId()).isEqualTo("WD-ED01");
		assertThat(waterdropEd01.upfrontCostUsd()).isEqualByComparingTo("49.99");
		assertThat(waterdropEd01.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropG5p500a.listingRecordId()).isEqualTo("WD-G5P500A");
		assertThat(waterdropG5p500a.upfrontCostUsd()).isEqualByComparingTo("259.99");
		assertThat(waterdropG5p500a.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropG5p700a.listingRecordId()).isEqualTo("WD-G5P700A");
		assertThat(waterdropG5p700a.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropG5p700.listingRecordId()).isEqualTo("WD-G5P700");
		assertThat(waterdropG5p700.upfrontCostUsd()).isEqualByComparingTo("349.99");
		assertThat(waterdropG5p700.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropK19Sfk.listingRecordId()).isEqualTo("WD-K19-SFK");
		assertThat(waterdropK19Sfk.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropX10.listingRecordId()).isEqualTo("WD-X10");
		assertThat(waterdropX10.upfrontCostUsd()).isEqualByComparingTo("1099.00");
		assertThat(waterdropX10.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropX14.listingRecordId()).isEqualTo("WD-X14");
		assertThat(waterdropX14.upfrontCostUsd()).isEqualByComparingTo("1799.00");
		assertThat(waterdropX14.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropX8a.listingRecordId()).isEqualTo("WD-X8-A");
		assertThat(waterdropX8a.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropX8Pro.listingRecordId()).isEqualTo("WD-X8-PRO");
		assertThat(waterdropX8Pro.upfrontCostUsd()).isEqualByComparingTo("899.00");
		assertThat(waterdropX8Pro.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropX12.listingRecordId()).isEqualTo("WD-X12");
		assertThat(waterdropX12.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropX12Pro.listingRecordId()).isEqualTo("WD-X12-PRO");
		assertThat(waterdropX12Pro.upfrontCostUsd()).isEqualByComparingTo("1399.00");
		assertThat(waterdropX12Pro.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropX16.listingRecordId()).isEqualTo("WD-X16");
		assertThat(waterdropX16.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
		assertThat(waterdropG5p700aPro.listingRecordId()).isEqualTo("WD-G5P700A-PRO");
		assertThat(waterdropG5p700aPro.upfrontCostUsd()).isEqualByComparingTo("409.99");
		assertThat(waterdropG5p700aPro.claimNames()).contains("PFOA Reduction", "PFOS Reduction");
	}

	@Test
	void guideReferencesResolveToLiveSystemsAndProducts() {
		var guides = guidePageService.getAll();

		assertThat(guides).hasSize(12);
		for (var guide : guides) {
			if (guide.relatedPwsids() != null) {
				for (var pwsid : guide.relatedPwsids()) {
					assertThat(publicWaterSystemService.getByPwsid(pwsid))
						.withFailMessage("Guide %s has unresolved related PWSID %s", guide.slug(), pwsid)
						.isPresent();
				}
			}
			if (guide.relatedProductIds() != null) {
				for (var productId : guide.relatedProductIds()) {
					assertThat(filterCatalogService.getByProductId(productId))
						.withFailMessage("Guide %s has unresolved related product %s", guide.slug(), productId)
						.isPresent();
				}
			}
		}
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
		assertThat(result.initialCost().rangeLowUsd()).isEqualByComparingTo("24.99");
		assertThat(result.initialCost().rangeHighUsd()).isEqualByComparingTo("1799.00");
		assertThat(result.annualCostMaintenance().rangeLowUsd()).isEqualByComparingTo("110.83");
		assertThat(result.annualCostMaintenance().rangeHighUsd()).isEqualByComparingTo("280.00");
		assertThat(result.certificationChecklist()).hasSize(3);
		assertThat(result.bestFitOptions())
			.extracting(option -> option.optionCode())
			.containsExactly("AQUATRU_CARAFE", "AQUASANA_AQ_CWM2", "AQUASANA_AQ_6200");
		assertThat(result.sources())
			.extracting(source -> source.sourceId())
			.contains(
				"pa-pfas-mcl-rule",
				"nsf-espring-listing-053",
				"amway-espring-122941-product",
				"aquatru-carafe-product",
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
		assertThat(report.readyPublicWaterRoutes()).isEqualTo(35);
		assertThat(report.blockedPublicWaterRoutes()).isZero();
		assertThat(report.items())
			.filteredOn(item -> item.routeType().equals("state_guidance"))
			.allSatisfy(item -> assertThat(item.status()).isEqualTo(ExpansionReadinessStatus.READY));
		assertThat(report.items())
			.filteredOn(item -> item.routeType().equals("public_water"))
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
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Official product records for this utility route")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("data-merchant-track=\"true\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Seller choice")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Best for")))
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
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"ready_public_water_routes\":35")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"GA3110075\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"AZ0408063\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"FL3354647\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"FL3354883\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"FL3480255\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"FL3590762\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"FL3590912\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"FL3591121\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"FL6424076\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"FL6535055\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"IL0855050\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"IL0855150\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"IL1830600\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"IL1975200\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"IL2015160\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"IN5245057\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"NV0000036\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"NV0000207\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"NV0000408\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"NV0001086\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_key\":\"NV0005027\"")));
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
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/public-water-system/FL3354647")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/public-water-system/FL3480255")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/public-water-system/FL3590069")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/public-water-system/FL3590762")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/public-water-system/FL3590912")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/public-water-system/FL6424076")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/public-water-system/FL6535055")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/public-water-system/GA3110075")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/public-water-system/NJ1914002")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/public-water-system/IN5245057")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/public-water-system/7360058")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/public-water-system/NC0234191")));
	}

	@Test
	void returnsDerivedRouteManifest() throws Exception {
		mockMvc.perform(get("/internal/derived/route-manifest"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_count\":59")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/AK2310730\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/AK2310900\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/AZ0408063\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/FL3354647\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/FL3354695\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/FL3354883\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/FL3480255\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/FL3590069\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/FL3590615\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/FL3590762\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/FL3590912\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/FL3591121\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/FL3591451\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/FL6424076\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/FL6514842\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/FL6521000\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/FL6535055\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/GA3110075\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/IL0855050\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/IL0855150\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/IL1830600\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/IL1975200\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/IL2015160\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/IN5245057\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/MD0120011\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/NJ1914002\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/NV0000036\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/NV0000207\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/NV0000408\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/NV0001086\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/NV0005027\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/private-well/MI\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/NC0234191\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/public-water/7360058\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/guides/choose-certified-pfas-filter-after-evidence\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/guides/countertop-vs-pitcher-vs-under-sink-for-pfas\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/guides/read-your-ccr\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/guides/how-to-read-a-pfas-utility-notice\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/guides/what-ucmr5-can-and-cannot-tell-you\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/guides/non-detect-vs-below-reference-pfas\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/guides/carbon-vs-ro-for-pfas\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/compare/under-sink-certified-pfas-options\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"primary_path\":\"/compare/pfas-filter-annual-cost-compare\"")));
	}

	@Test
	void returnsDerivedSearchIndexSeed() throws Exception {
		mockMvc.perform(get("/internal/derived/search-index"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_count\":59")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"state_guidance:MI\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:AK2310730\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:AK2310900\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:AZ0408063\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:FL3354647\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:FL3354695\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:FL3354883\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:FL3480255\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:FL3590069\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:FL3590615\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:FL3590762\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:FL3590912\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:FL3591121\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:FL3591451\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:FL6424076\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:FL6514842\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:FL6521000\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:FL6535055\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:GA3110075\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:IL0855050\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:IL0855150\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:IL1830600\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:IL1975200\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:IL2015160\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:IN5245057\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:MD0120011\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:NJ1914002\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:NV0000036\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:NV0000207\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:NV0000408\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:NV0001086\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:NV0005027\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:NC0234191\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"public_water:7360058\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"guide:choose-certified-pfas-filter-after-evidence\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"guide:countertop-vs-pitcher-vs-under-sink-for-pfas\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"guide:read-your-ccr\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"guide:how-to-read-a-pfas-utility-notice\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"guide:what-ucmr5-can-and-cannot-tell-you\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"guide:non-detect-vs-below-reference-pfas\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"guide:carbon-vs-ro-for-pfas\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"compare:under-sink-certified-pfas-options\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"document_id\":\"compare:nsf-53-vs-58-claim-examples\"")));
	}

	@Test
	void returnsDerivedDecisionInputSeed() throws Exception {
		mockMvc.perform(get("/internal/derived/decision-inputs"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_count\":43")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"state_guidance:MI\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"state_code\":\"MI\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"pwsid\":null")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"recommended_route_code\":\"PRIVATE_WELL_TEST_FIRST\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:AK2310730\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:AK2310900\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:AZ0408063\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:FL3354647\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:FL3354695\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:FL3354883\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:FL3480255\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:FL3590069\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:FL3590615\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:FL3590762\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:FL3590912\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:FL3591121\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:FL3591451\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:FL6424076\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:FL6514842\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:FL6521000\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:FL6535055\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:GA3110075\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:IL0855050\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:IL0855150\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:IL1830600\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:IL1975200\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:IL2015160\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:IN5245057\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:MD0120011\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:NJ1914002\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:NV0000036\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:NV0000207\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:NV0000408\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:NV0001086\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"input_id\":\"public_water:NV0005027\"")))
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
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_count\":59")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/AK2310730.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/AK2310900.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/AZ0408063.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/FL3354647.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/FL3354695.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/FL3354883.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/FL3480255.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/FL3590069.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/FL3590615.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/FL3590762.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/FL3590912.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/FL3591121.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/FL3591451.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/FL6424076.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/FL6514842.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/FL6521000.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/FL6535055.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/GA3110075.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/IL0855050.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/IL0855150.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/IL1830600.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/IL1975200.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/IL2015160.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/IN5245057.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/MD0120011.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/NJ1914002.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/NV0000036.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/NV0000207.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/NV0000408.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/NV0001086.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/NV0005027.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/NC0234191.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/public_water/7360058.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/state_guidance/MI.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/guide/choose-certified-pfas-filter-after-evidence.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/guide/countertop-vs-pitcher-vs-under-sink-for-pfas.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/guide/read-your-ccr.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/guide/how-to-read-a-pfas-utility-notice.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/guide/what-ucmr5-can-and-cannot-tell-you.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/guide/non-detect-vs-below-reference-pfas.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/guide/carbon-vs-ro-for-pfas.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/compare/under-sink-certified-pfas-options.json\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"model_path\":\"derived/page_models/compare/nsf-53-vs-58-claim-examples.json\"")));
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
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"item_count\":103")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/checker\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/robots.txt\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/sitemap.xml\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/compare/under-sink-certified-pfas-options\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/compare/nsf-53-vs-58-claim-examples\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/AK2310730\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/AK2310900\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/AZ0408063\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/FL3354647\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/FL3354883\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/FL3480255\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/FL3590069\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/FL3590762\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/FL3590912\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/FL3591121\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/FL6424076\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/FL6535055\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/GA3110075\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/IL0855050\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/IL0855150\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/IL1830600\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/IL1975200\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/IL2015160\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/IN5245057\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/MD0120011\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/NJ1914002\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/NV0000036\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/NV0000207\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/NV0000408\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/NV0001086\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/NV0005027\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/NC0234191\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"path\":\"/public-water-system/7360058\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"output_path\":\"guides/choose-certified-pfas-filter-after-evidence/index.html\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"output_path\":\"guides/countertop-vs-pitcher-vs-under-sink-for-pfas/index.html\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"output_path\":\"guides/read-your-ccr/index.html\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"output_path\":\"guides/how-to-read-a-pfas-utility-notice/index.html\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"output_path\":\"guides/what-ucmr5-can-and-cannot-tell-you/index.html\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"output_path\":\"guides/non-detect-vs-below-reference-pfas/index.html\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"output_path\":\"guides/carbon-vs-ro-for-pfas/index.html\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"output_path\":\"compare/under-sink-certified-pfas-options/index.html\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"output_path\":\"compare/pfas-filter-annual-cost-compare/index.html\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"output_path\":\"css/app.css\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"output_path\":\"js/merchant-tracking.js\"")));
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
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/compare/under-sink-certified-pfas-options</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/compare/pfas-filter-annual-cost-compare</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/guides/choose-certified-pfas-filter-after-evidence</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/guides/countertop-vs-pitcher-vs-under-sink-for-pfas</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/guides/read-your-ccr</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/guides/how-to-read-a-pfas-utility-notice</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/guides/what-ucmr5-can-and-cannot-tell-you</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/guides/non-detect-vs-below-reference-pfas</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/guides/carbon-vs-ro-for-pfas</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/AZ0408063</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/FL3354647</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/FL3354883</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/FL3480255</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/FL3590069</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/FL3590762</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/FL3590912</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/FL3591121</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/FL6424076</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/FL6535055</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/GA3110075</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/IL0855050</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/IL0855150</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/IL1830600</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/IL1975200</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/IL2015160</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/IN5245057</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/NV0000036</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/NV0000207</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/NJ1914002</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/NV0000408</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/NV0001086</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/NV0005027</loc>")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("<loc>https://pfas.example.test/public-water/7360058</loc>")));
	}

	@Test
	void returnsFreshnessQualityReport() throws Exception {
		mockMvc.perform(get("/internal/quality/freshness-report"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"stale_source_count\":0")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"indexable_route_count\":59")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"stale_indexable_route_count\":0")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"low_source_count_route_count\":0")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"unresolved_readiness_route_count\":0")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"noindex_candidate_count\":0")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"stale_sources\":[]")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"route_findings\":[]")));
	}

	@Test
	void rendersUtilityNoticeGuidePage() throws Exception {
		mockMvc.perform(get("/guides/how-to-read-a-pfas-utility-notice"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("A PFAS utility notice is an action document, not a generic scare document")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Live utility examples")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Lake Utility Services North")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Official product records linked to this guide")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Linked certified option lanes")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Primary source ledger")));
	}

	@Test
	void rendersGuidePage() throws Exception {
		mockMvc.perform(get("/guides/public-water-vs-private-well"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Public water vs private well is the first split, not a small detail")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Decision-intent guide")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Routing split")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Use source type as the first decision boundary")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("How this guide was built")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Query cluster")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Live utility examples")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Jansen Water System")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Official product records linked to this guide")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Linked certified option lanes")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Dedicated compare pages")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("/compare/countertop-vs-pitcher-vs-under-sink-compare")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("application/ld+json")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"@type\":\"Article\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Primary source ledger")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("CCR Information for Consumers")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("PFAS in Private Wells")));
	}

	@Test
	void rendersComparePage() throws Exception {
		mockMvc.perform(get("/compare/under-sink-certified-pfas-options"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Under-sink certified PFAS options are strongest when the route already supports point-of-use treatment")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Structured comparison")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Merchant-routing lane")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Live utility examples")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Primary source ledger")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("Seller choice")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("application/ld+json")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"@type\":\"ItemList\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"positiveNotes\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("data-merchant-track=\"true\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("data-route-type=\"compare\"")));
	}

	@Test
	void recordsMerchantClicksAndReturnsReport() throws Exception {
		clearMerchantClickTestData();

		mockMvc.perform(post("/internal/merchant-clicks")
				.contentType(MediaType.APPLICATION_JSON)
				.content("""
					{
					  "productId": "aquasana-aq-6200",
					  "merchant": "Aquasana",
					  "ctaSlot": "guide_product_lane",
					  "sourcePage": "/guides/public-water-vs-private-well",
					  "routeType": "guide",
					  "targetUrl": "https://example.test/product",
					  "pagePath": "/guides/public-water-vs-private-well"
					}
					"""))
			.andExpect(status().isAccepted())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"accepted\":true")));

		mockMvc.perform(get("/internal/merchant-clicks/report"))
			.andExpect(status().isOk())
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"total_count\":1")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"unique_product_count\":1")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"unique_source_page_count\":1")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"key\":\"Aquasana\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"key\":\"aquasana-aq-6200\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"key\":\"/guides/public-water-vs-private-well\"")))
			.andExpect(content().string(org.hamcrest.Matchers.containsString("\"key\":\"guide\"")));
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

	private void clearMerchantClickTestData() throws IOException {
		var root = Path.of("./build/test-merchant-clicks");
		if (!Files.exists(root)) {
			return;
		}
		try (var paths = Files.walk(root)) {
			paths.sorted(Comparator.reverseOrder())
				.forEach(path -> {
					try {
						Files.deleteIfExists(path);
					}
					catch (IOException exception) {
						throw new IllegalStateException("Failed to clear merchant click test data", exception);
					}
				});
		}
	}
}
