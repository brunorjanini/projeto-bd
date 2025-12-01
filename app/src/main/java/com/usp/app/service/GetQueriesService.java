package com.usp.app.service;


import com.usp.app.dto.*;
import com.usp.app.repository.Queries;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;

/**
 * Serviço responsável pela lógica de negócio relacionada a consultas de leitura.
 * Atua como camada intermediária entre os handlers e o repositório de queries.
 */
@Service
public class GetQueriesService {

    private final Queries repo;

    /**
     * Construtor do serviço de queries.
     *
     * @param repo Repositório de queries para acesso aos dados
     */
    public GetQueriesService(Queries repo) {
        this.repo = repo;
    }

    /**
     * Busca hospitais filtrados por central estadual e status de órgãos.
     *
     * @param centralEstadual Sigla do estado (UF) para filtrar hospitais (opcional)
     * @param status Status dos órgãos para contagem (opcional)
     * @return Flux contendo lista de hospitais com contagem de órgãos disponíveis
     */
    public Flux<Consulta1HospitalDTO> hospitaisPorEstadoEStatus(String centralEstadual, String status) {
        return repo.consultaHospitaisPorEstadoEStatus(centralEstadual, status);
    }

    /**
     * Busca transportes de órgãos entre hospitais com filtros opcionais.
     *
     * @param origemLike Nome (ou parte) do hospital de origem (opcional)
     * @param destinoLike Nome (ou parte) do hospital de destino (opcional)
     * @param apenasConcluidos Se true, retorna apenas transportes concluídos
     * @return Flux contendo lista de transportes com suas informações
     */
    public Flux<Consulta4TransporteDTO> transportesEntreHospitais(
            String origemLike,
            String destinoLike,
            boolean apenasConcluidos
    ) {
        return repo.consultaTransportesEntreHospitais(origemLike, destinoLike, apenasConcluidos);
    }
}

