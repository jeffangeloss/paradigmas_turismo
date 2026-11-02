% Grupo 4 - Ruta turistica en Lima: un ejemplo de cada regla de la seccion 4.3.
% Uso, desde la raiz del repositorio:  swipl prolog/app/demo.pl -- _datos

:- ensure_loaded('../src/turismo').

main :-
    current_prolog_flag(argv, Argumentos),
    (   Argumentos = [CarpetaDatos|_]
    ->  cargar_datos(CarpetaDatos),
        demo
    ;   writeln('Uso: swipl prolog/app/demo.pl -- _datos'),
        halt(1)
    ).

:- initialization(main, main).
