-- Inserção em Centro de Transporte --
INSERT INTO Centro_Transporte (
    nome, 
    CNPJ, 
    rua, 
    numero, 
    bairro, 
    cidade, 
    estado
) 
VALUES 
    (
        'Terminal Logístico São Paulo', 
        '12.345.678/0001-90', 
        'Rodovia Anhanguera', 
        'Km 25', 
        'Perus', 
        'São Paulo', 
        'SP'
    ),
    (
        'Centro Logístico Rio de Janeiro', 
        '98.765.432/0001-15', 
        'Estrada do Galeão', 
        'S/N', 
        'Ilha do Governador', 
        'Rio de Janeiro', 
        'RJ'
    );

-- Inserção em Central_Estadual --
insert
	into
	Central_Estadual (nome,
	estado,
	numero,
	rua,
	bairro,
	cidade)
values (
    'Central de Transplantes do Estado de São Paulo',
    'SP',
    '764',
    'Av. Dr. Enéas Carvalho de Aguiar',
    'Cerqueira César',
    'São Paulo'
),
(
    'Central de Transplantes do Estado do Rio de Janeiro',
    'RJ',
    '433',
    'Rua México',
    'Centro',
    'Rio de Janeiro'
);

-- Inserção em Dispositivos de GPS
/*
  1. Devem existir registros em 'Central_Estadual' (usaremos 'SP' e 'RJ').
  2. Devem existir registros em 'Centro_Transporte' (usaremos IDs 1 e 2).
*/
INSERT INTO Dispositivo_GPS (
    serial,
    Central_Estadual,
    id_centro_transporte
) 
VALUES 
    (
        'GPS-X100-PRO',
        'SP',          
        1             
    ),
    (
        'GPS-Z500-LITE', 
        'RJ',           
        2            
    );

-- Inserção em Hospital --
INSERT INTO Hospital (nome, CNPJ, telefone, email, rua, numero, bairro, cidade, Central_Estadual)
/*
  1. Devem existir registros em 'Central_Estadual' (usaremos 'SP' e 'RJ').
*/
VALUES (
    'Hospital das Clínicas da FMUSP',
    '60.448.040/0001-22',
    '(11) 2661-0000',
    'contato@hc.fm.usp.br',
    'Av. Dr. Enéas Carvalho de Aguiar',
    '255',
    'Cerqueira César',
    'São Paulo',
    'SP'
), (
    'Hospital Municipal Souza Aguiar',
    '29.468.055/0001-02',
    '(21) 3111-2000',
    'souzaaguiar@rio.rj.gov.br',
    'Praça da República',
    '111',
    'Centro',
    'Rio de Janeiro',
    'RJ'
);

-- Inserção em Pessoas --
insert
	into
	Pessoa (nome,
	CPF,
	dataNasc,
	telefone,
	email,
	rua,
	numero,
	bairro,
	cidade,
	estado)
