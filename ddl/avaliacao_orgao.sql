CREATE TABLE Avaliacao_Orgao (
    id_medico INTEGER,
    id_orgao INTEGER,
    data_hora TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_Avaliacao_Orgao PRIMARY KEY (id_medico, id_orgao, data_hora),

    CONSTRAINT FK_Avaliacao_Medico FOREIGN KEY (id_medico)
        REFERENCES Profissional (id_pessoa)
        ON DELETE CASCADE,

    CONSTRAINT FK_Avaliacao_Orgao FOREIGN KEY (id_orgao)
        REFERENCES Orgao_Tecido (id_orgao)
        ON DELETE cascade,
);