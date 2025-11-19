CREATE TABLE Centro_Transporte (
    id_centro_transporte SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    CNPJ CHAR(18) NOT NULL UNIQUE, -- Formato: XX.XXX.XXX/YYYY-ZZ
    rua VARCHAR(100),
    numero VARCHAR(10),
    bairro VARCHAR(50),
    cidade VARCHAR(50),
    estado CHAR(2),
    -- '^[A-Z]{2}$' obriga ter exatamente 2 letras maiúsculas do início ao fim.
  CONSTRAINT CK_Estado_Formato CHECK (estado ~ '^[A-Z]{2}$')
);