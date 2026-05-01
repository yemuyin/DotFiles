#!/bin/bash

# Este script usa slurp y grim para capturar un área,
# canaliza la imagen a un archivo temporal, la edita con swappy,
# y luego mueve el resultado final a la carpeta de destino.
# Requiere: slurp, grim, swappy.

# Directorio de destino
DIR_DEST="$HOME/Imágenes/Capturas"
mkdir -p "$DIR_DEST"

# Nombre del archivo FINAL para guardar el resultado (después de la edición)
FILENAME="swappy_edit_$(date +'%Y-%m-%d_%H-%M-%S').png"
FILE_PATH_FINAL="$DIR_DEST/$FILENAME"

# Archivo TEMPORAL para la captura inicial antes de pasar a swappy
# Usamos mktemp para crear un archivo seguro y único.
FILE_PATH_TEMP=$(mktemp --suffix=.png)

# =====================================================================
# PASO 1: SELECCIONAR ÁREA Y CAPTURAR AL ARCHIVO TEMPORAL
# =====================================================================

# slurp selecciona el área y grim -g toma la captura, guardándola en el temporal.
grim -g "$(slurp)" "$FILE_PATH_TEMP"

# Verificar que la captura inicial se haya realizado correctamente
if [ $? -ne 0 ] || [ ! -s "$FILE_PATH_TEMP" ]; then
    notify-send "❌ Captura Cancelada" "La selección o captura con slurp/grim fue cancelada o falló."
    rm -f "$FILE_PATH_TEMP" # Limpiar el temporal
    exit 1
fi

# =====================================================================
# PASO 2: ABRIR SWAPPY PARA EDICIÓN
# =====================================================================

# swappy abre el archivo temporal. Cuando el usuario hace "Save",
# swappy guarda la imagen editada en el mismo archivo temporal.
swappy -f "$FILE_PATH_TEMP"

# =====================================================================
# PASO 3: MOVER, NOTIFICACIÓN Y PORTAPAPELES
# =====================================================================

# Verificar que swappy no haya dejado un archivo vacío
if [ -s "$FILE_PATH_TEMP" ]; then
    # Mover el archivo editado (temporal) a la ruta final
    mv "$FILE_PATH_TEMP" "$FILE_PATH_FINAL"
    
    # Copiar la imagen editada al portapapeles
    wl-copy < "$FILE_PATH_FINAL"
    
    notify-send "✏️ Swappy: Edición Finalizada" "Guardada: $FILENAME\nCopiado al portapapeles."
else
    # Si el archivo temporal está vacío (swappy fue cerrado sin guardar/cancelado)
    notify-send "❌ Swappy Cancelado" "No se guardó ninguna edición o el proceso fue cancelado."
fi

# El archivo temporal se limpia automáticamente si el script termina bien.
# Si hubo error antes de swappy, ya lo limpiamos.
