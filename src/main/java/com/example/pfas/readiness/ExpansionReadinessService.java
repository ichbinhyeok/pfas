package com.example.pfas.readiness;

import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.example.pfas.benchmark.BenchmarkService;
import com.example.pfas.observation.UtilityObservationService;
import com.example.pfas.source.SourceRegistryService;
import com.example.pfas.state.StateGuidance;
import com.example.pfas.state.StateGuidanceService;
import com.example.pfas.stateprofile.StateBenchmarkProfile;
import com.example.pfas.stateprofile.StateBenchmarkProfileService;
import com.example.pfas.water.PublicWaterSystem;
import com.example.pfas.water.PublicWaterSystemService;

@Service
public class ExpansionReadinessService {

	private final StateGuidanceService stateGuidanceService;
	private final StateBenchmarkProfileService stateBenchmarkProfileService;
	private final PublicWaterSystemService publicWaterSystemService;
	private final UtilityObservationService utilityObservationService;
	private final SourceRegistryService sourceRegistryService;
	private final BenchmarkService benchmarkService;

	public ExpansionReadinessService(
		StateGuidanceService stateGuidanceService,
		StateBenchmarkProfileService stateBenchmarkProfileService,
		PublicWaterSystemService publicWaterSystemService,
		UtilityObservationService utilityObservationService,
		SourceRegistryService sourceRegistryService,
		BenchmarkService benchmarkService
	) {
		this.stateGuidanceService = stateGuidanceService;
		this.stateBenchmarkProfileService = stateBenchmarkProfileService;
		this.publicWaterSystemService = publicWaterSystemService;
		this.utilityObservationService = utilityObservationService;
		this.sourceRegistryService = sourceRegistryService;
		this.benchmarkService = benchmarkService;
	}

	public ExpansionReadinessReport getReport() {
		var items = new ArrayList<ExpansionReadinessItem>();

		stateGuidanceService.getAll().forEach(guidance -> items.add(evaluateStateRoute(guidance)));
		publicWaterSystemService.getAll().forEach(system -> items.add(evaluatePublicWaterRoute(system)));

		var readyStateRoutes = (int) items.stream()
			.filter(item -> item.routeType().equals("state_guidance"))
			.filter(item -> item.status() == ExpansionReadinessStatus.READY)
			.count();
		var blockedStateRoutes = (int) items.stream()
			.filter(item -> item.routeType().equals("state_guidance"))
			.filter(item -> item.status() != ExpansionReadinessStatus.READY)
			.count();
		var readyPublicWaterRoutes = (int) items.stream()
			.filter(item -> item.routeType().equals("public_water"))
			.filter(item -> item.status() == ExpansionReadinessStatus.READY)
			.count();
		var blockedPublicWaterRoutes = (int) items.stream()
			.filter(item -> item.routeType().equals("public_water"))
			.filter(item -> item.status() != ExpansionReadinessStatus.READY)
			.count();

		return new ExpansionReadinessReport(
			"v1",
			OffsetDateTime.now().toString(),
			readyStateRoutes,
			blockedStateRoutes,
			readyPublicWaterRoutes,
			blockedPublicWaterRoutes,
			items
		);
	}

	private ExpansionReadinessItem evaluateStateRoute(StateGuidance guidance) {
		var missingSignals = new ArrayList<String>();
		var profile = stateBenchmarkProfileService.getByStateCode(guidance.stateCode()).orElse(null);
		var resolvedSourceCount = resolvedSources(guidance.sourceIds());

		requirePresent(guidance.privateWellGuidanceUrl(), "missing_private_well_guidance_url", missingSignals);
		requirePresent(guidance.certifiedLabLookupUrl(), "missing_certified_lab_lookup_url", missingSignals);
		requirePresent(guidance.lastVerifiedDate(), "missing_last_verified_date", missingSignals);
		require(guidance.sourceIds() != null && guidance.sourceIds().size() >= 2, "insufficient_source_ids", missingSignals);
		require(resolvedSourceCount == safeSize(guidance.sourceIds()), "unresolved_source_ids", missingSignals);
		require(profile != null, "missing_state_benchmark_profile", missingSignals);
		if (profile != null) {
			requirePresent(profile.lastVerifiedDate(), "missing_profile_last_verified_date", missingSignals);
			require(profile.benchmarks() != null && !profile.benchmarks().isEmpty(), "missing_profile_benchmark_lines", missingSignals);
		}

		return new ExpansionReadinessItem(
			"state_guidance",
			guidance.stateCode(),
			guidance.stateCode() + " private-well route",
			missingSignals.isEmpty() ? ExpansionReadinessStatus.READY : ExpansionReadinessStatus.NEEDS_MORE_EVIDENCE,
			safeSize(guidance.sourceIds()),
			resolvedSourceCount,
			0,
			guidance.lastVerifiedDate(),
			List.copyOf(missingSignals)
		);
	}

	private ExpansionReadinessItem evaluatePublicWaterRoute(PublicWaterSystem system) {
		var missingSignals = new ArrayList<String>();
		var observations = utilityObservationService.getByPwsid(system.pwsid());
		var resolvedSourceCount = resolvedSources(system.sourceIds());

		requirePresent(system.utilityWebsiteUrl(), "missing_utility_website_url", missingSignals);
		requirePresent(system.ccrUrl(), "missing_ccr_url", missingSignals);
		requirePresent(system.pfasNoticeUrl(), "missing_pfas_notice_url", missingSignals);
		requirePresent(system.lastVerifiedDate(), "missing_last_verified_date", missingSignals);
		require(system.sourceIds() != null && system.sourceIds().size() >= 3, "insufficient_source_ids", missingSignals);
		require(resolvedSourceCount == safeSize(system.sourceIds()), "unresolved_source_ids", missingSignals);
		require(!observations.isEmpty(), "missing_utility_observations", missingSignals);
		require(observations.stream().allMatch(observation -> benchmarkService.getByBenchmarkId(observation.benchmarkId()).isPresent()),
			"observation_benchmark_mapping_incomplete",
			missingSignals);

		return new ExpansionReadinessItem(
			"public_water",
			system.pwsid(),
			system.pwsName(),
			missingSignals.isEmpty() ? ExpansionReadinessStatus.READY : ExpansionReadinessStatus.NEEDS_MORE_EVIDENCE,
			safeSize(system.sourceIds()),
			resolvedSourceCount,
			observations.size(),
			system.lastVerifiedDate(),
			List.copyOf(missingSignals)
		);
	}

	private int resolvedSources(List<String> sourceIds) {
		if (sourceIds == null) {
			return 0;
		}

		return (int) sourceIds.stream()
			.filter(sourceId -> sourceRegistryService.getDocument(sourceId).isPresent())
			.count();
	}

	private int safeSize(List<String> values) {
		return values == null ? 0 : values.size();
	}

	private void require(boolean condition, String signal, List<String> missingSignals) {
		if (!condition) {
			missingSignals.add(signal);
		}
	}

	private void requirePresent(String value, String signal, List<String> missingSignals) {
		require(value != null && !value.isBlank(), signal, missingSignals);
	}
}
