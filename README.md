# Ruta turística en una ciudad

Proyecto académico del curso Paradigmas de Programación. Modela una agencia de turismo que organiza recorridos entre hoteles, atractivos turísticos y miradores de Lima.

El sistema registra solicitudes de recorrido, encuentra rutas mediante conexiones habilitadas y asigna unidades de transporte compatibles con la cantidad de turistas. Se implementa en C++, Haskell y Prolog.

## Estructura

```text
paradigmas_turismo/
├── cpp/                    # Programación imperativa
│   ├── include/            # Un .hpp por funcionalidad, modelo.hpp, utilidades.hpp y fa/fa.hpp
│   ├── src/                # Un .cpp por funcionalidad, main.cpp y fa/fa_<nombre>.cpp
│   └── CMakeLists.txt
├── haskell/                # Programación funcional
│   ├── src/                # Tipos, LecturaCSV, Rutas, Reportes y FA/<Nombre>.hs
│   ├── app/Main.hs         # Programa principal (4.2.7)
│   └── turismo-haskell.cabal
├── prolog/                 # Programación lógica
│   ├── src/                # lecturaCSV.pl (4.3.1), red, rutas, atencion, inaccesibles, turismo y fa/
│   ├── app/                # main.pl (lectura de CSV) y demo.pl (un ejemplo de cada regla)
│   └── tests/pruebas.pl    # 55 pruebas plunit
├── _datos/                 # Fuente de datos compartida
│   ├── puntos.csv
│   ├── conexiones.csv
│   ├── unidades.csv
│   ├── solicitudes.csv
│   └── README.md
├── demo.sh                 # Demostración completa en macOS o Linux
├── BACKLOG.md              # Orden de trabajo, responsables y dependencias
├── CONTRATO.md             # Invariantes, nombres compartidos y decisiones de implementación
├── MEMORIA.md              # Registro de cambios del grupo
├── .gitignore
└── README.md
```

Cada archivo de código tiene un solo responsable, según el reparto del Anexo A (tabla de abajo). Los
archivos compartidos (`modelo.hpp`, `utilidades.*`, `Tipos.hs`, `turismo.pl` y los CSV) se cambian solo
con acuerdo del grupo.

## Módulos

- [`cpp/`](cpp/README.md): gestión de los datos, solicitudes, estados y archivos CSV.
- [`haskell/`](haskell/README.md): cálculo de rutas, costos y reportes funcionales.
- [`prolog/`](prolog/README.md): consultas sobre conexiones, alcanzabilidad y atención de solicitudes.

Los módulos se ejecutan por separado y comparten los archivos CSV de [`_datos/`](_datos/README.md) como única fuente de información. El módulo en C++ registra y actualiza los datos; inicialmente, Haskell y Prolog los usan en modo lectura. La ruta de la carpeta debe recibirse mediante un parámetro o una configuración para evitar copias de los CSV dentro de cada módulo.

## Datos principales

- [`puntos.csv`](_datos/puntos.csv)
- [`conexiones.csv`](_datos/conexiones.csv)
- [`unidades.csv`](_datos/unidades.csv)
- [`solicitudes.csv`](_datos/solicitudes.csv)

Los encabezados, valores válidos y reglas de integridad se documentan en [`_datos/README.md`](_datos/README.md).

Las funcionalidades adicionales pueden incorporar archivos complementarios, como `entradas.csv`, `visitantes.csv`, `cupos.csv` y `reservas.csv`.

## Compilación

### Módulo C++

Requiere un compilador con C++17 y CMake 3.16 o posterior. Desde la raíz del repositorio:

```bash
cmake -S cpp -B cpp/build
cmake --build cpp/build
./cpp/build/turismo_cpp _datos
```

En Windows, con un generador multiconfiguración, el ejecutable queda en
`cpp\build\Debug\turismo_cpp.exe`. Sin CMake se puede compilar con g++:

```bash
g++ -std=c++17 -Wall -Wextra -Icpp/include -o turismo cpp/src/*.cpp cpp/src/fa/*.cpp
./turismo _datos
```

Menú: 1 Registrar, 2 Gestionar estados, 3 Consultas, 4 Reporte general, 5 Funcionalidades adicionales
y 0 Salir. El detalle está en [`cpp/README.md`](cpp/README.md).

### Módulo Haskell

Requiere GHC y Cabal. Desde la carpeta `haskell/`:

```bash
cd haskell
cabal build
cabal run turismo-haskell -- ../_datos
cabal run turismo-haskell -- ../_datos S006 P011,P007,P006,P004
```

Los argumentos son `[carpeta] [codigo_solicitud] [ruta]`. En PowerShell la ruta va entre comillas.
Sin Cabal, desde la raíz: `runghc -ihaskell/src haskell/app/Main.hs _datos`. El detalle está en
[`haskell/README.md`](haskell/README.md).

