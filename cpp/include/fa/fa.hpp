// Grupo 4 - Ruta turistica en Lima. Puntos de entrada de las funcionalidades adicionales.
// El menu principal (opcion 5) llama a estas funciones. Cada integrante las define en su
// propio fa_<nombre>.cpp y puede agregar ahi mismo los archivos fa_<nombre>_*.cpp/.hpp que
// necesite. Este archivo no se edita, salvo acuerdo del grupo.
#pragma once
#include "modelo.hpp"

string tituloFASamantha();
void menuFASamantha(BaseDatos& db);

string tituloFAMelissa();
void menuFAMelissa(BaseDatos& db);

string tituloFAJefferson();
void menuFAJefferson(BaseDatos& db);
