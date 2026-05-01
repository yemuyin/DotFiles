#!/usr/bin/env bash
#stackabrix, a teminal hanoi-like game , written in Bash by Christos Angelopoulos,under GPL v2, December 2024
function load_colors()
{
  C0="\e[38;5;242m" #Grid Color
  C1="\e[33m" #-Yellow
  C2="\e[36m" #Cyan
  C3="\e[31m" #Red
  C4="\e[35m" #Magenta
  C5="\e[34m" #Blue
  C6="\e[32m" #Green
  b="\e[1m" #bold
}

function load_config()
{

 source "$CONFIG_FILE"
 #DEFAULT VALUES in case config doesn't load
 [[ -z $PREFERRED_EDITOR ]]&&PREFERRED_EDITOR="${EDITOR-nano}"
 [[ -z $COLORS ]]&&COLORS=5
 [[ -z $BLOCKS ]]&&BLOCKS=6
 [[ -z $NAV_LEFT ]]&&NAV_LEFT="h"
 [[ -z $NAV_RIGHT ]]&&NAV_RIGHT="l"

}

function load_new_game()
{
 GRAB_TOGGLE=no
 LIFTED=""
 TIME_START="$(date +%s)"
 MOVES=0
 unset "STACK[@]"
 X=""
 F=""
 COL_NAME=("  RED  " " GREEN " " YELLOW" " BLUE  " "MAGENTA" "  CYAN " " WHITE ")
 COL_CODE=(1 1 1 1 1 1 1 1)
 for ((x=0;x<COLORS;x++))
 do
  for ((y=0;y<BLOCKS;y++))
  do
  z="$((1 + RANDOM % COLORS))"
  while [[ ${COL_CODE[z]} -gt $BLOCKS ]]
  do
   z="$((1 + RANDOM % COLORS))"
  done
  ((COL_CODE[z]++))
  STACK[x]="${STACK[x]}""$z" 
  done
 done
 for ((i=0;i<COLORS;i++))
 do
  X[i]="\e[1;3$((i+1))m"
  F[i]="${COL_NAME[i]}" 
  GRAB[x]=""

 done
 CURSOR="0"
 X[0]="${I}"${X[0]}
}

function show_hiscores ()
{
 echo -e "${C1}${b}T O P   T E N${n}  ${C2}($COLORS Colors, $BLOCKS Blocks)${C0}\n"
 if [[ -n $(grep "$COLORS Colors, $BLOCKS Blocks" "$SHARE_DIR/hiscores.txt")    ]]
 then
  TOP_10_LENGTH=$(grep -c "$COLORS Colors, $BLOCKS Blocks" "$SHARE_DIR/hiscores.txt")
  if [[ $TOP_10_LENGTH -gt 10 ]];then TOP_10_LENGTH=10;fi
  ii=1;i=1;
  while [[ $i -le $TOP_10_LENGTH ]]
  do
 [[ "$(grep "$COLORS Colors, $BLOCKS Blocks" "$SHARE_DIR/hiscores.txt" |sort -h|cat -n|sed -n ${i}p|awk '{print $3,$4}')" == "$WIN_TIME" ]]&&h="${I}"||h=""
  echo -e "${h}\e[3${ii}m""$(grep "$COLORS Colors, $BLOCKS Blocks" "$SHARE_DIR/hiscores.txt" |sort -h|cat -n|sed -n ${i}p|sed 's/@.*//')""${n}"

   sleep 0.2
   ((i++));((ii++))
   [[ $ii -gt 7 ]]&&ii=1
  done
 else echo -e "No statistics available just yet."
 fi
}