values (
'Carlos Eduardo',
'123.456.789-12',
'1985-04-12',
'(11) 99999-1234',
'carlos.eduardo@email.com',
'Rua jardim paulista',
'45',
'Jardim Paulista',
'São Paulo',
'SP'
),
('Bruno Lima',
'555.666.777-88',
'1992-02-28',
'(61)12322-1234',
'bruno@teste.com',
'rua 1',
'bairro 2',
'567' ,
'Belo Horizonte',
'MG'
),
('Ana Maria Souza', 
'123.456.789-00', 
'1992-10-25', 
'(99) 12345-1234',
'ana.souza@email.com', 
'rua numero 3',
'3',
'bairro do rio',
'Rio de Janeiro', 
'RJ'
),
(
'Fernanda Oliveira', 
'987.654.321-10',
'1995-08-12',
'(21) 98888-7777', 
'fernanda.oli@exemplo.com', 
'Avenida Atlântica', 
'1500', 
'Copacabana', 
'Rio de Janeiro', 
'RJ'
),
(
'Maria da Silva', 
'555.444.333-22', 
'1960-08-15', 
'(11) 98888-7777', 
'maria.silva@email.com', 
'Rua das Acácias',
'45B', 
'Jardim Paulista', 
'São Paulo', 
'SP'
),
(
'Roberto Mendes', 
'333.444.555-66',
'1988-03-30', 
'(41) 99123-4567', 
'roberto.mendes@email.com', 
'Rua das Araucárias', 
'405', 
'Centro Cívico', 
'Curitiba', 
'PR'
),
(
'Juliana Costa', 
'777.888.999-00',
'2000-12-25', 
'(61) 99876-5432', 
'juliana.costa@email.com', 
'SQN 302 Bloco A', 
'104', 
'Asa Norte', 
'Brasília', 
'DF'
),
(
'Lucas Pereira', 
'111.222.333-44', 
'1993-07-14', 
'(51) 98888-1111', 
'lucas.pereira@email.com', 
'Av. Ipiranga',
'500',
'Partenon',
'Porto Alegre',
'RS'
),
(
'Amanda Lima', 
'444.555.666-77', 
'1998-02-10', 
'(71) 99777-2222', 
'amanda.lima@email.com', 
'Rua da Graça',
'85',
'Graça',
'Salvador',
'BA'
),
('Ricardo Santos', 
'777.888.999-11', 
'1980-05-25', 
'(92) 99111-3333', 
'ricardo.santos@email.com', 
'Av. Eduardo Ribeiro',
'1200',
'Centro',
'Manaus',
'AM'
),
(
'Beatriz Rocha', 
'000.111.222-33', 
'2001-11-30', 
'(48) 99222-4444', 
'beatriz.rocha@email.com', 
'Rua Bocaiúva',
'310',
'Centro',
'Florianópolis',
'SC'
),
(
'Eduardo Martins', 
'555.999.888-77', 
'1985-09-07', 
'(81) 99666-5555', 
'eduardo.martins@email.com', 
'Rua da Aurora',
'55',
'Santo Amaro',
'Recife',
'PE'
);

-- Inserção em Tipo --
/*
  1. Valores permitidos para tipo: 'fa', 'pa', 'pr'.
  2. Devem existir registros em 'Pessoas' (será usado ID's de 1 a 12).
*/
insert
	into
	Tipo (id_pessoa,
	tipo)
values (1,
'fa'),
(2,
'pa'),
(3,
'pr'),
(4,
'pa'),
(5,
'fa'),
(6,
'pa'),
(7,
'pa'),
(8,
'pr'),
(9,
'pr'),
(10,
'pr'),
(11,
'pr'),
(12,
'pr');

-- Inserção em Paciente --
/*
  1. Devem existir registros em 'Pessoa' (serão usados IDs 2, 4, 6 e 7).
  2. Devem existir registros em 'Hospital' (serão usados IDs 1 e 2).
*/
insert
	into
	Paciente (id_pessoa,
	id_hospital,
	tipo_sanguineo,
	fator_rh,
	status_clinico)
values (
    2,
    1,
    'O',
    '+',
    'Aguardando Transplante Renal'
),
(
    4,
    2,
    'AB',
    '-',
    'Em Avaliação Pré-Operatória'
),
(
6,
2,
'A',
'-',
'Aguardando transplante de coração'),
(7,
1,
'B',
'-',
'Doador de coração');

-- Inserção na tabela Modo
/*
  1. Devem existir registros em 'Paciente' (serão usados IDs 2, 4, 6 e 7).
  2. Modos podem ser: 'r' para receptor (quem vai receber o órgão) e 'd' para doador (quem está doando).
*/
INSERT INTO Modo (id_pessoa, modo)
VALUES (2, 'r'), (4, 'd'), (6, 'r'), (7, 'd');

--  Script de inserção de dados de teste na tabela 'Familiar'.
/*
1. Devem existir registros em 'Pessoa' (serão usados IDs 5 e 1).
*/
INSERT INTO Familiar (id_pessoa)
VALUES (5), (1);

-- Script de inserção de dados de teste na tabela 'Paciente_Familiar'.
/*
  1. Devem existir registros em 'Paciente' (serão usados IDs 2 e 4).
  2. Devem existir registros em 'Familiar' (serão usados IDs 1 e 5).
*/
INSERT INTO Paciente_Familiar (id_paciente, id_familiar, parentesco)
VALUES (2, 1, 'Amigos'), (4, 5, 'Primas');

