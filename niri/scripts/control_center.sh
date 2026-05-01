#!/bin/bash

# Comandos para Runit en Void
OFF="poweroff"
REB="reboot"
SUS="zzz" # Comando clásico de Void para suspender

CSS=".window { background-color: rgba(30, 30, 46, 0.9); border-radius: 15px 0 0 15px; border: 1px solid #89b4fa; border-right: none; }
      button { background: #313244; color: #cdd6f4; border-radius: 8px; padding: 10px; font-family: 'JetBrainsMono Nerd Font'; }"

# Lanzamos Yad con una estructura de formulario y un panel inferior
yad --form --title="Yad Control Center" \
    --css=<(echo "$CSS") \
    --width=350 --height=550 \
    --undecorated --fixed --close-on-unfocus \
    --columns=2 \
    --field="  󰖩  Network:BTN" "nmtui" \
    --field="  󰂯  Bluetooth:BTN" "blueman-manager" \
    --field="  󰄀  Captura:BTN" "niri msg action screenshot-screen" \
    --field="  󰚥  Bloquear:BTN" "gtklock" \
    --field="  󰤄  Suspender:BTN" "$SUS" \
    --field="  󰜉  Reiniciar:BTN" "$REB" \
    --field="  󰐥  Apagar:BTN" "$OFF" \
    --field="":LBL "" \
    --field="Visualizer (CAVA):LBL" "" \
    --button="Cerrar:1" &

# TRUCO PARA CAVA: 
# Como Yad no puede embeber CAVA fácilmente, lo ideal es que 
# Niri posicione una ventanita de terminal con CAVA justo debajo.
# Pero si quieres que el botón de Red abra algo útil en Void:
# Cambia 'nm-connection-editor' por 'foot -e nmtui' si prefieres terminal.