% Grupo 4 - Ruta turistica en Lima: modulo logico (seccion 4.3).
% Reune la lectura de CSV de lecturaCSV.pl (4.3.1) con las reglas de 4.3.2 a 4.3.6 y las
% funcionalidades adicionales. Uso interactivo, desde la carpeta prolog/:
%   ?- [src/turismo].
%   ?- cargar_datos('../_datos').
%   ?- conectado('P001', 'P003', D).
% Un ejemplo de cada regla, desde la raiz:  swipl prolog/app/demo.pl -- _datos
% Los codigos se escriben entre comillas simples ('P001'), igual que en los CSV.

:- use_module(lecturaCSV).          % 4.3.1 Melissa Ruiz
:- use_module(library(lists)).

:- ensure_loaded(red).              % 4.3.2 y 4.3.3 Jefferson Sanchez
:- ensure_loaded(rutas).            % 4.3.4 Samantha Rodriguez
:- ensure_loaded(atencion).         % 4.3.5 Melissa Ruiz
:- ensure_loaded(inaccesibles).     % 4.3.6 Samantha Rodriguez

% Funcionalidades adicionales: cada integrante edita solo su archivo de fa/.
:- ensure_loaded(fa/fa_samantha).
:- ensure_loaded(fa/fa_melissa).
:- ensure_loaded(fa/fa_jefferson).

% ---------------------------------------------------------------
% Demostracion: un ejemplo de cada regla
% ---------------------------------------------------------------

demo :-
    format("4.3.1 hechos cargados por lecturaCSV.pl:~n"),
    forall(member(F/N, [punto/4, conexion/6, unidad/5, solicitud/7]),
           ( functor(Molde, F, N), aggregate_all(count, Molde, Cant),
             format("  ~w/~w: ~w~n", [F, N, Cant]) )),
    format("4.3.2 ?- conectado('P001', 'P003', D).  (ejemplo del enunciado)~n"),
    forall(conectado('P001', 'P003', D), format("  D = ~w~n", [D])),
    format("      ?- conectado('P001', 'P010', D).  (tramo cerrado)~n"),
    ( conectado('P001', 'P010', _) -> format("  true~n") ; format("  false~n") ),
    format("4.3.3 ?- alcanzable('P001', 'P006').~n"),
    ( alcanzable('P001', 'P006') -> format("  true~n") ; format("  false~n") ),
    format("      ?- alcanzable('P001', 'P010').~n"),
    ( alcanzable('P001', 'P010') -> format("  true~n") ; format("  false~n") ),
    format("4.3.4 ?- ruta_evitando('P001', 'P006', 'P003', R).  (todas, por backtracking)~n"),
    forall(ruta_evitando('P001', 'P006', 'P003', R), format("  R = ~w~n", [R])),
    format("4.3.5 ?- puede_atender(U, 'S004').~n"),
    forall(puede_atender(U, 'S004'), format("  U = ~w~n", [U])),
    format("      ?- puede_atender('U001', 'S002').  (U001 ocupada)~n"),
    ( puede_atender('U001', 'S002') -> format("  true~n") ; format("  false~n") ),
    format("4.3.6 ?- solicitudes_inaccesibles(L).~n"),
    solicitudes_inaccesibles(L),
    format("  L = ~w~n", [L]).
