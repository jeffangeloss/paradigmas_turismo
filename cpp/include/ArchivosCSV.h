#ifndef ARCHIVOS_CSV_H
#define ARCHIVOS_CSV_H

#include "Conexion.h"
#include "Punto.h"
#include "Solicitud.h"
#include "Tipos.h"
#include "Unidad.h"
#include "Visitante.h"

#include <string>
#include <vector>

class ArchivosCSV {
private:
  std::string carpetaDatos;
  std::vector<Punto> puntos;
  std::vector<Conexion> conexiones;
  std::vector<Unidad> unidades;
  std::vector<Solicitud> solicitudes;

  std::string rutaArchivo(const std::string &nombre) const;
  std::vector<std::string> separarCampos(const std::string &linea) const;
  bool leerFilas(const std::string &nombre,
                 std::vector<std::string> &filas) const;
  void mostrarFilaInvalida(const std::string &archivo, int numeroFila) const;

  bool convertirTipoPunto(const std::string &texto, TipoPunto &tipo) const;
  bool convertirTipoVisitante(const std::string &texto,
                              TipoVisitante &tipo) const;
  bool convertirEstadoConexion(const std::string &texto,
                               EstadoConexion &estado) const;
  bool convertirEstadoUnidad(const std::string &texto,
                             EstadoUnidad &estado) const;
  bool convertirPrioridad(const std::string &texto,
                          Prioridad &prioridad) const;
  bool convertirEstadoSolicitud(const std::string &texto,
                                EstadoSolicitud &estado) const;

  std::vector<Punto> cargarPuntos() const;
  std::vector<Conexion> cargarConexiones() const;
  std::vector<Unidad> cargarUnidades() const;
  std::vector<Solicitud> cargarSolicitudes() const;

public:
  explicit ArchivosCSV(std::string carpetaDatos);

  // 4.1.2 Carga inicial. Responsable: Jefferson Sanchez.
  void cargarDatosIniciales();
  void actualizarDatos();

  std::vector<Punto> getPuntos() const;
  std::vector<Conexion> getConexiones() const;
  std::vector<Unidad> getUnidades() const;
  std::vector<Solicitud> getSolicitudes() const;
  std::vector<Visitante> cargarVisitantes() const;

  bool convertirTipoUnidad(const std::string &texto, TipoUnidad &tipo) const;
  std::string textoTipoPunto(TipoPunto tipo) const;
  std::string textoTipoUnidad(TipoUnidad tipo) const;
  std::string textoTipoVisitante(TipoVisitante tipo) const;
  std::string textoEstadoConexion(EstadoConexion estado) const;
  std::string textoEstadoUnidad(EstadoUnidad estado) const;
  std::string textoPrioridad(Prioridad prioridad) const;
  std::string textoEstadoSolicitud(EstadoSolicitud estado) const;

  bool archivoExiste(const std::string &nombre) const;
  bool guardarPlanFA02(const std::vector<Unidad> &nuevasUnidades,
                       const std::vector<Solicitud> &nuevasSolicitudes,
                       const std::vector<Visitante> &visitantes) const;
};

#endif
