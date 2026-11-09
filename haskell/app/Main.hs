module Main (main) where

import LecturaCSV (leerConexiones)
import Tipos (Conexion)
import Vecinos (ejecutarVecinos)

mostrarMenu :: IO ()
mostrarMenu = do
  putStrLn ""
  putStrLn "=== Modulo Haskell ==="
  putStrLn "1. [4.2.3] Funcion de vecinos"
  putStrLn "2. [4.2.4] Rutas posibles"
  putStrLn "3. [4.2.5] Costo de una ruta"
  putStrLn "4. [4.2.6] Reporte de solicitudes"
  putStrLn "5. [4.2.7] Resultado esperado"
  putStrLn "0. Volver al menu de C++"
  putStrLn "Opcion:"

mostrarPendiente :: String -> IO ()
mostrarPendiente funcionalidad =
  putStrLn ("[PENDIENTE] " ++ funcionalidad ++ " aun no esta implementada.")

ejecutarOpcion :: String -> [Conexion] -> IO ()
ejecutarOpcion "1" conexiones = ejecutarVecinos conexiones
ejecutarOpcion "2" _ = mostrarPendiente "Rutas posibles"
ejecutarOpcion "3" _ = mostrarPendiente "Costo de una ruta"
ejecutarOpcion "4" _ = mostrarPendiente "Reporte de solicitudes"
ejecutarOpcion "5" _ = mostrarPendiente "Resultado esperado"
ejecutarOpcion "0" _ = putStrLn "Regresando al menu de C++..."
ejecutarOpcion _ _ = putStrLn "[ERROR] Opcion no valida."

menuPrincipal :: [Conexion] -> IO ()
menuPrincipal conexiones = do
  mostrarMenu
  opcion <- getLine
  ejecutarOpcion opcion conexiones

  if opcion == "0"
    then return ()
    else menuPrincipal conexiones

iniciarPrograma :: Maybe [Conexion] -> IO ()
iniciarPrograma Nothing = putStrLn "[ERROR] No se pudo leer conexiones.csv."
iniciarPrograma (Just conexiones) = do
  putStrLn "[OK] conexiones.csv cargado correctamente."
  menuPrincipal conexiones

main = do
  resultado <- leerConexiones "../_datos/conexiones.csv"
  iniciarPrograma resultado
