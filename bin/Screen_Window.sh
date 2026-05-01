#!/bin/bash

# Este script usa la funcionalidad nativa de Niri para la captura 
# y luego usa wl-paste para guardar el archivo.
# Requiere: wl-clipboard (para wl-paste), notify-send (para Mako).
# NO requiere: grim, slurp, jq.

DIR_DEST="$HOME/Imágenes/ShotS"
FILENAME="screenshot_window_$(date +'%Y-%m-%d_%H-%M-%S').png"
FILE_PATH="$DIR_DEST/$FILENAME"

mkdir -p "$DIR_DEST"

# =====================================================================
# PASO 1: Ejecutar la función nativa de Niri para copiar la ventana
# =====================================================================

# Utilizamos 'niri msg action' para ejecutar el comando nativo de Niri.
# Esto copia la imagen de la ventana enfocada al portapapeles.
niri msg action screenshot-window

# Pequeña pausa para asegurar que Niri haya terminado de copiar la imagen al portapapeles
sleep 0.2

# =====================================================================
# PASO 2: Extraer y Guardar la imagen desde el portapapeles
# =====================================================================

# wl-paste -t image/png extrae la imagen del portapapeles.
# Si el portapapeles está vacío o no contiene una imagen, esto fallará.
wl-paste -t image/png > "$FILE_PATH"

if [ $? -eq 0 ] && [ -s "$FILE_PATH" ]; then
    # El archivo se guardó correctamente. La imagen ya está en el portapapeles.
    notify-send "✅ Captura Exitosa" "Ventana guardada: $FILENAME\nCopiado al portapapeles (Nativo)."
else
    notify-send "❌ Error" "Fallo al guardar la imagen. ¿Estaba la ventana enfocada?"
fi
