-- FA02: cotizacion de un plan turistico desde la agencia P000.
module SeleccionAtractivos (ejecutarSeleccionAtractivos) where

import CostoRuta (costoRuta)
import LecturaCSV (leerConexiones, leerUnidades)
import System.IO.Error (catchIOError)
import Text.Printf (printf)
import Text.Read (readMaybe)
import Tipos (Conexion, Unidad (..))
import Vecinos (vecinos)

data PuntoFA02 = PuntoFA02 String String

data EntradaFA02 = EntradaFA02 String Double Double Double Int

data AlternativaFA02 = AlternativaFA02 [String] String Int Double Int

separarCampos :: String -> [String]
separarCampos fila =
  case break (== ',') fila of
    (campo, []) -> [campo]
    (campo, _ : resto) -> campo : separarCampos resto

leerFilas :: FilePath -> IO [String]
leerFilas ruta = do
  contenido <- readFile ruta
  return (drop 1 (lines contenido))

leerCSV :: (String -> Maybe a) -> FilePath -> IO (Maybe [a])
leerCSV parsear ruta = catchIOError (leerArchivo parsear ruta) manejarError

leerArchivo :: (String -> Maybe a) -> FilePath -> IO (Maybe [a])
leerArchivo parsear ruta = do
  filas <- leerFilas ruta
  case traverse parsear filas of
    Nothing -> return Nothing
    Just datos -> length datos `seq` return (Just datos)

manejarError :: IOError -> IO (Maybe [a])
manejarError _ = return Nothing

leerSeguro :: IO (Maybe [a]) -> IO (Maybe [a])
leerSeguro accion = catchIOError (comprobarResultado accion) manejarError

comprobarResultado :: IO (Maybe [a]) -> IO (Maybe [a])
comprobarResultado accion = do
  resultado <- accion
  case resultado of
    Nothing -> return Nothing
    Just datos -> length datos `seq` return (Just datos)

parsearPunto :: String -> Maybe PuntoFA02
parsearPunto fila =
  case separarCampos fila of
    [codigo, _, tipo, _] -> Just (PuntoFA02 codigo tipo)
    _ -> Nothing

parsearEntrada :: String -> Maybe EntradaFA02
parsearEntrada fila =
  case separarCampos fila of
    [codigo, precioGeneral, precioEstudiante, precioNino, minutos] -> do
      general <- readMaybe precioGeneral
      estudiante <- readMaybe precioEstudiante
      nino <- readMaybe precioNino
      duracion <- readMaybe minutos
      if general >= 0 && estudiante >= 0 && nino >= 0 && duracion > 0
        then Just (EntradaFA02 codigo general estudiante nino duracion)
        else Nothing
    _ -> Nothing

buscarPunto :: String -> [PuntoFA02] -> Maybe PuntoFA02
buscarPunto _ [] = Nothing
buscarPunto codigo (punto@(PuntoFA02 codigoActual _) : restantes)
  | codigo == codigoActual = Just punto
  | otherwise = buscarPunto codigo restantes

buscarEntrada :: String -> [EntradaFA02] -> Maybe EntradaFA02
buscarEntrada _ [] = Nothing
buscarEntrada codigo (entrada@(EntradaFA02 codigoActual _ _ _ _) : restantes)
  | codigo == codigoActual = Just entrada
  | otherwise = buscarEntrada codigo restantes

-- Cada ruta comienza en P000. Los puntos ya visitados no pueden repetirse.
generarRutas :: String -> [Conexion] -> [String] -> [[String]]
generarRutas punto conexiones ruta =
  ruta : extenderRutas (vecinos punto conexiones) conexiones ruta

extenderRutas :: [String] -> [Conexion] -> [String] -> [[String]]
extenderRutas [] _ _ = []
extenderRutas (siguiente : restantes) conexiones ruta
  | siguiente `elem` ruta = extenderRutas restantes conexiones ruta
  | otherwise =
      generarRutas siguiente conexiones (ruta ++ [siguiente])
        ++ extenderRutas restantes conexiones ruta

quitarRutaSinVisitas :: [[String]] -> [[String]]
quitarRutaSinVisitas [] = []
quitarRutaSinVisitas (ruta : restantes)
  | length ruta > 1 = ruta : quitarRutaSinVisitas restantes
  | otherwise = quitarRutaSinVisitas restantes

