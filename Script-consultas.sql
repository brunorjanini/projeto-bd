-- CONSULTA 1: Agrupamento com Junção Externa (LEFT JOIN) e Filtro
--
-- Objetivo: Listar todos os Hospitais de São Paulo (SP) e, para cada um, contar quantos
--           órgãos foram captados lá e estão atualmente com o status 'Disponível'.
--           Incluir hospitais que não tiveram órgãos captados ainda (Contagem = 0).

SELECT H.id_hospital, H.nome, H.cidade, COUNT(id_doador) AS "Total de Órgãos Disponíveis Captados"
FROM (
    SELECT id_doador
    FROM Orgao_Tecido 
    WHERE status = 'Disponível'
) OT 
JOIN Paciente P
ON OT.id_doador =  P.id_pessoa
RIGHT JOIN (
    SELECT id_hospital, nome, cidade
    FROM Hospital
    WHERE Central_Estadual = 'SP'
) H
ON P.id_hospital = H.id_hospital
GROUP BY H.id_hospital, H.nome, H.cidade;


-- CONSULTA 2: Consulta Aninhada NÃO Correlacionada e Junção Interna
--
-- Objetivo: Encontrar o nome e CPF de todos os **Profissionais** que trabalham em um Hospital
--           que não possui **nenhum** Paciente (Doador ou Receptor) em sua base de dados
--           (Ou seja, o hospital está cadastrado, mas está 'vazio' em termos de pacientes).

SELECT
    P.nome AS "Nome do Profissional",
    P.cpf AS "CPF do Profissional"
FROM
    Pessoa P
JOIN
    Profissional PR ON P.id_pessoa = PR.id_pessoa
WHERE
    -- Consulta aninhada NÃO correlacionada: retorna a lista de IDs de Hospitais que possuem pacientes
    PR.id_hospital NOT IN (
        SELECT DISTINCT id_hospital
        FROM Paciente
    )


-- CONSULTA 3: Consulta Aninhada Correlacionada (Uso de EXISTS) e Agrupamento
--
-- Objetivo: Listar o nome e o tipo sanguíneo de **Receptores** que já foram
--           transplantados **mais de uma vez** e que estão em uma **Fila** de espera.

SELECT
    P.nome AS "Nome do Receptor",
    PA.tipo_sanguineo || PA.fator_rh AS "Tipo Sanguíneo",
    R.num_transplantes AS "Total de Transplantes"
FROM
    Pessoa P
JOIN
    Receptor R ON P.id_pessoa = R.id_pessoa
JOIN
    Paciente PA ON R.id_pessoa = PA.id_pessoa
WHERE
    R.num_transplantes > 1
    AND P.id_pessoa IN (
        SELECT id_pessoa
        FROM Historico_Fila HF
    )
ORDER BY
    R.num_transplantes DESC;


-- CONSULTA 4: Consulta com Múltiplas Junções (INNER JOIN) e Expressões de Data/Hora
--
-- Objetivo: Rastrear todos os transportes de órgãos que foram captados no Hospital 'A' e
--           entregues no Hospital 'B', listando o tempo total de trânsito em horas,
--           e as informações do Centro de Transporte e GPS.

SELECT
    OT.id_orgao AS "ID Órgão",
    OT.tipo_orgao AS "Tipo de Órgão",
    HA.nome AS "Hospital de Origem",
    HB.nome AS "Hospital de Destino",
    CT.nome AS "Centro de Transporte",
    T.dispositivo_gps AS "Serial GPS",
    EXTRACT(EPOCH FROM (T.data_hora_chegada - T.data_hora_saida)) / 3600 AS "Tempo de Trânsito (Horas)"
FROM
    Transporte T
JOIN
    Orgao_Tecido OT ON T.id_orgao = OT.id_orgao
JOIN
    Hospital HA ON T.id_hospital_origem = HA.id_hospital
JOIN
    Hospital HB ON T.id_hospital_destino = HB.id_hospital
JOIN
    Centro_Transporte CT ON T.id_centro_transporte = CT.id_centro_transporte
WHERE
    T.data_hora_chegada IS NOT NULL
    AND HA.nome LIKE 'Hospital Vital SP'
    AND HB.nome LIKE 'Hospital Carioca'
ORDER BY
    "Tempo de Trânsito (Horas)" DESC;


-- CONSULTA 5: Implementação de DIVISÃO RELACIONAL (OBRIGATÓRIO)
--
-- Objetivo: Encontrar o nome e CPF dos **Profissionais** que participaram da **avaliação**
--           de **TODOS** os tipos de Órgão/Tecido existentes no sistema.
--
--           Conceito de Divisão: Profissional DIVIDE por Tipo_Orgao_Tecido (Avaliacao_Orgao -> Tipo_Orgao_Tecido)
--           (Retorna profissionais que têm uma tupla em Avaliacao_Orgao para CADA tupla em Tipo_Orgao_Tecido)

SELECT
    P.nome AS "Nome do Profissional",
    P.cpf  AS "CPF",
    PR.profissao AS "Profissão"
FROM Profissional PR
JOIN Pessoa P
    ON P.id_pessoa = PR.id_pessoa
JOIN Avaliacao_Orgao AO
    ON AO.id_medico = PR.id_pessoa
JOIN Orgao_Tecido OT
    ON OT.id_orgao = AO.id_orgao
WHERE
    PR.profissao = 'MÉDICO'
GROUP BY
    P.nome,
    P.cpf,
    PR.profissao,
    PR.id_pessoa
HAVING COUNT(DISTINCT OT.tipo_orgao) = (
    SELECT COUNT(*)
    FROM Tipo_Orgao_Tecido
    )
ORDER BY
    P.nome;