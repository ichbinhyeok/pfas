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
public class FilterProductRepository {

	private static final String FILTER_PRODUCTS_PATH = "normalized/filter_products/filter_products.csv";

	private final Path csvPath;

	public FilterProductRepository(PfasDataProperties dataProperties) {
		this.csvPath = dataProperties.rootPath().resolve(FILTER_PRODUCTS_PATH).normalize();
	}

	public List<FilterProduct> findAll() {
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
			throw new IllegalStateException("Failed to read filter products csv: " + csvPath.toAbsolutePath(), exception);
		}
	}

	public Optional<FilterProduct> findByProductId(String productId) {
		return findAll().stream()
			.filter(product -> product.productId().equalsIgnoreCase(productId))
			.findFirst();
	}

	private FilterProduct parse(String line, Map<String, Integer> headerMap) {
		var values = CsvSupport.split(line);
		return new FilterProduct(
			CsvSupport.value(values, headerMap, "product_id"),
			CsvSupport.value(values, headerMap, "brand"),
			CsvSupport.value(values, headerMap, "model"),
			CsvSupport.value(values, headerMap, "filter_type"),
			CsvSupport.value(values, headerMap, "installation_type"),
			CsvSupport.value(values, headerMap, "cert_body"),
			CsvSupport.value(values, headerMap, "standard_code"),
			CsvSupport.value(values, headerMap, "listing_record_id"),
			CsvSupport.value(values, headerMap, "claim_scope"),
			CsvSupport.parsePipeSeparatedList(CsvSupport.value(values, headerMap, "covered_pfas")),
			CsvSupport.value(values, headerMap, "listing_url"),
			CsvSupport.parseInteger(CsvSupport.value(values, headerMap, "replacement_cadence_months")),
			CsvSupport.parseInteger(CsvSupport.value(values, headerMap, "replacement_capacity_gallons")),
			CsvSupport.value(values, headerMap, "last_verified_date"),
			CsvSupport.parsePipeSeparatedList(CsvSupport.value(values, headerMap, "source_ids"))
		);
	}
}
