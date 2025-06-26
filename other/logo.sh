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

# Цвета
b=$'\033[34m' # Blue
y=$'\033[33m' # Yellow
r=$'\033[0m'  # Reset

# Информация в рамке
info_lines=(
  "✦ Made by Pittpv"
  "✦ Feedback & Support in Tg: https://t.me/+DLsyG6ol3SFjM2Vk"
  "✦ Donate"
  "  EVM: 0x4FD5eC033BA33507E2dbFE57ca3ce0A6D70b48Bf"
  "  SOL: C9TV7Q4N77LrKJx4njpdttxmgpJ9HGFmQAn7GyDebH4R"
)

# Вычисляем максимальную длину строки (с учётом Unicode-символов)
max_len=0
for line in "${info_lines[@]}"; do
  clean_line=$(echo -e "$line" | sed -E 's/\x1B\[[0-9;]*[mK]//g')
  line_length=$(echo -n "$clean_line" | wc -m)
  [ "$line_length" -gt "$max_len" ] && max_len=$line_length
done

# Строим рамки
top_border="╔$(printf '═%.0s' $(seq 1 $((max_len + 2))))╗"
bottom_border="╚$(printf '═%.0s' $(seq 1 $((max_len + 2))))╝"

# Печать рамки
echo -e "${b}${top_border}${r}"
for line in "${info_lines[@]}"; do
  clean_line=$(echo -e "$line" | sed -E 's/\x1B\[[0-9;]*[mK]//g')
  line_length=$(echo -n "$clean_line" | wc -m)
  padding=$((max_len - line_length))
  printf "${b}║ ${y}%s%*s ${b}║\n" "$line" "$padding" ""
done
echo -e "${b}${bottom_border}${r}"
echo
