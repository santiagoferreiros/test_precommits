#!/bin/bash

# Compilar el programa principal
gcc TP1/src/main.c -o TP1/bin/tp1

# Ejecutar pruebas
for input_file in TP1/tests/test_*.txt; do
    test_name=$(basename ${input_file} .txt)
    output_file="output_${test_name}.txt"
    expected_output="TP1/tests/expected_outputs/expected_output_${test_name}.txt"

    # Ejecutar el programa con rutas de archivo de entrada y salida
    TP1/bin/tp1 ${input_file} ${output_file}

    # Compara la salida actual con la salida esperada
    if diff ${output_file} ${expected_output} > /dev/null; then
        echo "${test_name}: PASS"
    else
        echo "${test_name}: FAIL"
        echo "Differences:"
        diff -y ${output_file} ${expected_output}
    fi
done
