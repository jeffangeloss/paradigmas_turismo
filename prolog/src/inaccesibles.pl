% Grupo 4 - Ruta turistica en Lima: modulo logico (seccion 4.3).
% 4.3.6 Solicitudes inaccesibles. Responsable: Samantha Rodriguez.

% ---------------------------------------------------------------
% 4.3.6 Solicitudes inaccesibles
% ---------------------------------------------------------------

% Pendientes cuyo destino no se alcanza desde el origen por tramos habilitados.
solicitudes_inaccesibles(Lista) :-
    findall(S,
            ( solicitud(S, Origen, Destino, _, _, pendiente, _),
              \+ alcanzable(Origen, Destino) ),
            Lista).
