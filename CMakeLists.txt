cmake_minimum_required(VERSION 3.20...3.21)

project(LibGemini
LANGUAGES C CXX Fortran
)
# languaage Fortran is needed so that Fortran standard library is available, even though
# this is a C/C++ project, we are using a Fortran library libgemini3d

include(CTest)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

include(cmake/libraries.cmake)

include(cmake/gemini3d.cmake)

# --- Gemini_c.bin
# This is an example of a C/C++ Gemini3D main program
# this could be used as a starting point for C/C++ programs that use the GEMINI3D API

find_package(MPI COMPONENTS C Fortran REQUIRED)
find_package(HWLOC)
find_package(HDF5 COMPONENTS Fortran)
find_package(MUMPS)
find_package(SCALAPACK)
find_package(LAPACK)

add_executable(gemini_c.bin src/gemini_main.c)
set_target_properties(gemini_c.bin PROPERTIES
RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}
LINKER_LANGUAGE Fortran
)
# LINKER_LANGUAGE needed for Intel compilers
target_link_libraries(gemini_c.bin PRIVATE gemini3d::gemini3d)

if(MUMPS_FOUND)
  target_link_libraries(gemini_c.bin PRIVATE MUMPS::MUMPS)
else()
  target_link_libraries(gemini3d::gemini3d INTERFACE ${MUMPS_LIBRARIES})
endif()

if(SCALAPACK_FOUND)
  target_link_libraries(gemini_c.bin PRIVATE SCALAPACK::SCALAPACK)
else()
  target_link_libraries(gemini3d::gemini3d INTERFACE ${SCALAPACK_LIBRARIES})
endif()

if(LAPACK_FOUND)
  target_link_libraries(gemini_c.bin PRIVATE LAPACK::LAPACK)
endif()

if(HDF5_FOUND)
  target_link_libraries(gemini_c.bin PRIVATE HDF5::HDF5)
endif()

if(HWLOC_FOUND)
  target_link_libraries(gemini3d::gemini3d INTERFACE HWLOC::HWLOC)
endif()

target_link_libraries(gemini_c.bin PRIVATE
MPI::MPI_C
)
