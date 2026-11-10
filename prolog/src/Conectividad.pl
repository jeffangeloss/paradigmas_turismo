% 4.3.2 Conexión directa habilitada en ambos sentidos.
:- module(conectividad, [
    ejecutar_conexion/0,
    ejecutar_alcanzabilidad/0,
    conectado/3,
    alcanzable/2,
    ruta_evitando/4,
    ejecutar_ruta_evitando/0
]).

:- use_module('LecturaCSV.pl', [conexion/6]).
:- use_module('entradasMenu', [leer_codigo/2]).

conectado(Origen, Destino, Distancia) :-
    conexion(_, Origen, Destino, Distancia, _, habilitada).

conectado(Origen, Destino, Distancia) :-
    conexion(_, Destino, Origen, Distancia, _, habilitada).

% 4.3.3 Alcanzabilidad mediante conexiones habilitadas.
alcanzable(Origen, Destino) :-
    buscar_camino(Origen, Destino, [Origen]).

% 4.3.4 Ruta por conexiones habilitadas que evita un punto.
% La lista devuelta contiene el origen y el destino.
ruta_evitando(Origen, Destino, PuntoEvitado, Ruta) :-
    Origen \= PuntoEvitado,
    Destino \= PuntoEvitado,
    buscar_ruta(Origen, Destino, PuntoEvitado, [Origen], RutaInvertida),
    reverse(RutaInvertida, Ruta).

buscar_ruta(Actual, Destino, _, Visitados, [Destino|Visitados]) :-
    conectado(Actual, Destino, _),
    \+ member(Destino, Visitados).
buscar_ruta(Actual, Destino, PuntoEvitado, Visitados, Ruta) :-
    conectado(Actual, Vecino, _),
    Vecino \= PuntoEvitado,
    \+ member(Vecino, Visitados),
    buscar_ruta(Vecino, Destino, PuntoEvitado, [Vecino|Visitados], Ruta).

% Caso base. El destino está a un tramo.
buscar_camino(Actual, Destino, Visitados) :-
    conectado(Actual, Destino, _),
    \+ member(Destino, Visitados).

% Caso recursivo. Avanza a un vecino y continúa la búsqueda.
buscar_camino(Actual, Destino, Visitados) :-
    conectado(Actual, Vecino, _),
    \+ member(Vecino, Visitados),
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

ejecutar_ruta_evitando :-
    leer_codigo('Codigo de origen: ', Origen),
    leer_codigo('Codigo de destino: ', Destino),
    leer_codigo('Codigo del punto que se debe evitar: ', PuntoEvitado),
    (   ruta_evitando(Origen, Destino, PuntoEvitado, Ruta)
    ->  format('[SI] Ruta evitando ~w: ~w~n', [PuntoEvitado, Ruta])
    ;   format('[NO] No hay ruta entre ~w y ~w evitando ~w.~n',
            [Origen, Destino, PuntoEvitado])
    ).
