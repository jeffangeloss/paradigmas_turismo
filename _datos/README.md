# Datos compartidos

Esta carpeta es la única fuente de datos compartida por los módulos de C++, Haskell y Prolog. Los archivos usan codificación UTF-8, la coma como separador y el punto como separador decimal.

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

Una solicitud `pendiente` no tiene unidad asignada. Para pasarla a `asignada`, la unidad debe estar `disponible` y tener capacidad suficiente; después de la asignación, la unidad pasa a `ocupada`. Al marcar la solicitud como `entregada`, la unidad vuelve a estar `disponible`, pero la solicitud conserva su código en `unidad_asignada` para los reportes históricos.

## Reglas generales

- Los códigos no se repiten dentro de cada archivo.
- Las referencias a puntos y unidades deben corresponder a registros existentes.
- Los valores deben respetar los dominios y las restricciones indicadas en este documento.
- Los datos de prueba cumplen las cantidades mínimas de la sección 3 del enunciado: 11 puntos, 16 conexiones (2 cerradas), 4 unidades (2 disponibles) y 9 solicitudes con los tres estados. Usan lugares reales de Lima con distancias, tiempos y costos aproximados que el grupo puede ajustar.
