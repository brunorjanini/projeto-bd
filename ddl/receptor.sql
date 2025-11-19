
CREATE TABLE Receptor (
    id_pessoa INTEGER,
    data_inscricao DATE  not null default CURRENT_DATE,
    num_transplantes INTEGER DEFAULT 0,
    CONSTRAINT PK_Receptor PRIMARY KEY (id_pessoa),    

    CONSTRAINT FK_Receptor_Paciente FOREIGN KEY (id_pessoa)
        REFERENCES Paciente (id_pessoa)
        ON DELETE CASCADE -- Se o registro do Paciente for deletado, este também será.
);
