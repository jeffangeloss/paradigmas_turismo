-- Grupo 4: ruta turistica en Lima. Modulo funcional (seccion 4.2).
-- 4.2.6 Reporte de solicitudes. Responsable: Samantha Rodriguez.
module Reportes where

import Data.List (sortOn)

import Tipos

-- Cuantas solicitudes hay en cada estado.
conteoPorEstado :: [Solicitud] -> [(EstadoSolicitud, Int)]
conteoPorEstado = foldr sumar [(e, 0) | e <- [minBound .. maxBound]]
  where
    sumar s = map (\(e, n) -> if e == estadoSolicitud s then (e, n + 1) else (e, n))

-- Turistas de las solicitudes asignadas a cada unidad.
turistasPorUnidad :: [Unidad] -> [Solicitud] -> [(Codigo, Int)]
turistasPorUnidad unidades solicitudes =
  [ (unidadCodigo u, sum (map turistas (asignadasA u))) | u <- unidades ]
  where
    asignadas   = filter ((== Asignada) . estadoSolicitud) solicitudes
    asignadasA u = filter ((== Just (unidadCodigo u)) . unidadAsignada) asignadas

-- Pendientes: primero por prioridad (alta, media, baja), luego por codigo.
pendientesPorPrioridad :: [Solicitud] -> [Solicitud]
pendientesPorPrioridad =
  sortOn (\s -> (prioridad s, solicitudCodigo s))
    . filter ((== Pendiente) . estadoSolicitud)
