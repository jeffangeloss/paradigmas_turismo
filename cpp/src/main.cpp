#include <cctype>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

using namespace std;

struct Punto {
  string codigo;
  string nombre;
  string tipo;
  string zona;
};

struct Conexion {
  string codigo;
  string origen;
  string destino;
  double distancia;
  int tiempo;
  string estado;
};

struct Unidad {
  string codigo;
  string tipo;
  int capacidad;
  double costoKm;
  string estado;
};

struct Solicitud {
  string codigo;
  string origen;
  string destino;
  int cantidadTuristas;
  string prioridad;
  string estado;
  string unidadAsignada;
};

class SistemaTurismo {
public:
  explicit SistemaTurismo(const string &carpetaDatos)
      : carpetaDatos(carpetaDatos) {}

  void ejecutar() {
    string opcion;
    do {
      cout << "\n=== Sistema de turismo ===\n"
           << "1. Registrar informacion base\n"
           << "2. Gestionar estados\n"
           << "3. Consultas basicas\n"
           << "4. Reporte general\n"
           << "5. Abrir modulo Haskell\n"
           << "6. Abrir modulo Prolog\n"
           << "7. Registrar datos para FA01\n"
           << "0. Salir\n"
           << "Opcion: ";
      getline(cin, opcion);

      if (opcion == "1") {
        cout << "La gestion de informacion base corresponde a su modulo.\n";
      } else if (opcion == "2") {
        cout << "La gestion de estados corresponde a su modulo.\n";
      } else if (opcion == "3") {
        menuConsultas();
      } else if (opcion == "4") {
        mostrarReporteGeneral();
      } else if (opcion == "5") {
        abrirHaskell();
      } else if (opcion == "6") {
        abrirProlog();
      } else if (opcion == "7") {
        menuFA01();
      } else if (opcion == "0") {
        cout << "Programa finalizado.\n";
      } else {
        cout << "Opcion invalida.\n";
      }
    } while (opcion != "0");
  }

private:
  string carpetaDatos;

  string rutaArchivo(const string &nombre) const {
    return carpetaDatos + "/" + nombre;
  }

  string leerTexto(const string &mensaje) const {
    string respuesta;
    cout << mensaje;
    getline(cin, respuesta);
    return respuesta;
  }

  vector<string> separarCampos(const string &linea) const {
    vector<string> campos;
    string campo;
    for (int i = 0; i < static_cast<int>(linea.size()); ++i) {
      if (linea[i] == ',') {
        campos.push_back(campo);
        campo = "";
      } else if (linea[i] != '\r') {
        campo += linea[i];
      }
    }
    campos.push_back(campo);
    return campos;
  }

  bool leerFilas(const string &nombre, vector<string> &filas) const {
    ifstream archivo(rutaArchivo(nombre).c_str());
    if (!archivo) return false;

    string linea;
    getline(archivo, linea); // Saltar encabezado
    while (getline(archivo, linea)) {
      if (linea != "") filas.push_back(linea);
    }
    return true;
  }

  vector<Punto> cargarPuntos() const {
    vector<Punto> puntos;
    vector<string> filas;
    if (!leerFilas("puntos.csv", filas)) return puntos;

    for (int i = 0; i < static_cast<int>(filas.size()); ++i) {
      vector<string> campos = separarCampos(filas[i]);
      if (campos.size() >= 4) {
        Punto punto;
        punto.codigo = campos[0];
        punto.nombre = campos[1];
        punto.tipo = campos[2];
        punto.zona = campos[3];
        puntos.push_back(punto);
      }
    }
    return puntos;
  }

  vector<Conexion> cargarConexiones() const {
    vector<Conexion> conexiones;
    vector<string> filas;
    if (!leerFilas("conexiones.csv", filas)) return conexiones;

    for (int i = 0; i < static_cast<int>(filas.size()); ++i) {
      vector<string> campos = separarCampos(filas[i]);
      if (campos.size() >= 6) {
        Conexion conexion;
        conexion.codigo = campos[0];
        conexion.origen = campos[1];
        conexion.destino = campos[2];
        stringstream lectorDistancia(campos[3]);
        stringstream lectorTiempo(campos[4]);
        lectorDistancia >> conexion.distancia;
        lectorTiempo >> conexion.tiempo;
        conexion.estado = campos[5];
        conexiones.push_back(conexion);
      }
    }
    return conexiones;
  }

