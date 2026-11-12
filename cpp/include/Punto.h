#ifndef PUNTO_H
#define PUNTO_H

#include "Tipos.h"

#include <string>

class Punto {
private:
  std::string codigo;
  std::string nombre;
  TipoPunto tipo;
  std::string zona;

public:
  Punto(std::string codigo, std::string nombre, TipoPunto tipo,
        std::string zona);

  std::string getCodigo() const;
  std::string getNombre() const;
  TipoPunto getTipo() const;
  std::string getZona() const;
  bool esAtractivo() const;
};

#endif