function win_game()
{
 WIN=1
 for ((x=0;x<COLORS;x++))
 do
  for ((y=0;y<BLOCKS;y++))
  do
   [[ ${STACK[x]:y:1} != $((x+1)) ]]&&WIN=0&&break
  done
  [[ $WIN == 0 ]]&&break
 done
 if [[ $WIN == 1 ]]
 then
  WIN_TIME="$(date +%Y-%m-%d\ %T)"
  TIME="$(("$(date +%s)" - TIME_START))"
  SCORE="$((TIME+MOVES))"
  echo -e " \e[5m\e[1m$I$C3""  MISSION ACCOMPLISHED! $n\n \e[7m\e[1m${C1}  SCORE: $SCORE $n\n"
  
 if [[ $(grep -c "$COLORS Colors, $BLOCKS Blocks" "$SHARE_DIR/hiscores.txt") -lt 1 ]]
 then
  TENTH="$((SCORE+100))"; #avoid first time error
 else
  TENTH="$(sort -h "$SHARE_DIR/hiscores.txt"|grep "$COLORS Colors, $BLOCKS Blocks"|head -10|tail -1|awk '{print $1}')"
 fi  
 if [ "$SCORE" -lt "$TENTH" ]||[[ "$(grep -c "$COLORS Colors, $BLOCKS Blocks" "$SHARE_DIR/hiscores.txt")" -lt 10 ]]
 then
  echo -e "$SCORE\t$WIN_TIME\t@$COLORS Colors, $BLOCKS Blocks">>"$SHARE_DIR/hiscores.txt"
  echo -e "${C1}That's right, you made it to the${n}\n"
  show_hiscores
 fi
  
 echo -e " ${C0}Press any key to continue$n"
 fi
}

