% Importar los predicados que leen los CSV y crean la base de conocimiento.
:- use_module('../src/lecturaCSV').
:- use_module(library(aggregate)).

% Paso 1: recibir la ruta de la carpeta de datos desde la terminal.
% Paso 2: cargar los CSV.
% Paso 3: mostrar cuántos hechos quedaron disponibles para realizar consultas.
main :-
    current_prolog_flag(argv, Argumentos),
    (   Argumentos = [CarpetaDatos|_]
    ->  cargar_datos(CarpetaDatos),
        mostrar_resumen
    ;   writeln('Uso: swipl prolog/app/main.pl -- _datos'),
        halt(1)
    ).

% Contar los hechos creados a partir de cada archivo CSV.
mostrar_resumen :-
    aggregate_all(count, punto(_, _, _, _), Puntos),
    aggregate_all(count, conexion(_, _, _, _, _, _), Conexiones),
    aggregate_all(count, unidad(_, _, _, _, _), Unidades),
    aggregate_all(count, solicitud(_, _, _, _, _, _, _), Solicitudes),
    format('Datos cargados correctamente.~n', []),
    format('Puntos: ~d~n', [Puntos]),
    format('Conexiones: ~d~n', [Conexiones]),
    format('Unidades: ~d~n', [Unidades]),
    format('Solicitudes: ~d~n', [Solicitudes]).

% Ejecutar main/0 solamente cuando este archivo se inicia como programa.
:- initialization(main, main).
