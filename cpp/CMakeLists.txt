cmake_minimum_required(VERSION 3.16)

project(turismo_cpp VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_library(turismo_lib
    src/ArchivosCSV.cpp
    src/Punto.cpp
    src/Conexion.cpp
    src/Unidad.cpp
    src/Solicitud.cpp
    src/Visitante.cpp
    src/FA02.cpp
)

target_include_directories(turismo_lib PUBLIC include)

add_executable(turismo_cpp src/main.cpp)
target_link_libraries(turismo_cpp PRIVATE turismo_lib)

