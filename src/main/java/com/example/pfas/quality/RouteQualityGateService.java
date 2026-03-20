package com.example.pfas.quality;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.example.pfas.derived.PublicationRouteService;
import com.example.pfas.readiness.ExpansionReadinessItem;
import com.example.pfas.readiness.ExpansionReadinessService;

@Service
public class RouteQualityGateService {

	private static final int ROUTE_STALE_DAYS = 120;
	private static final int MIN_INDEXABLE_ROUTE_SOURCE_COUNT = 3;

	private final PublicationRouteService publicationRouteService;
	private final ExpansionReadinessService expansionReadinessService;

	public RouteQualityGateService(
		PublicationRouteService publicationRouteService,
		ExpansionReadinessService expansionReadinessService
	) {
		this.publicationRouteService = publicationRouteService;
		this.expansionReadinessService = expansionReadinessService;
	}

	public List<RouteQualityDecision> getAllDecisions() {
		var today = LocalDate.now();
		var readinessByRoute = new HashMap<String, ExpansionReadinessItem>();
		expansionReadinessService.getReport().items().forEach(item ->
			readinessByRoute.put(routeKey(item.routeType(), item.routeKey()), item)
		);

		return publicationRouteService.buildRoutes().stream()
			.map(route -> toDecision(route, readinessByRoute.get(routeKey(route.routeType(), route.routeKey())), today))
			.sorted(Comparator.comparing(decision -> decision.routeType() + ":" + decision.routeKey()))
			.toList();
	}

	public Optional<RouteQualityDecision> getDecision(String routeType, String routeKey) {
		return getAllDecisions().stream()
			.filter(decision -> decision.routeType().equals(routeType))
			.filter(decision -> decision.routeKey().equalsIgnoreCase(routeKey))
			.findFirst();
	}

	public Map<String, RouteQualityDecision> decisionIndex() {
		var index = new HashMap<String, RouteQualityDecision>();
		getAllDecisions().forEach(decision -> index.put(routeKey(decision.routeType(), decision.routeKey()), decision));
		return Map.copyOf(index);
	}

	public boolean isIndexable(String routeType, String routeKey) {
		return getDecision(routeType, routeKey)
			.map(RouteQualityDecision::indexable)
			.orElse(true);
	}

	private RouteQualityDecision toDecision(
		com.example.pfas.derived.RouteManifestRoute route,
		ExpansionReadinessItem readinessItem,
		LocalDate today
	) {
		var reasons = new java.util.ArrayList<String>();
		var lastVerified = parseDate(route.lastVerifiedDate());
		if (lastVerified == null) {
			reasons.add("missing_last_verified");
		}
		else if (ChronoUnit.DAYS.between(lastVerified, today) > ROUTE_STALE_DAYS) {
			reasons.add("stale_last_verified");
		}

		if (route.sourceCount() < MIN_INDEXABLE_ROUTE_SOURCE_COUNT) {
			reasons.add("low_source_count");
		}

		Integer resolvedSourceCount = null;
		if (readinessItem != null) {
			resolvedSourceCount = readinessItem.resolvedSourceCount();
			if (readinessItem.resolvedSourceCount() < readinessItem.sourceCount()) {
				reasons.add("unresolved_readiness_sources");
			}
			if (!readinessItem.missingSignals().isEmpty()) {
				reasons.add("readiness_missing_signals");
			}
		}

		return new RouteQualityDecision(
			route.routeType(),
			route.routeKey(),
			route.primaryPath(),
			route.lastVerifiedDate(),
			route.sourceCount(),
			resolvedSourceCount,
			reasons.isEmpty(),
			List.copyOf(reasons)
		);
	}

	private LocalDate parseDate(String raw) {
		if (raw == null || raw.isBlank()) {
			return null;
		}
		try {
			return java.time.OffsetDateTime.parse(raw).toLocalDate();
		}
		catch (Exception ignored) {
			try {
				return LocalDate.parse(raw.length() >= 10 ? raw.substring(0, 10) : raw);
			}
			catch (Exception ignoredAgain) {
				return null;
			}
		}
	}

	private String routeKey(String routeType, String routeKey) {
		return routeType + ":" + routeKey.toUpperCase();
	}
}
