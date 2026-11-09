-- Grupo 4: ruta turistica en Lima. Modulo funcional (seccion 4.2).
-- 4.2.1 Lectura de los CSV. Responsable: Jefferson Sanchez.
-- Enunciado 4.2.1: leer conexiones.csv, unidades.csv y pedidos.csv (aqui, solicitudes.csv).
module LecturaCSV where

import Text.Read (readMaybe)
import Tipos (Conexion (..), Solicitud (..), Unidad (..))

separarCampos :: String -> [String]
separarCampos fila =
  case break (== ',') fila of
    (campo, []) -> [campo]
    (campo, _ : resto) -> campo : separarCampos resto

leerFilas :: FilePath -> IO [String]
leerFilas ruta = do
  contenido <- readFile ruta
  pure (drop 1 (lines contenido))

parsearConexion :: String -> Maybe Conexion
parsearConexion fila =
  case separarCampos fila of
    [codigo, origen, destino, distancia, tiempo, estado] -> do
      km <- readMaybe distancia
      minutos <- readMaybe tiempo
      pure (Conexion codigo origen destino km minutos estado)
    _ -> Nothing

parsearUnidad :: String -> Maybe Unidad
parsearUnidad fila =
  case separarCampos fila of
    [codigo, tipo, capacidad, costo, estado] -> do
      cupo <- readMaybe capacidad
      costoKm <- readMaybe costo
      pure (Unidad codigo tipo cupo costoKm estado)
    _ -> Nothing

parsearSolicitud :: String -> Maybe Solicitud
parsearSolicitud fila =
  case separarCampos fila of
    [codigo, origen, destino, cantidad, prioridad, estado, unidad] -> do
      turistas <- readMaybe cantidad
      let unidadAsignada = if null unidad then Nothing else Just unidad
      pure (Solicitud codigo origen destino turistas prioridad estado unidadAsignada)
    _ -> Nothing

leerCSV :: (String -> Maybe a) -> FilePath -> IO (Maybe [a])
leerCSV parsear ruta = do
  filas <- leerFilas ruta
  pure (traverse parsear filas)

leerConexiones :: FilePath -> IO (Maybe [Conexion])
leerConexiones = leerCSV parsearConexion

leerUnidades :: FilePath -> IO (Maybe [Unidad])
leerUnidades = leerCSV parsearUnidad

leerSolicitudes :: FilePath -> IO (Maybe [Solicitud])
leerSolicitudes = leerCSV parsearSolicitud