// MAIN PROGRAM FOR GEMINI3D

#include <iostream>
#include <filesystem>

#include <cstdlib>
#include <cstring>

#include <mpi.h>

#include "gemini3d.h"
#include "iniparser.h"
//#include "pathlib.hpp"

namespace fs = std::filesystem;

int main(int argc, char **argv) {

struct params s;

int ierr = MPI_Init(&argc, &argv);

// CLI
if (argc < 2) {
  MPI_Finalize();
  std::cerr << "Gemini3D: please give simulation output directory e.g. ~/data/my_sim" << std::endl;
  return EXIT_FAILURE;
}

int L = strlen(argv[1]);
if(L > LMAX) {
  MPI_Finalize();
  std::cerr << "Gemini3D simulation output directory: path length > " << LMAX << std::endl;
  return EXIT_FAILURE;
}
L++; // for null terminator

// simulation directory
strcpy(s.out_dir, argv[1]);
//expanduser(s.out_dir);

if(! fs::is_directory(s.out_dir)) {
  std::cerr << "Gemini3D simulation output directory does not exist: " << s.out_dir << std::endl;
  return EXIT_FAILURE;
}

// Read gemini_config.ini
char ini_file[LMAX];
sprintf(ini_file, "%s/inputs/gemini_config.ini", argv[1]);

dictionary  *ini;
int b,i ;
double d;
const char *txt;

ini = iniparser_load(ini_file);
if (ini==NULL) {
    std::cerr << "gemini3d_ini: cannot parse file: " << ini_file << std::endl;
    return EXIT_FAILURE;
}

b = iniparser_getboolean(ini, "pizza:ham", -1);

iniparser_freedict(ini);  // close the file

// Prepare Gemini3D struct
strcpy(s.out_dir, argv[1]);

s.fortran_cli = false;
s.debug = false;
s.dryrun = false;
int lid2in = -1, lid3in = -1;

for (int i = 2; i < argc; i++) {
  if (strcmp(argv[i], "-d") == 0 || strcmp(argv[i], "-debug") == 0) s.debug = true;
  if (strcmp(argv[i], "-dryrun") == 0) s.dryrun = true;
  if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "-help") == 0) {
    MPI_Finalize();
    help_gemini_bin();
    return EXIT_SUCCESS;
  }
  if (strcmp(argv[i], "-manual_grid") == 0) {
    if (argc < i+1) {
      MPI_Finalize();
      std::cerr << "-manual_grid lid2in lid3in" << std::endl;
      return EXIT_FAILURE;
    }
    lid2in = atoi(argv[i]);
    lid3in = atoi(argv[i+1]);
  }
}

gemini_main(&s, &lid2in, &lid3in);

ierr = MPI_Finalize();

if (ierr != 0) return EXIT_FAILURE;

return EXIT_SUCCESS;
}
