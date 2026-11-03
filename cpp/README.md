# Módulo C++

Implementación orientada a objetos del dominio turístico. Requiere CMake 3.16
o posterior y un compilador compatible con C++17.

## Compilar y ejecutar

```bash
cmake -S . -B build
cmake --build build
./build/turismo_cpp
```

En Windows con un generador multiconfiguración, el ejecutable puede quedar en
`build/Debug/turismo_cpp.exe`.

## Ejecutar pruebas

```bash
ctest --test-dir build -C Debug --output-on-failure
```

Si se usa un generador de configuración única (por ejemplo, Ninja o Make), el
argumento `-C Debug` puede omitirse.

