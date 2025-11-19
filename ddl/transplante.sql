CREATE TABLE Transplante (
    id_orgao INTEGER NOT NULL,
    id_receptor INTEGER NOT NULL,
    data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    grau_prioridade VARCHAR(50),
    status_transplante VARCHAR(50) NOT NULL,

    CONSTRAINT PK_Transplante PRIMARY KEY (id_orgao, id_receptor),

    CONSTRAINT FK_Transplante_Orgao FOREIGN KEY (id_orgao)
        REFERENCES Orgao_Tecido (id_orgao)
        ON DELETE RESTRICT,

    CONSTRAINT FK_Transplante_Receptor FOREIGN KEY (id_receptor)
        REFERENCES Receptor (id_pessoa)
        ON DELETE CASCADE
);