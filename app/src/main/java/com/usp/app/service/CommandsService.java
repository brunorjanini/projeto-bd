package com.usp.app.service;

import com.usp.app.dto.NovoHospitalDTO;
import com.usp.app.dto.RealizarTransplanteDTO;
import com.usp.app.repository.CommandsRepository;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

/**
 * Serviço responsável pela lógica de negócio relacionada a comandos de escrita.
 * Atua como camada intermediária entre os handlers e o repositório de comandos.
 */
@Service
public class CommandsService {

    private final CommandsRepository repo;

    /**
     * Construtor do serviço de comandos.
     *
     * @param repo Repositório de comandos para operações de escrita no banco
     */
    public CommandsService(CommandsRepository repo) {
        this.repo = repo;
    }

    /**
     * Cria um novo hospital no sistema.
     *
     * @param dto Objeto contendo os dados do hospital a ser cadastrado
     * @return Mono vazio que completa quando a operação é finalizada
     */
    public Mono<Void> criarHospital(NovoHospitalDTO dto) {
        return repo.inserirHospital(dto).then();
    }

    /**
     * Realiza um transplante completo no sistema.
     * Esta operação é transacional e inclui:
     * inserção do transplante, atualização do órgão,
     * incremento do contador do receptor e remoção da fila.
     *
     * @param dto Objeto contendo os dados do transplante
     * @return Mono vazio que completa quando a operação é finalizada
     */
    public Mono<Void> realizarTransplante(RealizarTransplanteDTO dto) {
        return repo.realizarTransplante(dto).then();
    }
}
