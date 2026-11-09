% 4.3.2 Conexión directa habilitada en ambos sentidos.
:- module(conectividad, [conectado/3, alcanzable/2]).

:- use_module('lecturaCSV.pl', [conexion/6]).

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
