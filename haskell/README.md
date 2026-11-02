# Módulo Haskell

Implementación funcional del dominio turístico. Lee los CSV de [`_datos/`](../_datos/README.md),
calcula vecinos, rutas posibles y costos, y genera el reporte de solicitudes. Requiere GHC y Cabal.

## Estructura

| Archivo | Funcionalidad | Responsable |
|---|---|---|
| `src/LecturaCSV.hs` | 4.2.1 Lectura de CSV | Jefferson Sanchez |
| `src/Tipos.hs` | 4.2.2 Tipos propios (compartido) | Jefferson Sanchez |
| `src/Rutas.hs` | 4.2.3 Vecinos, 4.2.4 Rutas posibles y 4.2.5 Costo de una ruta | Melissa Ruíz |
| `src/Reportes.hs` | 4.2.6 Reporte de solicitudes | Samantha Rodriguez |
| `app/Main.hs` | 4.2.7 Programa principal | Samantha Rodriguez |
| `src/FA/<Nombre>.hs` | Funcionalidades adicionales | Cada autor |

## Compilar y ejecutar

Desde la carpeta `haskell/`:

```bash
cabal build
cabal run turismo-haskell -- ../_datos                                # solicitud pendiente de mayor prioridad
cabal run turismo-haskell -- ../_datos S006                           # una solicitud concreta
cabal run turismo-haskell -- ../_datos S004 P011,P007,P006,P004       # además, costo de la ruta dada
cabal run turismo-haskell -- ../_datos --fa melissa                   # funcionalidad adicional de un integrante
```

Los argumentos son `[carpeta] [codigo_solicitud] [ruta]`. La ruta se separa con comas o guiones. En
PowerShell va entre comillas (`"P011,P007,P006,P004"`), porque sin ellas PowerShell la parte en varios
argumentos.

Sin Cabal, desde la raíz del repositorio:

```bash
runghc -ihaskell/src haskell/app/Main.hs _datos
```

Para evaluar una función pura:

```bash
ghc -ihaskell/src -e 'costoRuta [Conexion "C001" "P001" "P002" 0.8 10 Habilitada] ["P001","P002"]' haskell/src/Rutas.hs
# Right (0.8,10)
```
