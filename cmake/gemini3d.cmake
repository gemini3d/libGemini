# consumes Gemini3D as ExternalProject, providing imported target "gemini3d::gemini3d"
include(ExternalProject)

# target_link_libraries(... gemini3d::gemini3d)
# for user programs
add_library(gemini3d::gemini3d INTERFACE IMPORTED)

option(mumps_external "force build MUMPS")
option(scalapack_external "force build SCALAPACK")
option(lapack_external "force build LAPACK")
option(hdf5_external "force build HDF5")

if(NOT GEMINI_ROOT)
  set(GEMINI_ROOT ${CMAKE_INSTALL_PREFIX})
endif()

find_package(MPI COMPONENTS C Fortran REQUIRED)
find_package(HWLOC)
if(NOT hdf5_external)
  find_package(HDF5 COMPONENTS Fortran)
  find_package(ZLIB)
endif()
if(NOT mumps_external)
  find_package(MUMPS)
endif()
if(NOT scalapack_external)
  find_package(SCALAPACK)
endif()
if(NOT lapack_external)
  find_package(LAPACK)
endif()

# artifacts from ExternalProject GEM3D

add_executable(gemini3d.compare IMPORTED)
set_target_properties(gemini3d.compare PROPERTIES
IMPORTED_LOCATION ${GEMINI_ROOT}/bin/gemini3d.compare
)

set(GEMINI_LIBRARIES
${GEMINI_ROOT}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gemini3d${CMAKE_STATIC_LIBRARY_SUFFIX})

set(GEMINI_INCLUDE_DIRS ${GEMINI_ROOT}/include)

# libraries needed by Gemini3D
set(h5fortran_LIBRARIES
${GEMINI_ROOT}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}h5fortran${CMAKE_STATIC_LIBRARY_SUFFIX}
)

set(nc4fortran_LIBRARIES
${GEMINI_ROOT}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}nc4fortran${CMAKE_STATIC_LIBRARY_SUFFIX}
)

set(MSIS_LIBRARIES
${GEMINI_ROOT}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}msis00mod${CMAKE_STATIC_LIBRARY_SUFFIX}
)

set(GLOW_LIBRARIES
${GEMINI_ROOT}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}glow${CMAKE_STATIC_LIBRARY_SUFFIX}
)

set(HWM_LIBRARIES
${GEMINI_ROOT}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}hwm_ifc${CMAKE_STATIC_LIBRARY_SUFFIX}
)

set(HWLOC_LIBRARIES
${GEMINI_ROOT}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}hwloc_ifc${CMAKE_STATIC_LIBRARY_SUFFIX}
${GEMINI_ROOT}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}hwloc_c${CMAKE_STATIC_LIBRARY_SUFFIX}
)

# these are available if Gemini3D auto-built them.
set(MUMPS_LIBRARIES
${GEMINI_ROOT}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}dmumps${CMAKE_STATIC_LIBRARY_SUFFIX}
${GEMINI_ROOT}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}mumps_common${CMAKE_STATIC_LIBRARY_SUFFIX}
${GEMINI_ROOT}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}pord${CMAKE_STATIC_LIBRARY_SUFFIX}
)

set(SCALAPACK_LIBRARIES
${GEMINI_ROOT}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}scalapack${CMAKE_STATIC_LIBRARY_SUFFIX}
${GEMINI_ROOT}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}blacs${CMAKE_STATIC_LIBRARY_SUFFIX}
)

set(LAPACK_LIBRARIES
${GEMINI_ROOT}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}lapack${CMAKE_STATIC_LIBRARY_SUFFIX}
${GEMINI_ROOT}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}blas${CMAKE_STATIC_LIBRARY_SUFFIX}
)

set(HDF5_LIBRARIES)
set(hdf5_names hdf5_hl_fortran hdf5_hl_f90cstub hdf5_fortran hdf5_f90cstub hdf5_hl hdf5)
foreach(_name ${hdf5_names})
  list(APPEND HDF5_LIBRARIES ${GEMINI_ROOT}/lib/lib${_name}${CMAKE_STATIC_LIBRARY_SUFFIX})
endforeach()

