import glob

arquivos = sorted(glob.glob("ddl/*.sql"))

with open("final.sql", "w", encoding="utf8") as out:
    for idx, f in enumerate(arquivos):
        with open(f, "r", encoding="utf8") as src:
            out.write(src.read().strip())
        if idx < len(arquivos) - 1:
            out.write("\n\n")
