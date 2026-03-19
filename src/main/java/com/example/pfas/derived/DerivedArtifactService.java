package com.example.pfas.derived;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import org.springframework.stereotype.Service;

import com.example.pfas.data.PfasDataProperties;
import com.example.pfas.readiness.ExpansionReadinessService;
import com.example.pfas.readiness.ExpansionReadinessStatus;
import com.example.pfas.state.StateGuidanceService;
import com.example.pfas.water.PublicWaterSystemService;
import com.example.pfas.web.GuidePage;
import com.example.pfas.web.GuidePageService;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class DerivedArtifactService {

	private static final String SCHEMA_VERSION = "v1";
	private static final ObjectMapper JSON_MAPPER = new ObjectMapper();

	private final ExpansionReadinessService expansionReadinessService;
	private final GuidePageService guidePageService;
	private final StateGuidanceService stateGuidanceService;
	private final PublicWaterSystemService publicWaterSystemService;
	private final PfasDataProperties dataProperties;

	public DerivedArtifactService(
		ExpansionReadinessService expansionReadinessService,
		GuidePageService guidePageService,
		StateGuidanceService stateGuidanceService,
		PublicWaterSystemService publicWaterSystemService,
		PfasDataProperties dataProperties
	) {
		this.expansionReadinessService = expansionReadinessService;
		this.guidePageService = guidePageService;
		this.stateGuidanceService = stateGuidanceService;
		this.publicWaterSystemService = publicWaterSystemService;
		this.dataProperties = dataProperties;
	}

	public RouteManifestFile buildRouteManifest() {
		var generatedAt = OffsetDateTime.now().toString();
		var routes = new ArrayList<RouteManifestRoute>();

		guidePageService.getAll().stream()
			.sorted(Comparator.comparing(GuidePage::slug))
			.map(this::toGuideRoute)
			.forEach(routes::add);

		expansionReadinessService.getReport().items().stream()
			.filter(item -> item.status() == ExpansionReadinessStatus.READY)
			.sorted(Comparator.comparing(item -> item.routeType() + ":" + item.routeKey()))
			.map(this::toReadyRoute)
			.forEach(routes::add);

		return new RouteManifestFile(SCHEMA_VERSION, generatedAt, routes.size(), List.copyOf(routes));
	}

	public SearchIndexSeedFile buildSearchIndexSeed() {
		var generatedAt = OffsetDateTime.now().toString();
		var documents = new ArrayList<SearchIndexSeedDocument>();

		guidePageService.getAll().stream()
			.sorted(Comparator.comparing(GuidePage::slug))
			.map(this::toGuideDocument)
			.forEach(documents::add);

		expansionReadinessService.getReport().items().stream()
			.filter(item -> item.status() == ExpansionReadinessStatus.READY)
			.sorted(Comparator.comparing(item -> item.routeType() + ":" + item.routeKey()))
			.map(this::toReadyDocument)
			.forEach(documents::add);

		return new SearchIndexSeedFile(SCHEMA_VERSION, generatedAt, documents.size(), List.copyOf(documents));
	}

	public DerivedArtifactSyncReport sync() {
		var manifest = buildRouteManifest();
		var searchIndex = buildSearchIndexSeed();
		var root = Path.of(dataProperties.root()).normalize();
		var outputs = new ArrayList<DerivedArtifactOutput>();

		writeJson(root.resolve("derived/page_models/route_manifest.json"), manifest);
		outputs.add(new DerivedArtifactOutput(
			"route_manifest",
			root.resolve("derived/page_models/route_manifest.json").toString().replace('\\', '/'),
			manifest.routeCount()
		));

		writeJson(root.resolve("derived/search_indexes/search_index_seed.json"), searchIndex);
		outputs.add(new DerivedArtifactOutput(
			"search_index_seed",
			root.resolve("derived/search_indexes/search_index_seed.json").toString().replace('\\', '/'),
			searchIndex.documentCount()
		));

		return new DerivedArtifactSyncReport(SCHEMA_VERSION, OffsetDateTime.now().toString(), List.copyOf(outputs));
	}

	private void writeJson(Path path, Object value) {
		try {
			Files.createDirectories(path.getParent());
			JSON_MAPPER.writerWithDefaultPrettyPrinter().writeValue(path.toFile(), value);
		}
		catch (IOException exception) {
			throw new IllegalStateException("Failed to write derived artifact to " + path, exception);
		}
	}

	private RouteManifestRoute toGuideRoute(GuidePage page) {
		return new RouteManifestRoute(
			"guide",
			page.slug(),
			page.title(),
			"guide_page",
			"/guides/" + page.slug(),
			page.primaryHref(),
			null,
			true,
			page.lastVerifiedDate(),
			0,
			"curated_guide",
			guideKeywords(page)
		);
	}

	private SearchIndexSeedDocument toGuideDocument(GuidePage page) {
		return new SearchIndexSeedDocument(
			"guide:" + page.slug(),
			"guide",
			page.slug(),
			"/guides/" + page.slug(),
			page.title(),
			page.lede(),
			page.lastVerifiedDate(),
			true,
			0,
			guideKeywords(page)
		);
	}

	private RouteManifestRoute toReadyRoute(com.example.pfas.readiness.ExpansionReadinessItem item) {
		return switch (item.routeType()) {
			case "state_guidance" -> stateGuidanceService.getByStateCode(item.routeKey())
				.map(guidance -> new RouteManifestRoute(
					item.routeType(),
					item.routeKey(),
					guidance.stateCode() + " private-well PFAS guide",
					"private_well_state_page",
					"/private-well/" + guidance.stateCode(),
					"/private-well-result/" + guidance.stateCode() + "?benchmarkRelation=UNKNOWN&currentFilterStatus=NONE&wholeHouseConsidered=false",
					"/internal/results/private-well/" + guidance.stateCode() + "?benchmarkRelation=UNKNOWN&currentFilterStatus=NONE",
					true,
					item.lastVerifiedDate(),
					item.sourceCount(),
					"state_guidance_ready",
					List.of(guidance.stateCode(), "private well", "PFAS", "certified lab", "state guidance")
				))
				.orElseThrow(() -> new IllegalStateException("Missing state guidance for ready route: " + item.routeKey()));
			case "public_water" -> publicWaterSystemService.getByPwsid(item.routeKey())
				.map(system -> new RouteManifestRoute(
					item.routeType(),
					item.routeKey(),
					system.pwsName() + " PFAS interpretation",
					"public_water_result_page",
					"/public-water/" + system.pwsid(),
					"/public-water-system/" + system.pwsid(),
					"/internal/results/public-water/" + system.pwsid(),
					true,
					item.lastVerifiedDate(),
					item.sourceCount(),
					"public_water_ready",
					List.of(system.pwsName(), system.stateCode(), system.pwsid(), "CCR", "PFAS", "public water")
				))
				.orElseThrow(() -> new IllegalStateException("Missing public water system for ready route: " + item.routeKey()));
			default -> throw new IllegalStateException("Unsupported ready route type: " + item.routeType());
		};
	}

	private SearchIndexSeedDocument toReadyDocument(com.example.pfas.readiness.ExpansionReadinessItem item) {
		return switch (item.routeType()) {
			case "state_guidance" -> stateGuidanceService.getByStateCode(item.routeKey())
				.map(guidance -> new SearchIndexSeedDocument(
					"state_guidance:" + guidance.stateCode(),
					item.routeType(),
					guidance.stateCode(),
					"/private-well/" + guidance.stateCode(),
					guidance.stateCode() + " private-well PFAS guide",
					"State guidance, lab lookup, and reference context for private-well PFAS interpretation in " + guidance.stateCode() + ".",
					item.lastVerifiedDate(),
					true,
					item.sourceCount(),
					List.of(guidance.stateCode(), "private well", "PFAS", "state guidance", "lab lookup")
				))
				.orElseThrow(() -> new IllegalStateException("Missing state guidance for ready document: " + item.routeKey()));
			case "public_water" -> publicWaterSystemService.getByPwsid(item.routeKey())
				.map(system -> new SearchIndexSeedDocument(
					"public_water:" + system.pwsid(),
					item.routeType(),
					system.pwsid(),
					"/public-water/" + system.pwsid(),
					system.pwsName() + " PFAS interpretation",
					"Utility observations, benchmark context, and certified point-of-use next steps for " + system.pwsName() + ".",
					item.lastVerifiedDate(),
					true,
					item.sourceCount(),
					List.of(system.pwsName(), system.stateCode(), system.pwsid(), "public water", "CCR", "PFAS")
				))
				.orElseThrow(() -> new IllegalStateException("Missing public water system for ready document: " + item.routeKey()));
			default -> throw new IllegalStateException("Unsupported ready document type: " + item.routeType());
		};
	}

	private List<String> guideKeywords(GuidePage page) {
		return List.of(page.slug().replace('-', ' '), "PFAS", "water", "decision guide");
	}
}
