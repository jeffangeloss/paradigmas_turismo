#ifndef TIPOS_H
#define TIPOS_H

enum class TipoPunto { Agencia, Hotel, Atractivo, Mirador, EspacioPublico };
enum class TipoUnidad { GuiaPeatonal, TaxiTuristico, BusTuristico };
enum class TipoVisitante { General, Estudiante, Nino };
enum class EstadoConexion { Habilitada, Cerrada };
enum class EstadoUnidad { Disponible, Ocupada };
enum class EstadoSolicitud { Pendiente, Asignada, Entregada };
enum class Prioridad { Baja, Media, Alta };

#endif
