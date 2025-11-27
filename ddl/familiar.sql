CREATE TABLE Familiar (
    id_pessoa INTEGER PRIMARY KEY,

    CONSTRAINT FK_Familiar_Pessoa FOREIGN KEY (id_pessoa)
        REFERENCES pessoa (id_pessoa)
        ON DELETE CASCADE -- Se a Pessoa for excluída, deixa de ser Familiar automaticamente.
);