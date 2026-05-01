#!/bin/bash
# sistema_ascii.sh - 100% ASCII, sin Unicode

echo "=========================================="
echo "         SYSTEM SNAPSHOT"
echo "=========================================="
echo ""
echo "$(date '+%Y-%m-%d %H:%M:%S')"
echo "Host: $(cat /etc/hostname 2>/dev/null || hostname 2>/dev/null || echo 'localhost')"
echo ""
echo "CPU:    [$(printf '%*s' $(( $(top -bn1 | grep Cpu | awk '{printf "%d", $2+$4}') / 4 )) '' | tr ' ' '#')$(printf '%*s' $((25 - $(top -bn1 | grep Cpu | awk '{printf "%d", $2+$4}') / 4)) '' | tr ' ' '.')]"
echo "Memory: [$(printf '%*s' $(( $(free | awk '/Mem:/ {printf "%d", $3/$2*100}') / 4 )) '' | tr ' ' '#')$(printf '%*s' $((25 - $(free | awk '/Mem:/ {printf "%d", $3/$2*100}') / 4)) '' | tr ' ' '.')]"
echo "Disk:   [$(printf '%*s' $(( $(df -h / | awk 'NR==2 {print $5}' | tr -d '%') / 4 )) '' | tr ' ' '#')$(printf '%*s' $((25 - $(df -h / | awk 'NR==2 {print $5}' | tr -d '%') / 4)) '' | tr ' ' '.')]"
echo ""
echo "=========================================="