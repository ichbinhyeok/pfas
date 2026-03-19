package com.example.pfas.decision;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/internal/public-water-decision")
public class PublicWaterDecisionController {

	private final PublicWaterDecisionService publicWaterDecisionService;

	public PublicWaterDecisionController(PublicWaterDecisionService publicWaterDecisionService) {
		this.publicWaterDecisionService = publicWaterDecisionService;
	}

	@GetMapping("/{pwsid}")
	public PublicWaterDecisionContext getOne(@PathVariable String pwsid) {
		return publicWaterDecisionService.getByPwsid(pwsid)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown pwsid: " + pwsid));
	}
}
