package com.example.pfas.web;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public record GuideSection(
	String title,
	String summary,
	List<String> paragraphs,
	List<String> bullets
) {
}
