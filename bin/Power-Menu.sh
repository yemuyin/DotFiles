#!/bin/bash

# =================================================================
# FUNCIÓN DE AUTENTICACIÓN (ask_sudo)
# =================================================================
# Esta función pide la contraseña usando fuzzel y la pasa a sudo -S.
ask_sudo() {
    local command_to_execute="$1"
    local prompt_text="$2"

    # 1. Pedir contraseña directamente con fuzzel
    # Capturamos la salida de fuzzel (la contraseña)
    local password=$(echo "" | fuzzel --dmenu --password --prompt "$prompt_text" --lines=1 --width=25)
    
    if [ -z "$password" ]; then
        notify-send "Menú de Energía" "Operación de sudo cancelada."
        return 1
    fi
    
    # 2. Ejecutar el comando con la contraseña inyectada
    # Usamos la ruta absoluta para que sudo encuentre el comando.
    local output
    # NOTA: Usamos "$command_to_execute" tal como viene, ya es la ruta absoluta.
    output=$(echo "$password" | sudo -S "$command_to_execute" 2>&1)
    local result=$?
    
    if [ $result -ne 0 ]; then
        notify-send "⚠️ Error de Sudo" "Falló la ejecución. (Clave incorrecta o error)"
    fi
    
    return $result
}

# =================================================================
# OPCIONES DEL MENÚ
# =================================================================

options=" Bloquear
󰌑 Reiniciar
⏻ Apagar"

# El menú principal se lanza para la selección
selected=$(echo -e "$options" | fuzzel --dmenu --prompt "Opciones: " --lines=3 --width=30)

# =================================================================
# EVALUACIÓN DE LA ELECCIÓN (Directo a la acción o contraseña)
# =================================================================
case "$selected" in
    " Bloquear")
        # El comando Lock.sh no necesita permisos de sudo
        ~/.local/bin/Lock.sh &
        ;;
    "󰌑 Reiniciar")
        # Ir directo a la solicitud de contraseña
        ask_sudo "/sbin/reboot" "🔑 Contraseña para Reiniciar:"
        ;;
    "⏻ Apagar")
        # Ir directo a la solicitud de contraseña
        ask_sudo "/sbin/poweroff" "🔑 Contraseña para Apagar:"
        ;;
esac
