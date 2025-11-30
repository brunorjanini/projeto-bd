package com.usp.app.config;

import org.springframework.web.reactive.config.CorsRegistry;
import org.springframework.web.reactive.config.WebFluxConfigurer;

public class WebServerConfigutarions {

	public WebFluxConfigurer corsConfig() {
		return new WebFluxConfigurer() {
			@Override
			public void addCorsMappings(CorsRegistry corsRegistry) {
				corsRegistry.addMapping("/**")
						.allowedOriginPatterns("*")
						.allowedMethods("*")
						.allowCredentials(true)
						.exposedHeaders("*");
			}
		};

	}
}
