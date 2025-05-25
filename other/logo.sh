function print_colored() {
  local b=$'\033[34m' # Blue
  local y=$'\033[33m' # Yellow
  local r=$'\033[0m'  # Reset
  echo -e "${b}$(echo "$1" | sed -E "s/(█+)/${y}\1${b}/g")${r}"
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
