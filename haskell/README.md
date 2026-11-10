# Módulo Haskell

Implementación funcional del dominio turístico. Requiere GHC y Cabal.

## Compilar y ejecutar

```bash
cabal build
cabal run turismo-haskell
```

Desde la raíz del repositorio, se puede indicar la carpeta compartida:

```bash
cabal run --project-dir=haskell turismo-haskell -- _datos
```

El menú carga `conexiones.csv` y `solicitudes.csv`. La opción 4.2.6 muestra
el total de solicitudes, su distribución por estado, la cantidad total de
turistas y el detalle de cada solicitud. El reporte usa `filter` para contar
estados y recursión para sumar turistas y generar las líneas. La opción 4.2.7
imprime un ejemplo de vecinos habilitados junto con el reporte para ilustrar
el resultado del módulo.

## Ejecutar pruebas

```bash
cabal test
```

