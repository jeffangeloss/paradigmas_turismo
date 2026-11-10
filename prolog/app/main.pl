:- use_module('../src/LecturaCSV', [cargar_datos/2]).
:- use_module('../src/entradasMenu', [leer_entrada/2]).
:- use_module('../src/Conectividad', [
    ejecutar_conexion/0,
    ejecutar_alcanzabilidad/0,
    ejecutar_ruta_evitando/0
]).
:- use_module('../src/Atencion_solicitudes', [ejecutar_atencion/0]).
:- use_module('../src/Solicitudes_inaccesibles', [ejecutar_solicitudes_inaccesibles/0]).
:- use_module('../src/Recomendador', [cargar_recomendador/1, ejecutar_recomendador/0]).

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
          (   cargar_recomendador(CarpetaDatos)
          ->  mostrar_resumen(Resumen),
              menu_principal
          ;   writeln('[ERROR] No se pudieron cargar los archivos de FA01.'),
              halt(1)
          )
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
    writeln('6. [FA01] Recomendador explicable de atractivos'),
    writeln('0. Volver al menu de C++').

ejecutar_opcion("1") :-
    ejecutar_conexion,
    menu_principal.
ejecutar_opcion("2") :-
    ejecutar_alcanzabilidad,
    menu_principal.
ejecutar_opcion("3") :-
    ejecutar_ruta_evitando,
    menu_principal.
ejecutar_opcion("4") :-
    ejecutar_atencion,
    menu_principal.
ejecutar_opcion("5") :-
    ejecutar_solicitudes_inaccesibles,
    menu_principal.
ejecutar_opcion("6") :-
    ejecutar_recomendador,
    menu_principal.
ejecutar_opcion("0") :-
    writeln('Regresando al menu de C++...').
ejecutar_opcion(_) :-
    writeln('[ERROR] Opcion no valida.'),
    menu_principal.

manejar_error(Error) :-
    message_to_string(Error, Detalle),
    format(
        user_error,
        '[ERROR] No se pudieron cargar los archivos CSV.~nDetalle: ~w~n',
        [Detalle]
    ),
    halt(1).

:- initialization(main, main).
