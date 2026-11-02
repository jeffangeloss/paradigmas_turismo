// Sistema Planificador de Rutas y Logistica - Grupo 4: ruta turistica en Lima
// Modulo C++ (paradigma imperativo): registra, gestiona y guarda los CSV base.
// 4.1.1 Menu principal. Responsable: Samantha Rodriguez
// Compilar: cmake -S cpp -B cpp/build && cmake --build cpp/build   (ver cpp/README.md)
// Ejecutar: ./cpp/build/turismo_cpp [carpeta_datos]   (por defecto "_datos")
#include "archivos.hpp"
#include "consultas.hpp"
#include "estados.hpp"
#include "registro.hpp"
#include "reporte.hpp"
#include "utilidades.hpp"
#include "fa/fa.hpp"

// ------------------------------------------------------- 4.1.1 Menu principal

void menuRegistrar(BaseDatos& db) {
    while (true) {
        cout << "\n--- Registrar ---\n1. Punto\n2. Conexion\n3. Unidad\n4. Solicitud\n0. Volver\n";
        int opcion = leerEntero("Opcion: ");
        switch (opcion) {
            case 1: registrarPunto(db); break;
            case 2: registrarConexion(db); break;
            case 3: registrarUnidad(db); break;
            case 4: registrarSolicitud(db); break;
            case 0: return;
            default: cout << "Opcion no valida.\n";
        }
    }
}

void menuEstados(BaseDatos& db) {
    while (true) {
        cout << "\n--- Gestionar estados ---\n1. Cerrar conexion\n2. Habilitar conexion\n"
                "3. Asignar solicitud a unidad\n4. Marcar solicitud entregada\n0. Volver\n";
        int opcion = leerEntero("Opcion: ");
        switch (opcion) {
            case 1: cambiarEstadoConexion(db, "cerrada"); break;
            case 2: cambiarEstadoConexion(db, "habilitada"); break;
            case 3: asignarSolicitud(db); break;
            case 4: marcarEntregada(db); break;
            case 0: return;
            default: cout << "Opcion no valida.\n";
        }
    }
}

void menuConsultas(const BaseDatos& db) {
    while (true) {
        cout << "\n--- Consultas ---\n1. Puntos registrados\n2. Conexiones de un punto\n"
                "3. Solicitudes segun estado\n4. Solicitudes de una unidad\n0. Volver\n";
        int opcion = leerEntero("Opcion: ");
        switch (opcion) {
            case 1: consultarPuntos(db); break;
            case 2: consultarConexionesDePunto(db); break;
            case 3: consultarSolicitudesPorEstado(db); break;
            case 4: consultarSolicitudesDeUnidad(db); break;
            case 0: return;
            default: cout << "Opcion no valida.\n";
        }
    }
}

// Opcion 5: cada integrante implementa su funcionalidad adicional en cpp/fa/
// y este menu solo la llama, asi que nadie mas toca este archivo por su FA.
void menuFuncionalidadesAdicionales(BaseDatos& db) {
    while (true) {
        cout << "\n--- Funcionalidades adicionales ---\n1. " << tituloFASamantha() << "\n2. "
             << tituloFAMelissa() << "\n3. " << tituloFAJefferson() << "\n0. Volver\n";
        int opcion = leerEntero("Opcion: ");
        switch (opcion) {
            case 1: menuFASamantha(db); break;
            case 2: menuFAMelissa(db); break;
            case 3: menuFAJefferson(db); break;
            case 0: return;
            default: cout << "Opcion no valida.\n";
        }
    }
}

int main(int argc, char* argv[]) {
    BaseDatos db;
    db.carpeta = (argc > 1) ? argv[1] : "_datos";
    cargarTodo(db);  // 4.1.2

    cout << fixed << setprecision(2);  // todos los decimales en pantalla salen con 2 cifras
    while (true) {
        cout << "\n=== Ruta turistica en Lima ===\n1. Registrar\n2. Gestionar estados\n"
                "3. Consultas\n4. Reporte general\n5. Funcionalidades adicionales\n0. Salir\n";
        int opcion = leerEntero("Opcion: ");
        switch (opcion) {
            case 1: menuRegistrar(db); break;
            case 2: menuEstados(db); break;
            case 3: menuConsultas(db); break;
            case 4: mostrarReporte(db); break;
            case 5: menuFuncionalidadesAdicionales(db); break;
            case 0: return 0;
            default: cout << "Opcion no valida.\n";
        }
    }
}
