#include <stdio.h>
#include <unistd.h>

void main() {
  for (;;) {
    fprintf(stdout, "\1Hello, stdout!\n");
    sleep(1);
  }
}
