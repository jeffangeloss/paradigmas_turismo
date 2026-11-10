# Módulo C++

Implementación orientada a objetos del dominio turístico. Requiere CMake 3.16
o posterior y un compilador compatible con C++17.

## Compilar y ejecutar

```bash
"C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\Common7\Tools\VsDevCmd.bat"
cmake -S . -B build
cmake --build build
build\turismo_cpp.exe
```

En Windows con un generador multiconfiguración, el ejecutable puede quedar en
`build/Debug/turismo_cpp.exe`.

Ejecuta el programa desde `cpp/` o desde la raíz del repositorio para que
encuentre `_datos/`. El menú permite consultar registros por código, mostrar
el reporte general, iniciar Haskell o Prolog y registrar los perfiles y
características que utiliza FA01. SWI-Prolog y Cabal deben estar disponibles
en `PATH` para abrir esos módulos desde el menú.

Para una recomendación FA01, registra primero el perfil y los datos de los
puntos y conexiones en la opción 7. Luego abre Prolog desde la opción 6 y
selecciona FA01 en su menú.

El lector CSV de C++ usa separación sencilla por comas. Los campos no deben
contener comas internas ni comillas escapadas. Las categorías e intereses se
guardan en filas separadas.

## Ejecutar pruebas

```bash
ctest --test-dir build -C Debug --output-on-failure
```

Si se usa un generador de configuración única (por ejemplo, Ninja o Make), el
argumento `-C Debug` puede omitirse.

