#!/bin/sh
grep -E "^\s*(Mod|Alt|Shift|Ctrl|Print)" $HOME/.config/niri/config.kdl | \
sed 's/^[ \t]*//' | \
sed '
    
    s/Alt/⚡ Alt/
    s/Super/ Super/
    s/Ctrl/ Ctrl/
    s/Shift/󰽮 Shift/
    s/Mod/  Mod/
    s/Print/ Print/
    
' | sort | \
fuzzel --dmenu --prompt " Buscar :> " --match-mode=exact --no-sort --no-icons -l 44 -w 65
