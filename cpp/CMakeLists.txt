cmake_minimum_required(VERSION 3.16)

project(turismo_cpp VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_library(turismo_lib
    src/Destino.cpp
)

target_include_directories(turismo_lib PUBLIC include)

add_executable(turismo_cpp src/main.cpp)
target_link_libraries(turismo_cpp PRIVATE turismo_lib)

include(CTest)
if(BUILD_TESTING)
    add_executable(turismo_cpp_tests tests/DestinoTest.cpp)
    target_link_libraries(turismo_cpp_tests PRIVATE turismo_lib)
    add_test(NAME destino_test COMMAND turismo_cpp_tests)
endif()

