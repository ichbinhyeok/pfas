package com.example.pfas.water;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Repository;

import com.example.pfas.csv.CsvSupport;
import com.example.pfas.data.PfasDataProperties;

@Repository
public class PublicWaterSystemRepository {

	private static final String PUBLIC_WATER_SYSTEMS_PATH = "normalized/public_water_systems/public_water_systems.csv";

	private final Path csvPath;

	public PublicWaterSystemRepository(PfasDataProperties dataProperties) {
		this.csvPath = Path.of(dataProperties.root(), PUBLIC_WATER_SYSTEMS_PATH).normalize();
	}

	public List<PublicWaterSystem> findAll() {
		if (!Files.exists(csvPath)) {
			return List.of();
		}

		try {
			var lines = Files.readAllLines(csvPath);
			if (lines.size() <= 1) {
				return List.of();
			}

			var headerMap = CsvSupport.headerMap(lines.get(0));
			return lines.stream()
				.skip(1)
				.filter(line -> !line.isBlank())
				.map(line -> parse(line, headerMap))
				.toList();
		} catch (IOException exception) {
			throw new IllegalStateException("Failed to read public water systems csv: " + csvPath.toAbsolutePath(), exception);
		}
	}

	public Optional<PublicWaterSystem> findByPwsid(String pwsid) {
		return findAll().stream()
			.filter(system -> system.pwsid().equalsIgnoreCase(pwsid))
			.findFirst();
	}

	private PublicWaterSystem parse(String line, java.util.Map<String, Integer> headerMap) {
		var values = CsvSupport.split(line);
		return new PublicWaterSystem(
			CsvSupport.value(values, headerMap, "pwsid"),
			CsvSupport.value(values, headerMap, "pws_name"),
			CsvSupport.value(values, headerMap, "state_code"),
			CsvSupport.value(values, headerMap, "system_type"),
			CsvSupport.value(values, headerMap, "population_served"),
			CsvSupport.value(values, headerMap, "source_water_type"),
			CsvSupport.value(values, headerMap, "utility_website_url"),
			CsvSupport.value(values, headerMap, "ccr_url"),
			CsvSupport.value(values, headerMap, "pfas_notice_url"),
			CsvSupport.value(values, headerMap, "service_area_notes"),
			CsvSupport.value(values, headerMap, "last_verified_date"),
			CsvSupport.parsePipeSeparatedList(CsvSupport.value(values, headerMap, "source_ids"))
		);
	}
}