  vector<Unidad> cargarUnidades() const {
    vector<Unidad> unidades;
    vector<string> filas;
    if (!leerFilas("unidades.csv", filas)) return unidades;

    for (int i = 0; i < static_cast<int>(filas.size()); ++i) {
      vector<string> campos = separarCampos(filas[i]);
      if (campos.size() >= 5) {
        Unidad unidad;
        unidad.codigo = campos[0];
        unidad.tipo = campos[1];
        stringstream lectorCapacidad(campos[2]);
        stringstream lectorCosto(campos[3]);
        lectorCapacidad >> unidad.capacidad;
        lectorCosto >> unidad.costoKm;
        unidad.estado = campos[4];
        unidades.push_back(unidad);
      }
    }
    return unidades;
  }

  vector<Solicitud> cargarSolicitudes() const {
    vector<Solicitud> solicitudes;
    vector<string> filas;
    if (!leerFilas("solicitudes.csv", filas)) return solicitudes;

    for (int i = 0; i < static_cast<int>(filas.size()); ++i) {
      vector<string> campos = separarCampos(filas[i]);
      if (campos.size() >= 7) {
        Solicitud solicitud;
        solicitud.codigo = campos[0];
        solicitud.origen = campos[1];
        solicitud.destino = campos[2];
        stringstream lectorCantidad(campos[3]);
        lectorCantidad >> solicitud.cantidadTuristas;
        solicitud.prioridad = campos[4];
        solicitud.estado = campos[5];
        solicitud.unidadAsignada = campos[6];
        solicitudes.push_back(solicitud);
      }
    }
    return solicitudes;
  }

  void menuConsultas() const {
    cout << "\n=== Consultas basicas ===\n"
         << "1. Punto\n2. Conexion\n3. Unidad\n4. Solicitud\n0. Volver\n";
    string opcion = leerTexto("Opcion: ");
    if (opcion == "1") consultarPunto();
    else if (opcion == "2") consultarConexion();
    else if (opcion == "3") consultarUnidad();
    else if (opcion == "4") consultarSolicitud();
    else if (opcion != "0") cout << "Opcion invalida.\n";
  }

  void consultarPunto() const {
    vector<Punto> puntos = cargarPuntos();
    string codigo = mayusculas(leerTexto("Codigo del punto: "));
    bool encontrado = false;
    for (int i = 0; i < static_cast<int>(puntos.size()); ++i) {
      if (puntos[i].codigo == codigo) {
        cout << puntos[i].codigo << " | " << puntos[i].nombre << " | "
             << puntos[i].tipo << " | " << puntos[i].zona << "\n";
        encontrado = true;
      }
    }
    mostrarNoEncontrado(encontrado, "punto", codigo);
  }

  void consultarConexion() const {
    vector<Conexion> conexiones = cargarConexiones();
    string codigo = mayusculas(leerTexto("Codigo de la conexion: "));
    bool encontrado = false;
    for (int i = 0; i < static_cast<int>(conexiones.size()); ++i) {
      if (conexiones[i].codigo == codigo) {
        cout << conexiones[i].codigo << " | " << conexiones[i].origen << " -> "
             << conexiones[i].destino << " | " << conexiones[i].distancia
             << " km | " << conexiones[i].tiempo << " min | "
             << conexiones[i].estado << "\n";
        encontrado = true;
      }
    }
    mostrarNoEncontrado(encontrado, "conexion", codigo);
  }

  void consultarUnidad() const {
    vector<Unidad> unidades = cargarUnidades();
    string codigo = mayusculas(leerTexto("Codigo de la unidad: "));
    bool encontrado = false;
    for (int i = 0; i < static_cast<int>(unidades.size()); ++i) {
      if (unidades[i].codigo == codigo) {
        cout << unidades[i].codigo << " | " << unidades[i].tipo << " | "
             << unidades[i].capacidad << " turistas | costo/km: "
             << unidades[i].costoKm << " | " << unidades[i].estado << "\n";
        encontrado = true;
      }
    }
    mostrarNoEncontrado(encontrado, "unidad", codigo);
  }

