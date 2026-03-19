package com.example.pfas.result;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.example.pfas.checker.ActionBenchmarkRelation;
import com.example.pfas.checker.ActionCurrentFilterStatus;

@RestController
@RequestMapping("/internal/results/private-well")
public class PrivateWellResultController {

	private final PrivateWellResultService privateWellResultService;

	public PrivateWellResultController(PrivateWellResultService privateWellResultService) {
		this.privateWellResultService = privateWellResultService;
	}

	@GetMapping("/{stateCode}")
	public WaterDecisionResult getOne(
		@PathVariable String stateCode,
		@RequestParam(defaultValue = "UNKNOWN") ActionBenchmarkRelation benchmarkRelation,
		@RequestParam(defaultValue = "NONE") ActionCurrentFilterStatus currentFilterStatus,
		@RequestParam(defaultValue = "false") boolean wholeHouseConsidered
	) {
		return privateWellResultService.get(
			stateCode.toUpperCase(),
			benchmarkRelation,
			currentFilterStatus,
			wholeHouseConsidered
		).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown stateCode: " + stateCode));
	}
}
