#!/bin/bash

# Функция загрузки RPC URL с обработкой ошибок
load_rpc_config() {
    if [ -f "/root/.env-aztec-agent" ]; then
        source "/root/.env-aztec-agent"
        if [ -z "$RPC_URL" ]; then
            echo -e "${RED}$(t "error_rpc_missing")${RESET}"
            exit 1
        fi
        if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
            echo -e "${YELLOW}Warning: TELEGRAM_BOT_TOKEN or TELEGRAM_CHAT_ID not found in /root/.env-aztec-agent${RESET}"
        fi
    else
        echo -e "${RED}$(t "error_file_missing")${RESET}"
        exit 1
    fi
}

# === Language settings ===
LANG="en"
declare -A TRANSLATIONS

init_languages() {
    if [ -n "$1" ]; then
        case $1 in
            "en") LANG="en" ;;
            "ru") LANG="ru" ;;
            "tr") LANG="tr" ;;
        esac
    else
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
    TRANSLATIONS["en,option3"]="3. Set up queue position notification for validator"
    TRANSLATIONS["en,option0"]="0. Exit"
    TRANSLATIONS["en,enter_option"]="Select option:"
    TRANSLATIONS["en,enter_address"]="Enter the validator address:"
    TRANSLATIONS["en,validator_info"]="Validator information:"
    TRANSLATIONS["en,address"]="Address"
    TRANSLATIONS["en,stake"]="Stake"
    TRANSLATIONS["en,withdrawer"]="Withdrawer"
    TRANSLATIONS["en,status"]="Status"
    TRANSLATIONS["en,validator_not_found"]="Validator with address %s not found."
    TRANSLATIONS["en,exiting"]="Exiting."
    TRANSLATIONS["en,invalid_input"]="Invalid input. Please choose 1, 2, 3 or 0."
    TRANSLATIONS["en,status_0"]="NOT_IN_SET - The validator is not in the validator set"
    TRANSLATIONS["en,status_1"]="ACTIVE - The validator is currently in the validator set"
    TRANSLATIONS["en,status_2"]="INACTIVE - The validator is not active; possibly in withdrawal delay"
    TRANSLATIONS["en,status_3"]="READY_TO_EXIT - The validator has completed exit delay and can be exited"
    TRANSLATIONS["en,error_rpc_missing"]="Error: RPC_URL not found in /root/.env-aztec-agent"
    TRANSLATIONS["en,error_file_missing"]="Error: /root/.env-aztec-agent file not found"
    TRANSLATIONS["en,select_mode"]="Select loading mode:"
    TRANSLATIONS["en,mode_fast"]="1. Fast mode (high CPU load)"
    TRANSLATIONS["en,mode_slow"]="2. Slow mode (low CPU load)"
    TRANSLATIONS["en,mode_invalid"]="Invalid mode selected. Please choose 1 or 2."
    TRANSLATIONS["en,checking_queue"]="Checking validator queue..."
    TRANSLATIONS["en,validator_in_queue"]="Validator found in queue:"
    TRANSLATIONS["en,position"]="Position"
    TRANSLATIONS["en,queued_at"]="Queued at"
    TRANSLATIONS["en,not_in_queue"]="Validator is not in the queue either."
    TRANSLATIONS["en,fetching_queue"]="Fetching validator queue data..."
    TRANSLATIONS["en,notification_script_created"]="Notification script created and scheduled. Monitoring validator: %s"
    TRANSLATIONS["en,notification_exists"]="Notification for this validator already exists."
    TRANSLATIONS["en,enter_validator_address"]="Enter validator address to monitor:"
    TRANSLATIONS["en,notification_removed"]="Notification for validator %s has been removed."
    TRANSLATIONS["en,no_notifications"]="No active notifications found."
    TRANSLATIONS["en,validator_not_in_queue"]="Validator not found in queue either. Please check the address."
    TRANSLATIONS["en,validator_not_in_set"]="Validator not found in current validator set. Checking queue..."
    TRANSLATIONS["en,queue_notification_title"]="Validator queue position notification"
    TRANSLATIONS["en,active_monitors"]="Active validator monitors:"
    TRANSLATIONS["en,enter_multiple_addresses"]="Enter validator addresses to monitor (comma separated):"
    TRANSLATIONS["en,invalid_address_format"]="Invalid address format: %s"
    TRANSLATIONS["en,processing_address"]="Processing address: %s"
    TRANSLATIONS["en,fetching_page"]="Fetching page %d of %d..."

    # Russian translations
    TRANSLATIONS["ru,fetching_validators"]="Получение списка валидаторов из контракта"
    TRANSLATIONS["ru,found_validators"]="Найдено валидаторов:"
    TRANSLATIONS["ru,checking_validators"]="Проверка валидаторов..."
    TRANSLATIONS["ru,check_completed"]="Проверка завершена."
    TRANSLATIONS["ru,select_action"]="Выберите действие:"
    TRANSLATIONS["ru,option1"]="1. Поиск и отображение данных конкретного валидатора"
    TRANSLATIONS["ru,option2"]="2. Отобразить полный список валидаторов"
    TRANSLATIONS["ru,option3"]="3. Настроить уведомление об изменении позиции в очереди"
    TRANSLATIONS["ru,option0"]="0. Выход"
    TRANSLATIONS["ru,enter_option"]="Выберите опцию:"
    TRANSLATIONS["ru,enter_address"]="Введите адрес валидатора:"
    TRANSLATIONS["ru,validator_info"]="Информация о валидаторе:"
    TRANSLATIONS["ru,address"]="Адрес"
    TRANSLATIONS["ru,stake"]="Стейк"
    TRANSLATIONS["ru,withdrawer"]="Withdrawer адрес"
    TRANSLATIONS["ru,status"]="Статус"
    TRANSLATIONS["ru,validator_not_found"]="Валидатор с адресом %s не найден."
    TRANSLATIONS["ru,exiting"]="Выход."
    TRANSLATIONS["ru,invalid_input"]="Неверный ввод. Пожалуйста, выберите 1, 2, 3 или 0."
    TRANSLATIONS["ru,status_0"]="NOT_IN_SET - Валидатор не в наборе валидаторов"
    TRANSLATIONS["ru,status_1"]="ACTIVE - Валидатор в настоящее время в наборе валидаторов"
    TRANSLATIONS["ru,status_2"]="INACTIVE - Валидатор не активен; возможно, в задержке вывода"
    TRANSLATIONS["ru,status_3"]="READY_TO_EXIT - Валидатор завершил задержку выхода и может быть выведен"
    TRANSLATIONS["ru,error_rpc_missing"]="Ошибка: RPC_URL не найден в /root/.env-aztec-agent"
    TRANSLATIONS["ru,error_file_missing"]="Ошибка: файл /root/.env-aztec-agent не найден"
    TRANSLATIONS["ru,select_mode"]="Выберите режим загрузки:"
    TRANSLATIONS["ru,mode_fast"]="1. Быстрый режим (высокая нагрузка на CPU)"
    TRANSLATIONS["ru,mode_slow"]="2. Медленный режим (низкая нагрузка на CPU)"
    TRANSLATIONS["ru,mode_invalid"]="Неверный режим. Пожалуйста, выберите 1 или 2."
    TRANSLATIONS["ru,checking_queue"]="Проверка очереди валидаторов..."
    TRANSLATIONS["ru,validator_in_queue"]="Валидатор найден в очереди:"
    TRANSLATIONS["ru,position"]="Позиция"
    TRANSLATIONS["ru,queued_at"]="Добавлен в очередь"
    TRANSLATIONS["ru,not_in_queue"]="Валидатора нет и в очереди."
    TRANSLATIONS["ru,fetching_queue"]="Получение данных очереди валидаторов..."
    TRANSLATIONS["ru,notification_script_created"]="Скрипт уведомления создан и запланирован. Мониторинг валидатора: %s"
    TRANSLATIONS["ru,notification_exists"]="Уведомление для этого валидатора уже существует."
    TRANSLATIONS["ru,enter_validator_address"]="Введите адрес валидатора для мониторинга:"
    TRANSLATIONS["ru,notification_removed"]="Уведомление для валидатора %s удалено."
    TRANSLATIONS["ru,no_notifications"]="Активных уведомлений не найдено."
    TRANSLATIONS["ru,validator_not_in_queue"]="Валидатор не найден и в очереди. Пожалуйста, проверьте адрес."
    TRANSLATIONS["ru,validator_not_in_set"]="Валидатор не найден в текущем наборе. Проверяем очередь..."
    TRANSLATIONS["ru,queue_notification_title"]="Уведомление о позиции в очереди валидаторов"
    TRANSLATIONS["ru,active_monitors"]="Активные мониторы валидаторов:"
    TRANSLATIONS["ru,enter_multiple_addresses"]="Введите адреса валидаторов для мониторинга (через запятую):"
    TRANSLATIONS["ru,invalid_address_format"]="Неверный формат адреса: %s"
    TRANSLATIONS["ru,processing_address"]="Обработка адреса: %s"
    TRANSLATIONS["ru,fetching_page"]="Получение страницы %d из %d..."

    # Turkish translations
    TRANSLATIONS["tr,fetching_validators"]="Doğrulayıcı listesi kontrattan alınıyor"
    TRANSLATIONS["tr,found_validators"]="Bulunan doğrulayıcılar:"
    TRANSLATIONS["tr,checking_validators"]="Doğrulayıcılar kontrol ediliyor..."
    TRANSLATIONS["tr,check_completed"]="Kontrol tamamlandı."
    TRANSLATIONS["tr,select_action"]="Bir işlem seçin:"
    TRANSLATIONS["tr,option1"]="1. Belirli bir doğrulayıcı için arama yap ve verileri göster"
    TRANSLATIONS["tr,option2"]="2. Tam doğrulayıcı listesini göster"
    TRANSLATIONS["tr,option3"]="3. Doğrulayıcı sıra pozisyonu bildirimi ayarla"
    TRANSLATIONS["tr,option0"]="0. Çıkış"
    TRANSLATIONS["tr,enter_option"]="Seçenek seçin:"
    TRANSLATIONS["tr,enter_address"]="Doğrulayıcı adresini girin:"
    TRANSLATIONS["tr,validator_info"]="Doğrulayıcı bilgisi:"
    TRANSLATIONS["tr,address"]="Adres"
    TRANSLATIONS["tr,stake"]="Stake"
    TRANSLATIONS["tr,withdrawer"]="Çekici"
    TRANSLATIONS["tr,status"]="Durum"
    TRANSLATIONS["tr,validator_not_found"]="%s adresli doğrulayıcı bulunamadı."
    TRANSLATIONS["tr,exiting"]="Çıkılıyor."
    TRANSLATIONS["tr,invalid_input"]="Geçersiz giriş. Lütfen 1, 2, 3 veya 0 seçin."
    TRANSLATIONS["tr,status_0"]="NOT_IN_SET - Doğrulayıcı, doğrulayıcı setinde değil"
    TRANSLATIONS["tr,status_1"]="AKTİF - Doğrulayıcı şu anda doğrulayıcı setinde"
    TRANSLATIONS["tr,status_2"]="PASİF - Doğrulayıcı aktif değil; muhtemelen çekme gecikmesinde"
    TRANSLATIONS["tr,status_3"]="ÇIKIŞA_HAZIR - Doğrulayıcı çıkış gecikmesini tamamladı ve çıkış yapılabilir"
    TRANSLATIONS["tr,error_rpc_missing"]="Hata: /root/.env-aztec-agent dosyasında RPC_URL bulunamadı"
    TRANSLATIONS["tr,error_file_missing"]="Hata: /root/.env-aztec-agent dosyası bulunamadı"
    TRANSLATIONS["tr,select_mode"]="Yükleme modunu seçin:"
    TRANSLATIONS["tr,mode_fast"]="1. Hızlı mod (yüksek CPU yükü)"
    TRANSLATIONS["tr,mode_slow"]="2. Yavaş mod (düşük CPU yükü)"
    TRANSLATIONS["tr,mode_invalid"]="Geçersiz mod. Lütfen 1 или 2 seçin."
    TRANSLATIONS["tr,checking_queue"]="Doğrulayıcı kuyruğu kontrol ediliyor..."
    TRANSLATIONS["tr,validator_in_queue"]="Doğrulayıcı kuyrukta bulundu:"
    TRANSLATIONS["tr,position"]="Pozisyon"
    TRANSLATIONS["tr,queued_at"]="Kuyruğa eklendi"
    TRANSLATIONS["tr,not_in_queue"]="Doğrulayıcı kuyrukta da yok."
    TRANSLATIONS["tr,fetching_queue"]="Doğrulayıcı kuyruk verileri alınıyor..."
    TRANSLATIONS["tr,notification_script_created"]="Bildirim betiği oluşturuldu ve zamanlandı. İzlenen doğrulayıcı: %s"
    TRANSLATIONS["tr,notification_exists"]="Bu doğrulayıcı için zaten bir bildirim var."
    TRANSLATIONS["tr,enter_validator_address"]="İzlemek için doğrulayıcı adresini girin:"
    TRANSLATIONS["tr,notification_removed"]="%s doğrulayıcısı için bildirim kaldırıldı."
    TRANSLATIONS["tr,no_notifications"]="Aktif bildirim bulunamadı."
    TRANSLATIONS["tr,validator_not_in_queue"]="Doğrulayıcı kuyrukta da bulunamadı. Lütfen adresi kontrol edin."
    TRANSLATIONS["tr,validator_not_in_set"]="Doğrulayıcı mevcut doğrulayıcı setinde bulunamadı. Kuyruk kontrol ediliyor..."
    TRANSLATIONS["tr,queue_notification_title"]="Doğrulayıcı sıra pozisyon bildirimi"
    TRANSLATIONS["tr,active_monitors"]="Aktif doğrulayıcı izleyicileri:"
    TRANSLATIONS["tr,enter_multiple_addresses"]="İzlemek için doğrulayıcı adreslerini girin (virgülle ayrılmış):"
    TRANSLATIONS["tr,invalid_address_format"]="Geçersiz adres formatı: %s"
    TRANSLATIONS["tr,processing_address"]="Adres işleniyor: %s"
    TRANSLATIONS["tr,fetching_page"]="Sayfa %d/%d alınıyor..."
}

