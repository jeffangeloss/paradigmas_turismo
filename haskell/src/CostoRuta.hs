-- 4.2.5 Distancia y tiempo total de una ruta.
module CostoRuta (costoRuta, ejecutarCostoRuta) where

import Rutas (rutasPosibles)
import Tipos (Conexion (..), EstadoConexion (Habilitada))

esMismoTramo :: String -> String -> String -> String -> Bool
esMismoTramo puntoA puntoB origen destino =
  (puntoA == origen && puntoB == destino)
    || (puntoA == destino && puntoB == origen)

buscarTramo :: String -> String -> [Conexion] -> (Double, Int, Bool)
buscarTramo _ _ [] = (0, 0, False)
buscarTramo puntoA puntoB (Conexion _ origen destino distancia tiempo Habilitada : restantes)
  | esMismoTramo puntoA puntoB origen destino =
      (distancia, tiempo, True)
  | otherwise = buscarTramo puntoA puntoB restantes
buscarTramo puntoA puntoB (_ : restantes) = buscarTramo puntoA puntoB restantes

sumarCostos :: (Double, Int, Bool) -> (Double, Int, Bool) -> (Double, Int, Bool)
sumarCostos (distancia, tiempo, tramoValido) (distanciaRestante, tiempoRestante, rutaValida) =
  ( distancia + distanciaRestante
  , tiempo + tiempoRestante
  , tramoValido && rutaValida
  )

sumarTramos :: [String] -> [Conexion] -> (Double, Int, Bool)
sumarTramos [_] _ = (0, 0, True)
sumarTramos (puntoA : puntoB : restantes) conexiones =
  sumarCostos
    (buscarTramo puntoA puntoB conexiones)
    (sumarTramos (puntoB : restantes) conexiones)
sumarTramos _ _ = (0, 0, False)

costoRuta :: [String] -> [Conexion] -> (Double, Int, Bool)
costoRuta puntos conexiones
  | length puntos < 2 = (0, 0, False)
  | otherwise = sumarTramos puntos conexiones

mostrarCosto :: (Double, Int, Bool) -> IO ()
mostrarCosto (_, _, False) =
  putStrLn "[>] La ruta contiene una conexion inexistente o cerrada."
mostrarCosto (distancia, tiempo, True) = do
  putStrLn ("Distancia total: " ++ show distancia ++ " km")
  putStrLn ("Tiempo total: " ++ show tiempo ++ " minutos")

mostrarOpcionesRuta :: [[String]] -> Int -> IO ()
mostrarOpcionesRuta [] _ = return ()
mostrarOpcionesRuta (ruta : restantes) numero = do
  putStrLn (show numero ++ ". " ++ show ruta)
  mostrarOpcionesRuta restantes (numero + 1)

seleccionarRuta :: String -> [[String]] -> Int -> [String]
seleccionarRuta _ [] _ = []
seleccionarRuta opcion (ruta : restantes) numero
  | opcion == show numero = ruta
  | otherwise = seleccionarRuta opcion restantes (numero + 1)

calcularRutaSeleccionada :: [String] -> [Conexion] -> IO ()
calcularRutaSeleccionada [] _ =
  putStrLn "[>] Numero de ruta no valido."
calcularRutaSeleccionada ruta conexiones = do
  putStrLn ("Ruta seleccionada: " ++ show ruta)
  mostrarCosto (costoRuta ruta conexiones)

ejecutarCostoRuta :: [Conexion] -> IO ()
ejecutarCostoRuta conexiones = do
  putStrLn "Codigo de origen:"
  origen <- getLine
  putStrLn "Codigo de destino:"
  destino <- getLine

  let rutas = rutasPosibles origen destino conexiones

  if null rutas
    then putStrLn "[>] No existen rutas habilitadas entre los puntos ingresados."
    else do
      putStrLn "Rutas disponibles:"
      mostrarOpcionesRuta rutas 1
      putStrLn "Numero de ruta:"
      opcion <- getLine
      calcularRutaSeleccionada (seleccionarRuta opcion rutas 1) conexiones