rutasDesdeAgencia :: [Conexion] -> [[String]]
rutasDesdeAgencia conexiones =
  quitarRutaSinVisitas (generarRutas "P000" conexiones ["P000"])

visitasDeRuta :: [String] -> [String]
visitasDeRuta [] = []
visitasDeRuta (_ : visitas) = visitas

costoPorPerfiles :: Int -> Int -> Int -> EntradaFA02 -> Double
costoPorPerfiles generales estudiantes ninos (EntradaFA02 _ precioGeneral precioEstudiante precioNino _) =
  fromIntegral generales * precioGeneral
    + fromIntegral estudiantes * precioEstudiante
    + fromIntegral ninos * precioNino

calcularVisitas :: [String] -> [PuntoFA02] -> [EntradaFA02] -> Int -> Int -> Int -> Maybe (Double, Int)
calcularVisitas [] _ _ _ _ _ = Just (0, 0)
calcularVisitas (codigo : restantes) puntos entradas generales estudiantes ninos =
  case (buscarPunto codigo puntos, buscarEntrada codigo entradas) of
    (Just (PuntoFA02 _ tipo), Just entrada@(EntradaFA02 _ _ _ _ minutos)) ->
      case calcularVisitas restantes puntos entradas generales estudiantes ninos of
        Nothing -> Nothing
        Just (costoRestante, tiempoRestante) ->
          if tipo == "atractivo"
            then Just (costoPorPerfiles generales estudiantes ninos entrada + costoRestante, minutos + tiempoRestante)
            else Just (costoRestante, minutos + tiempoRestante)
    _ -> Nothing

unidadCompatible :: Int -> Unidad -> Bool
unidadCompatible cantidad (Unidad _ _ capacidad _ estado) =
  estado == "disponible" && capacidad >= cantidad

esMejorUnidad :: Unidad -> Unidad -> Bool
esMejorUnidad (Unidad codigoA tipoA _ costoA _) (Unidad codigoB tipoB _ costoB _) =
  tipoA == tipoB
    && (costoA < costoB || (costoA == costoB && codigoA < codigoB))

existeUnidadMejor :: Unidad -> [Unidad] -> Bool
existeUnidadMejor _ [] = False
existeUnidadMejor unidad (otra : restantes)
  | esMejorUnidad otra unidad = True
  | otherwise = existeUnidadMejor unidad restantes

unidadesCompatibles :: Int -> [Unidad] -> [Unidad]
unidadesCompatibles cantidad unidades =
  [ unidad
  | unidad <- unidades
  , unidadCompatible cantidad unidad
  ]

seleccionarUnidadesBaratas :: [Unidad] -> [Unidad]
seleccionarUnidadesBaratas unidades =
  [unidad | unidad <- unidades, not (existeUnidadMejor unidad unidades)]

unidadesRecomendadas :: Int -> [Unidad] -> [Unidad]
unidadesRecomendadas cantidad unidades =
  seleccionarUnidadesBaratas (unidadesCompatibles cantidad unidades)

crearAlternativa :: [String] -> Unidad -> [Conexion] -> [PuntoFA02] -> [EntradaFA02] -> Int -> Int -> Int -> Double -> Int -> Maybe AlternativaFA02
crearAlternativa ruta (Unidad _ tipo _ costoKm _) conexiones puntos entradas generales estudiantes ninos presupuesto tiempoMaximo =
  case costoRuta ruta conexiones of
    (_, _, False) -> Nothing
    (distancia, tiempoRuta, True) ->
      case calcularVisitas (visitasDeRuta ruta) puntos entradas generales estudiantes ninos of
        Nothing -> Nothing
        Just (costoEntradas, tiempoVisitas) ->
          validarAlternativa ruta tipo costoEntradas distancia costoKm tiempoRuta tiempoVisitas presupuesto tiempoMaximo

validarAlternativa :: [String] -> String -> Double -> Double -> Double -> Int -> Int -> Double -> Int -> Maybe AlternativaFA02
validarAlternativa ruta tipo costoEntradas distancia costoKm tiempoRuta tiempoVisitas presupuesto tiempoMaximo =
  crearAlternativaValida
    ruta
    tipo
    (costoEntradas + distancia * costoKm)
    (tiempoRuta + tiempoVisitas)
    presupuesto
    tiempoMaximo

