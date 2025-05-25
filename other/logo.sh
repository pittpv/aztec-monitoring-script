#!/bin/bash

# Colors
g="\033[32m" # Green
y="\033[33m" # Yellow
b="\033[34m" # Blue
p="\033[35m" # Purple
r="\033[0m"  # Reset
bold="\033[1m"

function print_colored() {
  local b=$'\033[34m' # Blue
  local y=$'\033[33m' # Yellow
  local r=$'\033[0m'  # Reset
  echo "$1" | sed -E "s/(█+)/${b}\1${y}/g"
}
  echo
  print_colored " █████╗ ███████╗████████╗███████╗ ██████╗"
  print_colored "██╔══██╗╚══███╔╝╚══██╔══╝██╔════╝██╔════╝"
  print_colored "███████║  ███╔╝    ██║   █████╗  ██║"
  print_colored "██╔══██║ ███╔╝     ██║   ██╔══╝  ██║"
  print_colored "██║  ██║███████╗   ██║   ███████╗╚██████╗"
  print_colored "╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝ ╚═════╝"
  echo -e " "
  echo -e " "
  echo -e "${RESET}"
