package com.example.pfas.state;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

@Service
public class StateGuidanceService {

	private static final Comparator<StateGuidance> STATE_ORDER =
		Comparator.comparing(StateGuidance::stateCode);

	private final StateGuidanceRepository stateGuidanceRepository;
	private volatile List<StateGuidance> cachedGuidance;
	private volatile Map<String, StateGuidance> guidanceIndex;

	public StateGuidanceService(StateGuidanceRepository stateGuidanceRepository) {
		this.stateGuidanceRepository = stateGuidanceRepository;
	}

	public List<StateGuidance> getAll() {
		return snapshot();
	}

	public Optional<StateGuidance> getByStateCode(String stateCode) {
		if (stateCode == null || stateCode.isBlank()) {
			return Optional.empty();
		}
		return Optional.ofNullable(index().get(stateCode.trim().toUpperCase(java.util.Locale.ROOT)));
	}

	public boolean isKnownStateCode(String stateCode) {
		return getByStateCode(stateCode).isPresent();
	}

	private List<StateGuidance> snapshot() {
		var local = cachedGuidance;
		if (local != null) {
			return local;
		}

		synchronized (this) {
			if (cachedGuidance == null) {
				cachedGuidance = stateGuidanceRepository.findAll().stream()
					.sorted(STATE_ORDER)
					.toList();
				guidanceIndex = cachedGuidance.stream()
					.collect(Collectors.toUnmodifiableMap(
						guidance -> guidance.stateCode().toUpperCase(java.util.Locale.ROOT),
						Function.identity(),
						(left, right) -> left
					));
			}
			return cachedGuidance;
		}
	}

	private Map<String, StateGuidance> index() {
		snapshot();
		return guidanceIndex;
	}
}
