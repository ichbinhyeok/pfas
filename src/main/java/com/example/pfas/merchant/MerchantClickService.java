package com.example.pfas.merchant;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.time.OffsetDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class MerchantClickService {

	private static final ObjectMapper JSON_MAPPER = new ObjectMapper();

	private final Path eventFile;

	public MerchantClickService(PfasMerchantClickProperties properties) {
		var configuredRoot = properties.root();
		var root = configuredRoot == null || configuredRoot.isBlank()
			? Path.of("./build/merchant-clicks")
			: Path.of(configuredRoot);
		this.eventFile = root.normalize().resolve("events.ndjson");
	}

	public synchronized MerchantClickAccepted recordClick(MerchantClickPayload payload, String userAgent) {
		var event = new MerchantClickEvent(
			OffsetDateTime.now().toString(),
			nullToBlank(payload.productId()),
			nullToBlank(payload.merchant()),
			nullToBlank(payload.ctaSlot()),
			nullToBlank(payload.sourcePage()),
			nullToBlank(payload.routeType()),
			nullToBlank(payload.routeCode()),
			nullToBlank(payload.benchmarkRelation()),
			nullToBlank(payload.unlockState()),
			nullToBlank(payload.nextActionCode()),
			nullToBlank(payload.targetUrl()),
			nullToBlank(payload.pagePath()),
			nullToBlank(userAgent)
		);
		append(event);
		return new MerchantClickAccepted(true, event.recordedAt());
	}

	public synchronized MerchantClickReport getReport() {
		var events = readEvents();
		return new MerchantClickReport(
			OffsetDateTime.now().toString(),
			events.size(),
			uniqueCount(events, MerchantClickEvent::productId),
			uniqueCount(events, MerchantClickEvent::sourcePage),
			counts(events, MerchantClickEvent::merchant),
			counts(events, MerchantClickEvent::productId),
			counts(events, MerchantClickEvent::sourcePage),
			counts(events, MerchantClickEvent::routeType),
			counts(events, MerchantClickEvent::routeCode),
			counts(events, MerchantClickEvent::unlockState),
			events.stream()
				.sorted(Comparator.comparing(MerchantClickEvent::recordedAt).reversed())
				.limit(20)
				.toList()
		);
	}

	private void append(MerchantClickEvent event) {
		try {
			Files.createDirectories(eventFile.getParent());
			Files.writeString(
				eventFile,
				JSON_MAPPER.writeValueAsString(event) + System.lineSeparator(),
				StandardOpenOption.CREATE,
				StandardOpenOption.APPEND
			);
		}
		catch (IOException exception) {
			throw new IllegalStateException("Failed to append merchant click event", exception);
		}
	}

	private List<MerchantClickEvent> readEvents() {
		if (!Files.exists(eventFile)) {
			return List.of();
		}
		try {
			return Files.readAllLines(eventFile).stream()
				.filter(line -> !line.isBlank())
				.map(this::parseEvent)
				.toList();
		}
		catch (IOException exception) {
			throw new IllegalStateException("Failed to read merchant click events", exception);
		}
	}

	private MerchantClickEvent parseEvent(String line) {
		try {
			return JSON_MAPPER.readValue(line, MerchantClickEvent.class);
		}
		catch (IOException exception) {
			throw new IllegalStateException("Failed to parse merchant click event", exception);
		}
	}

	private int uniqueCount(List<MerchantClickEvent> events, Function<MerchantClickEvent, String> keyExtractor) {
		return (int) events.stream()
			.map(keyExtractor)
			.filter(value -> value != null && !value.isBlank())
			.distinct()
			.count();
	}

	private List<MerchantClickCountEntry> counts(List<MerchantClickEvent> events, Function<MerchantClickEvent, String> keyExtractor) {
		Map<String, Long> counts = events.stream()
			.map(keyExtractor)
			.map(this::nullToBlank)
			.filter(value -> !value.isBlank())
			.collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));

		return counts.entrySet().stream()
			.sorted(Map.Entry.<String, Long>comparingByValue().reversed().thenComparing(Map.Entry::getKey))
			.map(entry -> new MerchantClickCountEntry(entry.getKey(), entry.getValue()))
			.toList();
	}

	private String nullToBlank(String value) {
		return value == null ? "" : value;
	}
}
