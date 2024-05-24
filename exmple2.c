#include <stdio.h>
int main() {
  int a = 5;
  int b = ++a + a++;
  printf("Value: %d", a);
  return 0;
}
