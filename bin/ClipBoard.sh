#!/bin/sh

# 1. Listener de texto (ahora tipo plain para evitar conflictos con PCManFM)
wl-paste --type text/plain --watch cliphist store &

# 2. Listener de imágenes (opcional)
wl-paste --type image --watch cliphist store &
