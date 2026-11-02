:- module(turismo, [destino/2, descripcion/2]).

destino('Machu Picchu', 'Perú').
destino('Cartagena de Indias', 'Colombia').
destino('Buenos Aires', 'Argentina').

descripcion(Nombre, Descripcion) :-
    destino(Nombre, Pais),
    format(string(Descripcion), '~w, ~w', [Nombre, Pais]).

