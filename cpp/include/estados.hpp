// Grupo 4 - Ruta turistica en Lima. Modulo C++ (paradigma imperativo).
// 4.1.4 Gestion de estados de conexiones, unidades y solicitudes.
// Responsable: Melissa Ruiz
#pragma once
#include "modelo.hpp"

void cambiarEstadoConexion(BaseDatos& db, const string& nuevoEstado);
void asignarSolicitud(BaseDatos& db);
void marcarEntregada(BaseDatos& db);
