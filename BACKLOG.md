# Backlog · Grupo 4 · Ruta turística en Lima

Este backlog dice quién hace qué y en qué orden hasta la entrega del 16/11, de modo que tres personas
trabajen en paralelo sobre el mismo repositorio sin pisarse. El orden sale de las dependencias entre
archivos, y cada archivo tiene un solo responsable. Un ítem cambia de estado en el mismo commit que lo
cierra, dentro de la tabla de su responsable.

## Fechas que no se mueven

| Fecha | Entregable | Enunciado |
|---|---|---|
| 01/11, 23:59 | `Propuesta_G4.docx` (Anexo A) con el reparto de la base y la funcionalidad adicional (FA) de cada integrante, sin cambios posteriores | §6 |
| 16/11, 23:59 | Código fuente, CSV, README, informe técnico y video | §6.1 a §6.3 |
| 17/11 | Exposición grupal y sustentación individual | §7 |

## Cómo se organiza el repositorio

El código de cada módulo está dividido en un archivo por sección del enunciado, y el responsable de esa
sección según el Anexo A es el único que edita el archivo. Las FA ya tienen su archivo propio en cada
lenguaje y un punto de entrada en el sistema, así que nadie toca el menú ni el `main` de otro para
integrar la suya. El árbol completo está en `README.md`, sección Estructura.

| Archivo | Contenido | Responsable | Tipo |
|---|---|---|---|
| `cpp/src/main.cpp` | 4.1.1 Menú principal y submenú de FA | Samantha | Propio |
| `cpp/{include,src}/archivos.*` | 4.1.2 Carga inicial y 4.1.5 Generación de CSV | Jefferson | Propio |
| `cpp/{include,src}/validaciones.*` | 4.1.3 Validaciones | Melissa | Propio |
| `cpp/{include,src}/registro.*` | 4.1.3 Registro | Melissa | Propio |
| `cpp/{include,src}/estados.*` | 4.1.4 Gestión de estados | Melissa | Propio |
| `cpp/{include,src}/consultas.*` | 4.1.6 Consultas básicas | Samantha | Propio |
| `cpp/{include,src}/reporte.*` | 4.1.7 Reporte general | Samantha | Propio |
| `haskell/src/LecturaCSV.hs` | 4.2.1 Lectura de CSV | Jefferson | Propio |
| `haskell/src/Rutas.hs` | 4.2.3 Vecinos, 4.2.4 Rutas posibles y 4.2.5 Costo de una ruta | Melissa | Propio |
| `haskell/src/Reportes.hs` | 4.2.6 Reporte de solicitudes | Samantha | Propio |
| `haskell/app/Main.hs` | 4.2.7 Programa principal y llamada a las FA | Samantha | Propio |
| `prolog/src/lecturaCSV.pl` | 4.3.1 Lectura de CSV y base de conocimiento | Melissa | Propio |
| `prolog/src/red.pl` | 4.3.2 Conexión directa y 4.3.3 Alcanzabilidad | Jefferson | Propio |
| `prolog/src/rutas.pl` | 4.3.4 Ruta evitando un punto | Samantha | Propio |
| `prolog/src/atencion.pl` | 4.3.5 Atención de solicitudes | Melissa | Propio |
| `prolog/src/inaccesibles.pl` | 4.3.6 Solicitudes inaccesibles | Samantha | Propio |
| `cpp/src/fa/fa_<nombre>.cpp`, `haskell/src/FA/<Nombre>.hs`, `prolog/src/fa/fa_<nombre>.pl` | FA de cada integrante | Su autor | Propio |
| `cpp/include/modelo.hpp` | Estructuras y valores permitidos | Custodio Jefferson | Compartido |
| `haskell/src/Tipos.hs` | 4.2.2 Tipos propios | Custodio Jefferson | Compartido |
| `_datos/*.csv` (los cuatro base) | Datos de prueba | Custodio Jefferson | Compartido |
| `cpp/{include,src}/utilidades.*` | Texto, búsquedas y entrada por consola | Custodio Melissa | Compartido |
| `prolog/src/turismo.pl` | Punto de entrada y `demo` | Custodio Melissa | Compartido |
| `cpp/include/fa/fa.hpp` | Puntos de entrada de las FA en C++ | Custodio Samantha | Compartido |
| `demo.sh`, `README.md` (sección de FA), `CONTRATO.md` (sección de FA), `prolog/tests/pruebas.pl` | Un bloque por integrante o por regla | Cada uno en su bloque | Por bloques |

