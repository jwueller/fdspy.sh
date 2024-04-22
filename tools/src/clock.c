#include <stdio.h>
#include <unistd.h>
#include <time.h>

int main() {
  char s[64];
  time_t t;
  struct tm *tm;

  for (;;) {
    t = time(NULL);
    tm = localtime(&t);
    if (tm == NULL) {
      fprintf(stderr, "localtime failed\n");
      return 1;
    }

    /* ISO 8601 is the superior date format. */
    if (strftime(s, sizeof(s), "%FT%T%z", tm) == 0) {
      fprintf(stderr, "strftime failed\n");
      return 1;
    }

    fprintf(stdout, "%s\n", s);
    sleep(1);
  }

  return 0;
}
