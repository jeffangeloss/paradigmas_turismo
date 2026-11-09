:- module(atencion_solicitudes, [
    ejecutar_atencion/0,
    puede_atender/2
]).

:- use_module('lecturaCSV', [unidad/5, solicitud/7]).

% Comprueba disponibilidad, estado pendiente y capacidad suficiente.
puede_atender(CodigoUnidad, CodigoSolicitud) :-
    unidad(CodigoUnidad, _, Capacidad, _, disponible),
    solicitud(CodigoSolicitud, _, _, CantidadTuristas, _, pendiente, _),
    Capacidad >= CantidadTuristas.


/*//////////////////////////////////////////////////////////////////////////////////*/
% Interfaz de la funcionalidad 4.3.5.


ejecutar_atencion :-
    writeln('Escribe un codigo o VARIABLE para listar todas las coincidencias.'),
    leer_parametro('Codigo de unidad: ', Unidad),
    leer_parametro('Codigo de solicitud: ', Solicitud),
    consultar_atencion(Unidad, Solicitud).

consultar_atencion(codigo(CodigoUnidad), codigo(CodigoSolicitud)) :-
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

consultar_atencion(variable, codigo(CodigoSolicitud)) :-
    findall(
        CodigoUnidad,
        puede_atender(CodigoUnidad, CodigoSolicitud),
        Unidades
    ),
    mostrar_unidades(CodigoSolicitud, Unidades).

consultar_atencion(codigo(CodigoUnidad), variable) :-
    findall(
        CodigoSolicitud,
        puede_atender(CodigoUnidad, CodigoSolicitud),
        Solicitudes
    ),
    mostrar_solicitudes(CodigoUnidad, Solicitudes).

consultar_atencion(variable, variable) :-
    findall(
        CodigoUnidad-CodigoSolicitud,
        puede_atender(CodigoUnidad, CodigoSolicitud),
        Coincidencias
    ),
    mostrar_coincidencias(Coincidencias).

% VARIABLE y * representan un parámetro libre en el menú interactivo.
leer_parametro(Mensaje, Parametro) :-
    leer_entrada(Mensaje, Entrada),
    string_upper(Entrada, EntradaMayusculas),
    (   memberchk(EntradaMayusculas, ["VARIABLE", "*"])
    ->  Parametro = variable
    ;   atom_string(Codigo, EntradaMayusculas),
        Parametro = codigo(Codigo)
    ).

mostrar_unidades(_, []) :-
    writeln('No se encontraron unidades que puedan atender la solicitud.').
mostrar_unidades(CodigoSolicitud, Unidades) :-
    format('Unidades que pueden atender ~w:~n', [CodigoSolicitud]),
    forall(member(CodigoUnidad, Unidades), format('- ~w~n', [CodigoUnidad])).

mostrar_solicitudes(_, []) :-
    writeln('La unidad no puede atender ninguna solicitud pendiente.').
mostrar_solicitudes(CodigoUnidad, Solicitudes) :-
    format('Solicitudes que puede atender ~w:~n', [CodigoUnidad]),
    forall(
        member(CodigoSolicitud, Solicitudes),
        format('- ~w~n', [CodigoSolicitud])
    ).

mostrar_coincidencias([]) :-
    writeln('No se encontraron parejas de unidad y solicitud compatibles.').
mostrar_coincidencias(Coincidencias) :-
    writeln('Unidades y solicitudes compatibles:'),
    forall(
        member(CodigoUnidad-CodigoSolicitud, Coincidencias),
        format('- ~w puede atender ~w~n', [CodigoUnidad, CodigoSolicitud])
    ).

leer_entrada(Mensaje, Texto) :-
    write(Mensaje),
    flush_output,
    read_line_to_string(user_input, Entrada),
    (   Entrada == end_of_file
    ->  nl,
        halt
    ;   normalize_space(string(Texto), Entrada)
    ).
