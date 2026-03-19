package com.example.pfas.state;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Stream;

import org.springframework.stereotype.Repository;

import com.example.pfas.data.PfasDataProperties;
import com.fasterxml.jackson.databind.ObjectMapper;

@Repository
public class StateGuidanceRepository {

	private static final String STATE_GUIDANCE_PATH = "normalized/state_guidance";

	private final ObjectMapper objectMapper;
	private final Path stateGuidanceDirectory;

	public StateGuidanceRepository(PfasDataProperties dataProperties) {
		this.objectMapper = new ObjectMapper();
		this.stateGuidanceDirectory = Path.of(dataProperties.root(), STATE_GUIDANCE_PATH).normalize();
	}

	public List<StateGuidance> findAll() {
		if (!Files.exists(stateGuidanceDirectory)) {
			return List.of();
		}

		try (Stream<Path> files = Files.list(stateGuidanceDirectory)) {
			return files
				.filter(path -> path.getFileName().toString().endsWith(".json"))
				.sorted(Comparator.comparing(path -> path.getFileName().toString()))
				.map(this::readFile)
				.toList();
		} catch (IOException exception) {
			throw new IllegalStateException("Failed to list state guidance directory: " + stateGuidanceDirectory.toAbsolutePath(), exception);
		}
	}

	public Optional<StateGuidance> findByStateCode(String stateCode) {
		return findAll().stream()
			.filter(guidance -> guidance.stateCode().equalsIgnoreCase(stateCode))
			.findFirst();
	}

	private StateGuidance readFile(Path path) {
		try (InputStream inputStream = Files.newInputStream(path)) {
			return objectMapper.readValue(inputStream, StateGuidance.class);
		} catch (IOException exception) {
			throw new IllegalStateException("Failed to read state guidance file: " + path.toAbsolutePath(), exception);
		}
	}
}
