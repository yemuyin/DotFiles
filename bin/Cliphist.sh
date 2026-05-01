#!/bin/bash
# Script: ~/.local/bin/Cliphist_Text.sh
# Muestra y copia el historial de texto usando cliphist y Fuzzel.

# Solo lanza el menú de cliphist para texto
cliphist list | fuzzel -d -p " Historial del Clipboard:" -l 10 | cliphist decode | wl-copy
