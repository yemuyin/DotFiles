#!/bin/bash

# Directorio de destino
VIDEOS_DIR="$HOME/Vídeos/ScreenCasts"
mkdir -p "$VIDEOS_DIR"

# Nombre del archivo con timestamp
FILENAME="pantalla_completa_$(date +%Y%m%d_%H%M%S).mp4"
OUTPUT_FILE="$VIDEOS_DIR/$FILENAME"

echo "Iniciando grabación de pantalla completa con audio..."
echo "Presiona Ctrl+C para detener la grabación"
echo "Guardando en: $OUTPUT_FILE"

# Grabar pantalla completa con audio
# Plan B: Si Pipewire falla, forzamos el Monitor de Pulse
wf-recorder --audio -a alsa_output.pci-0000_04_00.6.analog-stereo.monitor -p preset=ultrafast -p crf=28 -f "$OUTPUT_FILE"

echo "-------------------------------------------"
echo "Grabación de pantalla completa guardada: $OUTPUT_FILE"
echo "Presiona ENTER para cerrar esta ventana"
read
