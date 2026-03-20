package com.example.pfas.quality;

import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Comparator;

import org.springframework.stereotype.Service;

import com.example.pfas.source.SourceDocument;
import com.example.pfas.source.SourceRegistryService;

@Service
public class QualityReportService {

	private static final int SOURCE_STALE_DAYS = 120;

	private final RouteQualityGateService routeQualityGateService;
	private final SourceRegistryService sourceRegistryService;

	public QualityReportService(
		RouteQualityGateService routeQualityGateService,
		SourceRegistryService sourceRegistryService
	) {
		this.routeQualityGateService = routeQualityGateService;
		this.sourceRegistryService = sourceRegistryService;
	}

	public FreshnessQualityReport buildFreshnessReport() {
		var today = LocalDate.now();
		var sourceFindings = sourceRegistryService.getAllDocuments().stream()
			.map(document -> toStaleSourceFinding(document, today))
			.flatMap(java.util.Optional::stream)
			.sorted(Comparator.comparing(FreshnessSourceFinding::sourceId))
			.toList();

		var routeDecisions = routeQualityGateService.getAllDecisions();
		var routeFindings = routeDecisions.stream()
			.filter(decision -> !decision.indexable())
			.map(this::toRouteFinding)
			.sorted(Comparator.comparing(FreshnessRouteFinding::primaryPath))
			.toList();

		var indexableRouteCount = routeDecisions.stream()
			.filter(RouteQualityDecision::indexable)
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

	private FreshnessRouteFinding toRouteFinding(RouteQualityDecision decision) {
		return new FreshnessRouteFinding(
			decision.routeType(),
			decision.routeKey(),
			decision.primaryPath(),
			decision.lastVerifiedDate(),
			decision.sourceCount(),
			decision.resolvedSourceCount(),
			!decision.indexable(),
			decision.blockReasons()
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
}
