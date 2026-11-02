// Grupo 4 - Ruta turistica en Lima. Modulo C++ (paradigma imperativo).
// 4.1.6 Consultas basicas.
// Responsable: Samantha Rodriguez
#include "consultas.hpp"
#include "utilidades.hpp"

// ---------------------------------------------------------- 4.1.6 Consultas

void imprimirSolicitud(const Solicitud& s) {
    cout << s.codigo << " | " << s.origen << " -> " << s.destino << " | " << s.turistas
         << " turistas | prioridad " << s.prioridad << " | " << s.estado << " | unidad "
         << (s.unidad.empty() ? "-" : s.unidad) << "\n";
}

void consultarPuntos(const BaseDatos& db) {
    cout << "Puntos registrados (" << db.puntos.size() << "):\n";
    for (size_t i = 0; i < db.puntos.size(); i++) {
        const Punto& p = db.puntos[i];
        cout << p.codigo << " | " << p.nombre << " | " << p.tipo << " | " << p.zona << "\n";
    }
}

void consultarConexionesDePunto(const BaseDatos& db) {
    string cod = aMayuscula(leerLinea("Codigo del punto: "));
    if (buscarPunto(db, cod) == -1) {
        cout << "El punto " << cod << " no existe.\n";
        return;
    }
    int total = 0;
    for (size_t i = 0; i < db.conexiones.size(); i++) {
        const Conexion& c = db.conexiones[i];
        if (c.origen != cod && c.destino != cod) continue;
        string otro = (c.origen == cod) ? c.destino : c.origen;
        cout << c.codigo << " | " << cod << " <-> " << otro << " | " << c.distanciaKm << " km | " << c.tiempoMin
             << " min | " << c.estado << "\n";
        total++;
    }
    if (total == 0) cout << "El punto " << cod << " no tiene conexiones.\n";
}

void consultarSolicitudesPorEstado(const BaseDatos& db) {
    string estado = aMinuscula(leerLinea("Estado (pendiente/asignada/entregada): "));
    if (!estaEn(estado, ESTADOS_SOLICITUD)) {
        cout << "Estado invalido: use pendiente, asignada o entregada.\n";
        return;
    }
    int total = 0;
    for (size_t i = 0; i < db.solicitudes.size(); i++) {
        if (db.solicitudes[i].estado != estado) continue;
        imprimirSolicitud(db.solicitudes[i]);
        total++;
    }
    if (total == 0) cout << "No hay solicitudes " << estado << ".\n";
}

// Todas las solicitudes que tienen esa unidad, con su estado (asignadas y entregadas)
void consultarSolicitudesDeUnidad(const BaseDatos& db) {
    string cod = aMayuscula(leerLinea("Codigo de la unidad: "));
    if (buscarUnidad(db, cod) == -1) {
        cout << "La unidad " << cod << " no existe.\n";
        return;
    }
    cout << "Solicitudes de " << cod << " (asignadas y entregadas):\n";
    int total = 0;
    for (size_t i = 0; i < db.solicitudes.size(); i++) {
        if (db.solicitudes[i].unidad != cod) continue;
        imprimirSolicitud(db.solicitudes[i]);
        total++;
    }
    if (total == 0) cout << "La unidad " << cod << " no tiene solicitudes.\n";
}
