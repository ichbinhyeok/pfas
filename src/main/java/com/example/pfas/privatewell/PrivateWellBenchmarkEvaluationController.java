package com.example.pfas.privatewell;

import java.math.BigDecimal;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/internal/private-well-benchmark-evaluation")
public class PrivateWellBenchmarkEvaluationController {

	private final PrivateWellBenchmarkEvaluatorService service;

	public PrivateWellBenchmarkEvaluationController(PrivateWellBenchmarkEvaluatorService service) {
		this.service = service;
	}

	@GetMapping("/{stateCode}")
	public PrivateWellBenchmarkEvaluation getOne(
		@PathVariable String stateCode,
		@RequestParam String analyteCode,
		@RequestParam BigDecimal value,
		@RequestParam(defaultValue = "ppt") String unit
	) {
		try {
			return service.evaluate(stateCode, analyteCode, value, unit)
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown stateCode: " + stateCode));
		}
		catch (InvalidPrivateWellMeasurementInputException exception) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, exception.getMessage(), exception);
		}
	}

	@GetMapping("/{stateCode}/batch")
	public PrivateWellBenchmarkBatchEvaluation getBatch(
		@PathVariable String stateCode,
		@RequestParam String batchInput
	) {
		try {
			return service.evaluateBatch(stateCode, batchInput)
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown stateCode: " + stateCode));
		}
		catch (InvalidPrivateWellBatchInputException exception) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, exception.getMessage(), exception);
		}
	}
}
