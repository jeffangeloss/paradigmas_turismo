-- Grupo 4: ruta turistica en Lima. Modulo funcional (seccion 4.2).
-- 4.2.2 Tipos propios. Responsable: Jefferson Sanchez.
-- Enunciado 4.2.2: representar conexiones, unidades y pedidos (aqui, solicitudes)
-- mediante tipos propios (data) o sinonimos de tipo.
-- Todos los modulos importan estos tipos, asi que un cambio aqui se acuerda en grupo.
module Tipos where
data Conexion = Conexion String String String Double Int String
  deriving (Show)

data Unidad = Unidad String String Int Double String
  deriving (Show)

data Solicitud = Solicitud String String String Int String String (Maybe String)
  deriving (Show)