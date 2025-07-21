#!/bin/bash
#
# Функция загрузки RPC URL с обработкой ошибок
load_rpc_config() {
    # Проверяем существование файла конфигурации
    if [ -f "/root/.env-aztec-agent" ]; then
        # Загружаем конфиг
        source "/root/.env-aztec-agent"

        # Проверяем наличие RPC_URL
        if [ -z "$RPC_URL" ]; then
            echo -e "${RED}$(t "error_rpc_missing")${RESET}"
            exit 1
        fi
    else
        # Файл не найден
        echo -e "${RED}$(t "error_file_missing")${RESET}"
        exit 1
    fi
}

# === Language settings ===
LANG="en"
declare -A TRANSLATIONS

# Initialize languages
init_languages() {
  # Check if language is passed as argument
  if [ -n "$1" ]; then
    case $1 in
      "en") LANG="en" ;;
      "ru") LANG="ru" ;;
      "tr") LANG="tr" ;;

    esac
  else
    # Default to English if no language specified
    LANG="en"
  fi

  # English translations
  TRANSLATIONS["en,fetching_validators"]="Fetching validator list from contract"
  TRANSLATIONS["en,found_validators"]="Found validators:"
  TRANSLATIONS["en,checking_validators"]="Checking validators..."
  TRANSLATIONS["en,check_completed"]="Check completed."
  TRANSLATIONS["en,select_action"]="Select an action:"
  TRANSLATIONS["en,option1"]="1. Search and display data for a specific validator"
  TRANSLATIONS["en,option2"]="2. Display the full validator list"
  TRANSLATIONS["en,option3"]="3. Back"
  TRANSLATIONS["en,enter_option"]="Select option:"
  TRANSLATIONS["en,enter_address"]="Enter the validator address:"
  TRANSLATIONS["en,validator_info"]="Validator information:"
  TRANSLATIONS["en,address"]="Address"
  TRANSLATIONS["en,stake"]="Stake"
  TRANSLATIONS["en,withdrawer"]="Withdrawer"
  TRANSLATIONS["en,proposer"]="Proposer"
  TRANSLATIONS["en,status"]="Status"
  TRANSLATIONS["en,validator_not_found"]="Validator with address %s not found."
  TRANSLATIONS["en,exiting"]="Exiting."
  TRANSLATIONS["en,invalid_input"]="Invalid input. Please choose 1, 2 or 3."
  TRANSLATIONS["en,status_0"]="NOT_IN_SET - The validator is not in the validator set"
  TRANSLATIONS["en,status_1"]="ACTIVE - The validator is currently in the validator set"
  TRANSLATIONS["en,status_2"]="INACTIVE - The validator is not active; possibly in withdrawal delay"
  TRANSLATIONS["en,status_3"]="READY_TO_EXIT - The validator has completed exit delay and can be exited"
  TRANSLATIONS["en,error_rpc_missing"]="Error: RPC_URL not found in /root/.env-aztec-agent"
  TRANSLATIONS["en,error_file_missing"]="Error: /root/.env-aztec-agent file not found"

  # Russian translations
  TRANSLATIONS["ru,fetching_validators"]="Получение списка валидаторов из контракта"
  TRANSLATIONS["ru,found_validators"]="Найдено валидаторов:"
  TRANSLATIONS["ru,checking_validators"]="Проверка валидаторов..."
  TRANSLATIONS["ru,check_completed"]="Проверка завершена."
  TRANSLATIONS["ru,select_action"]="Выберите действие:"
  TRANSLATIONS["ru,option1"]="1. Поиск и отображение данных конкретного валидатора"
  TRANSLATIONS["ru,option2"]="2. Отобразить полный список валидаторов"
  TRANSLATIONS["ru,option3"]="3. Назад"
  TRANSLATIONS["ru,enter_option"]="Выберите опцию:"
  TRANSLATIONS["ru,enter_address"]="Введите адрес валидатора:"
  TRANSLATIONS["ru,validator_info"]="Информация о валидаторе:"
  TRANSLATIONS["ru,address"]="Адрес"
  TRANSLATIONS["ru,stake"]="Стейк"
  TRANSLATIONS["ru,withdrawer"]="Withdrawer адрес"
  TRANSLATIONS["ru,proposer"]="Proposer адрес"
  TRANSLATIONS["ru,status"]="Статус"
  TRANSLATIONS["ru,validator_not_found"]="Валидатор с адресом %s не найден."
  TRANSLATIONS["ru,exiting"]="Выход."
  TRANSLATIONS["ru,invalid_input"]="Неверный ввод. Пожалуйста, выберите 1, 2 или 3."
  TRANSLATIONS["ru,status_0"]="NOT_IN_SET - Валидатор не в наборе валидаторов"
  TRANSLATIONS["ru,status_1"]="ACTIVE - Валидатор в настоящее время в наборе валидаторов"
  TRANSLATIONS["ru,status_2"]="INACTIVE - Валидатор не активен; возможно, в задержке вывода"
  TRANSLATIONS["ru,status_3"]="READY_TO_EXIT - Валидатор завершил задержку выхода и может быть выведен"
  TRANSLATIONS["ru,error_rpc_missing"]="Ошибка: RPC_URL не найден в /root/.env-aztec-agent"
  TRANSLATIONS["ru,error_file_missing"]="Ошибка: файл /root/.env-aztec-agent не найден"

  #Turkish translations
  TRANSLATIONS["tr,fetching_validators"]="Doğrulayıcı listesi kontrattan alınıyor"
  TRANSLATIONS["tr,found_validators"]="Bulunan doğrulayıcılar:"
  TRANSLATIONS["tr,checking_validators"]="Doğrulayıcılar kontrol ediliyor..."
  TRANSLATIONS["tr,check_completed"]="Kontrol tamamlandı."
  TRANSLATIONS["tr,select_action"]="Bir işlem seçin:"
  TRANSLATIONS["tr,option1"]="1. Belirli bir doğrulayıcı için arama yap ve verileri göster"
  TRANSLATIONS["tr,option2"]="2. Tam doğrulayıcı listesini göster"
  TRANSLATIONS["tr,option3"]="3. Geri"
  TRANSLATIONS["tr,enter_option"]="Seçenek seçin:"
  TRANSLATIONS["tr,enter_address"]="Doğrulayıcı adresini girin:"
  TRANSLATIONS["tr,validator_info"]="Doğrulayıcı bilgisi:"
  TRANSLATIONS["tr,address"]="Adres"
  TRANSLATIONS["tr,stake"]="Stake"
  TRANSLATIONS["tr,withdrawer"]="Çekici"
  TRANSLATIONS["tr,proposer"]="Öneren"
  TRANSLATIONS["tr,status"]="Durum"
  TRANSLATIONS["tr,validator_not_found"]="%s adresli doğrulayıcı bulunamadı."
  TRANSLATIONS["tr,exiting"]="Çıkılıyor."
  TRANSLATIONS["tr,invalid_input"]="Geçersiz giriş. Lütfen 1, 2 veya 3 seçin."
  TRANSLATIONS["tr,status_0"]="NOT_IN_SET - Doğrulayıcı, doğrulayıcı setinde değil"
  TRANSLATIONS["tr,status_1"]="AKTİF - Doğrulayıcı şu anda doğrulayıcı setinde"
  TRANSLATIONS["tr,status_2"]="PASİF - Doğrulayıcı aktif değil; muhtemelen çekme gecikmesinde"
  TRANSLATIONS["tr,status_3"]="ÇIKIŞA_HAZIR - Doğrulayıcı çıkış gecikmesini tamamladı ve çıkış yapılabilir"
  TRANSLATIONS["tr,error_rpc_missing"]="Hata: /root/.env-aztec-agent dosyasında RPC_URL bulunamadı"
  TRANSLATIONS["tr,error_file_missing"]="Hata: /root/.env-aztec-agent dosyası bulunamadı"
}

