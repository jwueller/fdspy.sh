#include <stdio.h>
#include <unistd.h>

void main() {
  for (;;) {
    fprintf(stderr, "\2Hello, stderr!\n");
    sleep(1);
  }
}
