#!/bin/sh
grep -E "^\s*(Mod|Super|Alt|Shift|Ctrl|Print|XF86)" $HOME/.config/niri/config.kdl | \
sed 's/^[ \t]*//' | \
awk '
    /^Super/ {print "--- SUPER ---"}
    /^Alt/ {print "--- ALT ---"} 
    /^Mod/ {print "--- MOD ---"}
    /^Shift/ {print "--- SHIFT ---"}
    /^Ctrl/ {print "--- CTRL ---"}
    /^Print/ {print "--- PRINT ---"}
    /^XF86/ {print "--- MULTIMEDIA ---"}
    {print}
' | uniq | \
fuzzel --dmenu --prompt " Buscar :> " --match-mode=exact --no-sort --no-icons -l 44 -w 60