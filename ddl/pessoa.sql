CREATE TABLE Pessoa (
    id_pessoa SERIAL,
    nome VARCHAR(100) NOT NULL,
    CPF CHAR(14) NOT NULL UNIQUE,
    dataNasc DATE,
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    rua VARCHAR(100),
    numero VARCHAR(10),
    bairro VARCHAR(50),
    cidade VARCHAR(50),
    estado CHAR(2),
    CONSTRAINT PK_PESSOA PRIMARY KEY(id_pessoa),
    CONSTRAINT CK_CPF CHECK(REGEXP_LIKE(CPF, '[0-9]{3}\.[0-9]{3}\.[0-9]{3}\-[0-9]{2}'))
);
