package com.example.pfas.benchmark;

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
public class BenchmarkRepository {

	private static final String BENCHMARKS_PATH = "normalized/benchmarks/benchmarks.csv";

	private final Path csvPath;

	public BenchmarkRepository(PfasDataProperties dataProperties) {
		this.csvPath = dataProperties.rootPath().resolve(BENCHMARKS_PATH).normalize();
	}

	public List<BenchmarkRecord> findAll() {
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
			throw new IllegalStateException("Failed to read benchmark registry csv: " + csvPath.toAbsolutePath(), exception);
		}
	}

	public Optional<BenchmarkRecord> findByBenchmarkId(String benchmarkId) {
		return findAll().stream()
			.filter(record -> record.benchmarkId().equalsIgnoreCase(benchmarkId))
			.findFirst();
	}

	private BenchmarkRecord parse(String line, Map<String, Integer> headerMap) {
		var values = CsvSupport.split(line);
		return new BenchmarkRecord(
			CsvSupport.value(values, headerMap, "benchmark_id"),
			CsvSupport.value(values, headerMap, "jurisdiction"),
			CsvSupport.value(values, headerMap, "benchmark_kind"),
			CsvSupport.value(values, headerMap, "contaminant_code"),
			CsvSupport.value(values, headerMap, "benchmark_label"),
			CsvSupport.parseBigDecimal(CsvSupport.value(values, headerMap, "benchmark_value")),
			CsvSupport.value(values, headerMap, "unit"),
			CsvSupport.value(values, headerMap, "comparison_basis"),
			CsvSupport.value(values, headerMap, "reference_status"),
			CsvSupport.value(values, headerMap, "effective_date"),
			CsvSupport.value(values, headerMap, "last_verified_date"),
			CsvSupport.value(values, headerMap, "primary_source_id"),
			CsvSupport.parsePipeSeparatedList(CsvSupport.value(values, headerMap, "source_ids")),
			CsvSupport.value(values, headerMap, "notes")
		);
	}
}
