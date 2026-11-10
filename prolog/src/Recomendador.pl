% FA01: recomendaciones justificadas por perfil.
:- module(recomendador, [
    cargar_recomendador/1,
    recomendar/2,
    ejecutar_recomendador/0
]).

:- use_module(library(csv)).
:- use_module('LecturaCSV', [punto/4, conexion/6]).
:- use_module('entradasMenu', [leer_codigo/2]).

:- dynamic caracteristica_punto/7.
:- dynamic accesibilidad_conexion/2.
:- dynamic perfil_turista/4.
:- dynamic categoria_punto/2.
:- dynamic interes_perfil/2.

cargar_recomendador(CarpetaDatos) :-
    validar_archivos(CarpetaDatos,
        ['caracteristicas_puntos.csv', 'accesibilidad_conexiones.csv',
         'perfiles_turista.csv', 'categorias_puntos.csv', 'intereses_turista.csv']),
    retractall(caracteristica_punto(_, _, _, _, _, _, _)),
    retractall(accesibilidad_conexion(_, _)),
    retractall(perfil_turista(_, _, _, _)),
    retractall(categoria_punto(_, _)),
    retractall(interes_perfil(_, _)),
    cargar_caracteristicas(CarpetaDatos),
    cargar_accesibilidad(CarpetaDatos),
    cargar_perfiles(CarpetaDatos),
    cargar_categorias(CarpetaDatos),
    cargar_intereses(CarpetaDatos).

validar_archivos(_, []).
validar_archivos(CarpetaDatos, [Nombre|Resto]) :-
    directory_file_path(CarpetaDatos, Nombre, Ruta),
    (   exists_file(Ruta)
    ->  validar_archivos(CarpetaDatos, Resto)
    ;   format('[ERROR] Falta el archivo ~w.~n', [Ruta]),
        fail
    ).

leer_csv(CarpetaDatos, Nombre, Filas) :-
    directory_file_path(CarpetaDatos, Nombre, Ruta),
    csv_read_file(Ruta, [_Encabezado|Filas],
        [functor(fila), strip(true), convert(true)]).

cargar_caracteristicas(CarpetaDatos) :-
    leer_csv(CarpetaDatos, 'caracteristicas_puntos.csv', Filas),
    maplist(guardar_caracteristica, Filas).

guardar_caracteristica(fila(Codigo, Movilidad, Ninos, Dia, Noche, Inicio, Fin)) :-
    assertz(caracteristica_punto(Codigo, Movilidad, Ninos, Dia, Noche, Inicio, Fin)).

cargar_accesibilidad(CarpetaDatos) :-
    leer_csv(CarpetaDatos, 'accesibilidad_conexiones.csv', Filas),
    maplist(guardar_accesibilidad, Filas).

guardar_accesibilidad(fila(Codigo, Accesible)) :-
    assertz(accesibilidad_conexion(Codigo, Accesible)).

cargar_perfiles(CarpetaDatos) :-
    leer_csv(CarpetaDatos, 'perfiles_turista.csv', Filas),
    maplist(guardar_perfil, Filas).

guardar_perfil(fila(Codigo, Movilidad, Ninos, Hora)) :-
    assertz(perfil_turista(Codigo, Movilidad, Ninos, Hora)).

cargar_categorias(CarpetaDatos) :-
    leer_csv(CarpetaDatos, 'categorias_puntos.csv', Filas),
    maplist(guardar_categoria, Filas).

guardar_categoria(fila(Codigo, Categoria)) :-
    assertz(categoria_punto(Codigo, Categoria)).

cargar_intereses(CarpetaDatos) :-
    leer_csv(CarpetaDatos, 'intereses_turista.csv', Filas),
    maplist(guardar_interes, Filas).

guardar_interes(fila(Codigo, Interes)) :-
    assertz(interes_perfil(Codigo, Interes)).

recomendar(CodigoPerfil, Resultados) :-
    perfil_turista(CodigoPerfil, Movilidad, Ninos, Hora),
    findall(
        Resultado,
        ( punto(Codigo, Nombre, Tipo, _),
          member(Tipo, [atractivo, mirador, hotel]),
          resultado_punto(CodigoPerfil, Codigo, Nombre, Movilidad, Ninos, Hora, Resultado)
        ),
        Resultados
    ).

resultado_punto(CodigoPerfil, Codigo, Nombre, Movilidad, Ninos, Hora, Resultado) :-
    caracteristica_punto(Codigo, Accesible, AptoNinos, SeguroDia, SeguroNoche, Inicio, Fin),
    evaluar_punto(CodigoPerfil, Codigo, Nombre, Accesible, AptoNinos,
        SeguroDia, SeguroNoche, Inicio, Fin, Movilidad, Ninos, Hora, Resultado).

evaluar_punto(CodigoPerfil, Codigo, Nombre, Accesible, AptoNinos,
    SeguroDia, SeguroNoche, Inicio, Fin, Movilidad, Ninos, Hora, Resultado) :-
    findall(Motivo,
        motivo_favorable(CodigoPerfil, Codigo, Accesible, AptoNinos,
            SeguroDia, SeguroNoche, Inicio, Fin, Movilidad, Ninos, Hora, Motivo),
        Motivos),
    findall(Razon,
        motivo_descarte(Codigo, Accesible, AptoNinos, SeguroDia,
            SeguroNoche, Inicio, Fin, Movilidad, Ninos, Hora, Razon),
        Descartes),
    (   Descartes = []
    ->  length(Motivos, Puntaje),
        Resultado = recomendacion(Codigo, Nombre, Puntaje, Motivos)
    ;   Resultado = descarte(Codigo, Nombre, Descartes)
    ).

