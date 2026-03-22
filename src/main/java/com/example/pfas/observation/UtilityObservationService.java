package com.example.pfas.observation;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

@Service
public class UtilityObservationService {

	private static final Comparator<UtilityObservation> OBSERVATION_ORDER =
		Comparator.comparing(UtilityObservation::pwsid)
			.thenComparing(UtilityObservation::sampleContext)
			.thenComparing(UtilityObservation::contaminantCode);

	private final UtilityObservationRepository utilityObservationRepository;
	private volatile List<UtilityObservation> cachedObservations;
	private volatile Map<String, UtilityObservation> observationIndex;
	private volatile Map<String, List<UtilityObservation>> observationsByPwsid;

	public UtilityObservationService(UtilityObservationRepository utilityObservationRepository) {
		this.utilityObservationRepository = utilityObservationRepository;
	}

	public List<UtilityObservation> getAll() {
		return snapshot();
	}

	public Optional<UtilityObservation> getByObservationId(String observationId) {
		if (observationId == null || observationId.isBlank()) {
			return Optional.empty();
		}
		return Optional.ofNullable(index().get(observationId.trim().toUpperCase(java.util.Locale.ROOT)));
	}

	public List<UtilityObservation> getByPwsid(String pwsid) {
		if (pwsid == null || pwsid.isBlank()) {
			return List.of();
		}
		return byPwsid().getOrDefault(pwsid.trim().toUpperCase(java.util.Locale.ROOT), List.of());
	}

	private List<UtilityObservation> snapshot() {
		var local = cachedObservations;
		if (local != null) {
			return local;
		}

		synchronized (this) {
			if (cachedObservations == null) {
				cachedObservations = utilityObservationRepository.findAll().stream()
					.sorted(OBSERVATION_ORDER)
					.toList();
				observationIndex = cachedObservations.stream()
					.collect(Collectors.toUnmodifiableMap(
						observation -> observation.observationId().toUpperCase(java.util.Locale.ROOT),
						Function.identity(),
						(left, right) -> left
					));
				observationsByPwsid = cachedObservations.stream()
					.collect(Collectors.collectingAndThen(
						Collectors.groupingBy(
							observation -> observation.pwsid().toUpperCase(java.util.Locale.ROOT),
							Collectors.toList()
						),
						grouped -> grouped.entrySet().stream()
							.collect(Collectors.toUnmodifiableMap(
								Map.Entry::getKey,
								entry -> List.copyOf(entry.getValue())
							))
					));
			}
			return cachedObservations;
		}
	}

	private Map<String, UtilityObservation> index() {
		snapshot();
		return observationIndex;
	}

	private Map<String, List<UtilityObservation>> byPwsid() {
		snapshot();
		return observationsByPwsid;
	}
}
