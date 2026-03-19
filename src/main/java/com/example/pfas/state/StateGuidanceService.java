package com.example.pfas.state;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

@Service
public class StateGuidanceService {

	private static final Comparator<StateGuidance> STATE_ORDER =
		Comparator.comparing(StateGuidance::stateCode);

	private final StateGuidanceRepository stateGuidanceRepository;

	public StateGuidanceService(StateGuidanceRepository stateGuidanceRepository) {
		this.stateGuidanceRepository = stateGuidanceRepository;
	}

	public List<StateGuidance> getAll() {
		return stateGuidanceRepository.findAll().stream()
			.sorted(STATE_ORDER)
			.toList();
	}

	public Optional<StateGuidance> getByStateCode(String stateCode) {
		return stateGuidanceRepository.findByStateCode(stateCode);
	}
}
