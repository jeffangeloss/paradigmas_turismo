-- Grupo 4: ruta turistica en Lima. Modulo funcional (seccion 4.2).
-- 4.2.3 Vecinos, 4.2.4 Rutas posibles y 4.2.5 Costo de una ruta. Responsable: Melissa Ruiz.
module Rutas where

import Data.List (sortOn)
import Data.Maybe (isNothing, listToMaybe)

import LecturaCSV (mayus, quitarEspacios, separar)
import Tipos

-- ---------------------------------------------------------------
-- 4.2.3 Vecinos
-- ---------------------------------------------------------------

-- Puntos unidos directamente a p por conexiones habilitadas, en ambos sentidos.
vecinos :: [Conexion] -> Codigo -> [(Codigo, Km, Minutos)]
vecinos conexiones p =
  [ (otroLado p c, distanciaKm c, tiempoMin c)
  | c <- conexiones
  , estadoConexion c == Habilitada
  , toca p c ]

-- La conexion c llega a p por alguno de sus dos extremos.
toca :: Codigo -> Conexion -> Bool
toca p c = conexionOrigen c == p || conexionDestino c == p

-- El extremo de c que no es p (se usa despues de comprobar toca p c).
otroLado :: Codigo -> Conexion -> Codigo
otroLado p c = if conexionOrigen c == p then conexionDestino c else conexionOrigen c

-- ---------------------------------------------------------------
-- 4.2.4 Rutas posibles (recursion explicita, sin repetir puntos)
-- ---------------------------------------------------------------

rutasPosibles :: [Conexion] -> Codigo -> Codigo -> [[Codigo]]
rutasPosibles conexiones origen destino = desde [] origen
  where
    desde visitados actual
      | actual == destino = [[actual]]
      | otherwise =
          [ actual : resto
          | (sig, _, _) <- vecinos conexiones actual
          , sig `notElem` (actual : visitados)
          , resto <- desde (actual : visitados) sig ]

-- ---------------------------------------------------------------
-- 4.2.5 Costo de una ruta
-- ---------------------------------------------------------------

-- Busca el tramo a-b en cualquier sentido, este habilitado o no.
buscarTramo :: [Conexion] -> Codigo -> Codigo -> Maybe Conexion
buscarTramo conexiones a b = listToMaybe
  [ c | c <- conexiones, toca a c, otroLado a c == b ]

-- Distancia y tiempo totales, o el tramo que falla.
costoRuta :: [Conexion] -> [Codigo] -> Either String (Km, Minutos)
costoRuta _ []  = Left "La ruta esta vacia"
costoRuta _ [_] = Right (0, 0)
costoRuta conexiones (a : b : resto) =
  case buscarTramo conexiones a b of
    Nothing -> Left ("El tramo " ++ a ++ " -> " ++ b ++ " no existe")
    Just c
      | estadoConexion c == Cerrada ->
          Left ("El tramo " ++ a ++ " -> " ++ b ++ " esta cerrado")
      | otherwise ->
          case costoRuta conexiones (b : resto) of
            Left msg         -> Left msg
            Right (km, min') -> Right (km + distanciaKm c, min' + tiempoMin c)

-- Texto de la ruta del usuario -> lista de codigos ("P001,P003" o "P001-P003").
leerRuta :: String -> [Codigo]
leerRuta texto =
  filter (not . null) (map (mayus . quitarEspacios) (separar ',' (map coma texto)))
  where coma ch = if ch == '-' then ',' else ch

-- Rutas de prueba tomadas de los datos: el primer tramo cerrado y el primer par
-- de puntos sin tramo entre ellos.
rutasDePrueba :: [Punto] -> [Conexion] -> [[Codigo]]
rutasDePrueba puntos conexiones =
  take 1 [ [conexionOrigen c, conexionDestino c] | c <- conexiones, estadoConexion c == Cerrada ]
  ++ take 1 [ [a, b] | a <- codigos, b <- codigos, a < b, isNothing (buscarTramo conexiones a b) ]
  where codigos = map puntoCodigo puntos

-- Costo en soles = distancia x tarifa por km de la unidad.
costoSoles :: Km -> Unidad -> Soles
costoSoles km u = km * costoKm u

-- Comparacion de rutas: cada ruta con su distancia y tiempo, de menor a mayor distancia.
rutasConCosto :: [Conexion] -> Codigo -> Codigo -> [([Codigo], Km, Minutos)]
rutasConCosto conexiones origen destino =
  sortOn (\(_, km, _) -> km)
    [ (r, km, m) | r <- rutasPosibles conexiones origen destino
                 , Right (km, m) <- [costoRuta conexiones r] ]
