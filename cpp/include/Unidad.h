#ifndef UNIDAD_H
#define UNIDAD_H

#include "Tipos.h"

#include <string>

class Unidad {
private:
  std::string codigo;
  TipoUnidad tipo;
  int capacidad;
  double costoKm;
  EstadoUnidad estado;

public:
  Unidad(std::string codigo, TipoUnidad tipo, int capacidad, double costoKm,
         EstadoUnidad estado);

  std::string getCodigo() const;
  TipoUnidad getTipo() const;
  int getCapacidad() const;
  double getCostoKm() const;
  EstadoUnidad getEstado() const;
  bool estaDisponible() const;
  bool tieneCapacidad(int cantidadPersonas) const;
  void ocupar();
  void liberar();
};

#endif
