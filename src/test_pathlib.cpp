#include <iostream>
#include <cstring>

#include "pathlib.hpp"


int main() {

  char p1[100];

  strncpy(p1, "~", 1);

  expanduser(p1);

  std::cout << p1 << std::endl;

  return EXIT_SUCCESS;
}
