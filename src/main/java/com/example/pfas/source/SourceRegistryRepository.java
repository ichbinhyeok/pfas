package com.example.pfas.source;

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
public class SourceRegistryRepository {

	private static final String SOURCE_REGISTRY_PATH = "normalized/source_registry/source_documents.json";

	private final ObjectMapper objectMapper;
	private final Path sourceRegistryFile;

	public SourceRegistryRepository(PfasDataProperties dataProperties) {
		this.objectMapper = new ObjectMapper();
		this.sourceRegistryFile = Path.of(dataProperties.root(), SOURCE_REGISTRY_PATH).normalize();
	}

	public List<SourceDocument> findAll() {
		var registry = readRegistry();
		return registry.documents() == null ? List.of() : List.copyOf(registry.documents());
	}

	public Optional<SourceDocument> findBySourceId(String sourceId) {
		return findAll().stream()
			.filter(document -> document.sourceId().equals(sourceId))
			.findFirst();
	}

	public Optional<String> findGeneratedAt() {
		return Optional.ofNullable(readRegistry().generatedAt());
	}

	private SourceRegistryFile readRegistry() {
		if (!Files.exists(sourceRegistryFile)) {
			throw new IllegalStateException("Missing source registry file: " + sourceRegistryFile.toAbsolutePath());
		}

		try (InputStream inputStream = Files.newInputStream(sourceRegistryFile)) {
			return objectMapper.readValue(inputStream, SourceRegistryFile.class);
		} catch (IOException exception) {
			throw new IllegalStateException("Failed to read source registry file: " + sourceRegistryFile.toAbsolutePath(), exception);
		}
	}
}
