#!/bin/bash

# 1. Obtiene una lista de todos los reproductores.
PLAYER_LIST=$(playerctl -l 2>/dev/null)

INFO=""
ACTIVE_PLAYER=""

# === BÚSQUEDA PRIORITARIA: PLAYING ===
for PLAYER_NAME in $PLAYER_LIST; do
    PLAYER_STATUS=$(playerctl -p "$PLAYER_NAME" status 2>/dev/null)

    if [ "$PLAYER_STATUS" = "Playing" ]; then
        ACTIVE_PLAYER="$PLAYER_NAME"
        break
    fi
done

# === BÚSQUEDA SECUNDARIA: PAUSED ===
if [ -z "$ACTIVE_PLAYER" ]; then
    for PLAYER_NAME in $PLAYER_LIST; do
        PLAYER_STATUS=$(playerctl -p "$PLAYER_NAME" status 2>/dev/null)

        if [ "$PLAYER_STATUS" = "Paused" ]; then
            ACTIVE_PLAYER="$PLAYER_NAME"
            break
        fi
    done
fi


# 2. Si se encontró un reproductor, obtenemos la metadata.
if [ -n "$ACTIVE_PLAYER" ]; then
    
    # Obtenemos los datos 
    ARTIST=$(playerctl -p "$ACTIVE_PLAYER" metadata artist 2>/dev/null)
    TITLE=$(playerctl -p "$ACTIVE_PLAYER" metadata title 2>/dev/null)
    
    # Definimos el icono
    PLAYER_STATUS=$(playerctl -p "$ACTIVE_PLAYER" status 2>/dev/null)
    if [ "$PLAYER_STATUS" = "Playing" ]; then
        STATUS_ICON="▶" 
    else
        STATUS_ICON="⏸" 
    fi

    # Prepara el texto a mostrar (INFO)
    if [ -z "$ARTIST" ]; then
        INFO="$STATUS_ICON $TITLE"
    else
        INFO="$STATUS_ICON $ARTIST - $TITLE"
    fi
    
    # 3. Imprime SOLO la cadena de texto.
    echo "$INFO" | tr -d '\0\r\n' | tr -c '[:print:]' ' '
    
else
    # 4. Si no hay reproductor activo, imprime cadena vacía (MÓDULO SE BORRA).
    echo "" 
fi
