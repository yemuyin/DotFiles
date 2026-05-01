#!/usr/bin/env bash
# ==============================================================================
# SCRIPT:  monitor_system.sh
# DESCRIPCIÓN: Monitorea uso de CPU, memoria y disco, con alertas configurables.
# USO: ./monitor_system.sh [--cpu LIMITE] [--mem LIMITE] [--disk LIMITE]
# ==============================================================================

# Configuración por defecto (porcentajes)
CPU_WARNING=80
MEM_WARNING=85
DISK_WARNING=90

# Colores para output (solo si la terminal los soporta)
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# ------------------------------------------------------------------------------
# FUNCIÓN: obtener_uso_cpu
# Obtiene el uso de CPU (promedio de todos los núcleos)
# ------------------------------------------------------------------------------
obtener_uso_cpu() {
    # Método compatible con Linux/macOS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        local cpu_usage=$(ps -A -o %cpu | awk '{s+=$1} END {print s}')
    else
        echo "Sistema operativo no soportado: $OSTYPE"
        exit 1
    fi
    
    # Redondear a entero
    printf "%.0f" "$cpu_usage"
}

# ------------------------------------------------------------------------------
# FUNCIÓN: verificar_limite
# Compara un valor con un límite y muestra alerta si se supera
# ------------------------------------------------------------------------------
verificar_limite() {
    local valor=$1
    local limite=$2
    local nombre=$3
    
    if [[ $valor -ge $limite ]]; then
        echo -e "[${RED}ALERTA${NC}] ${nombre}: ${valor}% (límite: ${limite}%)"
        return 1
    elif [[ $valor -ge $((limite - 10)) ]]; then
        echo -e "[${YELLOW}ADVERTENCIA${NC}] ${nombre}: ${valor}% (límite: ${limite}%)"
        return 0
    else
        echo -e "[${GREEN}OK${NC}] ${nombre}: ${valor}%"
        return 0
    fi
}

# ------------------------------------------------------------------------------
# FUNCIÓN: mostrar_ayuda
# Muestra mensaje de ayuda
# ------------------------------------------------------------------------------
mostrar_ayuda() {
    cat << EOF
Uso: $0 [OPCIONES]

Opciones:
  --cpu LÍMITE    Establece límite de CPU en % (defecto: $CPU_WARNING)
  --mem LÍMITE    Establece límite de memoria en % (defecto: $MEM_WARNING)
  --disk LÍMITE   Establece límite de disco en % (defecto: $DISK_WARNING)
  --help          Muestra esta ayuda

Ejemplos:
  $0
  $0 --cpu 90 --mem 80
  $0 --disk 95
EOF
}

# ------------------------------------------------------------------------------
# PROCESAR ARGUMENTOS DE LÍNEA DE COMANDOS
# ------------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
    case $1 in
        --cpu)
            CPU_WARNING="$2"
            shift 2
            ;;
        --mem)
            MEM_WARNING="$2"
            shift 2
            ;;
        --disk)
            DISK_WARNING="$2"
            shift 2
            ;;
        --help|-h)
            mostrar_ayuda
            exit 0
            ;;
        *)
            echo "Opción desconocida: $1"
            mostrar_ayuda
            exit 1
            ;;
    esac
done

# ------------------------------------------------------------------------------
# EJECUCIÓN PRINCIPAL
# ------------------------------------------------------------------------------
main() {
    echo "=== MONITOR DEL SISTEMA $(date) ==="
    echo "Límites configurados: CPU:${CPU_WARNING}% MEM:${MEM_WARNING}% DISK:${DISK_WARNING}%"
    echo ""
    
    # Obtener métricas
    local cpu=$(obtener_uso_cpu)
    local mem=$(free | awk '/Mem:/ {printf("%.0f", $3/$2 * 100)}')
    local disk=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
    
    # Verificar cada métrica
    verificar_limite "$cpu" "$CPU_WARNING" "CPU"
    local cpu_status=$?
    
    verificar_limite "$mem" "$MEM_WARNING" "Memoria"
    local mem_status=$?
    
    verificar_limite "$disk" "$DISK_WARNING" "Disco (/)"
    local disk_status=$?
    
    # Estado general
    echo ""
    if [[ $((cpu_status + mem_status + disk_status)) -eq 0 ]]; then
        echo -e "${GREEN}TODO EN ORDEN${NC} - El sistema está dentro de los límites."
        exit 0
    else
        echo -e "${RED}SE REQUIERE ATENCIÓN${NC} - Una o más métricas superan los límites."
        exit 1
    fi
}

# Ejecutar solo si se invoca directamente (no al ser importado como librería)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi