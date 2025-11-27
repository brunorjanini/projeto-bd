CREATE TABLE Fila (
    nome VARCHAR(50) PRIMARY KEY,
    CONSTRAINT FK_Fila_Tipo FOREIGN KEY (nome)
        REFERENCES Tipo_Orgao_Tecido (nome)
        ON DELETE CASCADE -- Se o tipo de órgão deixar de existir, a fila também é removida.
);
