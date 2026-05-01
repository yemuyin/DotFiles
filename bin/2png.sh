#!/bin/bash

echo "🎬 Usando la potencia de FFmpeg para convertir imágenes..."

# Contador para saber cuántas llevamos
count=0

# Buscamos archivos .jpg y .jpeg (ignorando mayúsculas/minúsculas)
for f in *.[jJ][pP]*[gG]; do
    # Verificar si existen archivos (por si la carpeta está vacía)
    [ -e "$f" ] || continue

    # Extraer el nombre sin la extensión
    filename="${f%.*}"

    echo "Converting: $f -> ${filename}.png"

    # Comando FFmpeg:
    # -i: archivo de entrada
    # -y: sobrescribir si ya existe el png
    # -loglevel error: para que no ensucie la pantalla con datos técnicos
    ffmpeg -i "$f" -y -loglevel error "${filename}.png"

    ((count++))
done

if [ $count -gt 0 ]; then
    echo "✅ ¡Hecho! Se han convertido $count imágenes a .png"
    echo "Los originales .jpg siguen aquí por seguridad."
else
    echo "❓ No encontré ningún archivo .jpg o .jpeg en esta carpeta."
fi
