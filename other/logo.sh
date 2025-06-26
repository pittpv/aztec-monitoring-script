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
echo

# Информация в рамке
info_lines=(
  "✦ Made by Pittpv                                            "
  "✦ Feedback & Support in Tg: https://t.me/+DLsyG6ol3SFjM2Vk  "
  "✦ Donate                                                    "
  "  EVM: 0x4FD5eC033BA33507E2dbFE57ca3ce0A6D70b48Bf"
  "  SOL: C9TV7Q4N77LrKJx4njpdttxmgpJ9HGFmQAn7GyDebH4R"
)

# Вычисляем максимальную длину строки
max_len=0
for line in "${info_lines[@]}"; do
  # Не учитываем цвета при подсчёте длины
  clean_line=$(echo -e "$line" | sed -E 's/\x1B\[[0-9;]*[mK]//g')
  [ ${#clean_line} -gt $max_len ] && max_len=${#clean_line}
done

# Строим рамки
top_border="╔$(printf '═%.0s' $(seq 1 $((max_len + 2))))╗"
bottom_border="╚$(printf '═%.0s' $(seq 1 $((max_len + 2))))╝"

# Печать рамки
echo -e "${b}${top_border}${r}"
for line in "${info_lines[@]}"; do
  # Выводим строку с цветом, но выравниваем по чистой длине
  clean_line=$(echo -e "$line" | sed -E 's/\x1B\[[0-9;]*[mK]//g')
  printf "${b}║ ${y}%-*s ${b}║\n" "$max_len" "$line"
done
echo -e "${b}${bottom_border}${r}"
echo
