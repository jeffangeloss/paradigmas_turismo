module Main (main) where

import CostoRuta (ejecutarCostoRuta)
import LecturaCSV (leerConexiones, leerSolicitudes)
import Rutas (ejecutarRutas)
import Tipos (Conexion)
import Tipos (Solicitud)
import Vecinos (ejecutarVecinos, vecinos)
import ReporteSolicitudes (ejecutarReporteSolicitudes, reporteSolicitudes)
import SeleccionAtractivos (ejecutarSeleccionAtractivos)
import System.Environment (getArgs)

mostrarMenu :: IO ()
mostrarMenu = do
  putStrLn ""
  putStrLn "=== Modulo Haskell ==="
  putStrLn "1. [4.2.3] Funcion de vecinos"
  putStrLn "2. [4.2.4] Rutas posibles"
  putStrLn "3. [4.2.5] Costo de una ruta"
  putStrLn "4. [4.2.6] Reporte de solicitudes"
  putStrLn "5. [4.2.7] Mostrar resultado esperado"
  putStrLn "0. Volver al menu de C++"
  putStrLn "Opcion:"

ejecutarOpcion :: String -> [Conexion] -> [Solicitud] -> IO ()
ejecutarOpcion "1" conexiones _ = ejecutarVecinos conexiones
ejecutarOpcion "2" conexiones _ = ejecutarRutas conexiones
ejecutarOpcion "3" conexiones _ = ejecutarCostoRuta conexiones
ejecutarOpcion "4" _ solicitudes = ejecutarReporteSolicitudes solicitudes
ejecutarOpcion "5" conexiones solicitudes = do
  putStrLn "=== Resultado esperado ==="
  putStrLn ("Vecinos habilitados de P002: " ++ show (vecinos "P002" conexiones))
  putStrLn (reporteSolicitudes solicitudes)
ejecutarOpcion "0" _ _ = putStrLn "Regresando al menu de C++..."
ejecutarOpcion _ _ _ = putStrLn "[ERROR] Opcion no valida."

menuPrincipal :: [Conexion] -> [Solicitud] -> IO ()
menuPrincipal conexiones solicitudes = do
  mostrarMenu
  opcion <- getLine
  ejecutarOpcion opcion conexiones solicitudes

  if opcion == "0"
    then return ()
    else menuPrincipal conexiones solicitudes

iniciarPrograma :: Maybe [Conexion] -> Maybe [Solicitud] -> IO ()
iniciarPrograma Nothing _ = putStrLn "[ERROR] No se pudo leer conexiones.csv."
iniciarPrograma _ Nothing = putStrLn "[ERROR] No se pudo leer solicitudes.csv."
iniciarPrograma (Just conexiones) (Just solicitudes) = do
  putStrLn "[OK] conexiones.csv cargado correctamente."
  putStrLn "[OK] solicitudes.csv cargado correctamente."
  menuPrincipal conexiones solicitudes

iniciarMenu :: FilePath -> IO ()
iniciarMenu carpetaDatos = do
  resultadoConexiones <- leerConexiones (carpetaDatos ++ "/conexiones.csv")
  resultadoSolicitudes <- leerSolicitudes (carpetaDatos ++ "/solicitudes.csv")
  iniciarPrograma resultadoConexiones resultadoSolicitudes

main :: IO ()
main = do
  argumentos <- getArgs
  case argumentos of
    carpeta : "--fa02" : generales : estudiantes : ninos : presupuesto : tiempo : _ ->
      ejecutarSeleccionAtractivos carpeta generales estudiantes ninos presupuesto tiempo
    carpeta : _ -> iniciarMenu carpeta
    [] -> iniciarMenu "../_datos"
