package com.example.pfas.derived;

import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.SpringApplication;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.stereotype.Component;

@Component
@ConditionalOnProperty(name = "pfas.derived.sync-on-startup", havingValue = "true")
public class DerivedArtifactSyncRunner implements ApplicationRunner {

	private final DerivedArtifactService service;
	private final ConfigurableApplicationContext applicationContext;

	public DerivedArtifactSyncRunner(
		DerivedArtifactService service,
		ConfigurableApplicationContext applicationContext
	) {
		this.service = service;
		this.applicationContext = applicationContext;
	}

	@Override
	public void run(ApplicationArguments args) {
		service.sync();
		SpringApplication.exit(applicationContext, () -> 0);
	}
}
