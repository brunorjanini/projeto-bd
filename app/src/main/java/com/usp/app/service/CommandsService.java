package com.usp.app.service;

import com.usp.app.dto.AtualizarNumTransplantesDTO;
import com.usp.app.dto.NovaAvaliacaoOrgaoDTO;
import com.usp.app.dto.NovoHistoricoFilaDTO;
import com.usp.app.dto.NovoHospitalDTO;
import com.usp.app.dto.NovoOrgaoDTO;
import com.usp.app.repository.CommandsRepository;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
public class CommandsService {

    private final CommandsRepository repo;

    public CommandsService(CommandsRepository repo) {
        this.repo = repo;
    }

    public Mono<Void> criarHospital(NovoHospitalDTO dto) {
        return repo.inserirHospital(dto).then();
    }

    public Mono<Void> criarOrgao(NovoOrgaoDTO dto) {
        return repo.inserirOrgao(dto).then();
    }

    public Mono<Void> criarAvaliacaoOrgao(NovaAvaliacaoOrgaoDTO dto) {
        return repo.inserirAvaliacaoOrgao(dto).then();
    }

    public Mono<Void> criarHistoricoFila(NovoHistoricoFilaDTO dto) {
        return repo.inserirHistoricoFila(dto).then();
    }

    public Mono<Void> atualizarNumTransplantes(Integer idPessoa, AtualizarNumTransplantesDTO dto) {
        return repo.atualizarNumTransplantes(idPessoa, dto).then();
    }
}
