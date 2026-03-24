package com.example.pfas.web;

import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.boot.webmvc.autoconfigure.error.ErrorViewResolver;
import org.springframework.web.servlet.ModelAndView;

import com.example.pfas.site.PfasSiteProperties;

@Configuration
public class PublicErrorViewConfiguration {

	@Bean
	ErrorViewResolver publicErrorViewResolver(PfasSiteProperties siteProperties) {
		return (request, status, model) -> {
			var resolvedModel = new HashMap<>(model);
			resolvedModel.putIfAbsent("siteBaseUrl", siteProperties.baseUrl());
			resolvedModel.putIfAbsent("status", status.value());
			resolvedModel.putIfAbsent("error", status.getReasonPhrase());
			resolvedModel.putIfAbsent("path", resolvePath(request, model));
			resolvedModel.remove("message");
			return new ModelAndView(resolveViewName(status), resolvedModel, status);
		};
	}

	private String resolveViewName(HttpStatus status) {
		if (status == HttpStatus.BAD_REQUEST) {
			return "error/400";
		}
		if (status == HttpStatus.NOT_FOUND) {
			return "error/404";
		}
		return "error/error";
	}

	private String resolvePath(HttpServletRequest request, Map<String, Object> model) {
		var path = model.get("path");
		if (path != null) {
			return path.toString();
		}
		var requestUri = request.getAttribute(RequestDispatcher.ERROR_REQUEST_URI);
		return requestUri == null ? request.getRequestURI() : requestUri.toString();
	}
}
