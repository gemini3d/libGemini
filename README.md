# libGemini

Using Gemini3D as a library.

A complex project such as Gemini3D can be consumed as a CMake ExternalProject.
CMake ExternalProject provides isolation between projects to avoid CMake scope problems between projects with different authors.
CMake ExternalProject allows for rapid development and version pinning of Gemini3D and other libraries.

TODO: add test cases

## Build

```sh
cmake -B build
cmake --build build
```

This downloads and builds Gemini3D and all its prerequisites.
Gemini3D requires a working MPI library already installed.

### Hinting library locations

If CMake doesn't find MPI, give a hint to its location.
For example, if MPI is installed in /opt/local/openmpi-4, then give configuration command:

```sh
cmake -B build -DMPI_ROOT=/opt/local/openmpi-4
```

To make that hint permanent, add an environment variable MPI_ROOT=/opt/local/openmpi-4 to your shell profile, then the "-DMPI_ROOT" option isn't needed in the future.

Other library locations can be hinted as well, like LAPACK, HDF5, etc.