crearAlternativaValida :: [String] -> String -> Double -> Int -> Double -> Int -> Maybe AlternativaFA02
crearAlternativaValida ruta tipo costoTotal tiempoTotal presupuesto tiempoMaximo
  | costoTotal <= presupuesto && tiempoTotal <= tiempoMaximo =
      Just (AlternativaFA02 ruta tipo (length (visitasDeRuta ruta)) costoTotal tiempoTotal)
  | otherwise = Nothing

alternativasPorUnidades :: [Unidad] -> [String] -> [Conexion] -> [PuntoFA02] -> [EntradaFA02] -> Int -> Int -> Int -> Double -> Int -> [AlternativaFA02]
alternativasPorUnidades [] _ _ _ _ _ _ _ _ _ = []
alternativasPorUnidades (unidad : restantes) ruta conexiones puntos entradas generales estudiantes ninos presupuesto tiempoMaximo =
  case crearAlternativa ruta unidad conexiones puntos entradas generales estudiantes ninos presupuesto tiempoMaximo of
    Nothing -> alternativasPorUnidades restantes ruta conexiones puntos entradas generales estudiantes ninos presupuesto tiempoMaximo
    Just alternativa -> alternativa : alternativasPorUnidades restantes ruta conexiones puntos entradas generales estudiantes ninos presupuesto tiempoMaximo

alternativasPorRutas :: [[String]] -> [Unidad] -> [Conexion] -> [PuntoFA02] -> [EntradaFA02] -> Int -> Int -> Int -> Double -> Int -> [AlternativaFA02]
alternativasPorRutas [] _ _ _ _ _ _ _ _ _ = []
alternativasPorRutas (ruta : restantes) unidades conexiones puntos entradas generales estudiantes ninos presupuesto tiempoMaximo =
  alternativasPorUnidades unidades ruta conexiones puntos entradas generales estudiantes ninos presupuesto tiempoMaximo
    ++ alternativasPorRutas restantes unidades conexiones puntos entradas generales estudiantes ninos presupuesto tiempoMaximo

esMejorAlternativa :: AlternativaFA02 -> AlternativaFA02 -> Bool
esMejorAlternativa (AlternativaFA02 _ _ visitasA costoA tiempoA) (AlternativaFA02 _ _ visitasB costoB tiempoB)
  | visitasA /= visitasB = visitasA > visitasB
  | costoA /= costoB = costoA < costoB
  | otherwise = tiempoA < tiempoB

insertarAlternativa :: AlternativaFA02 -> [AlternativaFA02] -> [AlternativaFA02]
insertarAlternativa alternativa [] = [alternativa]
insertarAlternativa alternativa (actual : restantes)
  | esMejorAlternativa alternativa actual = alternativa : actual : restantes
  | otherwise = actual : insertarAlternativa alternativa restantes

ordenarAlternativas :: [AlternativaFA02] -> [AlternativaFA02]
ordenarAlternativas [] = []
ordenarAlternativas (alternativa : restantes) =
  insertarAlternativa alternativa (ordenarAlternativas restantes)

unirRuta :: String -> [String] -> String
unirRuta _ [] = ""
unirRuta _ [punto] = punto
unirRuta separador (punto : restantes) = punto ++ separador ++ unirRuta separador restantes

mostrarAlternativas :: [AlternativaFA02] -> IO ()
mostrarAlternativas [] = putStrLn "No se encontraron alternativas dentro del presupuesto y tiempo disponibles."
mostrarAlternativas alternativas = do
  putStrLn "=== Alternativas generadas por Haskell ==="
  putStrLn ""
  mostrarAlternativasDesde 1 alternativas

mostrarAlternativasDesde :: Int -> [AlternativaFA02] -> IO ()
mostrarAlternativasDesde _ [] = return ()
mostrarAlternativasDesde numero (AlternativaFA02 ruta tipo visitas costo tiempo : restantes) = do
  putStrLn (show numero ++ ". " ++ unirRuta " -> " ruta)
  putStrLn ("   Visitas: " ++ show visitas)
  putStrLn ("   Transporte recomendado: " ++ tipo)
  printf "   Costo total: S/ %.2f\n" costo
  putStrLn ("   Tiempo total: " ++ show tiempo ++ " min")
  putStrLn ("FA02_DATA|" ++ show numero ++ "|" ++ unirRuta ">" ruta ++ "|" ++ tipo ++ "|" ++ show visitas ++ "|" ++ printf "%.2f" costo ++ "|" ++ show tiempo)
  putStrLn ""
  mostrarAlternativasDesde (numero + 1) restantes

