// Grupo 4 - Ruta turistica en Lima. Modulo C++ (paradigma imperativo).
// 4.1.3 Registro de puntos, conexiones, unidades y solicitudes.
// Responsable: Melissa Ruiz
#include "registro.hpp"
#include "archivos.hpp"
#include "utilidades.hpp"
#include "validaciones.hpp"

// ---------------------------------------------------- 4.1.3 Registro con validaciones

void registrarPunto(BaseDatos& db) {
    Punto p;
    p.codigo = aMayuscula(leerLinea("Codigo (ej. P012): "));
    p.nombre = leerLinea("Nombre: ");
    p.tipo = aMinuscula(leerLinea("Tipo (atractivo/hotel/mirador): "));
    p.zona = leerLinea("Zona: ");
    string error = validarPunto(db, p);
    if (error != "") {
        cout << "No se registro el punto: " << error << "\n";
        return;
    }
    db.puntos.push_back(p);
    guardarTodo(db);
    cout << "Punto " << p.codigo << " registrado.\n";
}

void registrarConexion(BaseDatos& db) {
    Conexion c;
    c.codigo = aMayuscula(leerLinea("Codigo (ej. C017): "));
    c.origen = aMayuscula(leerLinea("Punto origen: "));
    c.destino = aMayuscula(leerLinea("Punto destino: "));
    c.distanciaKm = leerDecimal("Distancia (km): ");
    c.tiempoMin = leerEntero("Tiempo (min): ");
    c.estado = "habilitada";  // invariante 4
    string error = validarConexion(db, c);
    if (error != "") {
        cout << "No se registro la conexion: " << error << "\n";
        return;
    }
    db.conexiones.push_back(c);
    guardarTodo(db);
    cout << "Conexion " << c.codigo << " (" << c.origen << " - " << c.destino << ") registrada (habilitada).\n";
}

void registrarUnidad(BaseDatos& db) {
    Unidad u;
    u.codigo = aMayuscula(leerLinea("Codigo (ej. U005): "));
    u.tipo = aMinuscula(leerLinea("Tipo (guia_peatonal/taxi_turistico/bus_turistico): "));
    u.capacidad = leerEntero("Capacidad (personas): ");
    u.costoKm = leerDecimal("Costo por km: ");
    u.estado = "disponible";  // invariante 4
    string error = validarUnidad(db, u);
    if (error != "") {
        cout << "No se registro la unidad: " << error << "\n";
        return;
    }
    db.unidades.push_back(u);
    guardarTodo(db);
    cout << "Unidad " << u.codigo << " registrada (disponible).\n";
}

void registrarSolicitud(BaseDatos& db) {
    Solicitud s;
    s.codigo = aMayuscula(leerLinea("Codigo (ej. S010): "));
    s.origen = aMayuscula(leerLinea("Punto origen: "));
    s.destino = aMayuscula(leerLinea("Punto destino: "));
    s.turistas = leerEntero("Numero de turistas: ");
    s.prioridad = aMinuscula(leerLinea("Prioridad (alta/media/baja): "));
    s.estado = "pendiente";  // invariante 4
    s.unidad = "";
    string error = validarSolicitud(db, s);
    if (error != "") {
        cout << "No se registro la solicitud: " << error << "\n";
        return;
    }
    db.solicitudes.push_back(s);
    guardarTodo(db);
    cout << "Solicitud " << s.codigo << " registrada (pendiente).\n";
}
