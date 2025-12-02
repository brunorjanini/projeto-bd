package com.usp.app.repository;

import com.usp.app.DatabaseErrorUtils;
import com.usp.app.dto.NovoHospitalDTO;
import com.usp.app.dto.RealizarTransplanteDTO;
import org.springframework.r2dbc.core.DatabaseClient;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.reactive.TransactionalOperator;
import reactor.core.publisher.Mono;

/**
 * Repositório responsável por executar comandos de escrita no banco de dados.
 * Inclui operações de inserção e atualização usando R2DBC de forma reativa.
 */
@Repository
public class CommandsRepository {

    private final DatabaseClient client;
    private final TransactionalOperator transactionalOperator;

    /**
     * Construtor do repositório de comandos.
     *
     * @param client                Cliente R2DBC para execução de comandos SQL
     * @param transactionalOperator Operador transacional para gerenciar transações
     *                              reativas
     */
    public CommandsRepository(DatabaseClient client, TransactionalOperator transactionalOperator) {
        this.client = client;
        this.transactionalOperator = transactionalOperator;
    }

    /**
     * Insere um novo hospital no banco de dados.
     *
     * @param dto Objeto contendo os dados do hospital a ser cadastrado
     * @return Mono contendo o número de linhas afetadas pela operação
     */
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

    /**
     * Realiza um transplante completo de forma transacional.
     * Esta operação executa múltiplas ações em uma única transação:
     * <ol>
     * <li>Insere o registro do transplante na tabela Transplante</li>
     * <li>Atualiza o status do órgão para "Transplantado" e validade para
     * "Aprovado"</li>
     * <li>Incrementa o contador de transplantes do receptor</li>
     * <li>Remove o receptor da fila de espera correspondente ao tipo de órgão</li>
     * </ol>
     *
     * @param dto Objeto contendo os dados do transplante (ID do órgão, ID do
     *            receptor e status)
     * @return Mono contendo o número de linhas afetadas pela operação
     * @throws RuntimeException Se houver erro durante a execução do transplante
     */
    public Mono<Long> realizarTransplante(RealizarTransplanteDTO dto) {
        String sql = """
                    WITH novo_transplante AS (
                    INSERT INTO Transplante (
                        id_orgao,
                        id_receptor,
                        data_hora,
                        status_transplante
                    )
                    VALUES (
                        :idOrgao,
                        :idReceptor,
                        CURRENT_TIMESTAMP,
                        :statusTransplante
                    )
                    RETURNING id_orgao, id_receptor
                ),
                atualiza_orgao AS (
                    UPDATE Orgao_Tecido o
                    SET status   = 'Transplantado',
                        validade = 'Aprovado'
                    FROM novo_transplante t
                    WHERE o.id_orgao = t.id_orgao
                    AND o.status = 'Disponível'
                    AND o.validade = 'Aprovado'
                    RETURNING o.id_orgao, t.id_receptor
                ),
                atualiza_receptor AS (
                    UPDATE Receptor r
                    SET num_transplantes = num_transplantes + 1
                    FROM atualiza_orgao a
                    WHERE r.id_pessoa = a.id_receptor
                    RETURNING a.id_orgao, a.id_receptor
                )
                DELETE FROM Historico_Fila hf
                USING atualiza_receptor ar
                WHERE hf.id_pessoa = ar.id_receptor
                  AND hf.nome = (
                      SELECT tipo_orgao
                      FROM Orgao_Tecido o
                      WHERE o.id_orgao = ar.id_orgao
                  )
                    """;

        return client.sql(sql)
                .bind("idOrgao", dto.idOrgao())
                .bind("idReceptor", dto.idReceptor())
                .bind("statusTransplante", dto.statusTransplante())
                .fetch()
                .rowsUpdated()
                .flatMap(rows -> {
                    System.out.println("Linhas afetadas no transplante: " + rows);
                    if (rows == 0) {
                        return Mono.error(new IllegalStateException(
                                "Receptor não está na fila para o tipo de órgão informado"));
                    }
                    return Mono.just(rows);
                })
                .as(transactionalOperator::transactional) // faz COMMIT e ROLLBACK (se der erro)
                .onErrorResume(error -> {
                    String msg = DatabaseErrorUtils.extractMessage(error);

                    return Mono.error(new RuntimeException(
                            msg,
                            error));
                });
    }
}
