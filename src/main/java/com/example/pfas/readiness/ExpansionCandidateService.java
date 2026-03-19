package com.example.pfas.readiness;

import java.util.List;

import org.springframework.stereotype.Service;

@Service
public class ExpansionCandidateService {

	private final ExpansionReadinessService expansionReadinessService;

	public ExpansionCandidateService(ExpansionReadinessService expansionReadinessService) {
		this.expansionReadinessService = expansionReadinessService;
	}

	public List<ExpansionCandidate> getReadyCandidates() {
		return expansionReadinessService.getReport().items().stream()
			.filter(item -> item.status() == ExpansionReadinessStatus.READY)
			.map(this::toCandidate)
			.toList();
	}

	private ExpansionCandidate toCandidate(ExpansionReadinessItem item) {
		if ("state_guidance".equals(item.routeType())) {
			return new ExpansionCandidate(
				item.routeType(),
				item.routeKey(),
				"/private-well/" + item.routeKey(),
				item.displayLabel(),
				"resolved_sources=" + item.resolvedSourceCount() + ", source_count=" + item.sourceCount()
			);
		}

		return new ExpansionCandidate(
			item.routeType(),
			item.routeKey(),
			"/public-water-system/" + item.routeKey(),
			item.displayLabel(),
			"resolved_sources=" + item.resolvedSourceCount() + ", observations=" + item.observationCount()
		);
	}
}
