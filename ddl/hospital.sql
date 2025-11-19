CREATE TABLE Hospital (
    id_hospital SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    CNPJ CHAR(18) NOT NULL UNIQUE, -- Formato: XX.XXX.XXX/YYYY-ZZ
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    rua VARCHAR(100),
    numero VARCHAR(10),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado CHAR(2),
    Central_Estadual CHAR(2) NOT NULL,

    CONSTRAINT FK_Hospital_Central FOREIGN KEY (Central_Estadual)
        REFERENCES Central_Estadual (estado)
        ON DELETE RESTRICT -- Impede deletar uma Central se ela tiver hospitais
    -- Impede que um hospital no 'RJ' seja cadastrado na central de 'SP'.
    CONSTRAINT CK_Hospital_Estado_Coerente CHECK (estado = Central_Estadual)
);