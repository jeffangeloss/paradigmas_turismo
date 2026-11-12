#include "Unidad.h"

Unidad::Unidad(std::string codigo, TipoUnidad tipo, int capacidad,
               double costoKm, EstadoUnidad estado) {
  this->codigo = codigo;
  this->tipo = tipo;
  this->capacidad = capacidad;
  this->costoKm = costoKm;
  this->estado = estado;
}

std::string Unidad::getCodigo() const { return codigo; }

TipoUnidad Unidad::getTipo() const { return tipo; }

int Unidad::getCapacidad() const { return capacidad; }

double Unidad::getCostoKm() const { return costoKm; }

EstadoUnidad Unidad::getEstado() const { return estado; }

bool Unidad::estaDisponible() const {
  return estado == EstadoUnidad::Disponible;
}

bool Unidad::tieneCapacidad(int cantidadPersonas) const {
  return capacidad >= cantidadPersonas;
}

void Unidad::ocupar() { estado = EstadoUnidad::Ocupada; }

void Unidad::liberar() { estado = EstadoUnidad::Disponible; }
