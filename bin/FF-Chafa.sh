#!/bin/bash
# Script para mostrar fastfetch sin logo seguido de una imagen aleatoria con chafa.

# --- Variables ---
FASTFETCH_CONFIG="//home/yemu/.config/fastfetch/RorfetchABC.jsonc"
AVATARS_DIR="/home/yemu/.Avatares/Gruvbox_Avatares/"

# 1. Mostrar Fastfetch sin logo
# Usamos --logo none y el archivo de configuración específico.

fastfetch --config "$FASTFETCH_CONFIG" --logo none

# 2. Seleccionar una imagen aleatoria
# find busca todos los archivos (incluyendo png, jpg, etc.) en el directorio.
# shuf selecciona uno al azar.
IMAGEN_ALEATORIA=$(find "$AVATARS_DIR" -type f | shuf -n 1)

# 3. Verificar si se encontró una imagen
if [ -z "$IMAGEN_ALEATORIA" ]; then
    echo "Advertencia: No se encontraron imágenes en $AVATARS_DIR para chafa."
    exit 0
fi

# 4. Mostrar la imagen con chafa

# chafa: -s (tamaño, puedes ajustarlo), -c (color), --fill (ajusta el tamaño a la terminal)
chafa --animate off --size 50x20 --colors 256 "$IMAGEN_ALEATORIA"

# Nota: Puedes ajustar '--size 25x10' (ancho x alto) para cambiar el tamaño del arte ASCII.
