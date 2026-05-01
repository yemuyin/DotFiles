#!/bin/sh
grep -E "^\s*(Mod|Super|Alt|Shift|Ctrl|Print|XF86)" \
$HOME/.config/niri/config.kdl | \
awk '
    /^\s*Super/ {print "1:" $0}
    /^\s*Alt/ {print "2:" $0} 
    /^\s*Mod/ {print "3:" $0}
    /^\s*Shift/ {print "4:" $0}
    /^\s*Ctrl/ {print "5:" $0}
    /^\s*Print/ {print "6:" $0}
    /^\s*XF86/ {print "7:" $0}
' | sort -n | cut -d: -f2- | \
fuzzel --dmenu --prompt " Buscar :> " --match-mode=exact --no-sort --no-icons -l 44 -w 60