% Pruebas plunit del modulo logico.
% Desde la raiz del repositorio:  swipl -g run_tests -t halt prolog/tests/pruebas.pl

:- use_module(library(plunit)).
:- ensure_loaded('../src/turismo').

% La carpeta _datos se ubica respecto de este archivo, asi las pruebas corren desde cualquier carpeta.
:- dynamic carpeta_datos/1.
:- prolog_load_context(directory, Dir),
   directory_file_path(Dir, '../../_datos', Datos),
   retractall(carpeta_datos(_)), assertz(carpeta_datos(Datos)).

cargar :- carpeta_datos(Datos), cargar_datos(Datos).

:- begin_tests(lectura, [setup(cargar)]).

test(cantidades) :-
    aggregate_all(count, punto(_, _, _, _), 11),
    aggregate_all(count, conexion(_, _, _, _, _, _), 16),
    aggregate_all(count, unidad(_, _, _, _, _), 4),
    aggregate_all(count, solicitud(_, _, _, _, _, _, _), 9).
test(codigos_se_conservan) :-
    punto('P001', 'Plaza Mayor de Lima', atractivo, 'Cercado de Lima'),
    unidad('U002', taxi_turistico, 4, 1.8, disponible).
test(numeros_como_numeros) :-
    conexion('C001', 'P001', 'P002', 0.8, 10, habilitada),
    solicitud('S001', 'P002', 'P003', 20, alta, asignada, 'U001').
test(unidad_vacia) :-
    solicitud('S002', 'P006', 'P007', 3, media, pendiente, '').
test(recargar_no_duplica) :-
    cargar,
    aggregate_all(count, punto(_, _, _, _), 11).
test(carga_desde_otra_carpeta,
     [ setup(working_directory(Antes, '/')),
       cleanup(working_directory(_, Antes)) ]) :-
    cargar,
    aggregate_all(count, punto(_, _, _, _), 11).

:- end_tests(lectura).

:- begin_tests(conectado, [setup(cargar)]).

test(directo, [nondet]) :- conectado('P001', 'P002', 0.8).
test(en_ambos_sentidos) :- conectado('P002', 'P001', 0.8).
test(ejemplo_del_enunciado, [true(D == 4.8), nondet]) :- conectado('P001', 'P003', D).
test(cerrada_no_cuenta, [fail]) :- conectado('P001', 'P010', _).
test(cerrada_no_cuenta_al_reves, [fail]) :- conectado('P010', 'P001', _).
test(cerrada_p05_p07, [fail]) :- conectado('P005', 'P007', _).
test(sin_tramo, [fail]) :- conectado('P001', 'P006', _).
test(vecinos_de_p11, [true(L == ['P007', 'P008'])]) :-
    findall(V, conectado('P011', V, _), L0), sort(L0, L).

:- end_tests(conectado).

:- begin_tests(alcanzable, [setup(cargar)]).

test(indirecto) :- alcanzable('P011', 'P004').
test(desvio_por_p06) :- alcanzable('P005', 'P007').
test(extremos_de_la_red) :- alcanzable('P001', 'P011').
test(p10_aislado, [fail]) :- alcanzable('P001', 'P010').
test(p10_aislado_al_reves, [fail]) :- alcanzable('P010', 'P001').
test(punto_inexistente, [fail]) :- alcanzable('P001', 'P099').
test(enumera_sin_repetir, [true(L0 == L)]) :-
    findall(X, alcanzable('P011', X), L0), sort(L0, L).
test(componente_de_p11, [true(L == ['P001', 'P002', 'P003', 'P004', 'P005', 'P006', 'P007', 'P008', 'P009'])]) :-
    findall(X, alcanzable('P011', X), L0), sort(L0, L).
test(no_se_alcanza_a_si_mismo, [fail]) :- alcanzable('P001', 'P001').
test(aislado_tampoco, [fail]) :- alcanzable('P010', 'P010').
test(no_incluye_p10, [true(L == [])]) :-
    findall(X, (alcanzable('P001', X), X == 'P010'), L).
test(termina_con_ciclos, [timeout(5)]) :- \+ alcanzable('P010', 'P011').
test(origen_libre, [true(L == ['P001', 'P002', 'P003', 'P005', 'P006', 'P007', 'P008', 'P009', 'P011'])]) :-
    findall(X, alcanzable(X, 'P004'), L).
% 10 puntos conectados entre si: 10 x 9 pares ordenados (sin X con X).
test(pares_alcanzables, [true(N == 90), timeout(5)]) :-
    aggregate_all(count, alcanzable(_, _), N).

:- end_tests(alcanzable).

:- begin_tests(ruta_evitando, [setup(cargar)]).