set(ZLIB_LIBRARIES ${GEMINI_ROOT}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}z${CMAKE_STATIC_LIBRARY_SUFFIX})

# ExternalProject defined
set(gemini3d_byproducts
${GEMINI_LIBRARIES}
${nc4fortran_LIBRARIES}
${h5fortran_LIBRARIES}
${GLOW_LIBRARIES}
${MSIS_LIBRARIES}
${HWM_LIBRARIES}
${HWLOC_LIBRARIES}
)
# BUILD_BYPRODUCTS does not yet support generator expressions
if(NOT MUMPS_FOUND)
  list(APPEND gemini3d_byproducts ${MUMPS_LIBRARIES})
endif()

if(NOT SCALAPACK_FOUND)
  list(APPEND gemini3d_byproducts ${SCALAPACK_LIBRARIES})
endif()

if(NOT LAPACK_FOUND)
  list(APPEND gemini3d_byproducts ${LAPACK_LIBRARIES})
endif()

if(NOT HDF5_FOUND)
  list(APPEND gemini3d_byproducts ${HDF5_LIBRARIES})
endif()

if(NOT ZLIB_FOUND)
  list(APPEND gemini3d_byproducts ${ZLIB_LIBRARIES})
endif()

set(gemini3d_args
-DCMAKE_INSTALL_PREFIX:PATH=${GEMINI_ROOT}
-DBUILD_SHARED_LIBS:BOOL=false
-DCMAKE_BUILD_TYPE=Release
-DBUILD_TESTING:BOOL=false
-Dmumps_external:BOOL=${mumps_external}
-Dscalapack_external:BOOL=${scalapack_external}
-Dlapack_external:BOOL=${lapack_external}
-Dhdf5_external:BOOL=${hdf5_external}
-Dautobuild:BOOL=${autobuild}
"$<$<BOOL:${LAPACK_ROOT}>:-DLAPACK_ROOT:PATH=${LAPACK_ROOT}>"
"$<$<BOOL:${SCALAPACK_ROOT}>:-DSCALAPACK_ROOT:PATH=${SCALAPACK_ROOT}>"
"$<$<BOOL:${MUMPS_ROOT}>:-DMUMPS_ROOT:PATH=${MUMPS_ROOT}>"
"$<$<BOOL:${HDF5_ROOT}>:-DHDF5_ROOT:PATH=${HDF5_ROOT}>"
"$<$<BOOL:${ZLIB_ROOT}>:-DZLIB_ROOT:PATH=${ZLIB_ROOT}>"
)

ExternalProject_Add(G3D
GIT_REPOSITORY ${gemini3d_git}
GIT_TAG ${gemini3d_tag}
CMAKE_ARGS ${gemini3d_args}
CMAKE_GENERATOR ${EXTPROJ_GENERATOR}
BUILD_BYPRODUCTS ${gemini3d_byproducts}
INACTIVITY_TIMEOUT 15
CONFIGURE_HANDLED_BY_BUILD true
)

file(MAKE_DIRECTORY ${GEMINI_INCLUDE_DIRS})
# avoid generate race condition

target_link_libraries(gemini3d::gemini3d INTERFACE
${gemini3d_byproducts}
"$<$<BOOL:${MUMPS_FOUND}>:MUMPS::MUMPS>"
"$<$<BOOL:${SCALAPACK_FOUND}>:SCALAPACK::SCALAPACK>"
"$<$<BOOL:${LAPACK_FOUND}>:LAPACK::LAPACK>"
"$<$<BOOL:${HDF5_FOUND}>:HDF5::HDF5>"
"$<$<BOOL:${ZLIB_FOUND}>:ZLIB::ZLIB>"
"$<$<BOOL:${HWLOC_FOUND}>:HWLOC::HWLOC>"
MPI::MPI_Fortran
${CMAKE_DL_LIBS}
$<$<BOOL:${UNIX}>:m>
)
# libdl and libm are needed on some systems for HDF5

# for Fortran modules
target_include_directories(gemini3d::gemini3d INTERFACE ${GEMINI_INCLUDE_DIRS})

add_dependencies(gemini3d::gemini3d G3D)
