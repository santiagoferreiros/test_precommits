#!/bin/bash

# Función para agregar un salto de línea al final de un archivo si no existe
add_trailing_newline() {
    local file="$1"
    if [ -n "$(tail -c 1 "$file")" ]; then
        echo "" >> "$file"
    fi
}

# Función para limpiar el archivo: eliminar tabulaciones, espacios adicionales, reemplazar múltiples espacios y eliminar líneas vacías
clean_file() {
    local file="$1"
    sed -e 's/\t/ /g' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]]\{2,\}/ /g' -e '/^$/d' "$file" > "${file}.clean"
}

# Función para contar líneas en un archivo limpio
count_lines() {
    local file="$1"
    local line_count=$(wc -l < "$file")
    echo "$line_count"
}

# Obtener nombres de archivos y agregar salto de línea si es necesario
output_file="$1"
expected_file="$2"

# Limpiar los archivos de líneas vacías, tabulaciones y normalizar espacios
clean_file "$output_file"
clean_file "$expected_file"

# Agregar salto de línea si es necesario al final del archivo
add_trailing_newline "${output_file}.clean"
add_trailing_newline "${expected_file}.clean"

# Contar líneas en los archivos limpios
output_line_count=$(count_lines "${output_file}.clean")
expected_line_count=$(count_lines "${expected_file}.clean")

# Usar diff para encontrar diferencias ignorando líneas vacías y normalizadas
diff_output=$(diff "${output_file}.clean" "${expected_file}.clean" | grep -vE '^[0-9]+[acd][0-9]+$|^---$')
echo $diff_output
# Contar las líneas coincidentes
#matching_lines=$((expected_line_count - $(echo "$diff_output" | grep -c '^<\|^>')))
matching_lines=$((expected_line_count - $(echo "$diff_output" | grep -c '^>')))


# Calcular porcentaje de coincidencia
if [ "$expected_line_count" -gt 0 ] && [ "$output_line_count" -gt 0 ]; then
    percentage_matching_expected=$(awk "BEGIN {printf \"%.2f\", ($matching_lines / $expected_line_count) * 100}")
    percentage_matching_output=$(awk "BEGIN {printf \"%.2f\", ($matching_lines / $output_line_count) * 100}")
    percentage_matching=$(awk "BEGIN {printf \"%.2f\", ($percentage_matching_expected < $percentage_matching_output ? $percentage_matching_expected : $percentage_matching_output)}")
else
    percentage_matching=0
fi

# Imprimir resultados
echo "Lineas matcheadas: $matching_lines"
echo "Total de líneas en output: $output_line_count"
echo "Total de líneas en expected output: $expected_line_count"
echo "Líneas en el output que coinciden con el expected output:"
echo "$diff_output" | grep '^<' | sed 's/^< //'
echo "% de coincidencia: $percentage_matching%"