Un archivo propio lo cambia su responsable cuando quiere, en su rama. Un archivo compartido se congela
al cerrar la fase 1, y desde entonces un cambio pasa por un pull request que revisan los tres, porque
lo usan todos los demás. En un archivo por bloques cada integrante edita solo lo que está entre sus
marcas (`# >>> FA <nombre>` y `# <<< FA <nombre>` en `demo.sh`, su subtítulo en README y CONTRATO, sus
`begin_tests` en `pruebas.pl`) y deja intactas las líneas de separación.

El 01/11 se simula el flujo con tres ramas, una por integrante, que editan su FA en los tres lenguajes,
su bloque de `demo.sh` y sus secciones de README y CONTRATO. Las tres se fusionan en `develop` sin
conflictos y `./demo.sh` termina sin fallos.

## Qué depende de qué

Un cambio en la primera columna obliga a avisar a quien figura en la última, porque su código lo usa.

| Si cambia | Lo usan | Avisar a |
|---|---|---|
| `cpp/{include,src}/validaciones.*` (Melissa) | La carga de `archivos.cpp`, que valida cada fila de los CSV con las mismas reglas | Jefferson |
| `guardarTodo` en `cpp/{include,src}/archivos.*` (Jefferson) | `registro.cpp` y `estados.cpp`, que guardan después de cada cambio | Melissa |
| `cpp/include/modelo.hpp` o `haskell/src/Tipos.hs` | Todos los archivos de su lenguaje | Los tres |
| `mayus`, `quitarEspacios` o `separar` en `LecturaCSV.hs` (Jefferson) | `leerRuta` en `Rutas.hs` | Melissa |
| `rutasPosibles`, `costoRuta` o `rutasConCosto` en `Rutas.hs` (Melissa) | `resumen` y `probarRuta` en `Turismo.hs` | Samantha |
| `conectado/3` o `alcanzable/2` en `red.pl` (Jefferson) | `ruta_evitando/4` y `solicitudes_inaccesibles/1` | Samantha |
| Los hechos de `lecturaCSV.pl` (Melissa) | Todas las reglas de Prolog y sus pruebas | Los tres |
| Cualquier fila de `_datos/*.csv` | Las 55 pruebas de `pruebas.pl`, que cuentan 11 puntos, 16 conexiones, 4 unidades y 9 solicitudes | Los tres |
| Una invariante de `CONTRATO.md` | C++, Haskell y Prolog | Los tres |

Por estas dependencias, la fase 1 fija primero todo lo compartido y después cada uno trabaja solo en
sus archivos.

## Reglas de trabajo con git

- `main` guarda solo versiones que pasan `./demo.sh`, y `develop` integra el trabajo de los tres.
- Cada ítem se trabaja en una rama corta desde `develop`, con el nombre `feat/<id>-<slug>` (por
  ejemplo `feat/b-4.1.6-consultas` o `feat/fa-m-tours`), que se fusiona en dos días como máximo.
- Antes de abrir el pull request se trae lo último de `develop` y se corre `./demo.sh` sin fallos.
- Otro integrante revisa cada pull request antes de fusionarlo.
- Cada integrante sube su propio trabajo desde su cuenta, y el mensaje del commit empieza con el ID
  del ítem, por ejemplo `B-4.1.6 agrega el caso de unidad sin solicitudes`.
- El informe no va en git, porque un `.docx` no se fusiona. Se edita en línea (Word en OneDrive o
  Google Docs), y `.gitignore` ignora los `.docx`.

```bash
git switch develop && git pull
git switch -c feat/b-4.1.6-consultas
# cambios solo en los archivos propios
./demo.sh
git add cpp/consultas.cpp cpp/consultas.hpp
git commit -m "B-4.1.6 agrega el caso de unidad sin solicitudes"
git push -u origin feat/b-4.1.6-consultas
# pull request a develop y revisión de otro integrante
```

