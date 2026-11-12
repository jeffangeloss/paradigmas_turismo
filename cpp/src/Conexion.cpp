#include "Conexion.h"

Conexion::Conexion(std::string codigo, std::string origen, std::string destino,
                   double distancia, int tiempo, EstadoConexion estado) {
  this->codigo = codigo;
  this->origen = origen;
  this->destino = destino;
  this->distancia = distancia;
  this->tiempo = tiempo;
  this->estado = estado;
}

std::string Conexion::getCodigo() const { return codigo; }

std::string Conexion::getOrigen() const { return origen; }

std::string Conexion::getDestino() const { return destino; }

double Conexion::getDistancia() const { return distancia; }

int Conexion::getTiempo() const { return tiempo; }

EstadoConexion Conexion::getEstado() const { return estado; }

bool Conexion::estaHabilitada() const {
  return estado == EstadoConexion::Habilitada;
}