t() {
    local key=$1
    local value="${TRANSLATIONS[$LANG,$key]}"
    if [[ $# -gt 1 ]]; then
        printf -v value "${value}" "${@:2}"
    fi
    echo "${value}"
}

init_languages "$1"

ROLLUP_ADDRESS="0x216f071653a82ced3ef9d29f3f0c0ed7829c8f81"
QUEUE_URL="https://dashtec.xyz/api/validators/queue"
MONITOR_DIR="/root/aztec-monitor-agent"

load_rpc_config

# Цвета
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
GRAY="\e[90m"
CYAN="\e[36m"
BLUE="\e[34m"
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

# Функция для отправки уведомления в Telegram
send_telegram_notification() {
    local message="$1"
    if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
        echo -e "${YELLOW}Telegram notification not sent: missing TELEGRAM_BOT_TOKEN or TELEGRAM_CHAT_ID${RESET}"
        return 1
    fi

    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d chat_id="$TELEGRAM_CHAT_ID" \
        -d text="$message" \
        -d parse_mode="Markdown" > /dev/null
}

# Функция для проверки очереди валидаторов
check_validator_queue() {
    local validator_address=$1
    echo -e "${YELLOW}$(t "fetching_queue")${RESET}"

    # Получаем первую страницу для получения информации о пагинации
    first_page_data=$(curl -s "${QUEUE_URL}?page=1&limit=100")
    if [ $? -ne 0 ] || [ -z "$first_page_data" ]; then
        echo -e "${RED}Error fetching validator queue data${RESET}"
        return 1
    fi

    # Проверяем валидность JSON
    if ! jq -e . >/dev/null 2>&1 <<<"$first_page_data"; then
        echo -e "${RED}Invalid JSON data received from queue API${RESET}"
        return 1
    fi

    # Получаем общее количество страниц
    total_pages=$(echo "$first_page_data" | jq -r '.pagination.totalPages // 1')
    if [ -z "$total_pages" ] || [ "$total_pages" -lt 1 ]; then
        total_pages=1
    fi

    # Нормализуем адрес для поиска (нижний регистр)
    search_address_lower=${validator_address,,}
    found=false

    # Проверяем все страницы
    for ((page=1; page<=total_pages; page++)); do
        echo -e "${YELLOW}$(t "fetching_page" "$page" "$total_pages")${RESET}"

        # Получаем данные текущей страницы
        page_data=$(curl -s "${QUEUE_URL}?page=${page}&limit=100")
        if [ $? -ne 0 ] || [ -z "$page_data" ]; then
            echo -e "${RED}Error fetching page ${page}${RESET}"
            continue
        fi

        # Проверяем наличие валидатора на текущей странице
        validator_info=$(echo "$page_data" | jq -r ".validatorsInQueue[] | select(.address? | ascii_downcase == \"$search_address_lower\")")

        if [ -n "$validator_info" ]; then
            echo -e "\n${GREEN}$(t "validator_in_queue")${RESET}"
            echo -e "  ${BOLD}$(t "address"):${RESET} $(echo "$validator_info" | jq -r '.address')"
            echo -e "  ${BOLD}$(t "position"):${RESET} $(echo "$validator_info" | jq -r '.position')"
            echo -e "  ${BOLD}$(t "withdrawer"):${RESET} $(echo "$validator_info" | jq -r '.withdrawerAddress')"
            echo -e "  ${BOLD}$(t "queued_at"):${RESET} $(echo "$validator_info" | jq -r '.queuedAt')"
            found=true
            break
        fi
    done

    if ! $found; then
        echo -e "\n${RED}$(t "not_in_queue")${RESET}"
        return 1
    fi
    return 0
}

create_monitor_script() {
    local validator_addresses=$1
    local addresses=()

    # Разделяем адреса по запятой
    IFS=',' read -ra addresses <<< "$validator_addresses"

    for validator_address in "${addresses[@]}"; do
        validator_address=$(echo "$validator_address" | xargs) # Удаляем лишние пробелы
        if [[ ! "$validator_address" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
            echo -e "${RED}Invalid address format: $validator_address${RESET}"
            continue
        fi

        local normalized_address=${validator_address,,}
        local script_name="monitor_${normalized_address:2}.sh"
        local log_file="$MONITOR_DIR/monitor_${normalized_address:2}.log"
        local position_file="$MONITOR_DIR/last_position_${normalized_address:2}.txt"

        if [ -f "$MONITOR_DIR/$script_name" ]; then
            echo -e "${YELLOW}$(t "notification_exists")${RESET}"
            continue
        fi

        mkdir -p "$MONITOR_DIR"

        cat > "$MONITOR_DIR/$script_name" <<'EOF'
#!/bin/bash

# Set safe environment
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
set -euo pipefail

# Configuration
VALIDATOR_ADDRESS="VALIDATOR_ADDRESS_PLACEHOLDER"
QUEUE_URL="QUEUE_URL_PLACEHOLDER"
MONITOR_DIR="MONITOR_DIR_PLACEHOLDER"
LAST_POSITION_FILE="LAST_POSITION_FILE_PLACEHOLDER"
LOG_FILE="LOG_FILE_PLACEHOLDER"
TELEGRAM_BOT_TOKEN="TELEGRAM_BOT_TOKEN_PLACEHOLDER"
TELEGRAM_CHAT_ID="TELEGRAM_CHAT_ID_PLACEHOLDER"

mkdir -p "$MONITOR_DIR"

send_telegram() {
    local message="$1"

    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d chat_id="$TELEGRAM_CHAT_ID" \
        -d text="$message" \
        -d parse_mode="Markdown" \
        -w "\n%{http_code}" > /dev/null 2>&1
}

format_date() {
    local iso_date="$1"
    if [[ "$iso_date" =~ ^([0-9]{4})-([0-9]{2})-([0-9]{2})T([0-9]{2}):([0-9]{2}):([0-9]{2}) ]]; then
        echo "${BASH_REMATCH[3]}.${BASH_REMATCH[2]}.${BASH_REMATCH[1]} ${BASH_REMATCH[4]}:${BASH_REMATCH[5]} UTC"
    else
        echo "$iso_date"
    fi
}

monitor_position() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting monitor_position" >> "$LOG_FILE"

    local last_position=""
    if [[ -f "$LAST_POSITION_FILE" ]]; then
        last_position=$(cat "$LAST_POSITION_FILE")
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Last known position: $last_position" >> "$LOG_FILE"
    fi

    # Get first page to check pagination
    local first_page_data=$(curl -s "${QUEUE_URL}?page=1&limit=100")
    if [[ $? -ne 0 || -z "$first_page_data" ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error fetching first page data" >> "$LOG_FILE"
        return 1
    fi

    if ! jq -e . >/dev/null 2>&1 <<<"$first_page_data"; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Invalid first page data received" >> "$LOG_FILE"
        return 1
    fi

    local total_pages=$(echo "$first_page_data" | jq -r '.pagination.totalPages // 1')
    if [[ -z "$total_pages" || "$total_pages" -lt 1 ]]; then
        total_pages=1
    fi

    local validator_found=false
    local current_position=""

    # Check all pages
    for ((page=1; page<=total_pages; page++)); do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Checking page $page of $total_pages" >> "$LOG_FILE"

        local page_data=$(curl -s "${QUEUE_URL}?page=${page}&limit=100")
        if [[ $? -ne 0 || -z "$page_data" ]]; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error fetching page $page" >> "$LOG_FILE"
            continue
        fi

        local validator_info=$(echo "$page_data" | jq -r ".validatorsInQueue[]? | select(.address? | ascii_downcase == \"${VALIDATOR_ADDRESS,,}\")")

        if [[ -n "$validator_info" ]]; then
            validator_found=true
            current_position=$(echo "$validator_info" | jq -r '.position')
            local queued_at=$(format_date "$(echo "$validator_info" | jq -r '.queuedAt')")

            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Validator found on page $page at position $current_position" >> "$LOG_FILE"
            break
        fi
    done

    if [[ "$validator_found" == true ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Validator at position $current_position" >> "$LOG_FILE"

        if [[ "$last_position" != "$current_position" ]]; then
            local message
            if [[ -n "$last_position" ]]; then
                message="📊 *Validator Position Update* 📊

🔹 *Address:* \`$VALIDATOR_ADDRESS\`
🔄 *Change:* $last_position → $current_position
📅 *Queued since:* $queued_at
⏳ *Checked at:* $(date '+%d.%m.%Y %H:%M UTC')"
            else
                message="🎉 *New Validator in Queue* 🎉

🔹 *Address:* \`$VALIDATOR_ADDRESS\`
📌 *Initial Position:* $current_position
📅 *Queued since:* $queued_at
⏳ *Checked at:* $(date '+%d.%m.%Y %H:%M UTC')"
            fi

            if send_telegram "$message"; then
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] Notification sent" >> "$LOG_FILE"
            fi

            echo "$current_position" > "$LAST_POSITION_FILE"
        fi
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Validator not in queue" >> "$LOG_FILE"

        if [[ -n "$last_position" ]]; then
            local message="❌ *Validator Removed from Queue* ❌

🔹 *Address:* \`$VALIDATOR_ADDRESS\`
⌛ *Last Position:* $last_position
⏳ *Checked at:* $(date '+%d.%m.%Y %H:%M UTC')"

            if send_telegram "$message"; then
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] Removal notification sent" >> "$LOG_FILE"
            fi

            # Удаляем файл последней позиции
            rm -f "$LAST_POSITION_FILE"

            # Удаляем сам скрипт мониторинга
            rm -f "$0"

            # Удаляем задание из cron
            crontab -l | grep -v "$0" | crontab -

            # Удаляем лог-файл
            rm -f "$LOG_FILE"
        fi
    fi
}

{
    monitor_position
} >> "$LOG_FILE" 2>&1
EOF

        # Заменяем плейсхолдеры
        sed -i "s|VALIDATOR_ADDRESS_PLACEHOLDER|$validator_address|g" "$MONITOR_DIR/$script_name"
        sed -i "s|QUEUE_URL_PLACEHOLDER|$QUEUE_URL|g" "$MONITOR_DIR/$script_name"
        sed -i "s|MONITOR_DIR_PLACEHOLDER|$MONITOR_DIR|g" "$MONITOR_DIR/$script_name"
        sed -i "s|LAST_POSITION_FILE_PLACEHOLDER|$position_file|g" "$MONITOR_DIR/$script_name"
        sed -i "s|LOG_FILE_PLACEHOLDER|$log_file|g" "$MONITOR_DIR/$script_name"
        sed -i "s|TELEGRAM_BOT_TOKEN_PLACEHOLDER|$TELEGRAM_BOT_TOKEN|g" "$MONITOR_DIR/$script_name"
        sed -i "s|TELEGRAM_CHAT_ID_PLACEHOLDER|$TELEGRAM_CHAT_ID|g" "$MONITOR_DIR/$script_name"

        chmod +x "$MONITOR_DIR/$script_name"

        if ! crontab -l | grep -q "$MONITOR_DIR/$script_name"; then
            (crontab -l 2>/dev/null; echo "0 * * * * $MONITOR_DIR/$script_name") | crontab -
        fi

        echo -e "${GREEN}$(t "notification_script_created" "$validator_address")${RESET}"
    done
}

# Функция для отображения списка активных мониторингов
list_monitor_scripts() {
    local scripts=($(ls "$MONITOR_DIR"/monitor_*.sh 2>/dev/null))

    if [ ${#scripts[@]} -eq 0 ]; then
        echo -e "${YELLOW}$(t "no_notifications")${RESET}"
        return
    fi

    echo -e "${BOLD}$(t "active_monitors")${RESET}"
    for script in "${scripts[@]}"; do
        local address=$(grep -oP 'VALIDATOR_ADDRESS="\K[^"]+' "$script")
        echo -e "  ${CYAN}$address${RESET}"
    done
}

# Функция для загрузки валидаторов (асинхронная)
fast_load_validators() {
    local TMP_RESULTS=$(mktemp)
    trap 'rm -f "$TMP_RESULTS"' EXIT

    # Оптимизированные настройки для большого количества валидаторов
    local MAX_CONCURRENT=10  # Увеличиваем количество одновременных запросов
    local BATCH_SIZE=100     # Размер батча для обработки
    local current_batch=0
    local total_processed=0

    echo -e "${YELLOW}Starting fast processing of $VALIDATOR_COUNT validators...${RESET}"
    echo -e "${YELLOW}Using $MAX_CONCURRENT concurrent requests${RESET}"

    # Функция для обработки одного валидатора
    process_validator() {
        local validator=$1
        (
            # Получаем данные через getAttesterView()
            response=$(cast call $ROLLUP_ADDRESS "getAttesterView(address)" $validator --rpc-url $RPC_URL 2>/dev/null)
            if [[ $? -ne 0 || -z "$response" ]]; then
                echo "$validator|ERROR" >> "$TMP_RESULTS"
                exit 0
            fi

            # Получаем отдельно withdrawer адрес через getConfig()
            config_response=$(cast call $ROLLUP_ADDRESS "getConfig(address)" $validator --rpc-url $RPC_URL 2>/dev/null)
            withdrawer="0x${config_response:26:40}"

            # Парсим данные из getAttesterView()
            data=${response:2}
            status_hex=${data:0:64}
            stake_hex=${data:64:64}

            status=$(hex_to_dec "$status_hex")
            stake=$(wei_to_token $(hex_to_dec "$stake_hex"))

            echo "$validator|$stake|$withdrawer|$status" >> "$TMP_RESULTS"
        ) &
    }

    # Обрабатываем валидаторов батчами для лучшего контроля памяти
    for ((i=0; i<VALIDATOR_COUNT; i+=BATCH_SIZE)); do
        local batch_end=$((i + BATCH_SIZE))
        if [[ $batch_end -gt $VALIDATOR_COUNT ]]; then
            batch_end=$VALIDATOR_COUNT
        fi

        echo -e "${CYAN}Processing batch $((i/BATCH_SIZE + 1))/$((VALIDATOR_COUNT/BATCH_SIZE + 1)) (validators $((i+1))-$batch_end)${RESET}"

        # Запускаем процессы для текущего батча
        for ((j=i; j<batch_end; j++)); do
            process_validator "${VALIDATOR_ADDRESSES[j]}"
            current_batch=$((current_batch + 1))

            # Если достигли лимита одновременных запросов, ждем завершения
            if [[ $current_batch -ge $MAX_CONCURRENT ]]; then
                wait
                current_batch=0
                # Небольшая пауза между группами для снижения нагрузки
                sleep 0.1
            fi
        done

        # Ждем завершения всех процессов в текущем батче
        wait
        current_batch=0

        # Обновляем прогресс
        total_processed=$batch_end
        progress_bar $total_processed $VALIDATOR_COUNT
        echo ""  # Новая строка после прогресс-бара

        # Пауза между батчами для снижения нагрузки на RPC
        sleep 0.5
    done

    echo -e "${GREEN}All validators processed. Loading results...${RESET}"

    # Загружаем результаты в память более эффективно
    local processed_count=0
    while IFS='|' read -r validator stake withdrawer status; do
        if [[ "$stake" == "ERROR" ]]; then
            echo -e "${RED}Error fetching info for $validator${RESET}"
            continue
        fi

        status_text=${STATUS_MAP[$status]:-UNKNOWN}
        status_color=${STATUS_COLOR[$status]:-$RESET}

        RESULTS+=("$validator|$stake|$withdrawer|$status|$status_text|$status_color")
        processed_count=$((processed_count + 1))

        # Показываем прогресс загрузки каждые 1000 записей
        if [[ $((processed_count % 1000)) -eq 0 ]]; then
            echo -e "${YELLOW}Loaded $processed_count results...${RESET}"
        fi
    done < "$TMP_RESULTS"

    echo -e "${GREEN}Successfully loaded $processed_count validator results${RESET}"
}





# Основной код
echo -e "${BOLD}$(t "fetching_validators") ${CYAN}$ROLLUP_ADDRESS${RESET}..."
VALIDATORS_RESPONSE=$(cast call $ROLLUP_ADDRESS "getAttesters()(address[])" --rpc-url $RPC_URL)

# Проверяем на ошибку VM execution error
if echo "$VALIDATORS_RESPONSE" | grep -q "error code -32015: VM execution error"; then
    echo -e "${RED}Error: VM execution error - insufficient data available${RESET}"
    echo -e "${YELLOW}Please check your RPC URL or try a different one${RESET}"
    exit 1
fi

# Проверяем на другие ошибки
if echo "$VALIDATORS_RESPONSE" | grep -q "Error:"; then
    echo -e "${RED}Error fetching validators: $VALIDATORS_RESPONSE${RESET}"
    exit 1
fi

# Оптимизированный парсинг массива адресов из ответа
# Ответ будет в формате: [0xaddr1, 0xaddr2, 0xaddr3, ...]
echo -e "${YELLOW}Parsing validator addresses...${RESET}"

# Убираем квадратные скобки и используем sed для быстрой обработки
VALIDATORS_RESPONSE=${VALIDATORS_RESPONSE:1:-1}  # Убираем квадратные скобки

# Используем sed для быстрого удаления пробелов и создания массива
VALIDATOR_ADDRESSES=($(echo "$VALIDATORS_RESPONSE" | sed 's/,/\n/g' | sed 's/ //g'))

VALIDATOR_COUNT=${#VALIDATOR_ADDRESSES[@]}
echo -e "${GREEN}Successfully parsed $VALIDATOR_COUNT addresses${RESET}"

echo -e "${GREEN}$(t "found_validators")${RESET} ${BOLD}${#VALIDATOR_ADDRESSES[@]}${RESET}"
echo "----------------------------------------"

# Запрашиваем адреса валидаторов для проверки
echo ""
echo -e "${BOLD}Enter validator addresses to check (comma separated):${RESET}"
echo -e "${YELLOW}Example: 0xdEc08eb67aEa96cd8C2F576aEFD5b9F6bA4bc973, 0x2Feec28A408724665Ea13325CC26054Fd40C9CA1${RESET}"
read -p "> " input_addresses

# Парсим введенные адреса
IFS=',' read -ra INPUT_ADDRESSES <<< "$input_addresses"

# Очищаем адреса от пробелов и проверяем их наличие в общем списке
declare -a VALIDATOR_ADDRESSES_TO_CHECK=()
local found_count=0
local not_found_count=0

echo -e "${YELLOW}Validating addresses...${RESET}"

for address in "${INPUT_ADDRESSES[@]}"; do
    # Очищаем адрес от пробелов
    clean_address=$(echo "$address" | tr -d ' ')

    # Проверяем, есть ли адрес в общем списке
    found=false
    for validator in "${VALIDATOR_ADDRESSES[@]}"; do
        if [[ "${validator,,}" == "${clean_address,,}" ]]; then
            VALIDATOR_ADDRESSES_TO_CHECK+=("$validator")
            found=true
            found_count=$((found_count + 1))
            echo -e "${GREEN}✓ Found: $validator${RESET}"
            break
        fi
    done

    if ! $found; then
        echo -e "${RED}✗ Not found: $clean_address${RESET}"
        not_found_count=$((not_found_count + 1))
    fi
done

echo ""
echo -e "${GREEN}Found $found_count validators to check${RESET}"
if [[ $not_found_count -gt 0 ]]; then
    echo -e "${RED}$not_found_count addresses not found in validator list${RESET}"
fi

if [[ ${#VALIDATOR_ADDRESSES_TO_CHECK[@]} -eq 0 ]]; then
    echo -e "${RED}No valid addresses to check. Exiting.${RESET}"
    exit 1
fi

# Запускаем быструю загрузку сразу
declare -a RESULTS
echo -e "${BOLD}Checking ${#VALIDATOR_ADDRESSES_TO_CHECK[@]} validators...${RESET}"

# Временно заменяем массив для обработки только выбранных валидаторов
ORIGINAL_VALIDATOR_ADDRESSES=("${VALIDATOR_ADDRESSES[@]}")
ORIGINAL_VALIDATOR_COUNT=$VALIDATOR_COUNT
VALIDATOR_ADDRESSES=("${VALIDATOR_ADDRESSES_TO_CHECK[@]}")
VALIDATOR_COUNT=${#VALIDATOR_ADDRESSES_TO_CHECK[@]}

# Запускаем быструю загрузку
fast_load_validators

# Восстанавливаем оригинальный массив
VALIDATOR_ADDRESSES=("${ORIGINAL_VALIDATOR_ADDRESSES[@]}")
VALIDATOR_COUNT=$ORIGINAL_VALIDATOR_COUNT

echo -e "\n${GREEN}${BOLD}$(t "check_completed")${RESET}"
echo "----------------------------------------"

while true; do
    echo ""
    echo -e "${BOLD}Select an action:${RESET}"
    echo -e "${CYAN}1. Search and display data for a specific validator${RESET}"
    echo -e "${CYAN}2. Display the checked validators list${RESET}"
    echo -e "${CYAN}3. Set up queue position notification for validator${RESET}"
    echo -e "${CYAN}4. Check another set of validators${RESET}"
    echo -e "${RED}0. Exit${RESET}"
    read -p "$(t "enter_option") " choice

    case $choice in
        1)
            read -p "$(t "enter_address") " search_address
            found=false
            for line in "${RESULTS[@]}"; do
                IFS='|' read -r validator stake withdrawer status status_text status_color <<< "$line"
                if [[ "${validator,,}" == "${search_address,,}" ]]; then
                    echo -e "\n${BOLD}$(t "validator_info")${RESET}\n"
                    echo -e "  ${BOLD}$(t "address"):${RESET} $validator"
                    echo -e "  ${BOLD}$(t "stake"):${RESET} $stake STK"
                    echo -e "  ${BOLD}$(t "withdrawer"):${RESET} $withdrawer"
                    echo -e "  ${BOLD}$(t "status"):${RESET} ${status_color}$status ($status_text)${RESET}\n"
                    found=true
                    break
                fi
            done
            if ! $found; then
                echo -e "\n${YELLOW}$(t "validator_not_found" "$search_address")${RESET}"
                echo -e "${YELLOW}$(t "checking_queue")${RESET}"
                check_validator_queue "$search_address"
            fi
            ;;
        2)
            echo ""
            echo -e "${BOLD}Checked validators (${#RESULTS[@]} total):${RESET}"
            echo "----------------------------------------"
            for line in "${RESULTS[@]}"; do
                IFS='|' read -r validator stake withdrawer status status_text status_color <<< "$line"
                echo -e "${BOLD}$(t "address"):${RESET} $validator"
                echo -e "  ${BOLD}$(t "stake"):${RESET} $stake STK"
                echo -e "  ${BOLD}$(t "withdrawer"):${RESET} $withdrawer"
                echo -e "  ${BOLD}$(t "status"):${RESET} ${status_color}$status ($status_text)${RESET}"
                echo -e ""
                echo "----------------------------------------"
            done
            ;;
        3)
            echo -e "\n${BOLD}$(t "queue_notification_title")${RESET}"
            list_monitor_scripts
            echo ""
            read -p "$(t "enter_multiple_addresses") " validator_addresses

            # Создаем скрипты для всех указанных адресов
            IFS=',' read -ra ADDRESSES_TO_MONITOR <<< "$validator_addresses"
            for address in "${ADDRESSES_TO_MONITOR[@]}"; do
                clean_address=$(echo "$address" | tr -d ' ')
                echo -e "${YELLOW}$(t "processing_address" "$clean_address")${RESET}"
                create_monitor_script "$clean_address"
            done
            ;;
        4)
            echo -e "\n${CYAN}Starting new validator check...${RESET}"
            echo "----------------------------------------"

            # Запрашиваем новые адреса валидаторов для проверки
            echo ""
            echo -e "${BOLD}Enter validator addresses to check (comma separated):${RESET}"
            echo -e "${YELLOW}Example: 0xdEc08eb67aEa96cd8C2F576aEFD5b9F6bA4bc973, 0x2Feec28A408724665Ea13325CC26054Fd40C9CA1${RESET}"
            read -p "> " input_addresses

            # Парсим введенные адреса
            IFS=',' read -ra INPUT_ADDRESSES <<< "$input_addresses"

            # Очищаем адреса от пробелов и проверяем их наличие в общем списке
            declare -a VALIDATOR_ADDRESSES_TO_CHECK=()
            local found_count=0
            local not_found_count=0

            echo -e "${YELLOW}Validating addresses...${RESET}"

            for address in "${INPUT_ADDRESSES[@]}"; do
                # Очищаем адрес от пробелов
                clean_address=$(echo "$address" | tr -d ' ')

                # Проверяем, есть ли адрес в общем списке
                found=false
                for validator in "${VALIDATOR_ADDRESSES[@]}"; do
                    if [[ "${validator,,}" == "${clean_address,,}" ]]; then
                        VALIDATOR_ADDRESSES_TO_CHECK+=("$validator")
                        found=true
                        found_count=$((found_count + 1))
                        echo -e "${GREEN}✓ Found: $validator${RESET}"
                        break
                    fi
                done

                if ! $found; then
                    echo -e "${RED}✗ Not found: $clean_address${RESET}"
                    not_found_count=$((not_found_count + 1))
                fi
            done

            echo ""
            echo -e "${GREEN}Found $found_count validators to check${RESET}"
            if [[ $not_found_count -gt 0 ]]; then
                echo -e "${RED}$not_found_count addresses not found in validator list${RESET}"
            fi

            if [[ ${#VALIDATOR_ADDRESSES_TO_CHECK[@]} -eq 0 ]]; then
                echo -e "${RED}No valid addresses to check.${RESET}"
                continue
            fi

            # Очищаем предыдущие результаты и запускаем быструю загрузку
            RESULTS=()
            echo -e "${BOLD}Checking ${#VALIDATOR_ADDRESSES_TO_CHECK[@]} validators...${RESET}"

            # Временно заменяем массив для обработки только выбранных валидаторов
            ORIGINAL_VALIDATOR_ADDRESSES=("${VALIDATOR_ADDRESSES[@]}")
            ORIGINAL_VALIDATOR_COUNT=$VALIDATOR_COUNT
            VALIDATOR_ADDRESSES=("${VALIDATOR_ADDRESSES_TO_CHECK[@]}")
            VALIDATOR_COUNT=${#VALIDATOR_ADDRESSES_TO_CHECK[@]}

            # Запускаем быструю загрузку
            fast_load_validators

            # Восстанавливаем оригинальный массив
            VALIDATOR_ADDRESSES=("${ORIGINAL_VALIDATOR_ADDRESSES[@]}")
            VALIDATOR_COUNT=$ORIGINAL_VALIDATOR_COUNT

            echo -e "\n${GREEN}${BOLD}Check completed.${RESET}"
            echo "----------------------------------------"
            ;;
        0)
            echo -e "\n${CYAN}$(t "exiting")${RESET}"
            break
            ;;
        *)
            echo -e "\n${RED}$(t "invalid_input")${RESET}"
            ;;
    esac
done
