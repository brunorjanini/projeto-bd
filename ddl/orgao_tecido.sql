CREATE TABLE Orgao_Tecido (
    id_orgao SERIAL PRIMARY KEY,
    id_doador INTEGER NOT NULL,
    tipo_orgao VARCHAR(50) NOT NULL,
    data_captacao TIMESTAMP NOT NULL,
    
    -- Status atual do órgão (ex: 'Disponível', 'Em Transporte', 'Transplantado')
    status VARCHAR(20) NOT NULL DEFAULT 'Disponível',
    -- Status da validação/avaliação clínica (Default: Não Avaliado) Pode ser: não avaliado, aprovado ou reprovado
    validade VARCHAR(20) NOT NULL DEFAULT 'Não Avaliado',


    -- FK para Doador
    CONSTRAINT FK_Orgao_Doador FOREIGN KEY (id_doador)
        REFERENCES Doador (id_pessoa)
        ON DELETE CASCADE, -- Se o doador for removido (erro de cadastro), os órgãos somem.

    -- FK para Tipo de Órgão
    CONSTRAINT FK_Orgao_Tipo FOREIGN KEY (tipo_orgao)
        REFERENCES Tipo_Orgao_Tecido (nome)
        ON DELETE RESTRICT -- Não pode deletar o tipo 'Rim' se existirem rins cadastrados.
        
         -- Regra 1: Validar Status Logístico
    CONSTRAINT CK_Orgao_Status CHECK (status IN ('Disponível', 'Em Transporte', 'Transplantado')),

    -- Regra 2: Validar Parecer da Avaliação (Validade)
    CONSTRAINT CK_Orgao_Validade CHECK (validade IN ('Não Avaliado', 'Aprovado', 'Reprovado'))
);c