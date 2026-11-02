// Grupo 4 - Ruta turistica en Lima. Modulo C++ (paradigma imperativo).
// 4.1.3 Validaciones de cada registro (tambien las usa la carga 4.1.2).
// Responsable: Melissa Ruiz
#pragma once
#include "modelo.hpp"

string validarPunto(const BaseDatos& db, const Punto& p);
string validarConexion(const BaseDatos& db, const Conexion& c);
string validarUnidad(const BaseDatos& db, const Unidad& u);
string validarSolicitud(const BaseDatos& db, const Solicitud& s);
