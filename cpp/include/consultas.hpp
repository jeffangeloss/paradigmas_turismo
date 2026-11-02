// Grupo 4 - Ruta turistica en Lima. Modulo C++ (paradigma imperativo).
// 4.1.6 Consultas basicas.
// Responsable: Samantha Rodriguez
#pragma once
#include "modelo.hpp"

void imprimirSolicitud(const Solicitud& s);
void consultarPuntos(const BaseDatos& db);
void consultarConexionesDePunto(const BaseDatos& db);
void consultarSolicitudesPorEstado(const BaseDatos& db);
void consultarSolicitudesDeUnidad(const BaseDatos& db);
