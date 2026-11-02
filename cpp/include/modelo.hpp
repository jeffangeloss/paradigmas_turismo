// Grupo 4 - Ruta turistica en Lima. Modulo C++ (paradigma imperativo).
// Estructuras y valores permitidos que comparten todos los archivos de C++.
// Archivo compartido: un cambio aqui toca a todos, asi que se acuerda en grupo
// y se revisa en un pull request antes de fusionarlo (ver BACKLOG.md).
#pragma once

#include <cctype>
#include <climits>
#include <cmath>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>
using namespace std;

// ---------------------------------------------------------------- Estructuras

struct Punto {
    string codigo, nombre, tipo, zona;
};

struct Conexion {
    string codigo, origen, destino;
    double distanciaKm;
    int tiempoMin;
    string estado;
};

struct Unidad {
    string codigo, tipo;
    int capacidad;
    double costoKm;
    string estado;
};

struct Solicitud {
    string codigo, origen, destino;
    int turistas;
    string prioridad, estado, unidad;
};

// Toda la informacion en memoria; cada cambio se vuelca a los CSV.
struct BaseDatos {
    string carpeta;
    vector<Punto> puntos;
    vector<Conexion> conexiones;
    vector<Unidad> unidades;
    vector<Solicitud> solicitudes;
};

// Valores permitidos por el contrato (para agregar uno basta con tocar su vector)
const vector<string> TIPOS_PUNTO = {"atractivo", "hotel", "mirador"};
const vector<string> TIPOS_UNIDAD = {"guia_peatonal", "taxi_turistico", "bus_turistico"};
const vector<string> ESTADOS_CONEXION = {"habilitada", "cerrada"};
const vector<string> ESTADOS_UNIDAD = {"disponible", "ocupada"};
const vector<string> PRIORIDADES = {"alta", "media", "baja"};
const vector<string> ESTADOS_SOLICITUD = {"pendiente", "asignada", "entregada"};
