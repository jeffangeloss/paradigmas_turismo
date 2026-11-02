% Grupo 4 - Ruta turistica en Lima: modulo logico (seccion 4.3).
% 4.3.4 Ruta evitando un punto. Responsable: Samantha Rodriguez.

:- use_module(library(lists)).

% ---------------------------------------------------------------
% 4.3.4 Ruta evitando un punto
% ---------------------------------------------------------------

% Ruta = [Origen, ..., Destino], sin Evitar y sin puntos repetidos.
% Por backtracking entrega cada ruta. Evitar debe venir instanciado: con
% una variable libre, \== siempre es verdadero y no se evitaria nada.
ruta_evitando(Origen, Destino, Evitar, Ruta) :-
    must_be(atom, Evitar),
    Origen \== Evitar,
    Destino \== Evitar,
    ruta_desde(Origen, Destino, Evitar, [Origen], RutaInversa),
    reverse(RutaInversa, Ruta).

% ruta_desde(+Actual, +Destino, +Evitar, +Visitados, -RutaInversa)
ruta_desde(Destino, Destino, _, Visitados, Visitados).
ruta_desde(Actual, Destino, Evitar, Visitados, Ruta) :-
    Actual \== Destino,
    conectado(Actual, Siguiente, _),
    Siguiente \== Evitar,
    \+ memberchk(Siguiente, Visitados),
    ruta_desde(Siguiente, Destino, Evitar, [Siguiente|Visitados], Ruta).
