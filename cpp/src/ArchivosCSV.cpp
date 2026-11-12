#include "ArchivosCSV.h"

#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>

using namespace std;

ArchivosCSV::ArchivosCSV(string carpetaDatos) {
  this->carpetaDatos = carpetaDatos;
}

// 4.1.2 Carga inicial. Responsable: Jefferson Sanchez.
void ArchivosCSV::cargarDatosIniciales() {
  const vector<string> archivos = {"puntos.csv", "conexiones.csv",
                                   "unidades.csv", "solicitudes.csv"};
  for (int i = 0; i < static_cast<int>(archivos.size()); ++i) {
    ifstream archivo(rutaArchivo(archivos[i]).c_str());
    if (!archivo) cerr << "No se pudo abrir " << rutaArchivo(archivos[i]) << "\n";
  }

  puntos = cargarPuntos();
  conexiones = cargarConexiones();
  unidades = cargarUnidades();
  solicitudes = cargarSolicitudes();

  cout << "Puntos cargados: " << puntos.size() << '\n'
       << "Conexiones cargadas: " << conexiones.size() << '\n'
       << "Unidades cargadas: " << unidades.size() << '\n'
       << "Solicitudes cargadas: " << solicitudes.size() << '\n';
}

void ArchivosCSV::actualizarDatos() {
  puntos = cargarPuntos();
  conexiones = cargarConexiones();
  unidades = cargarUnidades();
  solicitudes = cargarSolicitudes();
}

string ArchivosCSV::rutaArchivo(const string &nombre) const {
  return carpetaDatos + "/" + nombre;
}

