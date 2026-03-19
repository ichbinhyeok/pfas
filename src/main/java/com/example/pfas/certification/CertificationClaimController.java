package com.example.pfas.certification;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/internal/certification-claims")
public class CertificationClaimController {

	private final CertificationClaimService certificationClaimService;

	public CertificationClaimController(CertificationClaimService certificationClaimService) {
		this.certificationClaimService = certificationClaimService;
	}

	@GetMapping
	public List<CertificationClaim> list(@RequestParam(required = false) String listingRecordId) {
		if (listingRecordId == null || listingRecordId.isBlank()) {
			return certificationClaimService.getAll();
		}

		return certificationClaimService.getByListingRecordId(listingRecordId);
	}
}
