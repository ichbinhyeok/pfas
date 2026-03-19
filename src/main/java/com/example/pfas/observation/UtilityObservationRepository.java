package com.example.pfas.observation;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.stereotype.Repository;

import com.example.pfas.csv.CsvSupport;
import com.example.pfas.data.PfasDataProperties;

@Repository
public class UtilityObservationRepository {

	private static final String UTILITY_OBSERVATIONS_PATH = "normalized/utility_observations/utility_observations.csv";

	private final Path csvPath;

	public UtilityObservationRepository(PfasDataProperties dataProperties) {
		this.csvPath = Path.of(dataProperties.root(), UTILITY_OBSERVATIONS_PATH).normalize();
	}

	public List<UtilityObservation> findAll() {
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
			throw new IllegalStateException("Failed to read utility observations csv: " + csvPath.toAbsolutePath(), exception);
		}
	}

	public Optional<UtilityObservation> findByObservationId(String observationId) {
		return findAll().stream()
			.filter(observation -> observation.observationId().equalsIgnoreCase(observationId))
			.findFirst();
	}

	public List<UtilityObservation> findByPwsid(String pwsid) {
		return findAll().stream()
			.filter(observation -> observation.pwsid().equalsIgnoreCase(pwsid))
			.toList();
	}

	private UtilityObservation parse(String line, Map<String, Integer> headerMap) {
		var values = CsvSupport.split(line);
		return new UtilityObservation(
			CsvSupport.value(values, headerMap, "observation_id"),
			CsvSupport.value(values, headerMap, "pwsid"),
			CsvSupport.value(values, headerMap, "contaminant_code"),
			CsvSupport.value(values, headerMap, "contaminant_label"),
			CsvSupport.value(values, headerMap, "sample_context"),
			CsvSupport.value(values, headerMap, "period_start"),
			CsvSupport.value(values, headerMap, "period_end"),
			CsvSupport.value(values, headerMap, "sample_date"),
			CsvSupport.parseBigDecimal(CsvSupport.value(values, headerMap, "value")),
			CsvSupport.value(values, headerMap, "unit"),
			CsvSupport.value(values, headerMap, "result_flag"),
			CsvSupport.parseBigDecimal(CsvSupport.value(values, headerMap, "minimum_reporting_level")),
			CsvSupport.value(values, headerMap, "benchmark_type"),
			CsvSupport.parseBigDecimal(CsvSupport.value(values, headerMap, "benchmark_value")),
			CsvSupport.value(values, headerMap, "benchmark_unit"),
			CsvSupport.value(values, headerMap, "benchmark_source_id"),
			CsvSupport.parsePipeSeparatedList(CsvSupport.value(values, headerMap, "source_ids"))
		);
	}
}
