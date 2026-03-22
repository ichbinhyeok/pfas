package com.example.pfas.stateprofile;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Repository;

import com.example.pfas.data.PfasDataProperties;
import com.fasterxml.jackson.databind.ObjectMapper;

@Repository
public class StateBenchmarkProfileRepository {

	private static final String STATE_BENCHMARK_PROFILE_PATH = "normalized/state_benchmark_profiles/state_benchmark_profiles.json";

	private final ObjectMapper objectMapper;
	private final Path stateBenchmarkProfileFile;

	public StateBenchmarkProfileRepository(PfasDataProperties dataProperties) {
		this.objectMapper = new ObjectMapper();
		this.stateBenchmarkProfileFile = dataProperties.rootPath().resolve(STATE_BENCHMARK_PROFILE_PATH).normalize();
	}

	public List<StateBenchmarkProfile> findAll() {
		var file = readFile();
		return file.profiles() == null ? List.of() : List.copyOf(file.profiles());
	}

	public Optional<StateBenchmarkProfile> findByStateCode(String stateCode) {
		return findAll().stream()
			.filter(profile -> profile.stateCode().equalsIgnoreCase(stateCode))
			.findFirst();
	}

	private StateBenchmarkProfileFile readFile() {
		if (!Files.exists(stateBenchmarkProfileFile)) {
			throw new IllegalStateException("Missing state benchmark profile file: " + stateBenchmarkProfileFile.toAbsolutePath());
		}

		try (InputStream inputStream = Files.newInputStream(stateBenchmarkProfileFile)) {
			return objectMapper.readValue(inputStream, StateBenchmarkProfileFile.class);
		} catch (IOException exception) {
			throw new IllegalStateException("Failed to read state benchmark profile file: " + stateBenchmarkProfileFile.toAbsolutePath(), exception);
		}
	}
}
