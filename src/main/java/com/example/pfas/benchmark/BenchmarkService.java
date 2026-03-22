package com.example.pfas.benchmark;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

@Service
public class BenchmarkService {

	private static final Comparator<BenchmarkRecord> BENCHMARK_ORDER =
		Comparator.comparing(BenchmarkRecord::jurisdiction)
			.thenComparing(BenchmarkRecord::benchmarkKind)
			.thenComparing(BenchmarkRecord::contaminantCode);

	private final BenchmarkRepository benchmarkRepository;
	private volatile List<BenchmarkRecord> cachedBenchmarks;
	private volatile Map<String, BenchmarkRecord> benchmarkIndex;

	public BenchmarkService(BenchmarkRepository benchmarkRepository) {
		this.benchmarkRepository = benchmarkRepository;
	}

	public List<BenchmarkRecord> getAll() {
		return snapshot();
	}

	public Optional<BenchmarkRecord> getByBenchmarkId(String benchmarkId) {
		if (benchmarkId == null || benchmarkId.isBlank()) {
			return Optional.empty();
		}
		return Optional.ofNullable(index().get(benchmarkId.trim().toUpperCase(java.util.Locale.ROOT)));
	}

	private List<BenchmarkRecord> snapshot() {
		var local = cachedBenchmarks;
		if (local != null) {
			return local;
		}

		synchronized (this) {
			if (cachedBenchmarks == null) {
				cachedBenchmarks = benchmarkRepository.findAll().stream()
					.sorted(BENCHMARK_ORDER)
					.toList();
				benchmarkIndex = cachedBenchmarks.stream()
					.collect(Collectors.toUnmodifiableMap(
						record -> record.benchmarkId().toUpperCase(java.util.Locale.ROOT),
						Function.identity(),
						(left, right) -> left
					));
			}
			return cachedBenchmarks;
		}
	}

	private Map<String, BenchmarkRecord> index() {
		snapshot();
		return benchmarkIndex;
	}
}
