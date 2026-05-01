#!/bin/sh
grep -E "^\s*(Mod|Super|Alt|Shift|Ctrl|Print|XF86)" $HOME/.config/niri/config.kdl | \
sort | \
fuzzel --dmenu \
  --prompt " Buscar :> " \
  --match-mode=exact \
  --no-sort \
  --no-icons \
  -l 44 \
  -w 60 \
  --background=2e3440ff \
  --text-color=eceff4ff \
  --match-color=a3be8cff \
  --selection-color=88c0d0ff