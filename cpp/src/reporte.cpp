// Grupo 4 - Ruta turistica en Lima. Modulo C++ (paradigma imperativo).
// 4.1.7 Reporte general.
// Responsable: Samantha Rodriguez
#include "reporte.hpp"

// ------------------------------------------------------ 4.1.7 Reporte general

void mostrarReporte(const BaseDatos& db) {
    int habilitadas = 0, cerradas = 0;
    for (size_t i = 0; i < db.conexiones.size(); i++) {
        if (db.conexiones[i].estado == "habilitada") habilitadas++;
        else cerradas++;
    }
    int disponibles = 0;
    for (size_t i = 0; i < db.unidades.size(); i++) {
        if (db.unidades[i].estado == "disponible") disponibles++;
    }
    int pendientes = 0, asignadas = 0, entregadas = 0;
    for (size_t i = 0; i < db.solicitudes.size(); i++) {
        if (db.solicitudes[i].estado == "pendiente") pendientes++;
        else if (db.solicitudes[i].estado == "asignada") asignadas++;
        else entregadas++;
    }
    // Unidad con mas solicitudes (en empate gana la primera registrada)
    string mejor = "";
    int maximo = 0;
    for (size_t i = 0; i < db.unidades.size(); i++) {
        int cuenta = 0;
        for (size_t j = 0; j < db.solicitudes.size(); j++) {
            if (db.solicitudes[j].unidad == db.unidades[i].codigo) cuenta++;
        }
        if (cuenta > maximo) {
            maximo = cuenta;
            mejor = db.unidades[i].codigo;
        }
    }

    cout << "Puntos registrados: " << db.puntos.size() << "\n";
    cout << "Conexiones habilitadas: " << habilitadas << " | Cerradas: " << cerradas << "\n";
    cout << "Unidades disponibles: " << disponibles << " de " << db.unidades.size() << "\n";
    cout << "Solicitudes pendientes: " << pendientes << " | Asignadas: " << asignadas
         << " | Entregadas: " << entregadas << "\n";
    if (maximo == 0) cout << "Unidad con mas solicitudes: ninguna\n";
    else cout << "Unidad con mas solicitudes: " << mejor << " (" << maximo << " solicitudes)\n";
}
