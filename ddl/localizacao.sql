CREATE TABLE Localizacao (
    id_orgao INTEGER,
    id_receptor INTEGER ,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    coordenada VARCHAR(100) NOT NULL,

    CONSTRAINT PK_Localizacao PRIMARY KEY (id_orgao, id_receptor, data_hora),

    CONSTRAINT FK_Localizacao_Transporte FOREIGN KEY (id_orgao, id_receptor)
        REFERENCES Transporte (id_orgao, id_receptor)
        ON DELETE CASCADE
);
