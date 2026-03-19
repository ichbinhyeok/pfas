package com.example.pfas.certification;

import java.util.Comparator;
import java.util.List;

import org.springframework.stereotype.Service;

@Service
public class CertificationClaimService {

	private static final Comparator<CertificationClaim> CLAIM_ORDER =
		Comparator.comparing(CertificationClaim::certBody)
			.thenComparing(CertificationClaim::standardCode)
			.thenComparing(CertificationClaim::listingRecordId)
			.thenComparing(CertificationClaim::claimName);

	private final CertificationClaimRepository certificationClaimRepository;

	public CertificationClaimService(CertificationClaimRepository certificationClaimRepository) {
		this.certificationClaimRepository = certificationClaimRepository;
	}

	public List<CertificationClaim> getAll() {
		return certificationClaimRepository.findAll().stream()
			.sorted(CLAIM_ORDER)
			.toList();
	}

	public List<CertificationClaim> getByListingRecordId(String listingRecordId) {
		return certificationClaimRepository.findByListingRecordId(listingRecordId).stream()
			.sorted(CLAIM_ORDER)
			.toList();
	}
}
