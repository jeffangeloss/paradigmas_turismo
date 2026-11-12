#ifndef CONEXION_H
#define CONEXION_H

#include "Tipos.h"

#include <string>

class Conexion {
private:
  std::string codigo;
  std::string origen;
  std::string destino;
  double distancia;
  int tiempo;
  EstadoConexion estado;

public:
  Conexion(std::string codigo, std::string origen, std::string destino,
           double distancia, int tiempo, EstadoConexion estado);

  std::string getCodigo() const;
  std::string getOrigen() const;
  std::string getDestino() const;
  double getDistancia() const;
  int getTiempo() const;
  EstadoConexion getEstado() const;
  bool estaHabilitada() const;
};

#endif
