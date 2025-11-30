package com.usp.app.dto;

import java.time.LocalDateTime;

public record NovoOrgaoDTO(
        Integer idDoador,
        String tipoOrgao,
        String status,
        LocalDateTime dataCaptacao
) {}
