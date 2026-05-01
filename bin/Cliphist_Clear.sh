#!/bin/bash

# Este script borra todo el historial de texto de cliphist.
# y también limpia las imágenes temporales que pueda haber en /tmp.

# 1. Borrar el historial de texto de cliphist
cliphist wipe

# 2. Borrar las imágenes temporales (si existen)
rm -rf /tmp/cliphist_images/*

# 3. Notificación de confirmación (usando Mako)
notify-send " Historial Borrado" "El historial de texto y las imágenes temporales han sido eliminados."
