CREATE TABLE CentroDeTransporte (
  id_centro_de_transporte SERIAL NOT NULL,
  nome VARCHAR(100) NOT NULL,
  cnpj CHAR(14) NOT NULL,
  numero VARCHAR(11),
  rua VARCHAR(100),
  bairro VARCHAR(100),
  cidade VARCHAR(100),
  estado CHAR(2),
  CONSTRAINT PK_CENTRO_DE_TRANSPORTE PRIMARY KEY(id_centro_de_transporte),
  CONSTRAINT SK_CENTRO_DE_TRANSPORTE UNIQUE(cnpj)
);

CREATE TABLE Central_Estadual (
  nome VARCHAR(100) NOT NULL,
  estado CHAR(2) NOT NULL, 
  numero VARCHAR(11),
  rua VARCHAR(100),
  bairro VARCHAR(100),
  cidade VARCHAR(100),
  CONSTRAINT PK_CENTRAL_ESTADUAL PRIMARY KEY(estado)
);

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

CREATE TABLE Pessoa_Tipo (
    id_pessoa INTEGER NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Pessoa_Tipo PRIMARY KEY (id_pessoa, tipo),
    CONSTRAINT FK_Pessoa_Tipo_Pessoa FOREIGN KEY (id_pessoa)
        REFERENCES Pessoa (id_pessoa)
        ON DELETE cascade,
   	CONSTRAINT CK_Pessoa_Tipo_Valores CHECK (tipo IN ('fa', 'pa', 'pr'))
);

CREATE TABLE Avaliacao_orgao_Enfermeiro (
  
);