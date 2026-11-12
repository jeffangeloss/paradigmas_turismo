#include "Punto.h"

Punto::Punto(std::string codigo, std::string nombre, TipoPunto tipo,
             std::string zona) {
  this->codigo = codigo;
  this->nombre = nombre;
  this->tipo = tipo;
  this->zona = zona;
}

std::string Punto::getCodigo() const { return codigo; }

std::string Punto::getNombre() const { return nombre; }

TipoPunto Punto::getTipo() const { return tipo; }

std::string Punto::getZona() const { return zona; }

bool Punto::esAtractivo() const { return tipo == TipoPunto::Atractivo; }
