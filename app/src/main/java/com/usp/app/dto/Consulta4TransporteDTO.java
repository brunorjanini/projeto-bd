package com.usp.app.dto;

public record Consulta4TransporteDTO(
        Long idOrgao,
        String tipoOrgao,
        String hospitalOrigem,
        String hospitalDestino,
        String centroTransporte,
        String serialGps,
        Double tempoTransitoHoras
) {}
