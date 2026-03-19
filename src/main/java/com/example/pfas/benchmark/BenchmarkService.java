package com.example.pfas.benchmark;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

@Service
public class BenchmarkService {

	private static final Comparator<BenchmarkRecord> BENCHMARK_ORDER =
		Comparator.comparing(BenchmarkRecord::jurisdiction)
			.thenComparing(BenchmarkRecord::benchmarkKind)
			.thenComparing(BenchmarkRecord::contaminantCode);

	private final BenchmarkRepository benchmarkRepository;

	public BenchmarkService(BenchmarkRepository benchmarkRepository) {
		this.benchmarkRepository = benchmarkRepository;
	}

	public List<BenchmarkRecord> getAll() {
		return benchmarkRepository.findAll().stream()
			.sorted(BENCHMARK_ORDER)
			.toList();
	}

	public Optional<BenchmarkRecord> getByBenchmarkId(String benchmarkId) {
		return benchmarkRepository.findByBenchmarkId(benchmarkId);
	}
}