--  Script de inserção de dados de teste na tabela 'Receptor'.
/*
1. Devem existir registros em 'Receptor' (serão usados IDs 2 e 6).
*/
insert
	into
	Receptor (id_pessoa,
	data_inscricao,
	num_transplantes)
values (
2,
'2023-01-15',
0
),
(6,
'2025-02-12',
1);

-- Script de inserção de dados de teste na tabela 'Doador'.
/*
1. Devem existir registros em 'Doador' (serão usados IDs 4 e 7).
*/
insert
	into
	Doador (id_pessoa,
	data_obito)
values 
(
	4,
	null
),
(
    7, 
    '2023-11-20'
);

--Inserção em histórico clinico
/*
1. Devem existir registros em 'Doador' (serão usados IDs 4 e 7).
*/
INSERT INTO Historico_Clinico (
    id_pessoa, 
    doenca
) 
VALUES 
    (
        4, 
        'Hipertensão Arterial Controlada'
    ),
    (
        7, 
        'Nenhuma comorbidade relatada'
    );

-- Inserção em Profissional
/*
1. Devem existir registros em 'Pessoas' (serão usados IDs 3, 8, 9, 10, 11, 12).
2. profissão pode ser: "MÉDICO", "ENFERMEIRO", "OUTROS".
*/
insert
	into
	Profissional (
    id_pessoa,
	profissao,
	COREN,
	CRM,
	id_hospital,
	participacao_opo,
	participacao_cihdott
)
values 
(
        3,
        'MÉDICO',
        null,
        'CRM/SP 123456',
        1,
        true,
        false
    ),
    (
        8,
        'MÉDICO',
        null,
        'CRM/SP 987654',
        1,
        false,
        true
    ),
    (
        9,
        'ENFERMEIRO',
        'COREN/SP 98765',
        null,
        1,
        false,
        false
    ),
        (
        10,
        'ENFERMEIRO',
        'COREN/SP 987654',
        null,
        1,
        false,
        true
    ),
        (
        11,
        'OUTROS',
		null,
        null,
        1,
        false,
        true
    ),
        (
        12,
        'OUTROS',
        null,
        null,
        1,
        false,
        true
    )
;

-- Inserção em Tipo_Orgao_Tecido
INSERT INTO Tipo_Orgao_Tecido (nome) 
VALUES 
    ('Coração'),
    ('Pulmão'), 
    ('Rim'),
    ('Fígado'),
    ('Córnea'),
    ('Pâncreas');

-- Inserção em Fila
/*
1. Devem existir registros em 'Tipo_Orgao_Tecido' (serão usados "Coração" e "Pulmão").
*/
INSERT INTO Fila (nome) 
VALUES 
    ('Coração'),
    ('Pulmão');

-- Inserção em Historico Fila
/*
1. Devem existir registros em 'Tipo_Orgao_Tecido' (serão usados "Coração" e "Pulmão").
2. Devem existir registros em 'Pessoa' (serão usados Id's 2 e 6).
*/
INSERT INTO Historico_Fila (
    nome, 
    id_pessoa, 
    posicao
) 
VALUES 
    (
        'Pulmão',  -- Deve existir na tabela Fila
        2,      -- Deve existir na tabela Receptor
        1       -- Está em 1º lugar na fila
    ),
    (
        'Coração', 
        6,      -- A mesma pessoa (ID 6) pode estar em outra fila
        1
    );
   
-- Inserção em órgão/tecido
/*
 1. Devem existir registros em 'Doador' (serão usados ID's 4 e 7).
 2. Devem existir registros em 'Tipo_Orgao_Tecido' (serão usados "Coração" e "Pulmão").
*/
INSERT INTO Orgao_Tecido (
    id_doador, 
    tipo_orgao, 
    data_captacao
) 
VALUES 
    (
        4,
        'Rim',
        '2023-10-27 08:30:00' 
    ),
    (
        7, 
        'Coração', 
        '2023-10-27 09:00:00'
    );

