cmake_minimum_required(VERSION 3.20...3.21)

project(LibGemini
LANGUAGES C CXX Fortran
)
# languaage Fortran is needed so that Fortran standard library is available, even though
# this is a C/C++ project, we are using a Fortran library libgemini3d

include(CTest)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

include(cmake/libraries.cmake)
include(cmake/compiler_flags.cmake)

include(cmake/gemini3d.cmake)

# --- Gemini_c.bin
# This is an example of a C/C++ Gemini3D main program
# this could be used as a starting point for C/C++ programs that use the GEMINI3D API

add_executable(gemini_c.bin src/gemini_main.c)

set_target_properties(gemini_c.bin PROPERTIES
RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}
)

if(CMAKE_C_COMPILER_ID MATCHES "GNU|^Intel")
  set_target_properties(gemini_c.bin PROPERTIES
  LINKER_LANGUAGE Fortran
  )
endif()

target_link_libraries(gemini_c.bin PRIVATE gemini3d::gemini3d)

target_link_libraries(gemini_c.bin PRIVATE MPI::MPI_C)
