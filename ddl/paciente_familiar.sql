CREATE TABLE Paciente_Familiar (
    id_paciente INTEGER NOT NULL,
    id_familiar INTEGER NOT NULL,
    parentesco VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Paciente_Familiar PRIMARY KEY (id_paciente, id_familiar),    
    CONSTRAINT FK_PF_Paciente FOREIGN KEY (id_paciente)
        REFERENCES Paciente (id_pessoa)
        ON DELETE CASCADE, -- Se o registro do Paciente for deletado, este também será.
    CONSTRAINT FK_PF_Familiar FOREIGN KEY (id_familiar)
        REFERENCES Familiar (id_pessoa)
        ON DELETE CASCADE -- Se o registro do Paciente for deletado, este também será.
);