-- Grupo 4: ruta turistica en Lima. Modulo funcional (seccion 4.2).
-- 4.2.7 Programa principal. Responsable: Samantha Rodriguez.
-- Uso, desde haskell/: cabal run turismo-haskell -- [carpeta_datos] [codigo_solicitud] [ruta]
-- La ruta va separada por comas o guiones, por ejemplo P011,P007,P006,P004 (4.2.5).
module Main (main) where

import Data.List (intercalate, nub)
import Data.Maybe (fromMaybe, listToMaybe, mapMaybe)
import System.Environment (getArgs)
import System.IO
import Text.Printf (printf)

import LecturaCSV
import Reportes
import Rutas
import Tipos
import qualified FA.Jefferson as FAJefferson
import qualified FA.Melissa as FAMelissa
import qualified FA.Samantha as FASamantha

-- ---------------------------------------------------------------
-- Funciones auxiliares de presentacion (puras)
-- ---------------------------------------------------------------

formatoRuta :: [Codigo] -> String
formatoRuta = intercalate " -> "

formatoVecino :: (Codigo, Km, Minutos) -> String
formatoVecino (p, km, m) = printf "%s (%.2f km, %d min)" p km m

nombrePunto :: [Punto] -> Codigo -> String
nombrePunto puntos c =
  fromMaybe c (listToMaybe [puntoNombre p | p <- puntos, puntoCodigo p == c])

-- Resultado de costoRuta como texto: "5.40 km, 23 min" o el tramo que falla.
formatoCosto :: Either String (Km, Minutos) -> String
formatoCosto (Left msg)       = msg
formatoCosto (Right (km, m)) = printf "%.2f km, %d min" km m

-- Una unidad por cada tipo, disponible y con capacidad suficiente para los turistas
-- (el mismo criterio que puede_atender en Prolog).
unidadesPorTipo :: Int -> [Unidad] -> [Unidad]
unidadesPorTipo personas unidades = mapMaybe primera tipos
  where
    aptas     = filter (\u -> capacidad u >= personas && estadoUnidad u == Disponible) unidades
    tipos     = nub (map unidadTipo aptas)
    primera t = listToMaybe (filter ((== t) . unidadTipo) aptas)

-- ---------------------------------------------------------------
-- 4.2.7 Programa principal
-- ---------------------------------------------------------------

main :: IO ()
main = do
  hSetEncoding stdout utf8
  hSetEncoding stderr utf8
  args <- getArgs
  case args of
    (carpeta : "--fa" : quien : resto) -> funcionalidadAdicional carpeta quien resto
    _                                  -> programaBase args

-- Cada integrante implementa su FA en haskell/FA/<Nombre>.hs; aqui solo se la llama.
-- Uso, desde haskell/: cabal run turismo-haskell -- ../_datos --fa <samantha|melissa|jefferson> [args]
funcionalidadAdicional :: FilePath -> String -> [String] -> IO ()
funcionalidadAdicional carpeta quien resto = case quien of
  "samantha"  -> FASamantha.ejecutar carpeta resto
  "melissa"   -> FAMelissa.ejecutar carpeta resto
  "jefferson" -> FAJefferson.ejecutar carpeta resto
  _           -> putStrLn ("No existe la funcionalidad adicional de " ++ quien ++ ".")

