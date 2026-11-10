# Datos compartidos

Esta carpeta es la única fuente de datos compartida por los módulos de C++, Haskell y Prolog. Los archivos usan codificación UTF-8, la coma como separador y el punto como separador decimal.

El lector sencillo de C++ separa los campos por comas; por ello, los campos no deben incluir comas internas ni comillas escapadas. Las categorías e intereses de FA01 se registran en archivos de relación, una por fila.

El módulo de C++ será el único que escriba o actualice estos archivos. Inicialmente, Haskell y Prolog los usarán en modo lectura. Cada módulo debe recibir la ruta de esta carpeta mediante un parámetro o una configuración; los CSV no deben duplicarse dentro de los módulos.

## `puntos.csv`

Registra los puntos que pueden ser origen o destino de un recorrido.

```csv
codigo,nombre,tipo,zona
```

- `codigo`: identificador único del punto.
- `nombre`: nombre descriptivo.
- `tipo`: `hotel`, `atractivo` o `mirador`.
- `zona`: zona de Lima a la que pertenece el punto.

## `conexiones.csv`

Registra las conexiones entre dos puntos.

```csv
codigo,origen,destino,distancia_km,tiempo_min,estado
```

- `codigo`: identificador único de la conexión.
- `origen` y `destino`: códigos existentes en `puntos.csv`; deben ser diferentes.
- `distancia_km`: distancia mayor que cero, expresada en kilómetros.
- `tiempo_min`: tiempo mayor que cero, expresado en minutos.
- `estado`: `habilitada` o `cerrada`.

Cada conexión se almacena una sola vez. Haskell y Prolog deben interpretarla en ambos sentidos cuando esté `habilitada`.

## `unidades.csv`

Registra las unidades disponibles para atender solicitudes.

```csv
codigo,tipo,capacidad,costo_km,estado
```

- `codigo`: identificador único de la unidad.
- `tipo`: `guia_peatonal`, `taxi_turistico` o `bus_turistico`.
- `capacidad`: cantidad máxima de turistas; debe ser mayor que cero.
- `costo_km`: costo por kilómetro; debe ser mayor que cero.
- `estado`: `disponible` u `ocupada`.

## `solicitudes.csv`

Registra las solicitudes de recorrido. Sus códigos deben comenzar con `S`, por ejemplo `S001`.

```csv
codigo,origen,destino,cantidad_turistas,prioridad,estado,unidad_asignada
```

- `codigo`: identificador único de la solicitud.
- `origen` y `destino`: códigos existentes en `puntos.csv`; deben ser diferentes.
- `cantidad_turistas`: cantidad mayor que cero.
- `prioridad`: `alta`, `media` o `baja`.
- `estado`: `pendiente`, `asignada` o `entregada`.
- `unidad_asignada`: código de la unidad que atiende o atendió la solicitud.

## Datos adicionales de FA01

El recomendador explicable usa cinco archivos adicionales. C++ los mantiene y
Prolog los lee junto con los CSV base. Las categorías y los intereses se
guardan una por fila para que cada relación sea fácil de consultar.

### `caracteristicas_puntos.csv`

```csv
codigo,accesible_movilidad,apto_ninos,seguro_dia,seguro_noche,horario_inicio,horario_fin
```

- `codigo`: código existente en `puntos.csv`.
- `accesible_movilidad`, `apto_ninos`, `seguro_dia` y `seguro_noche`: valores `si` o `no`.
- `horario_inicio` y `horario_fin`: horas en formato `HH:MM`.

### `categorias_puntos.csv`

```csv
codigo,categoria
```

Cada fila asocia un punto existente con una categoría. Un mismo punto puede
aparecer varias veces si tiene más de una categoría.

### `accesibilidad_conexiones.csv`

```csv
codigo,accesible_movilidad
```

El código debe existir en `conexiones.csv`; la accesibilidad se evalúa solo
para conexiones habilitadas.

### `perfiles_turista.csv`

```csv
codigo,movilidad_reducida,viaja_con_ninos,hora_visita
```

- `codigo`: identificador único del perfil.
- `movilidad_reducida` y `viaja_con_ninos`: valores `si` o `no`.
- `hora_visita`: hora local de visita en formato `HH:MM`.

### `intereses_turista.csv`

```csv
codigo,interes
```

Cada fila relaciona un perfil existente con uno de sus intereses. Un perfil
puede aparecer en varias filas.

Una recomendación se descarta si incumple la accesibilidad requerida, la
seguridad del horario, la atención del lugar o la condición de visita con
niños. Las categorías coincidentes aumentan el puntaje y se explican en la
salida. Si el perfil requiere accesibilidad, el punto debe tener al menos una
ruta de conexiones habilitadas y marcadas como accesibles desde algún hotel.

Una solicitud `pendiente` no tiene unidad asignada. Para pasarla a `asignada`, la unidad debe estar `disponible` y tener capacidad suficiente; después de la asignación, la unidad pasa a `ocupada`. Al marcar la solicitud como `entregada`, la unidad vuelve a estar `disponible`, pero la solicitud conserva su código en `unidad_asignada` para los reportes históricos.

## Reglas generales

- Los códigos no se repiten dentro de cada archivo.
- Las referencias a puntos y unidades deben corresponder a registros existentes.
- Los valores deben respetar los dominios y las restricciones indicadas en este documento.
- Como referencia inicial, cada CSV contiene cuatro registros ilustrativos ambientados en lugares turísticos de Lima. No constituyen un conjunto de datos oficial y sus distancias, tiempos y costos son valores de ejemplo que el grupo puede ajustar.
