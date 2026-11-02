// Grupo 4 - Ruta turistica en Lima. Modulo C++ (paradigma imperativo).
// 4.1.2 Carga inicial y 4.1.5 Generacion de los archivos CSV.
// Responsable: Jefferson Sanchez
#include "archivos.hpp"
#include "utilidades.hpp"
#include "validaciones.hpp"

// ------------------------------------------------------------- Archivos CSV

string rutaArchivo(const BaseDatos& db, const string& nombre) {
    return db.carpeta + "/" + nombre;
}

// 4.1.5 Generacion de archivos CSV (formato exacto del contrato)
void guardarTodo(const BaseDatos& db) {
    ofstream f;

    f.open(rutaArchivo(db, "puntos.csv").c_str());
    if (!f) cout << "AVISO: no se pudo escribir puntos.csv\n";
    f << "codigo,nombre,tipo,zona\n";
    for (size_t i = 0; i < db.puntos.size(); i++) {
        const Punto& p = db.puntos[i];
        f << p.codigo << "," << p.nombre << "," << p.tipo << "," << p.zona << "\n";
    }
    f.close();

    f.open(rutaArchivo(db, "conexiones.csv").c_str());
    if (!f) cout << "AVISO: no se pudo escribir conexiones.csv\n";
    f << fixed << setprecision(2);
    f << "codigo,origen,destino,distancia_km,tiempo_min,estado\n";
    for (size_t i = 0; i < db.conexiones.size(); i++) {
        const Conexion& c = db.conexiones[i];
        f << c.codigo << "," << c.origen << "," << c.destino << "," << c.distanciaKm << "," << c.tiempoMin << ","
          << c.estado << "\n";
    }
    f.close();

    f.open(rutaArchivo(db, "unidades.csv").c_str());
    if (!f) cout << "AVISO: no se pudo escribir unidades.csv\n";
    f << fixed << setprecision(2);
    f << "codigo,tipo,capacidad,costo_km,estado\n";
    for (size_t i = 0; i < db.unidades.size(); i++) {
        const Unidad& u = db.unidades[i];
        f << u.codigo << "," << u.tipo << "," << u.capacidad << "," << u.costoKm << "," << u.estado
          << "\n";
    }
    f.close();

    f.open(rutaArchivo(db, "solicitudes.csv").c_str());
    if (!f) cout << "AVISO: no se pudo escribir solicitudes.csv\n";
    f << "codigo,origen,destino,cantidad_turistas,prioridad,estado,unidad_asignada\n";
    for (size_t i = 0; i < db.solicitudes.size(); i++) {
        const Solicitud& s = db.solicitudes[i];
        f << s.codigo << "," << s.origen << "," << s.destino << "," << s.turistas << ","
          << s.prioridad << "," << s.estado << "," << s.unidad << "\n";
    }
    f.close();
}

// Lee todas las lineas de un CSV. Devuelve false si el archivo no existe.
bool leerLineas(const string& ruta, vector<string>& lineas) {
    ifstream f(ruta.c_str());
    if (!f) return false;
    string linea;
    while (getline(f, linea)) lineas.push_back(linea);
    return true;
}

static int filasOmitidas = 0;  // filas de los CSV que no se cargaron (se avisa en cargarTodo)

void avisarFilaOmitida(const string& archivo, size_t numeroLinea, const string& motivo) {
    filasOmitidas++;
    cout << "AVISO: " << archivo << " linea " << numeroLinea << " omitida: " << motivo << "\n";
}

// 4.1.2 Carga inicial. Las filas mal formadas se saltan avisando el numero de linea.
void cargarPuntos(BaseDatos& db) {
    vector<string> lineas;
    if (!leerLineas(rutaArchivo(db, "puntos.csv"), lineas)) {
        cout << "AVISO: no existe puntos.csv, se inicia sin puntos\n";
        return;
    }
    for (size_t i = 1; i < lineas.size(); i++) {  // la linea 0 es el encabezado
        if (recortar(lineas[i]).empty()) continue;
        vector<string> c = dividirCampos(lineas[i]);
        if (c.size() != 4) {
            avisarFilaOmitida("puntos.csv", i + 1, "se esperaban 4 campos");
            continue;
        }
        Punto p = {aMayuscula(c[0]), c[1], aMinuscula(c[2]), c[3]};
        string error = validarPunto(db, p);
        if (error != "") {
            avisarFilaOmitida("puntos.csv", i + 1, error);
            continue;
        }
        db.puntos.push_back(p);
    }
}

