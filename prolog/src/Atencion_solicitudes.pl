% 4.3.5 Atención de solicitudes según disponibilidad y capacidad.
:- module(atencion_solicitudes, [
    ejecutar_atencion/0,
    puede_atender/2
]).

:- use_module('LecturaCSV', [unidad/5, solicitud/7]).
:- use_module('entradasMenu', [leer_codigo/2]).

puede_atender(CodigoUnidad, CodigoSolicitud) :-
    unidad(CodigoUnidad, _, Capacidad, _, disponible),
    solicitud(CodigoSolicitud, _, _, CantidadTuristas, _, pendiente, _),
    Capacidad >= CantidadTuristas.

ejecutar_atencion :-
    leer_codigo('Codigo de unidad: ', CodigoUnidad),
    leer_codigo('Codigo de solicitud: ', CodigoSolicitud),
    (   puede_atender(CodigoUnidad, CodigoSolicitud)
    ->  format(
            '[SI] La unidad ~w puede atender la solicitud ~w.~n',
            [CodigoUnidad, CodigoSolicitud]
        )
    ;   format(
            '[NO] La unidad ~w no puede atender la solicitud ~w.~n',
            [CodigoUnidad, CodigoSolicitud]
        )
    ).
