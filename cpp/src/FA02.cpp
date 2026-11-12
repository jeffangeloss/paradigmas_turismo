#include "FA02.h"

#include "ArchivosCSV.h"
#include "Solicitud.h"
#include "Tipos.h"
#include "Unidad.h"
#include "Visitante.h"

#include <cstdio>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

using namespace std;

namespace {

struct AlternativaFA02 {
  vector<string> ruta;
  TipoUnidad tipoTransporte;
  int cantidadVisitas;
  double costoTotal;
  int tiempoTotal;
};

class CotizacionFA02 {
private:
  string carpetaDatos;
  ArchivosCSV archivosCSV;

  string leerTexto(const string &mensaje) const {
    string respuesta;
    while (true) {
      cout << mensaje;
      if (!getline(cin, respuesta)) return "";
      if (respuesta.find(',') == string::npos) return respuesta;
      cout << "No uses comas.\n";
    }
  }

  bool leerDoublePositivo(const string &mensaje, double &numero) const {
    string texto = leerTexto(mensaje);
    stringstream lector(texto);
    char sobrante;
    if (!(lector >> numero) || numero <= 0 || lector >> sobrante) {
      cout << "Ingresa un numero mayor que cero.\n";
      return false;
    }
    return true;
  }

  bool leerEnteroPositivo(const string &mensaje, int &numero) const {
    string texto = leerTexto(mensaje);
    stringstream lector(texto);
    char sobrante;
    if (!(lector >> numero) || numero <= 0 || lector >> sobrante) {
      cout << "Ingresa un numero entero mayor que cero.\n";
      return false;
    }
    return true;
  }

  bool leerEnteroNoNegativo(const string &mensaje, int &numero) const {
    string texto = leerTexto(mensaje);
    stringstream lector(texto);
    char sobrante;
    if (!(lector >> numero) || numero < 0 || lector >> sobrante) {
      cout << "Ingresa un numero entero mayor o igual que cero.\n";
      return false;
    }
    return true;
  }

  vector<string> separarPor(const string &texto, char separador) const {
    vector<string> partes;
    string parte;
    for (int i = 0; i <= static_cast<int>(texto.size()); ++i) {
      if (i == static_cast<int>(texto.size()) || texto[i] == separador) {
        partes.push_back(parte);
        parte = "";
      } else {
        parte += texto[i];
      }
    }
    return partes;
  }

  bool parsearAlternativa(const string &linea,
                          AlternativaFA02 &alternativa) const {
    vector<string> campos = separarPor(linea, '|');
    if (campos.size() != 7 || campos[0] != "FA02_DATA") return false;

    stringstream lectorCantidad(campos[4]);
    stringstream lectorCosto(campos[5]);
    stringstream lectorTiempo(campos[6]);
    alternativa.ruta = separarPor(campos[2], '>');
    if (!archivosCSV.convertirTipoUnidad(campos[3],
                                         alternativa.tipoTransporte)) {
      return false;
    }
    lectorCantidad >> alternativa.cantidadVisitas;
    lectorCosto >> alternativa.costoTotal;
    lectorTiempo >> alternativa.tiempoTotal;

    return !alternativa.ruta.empty() && !lectorCantidad.fail()
           && !lectorCosto.fail() && !lectorTiempo.fail();
  }

  string comandoHaskell(int generales, int estudiantes, int ninos,
                        double presupuesto, int tiempoMaximo) const {
    stringstream comando;
    comando << fixed << setprecision(2);
    if (carpetaDatos == "_datos") {
      comando << "cabal run --project-dir=haskell turismo-haskell -- _datos";
    } else {
      comando << "cabal run --project-dir=../haskell turismo-haskell -- ../_datos";
    }
    comando << " --fa02 " << generales << " " << estudiantes << " " << ninos
            << " " << presupuesto << " " << tiempoMaximo << " 2>&1";
    return comando.str();
  }

  bool generarAlternativas(int generales, int estudiantes, int ninos,
                           double presupuesto, int tiempoMaximo,
                           vector<AlternativaFA02> &alternativas) const {
    string comando = comandoHaskell(generales, estudiantes, ninos, presupuesto,
                                    tiempoMaximo);
    FILE *proceso = _popen(comando.c_str(), "r");
    if (proceso == NULL) {
      cout << "[ERROR] No se pudo iniciar Haskell.\n";
      return false;
    }

    bool hayError = false;
    char buffer[512];
    while (fgets(buffer, sizeof(buffer), proceso) != NULL) {
      string linea(buffer);
      while (!linea.empty() && (linea.back() == '\n' || linea.back() == '\r')) {
        linea.pop_back();
      }

      if (linea.find("FA02_DATA|") == 0) {
        AlternativaFA02 alternativa;
        if (parsearAlternativa(linea, alternativa)) {
          alternativas.push_back(alternativa);
        } else {
          hayError = true;
          cout << "[ERROR] Haskell devolvio una alternativa invalida.\n";
        }
      } else if (linea.find("FA02_ERROR|") == 0) {
        hayError = true;
        cout << "[ERROR] " << linea.substr(12) << "\n";
      } else {
        cout << linea << "\n";
      }
    }

    int resultado = _pclose(proceso);
    if (resultado != 0) {
      cout << "[ERROR] Haskell no pudo completar FA02.\n";
      return false;
    }
    return !hayError;
  }

  string siguienteCodigoSolicitud(const vector<Solicitud> &solicitudes) const {
    int mayor = 0;
    for (int i = 0; i < static_cast<int>(solicitudes.size()); ++i) {
      string codigoActual = solicitudes[i].getCodigo();
      if (codigoActual.size() > 1 && codigoActual[0] == 'S') {
        stringstream lector(codigoActual.substr(1));
        int numero;
        char sobrante;
        if (lector >> numero && !(lector >> sobrante) && numero > mayor) {
          mayor = numero;
        }
      }
    }

    stringstream codigo;
    codigo << "S" << setw(3) << setfill('0') << mayor + 1;
    return codigo.str();
  }

