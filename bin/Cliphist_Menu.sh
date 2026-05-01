#!/bin/bash

# 1. Obtenemos la lista directamente de cliphist
# 2. Pasamos a Fuzzel (ajustado a tu pantalla de 32" con 15 líneas)
SELECTION=$(cliphist list | fuzzel -d -p "  Historial: " -l 15 -w 60)

# Si el usuario escapa o no selecciona nada, salimos
[ -z "$SELECTION" ] && exit 0

# 3. El truco mágico: cliphist decode recupera el contenido original 
# ya sea texto o imagen binaria, y wl-copy lo pone en el clipboard activo.
echo "$SELECTION" | cliphist decode | wl-copy

# 4. Notificación visual rápida
notify-send -t 1000 "  Portapapeles" "Contenido recuperado"
