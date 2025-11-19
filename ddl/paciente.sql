CREATE TABLE Paciente (
    id_pessoa INTEGER PRIMARY KEY,
    id_hospital INTEGER NOT NULL,
    tipo_sanguineo VARCHAR(2) NOT NULL,
    fator_rh CHAR(1) NOT NULL,
    status_clinico VARCHAR(50),
    CONSTRAINT FK_Paciente_Pessoa FOREIGN KEY (id_pessoa)
        REFERENCES Pessoa (id_pessoa)
        ON DELETE CASCADE, -- Se a Pessoa é deletada, o registro de Paciente tbm é
    CONSTRAINT FK_Paciente_Hospital FOREIGN KEY (id_hospital)
        REFERENCES Hospital (id_hospital)
        ON DELETE RESTRICT, -- Impede deletar um hospital se ele tiver pacientes
    -- Validar Tipo Sanguíneo
    CONSTRAINT CK_Tipo_Sanguineo CHECK (tipo_sanguineo IN ('A', 'B', 'AB', 'O')),
    -- Validar Fator RH
    CONSTRAINT CK_Fator_RH CHECK (fator_rh IN ('+', '-'))
);
c