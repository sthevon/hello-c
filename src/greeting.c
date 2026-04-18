#include <stdio.h>

void say_hello(const char *name) {
  if (!name) {
    return;
  }

  printf("Hello, %s\n", name);
}
