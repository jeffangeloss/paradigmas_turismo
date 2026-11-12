#ifndef SOLICITUD_H
#define SOLICITUD_H

#include "Tipos.h"

#include <string>

class Solicitud {
private:
  std::string codigo;
  std::string origen;
  std::string destino;
  int cantidadTuristas;
  Prioridad prioridad;
  EstadoSolicitud estado;
  std::string unidadAsignada;

public:
  Solicitud(std::string codigo, std::string origen, std::string destino,
            int cantidadTuristas, Prioridad prioridad, EstadoSolicitud estado,
            std::string unidadAsignada);

  std::string getCodigo() const;
  std::string getOrigen() const;
  std::string getDestino() const;
  int getCantidadTuristas() const;
  Prioridad getPrioridad() const;
  EstadoSolicitud getEstado() const;
  std::string getUnidadAsignada() const;
  bool estaPendiente() const;
  void asignarUnidad(std::string codigoUnidad);
  void marcarEntregada();
};

#endif
