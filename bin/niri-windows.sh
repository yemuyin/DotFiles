#!/bin/bash
# Script para Taskbar Niri - Versión Final de Extracción
# Usa SED para limpiar y etiquetar las líneas, luego Bash para el bucle.

# Obtener la salida de texto plano de Niri.
WINDOWS_TEXT=$(niri msg windows)

# Inicializamos las variables de salida
WINDOW_COUNT=0
WINDOW_LIST=""

# 1. Usamos SED para aislar y etiquetar solo las líneas de Título y App ID.
#    El output será una lista simple como: TITLE:Mi Ventana\nAPP:Firefox\n...
CLEAN_LINES=$(echo "$WINDOWS_TEXT" | \
    grep -E 'Title:|App ID:' | \
    sed -E -n '
        s/^[[:space:]]+Title: "(.*)"/\1/p; 
        s/^[[:space:]]+App ID: "(.*)"/\1/p;
    ' | sed 's/"//g') # Eliminamos cualquier comilla restante


# 2. Procesamos la lista secuencialmente: cada dos líneas es una ventana completa.
# Usaremos un índice par/impar (i) para saber si la línea es un Título o un App ID.
i=0
while IFS= read -r VALUE; do
    
    # Si 'i' es par (0, 2, 4...), es el Título.
    if (( i % 2 == 0 )); then
        CURRENT_TITLE="$VALUE"
    
    # Si 'i' es impar (1, 3, 5...), es el App ID. ¡Procesamos la pareja!
    else
        APP_ID="$VALUE"
        
        WINDOW_COUNT=$((WINDOW_COUNT + 1))
        
        # 3. Asignación de Iconos
        ICON=""
        case "$APP_ID" in
            "Firefox") ICON="" ;;
            "foot") ICON="" ;;
            "geany") ICON="" ;;
            "pcmanfm") ICON="" ;;
            *) ICON="" ;;
        esac

       # 3. Formato del botón para Waybar
# Quitamos "title" del span, y dejamos la acción onclick.
BUTTON="<span onclick=\"niri focus window title:'$CURRENT_TITLE'\">$ICON</span> "
WINDOW_LIST+="$BUTTON"
    fi
    
    i=$((i + 1))
done <<< "$CLEAN_LINES"

# 5. Generar la salida JSON para Waybar
# Primero, aseguramos el escaping correcto de las comillas y barras en la lista de ventanas
ESCAPED_WINDOW_LIST=$(echo "$WINDOW_LIST" | sed 's/\\/\\\\/g; s/"/\\"/g')
ESCAPED_WINDOW_LIST=$(echo "$ESCAPED_WINDOW_LIST" | sed 's/\//\\\//g') # Escapar barras oblicuas

# 5. Generar la salida JSON para Waybar
printf '{"text": "%s", "tooltip": "%s Ventanas abiertas"}\n' "$WINDOW_LIST" "$WINDOW_COUNT"
