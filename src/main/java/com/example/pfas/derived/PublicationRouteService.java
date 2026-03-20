package com.example.pfas.derived;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import org.springframework.stereotype.Service;

import com.example.pfas.readiness.ExpansionReadinessService;
import com.example.pfas.readiness.ExpansionReadinessStatus;
import com.example.pfas.state.StateGuidanceService;
import com.example.pfas.water.PublicWaterSystemService;
import com.example.pfas.web.GuidePage;
import com.example.pfas.web.GuidePageService;

@Service
public class PublicationRouteService {

	private final GuidePageService guidePageService;
	private final ExpansionReadinessService expansionReadinessService;
	private final StateGuidanceService stateGuidanceService;
	private final PublicWaterSystemService publicWaterSystemService;

	public PublicationRouteService(
		GuidePageService guidePageService,
		ExpansionReadinessService expansionReadinessService,
		StateGuidanceService stateGuidanceService,
		PublicWaterSystemService publicWaterSystemService
	) {
		this.guidePageService = guidePageService;
		this.expansionReadinessService = expansionReadinessService;
		this.stateGuidanceService = stateGuidanceService;
		this.publicWaterSystemService = publicWaterSystemService;
	}

	public List<RouteManifestRoute> buildRoutes() {
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

		return List.copyOf(routes);
	}

	private RouteManifestRoute toGuideRoute(GuidePage page) {
		var keywords = new ArrayList<String>();
		if (page.targetQueries() != null) {
			keywords.addAll(page.targetQueries());
		}
		keywords.add(page.slug().replace('-', ' '));
		keywords.add("PFAS");
		keywords.add("water");
		keywords.add("decision guide");

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
			page.sourceIds().size(),
			"curated_guide",
			List.copyOf(keywords)
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
}
