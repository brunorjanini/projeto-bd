CREATE TABLE Pessoa_Tipo (
    id_pessoa INTEGER NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Pessoa_Tipo PRIMARY KEY (id_pessoa, tipo),
    CONSTRAINT FK_Pessoa_Tipo_Pessoa FOREIGN KEY (id_pessoa)
        REFERENCES Pessoa (id_pessoa)
        ON DELETE cascade,
   	CONSTRAINT CK_Pessoa_Tipo_Valores CHECK (tipo IN ('fa', 'pa', 'pr'))
);