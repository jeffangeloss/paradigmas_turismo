# Ruta turística en una ciudad

Proyecto académico del curso Paradigmas de Programación. Modela una agencia de turismo que organiza recorridos entre hoteles, atractivos turísticos y miradores de Lima.

El sistema registra solicitudes de recorrido, encuentra rutas mediante conexiones habilitadas y asigna unidades de transporte compatibles con la cantidad de turistas. Se implementa en C++, Haskell y Prolog.

## Estructura

```text
paradigmas_turismo/
├── cpp/                    # Programación imperativa
├── haskell/                # Programación funcional
├── prolog/                 # Programación lógica
├── datos/                  # Fuente de datos compartida
│   ├── puntos.csv
│   ├── conexiones.csv
│   ├── unidades.csv
│   ├── solicitudes.csv
│   └── README.md
├── .gitignore
└── README.md
```

## Módulos

- [`cpp/`](cpp/README.md): gestión de los datos, solicitudes, estados y archivos CSV.
- [`haskell/`](haskell/README.md): cálculo de rutas, costos y reportes funcionales.
- [`prolog/`](prolog/README.md): consultas sobre conexiones, alcanzabilidad y atención de solicitudes.

Los módulos se ejecutan por separado y comparten los archivos CSV de [`datos/`](datos/README.md) como única fuente de información. El módulo en C++ registra y actualiza los datos; inicialmente, Haskell y Prolog los usan en modo lectura. La ruta de la carpeta debe recibirse mediante un parámetro o una configuración para evitar copias de los CSV dentro de cada módulo.

## Datos principales

- [`puntos.csv`](_datos/puntos.csv)
- [`conexiones.csv`](_datos/conexiones.csv)
- [`unidades.csv`](_datos/unidades.csv)
- [`solicitudes.csv`](_datos/solicitudes.csv)

Los encabezados, valores válidos y reglas de integridad se documentan en [`_datos/README.md`](_datos/README.md).

Las funcionalidades adicionales pueden incorporar archivos complementarios, como `entradas.csv`, `visitantes.csv`, `cupos.csv` y `reservas.csv`.

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

## Grupo 4 -- Integrantes

- Samantha Camila Rodriguez Melendez
- Melissa Alexandra Ruíz Delgado
- Jefferson Angelo Sanchez Palacios
