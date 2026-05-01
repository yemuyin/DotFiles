#!/bin/bash

# Configuración
BG_DIR="$HOME/.BGs/Cool"
TRANSITION_TYPE="grow"
TRANSITION_DURATION=3
INTERVAL=360  # 6 minutos en segundos

# Verificar si swww-daemon está corriendo
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 2
fi

# Bucle principal
while true; do
    # Obtener lista de imágenes
    mapfile -t backgrounds < <(find "$BG_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.webp" \))
    
    if [ ${#backgrounds[@]} -eq 0 ]; then
        echo "No se encontraron imágenes en $BG_DIR"
        exit 1
    fi
    
    # Seleccionar imagen aleatoria
    random_bg="${backgrounds[RANDOM % ${#backgrounds[@]}]}"
    
    # Esquina aleatoria para la transición
    corners=("top-left" "top-right" "bottom-left" "bottom-right")
    random_corner="${corners[RANDOM % 4]}"
    
    # Aplicar fondo con transición
    swww img "$random_bg" \
        --transition-type "$TRANSITION_TYPE" \
        --transition-pos "$random_corner" \
        --transition-duration "$TRANSITION_DURATION"
    
    # Esperar antes del siguiente cambio
    sleep $INTERVAL
done
