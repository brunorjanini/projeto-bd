package com.usp.app.handler;


import com.usp.app.dto.Consulta1HospitalDTO;
import com.usp.app.dto.Consulta4TransporteDTO;
import com.usp.app.service.GetQueriesService;

import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.server.ServerRequest;
import org.springframework.web.reactive.function.server.ServerResponse;

import reactor.core.publisher.Mono;

/**
 * Handler responsável por processar requisições HTTP de leitura relacionadas
 * a relatórios e consultas do sistema de transplantes.
 * Utiliza programação funcional reativa com WebFlux.
 */
@Service
public class RelatorioTransplantesHandler {

    private final GetQueriesService service;

    /**
     * Construtor do handler de relatórios.
     *
     * @param service Serviço de queries para lógica de negócio de leitura
     */
    public RelatorioTransplantesHandler(GetQueriesService service) {
        this.service = service;
    }

    /**
     * Endpoint GET para listar hospitais com contagem de órgãos disponíveis.
     * Suporta filtros opcionais por central estadual e status de órgãos.
     * 
     * <p>Exemplo: GET /api/relatorios/hospitais?central=SP&amp;status=Disponível</p>
     *
     * @param request Requisição HTTP contendo query parameters opcionais (central, status)
     * @return Mono de ServerResponse com status 200 e lista de hospitais no body
     */
    public Mono<ServerResponse> listarHospitais(ServerRequest request) {
        String central = request.queryParam("central").orElse(null);
        String status = request.queryParam("status").orElse(null);

        return ServerResponse.ok()
                .body(service.hospitaisPorEstadoEStatus(central, status),
                      Consulta1HospitalDTO.class);
    }

    /**
     * Endpoint GET para listar transportes de órgãos entre hospitais.
     * Suporta filtros opcionais por nome dos hospitais de origem e destino,
     * e flag para retornar apenas transportes concluídos.
     * 
     * <p>Exemplo: GET /api/relatorios/transportes?origemLike=Hospital&amp;destinoLike=Clinicas&amp;apenasConcluidos=true</p>
     *
     * @param request Requisição HTTP contendo query parameters opcionais (origemLike, destinoLike, apenasConcluidos)
     * @return Mono de ServerResponse com status 200 e lista de transportes no body
     */
    public Mono<ServerResponse> transportesEntreHospitais(ServerRequest request) {
        String origemLike  = request.queryParam("origemLike").orElse(null);
        String destinoLike = request.queryParam("destinoLike").orElse(null);
        boolean apenasConcluidos = request.queryParam("apenasConcluidos")
                .map(Boolean::parseBoolean)
                .orElse(false);

        return ServerResponse.ok()
                .body(service.transportesEntreHospitais(origemLike, destinoLike, apenasConcluidos),
                      Consulta4TransporteDTO.class);
    }
}
