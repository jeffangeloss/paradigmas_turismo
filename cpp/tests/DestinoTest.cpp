#include "Destino.hpp"

#include <cassert>

int main() {
    const turismo::Destino destino{"Machu Picchu", "Perú"};

    assert(destino.nombre() == "Machu Picchu");
    assert(destino.pais() == "Perú");
    assert(destino.descripcion() == "Machu Picchu, Perú");
    return 0;
}

