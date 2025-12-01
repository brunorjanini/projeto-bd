package com.usp.app;

import com.usp.app.handler.RelatorioTransplantesHandler;
import com.usp.app.handler.RelatorioTransplantesWriteHandler;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.RouterFunctions;
import org.springframework.web.reactive.function.server.ServerResponse;

/**
 * Configuração de rotas da API utilizando programação funcional reativa do Spring WebFlux.
 * Define todos os endpoints REST da aplicação de forma declarativa.
 */
@Configuration
public class RouterConfiguration {

    /**
     * Configura todas as rotas da API de relatórios e operações do sistema de transplantes.
     * 
     * <p>Rotas de leitura (GET):</p>
     * <ul>
     *   <li>GET /api/relatorios/hospitais - Lista hospitais com filtros opcionais</li>
     *   <li>GET /api/relatorios/transportes - Lista transportes de órgãos</li>
     * </ul>
     * 
     * <p>Rotas de escrita (POST):</p>
     * <ul>
     *   <li>POST /api/relatorios/hospitais - Cria novo hospital</li>
     *   <li>POST /api/transplantes - Realiza transplante completo</li>
     * </ul>
     *
     * @param readHandler Handler responsável por operações de leitura
     * @param writeHandler Handler responsável por operações de escrita
     * @return RouterFunction configurada com todas as rotas da API
     */
    @Bean
    public RouterFunction<ServerResponse> routes(RelatorioTransplantesHandler readHandler,
                                                 RelatorioTransplantesWriteHandler writeHandler) {
        return RouterFunctions.route()
                // READs
                .GET("/api/relatorios/hospitais", readHandler::listarHospitais)
                .GET("/api/relatorios/transportes", readHandler::transportesEntreHospitais)

                // WRITEs
                .POST("/api/relatorios/hospitais", writeHandler::criarHospital)
                .POST("/api/transplantes", writeHandler::realizarTransplante)

                .build();
    }

}
