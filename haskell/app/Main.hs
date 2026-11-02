module Main (main) where

import Turismo (Destino (Destino), descripcion)

main :: IO ()
main = do
  let destino = Destino "Machu Picchu" "Perú"
  putStrLn ("Destino recomendado: " ++ descripcion destino)

