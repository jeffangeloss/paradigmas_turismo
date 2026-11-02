% Grupo 4 - Ruta turistica en Lima: modulo logico (seccion 4.3).
% 4.3.5 Atencion de solicitudes. Responsable: Melissa Ruiz.

% ---------------------------------------------------------------
% 4.3.5 Atencion de solicitudes
% ---------------------------------------------------------------

% La unidad esta disponible y su capacidad alcanza para los turistas.
% Solo solicitudes pendientes: C++ no reasigna una asignada ni una
% entregada (invariante 2 del CONTRATO).
puede_atender(Unidad, Solicitud) :-
    unidad(Unidad, _, Capacidad, _, disponible),
    solicitud(Solicitud, _, _, Turistas, _, pendiente, _),
    Capacidad >= Turistas.
