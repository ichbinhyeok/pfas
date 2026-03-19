package com.example.pfas.benchmark;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/internal/benchmarks")
public class BenchmarkController {

	private final BenchmarkService benchmarkService;

	public BenchmarkController(BenchmarkService benchmarkService) {
		this.benchmarkService = benchmarkService;
	}

	@GetMapping
	public List<BenchmarkRecord> list() {
		return benchmarkService.getAll();
	}

	@GetMapping("/{benchmarkId}")
	public BenchmarkRecord getOne(@PathVariable String benchmarkId) {
		return benchmarkService.getByBenchmarkId(benchmarkId)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown benchmarkId: " + benchmarkId));
	}
}
