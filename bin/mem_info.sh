#!/bin/bash

# Script: ~/.local/bin/mem_info.sh
# Muestra información detallada de la memoria y la tabla de módulos instalados (inxi -mt).

# Limpia la pantalla al inicio
clear

echo "=== Información Detallada de Memoria (RAM y Módulos) ==="

# Ejecutar el comando inxi para mostrar la información de memoria (-m) y tabla (-t)
inxi -mt

echo -e "\n======================================================="

# Esperar una pulsación para mantener la ventana abierta
echo -e "\nPresiona cualquier tecla para salir..."
read -n 1 -s