motivo_favorable(Perfil, Codigo, _, _, _, _, _, _, _, _, _,
    'coincide con un interes del perfil') :-
    interes_perfil(Perfil, Interes),
    categoria_punto(Codigo, Interes).
motivo_favorable(_, _, 'si', _, _, _, _, _, 'si', _, _,
    'el lugar es accesible para movilidad reducida').
motivo_favorable(_, _, _, 'si', _, _, _, _, _, 'si', _,
    'es adecuado para visitar con ninos').
motivo_favorable(_, _, _, _, _, _, Inicio, Fin, _, _, Hora,
    'el horario esta dentro del horario de atencion') :-
    hora_en_rango(Hora, Inicio, Fin).
motivo_favorable(_, _, _, _, 'si', _, _, _, _, _, Hora,
    'es seguro durante el dia') :-
    hora_del_dia(Hora, dia).
motivo_favorable(_, _, _, _, _, 'si', _, _, _, _, Hora,
    'es seguro durante la noche') :-
    hora_del_dia(Hora, noche).
motivo_favorable(CodigoPerfil, Codigo, _, _, _, _, _, _, 'si', _, _,
    'existe una ruta accesible desde un hotel') :-
    perfil_turista(CodigoPerfil, 'si', _, _),
    accesible_desde_hotel(Codigo), !.

motivo_descarte(_, 'no', _, _, _, _, _, 'si', _, _,
    'no cumple el requisito de movilidad reducida').
motivo_descarte(_, _, 'no', _, _, _, _, _, 'si', _,
    'no esta marcado como adecuado para ninos').
motivo_descarte(_, _, _, 'no', _, _, _, _, _, Hora,
    'no es seguro durante el horario indicado') :-
    hora_del_dia(Hora, dia).
motivo_descarte(_, _, _, _, 'no', _, _, _, _, Hora,
    'no es seguro durante el horario indicado') :-
    hora_del_dia(Hora, noche).
motivo_descarte(_, _, _, _, _, Inicio, Fin, _, _, Hora,
    'esta fuera del horario de atencion') :-
    \+ hora_en_rango(Hora, Inicio, Fin).
motivo_descarte(Codigo, _, _, _, _, _, _, 'si', _, _,
    'no existe una ruta accesible desde un hotel') :-
    \+ accesible_desde_hotel(Codigo).

accesible_desde_hotel(Destino) :-
    punto(Origen, _, hotel, _),
    ruta_accesible(Origen, Destino, [Origen]).

ruta_accesible(Actual, Destino, _) :- Actual = Destino.
ruta_accesible(Actual, Destino, Visitados) :-
    conexion(Codigo, Actual, Vecino, _, _, habilitada),
    accesibilidad_conexion(Codigo, 'si'),
    \+ member(Vecino, Visitados),
    ruta_accesible(Vecino, Destino, [Vecino|Visitados]).
ruta_accesible(Actual, Destino, Visitados) :-
    conexion(Codigo, Vecino, Actual, _, _, habilitada),
    accesibilidad_conexion(Codigo, 'si'),
    \+ member(Vecino, Visitados),
    ruta_accesible(Vecino, Destino, [Vecino|Visitados]).

hora_en_rango(Hora, Inicio, Fin) :- Hora @>= Inicio, Hora @=< Fin.
hora_del_dia(Hora, dia) :- Hora @>= '06:00', Hora @< '18:00'.
hora_del_dia(Hora, noche) :- Hora @< '06:00' ; Hora @>= '18:00'.

ejecutar_recomendador :-
    leer_codigo('Codigo del perfil turistico: ', CodigoPerfil),
    (   recomendar(CodigoPerfil, Resultados)
    ->  mostrar_resultados(Resultados)
    ;   format('[ERROR] No se encontro el perfil ~w.~n', [CodigoPerfil])
    ).

mostrar_resultados([]) :-
    writeln('[INFO] No hay puntos turisticos para evaluar.').
mostrar_resultados(Resultados) :-
    Resultados \= [],
    forall(member(Resultado, Resultados), mostrar_resultado(Resultado)).

mostrar_resultado(recomendacion(Codigo, Nombre, Puntaje, Motivos)) :-
    format('[RECOMENDADO] ~w - ~w (coincidencias: ~d)~n',
        [Codigo, Nombre, Puntaje]),
    mostrar_motivos(Motivos, '+').
mostrar_resultado(descarte(Codigo, Nombre, Razones)) :-
    format('[DESCARTADO] ~w - ~w~n', [Codigo, Nombre]),
    mostrar_motivos(Razones, '-').

mostrar_motivos([], _).
mostrar_motivos([Motivo|Resto], Simbolo) :-
    format('  ~w ~w~n', [Simbolo, Motivo]),
    mostrar_motivos(Resto, Simbolo).
