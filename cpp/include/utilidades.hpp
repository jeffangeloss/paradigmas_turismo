// Grupo 4 - Ruta turistica en Lima. Modulo C++ (paradigma imperativo).
// Utilidades de texto, busquedas y entrada por consola que usan todos los archivos.
// Archivo compartido: se cambia solo con acuerdo del grupo (ver BACKLOG.md).
#pragma once
#include "modelo.hpp"

string recortar(const string& s);
string aMayuscula(string s);
string aMinuscula(string s);
vector<string> dividirCampos(const string& linea);
bool soloNumerico(const string& s);
bool aEntero(const string& s, int& valor);
bool aDecimal(const string& s, double& valor);
bool textoValido(const string& s);
bool estaEn(const string& valor, const vector<string>& opciones);

int buscarPunto(const BaseDatos& db, const string& codigo);
int buscarConexion(const BaseDatos& db, const string& a, const string& b);
int buscarConexionPorCodigo(const BaseDatos& db, const string& codigo);
int buscarUnidad(const BaseDatos& db, const string& codigo);
int buscarSolicitud(const BaseDatos& db, const string& codigo);

string leerLinea(const string& mensaje);
int leerEntero(const string& mensaje);
double leerDecimal(const string& mensaje);
