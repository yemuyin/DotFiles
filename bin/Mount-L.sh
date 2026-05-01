#!/bin/bash
# Script para Montaje Robusto por Etiqueta (-L).
# Uso: mountl <ETIQUETA> <PUNTO_DE_MONTAJE>
#
# AÑADIDA LÓGICA: Maneja automáticamente discos exFAT (LABEL=SSD) 
# y aplica permisos (uid/gid) para el usuario 'yemu' (UID=1000).

# 1. Verificar número de argumentos
if [ "$#" -ne 2 ]; then
    echo "Error: Se esperan 2 argumentos."
    echo "Uso: mountl <ETIQUETA> <PUNTO_DE_MONTAJE>"
    echo "Ejemplo: mountl DATA /mnt/data"
    exit 1
fi

ETIQUETA="$1"
PUNTO_MONTAJE="$2"
OPCIONES_MONTAJE=""

# --- LÓGICA DE DETECCIÓN DE SISTEMA DE ARCHIVOS (FS) ---
# Si la etiqueta es 'SSD' (el disco que formateaste a exFAT), aplicamos uid/gid.
if [ "$ETIQUETA" = "SSD" ]; then
    echo "Detectado disco exFAT (LABEL=$ETIQUETA). Aplicando permisos de escritura para 'yemu'."
    # uid=1000 y gid=1000 son los valores comunes para el primer usuario en Linux.
    # Esto permite que el usuario 'yemu' sea el propietario efectivo del disco exFAT.
    OPCIONES_MONTAJE="-o uid=1000,gid=1000"
fi
# --------------------------------------------------------

# 2. Asegurar que el punto de montaje exista
if [ ! -d "$PUNTO_MONTAJE" ]; then
    echo "Creando directorio: $PUNTO_MONTAJE"
    sudo mkdir -p "$PUNTO_MONTAJE"
fi

# 3. Ejecutar el montaje robusto con -L y las opciones
echo "Intentando montar LABEL=$ETIQUETA en $PUNTO_MONTAJE $OPCIONES_MONTAJE..."

# El comando mount ahora incluye la variable de opciones.
sudo mount -L "$ETIQUETA" "$PUNTO_MONTAJE" $OPCIONES_MONTAJE

# 4. Mensaje de resultado
if [ $? -eq 0 ]; then
    echo "¡Montaje exitoso!"
else
    echo "Error: Falló el montaje del disco $ETIQUETA."
fi
