-- 4.2.3 Función de vecinos.
module Vecinos (vecinos, ejecutarVecinos) where

import Tipos (Conexion (..))

vecinosDesdeOrigen :: String -> [Conexion] -> [String]
vecinosDesdeOrigen punto conexiones =
  [ destino | Conexion _ origen destino _ _ estado <- conexiones, origen == punto, estado == "habilitada"]

vecinosDesdeDestino :: String -> [Conexion] -> [String]
vecinosDesdeDestino punto conexiones =
  [ origen | Conexion _ origen destino _ _ estado <- conexiones, destino == punto, estado == "habilitada"]

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
