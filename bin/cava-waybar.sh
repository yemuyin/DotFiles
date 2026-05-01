#!/bin/bash

# Configuración de cava: 8 barras, salida raw en ASCII
BARS=24
CONFIG=$(mktemp)
cat > "$CONFIG" << EOF
[general]
bars = $BARS
[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
[input]
method = pipewire
source = auto
EOF

# Ejecutar cava y procesar la salida
/usr/bin/cava -p "$CONFIG" | while read -r line; do
    # Convertir la línea (ej: "3;5;2;1;0;4;6;7") en barras
    IFS=';' read -ra values <<< "$line"
    bar_str=""
    for value in "${values[@]}"; do
        # Mapear valores (0-7) a caracteres Unicode (8 niveles)
        case "$value" in
            0) bar_str="${bar_str} ";;   # Vacío
            1) bar_str="${bar_str}▁";;
            2) bar_str="${bar_str}▂";;
            3) bar_str="${bar_str}▃";;
            4) bar_str="${bar_str}▄";;
            5) bar_str="${bar_str}▅";;
            6) bar_str="${bar_str}▆";;
            7) bar_str="${bar_str}▇";;
            *) bar_str="${bar_str} ";;   # Por defecto vacío
        esac
    done
    # Salida JSON para Waybar
    echo "{\"text\": \"$bar_str\", \"class\": \"cava\"}"
done

rm "$CONFIG"
