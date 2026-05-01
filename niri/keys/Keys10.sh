#!/bin/sh
grep -E "^\s*(Mod|Super|Alt|Shift|Ctrl|Print|XF86)" $HOME/.config/niri/config.kdl | \
sed 's/^[ \t]*//' | sort -k1,1 -k2,2 | \
fuzzel --dmenu \
  --prompt " Atajos :> " \
  --match-mode=fuzzy \
  --no-sort \
  --no-icons \
  -l 44 \
  -w 70 \
  --lines=20