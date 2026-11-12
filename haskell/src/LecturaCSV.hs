-- Grupo 4: ruta turistica en Lima. Modulo funcional (seccion 4.2).
-- 4.2.1 Lectura de los CSV. Responsable: Jefferson Sanchez.
-- Enunciado 4.2.1: leer conexiones.csv, unidades.csv y pedidos.csv (aqui, solicitudes.csv).
module LecturaCSV where

import Text.Read (readMaybe)
import Tipos
  ( Conexion (..)
  , Entrada (..)
  , EstadoConexion (..)
  , EstadoSolicitud (..)
  , EstadoUnidad (..)
  , Prioridad (..)
  , Punto (..)
  , Solicitud (..)
  , TipoPunto (..)
  , TipoUnidad (..)
  , TipoVisitante (..)
  , Unidad (..)
  , Visitante (..)
  )

separarCampos :: String -> [String]
separarCampos fila =
  case break (== ',') fila of
    (campo, []) -> [campo]
    (campo, _ : resto) -> campo : separarCampos resto

leerFilas :: FilePath -> IO [String]
leerFilas ruta = do
  contenido <- readFile ruta
  pure (drop 1 (lines contenido))

parsearTipoPunto :: String -> Maybe TipoPunto
parsearTipoPunto "agencia" = Just Agencia
parsearTipoPunto "hotel" = Just Hotel
parsearTipoPunto "atractivo" = Just Atractivo
parsearTipoPunto "mirador" = Just Mirador
parsearTipoPunto "espacio_publico" = Just EspacioPublico
parsearTipoPunto _ = Nothing

parsearTipoUnidad :: String -> Maybe TipoUnidad
parsearTipoUnidad "guia_peatonal" = Just GuiaPeatonal
parsearTipoUnidad "taxi_turistico" = Just TaxiTuristico
parsearTipoUnidad "bus_turistico" = Just BusTuristico
parsearTipoUnidad _ = Nothing

parsearTipoVisitante :: String -> Maybe TipoVisitante
parsearTipoVisitante "general" = Just General
parsearTipoVisitante "estudiante" = Just Estudiante
parsearTipoVisitante "nino" = Just Nino
parsearTipoVisitante _ = Nothing

parsearEstadoConexion :: String -> Maybe EstadoConexion
parsearEstadoConexion "habilitada" = Just Habilitada
parsearEstadoConexion "cerrada" = Just Cerrada
parsearEstadoConexion _ = Nothing

parsearEstadoUnidad :: String -> Maybe EstadoUnidad
parsearEstadoUnidad "disponible" = Just Disponible
parsearEstadoUnidad "ocupada" = Just Ocupada
parsearEstadoUnidad _ = Nothing

parsearEstadoSolicitud :: String -> Maybe EstadoSolicitud
parsearEstadoSolicitud "pendiente" = Just Pendiente
parsearEstadoSolicitud "asignada" = Just Asignada
parsearEstadoSolicitud "entregada" = Just Entregada
parsearEstadoSolicitud _ = Nothing

parsearPrioridad :: String -> Maybe Prioridad
parsearPrioridad "baja" = Just Baja
parsearPrioridad "media" = Just Media
parsearPrioridad "alta" = Just Alta
parsearPrioridad _ = Nothing

parsearPunto :: String -> Maybe Punto
parsearPunto fila =
  case separarCampos fila of
    [codigo, nombre, tipoTexto, zona] -> do
      tipo <- parsearTipoPunto tipoTexto
      pure (Punto codigo nombre tipo zona)
    _ -> Nothing

parsearConexion :: String -> Maybe Conexion
parsearConexion fila =
  case separarCampos fila of
    [codigo, origen, destino, distancia, tiempo, estadoTexto] -> do
      km <- readMaybe distancia
      minutos <- readMaybe tiempo
      estado <- parsearEstadoConexion estadoTexto
      if km >= 0 && minutos >= 0
        then pure (Conexion codigo origen destino km minutos estado)
        else Nothing
    _ -> Nothing

parsearUnidad :: String -> Maybe Unidad
parsearUnidad fila =
  case separarCampos fila of
    [codigo, tipoTexto, capacidad, costo, estadoTexto] -> do
      tipo <- parsearTipoUnidad tipoTexto
      cupo <- readMaybe capacidad
      costoKm <- readMaybe costo
      estado <- parsearEstadoUnidad estadoTexto
      if cupo > 0 && costoKm >= 0
        then pure (Unidad codigo tipo cupo costoKm estado)
        else Nothing
    _ -> Nothing

parsearSolicitud :: String -> Maybe Solicitud
parsearSolicitud fila =
  case separarCampos fila of
    [codigo, origen, destino, cantidad, prioridadTexto, estadoTexto, unidad] -> do
      turistas <- readMaybe cantidad
      prioridad <- parsearPrioridad prioridadTexto
      estado <- parsearEstadoSolicitud estadoTexto
      let unidadAsignada = if null unidad then Nothing else Just unidad
      if turistas > 0
        then pure (Solicitud codigo origen destino turistas prioridad estado unidadAsignada)
        else Nothing
    _ -> Nothing

parsearVisitante :: String -> Maybe Visitante
parsearVisitante fila =
  case separarCampos fila of
    [solicitud, tipoTexto] -> do
      tipo <- parsearTipoVisitante tipoTexto
      pure (Visitante solicitud tipo)
    _ -> Nothing

parsearEntrada :: String -> Maybe Entrada
parsearEntrada fila =
  case separarCampos fila of
    [codigo, precioGeneral, precioEstudiante, precioNino, minutos] -> do
      general <- readMaybe precioGeneral
      estudiante <- readMaybe precioEstudiante
      nino <- readMaybe precioNino
      duracion <- readMaybe minutos
      if general >= 0 && estudiante >= 0 && nino >= 0 && duracion > 0
        then pure (Entrada codigo general estudiante nino duracion)
        else Nothing
    _ -> Nothing

leerCSV :: (String -> Maybe a) -> FilePath -> IO (Maybe [a])
leerCSV parsear ruta = do
  filas <- leerFilas ruta
  pure (traverse parsear filas)

leerPuntos :: FilePath -> IO (Maybe [Punto])
leerPuntos = leerCSV parsearPunto

leerConexiones :: FilePath -> IO (Maybe [Conexion])
leerConexiones = leerCSV parsearConexion

leerUnidades :: FilePath -> IO (Maybe [Unidad])
leerUnidades = leerCSV parsearUnidad

leerSolicitudes :: FilePath -> IO (Maybe [Solicitud])
leerSolicitudes = leerCSV parsearSolicitud

leerVisitantes :: FilePath -> IO (Maybe [Visitante])
leerVisitantes = leerCSV parsearVisitante

leerEntradas :: FilePath -> IO (Maybe [Entrada])
leerEntradas = leerCSV parsearEntrada
