# Contrato de datos y de módulos · Grupo 4 · Ruta turística en Lima

El formato de los CSV (encabezados, valores válidos y reglas de integridad) está en
[`_datos/README.md`](_datos/README.md). Este archivo fija lo que el grupo necesita además: cómo se
traduce el enunciado al escenario, las invariantes que mantiene C++, los nombres que comparten los
módulos y las decisiones de implementación. C++ es el único que escribe los CSV; Haskell y Prolog solo
los leen. Si un módulo necesita otro dato, se agrega como columna al final o en un CSV nuevo, y se
documenta en los dos archivos.

## Escenario

Una agencia de turismo de Lima organiza recorridos entre atractivos, hoteles y miradores. Los turistas
piden un traslado (solicitud de recorrido) y la agencia lo atiende con un bus turístico, un taxi
turístico o un guía peatonal. La red usa lugares reales y distancias aproximadas.

| Enunciado (sección 3) | En este escenario |
|---|---|
| puntos.csv | puntos.csv (atractivos, hoteles, miradores) |
| conexiones.csv | conexiones.csv (tramos entre dos puntos, con código propio) |
| unidades.csv | unidades.csv (`bus_turistico`, `taxi_turistico`, `guia_peatonal`) |
| pedidos.csv | solicitudes.csv (solicitudes de recorrido) |
| carga | `cantidad_turistas` (número de personas del grupo) |
| capacidad | capacidad (personas) |
| pendiente / asignado / entregado | pendiente / asignada / entregada |

## Reglas comunes

- Carpeta de datos: `_datos/` en la raíz. C++ y Haskell reciben la carpeta como primer argumento (por
  defecto `_datos`, ejecutados desde la raíz). Prolog la recibe en `cargar_datos/1`.
- Códigos en mayúsculas y con tres dígitos: `P001`, `C001`, `U001`, `S001`. C++ los pasa a mayúsculas
  al leer y al registrar.
- Prolog conserva los códigos tal como están en el CSV, así que en las consultas van entre comillas
  simples (`'P001'`). La unidad vacía de una solicitud pendiente queda como `''`.
- Decimales con punto. C++ escribe `distancia_km` y `costo_km` con 2 decimales (`0.80`, `4.50`).
- Ningún campo de texto lleva comas. Los datos de prueba usan solo texto ASCII.

## Invariantes que C++ mantiene

1. Una unidad `ocupada` tiene exactamente una solicitud `asignada`; una `disponible` no tiene ninguna.
2. Asignar: solicitud `pendiente` + unidad `disponible` + `capacidad >= cantidad_turistas` → solicitud
   `asignada` con esa unidad y unidad `ocupada`.
3. Marcar entregada: solo una solicitud `asignada` → pasa a `entregada`, conserva su unidad en
   `unidad_asignada` y la unidad vuelve a `disponible`.
4. Toda solicitud nueva nace `pendiente` y sin unidad; toda unidad nueva nace `disponible`; toda
   conexión nueva nace `habilitada`.
5. Cada cambio se guarda de inmediato en los CSV.
6. Ningún código se repite dentro de su archivo, y una conexión no se repite en ningún sentido.

## Datos de prueba (estado inicial)

- 11 puntos, 16 conexiones (14 habilitadas, 2 cerradas), 4 unidades (2 disponibles), 9 solicitudes
  (4 pendientes, 2 asignadas, 3 entregadas).
- `C016` (P001-P010) está cerrada y es la única conexión de P010 (Cerro San Cristobal), así que la
  solicitud pendiente `S006` (P002 → P010) es inaccesible. `C012` (P005-P007) está cerrada pero hay
  desvío por P006.
- U001 es la unidad con más solicitudes (S001, S003, S008).
- Pendientes por prioridad: S004 (alta), S002 (media), S006 (media), S009 (baja).

## Nombres que comparten los módulos

| Concepto | C++ (`cpp/include/modelo.hpp`) | Haskell (`haskell/src/Tipos.hs`) | Prolog (`prolog/src/lecturaCSV.pl`) |
|---|---|---|---|
| Punto | `struct Punto` | `data Punto` | `punto(Codigo, Nombre, Tipo, Zona)` |
| Conexión | `struct Conexion` | `data Conexion` | `conexion(Codigo, Origen, Destino, DistanciaKm, TiempoMin, Estado)` |
| Unidad | `struct Unidad` | `data Unidad` | `unidad(Codigo, Tipo, Capacidad, CostoKm, Estado)` |
| Solicitud | `struct Solicitud` | `data Solicitud` | `solicitud(Codigo, Origen, Destino, Cantidad, Prioridad, Estado, UnidadAsignada)` |

## Decisiones de implementación

Esta sección describe lo que el código hace hoy. Cada función o predicado citado está en el archivo de
su sección del enunciado (mapa en `README.md`, sección Estructura).

### 1. Unidad con más solicitudes (C++, reporte general)

- Cuenta las solicitudes cuya `unidad_asignada` es el código de la unidad, sea `asignada` o
  `entregada`. Una `pendiente` no tiene unidad y no suma.
- Recorre las unidades en el orden de `unidades.csv` y reemplaza al líder solo con una cuenta
  estrictamente mayor. En un empate gana la unidad que aparece primero en el archivo.
