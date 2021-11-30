add_library(pathlib_cpp OBJECT pathlib.cpp)
target_include_directories(pathlib_cpp INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})

add_executable(test_pathlib test_pathlib.cpp)
target_link_libraries(test_pathlib PRIVATE pathlib_cpp)
add_test(NAME pathlibC++ COMMAND test_pathlib)

target_sources(gemini_c.bin PRIVATE gemini_main.cpp)
#target_link_libraries(gemini_c.bin PRIVATE pathlib_cpp)
