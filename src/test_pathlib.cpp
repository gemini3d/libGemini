#include <string>
#include <cassert>

#include "pathlib.hpp"


int main() {

std::string p1, p2;

p1 = "~/nothing";
p2 = expanduser(p1);

assert(p2.size() > p1.size() + 2);

return EXIT_SUCCESS;
}
