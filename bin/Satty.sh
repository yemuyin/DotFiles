#!/bin/bash

# Este script usa slurp y grim para capturar un área,
# canaliza la imagen a satty para edición, y luego guarda el resultado.
# Requiere: slurp, grim, satty.

DIR_DEST="$HOME/Imágenes/Capturas"
mkdir -p "$DIR_DEST"

# Nombre del archivo temporal para guardar la imagen final
FILENAME="satty_edit_$(date +'%Y-%m-%d_%H-%M-%S').png"
FILE_PATH="$DIR_DEST/$FILENAME"

# =====================================================================
# PASO 1: SELECCIONAR ÁREA Y CAPTURAR A SATTY
# =====================================================================

# slurp selecciona el área y grim -g toma la captura.
# Luego se canaliza (pipe) la imagen binaria directamente a satty.
# Satty -f %f le dice dónde guardar el resultado final.

grim -g "$(slurp)" - | satty -f - --output-filename "$FILE_PATH"

# NOTA: Satty esperará a que el usuario termine la edición y cierre la ventana.

# =====================================================================
# PASO 2: NOTIFICACIÓN Y PORTAPAPELES
# =====================================================================

if [ $? -eq 0 ] && [ -s "$FILE_PATH" ]; then
    # Copiar la imagen editada al portapapeles
    wl-copy < "$FILE_PATH"
    
    notify-send "🎨 Satty: Edición Finalizada" "Guardada: $FILENAME\nCopiado al portapapeles."
else
    # Si satty se cerró sin guardar o hubo algún error.
    notify-send "❌ Satty Cancelado" "No se guardó ninguna captura o la edición fue cancelada."
fi
