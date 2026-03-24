package com.example.pfas.web;

import java.util.LinkedHashMap;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.ModelAndView;

import com.example.pfas.site.PfasSiteProperties;

@ControllerAdvice(basePackages = "com.example.pfas.web")
public class PublicErrorAdvice {

	private final PfasSiteProperties siteProperties;

	public PublicErrorAdvice(PfasSiteProperties siteProperties) {
		this.siteProperties = siteProperties;
	}

	@ExceptionHandler(ResponseStatusException.class)
	public ModelAndView handleResponseStatus(HttpServletRequest request, ResponseStatusException exception) {
		return errorView(request, exception.getStatusCode(), exception.getReason());
	}

	@ExceptionHandler({ MethodArgumentTypeMismatchException.class, IllegalArgumentException.class })
	public ModelAndView handleBadRequest(HttpServletRequest request, Exception exception) {
		return errorView(request, HttpStatus.BAD_REQUEST, exception.getMessage());
	}

	private ModelAndView errorView(HttpServletRequest request, HttpStatusCode statusCode, String message) {
		var status = HttpStatus.resolve(statusCode.value());
		var resolvedStatus = status == null ? HttpStatus.INTERNAL_SERVER_ERROR : status;
		var model = new LinkedHashMap<String, Object>();
		model.put("siteBaseUrl", siteProperties.baseUrl());
		model.put("status", resolvedStatus.value());
		model.put("error", resolvedStatus.getReasonPhrase());
		model.put("message", safeMessage(resolvedStatus, message));
		model.put("path", request.getRequestURI());
		return new ModelAndView(resolveViewName(resolvedStatus), model, resolvedStatus);
	}

	private String safeMessage(HttpStatus status, String message) {
		if (status.is4xxClientError() || status.is5xxServerError()) {
			return null;
		}
		return message;
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
}
