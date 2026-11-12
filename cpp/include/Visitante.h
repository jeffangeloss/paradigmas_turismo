#ifndef VISITANTE_H
#define VISITANTE_H

#include "Tipos.h"

#include <string>

class Visitante {
private:
  std::string solicitud;
  TipoVisitante tipo;

public:
  Visitante(std::string solicitud, TipoVisitante tipo);

  std::string getSolicitud() const;
  TipoVisitante getTipo() const;
};

#endif
