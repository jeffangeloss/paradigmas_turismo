-- 4.2.4 Rutas posibles sin repetir puntos.
module Rutas (rutasPosibles, ejecutarRutas) where

import Tipos (Conexion)
import Vecinos (vecinos)

buscarRutas :: String -> String -> [Conexion] -> [String] -> [[String]]
buscarRutas actual destino conexiones visitados
  | actual == destino = [reverse visitados]
  | otherwise =
      [ ruta
      | vecino <- vecinos actual conexiones
      , not (elem vecino visitados)
      , ruta <- buscarRutas vecino destino conexiones (vecino : visitados)
      ]

rutasPosibles :: String -> String -> [Conexion] -> [[String]]
rutasPosibles origen destino conexiones =
  buscarRutas origen destino conexiones [origen]

mostrarRutas :: [[String]] -> IO ()
mostrarRutas [] = return ()
mostrarRutas (ruta : restantes) = do
  print ruta
  mostrarRutas restantes

ejecutarRutas :: [Conexion] -> IO ()
ejecutarRutas conexiones = do
  putStrLn "Codigo de origen:"
  origen <- getLine
  putStrLn "Codigo de destino:"
  destino <- getLine

  let rutas = rutasPosibles origen destino conexiones

  if null rutas
    then putStrLn "[>] No existen rutas habilitadas entre los puntos ingresados."
    else do
      putStrLn "Rutas posibles:"
      mostrarRutas rutas
