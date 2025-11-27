import os

ordem = [
    "ddl/centro_de_transporte.sql",
    "ddl/central_estadual.sql",
    "ddl/dispositivo_de_gps.sql",
    "ddl/hospital.sql",
    "ddl/pessoa.sql",
    "ddl/tipo.sql",
    "ddl/paciente.sql",
    "ddl/modo.sql",
    "ddl/familiar.sql",
    "ddl/paciente_familiar.sql",
    "ddl/receptor.sql",
    "ddl/doador.sql",
    "ddl/historico_clinico.sql",
    "ddl/profissional.sql",
    "ddl/tipo_orgao_tecido.sql",
    "ddl/fila.sql",
    "ddl/historico.sql",
    "ddl/orgao_tecido.sql",
    "ddl/avaliacao_orgao.sql",
    "ddl/avaliacao_orgao_enfermeiro.sql",
    "ddl/transplante.sql",
    "ddl/transporte.sql",
    "ddl/localizacao.sql"
]

with open("final.sql", "w", encoding="utf8") as out:

    # Filtrar apenas arquivos válidos e não vazios
    validos = [f for f in ordem if os.path.exists(f) and os.path.getsize(f) > 0]

    for i, f in enumerate(validos):
        with open(f, "r", encoding="utf8") as src:
            out.write(src.read().rstrip())

        # Se não for o último arquivo válido, adiciona quebra dupla
        if i < len(validos) - 1:
            out.write("\n\n")