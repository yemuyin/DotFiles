#!/bin/sh
grep -E "^\s*(Mod|Super|Alt|Shift|Ctrl|Print|XF86)" $HOME/.config/niri/config.kdl | \
sed 's/^[ \t]*//' | sort | \
fuzzel --dmenu \
  --prompt " Buscar :> " \
  --match-mode=exact \
  --no-sort \
  --no-icons \
  -l 44 \
  -w 60 \
  --background=1e1e2eff \
  --text-color=cdd6f4ff \
  --match-color=a6e3a1ff \
  --selection-color=89b4faff