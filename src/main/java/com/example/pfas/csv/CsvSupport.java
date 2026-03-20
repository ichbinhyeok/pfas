package com.example.pfas.csv;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.IntStream;

public final class CsvSupport {

	private CsvSupport() {
	}

	public static String[] split(String line) {
		if (line == null) {
			return new String[0];
		}

		var values = new ArrayList<String>();
		var current = new StringBuilder();
		var inQuotes = false;

		for (var index = 0; index < line.length(); index++) {
			var character = line.charAt(index);
			if (character == '"') {
				if (inQuotes && index + 1 < line.length() && line.charAt(index + 1) == '"') {
					current.append('"');
					index++;
				} else {
					inQuotes = !inQuotes;
				}
				continue;
			}

			if (character == ',' && !inQuotes) {
				values.add(current.toString());
				current.setLength(0);
				continue;
			}

			current.append(character);
		}

		values.add(current.toString());
		return values.toArray(String[]::new);
	}

	public static Map<String, Integer> headerMap(String headerLine) {
		var headers = split(headerLine);
		var indexMap = new HashMap<String, Integer>();
		IntStream.range(0, headers.length).forEach(index -> indexMap.put(headers[index], index));
		return indexMap;
	}

	public static String value(String[] values, Map<String, Integer> headerMap, String column) {
		var index = headerMap.get(column);
		if (index == null || index >= values.length) {
			return "";
		}
		return values[index];
	}

	public static List<String> parsePipeSeparatedList(String raw) {
		if (raw == null || raw.isBlank()) {
			return List.of();
		}

		return Arrays.stream(raw.split("\\|"))
			.map(String::trim)
			.filter(value -> !value.isEmpty())
			.toList();
	}

	public static BigDecimal parseBigDecimal(String raw) {
		if (raw == null || raw.isBlank()) {
			return null;
		}
		return new BigDecimal(raw);
	}

	public static Integer parseInteger(String raw) {
		if (raw == null || raw.isBlank()) {
			return null;
		}
		return Integer.valueOf(raw);
	}
}
