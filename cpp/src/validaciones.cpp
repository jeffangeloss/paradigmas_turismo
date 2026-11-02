// Grupo 4 - Ruta turistica en Lima. Modulo C++ (paradigma imperativo).
// 4.1.3 Validaciones de cada registro (tambien las usa la carga 4.1.2).
// Responsable: Melissa Ruiz
#include "validaciones.hpp"
#include "utilidades.hpp"

// ------------------------------------------------------------- Validaciones
// Cada funcion devuelve "" si el registro es valido, o el motivo del rechazo.
// Se usan al registrar (4.1.3) y al cargar los CSV (4.1.2). Una regla nueva aqui
// tambien filtra la carga: las filas que no la cumplan se omiten y se pierden en el
// siguiente guardado. Si solo se quiere limitar el registro, validar en registrar*.

string validarPunto(const BaseDatos& db, const Punto& p) {
    if (!textoValido(p.codigo) || !textoValido(p.nombre) || !textoValido(p.zona))
        return "codigo, nombre y zona no pueden estar vacios ni llevar comas";
    if (buscarPunto(db, p.codigo) != -1) return "el codigo " + p.codigo + " ya existe";
    if (!estaEn(p.tipo, TIPOS_PUNTO)) return "tipo debe ser atractivo, hotel o mirador";
    return "";
}

string validarConexion(const BaseDatos& db, const Conexion& c) {
    if (!textoValido(c.codigo)) return "el codigo no puede estar vacio ni llevar comas";
    if (buscarConexionPorCodigo(db, c.codigo) != -1) return "el codigo " + c.codigo + " ya existe";
    if (buscarPunto(db, c.origen) == -1) return "el punto origen " + c.origen + " no existe";
    if (buscarPunto(db, c.destino) == -1) return "el punto destino " + c.destino + " no existe";
    if (c.origen == c.destino) return "origen y destino deben ser distintos";
    if (c.distanciaKm <= 0) return "la distancia debe ser mayor que cero";
    if (c.tiempoMin <= 0) return "el tiempo debe ser mayor que cero";
    if (!estaEn(c.estado, ESTADOS_CONEXION)) return "estado debe ser habilitada o cerrada";
    if (buscarConexion(db, c.origen, c.destino) != -1) return "la conexion ya existe (en algun sentido)";
    return "";
}

string validarUnidad(const BaseDatos& db, const Unidad& u) {
    if (!textoValido(u.codigo)) return "el codigo no puede estar vacio ni llevar comas";
    if (buscarUnidad(db, u.codigo) != -1) return "el codigo " + u.codigo + " ya existe";
    if (!estaEn(u.tipo, TIPOS_UNIDAD)) return "tipo debe ser guia_peatonal, taxi_turistico o bus_turistico";
    if (u.capacidad <= 0) return "la capacidad debe ser mayor que cero";
    if (u.costoKm <= 0) return "el costo por km debe ser mayor que cero";
    if (!estaEn(u.estado, ESTADOS_UNIDAD)) return "estado debe ser disponible u ocupada";
    return "";
}

string validarSolicitud(const BaseDatos& db, const Solicitud& s) {
    if (!textoValido(s.codigo)) return "el codigo no puede estar vacio ni llevar comas";
    if (buscarSolicitud(db, s.codigo) != -1) return "el codigo " + s.codigo + " ya existe";
    if (buscarPunto(db, s.origen) == -1) return "el punto origen " + s.origen + " no existe";
    if (buscarPunto(db, s.destino) == -1) return "el punto destino " + s.destino + " no existe";
    if (s.origen == s.destino) return "origen y destino deben ser distintos";
    if (s.turistas <= 0) return "el numero de turistas debe ser mayor que cero";
    if (!estaEn(s.prioridad, PRIORIDADES)) return "prioridad debe ser alta, media o baja";
    if (!estaEn(s.estado, ESTADOS_SOLICITUD)) return "estado debe ser pendiente, asignada o entregada";
    if (s.estado == "pendiente" && !s.unidad.empty()) return "una solicitud pendiente no lleva unidad";
    if (s.estado != "pendiente") {
        if (s.unidad.empty()) return "una solicitud " + s.estado + " debe tener unidad";
        if (buscarUnidad(db, s.unidad) == -1) return "la unidad " + s.unidad + " no existe";
    }
    return "";
}
