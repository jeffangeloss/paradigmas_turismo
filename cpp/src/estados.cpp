// Grupo 4 - Ruta turistica en Lima. Modulo C++ (paradigma imperativo).
// 4.1.4 Gestion de estados de conexiones, unidades y solicitudes.
// Responsable: Melissa Ruiz
#include "estados.hpp"
#include "archivos.hpp"
#include "utilidades.hpp"

// ---------------------------------------------------- 4.1.4 Gestion de estados

// Cierra o habilita una conexion; el tramo se busca en ambos sentidos.
void cambiarEstadoConexion(BaseDatos& db, const string& nuevoEstado) {
    string a = aMayuscula(leerLinea("Un extremo de la conexion: "));
    string b = aMayuscula(leerLinea("El otro extremo: "));
    int pos = buscarConexion(db, a, b);
    if (pos == -1) {
        cout << "No existe una conexion entre " << a << " y " << b << ".\n";
        return;
    }
    if (db.conexiones[pos].estado == nuevoEstado) {
        cout << "La conexion " << a << " - " << b << " ya esta " << nuevoEstado << ".\n";
        return;
    }
    db.conexiones[pos].estado = nuevoEstado;
    guardarTodo(db);
    cout << "Conexion " << a << " - " << b << " ahora esta " << nuevoEstado << ".\n";
}

// Invariante 2: pendiente + unidad disponible + capacidad >= turistas
void asignarSolicitud(BaseDatos& db) {
    string codSol = aMayuscula(leerLinea("Codigo de la solicitud: "));
    int s = buscarSolicitud(db, codSol);
    if (s == -1) {
        cout << "La solicitud " << codSol << " no existe.\n";
        return;
    }
    if (db.solicitudes[s].estado != "pendiente") {
        cout << "La solicitud " << codSol << " no esta pendiente (estado: " << db.solicitudes[s].estado
             << ").\n";
        return;
    }
    string codUni = aMayuscula(leerLinea("Codigo de la unidad: "));
    int u = buscarUnidad(db, codUni);
    if (u == -1) {
        cout << "La unidad " << codUni << " no existe.\n";
        return;
    }
    if (db.unidades[u].estado != "disponible") {
        cout << "La unidad " << codUni << " esta ocupada.\n";
        return;
    }
    if (db.unidades[u].capacidad < db.solicitudes[s].turistas) {
        cout << "Capacidad insuficiente: la unidad " << codUni << " lleva "
             << db.unidades[u].capacidad << " y la solicitud tiene " << db.solicitudes[s].turistas
             << " turistas.\n";
        return;
    }
    db.solicitudes[s].estado = "asignada";
    db.solicitudes[s].unidad = codUni;
    db.unidades[u].estado = "ocupada";
    guardarTodo(db);
    cout << "Solicitud " << codSol << " asignada a la unidad " << codUni << ".\n";
}

// Invariante 3: solo una solicitud asignada pasa a entregada y libera su unidad
void marcarEntregada(BaseDatos& db) {
    string codSol = aMayuscula(leerLinea("Codigo de la solicitud: "));
    int s = buscarSolicitud(db, codSol);
    if (s == -1) {
        cout << "La solicitud " << codSol << " no existe.\n";
        return;
    }
    if (db.solicitudes[s].estado != "asignada") {
        cout << "La solicitud " << codSol << " no esta asignada (estado: " << db.solicitudes[s].estado
             << ").\n";
        return;
    }
    db.solicitudes[s].estado = "entregada";  // conserva su unidad
    int u = buscarUnidad(db, db.solicitudes[s].unidad);
    if (u != -1) db.unidades[u].estado = "disponible";
    guardarTodo(db);
    cout << "Solicitud " << codSol << " entregada; la unidad " << db.solicitudes[s].unidad
         << " queda disponible.\n";
}
