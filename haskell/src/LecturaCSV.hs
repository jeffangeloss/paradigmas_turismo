-- Grupo 4: ruta turistica en Lima. Modulo funcional (seccion 4.2).
-- 4.2.1 Lectura de los CSV con un parser propio. Responsable: Jefferson Sanchez.
module LecturaCSV where

import Data.Char (isSpace, toUpper)
import Data.List (dropWhileEnd)
import Data.Maybe (mapMaybe)
import System.Directory (doesFileExist)
import System.Exit (exitFailure)
import System.IO
import Text.Read (readMaybe)

import Tipos

-- Separa por el caracter dado, conservando los campos vacios del final.
separar :: Char -> String -> [String]
separar sep s = case break (== sep) s of
  (campo, [])        -> [campo]
  (campo, _ : resto) -> campo : separar sep resto

quitarEspacios :: String -> String
quitarEspacios = dropWhileEnd isSpace . dropWhile isSpace

-- Campos de una linea, sin \r ni espacios alrededor.
campos :: String -> [String]
campos = map quitarEspacios . separar ',' . filter (/= '\r')

-- Salta el encabezado, convierte cada fila y devuelve (validas, descartadas).
parsearTabla :: ([String] -> Maybe a) -> String -> ([a], Int)
parsearTabla convertir texto = (validos, length filas - length validos)
  where
    filas   = filter (not . null . quitarEspacios) (drop 1 (lines texto))
    validos = mapMaybe (convertir . campos) filas

-- Los codigos se comparan en mayusculas (P001, U001, S001), como en el contrato.
mayus :: String -> String
mayus = map toUpper

filaPunto :: [String] -> Maybe Punto
filaPunto [c, nombre, _, _] = Just (Punto (mayus c) nombre)
filaPunto _                 = Nothing

filaConexion :: [String] -> Maybe Conexion
filaConexion [c, o, d, km, min', est] =
  case (readMaybe km, readMaybe min', leerEnum tablaEstadoConexion est) of
    (Just k, Just m, Just e) -> Just (Conexion (mayus c) (mayus o) (mayus d) k m e)
    _                        -> Nothing
filaConexion _ = Nothing

filaUnidad :: [String] -> Maybe Unidad
filaUnidad [c, tipo, cap, costo, est] =
  case (leerEnum tablaTipoUnidad tipo, readMaybe cap, readMaybe costo,
        leerEnum tablaEstadoUnidad est) of
    (Just t, Just n, Just k, Just e) -> Just (Unidad (mayus c) t n k e)
    _                                -> Nothing
filaUnidad _ = Nothing

filaSolicitud :: [String] -> Maybe Solicitud
filaSolicitud [c, o, d, t, prio, est, unidad] =
  case (readMaybe t, leerEnum tablaPrioridad prio, leerEnum tablaEstadoSolicitud est) of
    (Just n, Just p, Just e) ->
      Just (Solicitud (mayus c) (mayus o) (mayus d) n p e
                      (if null unidad then Nothing else Just (mayus unidad)))
    _ -> Nothing
filaSolicitud _ = Nothing

-- E/S: lee un archivo como UTF-8; si no existe, avisa y termina.
leerArchivo :: FilePath -> IO String
leerArchivo ruta = do
  existe <- doesFileExist ruta
  if existe
    then do
      h <- openFile ruta ReadMode
      hSetEncoding h utf8
      hGetContents' h   -- lee todo el archivo y lo cierra
    else do
      hPutStrLn stderr ("No se pudo leer el archivo: " ++ ruta)
      exitFailure

-- Lee un CSV y avisa por stderr cuantas filas descarto.
cargar :: FilePath -> ([String] -> Maybe a) -> IO [a]
cargar ruta convertir = do
  texto <- leerArchivo ruta
  let (validos, descartadas) = parsearTabla convertir texto
  if descartadas > 0
    then hPutStrLn stderr
           ("Aviso: " ++ ruta ++ ": " ++ show descartadas ++ " fila(s) descartada(s)")
    else return ()
  return validos
