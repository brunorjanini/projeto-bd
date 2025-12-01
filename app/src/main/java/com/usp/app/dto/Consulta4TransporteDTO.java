package com.usp.app.dto;

/**
 * DTO (Data Transfer Object) representando o resultado da consulta de transportes de órgãos.
 * Contém informações completas sobre um transporte entre hospitais.
 *
 * @param idOrgao ID único do órgão transportado
 * @param tipoOrgao Tipo do órgão (ex: "Coração", "Rim", "Fígado")
 * @param hospitalOrigem Nome do hospital de origem do transporte
 * @param hospitalDestino Nome do hospital de destino do transporte
 * @param centroTransporte Nome do centro de transporte responsável pela logística
 * @param serialGps Serial do dispositivo GPS usado no rastreamento (pode ser null)
 * @param tempoTransitoHoras Tempo de trânsito em horas entre origem e destino (null se ainda em trânsito)
 */
public record Consulta4TransporteDTO(
        Long idOrgao,
        String tipoOrgao,
        String hospitalOrigem,
        String hospitalDestino,
        String centroTransporte,
        String serialGps,
        Double tempoTransitoHoras
) {}
