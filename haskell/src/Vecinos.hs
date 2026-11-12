-- 4.2.3 Función de vecinos.
module Vecinos (vecinos, ejecutarVecinos) where

import Tipos (Conexion (..), EstadoConexion (Habilitada))

vecinosDesdeOrigen :: String -> [Conexion] -> [String]
vecinosDesdeOrigen punto conexiones =
  [destino | Conexion _ origen destino _ _ Habilitada <- conexiones, origen == punto]

vecinosDesdeDestino :: String -> [Conexion] -> [String]
vecinosDesdeDestino punto conexiones =
  [origen | Conexion _ origen destino _ _ Habilitada <- conexiones, destino == punto]

vecinos :: String -> [Conexion] -> [String]
vecinos punto conexiones = vecinosDesdeOrigen punto conexiones ++ vecinosDesdeDestino punto conexiones

ejecutarVecinos :: [Conexion] -> IO ()
ejecutarVecinos conexiones = do
  putStrLn "Codigo del punto:"
  codigoPunto <- getLine

  let puntosVecinos = vecinos codigoPunto conexiones

  if null puntosVecinos
    then putStrLn "[>] El punto no tiene vecinos habilitados."
    else do
      putStrLn "Puntos vecinos:"
      print puntosVecinos
