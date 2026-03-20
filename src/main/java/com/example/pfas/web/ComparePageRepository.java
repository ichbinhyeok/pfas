package com.example.pfas.web;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.example.pfas.data.PfasDataProperties;
import com.fasterxml.jackson.databind.ObjectMapper;

@Repository
public class ComparePageRepository {

	private static final String COMPARE_PAGES_PATH = "normalized/compare_pages/compare_pages.json";

	private final ObjectMapper objectMapper;
	private final Path comparePagesFile;

	public ComparePageRepository(PfasDataProperties dataProperties) {
		this.objectMapper = new ObjectMapper();
		this.comparePagesFile = Path.of(dataProperties.root(), COMPARE_PAGES_PATH).normalize();
	}

	public List<ComparePage> findAll() {
		var comparePageFile = readFile();
		return comparePageFile.comparePages() == null ? List.of() : List.copyOf(comparePageFile.comparePages());
	}

	private ComparePageFile readFile() {
		if (!Files.exists(comparePagesFile)) {
			throw new IllegalStateException("Missing compare pages file: " + comparePagesFile.toAbsolutePath());
		}

		try (InputStream inputStream = Files.newInputStream(comparePagesFile)) {
			return objectMapper.readValue(inputStream, ComparePageFile.class);
		}
		catch (IOException exception) {
			throw new IllegalStateException("Failed to read compare pages file: " + comparePagesFile.toAbsolutePath(), exception);
		}
	}
}