  void consultarSolicitud() const {
    vector<Solicitud> solicitudes = cargarSolicitudes();
    string codigo = mayusculas(leerTexto("Codigo de la solicitud: "));
    bool encontrado = false;
    for (int i = 0; i < static_cast<int>(solicitudes.size()); ++i) {
      if (solicitudes[i].codigo == codigo) {
        mostrarSolicitud(solicitudes[i]);
        encontrado = true;
      }
    }
    mostrarNoEncontrado(encontrado, "solicitud", codigo);
  }

  void mostrarNoEncontrado(bool encontrado, const string &tipo,
                           const string &codigo) const {
    if (!encontrado) cout << "No se encontro " << tipo << " " << codigo << ".\n";
  }

  void mostrarSolicitud(const Solicitud &solicitud) const {
    cout << solicitud.codigo << " | " << solicitud.origen << " -> "
         << solicitud.destino << " | " << solicitud.cantidadTuristas
         << " turistas | prioridad " << solicitud.prioridad << " | estado "
         << solicitud.estado << " | unidad "
         << (solicitud.unidadAsignada == "" ? "sin asignar" : solicitud.unidadAsignada)
         << "\n";
  }

  void mostrarReporteGeneral() const {
    vector<Punto> puntos = cargarPuntos();
    vector<Conexion> conexiones = cargarConexiones();
    vector<Unidad> unidades = cargarUnidades();
    vector<Solicitud> solicitudes = cargarSolicitudes();
    int habilitadas = 0;
    int cerradas = 0;
    int disponibles = 0;
    int ocupadas = 0;
    int pendientes = 0;
    int asignadas = 0;
    int entregadas = 0;

    for (int i = 0; i < static_cast<int>(conexiones.size()); ++i) {
      if (conexiones[i].estado == "habilitada") habilitadas++;
      if (conexiones[i].estado == "cerrada") cerradas++;
    }
    for (int i = 0; i < static_cast<int>(unidades.size()); ++i) {
      if (unidades[i].estado == "disponible") disponibles++;
      if (unidades[i].estado == "ocupada") ocupadas++;
    }
    for (int i = 0; i < static_cast<int>(solicitudes.size()); ++i) {
      if (solicitudes[i].estado == "pendiente") pendientes++;
      if (solicitudes[i].estado == "asignada") asignadas++;
      if (solicitudes[i].estado == "entregada") entregadas++;
    }

    cout << "\n=== Reporte general ===\n"
         << "Puntos: " << puntos.size() << "\n"
         << "Conexiones: " << conexiones.size() << " (habilitadas: "
         << habilitadas << ", cerradas: " << cerradas << ")\n"
         << "Unidades: " << unidades.size() << " (disponibles: "
         << disponibles << ", ocupadas: " << ocupadas << ")\n"
         << "Solicitudes: " << solicitudes.size() << " (pendientes: "
         << pendientes << ", asignadas: " << asignadas << ", entregadas: "
         << entregadas << ")\n";
  }

  void menuFA01() {
    cout << "\n=== Datos para el recomendador FA01 ===\n"
         << "1. Registrar perfil e intereses\n"
         << "2. Registrar caracteristicas y categorias de un punto\n"
         << "3. Registrar accesibilidad de una conexion\n"
         << "0. Volver\n";
    string opcion = leerTexto("Opcion: ");
    if (opcion == "1") registrarPerfil();
    else if (opcion == "2") registrarCaracteristicasPunto();
    else if (opcion == "3") registrarAccesibilidadConexion();
    else if (opcion != "0") cout << "Opcion invalida.\n";
  }

  void registrarPerfil() {
    string codigo = mayusculas(leerTexto("Codigo del perfil: "));
    if (existeCodigo("perfiles_turista.csv", codigo)) {
      cout << "Ese perfil ya existe.\n";
      return;
    }
    string movilidad = leerSiNo("Movilidad reducida");
    string ninos = leerSiNo("Viaja con ninos");
    string hora = leerTexto("Hora de visita (HH:MM): ");
    if (codigo == "" || !horaValida(hora)) {
      cout << "El codigo y una hora valida son obligatorios.\n";
      return;
    }
    string fila = codigo + "," + movilidad + "," + ninos + "," + hora;
    if (guardarFila("perfiles_turista.csv",
                    "codigo,movilidad_reducida,viaja_con_ninos,hora_visita",
                    codigo, fila)) {
      string intereses = leerTexto("Intereses separados por punto y coma: ");
      vector<string> lista = separarLista(intereses);
      reemplazarRelaciones("intereses_turista.csv", "codigo,interes", codigo,
                           lista);
      cout << "Perfil e intereses guardados.\n";
    } else {
      cout << "No se pudo guardar el perfil.\n";
    }
  }

