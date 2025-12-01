package com.usp.app.repository;

import com.usp.app.dto.*;
import org.springframework.r2dbc.core.DatabaseClient;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

/**
 * Repositório responsável por executar consultas de leitura no banco de dados.
 * Utiliza R2DBC para operações reativas e não bloqueantes.
 */
@Repository
public class Queries {

    private final DatabaseClient client;

    /**
     * Construtor do repositório de queries.
     *
     * @param client Cliente R2DBC para execução de queries no banco de dados
     */
    public Queries(DatabaseClient client) {
        this.client = client;
    }

    /**
     * Consulta hospitais filtrados por estado (Central Estadual) e status de órgãos disponíveis.
     * Retorna o nome do hospital, cidade e a quantidade total de órgãos disponíveis.
     *
     * @param centralEstadual Sigla do estado (UF) da central estadual para filtrar hospitais (opcional)
     * @param statusOrgao Status dos órgãos para contagem (ex: "Disponível", "Em Transporte", "Transplantado") (opcional)
     * @return Flux contendo lista de hospitais com suas respectivas quantidades de órgãos
     */
    public Flux<Consulta1HospitalDTO> consultaHospitaisPorEstadoEStatus(
            String centralEstadual,
            String statusOrgao) {
        boolean filtraStatus = statusOrgao != null && !statusOrgao.isBlank();
        boolean filtraCentral = centralEstadual != null && !centralEstadual.isBlank();

        String sql = String.format("""
                SELECT
                    H.nome   AS nome_hospital,
                    H.cidade AS cidade,
                    COUNT(OT.id_doador) AS total_orgaos_disponiveis
                FROM (
                    SELECT id_doador
                    FROM Orgao_Tecido
                    %s
                ) OT
                JOIN Paciente P
                    ON OT.id_doador = P.id_pessoa
                RIGHT JOIN (
                    SELECT id_hospital, nome, cidade
                    FROM Hospital
                    %s
                ) H
                    ON P.id_hospital = H.id_hospital
                GROUP BY H.nome, H.cidade
                ORDER BY total_orgaos_disponiveis DESC
                """,
                filtraStatus ? "WHERE status = :statusOrgao" : "",
                filtraCentral ? "WHERE Central_Estadual = :centralEstadual" : "");

        DatabaseClient.GenericExecuteSpec spec = client.sql(sql);

        // se os filtros foram fornecidos, faz o bind dos parâmetros
        if (filtraStatus) {
            spec = spec.bind("statusOrgao", statusOrgao);
        }
        if (filtraCentral) {
            spec = spec.bind("centralEstadual", centralEstadual);
        }

        System.out.println("SQL hospitais = " + sql);
        System.out.println("central = [" + centralEstadual + "], status = [" + statusOrgao + "]");

        return spec
                .map((row, meta) -> new Consulta1HospitalDTO(
                        row.get("nome_hospital", String.class),
                        row.get("cidade", String.class),
                        row.get("total_orgaos_disponiveis", Long.class)))
                .all();
    }

    /**
     * Consulta transportes de órgãos entre hospitais com filtros opcionais.
     * Retorna informações sobre o órgão transportado, hospitais de origem e destino,
     * centro de transporte responsável e tempo de trânsito em horas.
     *
     * @param nomeHospitalOrigem Nome (ou parte do nome) do hospital de origem para filtro (opcional)
     * @param nomeHospitalDestino Nome (ou parte do nome) do hospital de destino para filtro (opcional)
     * @param apenasConcluidos Se true, retorna apenas transportes já concluídos (com data de chegada); 
     *                         se false ou null, retorna todos os transportes
     * @return Flux contendo lista de transportes com suas respectivas informações
     */
    public Flux<Consulta4TransporteDTO> consultaTransportesEntreHospitais(
            String nomeHospitalOrigem,
            String nomeHospitalDestino,
            Boolean apenasConcluidos) {
        StringBuilder sql = new StringBuilder("""
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
                WHERE 1=1
                """);

        boolean temFiltroOrigem = nomeHospitalOrigem != null && !nomeHospitalOrigem.isBlank();
        boolean temFiltroDestino = nomeHospitalDestino != null && !nomeHospitalDestino.isBlank();

        // adiciona filtros conforme parâmetros fornecidos

        if (temFiltroOrigem) {
            sql.append(" AND HA.nome ILIKE :hospitalOrigem ");
        }
        if (temFiltroDestino) {
            sql.append(" AND HB.nome ILIKE :hospitalDestino ");
        }
        if (Boolean.TRUE.equals(apenasConcluidos)) {
            sql.append(" AND T.data_hora_chegada IS NOT NULL ");
        }

        sql.append(" ORDER BY tempo_transito_horas DESC ");

        DatabaseClient.GenericExecuteSpec spec = client.sql(sql.toString());

        if (temFiltroOrigem) {
            spec = spec.bind("hospitalOrigem", "%" + nomeHospitalOrigem + "%");
        }
        if (temFiltroDestino) {
            spec = spec.bind("hospitalDestino", "%" + nomeHospitalDestino + "%");
        }

        return spec
                .map((row, meta) -> new Consulta4TransporteDTO(
                        row.get("id_orgao", Long.class),
                        row.get("tipo_orgao", String.class),
                        row.get("hospital_origem", String.class),
                        row.get("hospital_destino", String.class),
                        row.get("centro_transporte", String.class),
                        row.get("serial_gps", String.class),
                        row.get("tempo_transito_horas", Double.class)))
                .all();
    }
}
