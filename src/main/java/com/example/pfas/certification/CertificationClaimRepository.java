package com.example.pfas.certification;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.example.pfas.csv.CsvSupport;
import com.example.pfas.data.PfasDataProperties;

@Repository
public class CertificationClaimRepository {

	private static final String CERTIFICATION_CLAIMS_PATH = "normalized/certification_claims/certification_claims.csv";

	private final Path csvPath;

	public CertificationClaimRepository(PfasDataProperties dataProperties) {
		this.csvPath = Path.of(dataProperties.root(), CERTIFICATION_CLAIMS_PATH).normalize();
	}

	public List<CertificationClaim> findAll() {
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
			throw new IllegalStateException("Failed to read certification claims csv: " + csvPath.toAbsolutePath(), exception);
		}
	}

	public List<CertificationClaim> findByListingRecordId(String listingRecordId) {
		return findAll().stream()
			.filter(claim -> claim.listingRecordId().equalsIgnoreCase(listingRecordId))
			.toList();
	}

	private CertificationClaim parse(String line, Map<String, Integer> headerMap) {
		var values = CsvSupport.split(line);
		return new CertificationClaim(
			CsvSupport.value(values, headerMap, "cert_body"),
			CsvSupport.value(values, headerMap, "standard_code"),
			CsvSupport.value(values, headerMap, "listing_record_id"),
			CsvSupport.value(values, headerMap, "reduction_claim"),
			CsvSupport.value(values, headerMap, "claim_name"),
			CsvSupport.value(values, headerMap, "claim_scope"),
			CsvSupport.value(values, headerMap, "claim_basis_note"),
			CsvSupport.parsePipeSeparatedList(CsvSupport.value(values, headerMap, "covered_pfas")),
			CsvSupport.parseBigDecimal(CsvSupport.value(values, headerMap, "claim_limit_ppt")),
			CsvSupport.value(values, headerMap, "listing_directory_url"),
			CsvSupport.value(values, headerMap, "effective_date"),
			CsvSupport.value(values, headerMap, "last_verified_date"),
			CsvSupport.parsePipeSeparatedList(CsvSupport.value(values, headerMap, "source_ids"))
		);
	}
}
