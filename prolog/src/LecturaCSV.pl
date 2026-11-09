:- module(lectura_csv, [
    cargar_datos/1,
    cargar_datos/2,
    limpiar_datos/0,
    punto/4,
    conexion/6,
    unidad/5,
    solicitud/7
]).

:- use_module(library(csv)).
:- use_module(library(aggregate)).

% Los hechos se reemplazan cada vez que se cargan los CSV.
:- dynamic punto/4.
:- dynamic conexion/6.
:- dynamic unidad/5.
:- dynamic solicitud/7.

cargar_datos(CarpetaDatos) :-
    cargar_datos(CarpetaDatos, _).

cargar_datos(CarpetaDatos, Resumen) :-
    validar_archivos(CarpetaDatos),
    limpiar_datos,
    cargar_puntos(CarpetaDatos),
    cargar_conexiones(CarpetaDatos),
    cargar_unidades(CarpetaDatos),
    cargar_solicitudes(CarpetaDatos),
    contar_datos(Resumen).

contar_datos(resumen(Puntos, Conexiones, Unidades, Solicitudes)) :-
    aggregate_all(count, punto(_, _, _, _), Puntos),
    aggregate_all(count, conexion(_, _, _, _, _, _), Conexiones),
    aggregate_all(count, unidad(_, _, _, _, _), Unidades),
    aggregate_all(count, solicitud(_, _, _, _, _, _, _), Solicitudes).

validar_archivos(CarpetaDatos) :-
    (   exists_directory(CarpetaDatos)
    ->  validar_archivos_requeridos(CarpetaDatos, [
            'puntos.csv',
            'conexiones.csv',
            'unidades.csv',
            'solicitudes.csv'
        ])
    ;   throw(error(existence_error(directory, CarpetaDatos), cargar_datos/2))
    ).

validar_archivos_requeridos(_, []).
validar_archivos_requeridos(CarpetaDatos, [Archivo|Resto]) :-
    directory_file_path(CarpetaDatos, Archivo, Ruta),
    (   exists_file(Ruta)
    ->  validar_archivos_requeridos(CarpetaDatos, Resto)
    ;   throw(error(existence_error(source_sink, Ruta), cargar_datos/2))
    ).

% Abre un CSV, omite su encabezado y devuelve las filas.
leer_filas(CarpetaDatos, NombreArchivo, Filas) :-
    directory_file_path(CarpetaDatos, NombreArchivo, RutaArchivo),
    setup_call_cleanup(
        open(RutaArchivo, read, Archivo, [encoding(utf8)]),
        csv_read_stream(
            Archivo,
            [_Encabezado|Filas],
            [functor(fila), strip(true), convert(true)]
        ),
        close(Archivo)
    ).

cargar_puntos(CarpetaDatos) :-
    leer_filas(CarpetaDatos, 'puntos.csv', Filas),
    maplist(guardar_punto, Filas).

guardar_punto(fila(Codigo, Nombre, Tipo, Zona)) :-
    assertz(punto(Codigo, Nombre, Tipo, Zona)).

cargar_conexiones(CarpetaDatos) :-
    leer_filas(CarpetaDatos, 'conexiones.csv', Filas),
    maplist(guardar_conexion, Filas).

guardar_conexion(fila(Codigo, Origen, Destino, DistanciaKm, TiempoMin, Estado)) :-
    assertz(conexion(Codigo, Origen, Destino, DistanciaKm, TiempoMin, Estado)).

cargar_unidades(CarpetaDatos) :-
    leer_filas(CarpetaDatos, 'unidades.csv', Filas),
    maplist(guardar_unidad, Filas).

guardar_unidad(fila(Codigo, Tipo, Capacidad, CostoKm, Estado)) :-
    assertz(unidad(Codigo, Tipo, Capacidad, CostoKm, Estado)).

cargar_solicitudes(CarpetaDatos) :-
    leer_filas(CarpetaDatos, 'solicitudes.csv', Filas),
    maplist(guardar_solicitud, Filas).

guardar_solicitud(fila(Codigo, Origen, Destino, Cantidad, Prioridad, Estado, UnidadAsignada)) :-
    assertz(solicitud(
        Codigo, Origen, Destino, Cantidad, Prioridad, Estado, UnidadAsignada
    )).

limpiar_datos :-
    retractall(punto(_, _, _, _)),
    retractall(conexion(_, _, _, _, _, _)),
    retractall(unidad(_, _, _, _, _)),
    retractall(solicitud(_, _, _, _, _, _, _)).
