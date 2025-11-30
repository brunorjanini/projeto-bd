package com.usp.app.dto;

public record NovoHospitalDTO(
        String nome,
        String cnpj,
        String telefone,
        String email,
        String rua,
        String numero,
        String bairro,
        String cidade,
        String centralEstadual
) {}
