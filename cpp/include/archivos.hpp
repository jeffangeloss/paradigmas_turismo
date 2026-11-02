// Grupo 4 - Ruta turistica en Lima. Modulo C++ (paradigma imperativo).
// 4.1.2 Carga inicial y 4.1.5 Generacion de los archivos CSV.
// Responsable: Jefferson Sanchez
#pragma once
#include "modelo.hpp"

string rutaArchivo(const BaseDatos& db, const string& nombre);
void guardarTodo(const BaseDatos& db);
bool leerLineas(const string& ruta, vector<string>& lineas);
void avisarFilaOmitida(const string& archivo, size_t numeroLinea, const string& motivo);
void cargarPuntos(BaseDatos& db);
void cargarConexiones(BaseDatos& db);
void cargarUnidades(BaseDatos& db);
void cargarSolicitudes(BaseDatos& db);
void cargarTodo(BaseDatos& db);
