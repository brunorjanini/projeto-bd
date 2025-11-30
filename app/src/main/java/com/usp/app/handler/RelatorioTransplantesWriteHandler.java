package com.usp.app.handler;

import com.usp.app.dto.*;
import com.usp.app.dto.Consulta1HospitalDTO;
import com.usp.app.dto.Consulta3ReceptorFilaDTO;
import com.usp.app.dto.Consulta5ProfissionalDivisaoDTO;
import com.usp.app.service.CommandsService;
import com.usp.app.service.GetQueriesService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.server.ServerRequest;
import org.springframework.web.reactive.function.server.ServerResponse;
import reactor.core.publisher.Mono;

@Component
public class RelatorioTransplantesWriteHandler {

    private final CommandsService writeService;
    private final GetQueriesService readService;

    public RelatorioTransplantesWriteHandler(CommandsService writeService,
                                             GetQueriesService readService) {
        this.writeService = writeService;
        this.readService = readService;
    }

    /**
     * POST /relatorios/hospitais
     * Cria um hospital e retorna o relatório atualizado (Consulta 1).
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
     * POST /orgaos
     * Insere órgão/tecido e retorna 201 sem body.
     */
    public Mono<ServerResponse> criarOrgao(ServerRequest request) {
        return request.bodyToMono(NovoOrgaoDTO.class)
                .flatMap(writeService::criarOrgao)
                .then(ServerResponse.status(HttpStatus.CREATED).build());
    }

    /**
     * POST /avaliacoes/orgaos
     * Cria avaliação e retorna lista de profissionais que avaliaram todos (Consulta 5).
     */
    public Mono<ServerResponse> criarAvaliacaoOrgao(ServerRequest request) {
        String profissao = request.queryParam("profissao").orElse("MÉDICO");

        return request.bodyToMono(NovaAvaliacaoOrgaoDTO.class)
                .flatMapMany(dto ->
                        writeService.criarAvaliacaoOrgao(dto)
                                .thenMany(readService.profissionaisQueAvaliaramTodosTipos(profissao))
                )
                .as(flux -> ServerResponse.status(HttpStatus.CREATED)
                        .body(flux, Consulta5ProfissionalDivisaoDTO.class));
    }

    /**
     * POST /filas/historico
     * Insere um histórico de fila e devolve consulta 3 atualizada.
     */
    public Mono<ServerResponse> criarHistoricoFila(ServerRequest request) {
        int minTransplantes = request.queryParam("minTransplantes")
                .map(Integer::parseInt)
                .orElse(1);

        return request.bodyToMono(NovoHistoricoFilaDTO.class)
                .flatMapMany(dto ->
                        writeService.criarHistoricoFila(dto)
                                .thenMany(readService.receptoresComMaisDeNTransplantesEmFila(minTransplantes))
                )
                .as(flux -> ServerResponse.status(HttpStatus.CREATED)
                        .body(flux, Consulta3ReceptorFilaDTO.class));
    }

    /**
     * PUT /receptores/{idPessoa}/num-transplantes
     * Atualiza num_transplantes e retorna consulta 3 atualizada.
     */
    public Mono<ServerResponse> atualizarNumTransplantes(ServerRequest request) {
        int idPessoa = Integer.parseInt(request.pathVariable("idPessoa"));
        int minTransplantes = request.queryParam("minTransplantes")
                .map(Integer::parseInt)
                .orElse(1);

        return request.bodyToMono(AtualizarNumTransplantesDTO.class)
                .flatMapMany(dto ->
                        writeService.atualizarNumTransplantes(idPessoa, dto)
                                .thenMany(readService.receptoresComMaisDeNTransplantesEmFila(minTransplantes))
                )
                .as(flux -> ServerResponse.ok()
                        .body(flux, Consulta3ReceptorFilaDTO.class));
    }
}
