#!/bin/sh
grep -E "^\s*(Mod|Super|Alt|Shift|Ctrl|Print|XF86)" $HOME/.config/niri/config.kdl | \
sed 's/^[ \t]*//' | \
awk '{
    if (/^Super/) prefix = "W: "
    else if (/^Alt/) prefix = "A: "
    else if (/^Mod/) prefix = "M: "
    else if (/^Shift/) prefix = "S: "
    else if (/^Ctrl/) prefix = "C: "
    else if (/^Print/) prefix = "P: "
    else if (/^XF86/) prefix = "X: "
    else prefix = ""
    print prefix $0
}' | sort | \
fuzzel --dmenu --prompt " Buscar :> " --match-mode=exact --no-sort --no-icons -l 44 -w 60