# Guía de instalación

Herramientas necesarias para compilar y ejecutar los tres módulos del proyecto en Windows y macOS. La instalación se hace una sola vez por equipo.

| Módulo | Herramientas | Comprobación |
|---|---|---|
| C++ | CMake 3.16 o posterior y un compilador con C++17 | `cmake --version` |
| Haskell | GHC y Cabal, instalados con GHCup | `ghc --version` y `cabal --version` |
| Prolog | SWI-Prolog | `swipl --version` |

## Windows

Todos los comandos se ejecutan en PowerShell, sin permisos de administrador.

### 1. C++

CMake genera el proyecto y las Build Tools de Visual Studio aportan el compilador. Las Build Tools pesan varios GB y tardan unos minutos.

```powershell
winget install Kitware.CMake
winget install Microsoft.VisualStudio.2022.BuildTools --override "--passive --wait --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"
```

Si `winget` no está disponible, CMake se descarga desde [cmake.org/download](https://cmake.org/download/) con la casilla **Add CMake to the system PATH** marcada, y las Build Tools desde [visualstudio.microsoft.com/downloads](https://visualstudio.microsoft.com/downloads/) con la carga de trabajo **Desarrollo para el escritorio con C++**.

### 2. Haskell

El instalador pregunta algunas opciones y sirven las predeterminadas. HLS y Stack no se necesitan.

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force;[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; try { & ([ScriptBlock]::Create((Invoke-WebRequest https://www.haskell.org/ghcup/sh/bootstrap-haskell.ps1 -UseBasicParsing))) -Interactive -DisableCurl } catch { Write-Error $_ }
```

El comando vigente está en [haskell.org/ghcup](https://www.haskell.org/ghcup/).

### 3. Prolog

```powershell
winget install SWI-Prolog.SWI-Prolog
```

También sirve el instalador de [swi-prolog.org/Download.html](https://www.swi-prolog.org/Download.html).

### 4. Abrir una terminal nueva

El `PATH` se lee al abrir el programa. Hay que cerrar todas las ventanas del editor (VS Code, Antigravity u otro) y de PowerShell, y abrir una nueva. Una pestaña nueva dentro de la misma ventana del editor no actualiza el `PATH`.

## macOS

```bash
xcode-select --install
brew install cmake swi-prolog
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

`xcode-select` instala el compilador (Apple clang). Homebrew se instala desde [brew.sh](https://brew.sh/) si aún no existe. Al terminar GHCup, se abre una terminal nueva.

## Comprobar la instalación

```bash
cmake --version
ghc --version
cabal --version
swipl --version
```

Los cuatro comandos deben mostrar una versión. En Windows, el compilador se comprueba al compilar el módulo C++.

## Compilar y ejecutar

### C++ (desde `cpp/`)

```bash
cmake -S . -B build
cmake --build build --config Debug
```

El ejecutable queda en `build\Debug\turismo_cpp.exe` en Windows y en `./build/turismo_cpp` en macOS.

### Haskell (desde `haskell/`)

```bash
cabal update
cabal build
cabal run turismo-haskell
```

`cabal update` solo se necesita la primera vez.

### Prolog (desde la raíz del repositorio)

```bash
swipl prolog/app/main.pl -- _datos
```

## Problemas frecuentes

| Mensaje | Causa y solución |
|---|---|
| `cmake` no se reconoce como un comando | La terminal se abrió antes de instalar y conserva el `PATH` anterior. Se cierra el editor por completo y se abre de nuevo. Si persiste, `where cmake` no debe salir vacío. Si CMake está en `C:\Program Files\CMake\bin`, esa carpeta se agrega al `Path` de las variables de entorno del usuario. |
| `No CMAKE_CXX_COMPILER could be found` | Falta el compilador. Se instalan las Build Tools con la carga de trabajo de C++, se borra la carpeta `build` y se repite `cmake -S . -B build`. |
| `ghc` o `cabal` no se reconocen | Se abre una terminal nueva tras instalar GHCup. Si persiste, se vuelve a ejecutar el comando de GHCup. |
| `swipl` no se reconoce | Se agrega la carpeta `bin` de SWI-Prolog (normalmente `C:\Program Files\swipl\bin`) al `Path`, como indica [`prolog/README.md`](prolog/README.md). |
