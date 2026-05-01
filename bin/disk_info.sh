#!/bin/bash

# Limpia la pantalla al inicio
clear

echo "=== df -h (Uso del sistema) ==="
df -h
echo -e "\n=============================="

echo -e "\n=== dysk (Información detallada) ==="
/home/yemu/.local/bin/dysk
echo -e "===================================="

# La forma más limpia de esperar una pulsación sin mostrar errores
# El comando "read -n 1 -s" lee 1 carácter (-n 1) en modo silencioso (-s)
echo -e "\nPresiona cualquier tecla para salir..."
read -n 1 -s 

# El script simplemente termina aquí, lo que cierra la ventana de foot.
