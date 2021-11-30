// MSVC 2017 or newer:
// cl /std:c++17 /EHsc

// Clang >= 9  or  g++ >= 8
// clang++ -std=c++17

#include <iostream>
#include <filesystem>
#include <string>
#include <cstring>

namespace fs = std::filesystem;

void expanduser(char *pathstr){
// does not handle ~username/foo

if(pathstr[0] != '~')
  return;

std::string s;
#ifdef _WIN32
s = std::getenv("USERPROFILE");
#else
s = std::getenv("HOME");
#endif

std::string r = pathstr;
r.erase(r.begin());

if (!s.empty()){
  s += r;
  if (sizeof(pathstr) < s.size() + 1) {
    std::cerr << "Error: expanduser: path too long " << sizeof(pathstr) << " < " << s.size() + 1 << std::endl;
    exit(EXIT_FAILURE);
  }

  strncpy(pathstr, s.c_str(), s.size() + 1);
}

}
