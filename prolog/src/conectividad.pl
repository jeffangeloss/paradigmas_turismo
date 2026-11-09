% 4.3.2 Conexión directa habilitada en ambos sentidos.
:- module(conectividad, [
    ejecutar_conexion/0,
    ejecutar_alcanzabilidad/0,
    conectado/3,
    alcanzable/2
]).

:- use_module('lecturaCSV.pl', [conexion/6]).
:- use_module('entrada', [leer_codigo/2]).

conectado(Origen, Destino, Distancia) :-
    conexion(_, Origen, Destino, Distancia, _, habilitada).

conectado(Origen, Destino, Distancia) :-
    conexion(_, Destino, Origen, Distancia, _, habilitada).

% 4.3.3 Alcanzabilidad mediante conexiones habilitadas.
alcanzable(Origen, Destino) :-
    buscar_camino(Origen, Destino, [Origen]).

% Caso base. El destino está a un tramo.
buscar_camino(Actual, Destino, Visitados) :-
    conectado(Actual, Destino, _),
    \+ memberchk(Destino, Visitados).

% Caso recursivo. Avanza a un vecino y continúa la búsqueda.
buscar_camino(Actual, Destino, Visitados) :-
    conectado(Actual, Vecino, _),
    \+ memberchk(Vecino, Visitados),
    buscar_camino(Vecino, Destino, [Vecino | Visitados]).

ejecutar_conexion :-
    leer_codigo('Codigo de origen: ', Origen),
    leer_codigo('Codigo de destino: ', Destino),
    (   conectado(Origen, Destino, Distancia)
    ->  format(
            '[SI] Existe conexion directa entre ~w y ~w (~w km).~n',
            [Origen, Destino, Distancia]
        )
    ;   format(
            '[NO] No existe conexion directa entre ~w y ~w.~n',
            [Origen, Destino]
        )
    ).

ejecutar_alcanzabilidad :-
    leer_codigo('Codigo de origen: ', Origen),
    leer_codigo('Codigo de destino: ', Destino),
    (   alcanzable(Origen, Destino)
    ->  format('[SI] ~w es alcanzable desde ~w.~n', [Destino, Origen])
    ;   format('[NO] ~w no es alcanzable desde ~w.~n', [Destino, Origen])
    ).
