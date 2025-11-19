CREATE TABLE Profissional (
    id_pessoa INTEGER,
    profissao VARCHAR(50) NOT NULL, -- Ex: 'Médico', 'Enfermeiro', 'Assistente Social'
    COREN VARCHAR(20),              -- Registro de enfermagem (pode ser NULL se for médico)
    CRM VARCHAR(20),                -- Registro médico (pode ser NULL se for enfermeiro)
    id_hospital INTEGER NOT NULL,
    participacao_opo BOOLEAN DEFAULT FALSE,
    participacao_cihdott BOOLEAN DEFAULT FALSE,

    CONSTRAINT PK_Profissional primary key (id_pessoa),
    
    CONSTRAINT FK_Profissional_Pessoa FOREIGN KEY (id_pessoa)
        REFERENCES Pessoa (id_pessoa)
        ON DELETE CASCADE,

    CONSTRAINT FK_Profissional_Hospital FOREIGN KEY (id_hospital)
        REFERENCES Hospital (id_hospital)
        ON DELETE CASCADE,

    -- Validar os tipos de profissão permitidos
    CONSTRAINT CK_Profissao_Valores CHECK (UPPER(profissao) IN ('MÉDICO', 'ENFERMEIRO', 'OUTROS')),

    -- Regra de negócio para documentos
    CONSTRAINT CK_Profissional_Documento CHECK (
        (UPPER(profissao) = 'MÉDICO' AND CRM IS NOT NULL) OR
        (UPPER(profissao) = 'ENFERMEIRO' AND COREN IS NOT NULL) OR
        (UPPER(profissao) = 'OUTROS')
    )
);
c