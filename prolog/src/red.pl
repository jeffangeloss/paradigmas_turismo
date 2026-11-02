% Grupo 4 - Ruta turistica en Lima: modulo logico (seccion 4.3).
% 4.3.2 Conexion directa y 4.3.3 Alcanzabilidad. Responsable: Jefferson Sanchez.

% ---------------------------------------------------------------
% 4.3.2 Conexion directa habilitada, en cualquier sentido
% ---------------------------------------------------------------

% conexion/6 viene de lecturaCSV.pl (4.3.1): codigo, origen, destino, km, minutos, estado.
conectado(A, B, Km) :- conexion(_, A, B, Km, _, habilitada).
conectado(A, B, Km) :- conexion(_, B, A, Km, _, habilitada).

% ---------------------------------------------------------------
% 4.3.3 Alcanzabilidad, directa o indirecta
% ---------------------------------------------------------------

% hay_camino puede probar el mismo par por varios caminos. Con los dos
% puntos conocidos, once se queda con el primero (un solo true) y el corte
% evita la segunda clausula. Si falta alguno, setof junta los puntos sin
% repetir y member los entrega uno por uno.
% Exige al menos un tramo: alcanzable(X, X) es falso (un punto no se
% alcanza a si mismo), aunque ruta_evitando(X, X, _, R) da R = [X].
alcanzable(A, B) :-
    nonvar(A), nonvar(B), !,
    once(hay_camino(A, B, [A])).
alcanzable(A, B) :-
    setof(X, hay_camino(A, X, [A]), Alcanzables),
    member(B, Alcanzables).

% hay_camino(+Actual, ?Destino, +Visitados): la lista de visitados evita
% ciclar y que el camino vuelva a un punto ya pisado (P001 -> P002 -> P001).
hay_camino(A, B, Visitados) :-
    conectado(A, B, _),
    \+ memberchk(B, Visitados).
hay_camino(A, B, Visitados) :-
    conectado(A, C, _),
    \+ memberchk(C, Visitados),
    hay_camino(C, B, [C|Visitados]).