## Fases

| Fase | Fechas | Meta | Bloquea a |
|---|---|---|---|
| F0 | 01/11 | Repositorio organizado y propuesta entregada | Todo lo demás |
| F1 | 02/11 a 03/11 | Repositorio en línea, FA especificadas y archivos compartidos congelados | F2 y F3 |
| F2 | 04/11 a 07/11 | Cada uno domina, prueba y documenta su base | La sustentación |
| F3 | 04/11 a 11/11 | Cada FA con datos, lógica y pruebas en sus propios archivos | F4 |
| F4 | 10/11 a 13/11 | Fusión escalonada de las FA en `develop` | F5 |
| F5 | 14/11 a 16/11 | Código congelado, video, informe final y entrega | F6 |
| F6 | 17/11 | Exposición y sustentación | |

F2 y F3 corren en paralelo porque tocan archivos distintos. El informe avanza fuera de git desde F2.

### F0 · Hoy, 01/11

| ID | Ítem | Responsable | Límite | Criterio de hecho | Estado |
|---|---|---|---|---|---|
| F0-01 | Repartir las funcionalidades base en el Anexo A | Jefferson | 01/11 | Las 20 quedan asignadas una sola vez | Hecho |
| F0-02 | Dividir el código en un archivo por responsable, con puntos de entrada para las FA | Jefferson | 01/11 | 19 casos de prueba dan la misma salida que antes, salvo el menú, que gana la opción 5, y la simulación de tres ramas se fusiona sin conflictos | Hecho |
| F0-03 | Elegir la FA de cada integrante | Cada uno | 01/11, 18:00 | Tres FA distintas, que no son variantes de la base ni se pisan entre sí (§5) | Hecho |
| F0-04 | Llenar la tabla propia de FA en el Anexo A | Cada uno | 01/11, 21:00 | Nombre, descripción, lenguajes, datos nuevos y ejemplo, con el ajuste que sugiere `ideas_FA_por_escenario.md` | Hecho |
| F0-05 | Igualar los tipos enumerados del Anexo A al código | Jefferson | 01/11, 21:00 | El Anexo dice `{Pendiente, Asignado, Entregado}` y el código usa `Pendiente`, `Asignada` y `Atendida`, así que la tabla del Anexo pasa a los nombres del código | Hecho |
| F0-06 | Entregar `Propuesta_G4.docx` | Jefferson | 01/11, 23:59 | Archivo con ese nombre y las secciones A a D completas | Pendiente |

Las FA quedan elegidas el 01/11, una por paradigma. Samantha toma el recomendador por perfil (Prolog),
Melissa los paquetes dentro de un presupuesto y un tiempo (Haskell) y Jefferson las reservas de cupos
(C++). Cada tabla del Anexo deja escrito lo que su FA no hace, para que la de Samantha y la de Melissa no
se solapen.

### F1 · Repositorio y contrato, 02/11 a 03/11

Nadie programa su FA hasta que F1 cierra, porque F1 decide qué archivos compartidos cambian.

| ID | Ítem | Responsable | Límite | Criterio de hecho | Estado |
|---|---|---|---|---|---|
| F1-01 | Crear el repositorio con el código actual como primer commit en `main` y abrir `develop` | Jefferson | 02/11 | `git log` muestra el commit inicial y `./demo.sh` pasa en un clon limpio | Pendiente |
| F1-02 | Crear el remoto privado, dar acceso a Samantha y Melissa y proteger `main` | Jefferson | 02/11 | Los tres clonan y `main` solo acepta pull requests | Pendiente |
| F1-03 | Instalar g++, GHC y SWI-Prolog, clonar y correr `./demo.sh` | Cada uno | 02/11 | Captura del resultado sin fallos en cada computadora | Pendiente |
| F1-04 | Especificar la FA propia en su subsección de `CONTRATO.md` | Cada uno | 03/11 | CSV nuevos con sus columnas, y una lista explícita de lo compartido que necesita cambiar, o «ninguno» | Pendiente |
| F1-05 | Aplicar en una sola rama `contrato/compartidos` los cambios que pidan las FA en archivos compartidos | Jefferson y Melissa | 03/11 | Columnas nuevas en `modelo.hpp`, `archivos.cpp`, `Tipos.hs` y `LecturaCSV.hs` (Jefferson) y en `validaciones.cpp`, `lecturaCSV.pl` y las pruebas de lectura (Melissa), o cierre sin cambios si ninguna FA los pide | Pendiente |
| F1-06 | Congelar los archivos compartidos y los cuatro CSV base | Grupo | 03/11 | Mensaje en el grupo con el commit de `develop` que queda como base | Pendiente |

