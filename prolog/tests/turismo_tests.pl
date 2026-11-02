:- begin_tests(turismo).

:- use_module('../src/turismo').

test(destino_conocido) :-
    destino('Machu Picchu', 'Perú').

test(descripcion_destino) :-
    descripcion('Machu Picchu', 'Machu Picchu, Perú').

:- end_tests(turismo).

