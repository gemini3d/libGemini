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
