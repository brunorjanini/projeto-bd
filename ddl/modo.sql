CREATE TABLE Modo (
    id_pessoa INTEGER PRIMARY KEY,
    modo CHAR(1) NOT NULL,

    CONSTRAINT FK_Modo_Paciente FOREIGN KEY (id_pessoa)
        REFERENCES Paciente (id_pessoa)
        ON DELETE CASCADE, -- Se o registro do Paciente for deletado, este também será.
    -- Validar os valores permitidos para 'modo'
    CONSTRAINT CK_Modo_Valores CHECK (modo IN ('r', 'd'))
);c