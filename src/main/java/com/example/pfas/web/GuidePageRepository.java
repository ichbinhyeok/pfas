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
public class GuidePageRepository {

	private static final String GUIDE_PAGES_PATH = "normalized/guides/guide_pages.json";

	private final ObjectMapper objectMapper;
	private final Path guidePagesFile;

	public GuidePageRepository(PfasDataProperties dataProperties) {
		this.objectMapper = new ObjectMapper();
		this.guidePagesFile = Path.of(dataProperties.root(), GUIDE_PAGES_PATH).normalize();
	}

	public List<GuidePage> findAll() {
		var guidePageFile = readFile();
		return guidePageFile.guides() == null ? List.of() : List.copyOf(guidePageFile.guides());
	}

	private GuidePageFile readFile() {
		if (!Files.exists(guidePagesFile)) {
			throw new IllegalStateException("Missing guide pages file: " + guidePagesFile.toAbsolutePath());
		}

		try (InputStream inputStream = Files.newInputStream(guidePagesFile)) {
			return objectMapper.readValue(inputStream, GuidePageFile.class);
		}
		catch (IOException exception) {
			throw new IllegalStateException("Failed to read guide pages file: " + guidePagesFile.toAbsolutePath(), exception);
		}
	}
}
