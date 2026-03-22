package com.example.pfas.filter;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.example.pfas.csv.CsvSupport;
import com.example.pfas.data.PfasDataProperties;

@Repository
public class FilterCostComponentRepository {

	private static final String FILTER_COST_COMPONENTS_PATH = "normalized/cost_models/filter_cost_components.csv";

	private final Path csvPath;

	public FilterCostComponentRepository(PfasDataProperties dataProperties) {
		this.csvPath = dataProperties.rootPath().resolve(FILTER_COST_COMPONENTS_PATH).normalize();
	}

	public List<RecurringCostComponent> findAll() {
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
		}
		catch (IOException exception) {
			throw new IllegalStateException("Failed to read filter cost components csv: " + csvPath.toAbsolutePath(), exception);
		}
	}

	public List<RecurringCostComponent> findByProductId(String productId) {
		return findAll().stream()
			.filter(component -> component.productId().equalsIgnoreCase(productId))
			.toList();
	}

	private RecurringCostComponent parse(String line, Map<String, Integer> headerMap) {
		var values = CsvSupport.split(line);
		return new RecurringCostComponent(
			CsvSupport.value(values, headerMap, "product_id"),
			CsvSupport.value(values, headerMap, "component_code"),
			CsvSupport.value(values, headerMap, "component_label"),
			CsvSupport.value(values, headerMap, "component_type"),
			CsvSupport.parseBigDecimal(CsvSupport.value(values, headerMap, "component_cost_usd")),
			CsvSupport.parseInteger(CsvSupport.value(values, headerMap, "component_cadence_months")),
			CsvSupport.value(values, headerMap, "price_observed_at"),
			CsvSupport.value(values, headerMap, "price_source_url"),
			CsvSupport.parsePipeSeparatedList(CsvSupport.value(values, headerMap, "source_ids"))
		);
	}
}
