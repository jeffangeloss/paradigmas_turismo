module Turismo
  ( Destino (..)
  , descripcion
  ) where

data Destino = Destino
  { nombre :: String
  , pais :: String
  }
  deriving (Eq, Show)

descripcion :: Destino -> String
descripcion destino = nombre destino ++ ", " ++ pais destino

