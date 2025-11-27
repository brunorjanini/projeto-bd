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

CREATE TABLE Dispositivo_GPS (
    serial VARCHAR(50) PRIMARY KEY,
    Central_Estadual CHAR(2) NOT NULL,
    id_centro_transporte INTEGER NOT NULL,

    CONSTRAINT FK_GPS_Central FOREIGN KEY (Central_Estadual)
        REFERENCES Central_Estadual (estado)
        ON DELETE RESTRICT,

    CONSTRAINT FK_GPS_Centro FOREIGN KEY (id_centro_transporte)
        REFERENCES Centro_Transporte (id_centro_transporte)
        ON DELETE CASCADE -- Se o centro de transporte fechar, os dispositivos são desvinculados ou deletados.
);

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

CREATE TABLE Pessoa (
    id_pessoa SERIAL,
    nome VARCHAR(100) NOT NULL,
    CPF CHAR(14) NOT NULL,
    dataNasc DATE,
    telefone VARCHAR(20),
    email VARCHAR(100),
    rua VARCHAR(100),
    numero VARCHAR(10),
    bairro VARCHAR(50),
    cidade VARCHAR(50),
    estado CHAR(2),
    CONSTRAINT PK_PESSOA PRIMARY KEY(id_pessoa),
    CONSTRAINT UN_PESSOA UNIQUE(cpf),
    --Verifica se o cpf está no formato xxx.xxx.xxx-xx
    CONSTRAINT CK_CPF CHECK(REGEXP_LIKE(CPF, '[0-9]{3}\.[0-9]{3}\.[0-9]{3}\-[0-9]{2}'))
);

CREATE TABLE Tipo (
    id_pessoa INTEGER NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Pessoa_Tipo PRIMARY KEY (id_pessoa, tipo),
    CONSTRAINT FK_Pessoa_Tipo_Pessoa FOREIGN KEY (id_pessoa)
        REFERENCES Pessoa (id_pessoa)
        ON DELETE cascade,
   	CONSTRAINT CK_Pessoa_Tipo_Valores CHECK (tipo IN ('fa', 'pa', 'pr'))
);

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

CREATE TABLE Modo (
    id_pessoa INTEGER PRIMARY KEY,
    modo CHAR(1) NOT NULL,

    CONSTRAINT FK_Modo_Paciente FOREIGN KEY (id_pessoa)
        REFERENCES Paciente (id_pessoa)
        ON DELETE CASCADE, -- Se o registro do Paciente for deletado, este também será.
    -- Validar os valores permitidos para 'modo'
    CONSTRAINT CK_Modo_Valores CHECK (modo IN ('r', 'd'))
);c

CREATE TABLE Familiar (
    id_pessoa INTEGER PRIMARY KEY,

    CONSTRAINT FK_Familiar_Pessoa FOREIGN KEY (id_pessoa)
        REFERENCES Pessoa (id_pessoa)
        ON DELETE CASCADE -- Se a Pessoa for excluída, deixa de ser Familiar automaticamente.
);

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


CREATE TABLE Receptor (
    id_pessoa INTEGER,
    data_inscricao DATE  not null default CURRENT_DATE,
    num_transplantes INTEGER DEFAULT 0,
    CONSTRAINT PK_Receptor PRIMARY KEY (id_pessoa),    

    CONSTRAINT FK_Receptor_Paciente FOREIGN KEY (id_pessoa)
        REFERENCES Paciente (id_pessoa)
        ON DELETE CASCADE -- Se o registro do Paciente for deletado, este também será.
);

CREATE TABLE Doador (
    id_pessoa INTEGER,
    data_obito DATE,
    CONSTRAINT PK_DOADOR PRIMARY KEY (id_pessoa),    

    CONSTRAINT FK_Doador_Paciente FOREIGN KEY (id_pessoa)
        REFERENCES Paciente (id_pessoa)
        ON DELETE CASCADE 
);

CREATE TABLE Historico_Clinico (
    id_pessoa INTEGER PRIMARY KEY,
    doenca VARCHAR(100) NOT NULL,
    CONSTRAINT FK_Historico_Doador FOREIGN KEY (id_pessoa)
        REFERENCES Doador (id_pessoa)
        ON DELETE CASCADE -- Se o Doador for removido, seu histórico também será.
);

