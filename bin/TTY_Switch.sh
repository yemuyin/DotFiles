#!/bin/bash
# Script para cambiar a una TTY de texto usando chvt.

TTY_DEST=3

# Usamos chvt (Change Virtual Terminal)
chvt $TTY_DEST

if [ $? -ne 0 ]; then
    # Si chvt falla, es muy probable que aún falten permisos o que Niri lo esté bloqueando totalmente.
    notify-send " TTY Fallida (chvt)" "Fallo al cambiar a TTY$TTY_DEST. Revisa si la membresía de grupo (tty) está activa."
fi
