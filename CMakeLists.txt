cmake_minimum_required(VERSION 3.20...3.22)

get_property(is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(NOT is_multi_config AND NOT (CMAKE_BUILD_TYPE OR DEFINED ENV{CMAKE_BUILD_TYPE}))
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Release default")
endif()

project(LibGemini
LANGUAGES C CXX Fortran
)
# languaage Fortran is needed so that Fortran standard library is available, even though
# this is a C/C++ project, we are using a Fortran library libgemini3d

include(CTest)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

include(cmake/options.cmake)
include(cmake/libraries.cmake)
include(cmake/compiler_flags.cmake)

# External Projects
include(cmake/gemini3d.cmake)
if(NOT WIN32)
include(cmake/forestclaw.cmake)
endif()

include(cmake/iniparser.cmake)

# --- Gemini_c.bin
# This is an example of a C/C++ Gemini3D main program
# this could be used as a starting point for C/C++ programs that use the GEMINI3D API

add_executable(gemini_c.bin src/gemini_main.c)

if(CMAKE_C_COMPILER_ID MATCHES "GNU|^Intel")
  set_target_properties(gemini_c.bin PROPERTIES
  LINKER_LANGUAGE Fortran
  )
endif()

target_link_libraries(gemini_c.bin PRIVATE gemini3d::gemini3d
MPI::MPI_C
iniparser
)

# --- setup tests

include(cmake/test/config.cmake)
include(cmake/test/sim.cmake)
