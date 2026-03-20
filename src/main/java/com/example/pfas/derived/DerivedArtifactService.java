package com.example.pfas.derived;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.example.pfas.checker.ActionCheckerService;
import com.example.pfas.data.PfasDataProperties;
import com.example.pfas.quality.RouteQualityGateService;
import com.example.pfas.readiness.ExpansionReadinessService;
import com.example.pfas.readiness.ExpansionReadinessStatus;
import com.example.pfas.result.PrivateWellResultService;
import com.example.pfas.result.PublicWaterResultService;
import com.example.pfas.state.StateGuidanceService;
import com.example.pfas.stateprofile.StateBenchmarkProfileService;
import com.example.pfas.water.PublicWaterSystemService;
import com.example.pfas.web.ComparePage;
import com.example.pfas.web.ComparePageService;
import com.example.pfas.web.GuidePage;
import com.example.pfas.web.GuidePageService;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class DerivedArtifactService {

	private static final String SCHEMA_VERSION = "v1";
	private static final ObjectMapper JSON_MAPPER = new ObjectMapper();

	private final PublicationRouteService publicationRouteService;
	private final RouteQualityGateService routeQualityGateService;
	private final ExpansionReadinessService expansionReadinessService;
	private final GuidePageService guidePageService;
	private final ComparePageService comparePageService;
	private final StateGuidanceService stateGuidanceService;
	private final StateBenchmarkProfileService stateBenchmarkProfileService;
	private final PublicWaterSystemService publicWaterSystemService;
	private final PublicWaterResultService publicWaterResultService;
	private final PrivateWellResultService privateWellResultService;
	private final ActionCheckerService actionCheckerService;
	private final PfasDataProperties dataProperties;

	public DerivedArtifactService(
		PublicationRouteService publicationRouteService,
		RouteQualityGateService routeQualityGateService,
		ExpansionReadinessService expansionReadinessService,
		GuidePageService guidePageService,
		ComparePageService comparePageService,
		StateGuidanceService stateGuidanceService,
		StateBenchmarkProfileService stateBenchmarkProfileService,
		PublicWaterSystemService publicWaterSystemService,
		PublicWaterResultService publicWaterResultService,
		PrivateWellResultService privateWellResultService,
		ActionCheckerService actionCheckerService,
		PfasDataProperties dataProperties
	) {
		this.publicationRouteService = publicationRouteService;
		this.routeQualityGateService = routeQualityGateService;
		this.expansionReadinessService = expansionReadinessService;
		this.guidePageService = guidePageService;
		this.comparePageService = comparePageService;
		this.stateGuidanceService = stateGuidanceService;
		this.stateBenchmarkProfileService = stateBenchmarkProfileService;
		this.publicWaterSystemService = publicWaterSystemService;
		this.publicWaterResultService = publicWaterResultService;
		this.privateWellResultService = privateWellResultService;
		this.actionCheckerService = actionCheckerService;
		this.dataProperties = dataProperties;
	}

	public RouteManifestFile buildRouteManifest() {
		var generatedAt = OffsetDateTime.now().toString();
		var gateIndex = routeQualityGateService.decisionIndex();
		var routes = publicationRouteService.buildRoutes().stream()
			.map(route -> applyGate(route, gateIndex))
			.toList();
		var indexableRouteCount = (int) routes.stream()
			.filter(RouteManifestRoute::indexable)
			.count();

		return new RouteManifestFile(SCHEMA_VERSION, generatedAt, routes.size(), indexableRouteCount, routes);
	}

	public SearchIndexSeedFile buildSearchIndexSeed() {
		var generatedAt = OffsetDateTime.now().toString();
		var documents = new ArrayList<SearchIndexSeedDocument>();
		var gateIndex = routeQualityGateService.decisionIndex();

		guidePageService.getAll().stream()
			.sorted(Comparator.comparing(GuidePage::slug))
			.map(page -> toGuideDocument(page, routeIndexable(gateIndex, "guide", page.slug())))
			.forEach(documents::add);

		comparePageService.getAll().stream()
			.sorted(Comparator.comparing(ComparePage::slug))
			.map(page -> toCompareDocument(page, routeIndexable(gateIndex, "compare", page.slug())))
			.forEach(documents::add);

		expansionReadinessService.getReport().items().stream()
			.filter(item -> item.status() == ExpansionReadinessStatus.READY)
			.sorted(Comparator.comparing(item -> item.routeType() + ":" + item.routeKey()))
			.map(item -> toReadyDocument(item, routeIndexable(gateIndex, item.routeType(), item.routeKey())))
			.forEach(documents::add);

		return new SearchIndexSeedFile(SCHEMA_VERSION, generatedAt, documents.size(), List.copyOf(documents));
	}

	public DecisionInputSeedFile buildDecisionInputSeed() {
		var generatedAt = OffsetDateTime.now().toString();
		var inputs = expansionReadinessService.getReport().items().stream()
			.filter(item -> item.status() == ExpansionReadinessStatus.READY)
			.sorted(Comparator.comparing(item -> item.routeType() + ":" + item.routeKey()))
			.map(this::toDecisionInputSeed)
			.toList();

		return new DecisionInputSeedFile(SCHEMA_VERSION, generatedAt, inputs.size(), inputs);
	}

	public PageGenerationManifestFile buildPageGenerationManifest() {
		var generatedAt = OffsetDateTime.now().toString();
		var items = buildPageModels().stream()
			.map(model -> new PageGenerationManifestItem(
				model.modelId(),
				model.routeType(),
				model.routeKey(),
				model.templateKind(),
				pageModelPath(model.routeType(), model.routeKey()),
				model.renderPath(),
				model.generationMode(),
				model.indexable(),
				model.lastVerifiedDate(),
				model.sourceCount()
			))
			.sorted(Comparator.comparing(item -> item.routeType() + ":" + item.routeKey()))
			.toList();

		return new PageGenerationManifestFile(SCHEMA_VERSION, generatedAt, items.size(), items);
	}

	public List<GeneratedPageModelFile> buildPageModels() {
		var models = new ArrayList<GeneratedPageModelFile>();
		var gateIndex = routeQualityGateService.decisionIndex();

		guidePageService.getAll().stream()
			.sorted(Comparator.comparing(GuidePage::slug))
			.map(page -> toGuidePageModel(page, routeIndexable(gateIndex, "guide", page.slug())))
			.forEach(models::add);

		comparePageService.getAll().stream()
			.sorted(Comparator.comparing(ComparePage::slug))
			.map(page -> toComparePageModel(page, routeIndexable(gateIndex, "compare", page.slug())))
			.forEach(models::add);

		expansionReadinessService.getReport().items().stream()
			.filter(item -> item.status() == ExpansionReadinessStatus.READY)
			.sorted(Comparator.comparing(item -> item.routeType() + ":" + item.routeKey()))
			.map(item -> toReadyPageModel(item, routeIndexable(gateIndex, item.routeType(), item.routeKey())))
			.forEach(models::add);

		return List.copyOf(models);
	}

	public GeneratedPageModelFile buildPageModel(String routeType, String routeKey) {
		var gateIndex = routeQualityGateService.decisionIndex();
		if ("guide".equals(routeType)) {
			return guidePageService.getBySlug(routeKey)
				.map(page -> toGuidePageModel(page, routeIndexable(gateIndex, "guide", page.slug())))
				.orElseThrow(() -> new IllegalStateException("Unknown guide page model: " + routeKey));
		}
		if ("compare".equals(routeType)) {
			return comparePageService.getBySlug(routeKey)
				.map(page -> toComparePageModel(page, routeIndexable(gateIndex, "compare", page.slug())))
				.orElseThrow(() -> new IllegalStateException("Unknown compare page model: " + routeKey));
		}

		return expansionReadinessService.getReport().items().stream()
			.filter(item -> item.status() == ExpansionReadinessStatus.READY)
			.filter(item -> item.routeType().equals(routeType))
			.filter(item -> item.routeKey().equalsIgnoreCase(routeKey))
			.findFirst()
			.map(item -> toReadyPageModel(item, routeIndexable(gateIndex, item.routeType(), item.routeKey())))
			.orElseThrow(() -> new IllegalStateException("Unknown derived page model: " + routeType + ":" + routeKey));
	}

	public DerivedArtifactSyncReport sync() {
		var manifest = buildRouteManifest();
		var searchIndex = buildSearchIndexSeed();
		var decisionInputs = buildDecisionInputSeed();
		var pageGenerationManifest = buildPageGenerationManifest();
		var pageModels = buildPageModels();
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

		writeJson(root.resolve("derived/decision_inputs/decision_input_seed.json"), decisionInputs);
		outputs.add(new DerivedArtifactOutput(
			"decision_input_seed",
			root.resolve("derived/decision_inputs/decision_input_seed.json").toString().replace('\\', '/'),
			decisionInputs.inputCount()
		));

		writeJson(root.resolve("derived/page_models/page_generation_manifest.json"), pageGenerationManifest);
		outputs.add(new DerivedArtifactOutput(
			"page_generation_manifest",
			root.resolve("derived/page_models/page_generation_manifest.json").toString().replace('\\', '/'),
			pageGenerationManifest.modelCount()
		));

		pageModels.forEach(model -> writeJson(root.resolve(pageModelPath(model.routeType(), model.routeKey())), model));
		outputs.add(new DerivedArtifactOutput(
			"page_models",
			root.resolve("derived/page_models").toString().replace('\\', '/'),
			pageModels.size()
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

	private SearchIndexSeedDocument toGuideDocument(GuidePage page, boolean indexable) {
		return new SearchIndexSeedDocument(
			"guide:" + page.slug(),
			"guide",
			page.slug(),
			"/guides/" + page.slug(),
			page.title(),
			page.lede() + " " + page.nextActionSummary(),
			page.lastVerifiedDate(),
			indexable,
			page.sourceIds().size(),
			guideKeywords(page)
		);
	}

	private SearchIndexSeedDocument toCompareDocument(ComparePage page, boolean indexable) {
		return new SearchIndexSeedDocument(
			"compare:" + page.slug(),
			"compare",
			page.slug(),
			"/compare/" + page.slug(),
			page.title(),
			page.lede() + " " + page.nextActionSummary(),
			page.lastVerifiedDate(),
			indexable,
			page.sourceIds().size(),
			compareKeywords(page)
		);
	}

	private SearchIndexSeedDocument toReadyDocument(com.example.pfas.readiness.ExpansionReadinessItem item, boolean indexable) {
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
					indexable,
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
					indexable,
					item.sourceCount(),
					List.of(system.pwsName(), system.stateCode(), system.pwsid(), "public water", "CCR", "PFAS")
				))
				.orElseThrow(() -> new IllegalStateException("Missing public water system for ready document: " + item.routeKey()));
			default -> throw new IllegalStateException("Unsupported ready document type: " + item.routeType());
		};
	}

	private DecisionInputSeed toDecisionInputSeed(com.example.pfas.readiness.ExpansionReadinessItem item) {
		return switch (item.routeType()) {
			case "state_guidance" -> {
				var selection = actionCheckerService.normalize(
					"private_well",
					"none",
					"none",
					"unknown",
					"none",
					"none",
					false,
					item.routeKey(),
					null
				);
				var recommendation = actionCheckerService.evaluate(selection);
				yield new DecisionInputSeed(
					"state_guidance:" + item.routeKey(),
					item.routeType(),
					item.routeKey(),
					selection.waterSource().name(),
					selection.directData().name(),
					selection.indirectData().name(),
					selection.benchmarkRelation().name(),
					selection.currentFilterStatus().name(),
					selection.wholeHouseConsidered(),
					selection.stateCode(),
					selection.pwsid(),
					recommendation.routeCode().name(),
					recommendation.primaryHref(),
					recommendation.secondaryHref(),
					recommendation.summary()
				);
			}
			case "public_water" -> {
				var result = publicWaterResultService.getByPwsid(item.routeKey())
					.orElseThrow(() -> new IllegalStateException("Missing public water result for ready route: " + item.routeKey()));
				var selection = actionCheckerService.normalize(
					"public_water",
					"utility_document",
					"none",
					result.meta().benchmarkRelation(),
					"none",
					"none",
					false,
					null,
					item.routeKey()
				);
				var recommendation = actionCheckerService.evaluate(selection);
				yield new DecisionInputSeed(
					"public_water:" + item.routeKey(),
					item.routeType(),
					item.routeKey(),
					selection.waterSource().name(),
					selection.directData().name(),
					selection.indirectData().name(),
					selection.benchmarkRelation().name(),
					selection.currentFilterStatus().name(),
					selection.wholeHouseConsidered(),
					selection.stateCode(),
					selection.pwsid(),
					recommendation.routeCode().name(),
					recommendation.primaryHref(),
					recommendation.secondaryHref(),
					recommendation.summary()
				);
			}
			default -> throw new IllegalStateException("Unsupported decision input route type: " + item.routeType());
		};
	}

	private GeneratedPageModelFile toGuidePageModel(GuidePage page, boolean indexable) {
		return new GeneratedPageModelFile(
			SCHEMA_VERSION,
			OffsetDateTime.now().toString(),
			"guide:" + page.slug(),
			"guide",
			page.slug(),
			"guide_page",
			"/guides/" + page.slug(),
			"static_file_seed",
			indexable,
			page.lastVerifiedDate(),
			page.sourceIds().size(),
			new GuidePageModelPayload(page)
		);
	}

	private GeneratedPageModelFile toComparePageModel(ComparePage page, boolean indexable) {
		return new GeneratedPageModelFile(
			SCHEMA_VERSION,
			OffsetDateTime.now().toString(),
			"compare:" + page.slug(),
			"compare",
			page.slug(),
			"compare_page",
			"/compare/" + page.slug(),
			"static_file_seed",
			indexable,
			page.lastVerifiedDate(),
			page.sourceIds().size(),
			new ComparePageModelPayload(page)
		);
	}

	private GeneratedPageModelFile toReadyPageModel(com.example.pfas.readiness.ExpansionReadinessItem item, boolean indexable) {
		return switch (item.routeType()) {
			case "state_guidance" -> stateGuidanceService.getByStateCode(item.routeKey())
				.map(guidance -> new GeneratedPageModelFile(
					SCHEMA_VERSION,
					OffsetDateTime.now().toString(),
					"state_guidance:" + guidance.stateCode(),
					item.routeType(),
					guidance.stateCode(),
					"private_well_state_page",
					"/private-well/" + guidance.stateCode(),
					"static_file_seed",
					indexable,
					item.lastVerifiedDate(),
					item.sourceCount(),
					new StateGuidePageModelPayload(
						guidance,
						stateBenchmarkProfileService.getByStateCode(guidance.stateCode()).orElse(null),
						toDecisionInputSeed(item),
						"/private-well-result/" + guidance.stateCode() + "?benchmarkRelation=UNKNOWN&currentFilterStatus=NONE&wholeHouseConsidered=false"
					)
				))
				.orElseThrow(() -> new IllegalStateException("Missing state guidance for page model: " + item.routeKey()));
			case "public_water" -> publicWaterSystemService.getByPwsid(item.routeKey())
				.flatMap(system -> publicWaterResultService.getByPwsid(system.pwsid())
					.map(result -> new GeneratedPageModelFile(
						SCHEMA_VERSION,
						OffsetDateTime.now().toString(),
						"public_water:" + system.pwsid(),
						item.routeType(),
						system.pwsid(),
						"public_water_result_page",
						"/public-water/" + system.pwsid(),
						"static_file_seed",
						indexable,
						item.lastVerifiedDate(),
						item.sourceCount(),
						new PublicWaterPageModelPayload(
							system,
							result,
							toDecisionInputSeed(item),
							"/public-water-system/" + system.pwsid()
						)
					)))
				.orElseThrow(() -> new IllegalStateException("Missing public water model inputs for: " + item.routeKey()));
			default -> throw new IllegalStateException("Unsupported page model route type: " + item.routeType());
		};
	}

	private String pageModelPath(String routeType, String routeKey) {
		return "derived/page_models/" + routeType + "/" + routeKey + ".json";
	}

	private List<String> guideKeywords(GuidePage page) {
		var keywords = new ArrayList<String>();
		if (page.targetQueries() != null) {
			keywords.addAll(page.targetQueries());
		}
		keywords.add(page.slug().replace('-', ' '));
		keywords.add("PFAS");
		keywords.add("water");
		keywords.add("decision guide");
		return List.copyOf(keywords);
	}

	private List<String> compareKeywords(ComparePage page) {
		var keywords = new ArrayList<String>();
		if (page.targetQueries() != null) {
			keywords.addAll(page.targetQueries());
		}
		keywords.add(page.slug().replace('-', ' '));
		keywords.add("PFAS");
		keywords.add("comparison");
		keywords.add("certified options");
		return List.copyOf(keywords);
	}

	private RouteManifestRoute applyGate(RouteManifestRoute route, Map<String, com.example.pfas.quality.RouteQualityDecision> gateIndex) {
		return new RouteManifestRoute(
			route.routeType(),
			route.routeKey(),
			route.displayLabel(),
			route.templateKind(),
			route.primaryPath(),
			route.supportingPath(),
			route.apiPath(),
			routeIndexable(gateIndex, route.routeType(), route.routeKey()),
			route.lastVerifiedDate(),
			route.sourceCount(),
			route.readinessBasis(),
			route.keywords()
		);
	}

	private boolean routeIndexable(Map<String, com.example.pfas.quality.RouteQualityDecision> gateIndex, String routeType, String routeKey) {
		var decision = gateIndex.get((routeType + ":" + routeKey).toUpperCase());
		return decision == null || decision.indexable();
	}
}