test(nunca_pasa_por_evitado, [timeout(5)]) :-
    findall(R, ruta_evitando('P011', 'P004', 'P008', R), Rutas),
    Rutas \== [],
    forall(member(R, Rutas), \+ memberchk('P008', R)).
test(rutas_esperadas, [true(Rutas == [['P011','P007','P006','P004'], ['P011','P007','P006','P005','P004']]), timeout(5)]) :-
    findall(R, ruta_evitando('P011', 'P004', 'P008', R), Rutas).
test(ejemplo_del_enunciado, [true(N == 4), timeout(5)]) :-
    findall(R, ruta_evitando('P001', 'P006', 'P003', R), Rutas),
    forall(member(R, Rutas), \+ memberchk('P003', R)),
    length(Rutas, N).
test(extremos_correctos, [timeout(5)]) :-
    forall(ruta_evitando('P001', 'P006', 'P003', R),
           ( R = ['P001'|_], last(R, 'P006') )).
test(sin_puntos_repetidos, [timeout(5)]) :-
    forall(ruta_evitando('P001', 'P008', 'P009', R),
           ( sort(R, S), length(R, N), length(S, N) )).
test(rutas_consecutivas_conectadas, [timeout(5)]) :-
    forall(ruta_evitando('P001', 'P008', 'P009', R),
           forall(append(_, [X, Y|_], R), conectado(X, Y, _))).
test(evitar_el_unico_puente, [fail, timeout(5)]) :-
    ruta_evitando('P011', 'P004', 'P007', _).
test(evitar_libre_es_error, [error(instantiation_error)]) :-
    ruta_evitando('P001', 'P006', _, _).
test(evitar_origen, [fail]) :- ruta_evitando('P011', 'P004', 'P011', _).
test(evitar_destino, [fail]) :- ruta_evitando('P011', 'P004', 'P004', _).
test(destino_aislado, [fail, timeout(5)]) :- ruta_evitando('P001', 'P010', 'P003', _).
test(sin_evitar_p08_hay_mas_rutas, [timeout(5)]) :-
    findall(R, ruta_evitando('P011', 'P004', 'P010', R), Todas),
    member(R1, Todas), memberchk('P008', R1), !.

:- end_tests(ruta_evitando).

:- begin_tests(puede_atender, [setup(cargar)]).

test(disponible_y_alcanza) :- puede_atender('U002', 'S002').
test(capacidad_justa) :- puede_atender('U002', 'S004').
test(bus_no_disponible_pero_capaz, [fail]) :- puede_atender('U001', 'S002').
test(taxi_ocupado, [fail]) :- puede_atender('U004', 'S002').
test(capacidad_insuficiente_taxi, [fail]) :- puede_atender('U002', 'S006').
test(guia_alcanza) :- puede_atender('U003', 'S006').
% Capacidad y unidad sirven, pero la solicitud ya no esta pendiente.
test(asignada_no_se_reasigna, [fail]) :- puede_atender('U002', 'S005').
test(entregada_no_se_reasigna, [fail]) :- puede_atender('U003', 'S008').
test(todos_los_pares, [true(L == ['U002'-'S002', 'U002'-'S004', 'U003'-'S002', 'U003'-'S004', 'U003'-'S006', 'U003'-'S009'])]) :-
    findall(U-S, puede_atender(U, S), L).
test(solicitud_inexistente, [fail]) :- puede_atender('U002', 'S999').
test(unidades_para_s004, [true(L == ['U002', 'U003'])]) :-
    findall(U, puede_atender(U, 'S004'), L).
test(ninguna_unidad_para_s003, [true(L == [])]) :-
    findall(U, puede_atender(U, 'S003'), L).

:- end_tests(puede_atender).

:- begin_tests(inaccesibles, [setup(cargar), cleanup(cargar)]).

test(datos_de_prueba, [true(L == ['S006']), timeout(5)]) :-
    solicitudes_inaccesibles(L).
test(solo_pendientes) :-
    solicitudes_inaccesibles(L),
    forall(member(S, L), solicitud(S, _, _, _, _, pendiente, _)).
test(aislar_p01_agrega_s009, [true(L == ['S006', 'S009']), timeout(5)]) :-
    % Se cierran los tramos habilitados de P001 en el modulo de lecturaCSV.pl, donde vive la base.
    forall(member(Otro, ['P002', 'P009', 'P003']),
           ( lectura_csv:retract(conexion(C, 'P001', Otro, Km, Min, habilitada)),
             lectura_csv:assertz(conexion(C, 'P001', Otro, Km, Min, cerrada)) )),
    solicitudes_inaccesibles(L).

:- end_tests(inaccesibles).
