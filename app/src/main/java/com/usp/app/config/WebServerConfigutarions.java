package com.usp.app.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.ReactiveTransactionManager;
import org.springframework.transaction.reactive.TransactionalOperator;
import org.springframework.web.reactive.config.CorsRegistry;
import org.springframework.web.reactive.config.WebFluxConfigurer;

/**
 * Classe de configuração do servidor web e recursos globais da aplicação.
 * Define configurações de CORS e gerenciamento de transações reativas.
 */
@Configuration
public class WebServerConfigutarions {

	/**
	 * Configura CORS (Cross-Origin Resource Sharing) para permitir requisições
	 * de diferentes origens para a API.
	 * 
	 * <p>Configurações aplicadas:</p>
	 * <ul>
	 *   <li>Permite todas as origens (*)</li>
	 *   <li>Permite todos os métodos HTTP (*)</li>
	 *   <li>Permite todos os headers (*)</li>
	 *   <li>Define tempo de cache do preflight em 3600 segundos (1 hora)</li>
	 * </ul>
	 *
	 * @return WebFluxConfigurer configurado com as políticas de CORS
	 */
	@Bean
	public WebFluxConfigurer corsConfig() {
		return new WebFluxConfigurer() {
			@Override
			public void addCorsMappings(CorsRegistry corsRegistry) {
				corsRegistry.addMapping("/**")
						.allowedOrigins("*")
						.allowedMethods("*")
						.allowedHeaders("*")
						.maxAge(3600);
			}
		};

	}

	/**
	 * Cria um operador transacional para gerenciar transações reativas no banco de dados.
	 * Utilizado para executar múltiplas operações de forma atômica.
	 *
	 * @param transactionManager Gerenciador de transações reativo fornecido pelo Spring
	 * @return TransactionalOperator configurado para operações transacionais
	 */
	@Bean
	public TransactionalOperator transactionalOperator(ReactiveTransactionManager transactionManager) {
		return TransactionalOperator.create(transactionManager);
	}
}