  void registrarCaracteristicasPunto() {
    string codigo = mayusculas(leerTexto("Codigo de un punto existente: "));
    if (!existeCodigo("puntos.csv", codigo)) {
      cout << "No existe ese punto.\n";
      return;
    }
    string movilidad = leerSiNo("Accesible para movilidad reducida");
    string ninos = leerSiNo("Adecuado para ninos");
    string seguroDia = leerSiNo("Seguro durante el dia");
    string seguroNoche = leerSiNo("Seguro durante la noche");
    string inicio = leerTexto("Hora de apertura (HH:MM): ");
    string fin = leerTexto("Hora de cierre (HH:MM): ");
    if (!horaValida(inicio) || !horaValida(fin)) {
      cout << "Ingresa horarios validos en formato HH:MM.\n";
      return;
    }
    string fila = codigo + "," + movilidad + "," + ninos + "," + seguroDia + "," +
                  seguroNoche + "," + inicio + "," + fin;
    if (!guardarFila("caracteristicas_puntos.csv",
                     "codigo,accesible_movilidad,apto_ninos,seguro_dia,seguro_noche,horario_inicio,horario_fin",
                     codigo, fila)) {
      cout << "No se pudieron guardar las caracteristicas.\n";
      return;
    }
    string categorias = leerTexto("Categorias separadas por punto y coma: ");
    vector<string> lista = separarLista(categorias);
    reemplazarRelaciones("categorias_puntos.csv", "codigo,categoria", codigo,
                         lista);
    cout << "Caracteristicas y categorias guardadas.\n";
  }

  void registrarAccesibilidadConexion() {
    string codigo = mayusculas(leerTexto("Codigo de una conexion existente: "));
    if (!existeCodigo("conexiones.csv", codigo)) {
      cout << "No existe esa conexion.\n";
      return;
    }
    string accesible = leerSiNo("Accesible para movilidad reducida");
    string fila = codigo + "," + accesible;
    if (guardarFila("accesibilidad_conexiones.csv",
                    "codigo,accesible_movilidad", codigo, fila)) {
      cout << "Accesibilidad de la conexion guardada.\n";
    } else {
      cout << "No se pudo guardar la accesibilidad.\n";
    }
  }

  bool guardarFila(const string &nombre, const string &encabezado,
                   const string &codigo, const string &nuevaFila) const {
    vector<string> filas;
    leerFilas(nombre, filas);
    bool actualizada = false;
    for (int i = 0; i < static_cast<int>(filas.size()); ++i) {
      vector<string> campos = separarCampos(filas[i]);
      if (campos.size() > 0 && campos[0] == codigo) {
        filas[i] = nuevaFila;
        actualizada = true;
      }
    }
    if (!actualizada) filas.push_back(nuevaFila);

    ofstream archivo(rutaArchivo(nombre).c_str());
    if (!archivo) return false;
    archivo << encabezado << "\n";
    for (int i = 0; i < static_cast<int>(filas.size()); ++i) {
      archivo << filas[i] << "\n";
    }
    return true;
  }

  void reemplazarRelaciones(const string &nombre, const string &encabezado,
                            const string &codigo,
                            const vector<string> &valores) const {
    vector<string> filas;
    leerFilas(nombre, filas);
    vector<string> nuevasFilas;
    for (int i = 0; i < static_cast<int>(filas.size()); ++i) {
      vector<string> campos = separarCampos(filas[i]);
      if (campos.size() > 0 && campos[0] != codigo) {
        nuevasFilas.push_back(filas[i]);
      }
    }
    for (int i = 0; i < static_cast<int>(valores.size()); ++i) {
      nuevasFilas.push_back(codigo + "," + valores[i]);
    }

    ofstream archivo(rutaArchivo(nombre).c_str());
    if (!archivo) return;
    archivo << encabezado << "\n";
    for (int i = 0; i < static_cast<int>(nuevasFilas.size()); ++i) {
      archivo << nuevasFilas[i] << "\n";
    }
  }

