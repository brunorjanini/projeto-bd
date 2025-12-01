package com.usp.app.dto;

/**
 * DTO (Data Transfer Object) para realizar um transplante completo no sistema.
 * Contém as informações essenciais para executar a operação transacional de transplante.
 *
 * @param idOrgao ID único do órgão a ser transplantado
 * @param idReceptor ID único do receptor que receberá o órgão
 * @param statusTransplante Status inicial do transplante (ex: "Realizado", "Agendado")
 */
public record RealizarTransplanteDTO(
        Integer idOrgao,
        Integer idReceptor,
        String statusTransplante
) {}
