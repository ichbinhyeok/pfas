package com.example.pfas.observation;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

@Service
public class UtilityObservationService {

	private static final Comparator<UtilityObservation> OBSERVATION_ORDER =
		Comparator.comparing(UtilityObservation::pwsid)
			.thenComparing(UtilityObservation::sampleContext)
			.thenComparing(UtilityObservation::contaminantCode);

	private final UtilityObservationRepository utilityObservationRepository;

	public UtilityObservationService(UtilityObservationRepository utilityObservationRepository) {
		this.utilityObservationRepository = utilityObservationRepository;
	}

	public List<UtilityObservation> getAll() {
		return utilityObservationRepository.findAll().stream()
			.sorted(OBSERVATION_ORDER)
			.toList();
	}

	public Optional<UtilityObservation> getByObservationId(String observationId) {
		return utilityObservationRepository.findByObservationId(observationId);
	}

	public List<UtilityObservation> getByPwsid(String pwsid) {
		return utilityObservationRepository.findByPwsid(pwsid).stream()
			.sorted(OBSERVATION_ORDER)
			.toList();
	}
}
