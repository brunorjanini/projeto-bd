CREATE TABLE Central_Estadual (
  nome VARCHAR(100) NOT NULL,
  estado CHAR(2),
  numero VARCHAR(11),
  rua VARCHAR(100),
  bairro VARCHAR(100),
  cidade VARCHAR(100),
  CONSTRAINT PK_CENTRAL_ESTADUAL PRIMARY KEY(estado)
  -- '^[A-Z]{2}$' obriga ter exatamente 2 letras maiúsculas do início ao fim.
  CONSTRAINT CK_Estado_Formato CHECK (estado ~ '^[A-Z]{2}$')
);