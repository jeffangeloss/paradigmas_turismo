:- use_module('../src/turismo').

main :-
    descripcion('Machu Picchu', Descripcion),
    format('Destino recomendado: ~w~n', [Descripcion]),
    halt.

:- initialization(main, main).

