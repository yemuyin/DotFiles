#!/bin/bash

# Define el comando que queremos ejecutar:
# Muestra el clima de Ciudad Real en español usando wttr.in
CLIMA_CMD="curl wttr.in/Ciudad%20Real?lang=es"

# Lanza foot con el comando.
#
# -w / --window-size-pixels=WIDTHxHEIGHT : Define el tamaño en píxeles.
#
# ASUMIENDO que tu tamaño inicial es 850x650, el doble de ancho sería 1700x650.
# Ajusta estos valores a tu gusto, o usa -W/--window-size-chars para caracteres.
#
# -H: Abre el terminal en un "hold" (mantener abierto)
#     después de que el comando ha terminado. Esto evita que se cierre.
foot -w 1300x950 -H sh -c "$CLIMA_CMD"
