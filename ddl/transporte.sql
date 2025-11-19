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
        ON DELETE SET NULL, -- Se o GPS quebrar/sumir, o registro de transporte continua existindo.

    CONSTRAINT FK_Transporte_Origem FOREIGN KEY (id_hospital_origem)
        REFERENCES Hospital (id_hospital)
        ON DELETE RESTRICT,

    CONSTRAINT FK_Transporte_Destino FOREIGN KEY (id_hospital_destino)
        REFERENCES Hospital (id_hospital)
        ON DELETE RESTRICT
);
