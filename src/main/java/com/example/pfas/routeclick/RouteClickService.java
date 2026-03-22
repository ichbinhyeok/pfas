package com.example.pfas.routeclick;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
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
public class RouteClickService {

	private static final int MAX_FIELD_LENGTH = 240;
	private static final int MAX_PATH_LENGTH = 2048;
	private static final ObjectMapper JSON_MAPPER = new ObjectMapper();

	private final Path eventFile;
	private final Object writeLock = new Object();

	public RouteClickService(PfasRouteClickProperties properties) {
		var configuredRoot = properties.root();
		var root = configuredRoot == null || configuredRoot.isBlank()
			? Path.of("./build/route-clicks")
			: Path.of(configuredRoot);
		this.eventFile = root.normalize().resolve("events.ndjson");
	}

	public RouteClickAccepted recordClick(RouteClickPayload payload, String userAgent) {
		var event = validate(payload, userAgent);
		synchronized (writeLock) {
			append(event);
		}
		return new RouteClickAccepted(true, event.recordedAt());
	}

	public RouteClickReport getReport() {
		var events = readEvents();
		return new RouteClickReport(
			OffsetDateTime.now().toString(),
			events.size(),
			uniqueCount(events, RouteClickEvent::sourcePage),
			uniqueCount(events, RouteClickEvent::targetPath),
			counts(events, RouteClickEvent::sourcePage),
			counts(events, RouteClickEvent::targetPath),
			counts(events, RouteClickEvent::ctaSlot),
			counts(events, RouteClickEvent::routeFamily),
			counts(events, RouteClickEvent::laneLabel),
			counts(events, RouteClickEvent::regionCode),
			events.stream()
				.sorted(Comparator.comparing(RouteClickEvent::recordedAt).reversed())
				.limit(20)
				.toList()
		);
	}

	private RouteClickEvent validate(RouteClickPayload payload, String userAgent) {
		if (payload == null) {
			throw new InvalidRouteClickPayloadException("Route click payload is required.");
		}

		return new RouteClickEvent(
			OffsetDateTime.now().toString(),
			normalizedRequired(payload.clickId(), "clickId"),
			normalizedPath(payload.sourcePage(), "sourcePage"),
			normalizedPath(payload.targetPath(), "targetPath"),
			normalizedRequired(payload.ctaSlot(), "ctaSlot"),
			normalizedOptional(payload.routeFamily()),
			normalizedOptional(payload.laneLabel()),
			normalizedOptional(payload.regionCode()),
			normalizedOptional(userAgent, 512)
		);
	}

	private void append(RouteClickEvent event) {
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
			throw new IllegalStateException("Failed to append route click event", exception);
		}
	}

	private List<RouteClickEvent> readEvents() {
		if (!Files.exists(eventFile)) {
			return List.of();
		}
		try (BufferedReader reader = Files.newBufferedReader(eventFile, StandardCharsets.UTF_8)) {
			return reader.lines()
				.map(String::trim)
				.filter(line -> !line.isBlank())
				.map(this::parseEventSafely)
				.flatMap(java.util.Optional::stream)
				.toList();
		}
		catch (IOException exception) {
			throw new IllegalStateException("Failed to read route click events", exception);
		}
	}

	private java.util.Optional<RouteClickEvent> parseEventSafely(String line) {
		try {
			return java.util.Optional.of(JSON_MAPPER.readValue(line, RouteClickEvent.class));
		}
		catch (IOException exception) {
			return java.util.Optional.empty();
		}
	}

	private int uniqueCount(List<RouteClickEvent> events, Function<RouteClickEvent, String> keyExtractor) {
		return (int) events.stream()
			.map(keyExtractor)
			.filter(value -> value != null && !value.isBlank())
			.distinct()
			.count();
	}

	private List<RouteClickCountEntry> counts(List<RouteClickEvent> events, Function<RouteClickEvent, String> keyExtractor) {
		Map<String, Long> counts = events.stream()
			.map(keyExtractor)
			.map(this::normalizedOptional)
			.filter(value -> !value.isBlank())
			.collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));

		return counts.entrySet().stream()
			.sorted(Map.Entry.<String, Long>comparingByValue().reversed().thenComparing(Map.Entry::getKey))
			.map(entry -> new RouteClickCountEntry(entry.getKey(), entry.getValue()))
			.toList();
	}

	private String normalizedRequired(String value, String fieldName) {
		var normalized = normalizedOptional(value);
		if (normalized.isBlank()) {
			throw new InvalidRouteClickPayloadException(fieldName + " is required.");
		}
		return normalized;
	}

	private String normalizedOptional(String value) {
		return normalizedOptional(value, MAX_FIELD_LENGTH);
	}

	private String normalizedOptional(String value, int maxLength) {
		if (value == null) {
			return "";
		}
		var trimmed = value.trim();
		if (trimmed.length() > maxLength) {
			return trimmed.substring(0, maxLength);
		}
		return trimmed;
	}

	private String normalizedPath(String value, String fieldName) {
		var normalized = normalizedOptional(value, MAX_PATH_LENGTH);
		if (normalized.isBlank()) {
			throw new InvalidRouteClickPayloadException(fieldName + " is required.");
		}
		if (!normalized.startsWith("/")) {
			throw new InvalidRouteClickPayloadException(fieldName + " must start with '/'.");
		}
		return normalized;
	}
}
