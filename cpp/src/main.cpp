#include <sstream>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

struct Punto {
    std::string codigo;
    std::string nombre;
    std::string tipo;
    std::string zona;
};

int main() {
    std::ifstream archivo("_datos/puntos.csv");

    if(!archivo){
        std::cerr << "No se pudo abrir _datos/puntos.csv\n";
        return 1;
    }

    std::string fila;
    std::getline(archivo, fila); // Omite el encabezado

    std::vector<Punto> puntos;
    while (std::getline(archivo, fila)) {
        if (fila.empty()) {
            continue;
        }

        std::istringstream campos(fila);
        Punto punto;
        if (std::getline(campos, punto.codigo, ',') && 
            std::getline(campos, punto.nombre, ',') && 
            std::getline(campos, punto.tipo, ',') &&
            std::getline(campos, punto.zona) ){
            puntos.push_back(punto);
        }
    }

    std::cout << "Puntos cargados: " << puntos.size() << '\n';
}

