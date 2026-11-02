#pragma once

#include <string>

namespace turismo {

class Destino {
public:
    Destino(std::string nombre, std::string pais);

    const std::string& nombre() const;
    const std::string& pais() const;
    std::string descripcion() const;

private:
    std::string nombre_;
    std::string pais_;
};

}  // namespace turismo

