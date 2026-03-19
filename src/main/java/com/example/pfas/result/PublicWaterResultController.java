package com.example.pfas.result;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/internal/results/public-water")
public class PublicWaterResultController {

	private final PublicWaterResultService publicWaterResultService;

	public PublicWaterResultController(PublicWaterResultService publicWaterResultService) {
		this.publicWaterResultService = publicWaterResultService;
	}

	@GetMapping("/{pwsid}")
	public WaterDecisionResult getOne(@PathVariable String pwsid) {
		return publicWaterResultService.getByPwsid(pwsid)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown pwsid: " + pwsid));
	}
}
