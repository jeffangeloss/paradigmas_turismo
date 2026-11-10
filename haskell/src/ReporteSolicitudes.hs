-- 4.2.6 Reporte de solicitudes.
module ReporteSolicitudes(reporteSolicitudes, ejecutarReporteSolicitudes) where

import Tipos (Solicitud (..))

reporteSolicitudes :: [Solicitud] -> String
reporteSolicitudes solicitudes =
  let pendientes = contarEstado "pendiente" solicitudes
      asignadas = contarEstado "asignada" solicitudes
      entregadas = contarEstado "entregada" solicitudes
      totalTuristas = sumarTuristas solicitudes
      encabezado =
        [ "=== Reporte de solicitudes ==="
        , "Total: " ++ show (length solicitudes)
        , "Pendientes: " ++ show pendientes
        , "Asignadas: " ++ show asignadas
        , "Entregadas: " ++ show entregadas
        , "Turistas solicitantes: " ++ show totalTuristas
        ]
   in unirLineas (encabezado ++ lineasSolicitudes solicitudes)

contarEstado :: String -> [Solicitud] -> Int
contarEstado estado solicitudes = length (filter (esEstado estado) solicitudes)
  where
    esEstado esperado (Solicitud _ _ _ _ _ actual _) = esperado == actual

sumarTuristas :: [Solicitud] -> Int
sumarTuristas [] = 0
sumarTuristas (Solicitud _ _ _ cantidad _ _ _ : resto) =
  cantidad + sumarTuristas resto

lineasSolicitudes :: [Solicitud] -> [String]
lineasSolicitudes [] = []
lineasSolicitudes (solicitud : resto) =
  mostrarSolicitud solicitud : lineasSolicitudes resto

unirLineas :: [String] -> String
unirLineas [] = ""
unirLineas [linea] = linea
unirLineas (linea : resto) = linea ++ "\n" ++ unirLineas resto

mostrarSolicitud :: Solicitud -> String
mostrarSolicitud (Solicitud codigo origen destino cantidad prioridad estado unidad) =
  " - " ++ codigo ++ ": " ++ origen ++ " -> " ++ destino
    ++ " | turistas: " ++ show cantidad
    ++ " | prioridad: " ++ prioridad
    ++ " | estado: " ++ estado
    ++ " | unidad: " ++ mostrarUnidad unidad

mostrarUnidad :: Maybe String -> String
mostrarUnidad Nothing = "sin asignar"
mostrarUnidad (Just codigo) = codigo

ejecutarReporteSolicitudes :: [Solicitud] -> IO ()
ejecutarReporteSolicitudes solicitudes =
  putStrLn (reporteSolicitudes solicitudes)
