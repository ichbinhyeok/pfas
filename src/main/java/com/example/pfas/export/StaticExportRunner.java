package com.example.pfas.export;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.boot.web.server.servlet.context.ServletWebServerApplicationContext;
import org.springframework.context.ApplicationListener;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
@ConditionalOnProperty(name = "pfas.export.static-on-startup", havingValue = "true")
public class StaticExportRunner implements ApplicationListener<ApplicationReadyEvent> {

	private final StaticExportService service;
	private final ServletWebServerApplicationContext applicationContext;
	private final String contextPath;

	public StaticExportRunner(
		StaticExportService service,
		ServletWebServerApplicationContext applicationContext,
		@Value("${server.servlet.context-path:}") String contextPath
	) {
		this.service = service;
		this.applicationContext = applicationContext;
		this.contextPath = contextPath == null ? "" : contextPath;
	}

	@Override
	public void onApplicationEvent(ApplicationReadyEvent event) {
		var port = applicationContext.getWebServer().getPort();
		service.export("http://127.0.0.1:" + port + normalizedContextPath());
		SpringApplication.exit(applicationContext, () -> 0);
	}

	private String normalizedContextPath() {
		if (contextPath.isBlank() || "/".equals(contextPath)) {
			return "";
		}
		return contextPath.startsWith("/") ? contextPath : "/" + contextPath;
	}
}
