-- 4.2.2 Tipos compartidos por los modulos funcionales.
module Tipos where

data TipoPunto = Agencia | Hotel | Atractivo | Mirador | EspacioPublico deriving (Show, Eq)
data TipoUnidad = GuiaPeatonal | TaxiTuristico | BusTuristico deriving (Show, Eq)
data TipoVisitante = General | Estudiante | Nino deriving (Show, Eq)
data EstadoConexion = Habilitada | Cerrada deriving (Show, Eq)
data EstadoUnidad = Disponible | Ocupada deriving (Show, Eq)
data EstadoSolicitud = Pendiente | Asignada | Entregada deriving (Show, Eq)
data Prioridad = Baja | Media | Alta deriving (Show, Eq, Ord)

data Punto = Punto String String TipoPunto String deriving (Show, Eq)
data Conexion = Conexion String String String Double Int EstadoConexion deriving (Show, Eq)
data Unidad = Unidad String TipoUnidad Int Double EstadoUnidad deriving (Show, Eq)
data Solicitud = Solicitud String String String Int Prioridad EstadoSolicitud (Maybe String) deriving (Show, Eq)
data Visitante = Visitante String TipoVisitante deriving (Show, Eq)
data Entrada = Entrada String Double Double Double Int deriving (Show, Eq)
