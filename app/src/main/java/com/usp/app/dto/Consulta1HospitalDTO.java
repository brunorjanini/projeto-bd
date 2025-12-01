package com.usp.app.dto;

/**
 * DTO (Data Transfer Object) representando o resultado da consulta de hospitais.
 * Contém informações sobre um hospital e a quantidade de órgãos disponíveis.
 *
 * @param nomeHospital Nome completo do hospital
 * @param cidade Cidade onde o hospital está localizado
 * @param totalOrgaosDisponiveis Quantidade total de órgãos disponíveis no hospital
 */
public record Consulta1HospitalDTO(
        String nomeHospital,
        String cidade,
        Long totalOrgaosDisponiveis
) {}
