#!/bin/sh

# 1. Limpieza de posibles restos de una sesión fallida
killall -9 wireplumber pipewire-pulse pipewire 2>/dev/null

# 2. Actualizar variables de entorno para D-Bus (Crucial en Void/Niri)
dbus-update-activation-environment --all

# 3. Arrancar en orden con pequeñas pausas (el "secreto" del éxito)
pipewire &
sleep 0.7
pipewire-pulse &
sleep 0.7
wireplumber &