CREATE TABLE Profissional (
    id_pessoa INTEGER,
    profissao VARCHAR(50) NOT NULL, -- Ex: 'Médico', 'Enfermeiro', 'Assistente Social'
    COREN VARCHAR(20),              -- Registro de enfermagem (pode ser NULL se for médico)
    CRM VARCHAR(20),                -- Registro médico (pode ser NULL se for enfermeiro)
    id_hospital INTEGER NOT NULL,
    participacao_opo BOOLEAN DEFAULT FALSE,
    participacao_cihdott BOOLEAN DEFAULT FALSE,

    CONSTRAINT PK_Profissional primary key (id_pessoa),
    
    CONSTRAINT FK_Profissional_Pessoa FOREIGN KEY (id_pessoa)
        REFERENCES Pessoa (id_pessoa)
        ON DELETE CASCADE,

    CONSTRAINT FK_Profissional_Hospital FOREIGN KEY (id_hospital)
        REFERENCES Hospital (id_hospital)
        ON DELETE CASCADE,

    -- Validar os tipos de profissão permitidos
    CONSTRAINT CK_Profissao_Valores CHECK (UPPER(profissao) IN ('MÉDICO', 'ENFERMEIRO', 'OUTROS')),

    -- Regra de negócio para documentos
    CONSTRAINT CK_Profissional_Documento CHECK (
        (UPPER(profissao) = 'MÉDICO' AND CRM IS NOT NULL) OR
        (UPPER(profissao) = 'ENFERMEIRO' AND COREN IS NOT NULL) OR
        (UPPER(profissao) = 'OUTROS')
    )
);
c

CREATE TABLE Fila (
    nome VARCHAR(50) PRIMARY KEY,
    CONSTRAINT FK_Fila_Tipo FOREIGN KEY (nome)
        REFERENCES Tipo_Orgao_Tecido (nome)
        ON DELETE CASCADE -- Se o tipo de órgão deixar de existir, a fila também é removida.
);c

CREATE TABLE Historico_Fila (
    nome VARCHAR(50),
    id_pessoa INTEGER ,
    posicao INTEGER NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_Historico_Fila PRIMARY KEY (nome, id_pessoa, data_hora),
    
    CONSTRAINT FK_Historico_Fila_Nome FOREIGN KEY (nome)
        REFERENCES Fila (nome)
        ON DELETE CASCADE,
  
    CONSTRAINT FK_Historico_Fila_Receptor FOREIGN KEY (id_pessoa)
        REFERENCES Receptor (id_pessoa)
        ON DELETE CASCADE
);

CREATE TABLE Tipo_Orgao_Tecido (
    nome VARCHAR(50) PRIMARY KEY
);

CREATE TABLE Orgao_Tecido (
    id_orgao SERIAL PRIMARY KEY,
    id_doador INTEGER NOT NULL,
    tipo_orgao VARCHAR(50) NOT NULL,
    data_captacao TIMESTAMP NOT NULL,
    
    -- Status atual do órgão (ex: 'Disponível', 'Em Transporte', 'Transplantado')
    status VARCHAR(20) NOT NULL DEFAULT 'Disponível',
    -- Status da validação/avaliação clínica (Default: Não Avaliado) Pode ser: não avaliado, aprovado ou reprovado
    validade VARCHAR(20) NOT NULL DEFAULT 'Não Avaliado',


    -- FK para Doador
    CONSTRAINT FK_Orgao_Doador FOREIGN KEY (id_doador)
        REFERENCES Doador (id_pessoa)
        ON DELETE CASCADE, -- Se o doador for removido (erro de cadastro), os órgãos somem.

    -- FK para Tipo de Órgão
    CONSTRAINT FK_Orgao_Tipo FOREIGN KEY (tipo_orgao)
        REFERENCES Tipo_Orgao_Tecido (nome)
        ON DELETE RESTRICT -- Não pode deletar o tipo 'Rim' se existirem rins cadastrados.
        
         -- Regra 1: Validar Status Logístico
    CONSTRAINT CK_Orgao_Status CHECK (status IN ('Disponível', 'Em Transporte', 'Transplantado')),

    -- Regra 2: Validar Parecer da Avaliação (Validade)
    CONSTRAINT CK_Orgao_Validade CHECK (validade IN ('Não Avaliado', 'Aprovado', 'Reprovado'))
);c

