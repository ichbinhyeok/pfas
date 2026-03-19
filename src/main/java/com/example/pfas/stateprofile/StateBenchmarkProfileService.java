package com.example.pfas.stateprofile;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

@Service
public class StateBenchmarkProfileService {

	private static final Comparator<StateBenchmarkProfile> PROFILE_ORDER =
		Comparator.comparing(StateBenchmarkProfile::stateCode);

	private final StateBenchmarkProfileRepository repository;

	public StateBenchmarkProfileService(StateBenchmarkProfileRepository repository) {
		this.repository = repository;
	}

	public List<StateBenchmarkProfile> getAll() {
		return repository.findAll().stream()
			.sorted(PROFILE_ORDER)
			.toList();
	}

	public Optional<StateBenchmarkProfile> getByStateCode(String stateCode) {
		return repository.findByStateCode(stateCode);
	}
}
