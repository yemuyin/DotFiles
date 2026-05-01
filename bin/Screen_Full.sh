#!/bin/bash

DIR_DEST="$HOME/Imágenes/ShotS"
FILENAME="screenshot_full_$(date +'%Y-%m-%d_%H-%M-%S').png"
FILE_PATH="$DIR_DEST/$FILENAME"

mkdir -p "$DIR_DEST"

# grim sin argumentos captura la pantalla completa
grim "$FILE_PATH"

if [ $? -eq 0 ]; then
    wl-copy < "$FILE_PATH"
    notify-send "✅ Captura Exitosa" "Guardado: $FILENAME\nCopiado al portapapeles."
else
    notify-send "❌ Error" "Fallo al tomar la captura de pantalla completa con grim."
fi
