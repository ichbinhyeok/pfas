package com.example.pfas.internalapi;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
public class InternalApiGuardFilter extends OncePerRequestFilter {

	private static final String INTERNAL_PREFIX = "/internal/";
	private static final String ADMIN_PATH = "/admin";
	private static final String HEADER_NAME = "X-PFAS-Internal-Token";
	private static final String AUTHORIZATION_HEADER = "Authorization";
	private static final String BASIC_PREFIX = "Basic ";
	private static final String BASIC_REALM = "Basic realm=\"PFAS Internal\"";

	private final InternalApiProperties properties;

	public InternalApiGuardFilter(InternalApiProperties properties) {
		this.properties = properties;
	}

	@Override
	protected boolean shouldNotFilter(HttpServletRequest request) {
		var path = request.getRequestURI();
		var contextPath = request.getContextPath();
		if (path != null && contextPath != null && !contextPath.isBlank() && path.startsWith(contextPath)) {
			path = path.substring(contextPath.length());
		}
		if (!isProtectedPath(path)) {
			return true;
		}

		return HttpMethod.OPTIONS.matches(request.getMethod());
	}

	@Override
	protected void doFilterInternal(
		HttpServletRequest request,
		HttpServletResponse response,
		FilterChain filterChain
	) throws ServletException, IOException {
		var expectedToken = properties.token();
		var providedToken = request.getHeader(HEADER_NAME);
		var providedAuthorization = request.getHeader(AUTHORIZATION_HEADER);

		if (isAuthorized(expectedToken, providedToken, providedAuthorization)) {
			filterChain.doFilter(request, response);
			return;
		}

		if (basicAuthConfigured()) {
			response.setHeader("WWW-Authenticate", BASIC_REALM);
			response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
			return;
		}

		response.sendError(HttpServletResponse.SC_NOT_FOUND);
	}

	private boolean isAuthorized(String expectedToken, String providedToken, String providedAuthorization) {
		return isTokenAuthorized(expectedToken, providedToken) || isBasicAuthorized(providedAuthorization);
	}

	private boolean isTokenAuthorized(String expectedToken, String providedToken) {
		return expectedToken != null
			&& !expectedToken.isBlank()
			&& expectedToken.equals(providedToken);
	}

	private boolean isBasicAuthorized(String providedAuthorization) {
		if (!basicAuthConfigured() || providedAuthorization == null || !providedAuthorization.startsWith(BASIC_PREFIX)) {
			return false;
		}

		try {
			var encoded = providedAuthorization.substring(BASIC_PREFIX.length()).trim();
			var decoded = new String(Base64.getDecoder().decode(encoded), StandardCharsets.UTF_8);
			var separator = decoded.indexOf(':');
			if (separator < 0) {
				return false;
			}
			var username = decoded.substring(0, separator);
			var password = decoded.substring(separator + 1);
			return properties.username().equals(username) && properties.password().equals(password);
		}
		catch (IllegalArgumentException exception) {
			return false;
		}
	}

	private boolean basicAuthConfigured() {
		return properties.username() != null
			&& !properties.username().isBlank()
			&& properties.password() != null
			&& !properties.password().isBlank();
	}

	private boolean isProtectedPath(String path) {
		if (path == null || path.isBlank()) {
			return false;
		}
		return path.startsWith(INTERNAL_PREFIX)
			|| ADMIN_PATH.equals(path)
			|| path.startsWith(ADMIN_PATH + "/");
	}
}
