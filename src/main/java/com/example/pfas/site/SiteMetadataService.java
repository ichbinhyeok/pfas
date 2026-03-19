package com.example.pfas.site;

import java.time.OffsetDateTime;

import org.springframework.stereotype.Service;

import com.example.pfas.source.SourceRegistryService;

@Service
public class SiteMetadataService {

	private final PfasSiteProperties siteProperties;
	private final SourceRegistryService sourceRegistryService;

	public SiteMetadataService(PfasSiteProperties siteProperties, SourceRegistryService sourceRegistryService) {
		this.siteProperties = siteProperties;
		this.sourceRegistryService = sourceRegistryService;
	}

	public String siteBaseUrl() {
		var raw = siteProperties.baseUrl();
		if (raw == null || raw.isBlank()) {
			return "https://example.com";
		}
		return raw.endsWith("/") ? raw.substring(0, raw.length() - 1) : raw;
	}

	public String editorialOwner() {
		var raw = siteProperties.editorialOwner();
		if (raw == null || raw.isBlank()) {
			return "PFAS Decision Engine operator (not publicly named)";
		}
		return raw;
	}

	public String methodologyOwner() {
		var raw = siteProperties.methodologyOwner();
		if (raw == null || raw.isBlank()) {
			return "PFAS Decision Engine methodology owner (not publicly named)";
		}
		return raw;
	}

	public String siteLastVerifiedDate() {
		return sourceRegistryService.registryGeneratedAt()
			.map(this::toDateOnly)
			.orElse("unknown");
	}

	public String absoluteUrl(String path) {
		var normalizedPath = (path == null || path.isBlank()) ? "/" : path;
		if (!normalizedPath.startsWith("/")) {
			normalizedPath = "/" + normalizedPath;
		}
		return siteBaseUrl() + normalizedPath;
	}

	private String toDateOnly(String raw) {
		try {
			return OffsetDateTime.parse(raw).toLocalDate().toString();
		}
		catch (Exception ignored) {
			return raw.length() >= 10 ? raw.substring(0, 10) : raw;
		}
	}
}