Con la combinación sugerida, solo la FA de Melissa toca algo compartido, porque un tour pone varias
solicitudes en una misma unidad y eso cambia la invariante 1 de `CONTRATO.md`. Esa decisión se toma en
F1-04 y su código cae en `estados.cpp` y `atencion.pl`, que ya son de Melissa. Las FA de Samantha y
Jefferson usan CSV propios y no cambian nada compartido.

### F2 · Base apropiada, 04/11 a 07/11

Una funcionalidad base está hecha cuando su responsable cumple cuatro condiciones.

1. Explica cada función de su archivo sin notas y nombra el concepto del paradigma que usa.
2. Prueba su parte con un caso propio además de `./demo.sh`, incluido un caso que debe fallar.
3. Comprueba que los comentarios documentan las partes principales (§6.1).
4. Ensaya, en una rama descartable, la modificación en vivo que propone
   `../preguntas_sustentacion_G4.md` para su módulo o una equivalente.

#### Samantha Rodriguez

| ID | Funcionalidad | Archivo | Estado |
|---|---|---|---|
| B-4.1.1 | Menú principal | `cpp/src/main.cpp` | Pendiente |
| B-4.1.6 | Consultas básicas | `cpp/{include,src}/consultas.*` | Pendiente |
| B-4.1.7 | Reporte general | `cpp/{include,src}/reporte.*` | Pendiente |
| B-4.2.6 | Reporte de solicitudes | `haskell/src/Reportes.hs` | Pendiente |
| B-4.2.7 | Resultado esperado | `haskell/app/Main.hs` | Pendiente |
| B-4.3.4 | Ruta evitando un punto | `prolog/src/rutas.pl` | Pendiente |
| B-4.3.6 | Solicitudes inaccesibles | `prolog/src/inaccesibles.pl` | Pendiente |

#### Melissa Ruíz

| ID | Funcionalidad | Archivo | Estado |
|---|---|---|---|
| B-4.1.3 | Registro con validaciones | `cpp/{include,src}/registro.*`, `cpp/{include,src}/validaciones.*` | Pendiente |
| B-4.1.4 | Gestión de estados | `cpp/{include,src}/estados.*` | Pendiente |
| B-4.2.3 | Vecinos | `haskell/src/Rutas.hs` | Pendiente |
| B-4.2.4 | Rutas posibles | `haskell/src/Rutas.hs` | Pendiente |
| B-4.2.5 | Costo de una ruta | `haskell/src/Rutas.hs` | Pendiente |
| B-4.3.1 | Lectura de CSV | `prolog/src/lecturaCSV.pl` | Pendiente |
| B-4.3.5 | Atención de solicitudes | `prolog/src/atencion.pl` | Pendiente |

#### Jefferson Sanchez

| ID | Funcionalidad | Archivo | Estado |
|---|---|---|---|
| B-4.1.2 | Carga inicial | `cpp/{include,src}/archivos.*` | Pendiente |
| B-4.1.5 | Generación de CSV | `cpp/{include,src}/archivos.*` | Pendiente |
| B-4.2.1 | Lectura de CSV | `haskell/src/LecturaCSV.hs` | Pendiente |
| B-4.2.2 | Definición de tipos | `haskell/src/Tipos.hs` | Pendiente |
| B-4.3.2 | Conexión directa | `prolog/src/red.pl` | Pendiente |
| B-4.3.3 | Alcanzabilidad | `prolog/src/red.pl` | Pendiente |

### F3 · Funcionalidades adicionales, 04/11 a 11/11

Cada FA sigue las mismas tareas, todas dentro de los archivos de su autor. El ID lleva el prefijo del
integrante y el número de la tarea, por ejemplo `FA-M-03`.

