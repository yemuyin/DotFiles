#!/bin/bash
# Rorsach Edition: Fastfetch + Chafa Integration

# --- Variables ---
# Asegúrate de que esta ruta apunte a tu nuevo Rorsach3.jsonc
FASTFETCH_CONFIG="$HOME/.config/fastfetch/Rorfetch4.jsonc"
AVATARS_DIR="$HOME/.Avatares"
TEMP_LOGO="/tmp/fastfetch_chafa_logo.txt"

# 1. Seleccionar una imagen aleatoria
IMAGEN_ALEATORIA=$(find "$AVATARS_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) | shuf -n 1)

# 2. Verificar si se encontró una imagen
if [ -z "$IMAGEN_ALEATORIA" ]; then
    echo "Error: No hay avatares en $AVATARS_DIR"
    # Si falla, lanzamos fastfetch normal sin logo
    fastfetch --config "$FASTFETCH_CONFIG" --logo none
    exit 1
fi

# 3. Generar el logo ASCII/ANSI con Chafa
# Ajustamos el tamaño a 40 de ancho para que encaje bien a la izquierda del texto
chafa --symbols sextant --size 40x20 --colors 256 "$IMAGEN_ALEATORIA" > "$TEMP_LOGO"

# 4. Lanzar Fastfetch usando el archivo temporal como logo
# Forzamos el tipo 'ascii' para que interprete los códigos de color de Chafa
fastfetch --config "$FASTFETCH_CONFIG" \
          --logo-source "$TEMP_LOGO" \
          --logo-type ascii \
          --logo-width 42 \
          --logo-padding-right 4

# Opcional: limpiar el temporal
# rm "$TEMP_LOGO"
