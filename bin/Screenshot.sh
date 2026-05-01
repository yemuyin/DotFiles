#!/bin/bash

# Directorio de destino y nombre del archivo
# Asegúrate de que $HOME/Imágenes existe o ajusta la ruta
DIR_DEST="$HOME/Imágenes/ShotS"
# Nombra el archivo con la fecha y hora para evitar sobrescribir
FILENAME="screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"
FILE_PATH="$DIR_DEST/$FILENAME"

# Crear el directorio si no existe
mkdir -p "$DIR_DEST"

# 1. Seleccionar el área con slurp
# slurp -d da las coordenadas del área seleccionada.
GEOMETRY=$(slurp -d)

# Verificar si se canceló la selección (ej. presionando ESC)
if [ -z "$GEOMETRY" ]; then
    notify-send -t 3000 "📸 Captura Cancelada" "No se seleccionó ninguna área."
    exit 0
fi

# 2. Tomar la captura con grim usando las coordenadas de slurp
# grim -g GEOMETRY toma la captura solo del área especificada.
grim -g "$GEOMETRY" "$FILE_PATH"

# Verificar si grim fue exitoso
if [ $? -eq 0 ]; then
    
    # 3. Copiar la imagen al portapapeles (wl-copy, proporcionado por wl-clipboard)
    wl-copy < "$FILE_PATH"

    # 4. Mostrar notificación de éxito (Enviado a Mako)
    notify-send "✅ Captura Exitosa" "Guardado: $FILENAME\nCopiado al portapapeles."
else
    notify-send "❌ Error" "Fallo al tomar la captura con grim."
fi
