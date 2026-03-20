package com.example.pfas.merchant;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/internal/merchant-clicks")
public class MerchantClickController {

	private final MerchantClickService merchantClickService;

	public MerchantClickController(MerchantClickService merchantClickService) {
		this.merchantClickService = merchantClickService;
	}

	@PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<MerchantClickAccepted> record(
		@RequestBody MerchantClickPayload payload,
		@RequestHeader(value = "User-Agent", required = false) String userAgent
	) {
		return ResponseEntity.status(HttpStatus.ACCEPTED).body(merchantClickService.recordClick(payload, userAgent));
	}

	@GetMapping(value = "/report", produces = MediaType.APPLICATION_JSON_VALUE)
	public MerchantClickReport report() {
		return merchantClickService.getReport();
	}
}