  int buscarUnidadDisponible(const vector<Unidad> &unidades,
                             TipoUnidad tipoTransporte,
                             int cantidadPersonas) const {
    int posicion = -1;
    for (int i = 0; i < static_cast<int>(unidades.size()); ++i) {
      bool compatible = unidades[i].estaDisponible()
                        && unidades[i].getTipo() == tipoTransporte
                        && unidades[i].tieneCapacidad(cantidadPersonas);
      if (compatible
          && (posicion == -1
              || unidades[i].getCostoKm() < unidades[posicion].getCostoKm()
              || (unidades[i].getCostoKm()
                      == unidades[posicion].getCostoKm()
                  && unidades[i].getCodigo()
                         < unidades[posicion].getCodigo()))) {
        posicion = i;
      }
    }
    return posicion;
  }

  void agregarVisitantes(vector<Visitante> &visitantes,
                         const string &codigoSolicitud,
                         TipoVisitante tipoVisitante, int cantidad) const {
    for (int i = 0; i < cantidad; ++i) {
      visitantes.push_back(Visitante(codigoSolicitud, tipoVisitante));
    }
  }

  void registrarPlan(int generales, int estudiantes, int ninos,
                     const AlternativaFA02 &alternativa) {
    if (alternativa.ruta.size() < 2 || alternativa.ruta[0] != "P000") {
      cout << "[ERROR] Haskell devolvio una ruta invalida.\n";
      return;
    }

    int cantidadPersonas = generales + estudiantes + ninos;
    archivosCSV.actualizarDatos();
    vector<Unidad> unidades = archivosCSV.getUnidades();
    vector<Solicitud> solicitudes = archivosCSV.getSolicitudes();
    vector<Visitante> visitantes = archivosCSV.cargarVisitantes();
    if (!archivosCSV.archivoExiste("visitantes.csv")) {
      cout << "[ERROR] No se pudo leer visitantes.csv.\n";
      return;
    }

    int posicionUnidad = buscarUnidadDisponible(
        unidades, alternativa.tipoTransporte, cantidadPersonas);
    if (posicionUnidad == -1) {
      cout << "[ERROR] La unidad recomendada ya no esta disponible.\n"
           << "Vuelve a generar las alternativas.\n";
      return;
    }

    string codigoSolicitud = siguienteCodigoSolicitud(solicitudes);
    Solicitud solicitud(codigoSolicitud, "P000", alternativa.ruta.back(),
                        cantidadPersonas, Prioridad::Media,
                        EstadoSolicitud::Pendiente, "");
    solicitud.asignarUnidad(unidades[posicionUnidad].getCodigo());

    unidades[posicionUnidad].ocupar();
    solicitudes.push_back(solicitud);
    agregarVisitantes(visitantes, codigoSolicitud, TipoVisitante::General,
                      generales);
    agregarVisitantes(visitantes, codigoSolicitud, TipoVisitante::Estudiante,
                      estudiantes);
    agregarVisitantes(visitantes, codigoSolicitud, TipoVisitante::Nino, ninos);

    if (!archivosCSV.guardarPlanFA02(unidades, solicitudes, visitantes)) {
      cout << "[ERROR] No se pudieron actualizar los archivos CSV.\n";
      return;
    }

    cout << "[OK] Alternativa seleccionada.\n"
         << "[OK] Unidad " << unidades[posicionUnidad].getCodigo()
         << " asignada.\n"
         << "[OK] Solicitud " << codigoSolicitud << " creada.\n";
  }

public:
  explicit CotizacionFA02(const string &carpetaDatos)
      : archivosCSV(carpetaDatos) {
    this->carpetaDatos = carpetaDatos;
  }

  void ejecutar() {
    int generales;
    int estudiantes;
    int ninos;
    if (!leerEnteroNoNegativo("Visitantes generales: ", generales)) return;
    if (!leerEnteroNoNegativo("Visitantes estudiantes: ", estudiantes)) return;
    if (!leerEnteroNoNegativo("Visitantes ninos: ", ninos)) return;
    if (generales + estudiantes + ninos == 0) {
      cout << "El grupo debe tener al menos una persona.\n";
      return;
    }

    double presupuesto;
    int tiempoMaximo;
    if (!leerDoublePositivo("Presupuesto maximo: ", presupuesto)) return;
    if (!leerEnteroPositivo("Tiempo disponible en minutos: ", tiempoMaximo)) {
      return;
    }

    vector<AlternativaFA02> alternativas;
    if (!generarAlternativas(generales, estudiantes, ninos, presupuesto,
                             tiempoMaximo, alternativas)) {
      return;
    }
    if (alternativas.empty()) return;

    string textoOpcion = leerTexto(
        "Seleccione una alternativa (1-3) o 0 para cancelar: ");
    stringstream lectorOpcion(textoOpcion);
    int opcion;
    char sobrante;
    if (!(lectorOpcion >> opcion) || lectorOpcion >> sobrante) {
      cout << "Opcion invalida.\n";
      return;
    }
    if (opcion == 0) {
      cout << "Asignacion cancelada.\n";
      return;
    }
    if (opcion < 1 || opcion > static_cast<int>(alternativas.size())) {
      cout << "Opcion invalida.\n";
      return;
    }

    registrarPlan(generales, estudiantes, ninos, alternativas[opcion - 1]);
  }
};

} // namespace

void ejecutarFA02(const string &carpetaDatos) {
  CotizacionFA02 cotizacion(carpetaDatos);
  cotizacion.ejecutar();
}
