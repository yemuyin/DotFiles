#!/bin/bash

# Directorio de destino
VIDEOS_DIR="$HOME/Vídeos/ScreenCasts"
mkdir -p "$VIDEOS_DIR"

# Nombre del archivo con timestamp
FILENAME="grabacion_$(date +%Y%m%d_%H%M%S).mp4"
OUTPUT_FILE="$VIDEOS_DIR/$FILENAME"

# Seleccionar área con slurp
echo "Selecciona el área a grabar..."
AREA=$(slurp 2>/dev/null)

if [ -z "$AREA" ]; then
    echo "Selección cancelada"
    exit 0
fi

echo "Grabando área: $AREA"
echo "Presiona Ctrl+C para detener la grabación"
echo "Guardando en: $OUTPUT_FILE"

# Grabar con audio del sistema (usando PipeWire)
wf-recorder -g "$AREA" --audio -a alsa_output.pci-0000_04_00.6.analog-stereo.monitor -p preset=ultrafast -p crf=28 -f "$OUTPUT_FILE"

echo "-------------------------------------------"
echo "Grabación con audio guardada: $OUTPUT_FILE"
echo "Presiona ENTER para cerrar esta ventana"
read
