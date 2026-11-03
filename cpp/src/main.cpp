#include "Destino.hpp"

#include <iostream>

int main() {
    const turismo::Destino destino{"Machu Picchu", "Perú"};
    std::cout << "Destino recomendado: " << destino.descripcion() << '\n';
    return 0;
}

