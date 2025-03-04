import re

# Archivo de entrada con los árboles génicos
input_file = "gene_trees.tre"
output_file = "mapping.txt"

# Usamos un conjunto para evitar duplicados
mapping = set()

with open(input_file, "r") as f:
    for line in f:
        # Extraer los identificadores de los taxa en formato ERRxxxxx__NN
        taxa = re.findall(r"(\b[\w]+__\d+\b)", line)
        for taxon in taxa:
            species = taxon.split("__")[0]  # Extraer la parte sin el sufijo __NN
            mapping.add((taxon, species))

# Guardar el archivo de correspondencia corregido
with open(output_file, "w") as f_out:
    for taxon, species in sorted(mapping):
        f_out.write(f"{taxon}\t{species}\n")

# Confirmar la ubicación del archivo corregido
output_file
