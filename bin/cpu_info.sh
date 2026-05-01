#!/bin/bash

# Script: ~/.local/bin/cpu_info.sh
# Muestra información detallada del sistema (inxi) y la gráfica de CPU (cpufetch).

# Limpia la pantalla al inicio
clear

echo "=== Resumen del Sistema (inxi) ==="
# Mostrar información de Audio, CPU, Gráficos y Discos
inxi -ACDG
echo -e "\n===================================="

echo -e "\n=== Información Visual de CPU (cpufetch) ==="
# Mostrar el gráfico de cpufetch
cpufetch
echo -e "==========================================\n"

# Esperar una pulsación para mantener la ventana abierta
echo "Presiona cualquier tecla para salir..."
read -n 1 -s
