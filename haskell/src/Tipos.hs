-- Grupo 4: ruta turistica en Lima. Modulo funcional (seccion 4.2).
-- 4.2.2 Tipos propios. Responsable: Jefferson Sanchez.
-- Todos los modulos importan estos tipos, asi que un cambio aqui se acuerda en grupo.
module Tipos where

import Data.Char (toLower)
import Data.Maybe (fromMaybe)

type Codigo = String
type Km     = Double
type Minutos = Int
type Soles  = Double

data EstadoConexion = Habilitada | Cerrada
  deriving (Show, Eq)

data EstadoUnidad = Disponible | Ocupada
  deriving (Show, Eq)

data EstadoSolicitud = Pendiente | Asignada | Entregada
  deriving (Show, Eq, Enum, Bounded)

-- El orden de los constructores define el orden: Alta < Media < Baja.
data Prioridad = Alta | Media | Baja
  deriving (Show, Eq, Ord)

data TipoUnidad = GuiaPeatonal | TaxiTuristico | BusTuristico
  deriving (Show, Eq)

data Punto = Punto
  { puntoCodigo :: Codigo
  , puntoNombre :: String
  } deriving (Show)

data Conexion = Conexion
  { conexionCodigo  :: Codigo
  , conexionOrigen  :: Codigo
  , conexionDestino :: Codigo
  , distanciaKm     :: Km
  , tiempoMin       :: Minutos
  , estadoConexion  :: EstadoConexion
  } deriving (Show)

data Unidad = Unidad
  { unidadCodigo :: Codigo
  , unidadTipo   :: TipoUnidad
  , capacidad    :: Int
  , costoKm      :: Soles
  , estadoUnidad :: EstadoUnidad
  } deriving (Show)

data Solicitud = Solicitud
  { solicitudCodigo  :: Codigo
  , solicitudOrigen  :: Codigo
  , solicitudDestino :: Codigo
  , turistas         :: Int
  , prioridad        :: Prioridad
  , estadoSolicitud  :: EstadoSolicitud
  , unidadAsignada   :: Maybe Codigo
  } deriving (Show)

-- Textos del CSV de cada enumerado, para leer y para mostrar.
tablaEstadoConexion :: [(String, EstadoConexion)]
tablaEstadoConexion = [("habilitada", Habilitada), ("cerrada", Cerrada)]

tablaEstadoUnidad :: [(String, EstadoUnidad)]
tablaEstadoUnidad = [("disponible", Disponible), ("ocupada", Ocupada)]

tablaEstadoSolicitud :: [(String, EstadoSolicitud)]
tablaEstadoSolicitud =
  [("pendiente", Pendiente), ("asignada", Asignada), ("entregada", Entregada)]

tablaPrioridad :: [(String, Prioridad)]
tablaPrioridad = [("alta", Alta), ("media", Media), ("baja", Baja)]

tablaTipoUnidad :: [(String, TipoUnidad)]
tablaTipoUnidad =
  [("guia_peatonal", GuiaPeatonal), ("taxi_turistico", TaxiTuristico), ("bus_turistico", BusTuristico)]

-- Texto -> valor (Nothing si no es un valor valido). Acepta mayusculas.
leerEnum :: [(String, a)] -> String -> Maybe a
leerEnum tabla texto = lookup (map toLower texto) tabla

-- Valor -> texto del CSV.
nombreEnum :: Eq a => [(String, a)] -> a -> String
nombreEnum tabla valor =
  fromMaybe "?" (lookup valor [(v, t) | (t, v) <- tabla])
