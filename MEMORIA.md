# Memoria del proyecto · Grupo 4

## Punto actual

02/11. El código del grupo está integrado en el repositorio de Melissa, con su estructura (`cpp/include`
y `cpp/src` con CMake, `haskell/src` y `app` con Cabal, `prolog/src`, `app` y `tests`) y su formato de
datos (`_datos/`, códigos `P001`, `C001`, `U001`, conexiones con código, tipos `guia_peatonal`,
`taxi_turistico` y `bus_turistico`, estado `entregada`). Su `lecturaCSV.pl` es la lectura de CSV de
Prolog (4.3.1). El trabajo vive en la rama `feat/integracion-codigo`, pendiente de pull request.

## Entradas

### 02/11 · Integración en el repositorio de Melissa con su formato de datos

- Quién. Jefferson, que migra el código con scripts y verifica cada paso; Melissa aporta la estructura del repositorio, el formato de `_datos/` y `lecturaCSV.pl`.
- Qué cambió. Los CSV del grupo pasan al formato de Melissa, el C++ va a `include/` y `src/` con su CMake, el Haskell a `src/` y `app/` con su Cabal, y las reglas de Prolog se montan sobre `lecturaCSV.pl` y su `conexion/6`. El ejemplo `Destino` se retira. README, CONTRATO, BACKLOG y `demo.sh` usan las rutas y los códigos nuevos.
- Por qué. El grupo elige el formato de Melissa y quiere conservar su trabajo en el repositorio.
- Lo probado que debe pasar. 17 salidas de C++ y Haskell equivalen a las del código anterior con la tabla de códigos, las 55 pruebas de Prolog pasan sobre `lecturaCSV.pl`, Haskell compila con Cabal y `-Wall`, y `./demo.sh` termina sin fallos.
- Lo probado que no debe pasar. Un código de conexión repetido se rechaza al registrar, y `lecturaCSV.pl` y `prolog/app/main.pl` de Melissa no cambian.
- Correcciones. Los datos de Melissa tenían 4 filas por archivo, por debajo de los mínimos del enunciado, así que se reemplazan por los 11 puntos, 16 conexiones, 4 unidades y 9 solicitudes del grupo en su formato.
- Cómo se reporta. Falta el commit, el push de la rama y el pull request para que Melissa lo revise.

### 01/11 · División del código por responsable

- Quién. Jefferson, que divide los tres módulos con scripts que copian cada función tal cual y verifica el resultado.
- Qué cambió. `cpp/turismo.cpp` pasa a nueve pares de archivos más `cpp/fa/`, `haskell/Turismo.hs` a cinco módulos más `haskell/FA/`, y `prolog/turismo.pl` a seis archivos más `prolog/fa/`. El menú de C++ gana la opción 5 (FA) y Salir pasa al 0, Haskell se ejecuta con `-ihaskell` y `demo.sh` tiene un bloque por integrante. Se agregan `.gitignore` y la sección de FA de CONTRATO.
- Por qué. Tres integrantes editan a la vez, y con un archivo por lenguaje cualquier cambio de uno chocaba con el de otro.
- Lo probado que debe pasar. 19 casos (8 de C++, 8 de Haskell y 3 de Prolog) dan la misma salida que el código anterior, salvo el menú, C++ compila con `-Wall -Wextra` y Haskell con `-Wall` sin advertencias, y Prolog pasa 55 de 55 pruebas.
- Lo probado que no debe pasar. Tres ramas que editan su FA, su bloque de `demo.sh` y sus secciones de README y CONTRATO no generan conflictos al fusionarse en `develop`.
- Correcciones. El pragma `OPTIONS_GHC -ihaskell` no sirve para buscar módulos, así que el comando de Haskell lleva `-ihaskell`.
- Cómo se reporta. El pendiente inmediato es F0-03 a F0-06, con límite hoy a las 23:59, y después F1.

### 01/11 · Backlog inicial

- Quién. Jefferson, que redacta el backlog y verifica el estado del código.
- Qué cambió. Se agregan `BACKLOG.md` y este archivo, sin tocar el código ni los datos.
- Por qué. El grupo pasa a trabajar con git y necesita un orden de trabajo hasta el 16/11, con la base y las FA fijadas por el Anexo A.
- Lo probado que debe pasar. `./demo.sh` termina sin fallos, C++ compila sin advertencias y Prolog pasa 55 de 55 pruebas plunit.
- Lo probado que no debe pasar. Ninguna funcionalidad base queda sin responsable ni con dos, y las 20 coinciden con la tabla C del Anexo A.
- Correcciones. El Anexo A nombra los estados de la solicitud distinto del código.
- Cómo se reporta. El backlog se reescribe por fases el mismo día, después de dividir el código.
