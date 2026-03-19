package com.example.pfas.export;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.boot.web.server.servlet.context.ServletWebServerApplicationContext;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
@ConditionalOnProperty(name = "pfas.export.static-on-startup", havingValue = "true")
public class StaticExportRunner implements ApplicationListener<ApplicationReadyEvent> {

	private final StaticExportService service;
	private final ServletWebServerApplicationContext applicationContext;

	public StaticExportRunner(
		StaticExportService service,
		ServletWebServerApplicationContext applicationContext
	) {
		this.service = service;
		this.applicationContext = applicationContext;
	}

	@Override
	public void onApplicationEvent(ApplicationReadyEvent event) {
		var port = applicationContext.getWebServer().getPort();
		service.export("http://127.0.0.1:" + port);
		SpringApplication.exit(applicationContext, () -> 0);
	}
}
