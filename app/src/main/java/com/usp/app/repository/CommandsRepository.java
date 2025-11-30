package com.usp.app.repository;

import com.usp.app.dto.AtualizarNumTransplantesDTO;
import com.usp.app.dto.NovaAvaliacaoOrgaoDTO;
import com.usp.app.dto.NovoHistoricoFilaDTO;
import com.usp.app.dto.NovoHospitalDTO;
import com.usp.app.dto.NovoOrgaoDTO;
import org.springframework.r2dbc.core.DatabaseClient;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Mono;

@Repository
public class CommandsRepository {

    private final DatabaseClient client;

    public CommandsRepository(DatabaseClient client) {
        this.client = client;
    }

    public Mono<Long> inserirHospital(NovoHospitalDTO dto) {
        String sql = """
            INSERT INTO Hospital
                (nome, cnpj, telefone, email, rua, numero, bairro, cidade, Central_Estadual)
            VALUES
                (:nome, :cnpj, :telefone, :email, :rua, :numero, :bairro, :cidade, :central)
            """;

        return client.sql(sql)
                .bind("nome", dto.nome())
                .bind("cnpj", dto.cnpj())
                .bind("telefone", dto.telefone())
                .bind("email", dto.email())
                .bind("rua", dto.rua())
                .bind("numero", dto.numero())
                .bind("bairro", dto.bairro())
                .bind("cidade", dto.cidade())
                .bind("central", dto.centralEstadual())
                .fetch()
                .rowsUpdated();
    }

    public Mono<Long> inserirOrgao(NovoOrgaoDTO dto) {
        String sql = """
            INSERT INTO Orgao_Tecido (id_doador, tipo_orgao, status, data_captacao)
            VALUES (:idDoador, :tipoOrgao, :status, :dataCaptacao)
            """;

        return client.sql(sql)
                .bind("idDoador", dto.idDoador())
                .bind("tipoOrgao", dto.tipoOrgao())
                .bind("status", dto.status())
                .bind("dataCaptacao", dto.dataCaptacao())
                .fetch()
                .rowsUpdated();
    }

    public Mono<Long> inserirAvaliacaoOrgao(NovaAvaliacaoOrgaoDTO dto) {
        String sql = """
            INSERT INTO Avaliacao_Orgao (id_medico, id_orgao, data_hora)
            VALUES (:idMedico, :idOrgao, :dataHora)
            """;

        return client.sql(sql)
                .bind("idMedico", dto.idMedico())
                .bind("idOrgao", dto.idOrgao())
                .bind("dataHora", dto.dataHora())
                .fetch()
                .rowsUpdated();
    }

    public Mono<Long> inserirHistoricoFila(NovoHistoricoFilaDTO dto) {
        String sql = """
            INSERT INTO Historico_Fila (nome, id_pessoa, posicao)
            VALUES (:nomeFila, :idPessoa, :posicao)
            """;

        return client.sql(sql)
                .bind("nomeFila", dto.nomeFila())
                .bind("idPessoa", dto.idPessoa())
                .bind("posicao", dto.posicao())
                .fetch()
                .rowsUpdated();
    }

    public Mono<Long> atualizarNumTransplantes(Integer idPessoa, AtualizarNumTransplantesDTO dto) {
        String sql = """
            UPDATE Receptor
            SET num_transplantes = :num
            WHERE id_pessoa = :idPessoa
            """;

        return client.sql(sql)
                .bind("num", dto.numTransplantes())
                .bind("idPessoa", idPessoa)
                .fetch()
                .rowsUpdated();
    }
}
