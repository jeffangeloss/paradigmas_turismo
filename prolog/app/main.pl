:- use_module('../src/lecturaCSV', [cargar_datos/2]).
:- use_module('../src/entrada', [leer_entrada/2]).
:- use_module('../src/conectividad', [
    ejecutar_conexion/0,
    ejecutar_alcanzabilidad/0
]).
:- use_module('../src/atencion_solicitudes', [ejecutar_atencion/0]).

main :-
    current_prolog_flag(argv, Argumentos),
    (   Argumentos = [CarpetaDatos|_]
    ->  ejecutar_carga(CarpetaDatos)
    ;   writeln('[ERROR] Uso: swipl prolog/app/main.pl -- _datos'),
        halt(1)
    ).

ejecutar_carga(CarpetaDatos) :-
    format('Cargando archivos desde: ~w~n~n', [CarpetaDatos]),
    catch(
        ( cargar_datos(CarpetaDatos, Resumen),
          mostrar_resumen(Resumen),
          menu_principal
        ),
        Error,
        manejar_error(Error)
    ).

mostrar_resumen(resumen(Puntos, Conexiones, Unidades, Solicitudes)) :-
    format('[OK] puntos.csv: ~d registros~n', [Puntos]),
    format('[OK] conexiones.csv: ~d registros~n', [Conexiones]),
    format('[OK] unidades.csv: ~d registros~n', [Unidades]),
    format('[OK] solicitudes.csv: ~d registros~n', [Solicitudes]),
    Total is Puntos + Conexiones + Unidades + Solicitudes,
    format('~nCarga completada: 4 archivos, ~d registros en total.~n', [Total]).

% Muestra las funcionalidades Prolog y procesa una opción por vez.
menu_principal :-
    mostrar_menu,
    leer_entrada('Opcion: ', Opcion),
    ejecutar_opcion(Opcion).

mostrar_menu :-
    nl,
    writeln('=== Modulo Prolog ==='),
    writeln('1. [4.3.2] Regla de conexion directa'),
    writeln('2. [4.3.3] Regla de alcanzabilidad'),
    writeln('3. [4.3.4] Regla de ruta evitando un punto'),
    writeln('4. [4.3.5] Regla de atencion de solicitudes'),
    writeln('5. [4.3.6] Regla de solicitudes inaccesibles'),
    writeln('0. Volver al menu de C++').

ejecutar_opcion("1") :-
    ejecutar_conexion,
    menu_principal.
ejecutar_opcion("2") :-
    ejecutar_alcanzabilidad,
    menu_principal.
ejecutar_opcion("3") :-
    % TODO 4.3.4: reemplazar este placeholder por la ruta que evita un punto.
    mostrar_placeholder('Regla de ruta evitando un punto'),
    menu_principal.
ejecutar_opcion("4") :-
    ejecutar_atencion,
    menu_principal.
ejecutar_opcion("5") :-
    % TODO 4.3.6: reemplazar este placeholder por solicitudes inaccesibles.
    mostrar_placeholder('Regla de solicitudes inaccesibles'),
    menu_principal.
ejecutar_opcion("0") :-
    writeln('Regresando al menu de C++...').
ejecutar_opcion(_) :-
    writeln('[ERROR] Opcion no valida.'),
    menu_principal.

mostrar_placeholder(Funcionalidad) :-
    format('[PENDIENTE] ~w aun no esta implementada.~n', [Funcionalidad]).

manejar_error(Error) :-
    message_to_string(Error, Detalle),
    format(
        user_error,
        '[ERROR] No se pudieron cargar los archivos CSV.~nDetalle: ~w~n',
        [Detalle]
    ),
    halt(1).

:- initialization(main, main).
