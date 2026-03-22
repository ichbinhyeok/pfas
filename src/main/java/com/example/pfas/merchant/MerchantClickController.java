package com.example.pfas.merchant;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
public class MerchantClickController {

	private final MerchantClickService merchantClickService;

	public MerchantClickController(MerchantClickService merchantClickService) {
		this.merchantClickService = merchantClickService;
	}

	@PostMapping(
		value = {"/merchant-clicks", "/internal/merchant-clicks"},
		consumes = MediaType.APPLICATION_JSON_VALUE,
		produces = MediaType.APPLICATION_JSON_VALUE
	)
	public ResponseEntity<MerchantClickAccepted> record(
		@RequestBody MerchantClickPayload payload,
		@RequestHeader(value = "User-Agent", required = false) String userAgent
	) {
		try {
			return ResponseEntity.status(HttpStatus.ACCEPTED).body(merchantClickService.recordClick(payload, userAgent));
		}
		catch (InvalidMerchantClickPayloadException exception) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, exception.getMessage(), exception);
		}
	}

	@GetMapping(value = "/internal/merchant-clicks/report", produces = MediaType.APPLICATION_JSON_VALUE)
	public MerchantClickReport report() {
		return merchantClickService.getReport();
	}
}
