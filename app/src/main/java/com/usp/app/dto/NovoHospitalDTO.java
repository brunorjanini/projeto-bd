package com.usp.app.dto;

/**
 * DTO (Data Transfer Object) para criação de um novo hospital no sistema.
 * Contém todos os dados necessários para cadastrar um hospital.
 *
 * @param nome Nome completo do hospital
 * @param cnpj CNPJ do hospital no formato XX.XXX.XXX/XXXX-XX
 * @param telefone Telefone de contato do hospital
 * @param email Email de contato do hospital
 * @param rua Nome da rua do endereço do hospital
 * @param numero Número do endereço do hospital
 * @param bairro Bairro do endereço do hospital
 * @param cidade Cidade onde o hospital está localizado
 * @param centralEstadual Sigla do estado (UF) da central estadual responsável pelo hospital
 */
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
