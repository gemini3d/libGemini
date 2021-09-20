set(_lib_names forestclaw gemini3d)

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json _libj)

foreach(n ${_lib_names})
  foreach(t git tag)
    string(JSON m ERROR_VARIABLE e GET ${_libj} ${n} ${t})
    if(m)
      set(${n}_${t} ${m})
    endif()
  endforeach()
endforeach()