| Tarea | Ítem | Límite | Criterio de hecho | FA-S | FA-M | FA-J |
|---|---|---|---|---|---|---|
| | Nombre | 01/11 | Igual al del Anexo A | Recomendador explicable de atractivos y miradores por perfil (Prolog) | Paquetes de atractivos dentro de un presupuesto y un tiempo (Haskell) | Reservas de cupos por turno con lista de espera (C++) |
| 01 | Especificación | 03/11 | Es F1-04 | Pendiente | Pendiente | Pendiente |
| 02 | Datos de prueba y su registro desde C++ | 06/11 | CSV propios en `_datos/` y su registro y validación en `cpp/src/fa/fa_<nombre>.cpp`, porque C++ es el único que escribe CSV | Pendiente | Pendiente | Pendiente |
| 03 | Lógica principal | 09/11 | Implementada en el lenguaje de la FA con `FA - Autor` | Pendiente | Pendiente | Pendiente |
| 04 | Pruebas y demo | 11/11 | Casos que deben pasar y casos que deben fallar, y su bloque de `demo.sh` | Pendiente | Pendiente | Pendiente |
| 05 | README | 11/11 | Su sección de FA con comandos y resultado esperado | Pendiente | Pendiente | Pendiente |

### F4 · Integración escalonada, 10/11 a 13/11

Las FA entran a `develop` una por día, empezando por la que toca lo compartido, para que las siguientes
se prueben sobre la versión real.

| ID | Ítem | Responsable | Límite | Criterio de hecho | Estado |
|---|---|---|---|---|---|
| F4-01 | Fusionar la FA que cambia algo compartido (con la combinación sugerida, la de Melissa) | Su autor | 10/11 | Pull request revisado y `./demo.sh` sin fallos en `develop` | Pendiente |
| F4-02 | Fusionar la segunda FA | Su autor | 11/11 | Igual que F4-01 | Pendiente |
| F4-03 | Fusionar la tercera FA | Su autor | 12/11 | Igual que F4-01 | Pendiente |
| F4-04 | Prueba cruzada, en la que cada uno ejecuta la FA de otro siguiendo solo el README | Grupo | 13/11 | Las tres FA funcionan en las tres computadoras | Pendiente |

### F5 · Cierre y entrega, 14/11 a 16/11

| ID | Ítem | Responsable | Límite | Estado |
|---|---|---|---|---|
| R-01 | README final, revisado contra los comandos reales | Jefferson | 14/11 | Pendiente |
| R-02 | Comprobar los mínimos de la sección 3 después de sumar los datos de las FA | Jefferson | 14/11 | Pendiente |
| R-03 | Congelar el código, fusionar `develop` en `main` y etiquetar `entrega-final` | Jefferson | 14/11 | Pendiente |
| R-04 | Enviar el código, los CSV, el README, el informe y el video | Jefferson | 16/11, 23:59 | Pendiente |

## Trabajo fuera de git

### Informe técnico (§6.3)

| ID | Sección | Responsable | Límite | Estado |
|---|---|---|---|---|
| I-01 | 1. Carátula | Jefferson | 12/11 | Pendiente |
| I-02 | 2. Introducción | Samantha | 10/11 | Pendiente |
| I-03 | 3. Trabajos relacionados, con dos papers por integrante sin repetir (elegidos el 05/11) | Cada uno | 09/11 | Pendiente |
| I-04 | 4. Metodología general, 4.a flujo entre módulos y 4.b archivos CSV | Jefferson | 11/11 | Pendiente |
| I-05 | 4.c, 4.d y 4.e, donde cada uno describe sus archivos y consolidan Samantha (C++), Melissa (Haskell) y Jefferson (Prolog) | Cada uno | 11/11 | Pendiente |
| I-06 | 4.f Funcionalidades adicionales, cada una con su autor y lenguajes | Cada uno | 12/11 | Pendiente |
| I-07 | 5. Resultados de los tres módulos base, con capturas | Samantha | 12/11 | Pendiente |
| I-08 | 5. Resultados de cada FA | Cada uno | 13/11 | Pendiente |
| I-09 | 6. Análisis comparativo de paradigmas | Melissa | 12/11 | Pendiente |
| I-10 | 7. Conclusiones | Samantha | 13/11 | Pendiente |
| I-11 | 8. Aportes, cada uno el suyo, con los archivos de este backlog como evidencia | Cada uno | 14/11 | Pendiente |
| I-12 | 9. Referencias en APA y formato final | Jefferson | 15/11 | Pendiente |
| I-13 | Declaración del uso de herramientas de IA según los lineamientos de la Universidad de Lima, con la herramienta, la finalidad y el alcance, previa confirmación con el sílabo o la docente | Grupo | 15/11 | Pendiente |
| I-14 | Revisión cruzada, en la que cada integrante lee la sección de otro | Grupo | 15/11 | Pendiente |

