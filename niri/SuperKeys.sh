#!/bin/sh

OPCIONES="
1. Símbolos ASCII [WIN] [ALT] etc
2. Colores fuzzel bonitos
3. Agrupado con separadores ---
4. Prefijos W: A: M: etc
5. Minimalista ordenada
6. Original (para comparar)
"

ELECCION=$(echo "$OPCIONES" | fuzzel --dmenu --prompt "Elige versión: " --lines=7 --width=50)

case "$ELECCION" in
    *"1."*)
        # Versión símbolos ASCII
        grep -E "^\s*(Mod|Super|Alt|Shift|Ctrl|Print|XF86)" $HOME/.config/niri/config.kdl | \
        sed 's/^[ \t]*//' | \
        sed '
            s/Super/[WIN] Super/
            s/Alt/[ALT] Alt/
            s/Ctrl/[CTL] Ctrl/
            s/Shift/[SFT] Shift/
            s/Mod/[MOD] Mod/
            s/Print/[PIC] Print/
            s/XF86/[MED] XF86/
        ' | sort | \
        fuzzel --dmenu --prompt "Símbolos> " --match-mode=exact --no-sort --no-icons -l 44 -w 65
        ;;
    *"2."*)
        # Versión colores
        grep -E "^\s*(Mod|Super|Alt|Shift|Ctrl|Print|XF86)" $HOME/.config/niri/config.kdl | \
        sed 's/^[ \t]*//' | sort | \
        fuzzel --dmenu \
          --prompt "Colores> " \
          --match-mode=exact \
          --no-sort \
          --no-icons \
          -l 44 \
          -w 60 \
          --background=1e1e2eff \
          --text-color=cdd6f4ff \
          --match-color=a6e3a1ff \
          --selection-color=89b4faff
        ;;
    *"3."*)
        # Versión separadores
        grep -E "^\s*(Mod|Super|Alt|Shift|Ctrl|Print|XF86)" $HOME/.config/niri/config.kdl | \
        sed 's/^[ \t]*//' | \
        awk '
            /^Super/ && !super {print "--- SUPER ---"; super=1}
            /^Alt/ && !alt {print "--- ALT ---"; alt=1} 
            /^Mod/ && !mod {print "--- MOD ---"; mod=1}
            /^Shift/ && !shift {print "--- SHIFT ---"; shift=1}
            /^Ctrl/ && !ctrl {print "--- CTRL ---"; ctrl=1}
            /^Print/ && !print {print "--- PRINT ---"; print=1}
            /^XF86/ && !xf86 {print "--- MULTIMEDIA ---"; xf86=1}
            {print}
        ' | \
        fuzzel --dmenu --prompt "Separadores> " --match-mode=exact --no-sort --no-icons -l 44 -w 60
        ;;
    *"4."*)
        # Versión prefijos
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
        fuzzel --dmenu --prompt "Prefijos> " --match-mode=exact --no-sort --no-icons -l 44 -w 60
        ;;
    *"5."*)
        # Versión minimalista
        grep -E "^\s*(Mod|Super|Alt|Shift|Ctrl|Print|XF86)" $HOME/.config/niri/config.kdl | \
        sed 's/^[ \t]*//' | sort -k1,1 -k2,2 | \
        fuzzel --dmenu \
          --prompt "Minimal> " \
          --match-mode=fuzzy \
          --no-sort \
          --no-icons \
          -l 44 \
          -w 70
        ;;
    *"6."*)
        # Original
        grep -E "^\s*(Mod|Super|Alt|Shift|Ctrl|Print|XF86)" $HOME/.config/niri/config.kdl | \
        fuzzel --dmenu --prompt "Original> " --match-mode=exact --no-sort --no-icons -l 44 -w 60
        ;;
esac