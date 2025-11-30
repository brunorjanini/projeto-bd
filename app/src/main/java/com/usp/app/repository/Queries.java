package com.usp.app.repository;

import com.usp.app.dto.*;
import org.springframework.r2dbc.core.DatabaseClient;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

@Repository
public class Queries {

    private final DatabaseClient client;

    public Queries(DatabaseClient client) {
        this.client = client;
    }

    public Flux<Consulta1HospitalDTO> consultaHospitaisPorEstadoEStatus(
            String centralEstadual,
            String statusOrgao
    ) {
        String sql = """
            SELECT
                H.nome   AS nome_hospital,
                H.cidade AS cidade,
                COUNT(OT.id_orgao) AS total_orgaos_disponiveis
            FROM Hospital H
            LEFT JOIN Paciente P
                ON H.id_hospital = P.id_hospital
            LEFT JOIN Doador D
                ON P.id_pessoa = D.id_pessoa
            LEFT JOIN Orgao_Tecido OT
                ON D.id_pessoa = OT.id_doador
               AND OT.status = :statusOrgao
            WHERE H.Central_Estadual = :centralEstadual
            GROUP BY H.nome, H.cidade
            ORDER BY total_orgaos_disponiveis DESC
            """;

        return client.sql(sql)
                .bind("statusOrgao", statusOrgao)
                .bind("centralEstadual", centralEstadual)
                .map((row, meta) -> new Consulta1HospitalDTO(
                        row.get("nome_hospital", String.class),
                        row.get("cidade", String.class),
                        row.get("total_orgaos_disponiveis", Long.class)
                ))
                .all();
    }

    public Flux<Consulta2ProfissionalSemPacienteDTO> consultaProfissionaisDeHospitaisSemPacientes() {
        String sql = """
            SELECT
                P.nome AS nome_profissional,
                P.cpf  AS cpf_profissional,
                H.nome AS nome_hospital
            FROM Pessoa P
            JOIN Profissional PR ON P.id_pessoa = PR.id_pessoa
            JOIN Hospital H      ON PR.id_hospital = H.id_hospital
            WHERE PR.id_hospital NOT IN (
                SELECT DISTINCT id_hospital
                FROM Paciente
            )
            ORDER BY H.nome, P.nome
            """;

        return client.sql(sql)
                .map((row, meta) -> new Consulta2ProfissionalSemPacienteDTO(
                        row.get("nome_profissional", String.class),
                        row.get("cpf_profissional", String.class),
                        row.get("nome_hospital", String.class)
                ))
                .all();
    }

    public Flux<Consulta3ReceptorFilaDTO> consultaReceptoresComMaisDeNTransplantesEmFila(
            int minTransplantes
    ) {
        String sql = """
            SELECT
                P.nome AS nome_receptor,
                PA.tipo_sanguineo || PA.fator_rh AS tipo_sanguineo,
                R.num_transplantes AS total_transplantes
            FROM Pessoa P
            JOIN Receptor R ON P.id_pessoa = R.id_pessoa
            JOIN Paciente PA ON R.id_pessoa = PA.id_pessoa
            WHERE
                R.num_transplantes > :minTransplantes
                AND EXISTS (
                    SELECT 1
                    FROM Historico_Fila HF
                    WHERE HF.id_pessoa = R.id_pessoa
                      AND HF.data_hora = (
                          SELECT MAX(HF_INNER.data_hora)
                          FROM Historico_Fila HF_INNER
                          WHERE HF_INNER.id_pessoa = HF.id_pessoa
                          GROUP BY HF_INNER.id_pessoa
                      )
                )
            ORDER BY R.num_transplantes DESC
            """;

        return client.sql(sql)
                .bind("minTransplantes", minTransplantes)
                .map((row, meta) -> new Consulta3ReceptorFilaDTO(
                        row.get("nome_receptor", String.class),
                        row.get("tipo_sanguineo", String.class),
                        row.get("total_transplantes", Integer.class)
                ))
                .all();
    }

    public Flux<Consulta4TransporteDTO> consultaTransportesEntreHospitais(
            String nomeHospitalOrigemLike,
            String nomeHospitalDestinoLike,
            boolean apenasConcluidos
    ) {
        String baseSql = """
            SELECT
                OT.id_orgao AS id_orgao,
                OT.tipo_orgao AS tipo_orgao,
                HA.nome AS hospital_origem,
                HB.nome AS hospital_destino,
                CT.nome AS centro_transporte,
                T.dispositivo_gps AS serial_gps,
                EXTRACT(EPOCH FROM (T.data_hora_chegada - T.data_hora_saida)) / 3600
                    AS tempo_transito_horas
            FROM Transporte T
            JOIN Orgao_Tecido OT
                ON T.id_orgao = OT.id_orgao
            JOIN Hospital HA
                ON T.id_hospital_origem = HA.id_hospital
            JOIN Hospital HB
                ON T.id_hospital_destino = HB.id_hospital
            JOIN Centro_Transporte CT
                ON T.id_centro_transporte = CT.id_centro_transporte
            WHERE
                HA.nome LIKE :hospitalOrigem
                AND HB.nome LIKE :hospitalDestino
            """;

        StringBuilder sql = new StringBuilder(baseSql);
        if (apenasConcluidos) {
            sql.append(" AND T.data_hora_chegada IS NOT NULL ");
        }
        sql.append(" ORDER BY tempo_transito_horas DESC ");

        return client.sql(sql.toString())
                .bind("hospitalOrigem", nomeHospitalOrigemLike)
                .bind("hospitalDestino", nomeHospitalDestinoLike)
                .map((row, meta) -> new Consulta4TransporteDTO(
                        row.get("id_orgao", Long.class),
                        row.get("tipo_orgao", String.class),
                        row.get("hospital_origem", String.class),
                        row.get("hospital_destino", String.class),
                        row.get("centro_transporte", String.class),
                        row.get("serial_gps", String.class),
                        row.get("tempo_transito_horas", Double.class)
                ))
                .all();
    }

    public Flux<Consulta5ProfissionalDivisaoDTO> consultaProfissionaisQueAvaliaramTodosTipos(
            String profissao
    ) {
        String sql = """
            SELECT
                P.nome AS nome_profissional,
                P.cpf  AS cpf,
                PR.profissao AS profissao
            FROM Pessoa P
            JOIN Profissional PR ON P.id_pessoa = PR.id_pessoa
            WHERE
                PR.profissao = :profissao
                AND NOT EXISTS (
                    SELECT NOME
                    FROM Tipo_Orgao_Tecido TOT
                    EXCEPT
                    SELECT DISTINCT OT.tipo_orgao
                    FROM Avaliacao_Orgao AO
                    JOIN Orgao_Tecido OT ON AO.id_orgao = OT.id_orgao
                    WHERE AO.id_medico = PR.id_pessoa
                )
            ORDER BY P.nome
            """;

        return client.sql(sql)
                .bind("profissao", profissao)
                .map((row, meta) -> new Consulta5ProfissionalDivisaoDTO(
                        row.get("nome_profissional", String.class),
                        row.get("cpf", String.class),
                        row.get("profissao", String.class)
                ))
                .all();
    }
}