### Video (§6.2, máximo 10 minutos)

| ID | Ítem | Responsable | Límite | Estado |
|---|---|---|---|---|
| V-01 | Guion con el orden de las pruebas y el tiempo de cada una | Melissa | 13/11 | Pendiente |
| V-02 | Grabación de las pruebas de su base y de su FA, explicando qué se prueba y qué resulta | Cada uno | 14/11 | Pendiente |
| V-03 | Edición y montaje, con duración final de 10 minutos o menos | Melissa | 15/11 | Pendiente |

### Exposición y sustentación (§7)

| ID | Ítem | Responsable | Límite | Estado |
|---|---|---|---|---|
| E-01 | Diapositivas consolidadas | Samantha | 15/11 | Pendiente |
| E-02 | Escenario y problema, y conclusiones | Samantha | 15/11 | Pendiente |
| E-03 | Trabajos relacionados, en el que cada uno presenta sus dos papers | Cada uno | 15/11 | Pendiente |
| E-04 | Metodología y principales componentes | Jefferson | 15/11 | Pendiente |
| E-05 | Análisis comparativo de paradigmas | Melissa | 15/11 | Pendiente |
| E-06 | Ensayo general cronometrado | Grupo | 16/11 | Pendiente |
| E-07 | Simulacro individual con `../preguntas_sustentacion_G4.md` y la pregunta probable de su FA | Cada uno | 16/11 | Pendiente |

## Carga por integrante

| Integrante | Base | FA | Custodia | Fuera de git |
|---|---|---|---|---|
| Samantha Rodriguez | 7 funcionalidades en 7 archivos | FA-S | `cpp/include/fa/fa.hpp` | Introducción, resultados de la base, conclusiones, diapositivas, escenario y conclusiones en la exposición |
| Melissa Ruíz | 7 funcionalidades en 6 archivos | FA-M | `cpp/{include,src}/utilidades.*`, `prolog/src/turismo.pl` | Análisis comparativo, guion y edición del video, comparativo en la exposición |
| Jefferson Sanchez | 6 funcionalidades en 4 archivos | FA-J | `cpp/include/modelo.hpp`, `haskell/src/Tipos.hs`, `_datos/*.csv` | Repositorio, carátula, metodología general, referencias, README, entrega y metodología en la exposición |

Los tres comparten además dos papers por cabeza, sus párrafos de 4.c a 4.f, los resultados de su FA,
su aporte y la grabación de sus pruebas. El reparto del informe, del video y de la exposición es una
propuesta que el grupo puede ajustar, porque el Anexo A fija solo la base y las FA.

## Riesgos

| Riesgo | Respuesta |
|---|---|
| Alguien edita un archivo ajeno y su rama choca con la del responsable | Mapa de archivos de este backlog y revisión obligatoria antes de fusionar |
| Una FA necesita una columna nueva en un CSV base después del 03/11 | Va en un CSV propio de la FA, enlazado por el código de la solicitud o del punto |
| Un cambio en `_datos/*.csv` rompe las pruebas de Prolog | Los CSV base se congelan en F1-06 y las FA ponen sus datos en archivos propios |
| El jurado lee una FA como variante de la base | El Anexo A recoge el ajuste de `ideas_FA_por_escenario.md` antes de entregarse |
| El Anexo A y el código nombran distinto los estados de la solicitud | F0-05 se cierra hoy |
| Alguien no domina su base el 17/11 | F2 cierra el 07/11, con diez días de margen para preguntar |
