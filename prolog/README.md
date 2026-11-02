# Módulo Prolog

Este módulo lee los cuatro CSV compartidos y convierte sus filas en hechos de Prolog. Los archivos sólo se leen: no se modifican desde este módulo.

## 1. Instalar SWI-Prolog

1. Descargar SWI-Prolog desde su [página oficial](https://www.swi-prolog.org/Download.html).
2. Ejecutar el instalador correspondiente al sistema operativo.
3. Cerrar y volver a abrir PowerShell o VS Code.

## 2. Elegir una forma de ejecución

### Opción A: agregar SWI-Prolog al `PATH` (recomendada)

En Windows:

1. Buscar **Variables de entorno** desde el menú Inicio.
2. Abrir **Editar las variables de entorno del sistema**.
3. Entrar a **Variables de entorno**.
4. Seleccionar `Path` en las variables de usuario y pulsar **Editar**.
5. Agregar la carpeta `bin` de la instalación de SWI-Prolog.
6. Guardar los cambios y reiniciar VS Code.

Comprobar que el comando esté disponible:

```powershell
swipl --version
```

Desde la raíz de `paradigmas_turismo`, ejecutar el programa:

```powershell
swipl prolog/app/main.pl -- _datos
```

### Opción B: ejecutar sin modificar el `PATH`

Se puede usar directamente la ruta completa del ejecutable. En una instalación estándar de Windows:

```powershell
& "C:\Program Files\swipl\bin\swipl.exe" prolog/app/main.pl -- _datos
```

Si SWI-Prolog se instaló en otra ubicación, se debe reemplazar la ruta anterior por la correspondiente.

## 3. Verificar la ejecución

El resultado esperado es:

```text
Datos cargados correctamente.
Puntos: 4
Conexiones: 4
Unidades: 4
Solicitudes: 4
```

`main.pl` sólo inicia el programa: recibe la ruta `_datos`, llama a `cargar_datos/1` y muestra el número de hechos cargados.

## 4. Realizar consultas manuales

1. Desde la raíz del repositorio, entrar a la carpeta Prolog:

```powershell
cd prolog
```

2. Si `swipl` está configurado en el `PATH`, iniciar SWI-Prolog con:

```powershell
swipl
```

Si no está configurado en el `PATH`, usar la ruta completa:

```powershell
& "C:\Program Files\swipl\bin\swipl.exe"
```

3. Cuando aparezca el prompt `?-`, cargar el código y los CSV:

```prolog
[src/lecturaCSV].
cargar_datos('../_datos').
```

No se debe escribir manualmente `?-`; SWI-Prolog lo muestra automáticamente.

## 5. Consultas básicas

### Buscar un punto por su código

```prolog
punto('P002', Nombre, Tipo, Zona).
```

### Buscar un punto por código y comprobar que sea un atractivo

```prolog
punto('P002', Nombre, atractivo, Zona).
```

### Listar todos los atractivos

```prolog
punto(Codigo, Nombre, atractivo, Zona).
```

### Buscar una conexión por su código

```prolog
conexion('C001', Origen, Destino, DistanciaKm, TiempoMin, Estado).
```

### Listar las unidades disponibles

```prolog
unidad(Codigo, Tipo, Capacidad, CostoKm, disponible).
```

### Listar las solicitudes pendientes

```prolog
solicitud(Codigo, Origen, Destino, Cantidad, Prioridad, pendiente, Unidad).
```

### Buscar una solicitud por su código

```prolog
solicitud('S002', Origen, Destino, Cantidad, Prioridad, Estado, Unidad).
```

Si una consulta tiene varios resultados, presionar `;` para ver el siguiente. Presionar `Enter` para detener la búsqueda.

Para salir de SWI-Prolog:

```prolog
halt.
```

## Actualización de la base de conocimiento

El predicado `cargar_datos/1` realiza estos pasos:

1. Elimina los hechos cargados anteriormente con `limpiar_datos/0`.
2. Lee `puntos.csv` y crea hechos `punto/4`.
3. Lee `conexiones.csv` y crea hechos `conexion/6`.
4. Lee `unidades.csv` y crea hechos `unidad/5`.
5. Lee `solicitudes.csv` y crea hechos `solicitud/7`.

Esto permite volver a ejecutar `cargar_datos('../_datos').` después de cambiar un CSV sin duplicar información.

## 6. Reglas de la sección 4.3

`src/turismo.pl` carga `src/lecturaCSV.pl` y las reglas de cada integrante. Desde la carpeta
`prolog/`:

```prolog
[src/turismo].
cargar_datos('../_datos').
```

| Archivo | Regla | Responsable |
|---|---|---|
| `src/lecturaCSV.pl` | 4.3.1 Lectura de CSV y base de conocimiento | Melissa Ruíz |
| `src/red.pl` | 4.3.2 `conectado/3` y 4.3.3 `alcanzable/2` | Jefferson Sanchez |
| `src/rutas.pl` | 4.3.4 `ruta_evitando/4` | Samantha Rodriguez |
| `src/atencion.pl` | 4.3.5 `puede_atender/2` | Melissa Ruíz |
| `src/inaccesibles.pl` | 4.3.6 `solicitudes_inaccesibles/1` | Samantha Rodriguez |
| `src/fa/fa_<nombre>.pl` | Funcionalidad adicional de cada integrante | Cada autor |

Los códigos se escriben entre comillas simples, igual que en los CSV. Resultados con los datos de
`_datos/`:

| Consulta | Resultado |
|---|---|
| `conectado('P001', 'P003', Distancia).` | `Distancia = 4.8.` |
| `conectado('P001', 'P010', D).` | `false.` (el tramo está cerrado) |
| `conectado('P003', 'P001', D).` | `D = 4.8.` (en cualquier sentido) |
| `alcanzable('P001', 'P006').` | `true.` |
| `alcanzable('P001', 'P010').` | `false.` (P010 solo se une a P001 por un tramo cerrado) |
| `ruta_evitando('P001', 'P006', 'P003', Ruta).` | 4 rutas, una por cada `;` |
| `puede_atender(U, 'S004').` | `U = 'U002' ;` `U = 'U003'.` |
| `puede_atender('U001', 'S002').` | `false.` (U001 está ocupada) |
| `solicitudes_inaccesibles(Lista).` | `Lista = ['S006'].` |

## 7. Ejemplo de cada regla

Desde la raíz del repositorio:

```powershell
swipl prolog/app/demo.pl -- _datos
```

## 8. Pruebas

Las 55 pruebas plunit cubren la lectura y las cinco reglas. Desde la raíz del repositorio:

```powershell
swipl -g run_tests -t halt prolog/tests/pruebas.pl
```

Cada prueba imprime `passed`. Las pruebas ubican `_datos/` respecto de su propio archivo y no modifican
los CSV.
