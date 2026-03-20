package com.example.pfas.web;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public record ComparePageFile(
	String schemaVersion,
	String generatedAt,
	List<ComparePage> comparePages
) {
}
