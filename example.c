#include <stdio.h>
#include <stdlib.h>

int main() {
    int* ptr = malloc(sizeof(int) * 10);  // asignación dinámica de memoria
    ptr[10] = 5;  // acceso fuera de los límites del array
    printf("Valor: %d\n", ptr[10]);
    // falta liberar la memoria
    return 0;
}