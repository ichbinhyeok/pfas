package com.example.pfas.site;

import org.springframework.stereotype.Service;

@Service
public class SiteMetadataService {

	private final PfasSiteProperties siteProperties;

	public SiteMetadataService(PfasSiteProperties siteProperties) {
		this.siteProperties = siteProperties;
	}

	public String siteBaseUrl() {
		var raw = siteProperties.baseUrl();
		if (raw == null || raw.isBlank()) {
			return "https://example.com";
		}
		return raw.endsWith("/") ? raw.substring(0, raw.length() - 1) : raw;
	}

	public String absoluteUrl(String path) {
		var normalizedPath = (path == null || path.isBlank()) ? "/" : path;
		if (!normalizedPath.startsWith("/")) {
			normalizedPath = "/" + normalizedPath;
		}
		return siteBaseUrl() + normalizedPath;
	}
}
