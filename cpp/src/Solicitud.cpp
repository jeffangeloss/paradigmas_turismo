#include "Solicitud.h"

Solicitud::Solicitud(std::string codigo, std::string origen,
                     std::string destino, int cantidadTuristas,
                     Prioridad prioridad, EstadoSolicitud estado,
                     std::string unidadAsignada) {
  this->codigo = codigo;
  this->origen = origen;
  this->destino = destino;
  this->cantidadTuristas = cantidadTuristas;
  this->prioridad = prioridad;
  this->estado = estado;
  this->unidadAsignada = unidadAsignada;
}

std::string Solicitud::getCodigo() const { return codigo; }

std::string Solicitud::getOrigen() const { return origen; }

std::string Solicitud::getDestino() const { return destino; }

int Solicitud::getCantidadTuristas() const { return cantidadTuristas; }

Prioridad Solicitud::getPrioridad() const { return prioridad; }

EstadoSolicitud Solicitud::getEstado() const { return estado; }

std::string Solicitud::getUnidadAsignada() const { return unidadAsignada; }

bool Solicitud::estaPendiente() const {
  return estado == EstadoSolicitud::Pendiente;
}

void Solicitud::asignarUnidad(std::string codigoUnidad) {
  unidadAsignada = codigoUnidad;
  estado = EstadoSolicitud::Asignada;
}

void Solicitud::marcarEntregada() { estado = EstadoSolicitud::Entregada; }
