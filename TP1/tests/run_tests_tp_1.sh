#!/bin/bash

# Compilar el programa principal
gcc TP1/src/main.c -o TP1/bin/tp1

# Ejecutar pruebas
for input_file in TP1/tests/test_*.txt; do
    test_name=$(basename ${input_file} .txt)
    output_file="TP1/tests/output_${test_name}.txt"
    expected_output="TP1/tests/expected_outputs/expected_output_${test_name}.txt"

    # Ejecutar el programa con rutas de archivo de entrada y salida
    TP1/bin/tp1 ${input_file} ${output_file}

    # Convertir tabulaciones a un solo espacio
    sed -i 's/\t\+/ /g' ${output_file}
    sed -i 's/\t\+/ /g' ${expected_output}

    # Limpiar espacios al final de las líneas
    sed -i 's/[ \t]*$//' ${output_file}
    sed -i 's/[ \t]*$//' ${expected_output}

    # Eliminar el salto de línea final si existe
    sed -i ':a;N;$!ba;s/\n$//' ${output_file}
    sed -i 's/[ \t]*$//' ${expected_output}

    # Compara la salida actual con la salida esperada usando colordiff en formato de dos columnas
    if colordiff -y ${output_file} ${expected_output} > /dev/null; then
        echo "Resultado ${test_name}: PASS"
    else
        echo -e "Resultado ${test_name}: FAIL"
        echo -e "\nDiferencias indicadas en colores. Referencia de colores: \n\n\033[32m  * Verde: Líneas faltantes en salida actual \033[0m\n\033[31m  * Rojo: Líneas adicionales en salida actual \033[0m\n\033[34m  * Celeste: Líneas con diferencias entre salida actual y esperada\033[0m"
        echo -e "\nSalida de ejecución actual ${test_name} \t\t\t\tSalida esperada ${test_name}\n"
        colordiff -y ${output_file} ${expected_output}
    fi
done
