package com.usp.app.handler;

import com.usp.app.dto.*;
import com.usp.app.service.CommandsService;
import com.usp.app.service.GetQueriesService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.server.ServerRequest;
import org.springframework.web.reactive.function.server.ServerResponse;
import reactor.core.publisher.Mono;

/**
 * Handler responsável por processar requisições HTTP de escrita relacionadas
 * a relatórios e operações do sistema de transplantes.
 * Combina operações de escrita com queries de leitura para retornar dados atualizados.
 */
@Component
public class RelatorioTransplantesWriteHandler {

    private final CommandsService writeService;
    private final GetQueriesService readService;

    /**
     * Construtor do handler de operações de escrita.
     *
     * @param writeService Serviço de comandos para operações de escrita
     * @param readService Serviço de queries para consultas de leitura
     */
    public RelatorioTransplantesWriteHandler(CommandsService writeService,
                                             GetQueriesService readService) {
        this.writeService = writeService;
        this.readService = readService;
    }

    /**
     * Endpoint POST para criar um novo hospital no sistema.
     * Após a criação, retorna a lista atualizada de hospitais filtrada pela
     * central estadual e status de órgãos especificados nos query parameters.
     * 
     * <p>Exemplo: POST /api/relatorios/hospitais?central=SP&amp;status=Disponível</p>
     *
     * @param request Requisição HTTP contendo o body com dados do hospital (NovoHospitalDTO)
     *                e query parameters (central, status)
     * @return Mono de ServerResponse com status 201 (CREATED) e lista atualizada de hospitais
     */
    public Mono<ServerResponse> criarHospital(ServerRequest request) {
        String central = request.queryParam("central").orElse("SP");
        String status = request.queryParam("status").orElse("Disponível");

        return request.bodyToMono(NovoHospitalDTO.class)
                .flatMapMany(dto ->
                        writeService.criarHospital(dto)
                                .thenMany(readService.hospitaisPorEstadoEStatus(central, status))
                )
                .as(flux -> ServerResponse.status(HttpStatus.CREATED)
                        .body(flux, Consulta1HospitalDTO.class));
    }

    /**
     * Endpoint POST para realizar um transplante completo de forma transacional.
     * Esta operação executa múltiplas ações atomicamente:
     * <ul>
     *   <li>Insere o registro do transplante</li>
     *   <li>Atualiza o status e validade do órgão</li>
     *   <li>Incrementa o contador de transplantes do receptor</li>
     *   <li>Remove o receptor da fila de espera</li>
     * </ul>
     * 
     * <p>Exemplo: POST /api/transplantes</p>
     *
     * @param request Requisição HTTP contendo o body com dados do transplante (RealizarTransplanteDTO)
     * @return Mono de ServerResponse com status 201 (CREATED) em caso de sucesso,
     *         ou status 500 (INTERNAL_SERVER_ERROR) com mensagem de erro em caso de falha
     */
    public Mono<ServerResponse> realizarTransplante(ServerRequest request) {
        return request.bodyToMono(RealizarTransplanteDTO.class)
                .flatMap(dto ->
                        writeService.realizarTransplante(dto)
                                .then(ServerResponse.status(HttpStatus.CREATED).build())
                )
                .onErrorResume(error ->
                        ServerResponse.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                .bodyValue(error.getMessage())
                );
    }
}
