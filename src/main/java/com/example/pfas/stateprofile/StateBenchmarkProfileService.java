package com.example.pfas.stateprofile;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

@Service
public class StateBenchmarkProfileService {

	private static final Comparator<StateBenchmarkProfile> PROFILE_ORDER =
		Comparator.comparing(StateBenchmarkProfile::stateCode);

	private final StateBenchmarkProfileRepository repository;
	private volatile List<StateBenchmarkProfile> cachedProfiles;
	private volatile Map<String, StateBenchmarkProfile> profileIndex;

	public StateBenchmarkProfileService(StateBenchmarkProfileRepository repository) {
		this.repository = repository;
	}

	public List<StateBenchmarkProfile> getAll() {
		return snapshot();
	}

	public Optional<StateBenchmarkProfile> getByStateCode(String stateCode) {
		if (stateCode == null || stateCode.isBlank()) {
			return Optional.empty();
		}
		return Optional.ofNullable(index().get(stateCode.trim().toUpperCase(java.util.Locale.ROOT)));
	}

	private List<StateBenchmarkProfile> snapshot() {
		var local = cachedProfiles;
		if (local != null) {
			return local;
		}

		synchronized (this) {
			if (cachedProfiles == null) {
				cachedProfiles = repository.findAll().stream()
					.sorted(PROFILE_ORDER)
					.toList();
				profileIndex = cachedProfiles.stream()
					.collect(Collectors.toUnmodifiableMap(
						profile -> profile.stateCode().toUpperCase(java.util.Locale.ROOT),
						Function.identity(),
						(left, right) -> left
					));
			}
			return cachedProfiles;
		}
	}

	private Map<String, StateBenchmarkProfile> index() {
		snapshot();
		return profileIndex;
	}
}
