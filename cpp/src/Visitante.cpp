#include "Visitante.h"

Visitante::Visitante(std::string solicitud, TipoVisitante tipo) {
  this->solicitud = solicitud;
  this->tipo = tipo;
}

std::string Visitante::getSolicitud() const { return solicitud; }

TipoVisitante Visitante::getTipo() const { return tipo; }
