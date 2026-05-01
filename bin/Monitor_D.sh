#!/bin/bash
# ==============================================================================
# SCRIPT:  sistema_clean.sh
# DESCRIPCIÓN: Instantánea del sistema - Clean y funcional
# ==============================================================================

# ------------------------------------------------------------------------------
# CONFIGURACIÓN (ASCII seguro, sin Unicode problemático)
# ------------------------------------------------------------------------------
S_CALENDAR="📅"
S_COMPUTER="🖥"
S_UPTIME="⏱"
S_CPU="🔄"
S_MEMORY="🧠"
S_DISK="💾"
S_LOAD="📊"
S_CHECK="✅"
S_TEMP="🌡"
S_USED="📏"
S_STORAGE="💿"

# ------------------------------------------------------------------------------
# FUNCIONES BÁSICAS
# ------------------------------------------------------------------------------
get_hostname() {
    # Método universalmente compatible
    if [[ -f /etc/hostname ]]; then
        head -n1 /etc/hostname | cut -c1-15
    else
        hostname 2>/dev/null | cut -c1-15 || echo "localhost"
    fi
}

draw_bar() {
    local percent=$1
    local width=25
    local filled=$((percent * width / 100))
    local empty=$((width - filled))
    
    echo -n "["
    for ((i=0; i<filled; i++)); do echo -n "█"; done
    for ((i=0; i<empty; i++)); do echo -n "░"; done
    echo -n "]"
}

get_cpu() {
    if [[ -f /proc/stat ]]; then
        top -bn1 2>/dev/null | grep "Cpu(s)" | awk '{printf "%d", $2 + $4 + $6}' || echo "0"
    else
        echo "0"
    fi
}

get_memory() {
    if [[ -f /proc/meminfo ]]; then
        # Obtener valores en KB
        local mem_total_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        local mem_avail_kb=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
        
        if [[ -n "$mem_total_kb" && "$mem_total_kb" -gt 0 ]]; then
            # Calcular porcentaje
            local mem_used_kb=$((mem_total_kb - mem_avail_kb))
            local percent=$((mem_used_kb * 100 / mem_total_kb))
            echo "$percent:$mem_used_kb:$mem_total_kb"
            return
        fi
    fi
    echo "0:0:0"
}

get_disk() {
    local usage=$(df -h / 2>/dev/null | awk 'NR==2 {print $5}' | tr -d '%')
    local used=$(df -h / 2>/dev/null | awk 'NR==2 {print $3}')
    local total=$(df -h / 2>/dev/null | awk 'NR==2 {print $2}')
    echo "${usage:-0}:${used:-0}:${total:-0}"
}

get_load() {
    if [[ -f /proc/loadavg ]]; then
        awk '{printf "%.2f %.2f %.2f", $1, $2, $3}' /proc/loadavg
    else
        echo "0.00 0.00 0.00"
    fi
}

get_uptime() {
    if [[ -f /proc/uptime ]]; then
        local seconds=$(awk '{print int($1)}' /proc/uptime)
        local days=$((seconds / 86400))
        local hours=$(( (seconds % 86400) / 3600 ))
        local mins=$(( (seconds % 3600) / 60 ))
        
        if [[ $days -gt 0 ]]; then
            printf "%d días %02d:%02d" "$days" "$hours" "$mins"
        elif [[ $hours -gt 0 ]]; then
            printf "%d:%02d horas" "$hours" "$mins"
        else
            printf "%d minutos" "$mins"
        fi
    else
        echo "N/A"
    fi
}

kb_to_mb() {
    local kb=$1
    echo $((kb / 1024))
}

