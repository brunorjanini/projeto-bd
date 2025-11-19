CREATE TABLE Doador (
    id_pessoa INTEGER,
    data_obito DATE,
    CONSTRAINT PK_DOADOR PRIMARY KEY (id_pessoa),    

    CONSTRAINT FK_Doador_Paciente FOREIGN KEY (id_pessoa)
        REFERENCES Paciente (id_pessoa)
        ON DELETE CASCADE 
);
