package com.example.pfas.quality;

import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.example.pfas.derived.DerivedArtifactService;
import com.example.pfas.readiness.ExpansionReadinessItem;
import com.example.pfas.readiness.ExpansionReadinessService;
import com.example.pfas.source.SourceDocument;
import com.example.pfas.source.SourceRegistryService;

@Service
public class QualityReportService {

	private static final int SOURCE_STALE_DAYS = 120;
	private static final int ROUTE_STALE_DAYS = 120;
	private static final int MIN_INDEXABLE_ROUTE_SOURCE_COUNT = 3;

	private final DerivedArtifactService derivedArtifactService;
	private final ExpansionReadinessService expansionReadinessService;
	private final SourceRegistryService sourceRegistryService;

	public QualityReportService(
		DerivedArtifactService derivedArtifactService,
		ExpansionReadinessService expansionReadinessService,
		SourceRegistryService sourceRegistryService
	) {
		this.derivedArtifactService = derivedArtifactService;
		this.expansionReadinessService = expansionReadinessService;
		this.sourceRegistryService = sourceRegistryService;
	}

	public FreshnessQualityReport buildFreshnessReport() {
		var today = LocalDate.now();
		var sourceFindings = sourceRegistryService.getAllDocuments().stream()
			.map(document -> toStaleSourceFinding(document, today))
			.flatMap(java.util.Optional::stream)
			.sorted(Comparator.comparing(FreshnessSourceFinding::sourceId))
			.toList();

		Map<String, ExpansionReadinessItem> readinessByRoute = new HashMap<>();
		expansionReadinessService.getReport().items().forEach(item ->
			readinessByRoute.put(routeKey(item.routeType(), item.routeKey()), item)
		);

		var routeFindings = derivedArtifactService.buildRouteManifest().routes().stream()
			.filter(route -> route.indexable())
			.map(route -> toRouteFinding(route, readinessByRoute.get(routeKey(route.routeType(), route.routeKey())), today))
			.filter(finding -> !finding.reasons().isEmpty())
			.sorted(Comparator.comparing(FreshnessRouteFinding::primaryPath))
			.toList();

		var indexableRouteCount = derivedArtifactService.buildRouteManifest().routes().stream()
			.filter(route -> route.indexable())
			.count();
		var staleIndexableRouteCount = routeFindings.stream()
			.filter(finding -> finding.reasons().contains("stale_last_verified"))
			.count();
		var lowSourceCountRouteCount = routeFindings.stream()
			.filter(finding -> finding.reasons().contains("low_source_count"))
			.count();
		var unresolvedReadinessRouteCount = routeFindings.stream()
			.filter(finding -> finding.reasons().contains("unresolved_readiness_sources"))
			.count();
		var noindexCandidateCount = routeFindings.stream()
			.filter(FreshnessRouteFinding::noindexCandidate)
			.count();

		return new FreshnessQualityReport(
			"v1",
			OffsetDateTime.now().toString(),
			sourceRegistryService.getAllDocuments().size(),
			sourceFindings.size(),
			(int) indexableRouteCount,
			(int) staleIndexableRouteCount,
			(int) lowSourceCountRouteCount,
			(int) unresolvedReadinessRouteCount,
			(int) noindexCandidateCount,
			sourceFindings,
			routeFindings
		);
	}

	private java.util.Optional<FreshnessSourceFinding> toStaleSourceFinding(SourceDocument document, LocalDate today) {
		var referenceDate = parseDate(document.retrievedAt());
		var reason = "stale_retrieved_at";

		if (referenceDate == null) {
			referenceDate = parseDate(document.lastUpdatedDate());
			reason = "stale_last_updated_date";
		}
		if (referenceDate == null) {
			referenceDate = parseDate(document.effectiveDate());
			reason = "stale_effective_date";
		}
		if (referenceDate == null) {
			referenceDate = parseDate(document.publishedDate());
			reason = "stale_published_date";
		}
		if (referenceDate == null) {
			return java.util.Optional.of(
				new FreshnessSourceFinding(document.sourceId(), document.title(), null, -1, "missing_reference_date")
			);
		}

		var daysSince = ChronoUnit.DAYS.between(referenceDate, today);
		if (daysSince > SOURCE_STALE_DAYS) {
			return java.util.Optional.of(
				new FreshnessSourceFinding(document.sourceId(), document.title(), referenceDate.toString(), daysSince, reason)
			);
		}
		return java.util.Optional.empty();
	}

	private FreshnessRouteFinding toRouteFinding(
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

		return new FreshnessRouteFinding(
			route.routeType(),
			route.routeKey(),
			route.primaryPath(),
			route.lastVerifiedDate(),
			route.sourceCount(),
			resolvedSourceCount,
			!reasons.isEmpty(),
			java.util.List.copyOf(reasons)
		);
	}

	private LocalDate parseDate(String raw) {
		if (raw == null || raw.isBlank()) {
			return null;
		}
		try {
			return OffsetDateTime.parse(raw).toLocalDate();
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
