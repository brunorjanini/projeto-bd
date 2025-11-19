CREATE TABLE Historico_Fila (
    nome VARCHAR(50),
    id_pessoa INTEGER ,
    posicao INTEGER NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_Historico_Fila PRIMARY KEY (nome, id_pessoa, data_hora),
    
    CONSTRAINT FK_Historico_Fila_Nome FOREIGN KEY (nome)
        REFERENCES Fila (nome)
        ON DELETE CASCADE,
  
    CONSTRAINT FK_Historico_Fila_Receptor FOREIGN KEY (id_pessoa)
        REFERENCES Receptor (id_pessoa)
        ON DELETE CASCADE
);