package com.example.pfas.tracking;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Locale;
import java.util.Set;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.example.pfas.site.PfasSiteProperties;

@Component
public class PublicWriteOriginGuardFilter extends OncePerRequestFilter {

	private static final Set<String> TRACKING_PATHS = Set.of("/merchant-clicks", "/route-clicks");

	private final PfasSiteProperties siteProperties;

	public PublicWriteOriginGuardFilter(PfasSiteProperties siteProperties) {
		this.siteProperties = siteProperties;
	}

	@Override
	protected boolean shouldNotFilter(HttpServletRequest request) {
		if (!HttpMethod.POST.matches(request.getMethod())) {
			return true;
		}

		var path = normalizedPath(request);
		return !TRACKING_PATHS.contains(path);
	}

	@Override
	protected void doFilterInternal(
		HttpServletRequest request,
		HttpServletResponse response,
		FilterChain filterChain
	) throws ServletException, IOException {
		if (isCrossSiteBrowserRequest(request)) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		filterChain.doFilter(request, response);
	}

	private boolean isCrossSiteBrowserRequest(HttpServletRequest request) {
		var secFetchSite = request.getHeader("Sec-Fetch-Site");
		if (secFetchSite != null && "cross-site".equalsIgnoreCase(secFetchSite.trim())) {
			return true;
		}

		var expectedOrigin = normalizedOrigin(siteProperties.baseUrl());
		if (expectedOrigin == null) {
			return false;
		}

		var originHeader = request.getHeader("Origin");
		if (originHeader != null) {
			var origin = normalizedOrigin(originHeader);
			return origin == null || !expectedOrigin.equals(origin);
		}

		var refererHeader = request.getHeader("Referer");
		if (refererHeader != null) {
			var refererOrigin = normalizedOrigin(refererHeader);
			return refererOrigin == null || !expectedOrigin.equals(refererOrigin);
		}

		return false;
	}

	private String normalizedPath(HttpServletRequest request) {
		var path = request.getRequestURI();
		var contextPath = request.getContextPath();
		if (path != null && contextPath != null && !contextPath.isBlank() && path.startsWith(contextPath)) {
			path = path.substring(contextPath.length());
		}
		return path == null ? "" : path;
	}

	private String normalizedOrigin(String raw) {
		if (raw == null || raw.isBlank()) {
			return null;
		}

		try {
			var uri = new URI(raw.trim());
			if (uri.getScheme() == null || uri.getHost() == null) {
				return null;
			}

			var scheme = uri.getScheme().toLowerCase(Locale.ROOT);
			var host = uri.getHost().toLowerCase(Locale.ROOT);
			var port = uri.getPort();
			var includePort = port >= 0 && !isDefaultPort(scheme, port);
			return includePort ? scheme + "://" + host + ":" + port : scheme + "://" + host;
		}
		catch (URISyntaxException exception) {
			return null;
		}
	}

	private boolean isDefaultPort(String scheme, int port) {
		return ("http".equals(scheme) && port == 80) || ("https".equals(scheme) && port == 443);
	}
}