# ------------------------------------------------------------------------------
# MOSTRAR SNAPSHOT
# ------------------------------------------------------------------------------
show_snapshot() {
    clear
    
    # Cabecera
    echo "╔════════════════════════════════════════╗"
    echo "║        SNAPSHOT DEL SISTEMA           ║"
    echo "╚════════════════════════════════════════╝"
    echo ""
    
    # Información básica
    echo "$S_CALENDAR  $(date '+%Y-%m-%d %H:%M:%S')"
    echo "$S_COMPUTER  Host: $(get_hostname)"
    echo "$S_UPTIME  Uptime: $(get_uptime)"
    echo ""
    
    # Carga
    echo "$S_LOAD  CARGA DEL SISTEMA:"
    echo "   $(get_load) (1m, 5m, 15m)"
    echo ""
    
    echo "──────────────────────────────────────────"
    echo ""
    
    # CPU
    local cpu=$(get_cpu)
    echo "$S_CPU  CPU:"
    echo -n "   "
    draw_bar "$cpu"
    echo " $cpu%"
    
    # Temperatura si existe
    if [[ -f /sys/class/thermal/thermal_zone0/temp ]]; then
        local temp=$(cat /sys/class/thermal/thermal_zone0/temp)
        echo "   $S_TEMP  Temperatura: $((temp / 1000))°C"
    fi
    echo ""
    
    # Memoria
    local mem_info=$(get_memory)
    local mem_percent=$(echo "$mem_info" | cut -d: -f1)
    local mem_used_kb=$(echo "$mem_info" | cut -d: -f2)
    local mem_total_kb=$(echo "$mem_info" | cut -d: -f3)
    
    echo "$S_MEMORY  MEMORIA:"
    echo -n "   "
    draw_bar "$mem_percent"
    echo " $mem_percent%"
    
    if [[ "$mem_total_kb" -gt 0 ]]; then
        local mem_used_mb=$(kb_to_mb "$mem_used_kb")
        local mem_total_mb=$(kb_to_mb "$mem_total_kb")
        echo "   $S_USED  Usada: ${mem_used_mb}MB / Total: ${mem_total_mb}MB"
    fi
    echo ""
    
    # Disco
    local disk_info=$(get_disk)
    local disk_percent=$(echo "$disk_info" | cut -d: -f1)
    local disk_used=$(echo "$disk_info" | cut -d: -f2)
    local disk_total=$(echo "$disk_info" | cut -d: -f3)
    
    echo "$S_DISK  DISCO (raíz /):"
    echo -n "   "
    draw_bar "$disk_percent"
    echo " $disk_percent%"
    
    if [[ -n "$disk_used" && "$disk_used" != "0" ]]; then
        echo "   $S_STORAGE  $disk_used usado / $disk_total total"
    fi
    
    echo ""
    echo "──────────────────────────────────────────"
    echo ""
    echo "$S_CHECK  Instantánea completada"
}

# ------------------------------------------------------------------------------
# VERSIÓN COMPACTA
# ------------------------------------------------------------------------------
show_compact() {
    local host=$(get_hostname)
    local cpu=$(get_cpu)
    
    local mem_info=$(get_memory)
    local mem_percent=$(echo "$mem_info" | cut -d: -f1)
    
    local disk_info=$(get_disk)
    local disk_percent=$(echo "$disk_info" | cut -d: -f1)
    
    local load=$(get_load | awk '{print $1}')
    
    echo "┌───[🖥 $host]───[🔄 ${cpu}%]───[🧠 ${mem_percent}%]───[💾 ${disk_percent}%]──┐"
    echo "│ ⚡ $load  $(date '+%H:%M:%S')  ⏱ $(get_uptime)                   │"
    echo "└───────────────────────────────────────────────────────┘"
}

# ------------------------------------------------------------------------------
# MAIN
# ------------------------------------------------------------------------------
case "${1:-}" in
    "compact"|"c")
        show_compact
        ;;
    "help"|"-h"|"--help")
        echo "Uso: $0 [opción]"
        echo ""
        echo "Opciones:"
        echo "  [vacío]    - Vista completa"
        echo "  compact    - Vista compacta"
        echo "  help       - Esta ayuda"
        ;;
    *)
        show_snapshot
        ;;
esac