### Módulo Prolog

1. Descargar e instalar [SWI-Prolog](https://www.swi-prolog.org/Download.html).
2. Cerrar y volver a abrir PowerShell.

Existen dos formas de ejecutarlo:

**Opción 1 — agregar SWI-Prolog al `PATH` (recomendada)**

Agregar la carpeta `bin` de la instalación de SWI-Prolog a la variable de entorno `PATH`, cerrar VS Code y volver a abrirlo. Después comprobar:

```powershell
swipl --version
```

Desde la raíz del repositorio:

```powershell
swipl prolog/app/main.pl -- _datos
```

**Opción 2 — ejecutar sin modificar el `PATH`**

Usar la ruta completa del ejecutable. En una instalación estándar de Windows:

```powershell
& "C:\Program Files\swipl\bin\swipl.exe" prolog/app/main.pl -- _datos
```

Si SWI-Prolog se instaló en otra ubicación, se debe reemplazar esa ruta.

Para realizar consultas manuales, entrar a la carpeta `prolog/` y usar una de estas dos formas:

```powershell
cd prolog
swipl
```

O, sin configurar el `PATH`:

```powershell
cd prolog
& "C:\Program Files\swipl\bin\swipl.exe"
```

Cuando aparezca el prompt `?-`, escribir las consultas sin copiar el propio símbolo `?-`:

```prolog
[src/lecturaCSV].
cargar_datos('../_datos').
punto(Codigo, Nombre, Tipo, Zona).
halt.
```

Para usar además las reglas de la sección 4.3, se carga `src/turismo.pl`, que reúne el lector
`src/lecturaCSV.pl` con las reglas:

```prolog
[src/turismo].
cargar_datos('../_datos').
conectado('P001', 'P003', Distancia).
```

Un ejemplo de cada regla, desde la raíz: `swipl prolog/app/demo.pl -- _datos`.

La documentación completa del módulo se encuentra en [`prolog/README.md`](prolog/README.md).

## Demostración y pruebas

En macOS o Linux, `./demo.sh` compila C++ en un directorio temporal, muestra su reporte, ejecuta
Haskell, la lectura de CSV y la demostración de Prolog, y corre las 55 pruebas plunit sobre una copia de
`_datos/`, sin modificarla. Las pruebas de Prolog también se corren solas:

```bash
swipl -g run_tests -t halt prolog/tests/pruebas.pl
```

## Funcionalidades y responsables

| Código | Funcionalidad | Módulo | Responsable |
|---|---|---|---|
| 4.1.1 | Menú principal | C++ | Samantha Rodriguez |
| 4.1.2 | Carga inicial | C++ | Jefferson Sanchez |
| 4.1.3 | Registro de información con validaciones | C++ | Melissa Ruíz |
| 4.1.4 | Gestión de estados | C++ | Melissa Ruíz |
| 4.1.5 | Generación de archivos CSV | C++ | Jefferson Sanchez |
| 4.1.6 | Consultas básicas | C++ | Samantha Rodriguez |
| 4.1.7 | Reporte general | C++ | Samantha Rodriguez |
| 4.2.1 | Lectura de archivos CSV | Haskell | Jefferson Sanchez |
| 4.2.2 | Definición de tipos | Haskell | Jefferson Sanchez |
| 4.2.3 | Función de vecinos | Haskell | Melissa Ruíz |
| 4.2.4 | Rutas posibles | Haskell | Melissa Ruíz |
| 4.2.5 | Costo de una ruta | Haskell | Melissa Ruíz |
| 4.2.6 | Reporte de solicitudes | Haskell | Samantha Rodriguez |
| 4.2.7 | Programa principal y resultado esperado | Haskell | Samantha Rodriguez |
| 4.3.1 | Lectura de CSV y base de conocimiento | Prolog | Melissa Ruíz |
| 4.3.2 | Regla de conexión directa | Prolog | Jefferson Sanchez |
| 4.3.3 | Regla de alcanzabilidad | Prolog | Jefferson Sanchez |
| 4.3.4 | Regla de ruta evitando un punto | Prolog | Samantha Rodriguez |
| 4.3.5 | Regla de atención de solicitudes | Prolog | Melissa Ruíz |
| 4.3.6 | Regla de solicitudes inaccesibles | Prolog | Samantha Rodriguez |
| FA01 | Recomendador explicable de atractivos por perfil | C++ y Prolog | Samantha Rodriguez |
| FA02 | Selección de atractivos dentro de un presupuesto | C++ y Haskell | Melissa Ruíz |
| FA03 | Reservas de cupos por turno con lista de espera | C++ | Jefferson Sanchez |

## Grupo 4 - Integrantes

- Samantha Camila Rodriguez Melendez
- Melissa Alexandra Ruíz Delgado
- Jefferson Angelo Sanchez Palacios
