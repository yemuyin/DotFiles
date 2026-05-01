#!/bin/sh
grep -E "^\s*(Mod|Super|Alt|Shift|Ctrl|Print|XF86)" $HOME/.config/niri/config.kdl | \
awk '
    /Launch|spawn/ {print "🚀 Aplicaciones: " $0}
    /move|resize/ {print "📦 Ventanas: " $0}
    /workspace|output/ {print "🖥️ Workspaces: " $0}
    /audio|volume/ {print "🔊 Audio: " $0}
    /screenshot|recorder/ {print "📷 Captura: " $0}
    !/Launch|spawn|move|resize|workspace|output|audio|volume|screenshot|recorder/ {print "⚙️ Otros: " $0}
' | sort | \
fuzzel --dmenu --prompt " Buscar :> " --match-mode=exact --no-sort --no-icons -l 44 -w 60 | \
sed 's/^[^:]*: //'