CREATE TABLE Avaliacao_Orgao (
    id_medico INTEGER,
    id_orgao INTEGER,
    data_hora TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_Avaliacao_Orgao PRIMARY KEY (id_medico, id_orgao, data_hora),

    CONSTRAINT FK_Avaliacao_Medico FOREIGN KEY (id_medico)
        REFERENCES Profissional (id_pessoa)
        ON DELETE CASCADE,

    CONSTRAINT FK_Avaliacao_Orgao FOREIGN KEY (id_orgao)
        REFERENCES Orgao_Tecido (id_orgao)
        ON DELETE cascade,
);

CREATE TABLE Avaliacao_Orgao_Enfermeiro (
    id_medico INTEGER,
    id_orgao INTEGER,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_enfermeiro INTEGER,

    CONSTRAINT PK_Avaliacao_Enfermeiro PRIMARY KEY (id_medico, id_orgao, data_hora, id_enfermeiro),

    CONSTRAINT FK_Avaliacao_Enf_Medico FOREIGN KEY (id_medico)
        REFERENCES Profissional (id_pessoa)
        ON DELETE CASCADE,

    CONSTRAINT FK_Avaliacao_Enf_Orgao FOREIGN KEY (id_orgao)
        REFERENCES Orgao_Tecido (id_orgao)
        ON DELETE CASCADE,

    CONSTRAINT FK_Avaliacao_Enf_Enfermeiro FOREIGN KEY (id_enfermeiro)
        REFERENCES Profissional (id_pessoa)
        ON DELETE CASCADE
);

CREATE TABLE Transplante (
    id_orgao INTEGER NOT NULL,
    id_receptor INTEGER NOT NULL,
    data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    grau_prioridade VARCHAR(50),
    status_transplante VARCHAR(50) NOT NULL,

    CONSTRAINT PK_Transplante PRIMARY KEY (id_orgao, id_receptor),

    CONSTRAINT FK_Transplante_Orgao FOREIGN KEY (id_orgao)
        REFERENCES Orgao_Tecido (id_orgao)
        ON DELETE RESTRICT,

    CONSTRAINT FK_Transplante_Receptor FOREIGN KEY (id_receptor)
        REFERENCES Receptor (id_pessoa)
        ON DELETE CASCADE
);

CREATE TABLE Transporte (
    id_orgao INTEGER,
    id_receptor INTEGER,
    data_hora_saida TIMESTAMP NOT NULL,
    data_hora_chegada TIMESTAMP, -- Pode ser NULL se ainda estiver em trânsito
    modal VARCHAR(50), -- Ex: 'Terrestre', 'Aéreo', 'Helicóptero'
    id_centro_transporte INTEGER NOT NULL,
    dispositivo_gps VARCHAR(50),
    id_hospital_origem INTEGER NOT NULL,
    id_hospital_destino INTEGER NOT NULL,

    CONSTRAINT PK_Transporte PRIMARY KEY (id_orgao, id_receptor),

    CONSTRAINT FK_Transporte_Orgao FOREIGN KEY (id_orgao)
        REFERENCES Orgao_Tecido (id_orgao)
        ON DELETE CASCADE,

    CONSTRAINT FK_Transporte_Receptor FOREIGN KEY (id_receptor)
        REFERENCES Receptor (id_pessoa)
        ON DELETE CASCADE,

    CONSTRAINT FK_Transporte_Centro FOREIGN KEY (id_centro_transporte)
        REFERENCES Centro_Transporte (id_centro_transporte)
        ON DELETE RESTRICT,

    CONSTRAINT FK_Transporte_GPS FOREIGN KEY (dispositivo_gps)
        REFERENCES Dispositivo_GPS (serial)
       v ON DELETE SET NULL, -- Se o GPS quebrar/sumir, o registro de transporte continua existindo.

    CONSTRAINT FK_Transporte_Origem FOREIGN KEY (id_hospital_origem)
        REFERENCES Hospital (id_hospital)
        ON DELETE RESTRICT,

    CONSTRAINT FK_Transporte_Destino FOREIGN KEY (id_hospital_destino)
        REFERENCES Hospital (id_hospital)
        ON DELETE RESTRICT
);

CREATE TABLE Localizacao (
    id_orgao INTEGER,
    id_receptor INTEGER ,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    coordenada VARCHAR(100) NOT NULL,

    CONSTRAINT PK_Localizacao PRIMARY KEY (id_orgao, id_receptor, data_hora),

    CONSTRAINT FK_Localizacao_Transporte FOREIGN KEY (id_orgao, id_receptor)
        REFERENCES Transporte (id_orgao, id_receptor)
        ON DELETE CASCADE
);