- Si ninguna unidad tiene solicitudes, imprime `Unidad con mas solicitudes: ninguna`.
- Con los datos de prueba imprime `U001 (3 solicitudes)`. Haskell y Prolog no calculan este dato.

### 2. Qué cuenta como carga de una unidad (C++ y Haskell no coinciden a propósito)

| Salida | Criterio | U001 | U002 | U003 | U004 |
|---|---|---|---|---|---|
| C++, menú 3 > 4 («Solicitudes de U001 (asignadas y entregadas)») y reporte | Solicitudes con esa unidad, `asignada` o `entregada`. Cuenta solicitudes. | 3 | 1 | 0 | 1 |
| Haskell, «Carga asignada por unidad (turistas en solicitudes asignadas)» (`turistasPorUnidad`) | Suma de `cantidad_turistas` solo de solicitudes `asignada` (en curso). Cuenta personas. | 20 | 0 | 0 | 2 |

- C++ lleva el historial de la unidad y Haskell la carga actual. U002 lo muestra: entregó S007 (3
  turistas), así que para C++ tiene una solicitud y para Haskell su carga es 0.
- Por la invariante 1, Haskell muestra un valor distinto de cero solo para unidades ocupadas.
- Las dos salidas lo dicen en su rótulo, y cada integrante debe poder explicar la diferencia.

### 3. Unidades en la comparación de costos de Haskell (`unidadesPorTipo`)

- Entran las unidades `disponible` con `capacidad >= cantidad_turistas` de la solicitud elegida, el
  mismo criterio de unidad que `puede_atender` en Prolog.
- Se muestra una sola unidad por tipo, la primera en el orden de `unidades.csv`.
- En la solicitud S004 (4 turistas) quedan fuera U001 y U004 por ocupadas, y salen U002
  (`taxi_turistico`) y U003 (`guia_peatonal`).
- El costo es `km de la ruta más corta (por distancia) x costo_km` de la unidad. En S004 son 5.40 km,
  es decir S/ 9.72 en taxi turístico y S/ 4.32 con guía peatonal.
- No mira el estado de la solicitud: con `codigo_solicitud` se pueden comparar costos de una solicitud
  ya `asignada` o `entregada`.

### 4. `puede_atender(Unidad, Solicitud)` (Prolog)

- Se cumple si la unidad está `disponible`, `capacidad >= cantidad_turistas` **y la solicitud está
  `pendiente`**. El enunciado (4.3.5) pide solo las dos primeras condiciones; la tercera respeta la
  invariante 2, porque C++ no reasigna una solicitud `asignada` ni `entregada`.
- `findall(U-S, puede_atender(U, S), L)` devuelve
  `['U002'-'S002', 'U002'-'S004', 'U003'-'S002', 'U003'-'S004', 'U003'-'S006', 'U003'-'S009']`.
- No evalúa el tipo de unidad ni si el destino es alcanzable: `'S006'` (inaccesible) aparece con U003.

### 5. Filas mal formadas

| Módulo | Qué hace |
|---|---|
| C++ | Valida cada fila con las mismas reglas del registro. La omite y avisa `AVISO: <archivo> linea N omitida: <motivo>`. **Esas filas se pierden en el siguiente guardado**, porque C++ reescribe los cuatro CSV desde memoria. |
| Haskell | Descarta la fila si no tiene el número exacto de campos, si un número no se lee o si un enumerado no es válido, y avisa por `stderr` el total por archivo. No valida códigos repetidos ni referencias. |
| Prolog (`lecturaCSV.pl`) | Una fila con otro número de campos lanza un error (`row_arity`) y detiene la carga. Un valor no numérico, como `abc` en `distancia_km`, se carga como átomo. No valida tipos ni referencias. |

Como C++ es el único que escribe, los CSV que guarda siempre son válidos. El riesgo existe solo si
alguien edita los CSV a mano.

### 6. Carpeta de datos vacía o inexistente

- C++ inicia con una carpeta vacía, avisa de cada archivo ausente y crea los cuatro CSV con su
  encabezado en el primer cambio. Con una carpeta inexistente avisa además que los cambios no se podrán
  guardar.
- Haskell termina con `No se pudo leer el archivo` si falta cualquiera de los cuatro CSV.
- Prolog: `cargar_datos/1` borra la base antes de leer, así que una carga fallida (carpeta inexistente o
  fila con otro número de campos) la deja vacía. Se vuelve a llamar con una carpeta válida.
- Mejoras opcionales, que decide la responsable de 4.3.1, son leer antes de borrar y capturar el error
  con `catch/3`.

## Datos de las funcionalidades adicionales

Cada FA documenta aquí sus CSV o columnas nuevas antes de programarlas, y solo su autor edita su
subsección. Una FA usa de preferencia un CSV propio en `_datos/`. Una columna nueva en uno de los cuatro
CSV base cambia la lectura y la escritura de los tres módulos, así que se acuerda en grupo.

### FA01 de Samantha Rodriguez · Recomendador explicable de atractivos por perfil

Pendiente.

### FA02 de Melissa Ruíz · Selección de atractivos dentro de un presupuesto

Pendiente.

### FA03 de Jefferson Sanchez · Reservas de cupos por turno con lista de espera

Pendiente.
