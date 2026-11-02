#!/usr/bin/env bash
# Demostracion de los tres modulos sobre una copia de _datos/ (macOS o Linux).
# Uso, desde cualquier carpeta:  ./demo.sh
# No modifica _datos/ ni deja binarios en el proyecto: todo se crea en un
# directorio temporal que se borra al terminar.

set -u

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cd "$RAIZ" || exit 1
mkdir "$TMP/trabajo"
cp -R _datos "$TMP/trabajo/_datos"
DATOS="$TMP/trabajo/_datos"
FALLOS=0

titulo() { printf '\n==== %s ====\n' "$1"; }

# runghc puede ser una funcion del perfil de zsh (no existe en un script de bash).
correr_haskell() {
    if command -v runghc >/dev/null 2>&1; then
        runghc -ihaskell/src haskell/app/Main.hs "$@"
    else
        zsh -ic 'runghc -ihaskell/src haskell/app/Main.hs "$@"' _ "$@"
    fi
}

titulo "1. C++ (g++ -std=c++17): reporte general y solicitudes de U001"
if g++ -std=c++17 -Wall -Wextra -Icpp/include -o "$TMP/turismo" cpp/src/*.cpp cpp/src/fa/*.cpp; then
    # Menu: 4 Reporte; 3 > 4 Solicitudes de una unidad (U001); 0 Salir.
    printf '4\n3\n4\nU001\n0\n0\n' | "$TMP/turismo" "$DATOS" || FALLOS=$((FALLOS + 1))
else
    echo "No se pudo compilar el modulo C++ (cpp/src/*.cpp cpp/src/fa/*.cpp)"
    FALLOS=$((FALLOS + 1))
fi

titulo "2. Haskell: solicitud pendiente de mayor prioridad (S004)"
correr_haskell "$DATOS" || FALLOS=$((FALLOS + 1))

titulo "3. Prolog: lectura de CSV (prolog/app/main.pl)"
swipl prolog/app/main.pl -- "$DATOS" || FALLOS=$((FALLOS + 1))

titulo "4. Prolog: un ejemplo de cada regla (prolog/app/demo.pl)"
swipl prolog/app/demo.pl -- "$DATOS" || FALLOS=$((FALLOS + 1))

titulo "5. Prolog: pruebas plunit"
swipl -q -g run_tests -t halt prolog/tests/pruebas.pl 2>&1 || FALLOS=$((FALLOS + 1))

# Funcionalidades adicionales. Cada integrante edita solo su bloque y deja las
# lineas de separacion como estan, asi las tres ramas se fusionan sin conflictos.
# Para contar un fallo: <comando> || FALLOS=$((FALLOS + 1))

# >>> FA01 Samantha Rodriguez (solo la edita Samantha)
titulo "6. FA01 de Samantha Rodriguez"
echo "Pendiente."
# <<< FA01 Samantha Rodriguez

# >>> FA02 Melissa Ruiz (solo la edita Melissa)
titulo "7. FA02 de Melissa Ruiz"
echo "Pendiente."
# <<< FA02 Melissa Ruiz

# >>> FA03 Jefferson Sanchez (solo la edita Jefferson)
titulo "8. FA03 de Jefferson Sanchez"
echo "Pendiente."
# <<< FA03 Jefferson Sanchez

titulo "Resultado"
if [ "$FALLOS" -eq 0 ]; then
    echo "Demo completa sin fallos. Se borro el directorio temporal."
else
    echo "Hubo $FALLOS paso(s) con error."
    exit 1
fi