void cargarConexiones(BaseDatos& db) {
    vector<string> lineas;
    if (!leerLineas(rutaArchivo(db, "conexiones.csv"), lineas)) {
        cout << "AVISO: no existe conexiones.csv, se inicia sin conexiones\n";
        return;
    }
    for (size_t i = 1; i < lineas.size(); i++) {
        if (recortar(lineas[i]).empty()) continue;
        vector<string> c = dividirCampos(lineas[i]);
        if (c.size() != 6) {
            avisarFilaOmitida("conexiones.csv", i + 1, "se esperaban 6 campos");
            continue;
        }
        Conexion x;
        x.codigo = aMayuscula(c[0]);
        x.origen = aMayuscula(c[1]);
        x.destino = aMayuscula(c[2]);
        x.estado = aMinuscula(c[5]);
        if (!aDecimal(c[3], x.distanciaKm) || !aEntero(c[4], x.tiempoMin)) {
            avisarFilaOmitida("conexiones.csv", i + 1, "distancia o tiempo no numericos");
            continue;
        }
        string error = validarConexion(db, x);
        if (error != "") {
            avisarFilaOmitida("conexiones.csv", i + 1, error);
            continue;
        }
        db.conexiones.push_back(x);
    }
}

void cargarUnidades(BaseDatos& db) {
    vector<string> lineas;
    if (!leerLineas(rutaArchivo(db, "unidades.csv"), lineas)) {
        cout << "AVISO: no existe unidades.csv, se inicia sin unidades\n";
        return;
    }
    for (size_t i = 1; i < lineas.size(); i++) {
        if (recortar(lineas[i]).empty()) continue;
        vector<string> c = dividirCampos(lineas[i]);
        if (c.size() != 5) {
            avisarFilaOmitida("unidades.csv", i + 1, "se esperaban 5 campos");
            continue;
        }
        Unidad u;
        u.codigo = aMayuscula(c[0]);
        u.tipo = aMinuscula(c[1]);
        u.estado = aMinuscula(c[4]);
        if (!aEntero(c[2], u.capacidad) || !aDecimal(c[3], u.costoKm)) {
            avisarFilaOmitida("unidades.csv", i + 1, "capacidad o costo_km no numericos");
            continue;
        }
        string error = validarUnidad(db, u);
        if (error != "") {
            avisarFilaOmitida("unidades.csv", i + 1, error);
            continue;
        }
        db.unidades.push_back(u);
    }
}

void cargarSolicitudes(BaseDatos& db) {
    vector<string> lineas;
    if (!leerLineas(rutaArchivo(db, "solicitudes.csv"), lineas)) {
        cout << "AVISO: no existe solicitudes.csv, se inicia sin solicitudes\n";
        return;
    }
    for (size_t i = 1; i < lineas.size(); i++) {
        if (recortar(lineas[i]).empty()) continue;
        vector<string> c = dividirCampos(lineas[i]);
        if (c.size() != 7) {
            avisarFilaOmitida("solicitudes.csv", i + 1, "se esperaban 7 campos");
            continue;
        }
        Solicitud s;
        s.codigo = aMayuscula(c[0]);
        s.origen = aMayuscula(c[1]);
        s.destino = aMayuscula(c[2]);
        s.prioridad = aMinuscula(c[4]);
        s.estado = aMinuscula(c[5]);
        s.unidad = aMayuscula(c[6]);
        if (!aEntero(c[3], s.turistas)) {
            avisarFilaOmitida("solicitudes.csv", i + 1, "cantidad_turistas no numerica");
            continue;
        }
        string error = validarSolicitud(db, s);
        if (error != "") {
            avisarFilaOmitida("solicitudes.csv", i + 1, error);
            continue;
        }
        db.solicitudes.push_back(s);
    }
}

// 4.1.2 Carga inicial completa (puntos primero: el resto depende de ellos).
void cargarTodo(BaseDatos& db) {
    cargarPuntos(db);
    cargarConexiones(db);
    cargarUnidades(db);
    cargarSolicitudes(db);
    cout << "Datos cargados de " << db.carpeta << "/: " << db.puntos.size() << " puntos, "
         << db.conexiones.size() << " conexiones, " << db.unidades.size() << " unidades, "
         << db.solicitudes.size() << " solicitudes\n";
    if (!filesystem::is_directory(db.carpeta))
        cout << "AVISO: la carpeta " << db.carpeta << " no existe; los cambios no se podran guardar\n";
    if (filasOmitidas > 0)
        cout << "AVISO: " << filasOmitidas << " fila(s) omitida(s) se perderan en el proximo guardado\n";
}
