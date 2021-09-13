# libGemini

Using Gemini3D as a library.

A complex project such as Gemini3D can be consumed as a CMake ExternalProject.
CMake ExternalProject provide isolation between projects to avoid CMake scope problems between projects with different authors.
One could also just `cmake --install` Gemini3D, but using ExternalProject allows for rapid development and version pinning of Gemini3D and other libraries.

The first Hello World example we plan is to invoke Gemini3D from a C++ program, running one of the simple CI test simulations.