  vector<string> separarLista(const string &texto) const {
    vector<string> valores;
    string valor;
    for (int i = 0; i <= static_cast<int>(texto.size()); ++i) {
      if (i == static_cast<int>(texto.size()) || texto[i] == ';') {
        string limpio = limpiarEspacios(valor);
        if (limpio != "") valores.push_back(minusculas(limpio));
        valor = "";
      } else {
        valor += texto[i];
      }
    }
    return valores;
  }

  string limpiarEspacios(const string &texto) const {
    int inicio = 0;
    int fin = static_cast<int>(texto.size()) - 1;
    while (inicio <= fin && (texto[inicio] == ' ' || texto[inicio] == '\t')) inicio++;
    while (fin >= inicio && (texto[fin] == ' ' || texto[fin] == '\t')) fin--;
    string resultado;
    for (int i = inicio; i <= fin; ++i) resultado += texto[i];
    return resultado;
  }

  bool existeCodigo(const string &archivo, const string &codigo) const {
    vector<string> filas;
    if (!leerFilas(archivo, filas)) return false;
    for (int i = 0; i < static_cast<int>(filas.size()); ++i) {
      vector<string> campos = separarCampos(filas[i]);
      if (campos.size() > 0 && campos[0] == codigo) return true;
    }
    return false;
  }

  string leerSiNo(const string &pregunta) const {
    while (true) {
      string respuesta = minusculas(leerTexto(pregunta + " (si/no): "));
      if (respuesta == "si" || respuesta == "no") return respuesta;
      cout << "Escribe si o no.\n";
    }
  }

  bool horaValida(const string &hora) const {
    if (hora.size() != 5 || hora[2] != ':') return false;
    for (int i = 0; i < 5; ++i) {
      if (i != 2 && !isdigit(static_cast<unsigned char>(hora[i]))) return false;
    }
    int horas = (hora[0] - '0') * 10 + (hora[1] - '0');
    int minutos = (hora[3] - '0') * 10 + (hora[4] - '0');
    return horas < 24 && minutos < 60;
  }

  string minusculas(const string &texto) const {
    string resultado = texto;
    for (int i = 0; i < static_cast<int>(resultado.size()); ++i) {
      resultado[i] = static_cast<char>(tolower(static_cast<unsigned char>(resultado[i])));
    }
    return resultado;
  }

  string mayusculas(const string &texto) const {
    string resultado = texto;
    for (int i = 0; i < static_cast<int>(resultado.size()); ++i) {
      resultado[i] = static_cast<char>(toupper(static_cast<unsigned char>(resultado[i])));
    }
    return resultado;
  }

  void abrirHaskell() const {
    string comando;
    if (carpetaDatos == "_datos") {
      comando = "cabal run --project-dir=haskell turismo-haskell -- _datos";
    } else {
      comando = "cabal run --project-dir=../haskell turismo-haskell -- ../_datos";
    }
    int resultado = system(comando.c_str());
    if (resultado != 0) cout << "No se pudo iniciar Haskell. Revisa Cabal y la ruta.\n";
  }

  void abrirProlog() const {
    string comando;
    if (carpetaDatos == "_datos") {
      comando = "swipl prolog/app/main.pl -- _datos";
    } else {
      comando = "swipl ../prolog/app/main.pl -- ../_datos";
    }
    int resultado = system(comando.c_str());
    if (resultado != 0) cout << "No se pudo iniciar Prolog. Revisa SWI-Prolog y la ruta.\n";
  }
};

// 4.1.2 Carga inicial. Responsable: Jefferson Sanchez.
std::vector<Punto> cargaInicialPuntos(const std::string &carpetaDatos) {
    std::ifstream archivo(carpetaDatos + "/puntos.csv");

    if(!archivo){
        std::cerr << "No se pudo abrir " << carpetaDatos << "/puntos.csv\n";
        return {};
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

    return puntos;
}

int main() {
  string carpetaDatos = "_datos";
  ifstream datos((carpetaDatos + "/puntos.csv").c_str());
  if (!datos) carpetaDatos = "../_datos";

  std::vector<Punto> puntos = cargaInicialPuntos(carpetaDatos);
  std::cout << "Puntos cargados: " << puntos.size() << '\n';

  SistemaTurismo sistema(carpetaDatos);
  sistema.ejecutar();
  return 0;
}