function print_matrix()
{
 for (( x=0 ; x < COLORS ; x++ ))
 do
  echo -ne "${GRAB[x]}""       ""${n}${C0}  "
 done
 echo ""
 MARGIN=$((BLOCKS/COLORS))
 while [[ $BLOCKS -gt $((MARGIN*COLORS)) ]]
 do
  ((MARGIN++))

 done
 for ((x=$((BLOCKS+MARGIN));x>=0;x--))
 do
  for ((y=0;y<COLORS;y++))
  do
   if [[ ${STACK[y]:x:1} == "" ]] 
   then 
    brick="${C0}   ┃   ${n}"
   elif [[ $y == "$LIFTED" ]]&&[[ $x = $((${#STACK[y]}-1)) ]]
   then 
    brick="${C0}   ┃   ${n}"
   else
    brick="${I}\e[3${STACK[y]:x:1}m""▁▁▁▁▁▁▁${n}"
   fi
   echo -ne "$brick""  "
  done
  echo ""
 done
 echo ""
 for (( x=0 ; x < COLORS ; x++ ))
 do
  echo -ne "${X[x]}${F[x]}${n}  "
 done
 echo ""
 

}

function mv_cursor ()
{
 X[CURSOR]=${X[CURSOR]:5}
 X[NEW_CURSOR]="${I}${X[NEW_CURSOR]}"
if [[ $GRAB_TOGGLE == yes ]]
then 
 GRAB[CURSOR]=""
 GRAB[NEW_CURSOR]="$GRAB_HL"
 else
 GRAB[CURSOR]=""
 GRAB[NEW_CURSOR]=""
fi;
 CURSOR="$NEW_CURSOR"
}

function grab_down ()
{
 if [[ ${#STACK[CURSOR]} -le $((BLOCKS+MARGIN)) ]]||[[ ${STACK[CURSOR]} == "${STACK[LIFTED]}" ]]
 then
  GRAB_TOGGLE="no"
  STACK[CURSOR]="${STACK[CURSOR]}""${STACK[LIFTED]:(-1):1}"
  STACK[LIFTED]="${STACK[LIFTED]::-1}"
  LIFTED=""
  ((MOVES++))
 fi
 
}

function grab_up ()
{
 if [[ ${#STACK[CURSOR]} -gt 0 ]]
 then
  GRAB_TOGGLE="yes"
  GRAB_HL="${I}""\e[3${STACK[CURSOR]:(-1):1}m"
  LIFTED=$CURSOR
  ((MOVES++))
 fi
}

function play_menu ()
{
 db="";
# CURSOR="0"
# X[0]="${I}"${X[0]}
 while [[ "$db" != "m" ]]&&[[ "$db" != "M" ]]
 do
  clear
  print_matrix
  echo -e "${C0}╭────────────────────────╮"
  echo -e "${C0}│${C4}${b} $NAV_LEFT$NAV_RIGHT/arrows         ${n}${C2}Move ${C0}│"
  echo -e "${C0}├────────────────────────┤"
  echo -e "${C0}│${C4}${b} space        ${n}${C2}Lift/Drop ${C0}│"
  echo -e "${C0}├────────────────────────┤"
  echo -e "${C0}│${C4}${b} n             ${n}${C2}New Game ${C0}│"
  echo -e "${C0}├────────────────────────┤" 
  echo -e "${C0}│${C4}${b} m            ${n}${C2}Main Menu ${C0}│"
  echo -e "${C0}├────────────────────────┤"
  echo -e "${C0}│${C4}${b} q                 ${n}${C2}Quit ${C0}│"
  echo -e "${C0}╰────────────────────────╯${n}"
  win_game
  #load_cheat
  read -sn 1 db
  [[ $WIN == 1 ]]&&db="m"&&WIN=0
  [[ $(echo "$db" | od) = "$spacebar" ]]&&db="$spacebar"
  case $db in
   n|N)db="";load_new_game;play_menu;
   ;;
   "$NAV_RIGHT"|C) if  [[ $CURSOR -lt  $((COLORS-1)) ]]; then NEW_CURSOR=$((CURSOR+1));mv_cursor;fi;
   ;;
   "$NAV_LEFT"|D) if  [[ $CURSOR -gt 0 ]]; then NEW_CURSOR=$((CURSOR-1));mv_cursor;fi;
   ;;
   "$spacebar")if [[ $GRAB_TOGGLE == yes ]];then grab_down;else grab_up;fi;NEW_CURSOR=$CURSOR;mv_cursor;
   ;;
   q|Q)clear;exit
   ;;
   *)
  esac
 done
 clear

}



function main_menu ()
{
clear
 mm=""
 while [[ "$mm" != "q" ]]&&[[ "$mm" != "Q" ]]
 do
  echo -e "${C0}╭────────────────────────╮"
  echo -e "${C0}│  ${C3}${b}S T A C K A B R I X ${n}  ${C0}│"
  echo -e "${C0}├────────────────────────┤"
  echo -e "${C0}│${C4}${b} n             ${n}${C2}New Game ${C0}│"
  echo -e "${C0}├────────────────────────┤"
  echo -e "${C0}│${C4}${b} c            ${n}${C2}Configure ${C0}│"
  echo -e "${C0}├────────────────────────┤"
  echo -e "${C0}│${C4}${b} h           ${n}${C2}Highscores ${C0}│"
  echo -e "${C0}├────────────────────────┤" 
  echo -e "${C0}│${C4}${b} q                 ${n}${C2}Quit ${C0}│"
  echo -e "${C0}╰────────────────────────╯${n}"
  read -sn 1 mm
  case $mm in
   n|N)db="";load_new_game;play_menu;
   ;;
   c) clear;eval "$PREFERRED_EDITOR" "$CONFIG_FILE";tput civis;load_config
   ;;
   h|H)clear;WIN_TIME="";show_hiscores;echo -e "\n${C0}Press any key to return${n}";read -sN 1 v;clear;
   ;;
   q|Q)clear;
   ;;
   *)clear;
  esac
 done
}

function cursor_reappear() {
echo -e "\x1b[?25h"
exit
}
######################
trap cursor_reappear HUP INT QUIT TERM EXIT ABRT
echo -e "\x1b[?25l" # make cursor invisible
spacebar=$(cat << eof
0000000 000012
0000001
eof
)
I="\e[7m" #invert
J="\e[5m" #blink
n="\e[m" #reset
CONFIG_FILE="$HOME/.config/stackabrix/stackabrix.config"
SHARE_DIR="$HOME/.local/share/stackabrix/"
############## GAME ####################
load_config
load_colors
main_menu
