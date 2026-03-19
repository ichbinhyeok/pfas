package com.example.pfas.certification;

import java.math.BigDecimal;
import java.util.List;

public record CertificationClaim(
	String certBody,
	String standardCode,
	String listingRecordId,
	String reductionClaim,
	String claimName,
	String claimScope,
	String claimBasisNote,
	List<String> coveredPfas,
	BigDecimal claimLimitPpt,
	String listingDirectoryUrl,
	String effectiveDate,
	String lastVerifiedDate,
	List<String> sourceIds
) {
}
