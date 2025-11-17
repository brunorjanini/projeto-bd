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

CREATE TABLE Avaliacao_orgao_Enfermeiro (
  
);