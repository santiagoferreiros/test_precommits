#include <stdio.h>
#include <stdlib.h>
// #include <ctype.h>
// #include <string.h>

#define CANTIDAD_ESTADOS 7
#define CANTIDAD_SIMBOLOS 6

typedef enum {
  Q0, // estado inicial
  Q1, // esatdo final 0 (octal)
  Q2, // estado final DECIMAL
  Q3, // estado intermedio [x,X]
  Q4, // estado final HEXADECIMAL
  Q5, // estado final OCTAL
  Q6  // estado Rechazo
} t_estado;

typedef enum {
  A, // 0
  B, // [1-7]
  C, // [8,9]
  D, // [a-f,A-F]
  E, // [x,X]
  F  // otro caracter
} t_caracter;

#define ESTADO_INICIAL Q0
#define ESTADO_FINAL_CERO Q1
#define ESTADO_FINAL_DECIMAL Q2
#define ESTADO_FINAL_HEXADECIMAL Q4
#define ESTADO_FINAL_OCTAL Q5
#define CENTINELA ','

int tabla_transiciones[CANTIDAD_ESTADOS][CANTIDAD_SIMBOLOS] = {
    {Q1, Q2, Q2, Q6, Q6, Q6}, {Q5, Q5, Q6, Q6, Q3, Q6},
    {Q2, Q2, Q2, Q6, Q6, Q6}, {Q4, Q4, Q4, Q4, Q6, Q6},
    {Q4, Q4, Q4, Q4, Q6, Q6}, {Q5, Q5, Q6, Q6, Q6, Q6},
    {Q6, Q6, Q6, Q6, Q6, Q6}};

t_estado char_to_enum(char c) {
  switch (c) {
  case '0':
    return A;
    break;

  case '1':
  case '2':
  case '3':
  case '4':
  case '5':
  case '6':
  case '7':
    return B;
    break;

  case '8':
  case '9':
    return C;
    break;

  case 'A':
  case 'a':
  case 'B':
  case 'b':
  case 'C':
  case 'c':
  case 'D':
  case 'd':
  case 'E':
  case 'e':
  case 'F':
  case 'f':
    return D;
    break;

  case 'X':
  case 'x':
    return E;
    break;

  default:
    return F;
    break;
  };
}

void resultado(FILE *output, t_estado estado) {
  fputs("\t\t", output);
  switch (estado) {
  case ESTADO_FINAL_CERO:
  case ESTADO_FINAL_OCTAL:
    fputs("OCTAL\n", output);
    break;
  case ESTADO_FINAL_DECIMAL:
    fputs("DECIMAL\n", output);
    break;
  case ESTADO_FINAL_HEXADECIMAL:
    fputs("HEXADECIMAL\n", output);
    break;
  default:
    fputs("NO RECONOCIDA\n", output);
  }
}

void lexer(FILE *input, FILE *output) {
  char c;
  int estado = ESTADO_INICIAL;
  while ((c = fgetc(input)) != EOF) {
    if (c != CENTINELA) {
      fputc(c, output);
      estado = tabla_transiciones[estado][char_to_enum(c)];
    } else {
      resultado(output, estado);
      estado = ESTADO_INICIAL;
    }
  }
  resultado(output, estado);
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
    printf("Debe pasarse un nombre de archivo válido como parámetro.\n");
    return EXIT_FAILURE;
  }

  FILE *file = fopen(argv[1], "r");
  if (file == NULL) {
    printf("Error al intentar abrir el archivo %s.\n", argv[1]);
    return EXIT_FAILURE;
  }
  if (argc == 3) {
    FILE *salida = fopen(argv[2], "w");
    if (salida == NULL) {
      printf("Error al intentarr crear el archivo %s.\n", argv[2]);
      return EXIT_FAILURE;
    }
    lexer(file, salida); // escribre archivo
  } else {
    lexer(file, stdout); // muestra en pantalla
  }
  fclose(file);
  return EXIT_SUCCESS;
}
