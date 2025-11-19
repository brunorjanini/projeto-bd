CREATE TABLE Historico_Clinico (
    id_pessoa INTEGER PRIMARY KEY,
    doenca VARCHAR(100) NOT NULL,
    CONSTRAINT FK_Historico_Doador FOREIGN KEY (id_pessoa)
        REFERENCES Doador (id_pessoa)
        ON DELETE CASCADE -- Se o Doador for removido, seu histórico também será.
);