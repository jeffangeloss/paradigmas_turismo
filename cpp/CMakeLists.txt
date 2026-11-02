cmake_minimum_required(VERSION 3.16)

project(turismo_cpp VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Un archivo por funcionalidad de la seccion 4.1, mas las funcionalidades adicionales en src/fa/.
add_library(turismo_lib
    src/utilidades.cpp
    src/validaciones.cpp
    src/archivos.cpp
    src/registro.cpp
    src/estados.cpp
    src/consultas.cpp
    src/reporte.cpp
    src/fa/fa_samantha.cpp
    src/fa/fa_melissa.cpp
    src/fa/fa_jefferson.cpp
)

target_include_directories(turismo_lib PUBLIC include)
target_compile_options(turismo_lib PRIVATE -Wall -Wextra)

add_executable(turismo_cpp src/main.cpp)
target_link_libraries(turismo_cpp PRIVATE turismo_lib)
target_compile_options(turismo_cpp PRIVATE -Wall -Wextra)
