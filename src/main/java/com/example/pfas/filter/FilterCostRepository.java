package com.example.pfas.filter;

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
public class FilterCostRepository {

	private static final String FILTER_COSTS_PATH = "normalized/cost_models/filter_costs.csv";

	private final Path csvPath;

	public FilterCostRepository(PfasDataProperties dataProperties) {
		this.csvPath = Path.of(dataProperties.root(), FILTER_COSTS_PATH).normalize();
	}

	public List<FilterCost> findAll() {
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
			throw new IllegalStateException("Failed to read filter costs csv: " + csvPath.toAbsolutePath(), exception);
		}
	}

	public Optional<FilterCost> findByProductId(String productId) {
		return findAll().stream()
			.filter(cost -> cost.productId().equalsIgnoreCase(productId))
			.findFirst();
	}

	private FilterCost parse(String line, Map<String, Integer> headerMap) {
		var values = CsvSupport.split(line);
		return new FilterCost(
			CsvSupport.value(values, headerMap, "product_id"),
			CsvSupport.parseBigDecimal(CsvSupport.value(values, headerMap, "upfront_cost_usd")),
			CsvSupport.parseBigDecimal(CsvSupport.value(values, headerMap, "replacement_cost_usd")),
			CsvSupport.parseBigDecimal(CsvSupport.value(values, headerMap, "membrane_cost_usd")),
			CsvSupport.parseBigDecimal(CsvSupport.value(values, headerMap, "service_cost_usd")),
			CsvSupport.parseInteger(CsvSupport.value(values, headerMap, "replacement_cadence_months")),
			CsvSupport.value(values, headerMap, "price_observed_at"),
			CsvSupport.value(values, headerMap, "price_source_url"),
			CsvSupport.value(values, headerMap, "cost_confidence"),
			CsvSupport.parsePipeSeparatedList(CsvSupport.value(values, headerMap, "source_ids"))
		);
	}
}