vector<string> ArchivosCSV::separarCampos(const string &linea) const {
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

bool ArchivosCSV::leerFilas(const string &nombre, vector<string> &filas) const {
  ifstream archivo(rutaArchivo(nombre).c_str());
  if (!archivo) return false;

  string linea;
  getline(archivo, linea); // Saltar encabezado
  while (getline(archivo, linea)) {
    if (linea != "") filas.push_back(linea);
  }
  return true;
}

void ArchivosCSV::mostrarFilaInvalida(const string &archivo,
                                      int numeroFila) const {
  cout << "[ERROR] Fila " << numeroFila << " invalida en " << archivo
       << ".\n";
}

bool ArchivosCSV::convertirTipoPunto(const string &texto,
                                     TipoPunto &tipo) const {
  if (texto == "agencia") tipo = TipoPunto::Agencia;
  else if (texto == "hotel") tipo = TipoPunto::Hotel;
  else if (texto == "atractivo") tipo = TipoPunto::Atractivo;
  else if (texto == "mirador") tipo = TipoPunto::Mirador;
  else if (texto == "espacio_publico") tipo = TipoPunto::EspacioPublico;
  else return false;
  return true;
}

bool ArchivosCSV::convertirTipoUnidad(const string &texto,
                                      TipoUnidad &tipo) const {
  if (texto == "guia_peatonal") tipo = TipoUnidad::GuiaPeatonal;
  else if (texto == "taxi_turistico") tipo = TipoUnidad::TaxiTuristico;
  else if (texto == "bus_turistico") tipo = TipoUnidad::BusTuristico;
  else return false;
  return true;
}

bool ArchivosCSV::convertirTipoVisitante(const string &texto,
                                         TipoVisitante &tipo) const {
  if (texto == "general") tipo = TipoVisitante::General;
  else if (texto == "estudiante") tipo = TipoVisitante::Estudiante;
  else if (texto == "nino") tipo = TipoVisitante::Nino;
  else return false;
  return true;
}

bool ArchivosCSV::convertirEstadoConexion(const string &texto,
                                          EstadoConexion &estado) const {
  if (texto == "habilitada") estado = EstadoConexion::Habilitada;
  else if (texto == "cerrada") estado = EstadoConexion::Cerrada;
  else return false;
  return true;
}

bool ArchivosCSV::convertirEstadoUnidad(const string &texto,
                                        EstadoUnidad &estado) const {
  if (texto == "disponible") estado = EstadoUnidad::Disponible;
  else if (texto == "ocupada") estado = EstadoUnidad::Ocupada;
  else return false;
  return true;
}

bool ArchivosCSV::convertirPrioridad(const string &texto,
                                     Prioridad &prioridad) const {
  if (texto == "baja") prioridad = Prioridad::Baja;
  else if (texto == "media") prioridad = Prioridad::Media;
  else if (texto == "alta") prioridad = Prioridad::Alta;
  else return false;
  return true;
}

bool ArchivosCSV::convertirEstadoSolicitud(const string &texto,
                                           EstadoSolicitud &estado) const {
  if (texto == "pendiente") estado = EstadoSolicitud::Pendiente;
  else if (texto == "asignada") estado = EstadoSolicitud::Asignada;
  else if (texto == "entregada") estado = EstadoSolicitud::Entregada;
  else return false;
  return true;
}

vector<Punto> ArchivosCSV::cargarPuntos() const {
  vector<Punto> puntosCargados;
  vector<string> filas;
  if (!leerFilas("puntos.csv", filas)) return puntosCargados;

  for (int i = 0; i < static_cast<int>(filas.size()); ++i) {
    vector<string> campos = separarCampos(filas[i]);
    TipoPunto tipo;
    if (campos.size() == 4 && convertirTipoPunto(campos[2], tipo)) {
      puntosCargados.push_back(Punto(campos[0], campos[1], tipo, campos[3]));
    } else {
      mostrarFilaInvalida("puntos.csv", i + 2);
    }
  }
  return puntosCargados;
}

vector<Conexion> ArchivosCSV::cargarConexiones() const {
  vector<Conexion> conexionesCargadas;
  vector<string> filas;
  if (!leerFilas("conexiones.csv", filas)) return conexionesCargadas;

  for (int i = 0; i < static_cast<int>(filas.size()); ++i) {
    vector<string> campos = separarCampos(filas[i]);
    if (campos.size() == 6) {
      double distancia;
      int tiempo;
      EstadoConexion estado;
      stringstream lectorDistancia(campos[3]);
      stringstream lectorTiempo(campos[4]);
      char sobranteDistancia;
      char sobranteTiempo;
      bool datosValidos = lectorDistancia >> distancia
                          && !(lectorDistancia >> sobranteDistancia)
                          && lectorTiempo >> tiempo
                          && !(lectorTiempo >> sobranteTiempo)
                          && distancia >= 0 && tiempo >= 0
                          && convertirEstadoConexion(campos[5], estado);
      if (datosValidos) {
        conexionesCargadas.push_back(Conexion(
            campos[0], campos[1], campos[2], distancia, tiempo, estado));
      } else {
        mostrarFilaInvalida("conexiones.csv", i + 2);
      }
    } else {
      mostrarFilaInvalida("conexiones.csv", i + 2);
    }
  }
  return conexionesCargadas;
}

vector<Unidad> ArchivosCSV::cargarUnidades() const {
  vector<Unidad> unidadesCargadas;
  vector<string> filas;
  if (!leerFilas("unidades.csv", filas)) return unidadesCargadas;

  for (int i = 0; i < static_cast<int>(filas.size()); ++i) {
    vector<string> campos = separarCampos(filas[i]);
    if (campos.size() == 5) {
      TipoUnidad tipo;
      int capacidad;
      double costoKm;
      EstadoUnidad estado;
      stringstream lectorCapacidad(campos[2]);
      stringstream lectorCosto(campos[3]);
      char sobranteCapacidad;
      char sobranteCosto;
      bool datosValidos = convertirTipoUnidad(campos[1], tipo)
                          && lectorCapacidad >> capacidad
                          && !(lectorCapacidad >> sobranteCapacidad)
                          && lectorCosto >> costoKm
                          && !(lectorCosto >> sobranteCosto)
                          && capacidad > 0 && costoKm >= 0
                          && convertirEstadoUnidad(campos[4], estado);
      if (datosValidos) {
        unidadesCargadas.push_back(
            Unidad(campos[0], tipo, capacidad, costoKm, estado));
      } else {
        mostrarFilaInvalida("unidades.csv", i + 2);
      }
    } else {
      mostrarFilaInvalida("unidades.csv", i + 2);
    }
  }
  return unidadesCargadas;
}

vector<Solicitud> ArchivosCSV::cargarSolicitudes() const {
  vector<Solicitud> solicitudesCargadas;
  vector<string> filas;
  if (!leerFilas("solicitudes.csv", filas)) return solicitudesCargadas;

  for (int i = 0; i < static_cast<int>(filas.size()); ++i) {
    vector<string> campos = separarCampos(filas[i]);
    if (campos.size() == 7) {
      int cantidadTuristas;
      Prioridad prioridad;
      EstadoSolicitud estado;
      stringstream lectorCantidad(campos[3]);
      char sobrante;
      bool datosValidos = lectorCantidad >> cantidadTuristas
                          && !(lectorCantidad >> sobrante)
                          && cantidadTuristas > 0
                          && convertirPrioridad(campos[4], prioridad)
                          && convertirEstadoSolicitud(campos[5], estado);
      if (datosValidos) {
        solicitudesCargadas.push_back(Solicitud(
            campos[0], campos[1], campos[2], cantidadTuristas, prioridad,
            estado, campos[6]));
      } else {
        mostrarFilaInvalida("solicitudes.csv", i + 2);
      }
    } else {
      mostrarFilaInvalida("solicitudes.csv", i + 2);
    }
  }
  return solicitudesCargadas;
}

vector<Visitante> ArchivosCSV::cargarVisitantes() const {
  vector<Visitante> visitantes;
  vector<string> filas;
  if (!leerFilas("visitantes.csv", filas)) return visitantes;

  for (int i = 0; i < static_cast<int>(filas.size()); ++i) {
    vector<string> campos = separarCampos(filas[i]);
    TipoVisitante tipo;
    if (campos.size() == 2 && convertirTipoVisitante(campos[1], tipo)) {
      visitantes.push_back(Visitante(campos[0], tipo));
    } else {
      mostrarFilaInvalida("visitantes.csv", i + 2);
    }
  }
  return visitantes;
}

vector<Punto> ArchivosCSV::getPuntos() const { return puntos; }

vector<Conexion> ArchivosCSV::getConexiones() const { return conexiones; }

vector<Unidad> ArchivosCSV::getUnidades() const { return unidades; }

vector<Solicitud> ArchivosCSV::getSolicitudes() const { return solicitudes; }

string ArchivosCSV::textoTipoPunto(TipoPunto tipo) const {
  if (tipo == TipoPunto::Agencia) return "agencia";
  if (tipo == TipoPunto::Hotel) return "hotel";
  if (tipo == TipoPunto::Atractivo) return "atractivo";
  if (tipo == TipoPunto::Mirador) return "mirador";
  return "espacio_publico";
}

string ArchivosCSV::textoTipoUnidad(TipoUnidad tipo) const {
  if (tipo == TipoUnidad::GuiaPeatonal) return "guia_peatonal";
  if (tipo == TipoUnidad::TaxiTuristico) return "taxi_turistico";
  return "bus_turistico";
}

string ArchivosCSV::textoTipoVisitante(TipoVisitante tipo) const {
  if (tipo == TipoVisitante::General) return "general";
  if (tipo == TipoVisitante::Estudiante) return "estudiante";
  return "nino";
}

string ArchivosCSV::textoEstadoConexion(EstadoConexion estado) const {
  if (estado == EstadoConexion::Habilitada) return "habilitada";
  return "cerrada";
}

string ArchivosCSV::textoEstadoUnidad(EstadoUnidad estado) const {
  if (estado == EstadoUnidad::Disponible) return "disponible";
  return "ocupada";
}

string ArchivosCSV::textoPrioridad(Prioridad prioridad) const {
  if (prioridad == Prioridad::Baja) return "baja";
  if (prioridad == Prioridad::Media) return "media";
  return "alta";
}

string ArchivosCSV::textoEstadoSolicitud(EstadoSolicitud estado) const {
  if (estado == EstadoSolicitud::Pendiente) return "pendiente";
  if (estado == EstadoSolicitud::Asignada) return "asignada";
  return "entregada";
}

bool ArchivosCSV::archivoExiste(const string &nombre) const {
  ifstream archivo(rutaArchivo(nombre).c_str());
  return static_cast<bool>(archivo);
}

bool ArchivosCSV::guardarPlanFA02(
    const vector<Unidad> &nuevasUnidades,
    const vector<Solicitud> &nuevasSolicitudes,
    const vector<Visitante> &visitantes) const {
  ofstream archivoUnidades(rutaArchivo("unidades.csv").c_str());
  ofstream archivoSolicitudes(rutaArchivo("solicitudes.csv").c_str());
  ofstream archivoVisitantes(rutaArchivo("visitantes.csv").c_str());
  if (!archivoUnidades || !archivoSolicitudes || !archivoVisitantes) {
    return false;
  }

  archivoUnidades << "codigo,tipo,capacidad,costo_km,estado\n";
  archivoUnidades << fixed << setprecision(2);
  for (int i = 0; i < static_cast<int>(nuevasUnidades.size()); ++i) {
    archivoUnidades << nuevasUnidades[i].getCodigo() << ","
                    << textoTipoUnidad(nuevasUnidades[i].getTipo()) << ","
                    << nuevasUnidades[i].getCapacidad() << ","
                    << nuevasUnidades[i].getCostoKm() << ","
                    << textoEstadoUnidad(nuevasUnidades[i].getEstado()) << "\n";
  }

  archivoSolicitudes
      << "codigo,origen,destino,cantidad_turistas,prioridad,estado,unidad_asignada\n";
  for (int i = 0; i < static_cast<int>(nuevasSolicitudes.size()); ++i) {
    archivoSolicitudes
        << nuevasSolicitudes[i].getCodigo() << ","
        << nuevasSolicitudes[i].getOrigen() << ","
        << nuevasSolicitudes[i].getDestino() << ","
        << nuevasSolicitudes[i].getCantidadTuristas() << ","
        << textoPrioridad(nuevasSolicitudes[i].getPrioridad()) << ","
        << textoEstadoSolicitud(nuevasSolicitudes[i].getEstado()) << ","
        << nuevasSolicitudes[i].getUnidadAsignada() << "\n";
  }

  archivoVisitantes << "solicitud,tipo_visitante\n";
  for (int i = 0; i < static_cast<int>(visitantes.size()); ++i) {
    archivoVisitantes << visitantes[i].getSolicitud() << ","
                      << textoTipoVisitante(visitantes[i].getTipo()) << "\n";
  }

  return archivoUnidades.good() && archivoSolicitudes.good()
         && archivoVisitantes.good();
}
