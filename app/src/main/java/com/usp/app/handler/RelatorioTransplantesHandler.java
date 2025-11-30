package com.usp.app.handler;


import com.usp.app.dto.Consulta1HospitalDTO;
import com.usp.app.dto.Consulta2ProfissionalSemPacienteDTO;
import com.usp.app.dto.Consulta3ReceptorFilaDTO;
import com.usp.app.dto.Consulta4TransporteDTO;
import com.usp.app.dto.Consulta5ProfissionalDivisaoDTO;
import com.usp.app.service.GetQueriesService;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.server.ServerRequest;
import org.springframework.web.reactive.function.server.ServerResponse;

import reactor.core.publisher.Mono;

@Service
public class RelatorioTransplantesHandler {

    private final GetQueriesService service;

    public RelatorioTransplantesHandler(GetQueriesService service) {
        this.service = service;
    }

    /**
     * GET /api/relatorios/hospitais?central=SP&status=Disponível
     */
    public Mono<ServerResponse> listarHospitais(ServerRequest request) {
        String central = request.queryParam("central").orElse("SP");
        String status = request.queryParam("status").orElse("Disponível");

        return ServerResponse.ok()
                .body(service.hospitaisPorEstadoEStatus(central, status),
                      Consulta1HospitalDTO.class);
    }

    /**
     * GET /api/relatorios/profissionais-sem-pacientes
     */
    public Mono<ServerResponse> profissionaisSemPacientes(ServerRequest request) {
        return ServerResponse.ok()
                .body(service.profissionaisDeHospitaisSemPacientes(),
                      Consulta2ProfissionalSemPacienteDTO.class);
    }

    /**
     * GET /api/relatorios/receptores?minTransplantes=1
     */
    public Mono<ServerResponse> receptoresComMaisTransplantes(ServerRequest request) {
        int minTransplantes = request.queryParam("minTransplantes")
                .map(Integer::parseInt)
                .orElse(1);

        return ServerResponse.ok()
                .body(service.receptoresComMaisDeNTransplantesEmFila(minTransplantes),
                      Consulta3ReceptorFilaDTO.class);
    }

    /**
     * GET /api/relatorios/transportes
     *   ?origemLike=%25Hospital%20Vital%20SP%25
     *   &destinoLike=%25Hospital%20Carioca%25
     *   &apenasConcluidos=true
     */
    public Mono<ServerResponse> transportesEntreHospitais(ServerRequest request) {
        String origemLike  = request.queryParam("origemLike").orElse("%Hospital Vital SP%");
        String destinoLike = request.queryParam("destinoLike").orElse("%Hospital Carioca%");
        boolean apenasConcluidos = request.queryParam("apenasConcluidos")
                .map(Boolean::parseBoolean)
                .orElse(true);

        return ServerResponse.ok()
                .body(service.transportesEntreHospitais(origemLike, destinoLike, apenasConcluidos),
                      Consulta4TransporteDTO.class);
    }

    /**
     * GET /api/relatorios/profissionais-avaliaram-todos?profissao=MÉDICO
     */
    public Mono<ServerResponse> profissionaisQueAvaliaramTodos(ServerRequest request) {
        String profissao = request.queryParam("profissao").orElse("MÉDICO");

        return ServerResponse.ok()
                .body(service.profissionaisQueAvaliaramTodosTipos(profissao),
                      Consulta5ProfissionalDivisaoDTO.class);
    }

    /**
     * Error handling for bad requests.
     */
    private Mono<ServerResponse> badRequest(String message) {
        return ServerResponse.status(HttpStatus.BAD_REQUEST)
                .bodyValue(message);
    }
}
