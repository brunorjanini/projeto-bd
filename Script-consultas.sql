-- CONSULTA 1: Agrupamento com Junção Externa (LEFT JOIN) e Filtro
--
-- Objetivo: Listar todos os Hospitais de São Paulo (SP) e, para cada um, contar quantos
--           órgãos foram captados lá e estão atualmente com o status 'Disponível'.
--           Incluir hospitais que não tiveram órgãos captados ainda (Contagem = 0).

SELECT
    H.nome AS "Nome do Hospital",
    H.cidade AS "Cidade",
    COUNT(OT.id_orgao) AS "Total de Órgãos Disponíveis Captados"
FROM
    Hospital H
-- 1. Junta Hospital (H) com Paciente (P)
LEFT JOIN
    Paciente P ON H.id_hospital = P.id_hospital
-- 2. Junta Paciente (P) com Doador (D) - id_pessoa é a FK/PK em ambas
LEFT JOIN
    Doador D ON P.id_pessoa = D.id_pessoa
-- 3. Junta Doador (D) com Órgão/Tecido (OT)
LEFT JOIN
    Orgao_Tecido OT ON D.id_pessoa = OT.id_doador AND OT.status = 'Disponível'
WHERE
    H.Central_Estadual = 'SP' -- Filtro de Estado
GROUP BY
    H.nome, H.cidade
ORDER BY
    "Total de Órgãos Disponíveis Captados" DESC;


-- CONSULTA 2: Consulta Aninhada NÃO Correlacionada e Junção Interna
--
-- Objetivo: Encontrar o nome e CPF de todos os **Profissionais** que trabalham em um Hospital
--           que não possui **nenhum** Paciente (Doador ou Receptor) em sua base de dados
--           (Ou seja, o hospital está cadastrado, mas está 'vazio' em termos de pacientes).

SELECT
    P.nome AS "Nome do Profissional",
    P.cpf AS "CPF do Profissional",
    H.nome AS "Nome do Hospital"
FROM
    Pessoa P
JOIN
    Profissional PR ON P.id_pessoa = PR.id_pessoa
JOIN
    Hospital H ON PR.id_hospital = H.id_hospital
WHERE
    -- Consulta aninhada NÃO correlacionada: retorna a lista de IDs de Hospitais que possuem pacientes
    PR.id_hospital NOT IN (
        SELECT DISTINCT id_hospital
        FROM Paciente
    )
ORDER BY
    H.nome, P.nome;


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
    -- Consulta Aninhada Correlacionada: Verifica se o Receptor (R.id_pessoa) está ativo em alguma fila.
    AND EXISTS (
        SELECT 1
        FROM Historico_Fila HF
        WHERE HF.id_pessoa = R.id_pessoa
        -- Subconsulta para obter a última posição conhecida do paciente naquela fila
        AND HF.data_hora = (
            SELECT MAX(data_hora)
            FROM Historico_Fila HF_INNER
            WHERE HF_INNER.id_pessoa = HF.id_pessoa
            GROUP BY HF_INNER.id_pessoa
        )
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
    -- Cálculo da diferença em horas (Retorno esperado: 1.0 hora)
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
    T.data_hora_chegada IS NOT NULL -- Apenas transportes concluídos
    -- FILTRO CORRIGIDO: Usa os nomes reais dos hospitais do transporte
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
    P.cpf AS "CPF",
    PR.profissao AS "Profissão"
FROM
    Pessoa P
JOIN
    Profissional PR ON P.id_pessoa = PR.id_pessoa
WHERE
    PR.profissao = 'MÉDICO' -- Apenas médicos fazem a avaliação principal
    AND NOT EXISTS (
        -- Subconsulta 1: Pega todos os tipos de órgãos/tecido
        SELECT NOME
        FROM Tipo_Orgao_Tecido TOT
        EXCEPT
        -- Subconsulta 2: Pega os tipos de órgão/tecido que o Profissional (externo) avaliou
        SELECT DISTINCT OT.tipo_orgao
        FROM Avaliacao_Orgao AO
        JOIN Orgao_Tecido OT ON AO.id_orgao = OT.id_orgao
        WHERE AO.id_medico = PR.id_pessoa -- Correlacionada: verifica o profissional do loop
    )
ORDER BY
    P.nome;