package com.example.pfas.result;

import java.math.BigDecimal;

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
		@RequestParam(required = false) String batchInput,
		@RequestParam(required = false) String analyteCode,
		@RequestParam(required = false) BigDecimal value,
		@RequestParam(defaultValue = "ppt") String unit,
		@RequestParam(defaultValue = "false") boolean wholeHouseConsidered
	) {
		if (batchInput != null && !batchInput.isBlank()) {
			try {
				return privateWellResultService.getFromBatchMeasurement(
					stateCode.toUpperCase(),
					batchInput,
					currentFilterStatus,
					wholeHouseConsidered
				).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown stateCode: " + stateCode));
			}
			catch (com.example.pfas.privatewell.InvalidPrivateWellBatchInputException exception) {
				throw new ResponseStatusException(HttpStatus.BAD_REQUEST, exception.getMessage(), exception);
			}
		}

		if (analyteCode != null && value != null) {
			return privateWellResultService.getFromMeasurement(
				stateCode.toUpperCase(),
				analyteCode,
				value,
				unit,
				currentFilterStatus,
				wholeHouseConsidered
			).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown stateCode: " + stateCode));
		}

		return privateWellResultService.get(
			stateCode.toUpperCase(),
			benchmarkRelation,
			currentFilterStatus,
			wholeHouseConsidered
		).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown stateCode: " + stateCode));
	}
}
