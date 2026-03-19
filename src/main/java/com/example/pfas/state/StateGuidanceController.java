package com.example.pfas.state;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/internal/state-guidance")
public class StateGuidanceController {

	private final StateGuidanceService stateGuidanceService;

	public StateGuidanceController(StateGuidanceService stateGuidanceService) {
		this.stateGuidanceService = stateGuidanceService;
	}

	@GetMapping
	public List<StateGuidance> list() {
		return stateGuidanceService.getAll();
	}

	@GetMapping("/{stateCode}")
	public StateGuidance getOne(@PathVariable String stateCode) {
		return stateGuidanceService.getByStateCode(stateCode)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown state_code: " + stateCode));
	}
}
