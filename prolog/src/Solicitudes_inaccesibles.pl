% 4.3.6 Solicitudes cuyo origen no puede alcanzar su destino.
:- module(solicitudes_inaccesibles, [
    ejecutar_solicitudes_inaccesibles/0,
    solicitudes_inaccesibles/1
]).

:- use_module('LecturaCSV', [solicitud/7]).
:- use_module('Conectividad', [alcanzable/2]).

% Se consideran todos los estados para que el reporte también permita
% detectar inconsistencias históricas en los datos.
solicitudes_inaccesibles(Solicitudes) :-
    findall(
        solicitud(Codigo, Origen, Destino, Cantidad, Prioridad, Estado, Unidad),
        ( solicitud(Codigo, Origen, Destino, Cantidad, Prioridad, Estado, Unidad),
          \+ alcanzable(Origen, Destino)
        ),
        Solicitudes
    ).

ejecutar_solicitudes_inaccesibles :-
    solicitudes_inaccesibles(Solicitudes),
    (   Solicitudes = []
    ->  writeln('[OK] Todas las solicitudes tienen una ruta habilitada.')
    ;   writeln('Solicitudes sin ruta habilitada:'),
        forall(
            member(solicitud(Codigo, Origen, Destino, Cantidad, Prioridad, Estado, Unidad), Solicitudes),
            format(' - ~w: ~w -> ~w; ~d turistas; prioridad ~w; estado ~w; unidad ~w~n',
                [Codigo, Origen, Destino, Cantidad, Prioridad, Estado, Unidad])
        )
    ).
