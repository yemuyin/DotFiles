#!/bin/sh

# Directorio donde se encuentran tus imágenes de fondo (BGs)
BG_DIR="/home/yemu/.BGs/backgrounds"

# Seleccionar una imagen aleatoria de forma robusta
# - Busca solo archivos (-type f)
# - Usa el separador nulo (-print0) para manejar nombres con espacios o caracteres especiales
# - Selecciona 1 archivo al azar (-n1 -z)
# - Pasa el resultado a xargs (-0) para limpiar el output
RANDOM_BG="$(find "$BG_DIR" -type f -print0 | shuf -n1 -z | xargs -0)"

# Verificar que se haya encontrado una imagen
if [ -z "$RANDOM_BG" ]; then
    echo "ERROR: No se encontró ninguna imagen de fondo en $BG_DIR." >&2
    # Si falla, lanza gtklock sin un fondo específico
    exec gtklock
fi

# 1. (Opcional) Asegúrate de que swww haya establecido el *wallpaper* normal.
# Si solo quieres cambiar el fondo de gtklock, esta línea ya NO es necesaria.
# Sin embargo, puedes dejarla si quieres que el fondo del escritorio cambie ANTES de bloquear.
# swww img "$RANDOM_BG" --transition-type outer --transition-step 30 --transition-fps 60

# 2. Ejecutar gtklock usando la opción -b para el fondo
# La variable $RANDOM_BG contiene la ruta a la imagen seleccionada al azar.
exec gtklock -b "$RANDOM_BG"