-- Inserção em avaliação/órgão
/* 
  1. Devem existir registros em 'Profissionais' (serão usados Ids 3 e 8). A aplicação deve garantir que os Id's referenciam profissionais médicos
  2. Devem existir registros em 'Orgao_Tecido' (serão usados Ids 1 e 2).
*/
INSERT INTO Avaliacao_Orgao (
    id_medico, 
    id_orgao, 
    data_hora
) 
VALUES 
    (
        3,          
        1,         
        DEFAULT    
    ),
    (
        8, 
        2,          
        '2023-10-27 15:30:00' 
    );

-- Inserção em Avaliação_Órgão_Enfermeiro
/* 
  1. Devem existir registros em 'Avaliação órgão' (serão usados as chaves (para id_medico e id_orgão respectivamente){3,1} e {8,2}.
  2. Devem existir registros em 'Profissionais' (serão usados Ids 9 e 10). A aplicação deve garantir que os Ids correspondem a profissionais enfermeiros
*/
INSERT INTO Avaliacao_Orgao_Enfermeiro (
    id_medico, 
    id_orgao, 
    id_enfermeiro, 
    data_hora
) 
VALUES 
    (
        3,          -- ID do Médico responsável
        1,          -- ID do Órgão sendo avaliado (ex: Rim)
        9,          -- ID do Enfermeiro auxiliar
        DEFAULT     -- Data/Hora atual
    ),
    (
        8, 
        2,          -- Outro órgão (ex: Córnea)
        10,          -- O mesmo enfermeiro auxiliando
        '2023-10-27 16:45:00' -- Registro histórico
    );

-- Inserção em transplante
/*
 1. Devem existir registros em 'Receptor' (serão usados ID's 2 e 6).
 2. Devem existir registros em 'Orgao_Tecido' (serão usados "ID's 1 e 2).
*/
INSERT INTO Transplante (
    id_orgao, 
    id_receptor, 
    grau_prioridade, 
    status_transplante,
    data_hora
) 
VALUES 
    (
        1,              
        2,              
        'Urgente',    
        'Realizado',    
        DEFAULT         
    ),
    (
        2,             
        6,              
        'Eletivo',    
        'Agendado',    
        '2023-11-01 08:00:00' 
    );

-- Inserção em transporte
/*
 1. Devem existir registros em 'Transplante' (serão usados as tuplas (1,2) e (2,6) representando Ids de órgão e receptor, respectivamente).
 3. Devem existir registros em 'Centro de transporte' (serão usados ID's 1 e 1).
 4. Devem existir registros em 'Centros de GPS' (serão usados 'GPS-X100-PRO' e 'GPS-Z500-LITE').
 5. Devem existir registros em 'Hospital' (serão usados "ID's 1 e 2).
*/
INSERT INTO Transporte (
    id_orgao,
    id_receptor,
    data_hora_saida,
    data_hora_chegada,
    modal,
    id_centro_transporte,
    dispositivo_gps,
    id_hospital_origem,
    id_hospital_destino
)
VALUES 
    (
        1,                    
        2,                   
        '2023-10-27 10:00:00',
        '2023-10-27 11:30:00',
        'Helicóptero',       
        1,                  
        'GPS-X100-PRO',      
        2,                  
        1                
    ),
    (
        2,                   
        6,                
        NOW(),            
        NULL,              
        'Terrestre',       
        1,                 
        'GPS-Z500-LITE',    
        1,                  
        2                  
    );

-- Inserção em localização
/*
 1. Devem existir registros em 'Transplante' (serão usados as tuplas (1,2) e (2,6) representando Ids de órgão e receptor, respectivamente).
*/
insert
	into
	Localizacao (
    id_orgao,
	id_receptor,
	coordenada,
	data_hora
)
values 
    (
        1, 
        2, 
        '-23.550520, -46.633308',
        '2023-10-27 10:05:00'    
    ),
    (
        1, 
        2, 
        '-23.555000, -46.640000',
        '2023-10-27 10:15:00' 
    ),
    (
        1, 
        2, 
        '-23.560000, -46.650000',
        '2023-10-27 10:25:00'
    ),
	(
    	2, 
    	6, 
    	'-22.906847, -43.172896' ,
    	'2023-10-27 10:25:00'
	);
