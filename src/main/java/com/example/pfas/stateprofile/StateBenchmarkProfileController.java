package com.example.pfas.stateprofile;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/internal/state-benchmark-profiles")
public class StateBenchmarkProfileController {

	private final StateBenchmarkProfileService service;

	public StateBenchmarkProfileController(StateBenchmarkProfileService service) {
		this.service = service;
	}

	@GetMapping
	public List<StateBenchmarkProfile> list() {
		return service.getAll();
	}

	@GetMapping("/{stateCode}")
	public StateBenchmarkProfile getOne(@PathVariable String stateCode) {
		return service.getByStateCode(stateCode)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown stateCode: " + stateCode));
	}
}