# Translation function
t() {
  local key=$1
  local value="${TRANSLATIONS[$LANG,$key]}"

  # Handle printf-style formatting
  if [[ $# -gt 1 ]]; then
    printf -v value "${value}" "${@:2}"
  fi

  echo "${value}"
}

# Initialize language system with first argument
init_languages "$1"

ROLLUP_ADDRESS="0x216f071653a82ced3ef9d29f3f0c0ed7829c8f81"

load_rpc_config

# Цвета
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
GRAY="\e[90m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

declare -A STATUS_MAP=(
    [0]=$(t "status_0")
    [1]=$(t "status_1")
    [2]=$(t "status_2")
    [3]=$(t "status_3")
)

declare -A STATUS_COLOR=(
    [0]="$GRAY"
    [1]="$GREEN"
    [2]="$YELLOW"
    [3]="$RED"
)

hex_to_dec() {
    local hex=${1^^}
    echo "ibase=16; $hex" | bc
}

hex_to_address() {
    local hex=$1
    echo "0x${hex:24:40}"
}

wei_to_token() {
    local wei_value=$1
    local int_part=$(echo "$wei_value / 1000000000000000000" | bc)
    local frac_part=$(echo "$wei_value % 1000000000000000000" | bc)
    local frac_str=$(printf "%018d" $frac_part)
    frac_str=$(echo "$frac_str" | sed 's/0*$//')
    if [[ -z "$frac_str" ]]; then
        echo "$int_part"
    else
        echo "$int_part.$frac_str"
    fi
}

progress_bar() {
    local current=$1
    local total=$2
    local width=40
    local filled=$(( current * width / total ))
    local empty=$(( width - filled ))

    printf "\r["
    for ((i=0; i<filled; i++)); do printf "="; done
    for ((i=0; i<empty; i++)); do printf " "; done
    printf "] %d/%d" "$current" "$total"
}

echo -e "${BOLD}$(t "fetching_validators") ${CYAN}$ROLLUP_ADDRESS${RESET}..."
echo -e ""
VALIDATORS_RESPONSE=$(cast call $ROLLUP_ADDRESS "getAttesters()" --rpc-url $RPC_URL)
VALIDATORS_HEX=${VALIDATORS_RESPONSE:130}
VALIDATOR_COUNT=$(( ${#VALIDATORS_HEX} / 64 ))
VALIDATOR_ADDRESSES=()

for (( i=0; i<$VALIDATOR_COUNT; i++ )); do
    PART=${VALIDATORS_HEX:$((i*64)):64}
    ADDRESS_HEX=${PART:24:40}
    VALIDATOR_ADDRESSES+=("0x$ADDRESS_HEX")
done

echo -e "${GREEN}$(t "found_validators")${RESET} ${BOLD}${#VALIDATOR_ADDRESSES[@]}${RESET}"
echo "----------------------------------------"

# Временный файл для результатов
TMP_RESULTS=$(mktemp)
trap 'rm -f "$TMP_RESULTS"' EXIT

echo -e "${BOLD}$(t "checking_validators")${RESET}"

CURRENT=0

for validator in "${VALIDATOR_ADDRESSES[@]}"; do
    (
        info=$(cast call $ROLLUP_ADDRESS "getInfo(address)" $validator --rpc-url $RPC_URL 2>/dev/null)
        # Проверяем успешность вызова
        if [[ $? -ne 0 || -z "$info" ]]; then
            echo "$validator|ERROR" >> "$TMP_RESULTS"
            exit 0
        fi
        info_hex=${info:2}

        stake_hex=${info_hex:0:64}
        withdrawer_hex=${info_hex:64:64}
        proposer_hex=${info_hex:128:64}
        status_hex=${info_hex:254:2}

        stake_raw=$(hex_to_dec "$stake_hex")
        stake=$(wei_to_token "$stake_raw")
        withdrawer=$(hex_to_address "$withdrawer_hex")
        proposer=$(hex_to_address "$proposer_hex")
        status=$(hex_to_dec "$status_hex")

        echo "$validator|$stake|$withdrawer|$proposer|$status" >> "$TMP_RESULTS"
    ) &
done

# Ждем окончания всех подпроцессов, обновляя прогресс
while true; do
    CURRENT=$(wc -l < "$TMP_RESULTS" 2>/dev/null || echo 0)
    progress_bar $CURRENT $VALIDATOR_COUNT
    if [[ $CURRENT -ge $VALIDATOR_COUNT ]]; then
        break
    fi
    sleep 0.1
done

echo -e "\n${GREEN}${BOLD}$(t "check_completed")${RESET}"
echo "----------------------------------------"

declare -a RESULTS

# Обработка результатов
while IFS='|' read -r validator stake withdrawer proposer status; do
    if [[ "$stake" == "ERROR" ]]; then
        echo -e "${RED}$(t "error_fetching_info") $validator${RESET}"
        continue
    fi

    status_text=${STATUS_MAP[$status]:-UNKNOWN}
    status_color=${STATUS_COLOR[$status]:-$RESET}

    RESULTS+=("$validator|$stake|$withdrawer|$proposer|$status|$status_text|$status_color")
done < "$TMP_RESULTS"

# Меню
while true; do
    echo ""
    echo -e "${BOLD}$(t "select_action")${RESET}"
    echo -e "${CYAN}$(t "option1")${RESET}"
    echo -e "${CYAN}$(t "option2")${RESET}"
    echo -e "${RED}$(t "option3")${RESET}"
    read -p "$(t "enter_option") " choice

    case $choice in
        1)
            read -p "$(t "enter_address") " search_address
            found=false
            for line in "${RESULTS[@]}"; do
                IFS='|' read -r validator stake withdrawer proposer status status_text status_color <<< "$line"
                if [[ "${validator,,}" == "${search_address,,}" ]]; then
                    echo -e "\n${BOLD}$(t "validator_info")${RESET}\n"
                    echo -e "  ${BOLD}$(t "address"):${RESET} $validator"
                    echo -e "  ${BOLD}$(t "stake"):${RESET} $stake STK"
                    echo -e "  ${BOLD}$(t "withdrawer"):${RESET} $withdrawer"
                    echo -e "  ${BOLD}$(t "proposer"):${RESET} $proposer"
                    echo -e "  ${BOLD}$(t "status"):${RESET} ${status_color}$status ($status_text)${RESET}\n"
                    found=true
                    break
                fi
            done
            if ! $found; then
                echo -e "\n${RED}$(t "validator_not_found" "$search_address")${RESET}"
            fi
            ;;
        2)
            echo ""
            for line in "${RESULTS[@]}"; do
                IFS='|' read -r validator stake withdrawer proposer status status_text status_color <<< "$line"
                echo -e "${BOLD}$(t "address"):${RESET} $validator"
                echo -e "  ${BOLD}$(t "stake"):${RESET} $stake STK"
                echo -e "  ${BOLD}$(t "withdrawer"):${RESET} $withdrawer"
                echo -e "  ${BOLD}$(t "proposer"):${RESET} $proposer"
                echo -e "  ${BOLD}$(t "status"):${RESET} ${status_color}$status ($status_text)${RESET}"
                echo -e ""
                echo "----------------------------------------"
            done
            ;;
        3)
            echo -e "\n${CYAN}$(t "exiting")${RESET}"
            break
            ;;
        *)
            echo -e "\n${RED}$(t "invalid_input")${RESET}"
            ;;
    esac
done
