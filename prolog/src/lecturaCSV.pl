:- module(lectura_csv, [
    cargar_datos/1,
    limpiar_datos/0,
    punto/4,
    conexion/6,
    unidad/5,
    solicitud/7
]).

% Se convierte cada línea del archivo en un término fila(...).
:- use_module(library(csv)).

% Se crean los hechos para almacenar la información de los CSV.
:- dynamic punto/4.
:- dynamic conexion/6.
:- dynamic unidad/5.
:- dynamic solicitud/7.

% Paso 1: limpiar la información anterior y cargar los CSV
cargar_datos(CarpetaDatos) :-
    limpiar_datos,
    cargar_puntos(CarpetaDatos),
    cargar_conexiones(CarpetaDatos),
    cargar_unidades(CarpetaDatos),
    cargar_solicitudes(CarpetaDatos).

% Paso 2: abrir un CSV (solo deuvelve sus filas)
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

%Cargar los datos de cada CSV y crear los hechos correspondientes

% punto/4.
cargar_puntos(CarpetaDatos) :-
    leer_filas(CarpetaDatos, 'puntos.csv', Filas), % crea la lista de filas
    maplist(guardar_punto, Filas). % recorre la lista y guarda cada punto

guardar_punto(fila(Codigo, Nombre, Tipo, Zona)) :-
    assertz(punto(Codigo, Nombre, Tipo, Zona)). % agrega el hecho a la base

% conexion/6.
cargar_conexiones(CarpetaDatos) :-
    leer_filas(CarpetaDatos, 'conexiones.csv', Filas),
    maplist(guardar_conexion, Filas).

guardar_conexion(fila(Codigo, Origen, Destino, DistanciaKm, TiempoMin, Estado)) :-
    assertz(conexion(Codigo, Origen, Destino, DistanciaKm, TiempoMin, Estado)).

% unidad/5.
cargar_unidades(CarpetaDatos) :-
    leer_filas(CarpetaDatos, 'unidades.csv', Filas),
    maplist(guardar_unidad, Filas).

guardar_unidad(fila(Codigo, Tipo, Capacidad, CostoKm, Estado)) :-
    assertz(unidad(Codigo, Tipo, Capacidad, CostoKm, Estado)).

% solicitud/7.
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
