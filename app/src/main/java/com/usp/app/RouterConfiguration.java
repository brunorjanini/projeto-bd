package com.usp.app;

import com.usp.app.handler.RelatorioTransplantesHandler;
import com.usp.app.handler.RelatorioTransplantesWriteHandler;

import java.net.URI;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.RouterFunctions;
import org.springframework.web.reactive.function.server.ServerResponse;

@Configuration
public class RouterConfiguration {

    @Bean
    public RouterFunction<ServerResponse> routes(RelatorioTransplantesHandler readHandler,
                                                 RelatorioTransplantesWriteHandler writeHandler) {
        return RouterFunctions.route()
                // READs
                .GET("/api/relatorios/hospitais", readHandler::listarHospitais)
                .GET("/api/relatorios/profissionais-sem-pacientes", readHandler::profissionaisSemPacientes)
                .GET("/api/relatorios/receptores", readHandler::receptoresComMaisTransplantes)
                .GET("/api/relatorios/transportes", readHandler::transportesEntreHospitais)
                .GET("/api/relatorios/profissionais-avaliaram-todos", readHandler::profissionaisQueAvaliaramTodos)

                // WRITEs
                .POST("/api/relatorios/hospitais", writeHandler::criarHospital)
                .POST("/api/orgaos", writeHandler::criarOrgao)
                .POST("/api/avaliacoes/orgaos", writeHandler::criarAvaliacaoOrgao)
                .POST("/api/filas/historico", writeHandler::criarHistoricoFila)
                .PUT("/api/receptores/{idPessoa}/num-transplantes", writeHandler::atualizarNumTransplantes)

                .build();
    }

    @Bean
    public RouterFunction<ServerResponse> uiRouter() {
        return RouterFunctions.route(org.springframework.web.reactive.function.server.RequestPredicates.GET("/"), request ->
                ServerResponse
                        .temporaryRedirect(URI.create("/transplantes.html"))
                        .build()
        );
    }
}