-- Programa base: resumen de una solicitud, prueba de costoRuta y reporte.
programaBase :: [String] -> IO ()
programaBase args = do
  let carpeta = case args of (c : _) -> c; [] -> "_datos"
      pedido  = case args of (_ : s : _) -> Just (mayus s); _ -> Nothing
  puntos      <- cargar (carpeta ++ "/puntos.csv") filaPunto
  conexiones  <- cargar (carpeta ++ "/conexiones.csv") filaConexion
  unidades    <- cargar (carpeta ++ "/unidades.csv") filaUnidad
  solicitudes <- cargar (carpeta ++ "/solicitudes.csv") filaSolicitud
  let elegida = case pedido of
        Just cod -> listToMaybe [s | s <- solicitudes, solicitudCodigo s == cod]
        Nothing  -> listToMaybe (pendientesPorPrioridad solicitudes)
      pruebas = case args of
        (_ : _ : r : _) -> [leerRuta r]
        _               -> rutasDePrueba puntos conexiones
  case (elegida, pedido) of
    (Just s, _) -> do
      resumen puntos conexiones unidades s
      mapM_ (probarRuta conexiones) pruebas
      reporte unidades solicitudes
    (Nothing, Just c)  -> putStrLn ("La solicitud " ++ c ++ " no existe.")
    (Nothing, Nothing) -> putStrLn "No hay solicitudes pendientes."

-- 4.2.5 Prueba de costoRuta con una ruta dada como lista de puntos.
probarRuta :: [Conexion] -> [Codigo] -> IO ()
probarRuta conexiones r = do
  putStrLn ("Prueba de costoRuta (" ++ formatoRuta r ++ "):")
  putStrLn ("  " ++ formatoCosto (costoRuta conexiones r))

-- Rutas y costos de la solicitud elegida (4.2.3 a 4.2.5).
resumen :: [Punto] -> [Conexion] -> [Unidad] -> Solicitud -> IO ()
resumen puntos conexiones unidades s = do
  let o = solicitudOrigen s
      d = solicitudDestino s
      rutas = rutasConCosto conexiones o d
  putStrLn ("Solicitud: " ++ solicitudCodigo s ++ " (" ++ o ++ " -> " ++ d ++ ")")
  putStrLn ("De " ++ nombrePunto puntos o ++ " a " ++ nombrePunto puntos d
            ++ ", " ++ show (turistas s) ++ " turistas, prioridad "
            ++ nombreEnum tablaPrioridad (prioridad s))
  putStrLn ("Vecinos de " ++ o ++ ": "
            ++ intercalate ", " (map formatoVecino (vecinos conexiones o)))
  putStrLn ("Rutas posibles: " ++ show (length rutas))
  mapM_ (\(r, km, m) -> printf "  %s (%.2f km, %d min)\n" (formatoRuta r) km m) rutas
  case rutas of
    [] -> putStrLn ("La solicitud " ++ solicitudCodigo s
                    ++ " no tiene rutas posibles por conexiones habilitadas.")
    (mejor, km, m) : _ -> do
      printf "Ruta mas corta (km): %s, distancia %.2f km, tiempo %d min\n"
             (formatoRuta mejor) km m
      case unidadesPorTipo (turistas s) unidades of
        []    -> putStrLn ("Ninguna unidad disponible tiene capacidad para "
                           ++ show (turistas s) ++ " turistas.")
        aptas -> mapM_ (\u -> printf "Costo de ruta %s (%s): S/ %.2f\n" (formatoRuta mejor)
                                  (nombreEnum tablaTipoUnidad (unidadTipo u)) (costoSoles km u))
                       aptas

-- 4.2.6 Reporte de todas las solicitudes.
reporte :: [Unidad] -> [Solicitud] -> IO ()
reporte unidades solicitudes = do
  putStrLn "Solicitudes por estado:"
  mapM_ (\(e, n) -> putStrLn ("  " ++ nombreEnum tablaEstadoSolicitud e ++ ": " ++ show n))
        (conteoPorEstado solicitudes)
  putStrLn "Carga asignada por unidad (turistas en solicitudes asignadas):"
  mapM_ (\(u, n) -> putStrLn ("  " ++ u ++ ": " ++ show n))
        (turistasPorUnidad unidades solicitudes)
  putStrLn ("Solicitudes pendientes por prioridad: "
            ++ intercalate ", "
                 [ solicitudCodigo p ++ " (" ++ nombreEnum tablaPrioridad (prioridad p) ++ ")"
                 | p <- pendientesPorPrioridad solicitudes ])