mostrarError :: String -> IO ()
mostrarError mensaje = putStrLn ("FA02_ERROR|" ++ mensaje)

crearAlternativas :: Int -> Int -> Int -> Double -> Int -> [PuntoFA02] -> [Conexion] -> [Unidad] -> [EntradaFA02] -> [AlternativaFA02]
crearAlternativas generales estudiantes ninos presupuesto tiempoMaximo puntos conexiones unidades entradas =
  alternativasPorRutas
    (rutasDesdeAgencia conexiones)
    (unidadesRecomendadas (generales + estudiantes + ninos) unidades)
    conexiones
    puntos
    entradas
    generales
    estudiantes
    ninos
    presupuesto
    tiempoMaximo

mejoresAlternativas :: Int -> Int -> Int -> Double -> Int -> [PuntoFA02] -> [Conexion] -> [Unidad] -> [EntradaFA02] -> [AlternativaFA02]
mejoresAlternativas generales estudiantes ninos presupuesto tiempoMaximo puntos conexiones unidades entradas =
  take 3
    ( ordenarAlternativas
        (crearAlternativas generales estudiantes ninos presupuesto tiempoMaximo puntos conexiones unidades entradas)
    )

generarAlternativas :: Int -> Int -> Int -> Double -> Int -> [PuntoFA02] -> [Conexion] -> [Unidad] -> [EntradaFA02] -> IO ()
generarAlternativas generales estudiantes ninos presupuesto tiempoMaximo puntos conexiones unidades entradas =
  case buscarPunto "P000" puntos of
    Nothing -> mostrarError "No existe la agencia P000 en puntos.csv."
    Just _ ->
      mostrarAlternativas
        (mejoresAlternativas generales estudiantes ninos presupuesto tiempoMaximo puntos conexiones unidades entradas)

procesarDatos :: Int -> Int -> Int -> Double -> Int -> Maybe [PuntoFA02] -> Maybe [Conexion] -> Maybe [Unidad] -> Maybe [EntradaFA02] -> IO ()
procesarDatos _ _ _ _ _ Nothing _ _ _ = mostrarError "No se pudo leer puntos.csv."
procesarDatos _ _ _ _ _ _ Nothing _ _ = mostrarError "No se pudo leer conexiones.csv."
procesarDatos _ _ _ _ _ _ _ Nothing _ = mostrarError "No se pudo leer unidades.csv."
procesarDatos _ _ _ _ _ _ _ _ Nothing = mostrarError "No se pudo leer entradas.csv."
procesarDatos generales estudiantes ninos presupuesto tiempoMaximo (Just puntos) (Just conexiones) (Just unidades) (Just entradas) =
  generarAlternativas generales estudiantes ninos presupuesto tiempoMaximo puntos conexiones unidades entradas

leerEntero :: String -> Maybe Int
leerEntero = readMaybe

leerDecimal :: String -> Maybe Double
leerDecimal = readMaybe

ejecutarSeleccionAtractivos :: FilePath -> String -> String -> String -> String -> String -> IO ()
ejecutarSeleccionAtractivos carpetaDatos generalesTexto estudiantesTexto ninosTexto presupuestoTexto tiempoTexto =
  case (leerEntero generalesTexto, leerEntero estudiantesTexto, leerEntero ninosTexto, leerDecimal presupuestoTexto, leerEntero tiempoTexto) of
    (Just generales, Just estudiantes, Just ninos, Just presupuesto, Just tiempoMaximo)
      | generales >= 0 && estudiantes >= 0 && ninos >= 0
          && generales + estudiantes + ninos > 0
          && presupuesto > 0
          && tiempoMaximo > 0 -> do
          puntos <- leerCSV parsearPunto (carpetaDatos ++ "/puntos.csv")
          conexiones <- leerSeguro (leerConexiones (carpetaDatos ++ "/conexiones.csv"))
          unidades <- leerSeguro (leerUnidades (carpetaDatos ++ "/unidades.csv"))
          entradas <- leerCSV parsearEntrada (carpetaDatos ++ "/entradas.csv")
          procesarDatos generales estudiantes ninos presupuesto tiempoMaximo puntos conexiones unidades entradas
    _ -> mostrarError "Revisa las cantidades, el presupuesto y el tiempo ingresados."
