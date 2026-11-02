# Módulo C++

Implementación imperativa del dominio turístico, con `struct`, vectores, funciones y lectura y
escritura de archivos CSV. Es el único módulo que escribe los CSV de [`_datos/`](../_datos/README.md).
Requiere un compilador compatible con C++17 y, para compilar con CMake, CMake 3.16 o posterior.

## Estructura

| Archivo | Funcionalidad | Responsable |
|---|---|---|
| `src/main.cpp` | 4.1.1 Menú principal | Samantha Rodriguez |
| `include/archivos.hpp`, `src/archivos.cpp` | 4.1.2 Carga inicial y 4.1.5 Generación de CSV | Jefferson Sanchez |
| `include/validaciones.hpp`, `src/validaciones.cpp` | 4.1.3 Validaciones | Melissa Ruíz |
| `include/registro.hpp`, `src/registro.cpp` | 4.1.3 Registro | Melissa Ruíz |
| `include/estados.hpp`, `src/estados.cpp` | 4.1.4 Gestión de estados | Melissa Ruíz |
| `include/consultas.hpp`, `src/consultas.cpp` | 4.1.6 Consultas básicas | Samantha Rodriguez |
| `include/reporte.hpp`, `src/reporte.cpp` | 4.1.7 Reporte general | Samantha Rodriguez |
| `include/modelo.hpp` | Estructuras y valores permitidos (compartido) | Grupo |
| `include/utilidades.hpp`, `src/utilidades.cpp` | Texto, búsquedas y entrada por consola (compartido) | Grupo |
| `include/fa/fa.hpp`, `src/fa/fa_<nombre>.cpp` | Funcionalidades adicionales (opción 5 del menú) | Cada autor |

## Compilar y ejecutar

Desde la raíz del repositorio, con CMake:

```bash
cmake -S cpp -B cpp/build
cmake --build cpp/build
./cpp/build/turismo_cpp _datos
```

En Windows con un generador multiconfiguración, el ejecutable queda en
`cpp\build\Debug\turismo_cpp.exe`.

Sin CMake, con g++:

```bash
g++ -std=c++17 -Wall -Wextra -Icpp/include -o turismo cpp/src/*.cpp cpp/src/fa/*.cpp
./turismo _datos
```

El argumento es la carpeta de datos (por defecto `_datos`). Menú: 1 Registrar, 2 Gestionar estados,
3 Consultas, 4 Reporte general, 5 Funcionalidades adicionales y 0 Salir. Para ver el reporte sin
teclear:

```bash
printf '4\n0\n' | ./cpp/build/turismo_cpp _datos
```
