CREATE TABLE Avaliacao_Orgao_Enfermeiro (
    id_medico INTEGER,
    id_orgao INTEGER,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_enfermeiro INTEGER,

    CONSTRAINT PK_Avaliacao_Enfermeiro PRIMARY KEY (id_medico, id_orgao, data_hora, id_enfermeiro),

    CONSTRAINT FK_Avaliacao_Enf_Medico FOREIGN KEY (id_medico)
        REFERENCES Profissional (id_pessoa)
        ON DELETE CASCADE,

    CONSTRAINT FK_Avaliacao_Enf_Orgao FOREIGN KEY (id_orgao)
        REFERENCES Orgao_Tecido (id_orgao)
        ON DELETE CASCADE,

    CONSTRAINT FK_Avaliacao_Enf_Enfermeiro FOREIGN KEY (id_enfermeiro)
        REFERENCES Profissional (id_pessoa)
        ON DELETE CASCADE
);