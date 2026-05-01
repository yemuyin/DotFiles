#!/bin/sh
grep -E "^\s*(Mod|Super|Alt|Shift|Ctrl|Print|XF86)" \
$HOME/.config/niri/config.kdl | \
fuzzel --dmenu --prompt " Buscar :> " --match-mode=exact --no-sort --no-icons -l 44 -w 60
