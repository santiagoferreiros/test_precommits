#!/bin/bash

# Compilar el programa principal
gcc TP1/src/main.c -o TP1/bin/tp1

total_tests=0
passed_tests=0
total_percentage=0
min_percentage_per_test=75  # Establecer el porcentaje mínimo de coincidencia para pasar el test
min_average_percentage_over_all_test=80
min_quantity_test=2
pass_tests=1

# Ejecutar pruebas
for input_file in TP1/tests/test_*.txt; do
    total_tests=$((total_tests + 1))
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

    # Contar líneas totales del test y líneas coincidentes con lo esperado
    total_lines=$(cat ${expected_output} | wc -l)
    matching_lines=$(grep -Fxf ${output_file} ${expected_output} | wc -l)
    percentage=$(echo "scale=2; $matching_lines / $total_lines * 100" | bc)

    # Sumarizar para promedio
    total_percentage=$(echo "$total_percentage + $percentage" | bc)

    # Determinar si el test es pasado o no basado en el porcentaje de coincidencia
    if (( $(echo "$percentage >= $min_percentage" | bc) )); then
        passed_tests=$((passed_tests + 1))
        echo -e "\nResultado ${test_name}: \033[32m PASS with #${percentage}%\033[0m"
    else
        echo -e "\nResultado ${test_name}: \033[31m FAIL with #${percentage}%\033[0m"
        echo -e "\nDiferencias indicadas según colores de referencia: \n\033[32m  * Verde: Líneas faltantes en salida actual \033[0m\n\033[31m  * Rojo: Líneas adicionales en salida actual \033[0m\n\033[36m  * Cian: Líneas con diferencias entre salida actual y esperada\033[0m"
        echo -e "\nSalida de ejecución actual ${test_name} \t\t\t\tSalida esperada ${test_name}\n"
        colordiff -y ${output_file} ${expected_output}
    fi

# Calcular el porcentaje promedio de coincidencia
if [ "$total_tests" -ne 0 ]; then
    average_percentage=$(echo "scale=2; $total_percentage / $total_tests" | bc)
else
    average_percentage=0
fi

echo "Se pasaron $passed_tests / $total_tests tests"
echo "Porcentaje promedio de cobertura de test: $average_percentage%"

if (( $(echo "$passed_tests >= $min_quantity_test" | bc) )); then
        pass_tests=0
        echo -e "\n\033[31m No se superaron la cantidad mínima de test\033[0m"

if (( $(echo "$average_percentage >= $min_average_percentage_over_all_test" | bc) )); then
        pass_tests=0
        echo -e "\n\033[31m No se alcanzó el mínimo % promedio de cobertura de test\033[0m"

if [ "$pass_tests" -ne 0 ]; then
        echo -e "\n\033[32m Se superaron las pruebas de test\033[0m"

done
