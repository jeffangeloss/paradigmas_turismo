// Grupo 4 - Ruta turistica en Lima. Modulo C++ (paradigma imperativo).
// Utilidades de texto, busquedas y entrada por consola que usan todos los archivos.
// Archivo compartido: se cambia solo con acuerdo del grupo (ver BACKLOG.md).
#include "utilidades.hpp"

// ------------------------------------------------------- Utilidades de texto

string recortar(const string& s) {
    size_t ini = 0;
    size_t fin = s.size();
    while (ini < fin && isspace((unsigned char)s[ini])) ini++;
    while (fin > ini && isspace((unsigned char)s[fin - 1])) fin--;
    return s.substr(ini, fin - ini);
}

string aMayuscula(string s) {
    for (size_t i = 0; i < s.size(); i++) s[i] = toupper((unsigned char)s[i]);
    return s;
}

string aMinuscula(string s) {
    for (size_t i = 0; i < s.size(); i++) s[i] = tolower((unsigned char)s[i]);
    return s;
}

// Separa una linea CSV por comas y recorta cada campo (tolera \r y espacios).
vector<string> dividirCampos(const string& linea) {
    vector<string> campos;
    string actual;
    for (size_t i = 0; i < linea.size(); i++) {
        if (linea[i] == ',') {
            campos.push_back(recortar(actual));
            actual = "";
        } else {
            actual += linea[i];
        }
    }
    campos.push_back(recortar(actual));
    return campos;
}

// Solo digitos, punto y signo: asi strtol/strtod no aceptan "inf", "nan" ni "0x1A".
bool soloNumerico(const string& s) {
    if (s.empty()) return false;
    for (size_t i = 0; i < s.size(); i++) {
        if (!isdigit((unsigned char)s[i]) && s[i] != '.' && s[i] != '-' && s[i] != '+') return false;
    }
    return true;
}

bool aEntero(const string& s, int& valor) {
    if (!soloNumerico(s)) return false;
    char* fin;  // strtol deja aqui donde dejo de leer; si no es el final ('\0'), sobraba texto ("3.5")
    long n = strtol(s.c_str(), &fin, 10);
    if (*fin != '\0' || n > INT_MAX || n < INT_MIN) return false;  // evita desborde de int
    valor = (int)n;
    return true;
}

// Se redondea a 2 decimales, como se guarda en el CSV: asi 0.004 queda en 0.00
// y la validacion "> 0" lo rechaza en vez de escribir un valor nulo.
bool aDecimal(const string& s, double& valor) {
    if (!soloNumerico(s)) return false;
    char* fin;
    double n = strtod(s.c_str(), &fin);
    if (*fin != '\0') return false;
    valor = round(n * 100) / 100;
    return true;
}

bool textoValido(const string& s) {
    return !s.empty() && s.find(',') == string::npos;
}

bool estaEn(const string& valor, const vector<string>& opciones) {
    for (size_t i = 0; i < opciones.size(); i++) {
        if (opciones[i] == valor) return true;
    }
    return false;
}

// ---------------------------------------------------------------- Busquedas

int buscarPunto(const BaseDatos& db, const string& codigo) {
    for (size_t i = 0; i < db.puntos.size(); i++) {
        if (db.puntos[i].codigo == codigo) return (int)i;
    }
    return -1;
}

// Una conexion es de doble sentido: se busca en ambos sentidos.
int buscarConexion(const BaseDatos& db, const string& a, const string& b) {
    for (size_t i = 0; i < db.conexiones.size(); i++) {
        const Conexion& c = db.conexiones[i];
        if ((c.origen == a && c.destino == b) || (c.origen == b && c.destino == a)) return (int)i;
    }
    return -1;
}

int buscarConexionPorCodigo(const BaseDatos& db, const string& codigo) {
    for (size_t i = 0; i < db.conexiones.size(); i++) {
        if (db.conexiones[i].codigo == codigo) return (int)i;
    }
    return -1;
}

int buscarUnidad(const BaseDatos& db, const string& codigo) {
    for (size_t i = 0; i < db.unidades.size(); i++) {
        if (db.unidades[i].codigo == codigo) return (int)i;
    }
    return -1;
}

int buscarSolicitud(const BaseDatos& db, const string& codigo) {
    for (size_t i = 0; i < db.solicitudes.size(); i++) {
        if (db.solicitudes[i].codigo == codigo) return (int)i;
    }
    return -1;
}

// ------------------------------------------------------------ Entrada robusta

// Lee una linea; con EOF termina el programa (los datos ya estan guardados).
string leerLinea(const string& mensaje) {
    cout << mensaje;
    string linea;
    if (!getline(cin, linea)) {
        cout << "\nFin de la entrada. Hasta luego.\n";
        exit(0);
    }
    return recortar(linea);
}

int leerEntero(const string& mensaje) {
    while (true) {
        int valor;
        if (aEntero(leerLinea(mensaje), valor)) return valor;
        cout << "Numero invalido, intente de nuevo.\n";
    }
}

double leerDecimal(const string& mensaje) {
    while (true) {
        double valor;
        if (aDecimal(leerLinea(mensaje), valor)) return valor;
        cout << "Numero invalido, intente de nuevo.\n";
    }
}
