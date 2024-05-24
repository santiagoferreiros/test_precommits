#include <stdio.h>
int main() {
  int a = 8;
  int b = ++a + a++;
  printf("Value: %d", a);
  return 0;
}