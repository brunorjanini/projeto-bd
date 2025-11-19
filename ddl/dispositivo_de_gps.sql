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