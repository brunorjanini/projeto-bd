package com.usp.app.dto;

import java.time.LocalDateTime;

public record NovaAvaliacaoOrgaoDTO(
        Integer idMedico,
        Integer idOrgao,
        LocalDateTime dataHora
) {}
