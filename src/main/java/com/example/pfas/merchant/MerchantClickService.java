package com.example.pfas.merchant;

import java.io.BufferedReader;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
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
public class MerchantClickService {

	private static final int MAX_FIELD_LENGTH = 240;
	private static final int MAX_URL_LENGTH = 2048;
	private static final ObjectMapper JSON_MAPPER = new ObjectMapper();

	private final Path eventFile;
	private final Object writeLock = new Object();

	public MerchantClickService(PfasMerchantClickProperties properties) {
		var configuredRoot = properties.root();
		var root = configuredRoot == null || configuredRoot.isBlank()
			? Path.of("./build/merchant-clicks")
			: Path.of(configuredRoot);
		this.eventFile = root.normalize().resolve("events.ndjson");
	}

	public MerchantClickAccepted recordClick(MerchantClickPayload payload, String userAgent) {
		var event = validate(payload, userAgent);
		synchronized (writeLock) {
			append(event);
		}
		return new MerchantClickAccepted(true, event.recordedAt());
	}

	public MerchantClickReport getReport() {
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

	private MerchantClickEvent validate(MerchantClickPayload payload, String userAgent) {
		if (payload == null) {
			throw new InvalidMerchantClickPayloadException("Merchant click payload is required.");
		}

		var productId = normalizedRequired(payload.productId(), "productId");
		var merchant = normalizedRequired(payload.merchant(), "merchant");
		var targetUrl = normalizedUrl(payload.targetUrl(), "targetUrl");
		var pagePath = normalizedPath(payload.pagePath(), "pagePath");

		return new MerchantClickEvent(
			OffsetDateTime.now().toString(),
			productId,
			merchant,
			normalizedOptional(payload.ctaSlot()),
			normalizedOptional(payload.sourcePage()),
			normalizedOptional(payload.routeType()),
			normalizedOptional(payload.routeCode()),
			normalizedOptional(payload.benchmarkRelation()),
			normalizedOptional(payload.unlockState()),
			normalizedOptional(payload.nextActionCode()),
			targetUrl,
			pagePath,
			normalizedOptional(userAgent, 512)
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
		try (BufferedReader reader = Files.newBufferedReader(eventFile, StandardCharsets.UTF_8)) {
			return reader.lines()
				.map(String::trim)
				.filter(line -> !line.isBlank())
				.map(this::parseEventSafely)
				.flatMap(java.util.Optional::stream)
				.toList();
		}
		catch (IOException exception) {
			throw new IllegalStateException("Failed to read merchant click events", exception);
		}
	}

	private java.util.Optional<MerchantClickEvent> parseEventSafely(String line) {
		try {
			return java.util.Optional.of(JSON_MAPPER.readValue(line, MerchantClickEvent.class));
		}
		catch (IOException exception) {
			return java.util.Optional.empty();
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
			.map(this::normalizedOptional)
			.filter(value -> !value.isBlank())
			.collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));

		return counts.entrySet().stream()
			.sorted(Map.Entry.<String, Long>comparingByValue().reversed().thenComparing(Map.Entry::getKey))
			.map(entry -> new MerchantClickCountEntry(entry.getKey(), entry.getValue()))
			.toList();
	}

	private String normalizedRequired(String value, String fieldName) {
		var normalized = normalizedOptional(value);
		if (normalized.isBlank()) {
			throw new InvalidMerchantClickPayloadException(fieldName + " is required.");
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

	private String normalizedUrl(String value, String fieldName) {
		var normalized = normalizedOptional(value, MAX_URL_LENGTH);
		if (normalized.isBlank()) {
			throw new InvalidMerchantClickPayloadException(fieldName + " is required.");
		}

		try {
			var uri = new URI(normalized);
			var scheme = uri.getScheme();
			if (scheme == null || (!scheme.equalsIgnoreCase("http") && !scheme.equalsIgnoreCase("https"))) {
				throw new InvalidMerchantClickPayloadException(fieldName + " must be an absolute http or https URL.");
			}
			return uri.toString();
		}
		catch (URISyntaxException exception) {
			throw new InvalidMerchantClickPayloadException(fieldName + " must be a valid URL.");
		}
	}

	private String normalizedPath(String value, String fieldName) {
		var normalized = normalizedOptional(value, MAX_URL_LENGTH);
		if (normalized.isBlank()) {
			throw new InvalidMerchantClickPayloadException(fieldName + " is required.");
		}
		if (!normalized.startsWith("/")) {
			throw new InvalidMerchantClickPayloadException(fieldName + " must start with '/'.");
		}
		return normalized;
	}
}
