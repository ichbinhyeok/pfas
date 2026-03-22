package com.example.pfas.internalapi;

import java.io.IOException;

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
	private static final String HEADER_NAME = "X-PFAS-Internal-Token";

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
		if (path == null || !path.startsWith(INTERNAL_PREFIX)) {
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

		if (isAuthorized(expectedToken, providedToken)) {
			filterChain.doFilter(request, response);
			return;
		}

		response.sendError(HttpServletResponse.SC_NOT_FOUND);
	}

	private boolean isAuthorized(String expectedToken, String providedToken) {
		return expectedToken != null
			&& !expectedToken.isBlank()
			&& expectedToken.equals(providedToken);
	}
}
