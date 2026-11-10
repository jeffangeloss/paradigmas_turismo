#include "Destino.hpp"

#include <utility>

namespace turismo {

Destino::Destino(std::string nombre, std::string pais)
    : nombre_(std::move(nombre)), pais_(std::move(pais)) {}

const std::string &Destino::nombre() const { return nombre_; }

const std::string &Destino::pais() const { return pais_; }

std::string Destino::descripcion() const { return nombre_ + ", " + pais_; }

} // namespace turismo
