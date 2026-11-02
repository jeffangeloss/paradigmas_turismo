module Main (main) where

import Turismo (Destino (Destino), descripcion)

main :: IO ()
main =
  if descripcion (Destino "Machu Picchu" "Perú") == "Machu Picchu, Perú"
    then putStrLn "Prueba superada"
    else error "La descripción del destino no coincide"

