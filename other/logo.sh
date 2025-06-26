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

# Функция для визуальной длины строки (✦ = 2, остальные = 1)
get_visual_length() {
  local input="$1"
  local len=0
  local i char
  for (( i=0; i<${#input}; i++ )); do
    char="${input:$i:1}"
    if [[ "$char" == "✦" ]]; then
      ((len+=2))
    else
      ((len+=1))
    fi
  done
  echo "$len"
}

# Вычисляем максимальную длину строки
max_len=0
for line in "${info_lines[@]}"; do
  clean_line=$(echo -e "$line" | sed -E 's/\x1B\[[0-9;]*[mK]//g')
  line_length=$(get_visual_length "$clean_line")
  (( line_length > max_len )) && max_len=$line_length
done

# Строим рамки
top_border="╔$(printf '═%.0s' $(seq 1 $((max_len + 2))))╗"
bottom_border="╚$(printf '═%.0s' $(seq 1 $((max_len + 2))))╝"

# Печать рамки
echo -e "${b}${top_border}${r}"
for line in "${info_lines[@]}"; do
  clean_line=$(echo -e "$line" | sed -E 's/\x1B\[[0-9;]*[mK]//g')
  visual_len=$(get_visual_length "$clean_line")
  padding=$((max_len - visual_len))
  printf "${b}║ ${y}%s%*s ${b}║\n" "$line" "$padding" ""
done
echo -e "${b}${bottom_border}${r}"
