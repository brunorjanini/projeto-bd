package com.usp.app.service;


import com.usp.app.dto.*;
import com.usp.app.repository.Queries;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;

@Service
public class GetQueriesService {

    private final Queries repo;

    public GetQueriesService(Queries repo) {
        this.repo = repo;
    }

    public Flux<Consulta1HospitalDTO> hospitaisPorEstadoEStatus(String centralEstadual, String status) {
        return repo.consultaHospitaisPorEstadoEStatus(centralEstadual, status);
    }

    public Flux<Consulta2ProfissionalSemPacienteDTO> profissionaisDeHospitaisSemPacientes() {
        return repo.consultaProfissionaisDeHospitaisSemPacientes();
    }

    public Flux<Consulta3ReceptorFilaDTO> receptoresComMaisDeNTransplantesEmFila(int minTransplantes) {
        return repo.consultaReceptoresComMaisDeNTransplantesEmFila(minTransplantes);
    }

    public Flux<Consulta4TransporteDTO> transportesEntreHospitais(
            String origemLike,
            String destinoLike,
            boolean apenasConcluidos
    ) {
        return repo.consultaTransportesEntreHospitais(origemLike, destinoLike, apenasConcluidos);
    }

    public Flux<Consulta5ProfissionalDivisaoDTO> profissionaisQueAvaliaramTodosTipos(String profissao) {
        return repo.consultaProfissionaisQueAvaliaramTodosTipos(profissao);
    }
}

