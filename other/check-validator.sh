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

# Функция для быстрой загрузки (оптимизированная асинхронная)
fast_load_validators() {
    local TMP_RESULTS=$(mktemp)
    trap 'rm -f "$TMP_RESULTS"' EXIT

    # Ограничиваем количество одновременных запросов
    local MAX_CONCURRENT=5
    local current_batch=0
    local total_validators=${#VALIDATOR_ADDRESSES[@]}
    local processed=0

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

    # Обрабатываем валидаторов батчами
    for validator in "${VALIDATOR_ADDRESSES[@]}"; do
        process_validator "$validator"
        current_batch=$((current_batch + 1))

        # Если достигли лимита одновременных запросов, ждем завершения
        if [[ $current_batch -ge $MAX_CONCURRENT ]]; then
            wait
            current_batch=0
            # Небольшая пауза между батчами для снижения нагрузки
            sleep 0.2
        fi
    done

    # Ждем завершения оставшихся процессов
    wait

    # Обновляем прогресс-бар
    while true; do
        CURRENT=$(wc -l < "$TMP_RESULTS" 2>/dev/null || echo 0)
        progress_bar $CURRENT $VALIDATOR_COUNT
        if [[ $CURRENT -ge $VALIDATOR_COUNT ]]; then
            break
        fi
        sleep 0.1
    done

    while IFS='|' read -r validator stake withdrawer status; do
        if [[ "$stake" == "ERROR" ]]; then
            echo -e "${RED}Error fetching info for $validator${RESET}"
            continue
        fi

        status_text=${STATUS_MAP[$status]:-UNKNOWN}
        status_color=${STATUS_COLOR[$status]:-$RESET}

        RESULTS+=("$validator|$stake|$withdrawer|$status|$status_text|$status_color")
    done < "$TMP_RESULTS"
}

# Функция для медленной загрузки (синхронной)
slow_load_validators() {
    CURRENT=0
    for validator in "${VALIDATOR_ADDRESSES[@]}"; do
        # Получаем данные через getAttesterView()
        response=$(cast call $ROLLUP_ADDRESS "getAttesterView(address)" $validator --rpc-url $RPC_URL 2>/dev/null)
        if [[ $? -ne 0 || -z "$response" ]]; then
            echo -e "${RED}Error fetching info for $validator${RESET}"
            continue
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

        status_text=${STATUS_MAP[$status]:-UNKNOWN}
        status_color=${STATUS_COLOR[$status]:-$RESET}

        RESULTS+=("$validator|$stake|$withdrawer|$status|$status_text|$status_color")

        CURRENT=$((CURRENT + 1))
        progress_bar $CURRENT $VALIDATOR_COUNT
    done
}

# Основной код
echo -e "${BOLD}$(t "fetching_validators") ${CYAN}$ROLLUP_ADDRESS${RESET}..."
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

# Выбор режима загрузки
echo ""
echo -e "${BOLD}$(t "select_mode")${RESET}"
echo -e "${CYAN}$(t "mode_fast")${RESET}"
echo -e "${CYAN}$(t "mode_slow")${RESET}"
read -p "$(t "enter_option") " mode

declare -a RESULTS
echo -e "${BOLD}$(t "checking_validators")${RESET}"

case $mode in
    1)
        fast_load_validators
        ;;
    2)
        slow_load_validators
        ;;
    *)
        echo -e "\n${RED}$(t "mode_invalid")${RESET}"
        exit 1
        ;;
esac

echo -e "\n${GREEN}${BOLD}$(t "check_completed")${RESET}"
echo "----------------------------------------"

while true; do
    echo ""
    echo -e "${BOLD}$(t "select_action")${RESET}"
    echo -e "${CYAN}$(t "option1")${RESET}"
    echo -e "${CYAN}$(t "option2")${RESET}"
    echo -e "${CYAN}$(t "option3")${RESET}"
    echo -e "${RED}$(t "option0")${RESET}"
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
            create_monitor_script "$validator_addresses"
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

##!/bin/bash
#
## Функция загрузки RPC URL с обработкой ошибок
#load_rpc_config() {
#    if [ -f "/root/.env-aztec-agent" ]; then
#        source "/root/.env-aztec-agent"
#        if [ -z "$RPC_URL" ]; then
#            echo -e "${RED}$(t "error_rpc_missing")${RESET}"
#            exit 1
#        fi
#    else
#        echo -e "${RED}$(t "error_file_missing")${RESET}"
#        exit 1
#    fi
#}
#
## === Language settings ===
#LANG="en"
#declare -A TRANSLATIONS
#
#init_languages() {
#    if [ -n "$1" ]; then
#        case $1 in
#            "en") LANG="en" ;;
#            "ru") LANG="ru" ;;
#            "tr") LANG="tr" ;;
#        esac
#    else
#        LANG="en"
#    fi
#
#    # English translations
#    TRANSLATIONS["en,fetching_validators"]="Fetching validator list from contract"
#    TRANSLATIONS["en,found_validators"]="Found validators:"
#    TRANSLATIONS["en,checking_validators"]="Checking validators..."
#    TRANSLATIONS["en,check_completed"]="Check completed."
#    TRANSLATIONS["en,select_action"]="Select an action:"
#    TRANSLATIONS["en,option1"]="1. Search and display data for a specific validator"
#    TRANSLATIONS["en,option2"]="2. Display the full validator list"
#    TRANSLATIONS["en,option3"]="3. Back"
#    TRANSLATIONS["en,enter_option"]="Select option:"
#    TRANSLATIONS["en,enter_address"]="Enter the validator address:"
#    TRANSLATIONS["en,validator_info"]="Validator information:"
#    TRANSLATIONS["en,address"]="Address"
#    TRANSLATIONS["en,stake"]="Stake"
#    TRANSLATIONS["en,withdrawer"]="Withdrawer"
#    TRANSLATIONS["en,status"]="Status"
#    TRANSLATIONS["en,validator_not_found"]="Validator with address %s not found."
#    TRANSLATIONS["en,exiting"]="Exiting."
#    TRANSLATIONS["en,invalid_input"]="Invalid input. Please choose 1, 2 or 3."
#    TRANSLATIONS["en,status_0"]="NOT_IN_SET - The validator is not in the validator set"
#    TRANSLATIONS["en,status_1"]="ACTIVE - The validator is currently in the validator set"
#    TRANSLATIONS["en,status_2"]="INACTIVE - The validator is not active; possibly in withdrawal delay"
#    TRANSLATIONS["en,status_3"]="READY_TO_EXIT - The validator has completed exit delay and can be exited"
#    TRANSLATIONS["en,error_rpc_missing"]="Error: RPC_URL not found in /root/.env-aztec-agent"
#    TRANSLATIONS["en,error_file_missing"]="Error: /root/.env-aztec-agent file not found"
#    TRANSLATIONS["en,select_mode"]="Select loading mode:"
#    TRANSLATIONS["en,mode_fast"]="1. Fast mode (high CPU load)"
#    TRANSLATIONS["en,mode_slow"]="2. Slow mode (low CPU load)"
#    TRANSLATIONS["en,mode_invalid"]="Invalid mode selected. Please choose 1 or 2."
#    TRANSLATIONS["en,checking_queue"]="Checking validator queue..."
#    TRANSLATIONS["en,validator_in_queue"]="Validator found in queue:"
#    TRANSLATIONS["en,position"]="Position"
#    TRANSLATIONS["en,queued_at"]="Queued at"
#    TRANSLATIONS["en,not_in_queue"]="Validator is not in the queue either."
#    TRANSLATIONS["en,fetching_queue"]="Fetching validator queue data..."
#
#    # Russian translations
#    TRANSLATIONS["ru,fetching_validators"]="Получение списка валидаторов из контракта"
#    TRANSLATIONS["ru,found_validators"]="Найдено валидаторов:"
#    TRANSLATIONS["ru,checking_validators"]="Проверка валидаторов..."
#    TRANSLATIONS["ru,check_completed"]="Проверка завершена."
#    TRANSLATIONS["ru,select_action"]="Выберите действие:"
#    TRANSLATIONS["ru,option1"]="1. Поиск и отображение данных конкретного валидатора"
#    TRANSLATIONS["ru,option2"]="2. Отобразить полный список валидаторов"
#    TRANSLATIONS["ru,option3"]="3. Назад"
#    TRANSLATIONS["ru,enter_option"]="Выберите опцию:"
#    TRANSLATIONS["ru,enter_address"]="Введите адрес валидатора:"
#    TRANSLATIONS["ru,validator_info"]="Информация о валидаторе:"
#    TRANSLATIONS["ru,address"]="Адрес"
#    TRANSLATIONS["ru,stake"]="Стейк"
#    TRANSLATIONS["ru,withdrawer"]="Withdrawer адрес"
#    TRANSLATIONS["ru,status"]="Статус"
#    TRANSLATIONS["ru,validator_not_found"]="Валидатор с адресом %s не найден."
#    TRANSLATIONS["ru,exiting"]="Выход."
#    TRANSLATIONS["ru,invalid_input"]="Неверный ввод. Пожалуйста, выберите 1, 2 или 3."
#    TRANSLATIONS["ru,status_0"]="NOT_IN_SET - Валидатор не в наборе валидаторов"
#    TRANSLATIONS["ru,status_1"]="ACTIVE - Валидатор в настоящее время в наборе валидаторов"
#    TRANSLATIONS["ru,status_2"]="INACTIVE - Валидатор не активен; возможно, в задержке вывода"
#    TRANSLATIONS["ru,status_3"]="READY_TO_EXIT - Валидатор завершил задержку выхода и может быть выведен"
#    TRANSLATIONS["ru,error_rpc_missing"]="Ошибка: RPC_URL не найден в /root/.env-aztec-agent"
#    TRANSLATIONS["ru,error_file_missing"]="Ошибка: файл /root/.env-aztec-agent не найден"
#    TRANSLATIONS["ru,select_mode"]="Выберите режим загрузки:"
#    TRANSLATIONS["ru,mode_fast"]="1. Быстрый режим (высокая нагрузка на CPU)"
#    TRANSLATIONS["ru,mode_slow"]="2. Медленный режим (низкая нагрузка на CPU)"
#    TRANSLATIONS["ru,mode_invalid"]="Неверный режим. Пожалуйста, выберите 1 или 2."
#    TRANSLATIONS["ru,checking_queue"]="Проверка очереди валидаторов..."
#    TRANSLATIONS["ru,validator_in_queue"]="Валидатор найден в очереди:"
#    TRANSLATIONS["ru,position"]="Позиция"
#    TRANSLATIONS["ru,queued_at"]="Добавлен в очередь"
#    TRANSLATIONS["ru,not_in_queue"]="Валидатора нет и в очереди."
#    TRANSLATIONS["ru,fetching_queue"]="Получение данных очереди валидаторов..."
#
#    # Turkish translations
#    TRANSLATIONS["tr,fetching_validators"]="Doğrulayıcı listesi kontrattan alınıyor"
#    TRANSLATIONS["tr,found_validators"]="Bulunan doğrulayıcılar:"
#    TRANSLATIONS["tr,checking_validators"]="Doğrulayıcılar kontrol ediliyor..."
#    TRANSLATIONS["tr,check_completed"]="Kontrol tamamlandı."
#    TRANSLATIONS["tr,select_action"]="Bir işlem seçin:"
#    TRANSLATIONS["tr,option1"]="1. Belirli bir doğrulayıcı için arama yap ve verileri göster"
#    TRANSLATIONS["tr,option2"]="2. Tam doğrulayıcı listesini göster"
#    TRANSLATIONS["tr,option3"]="3. Geri"
#    TRANSLATIONS["tr,enter_option"]="Seçenek seçin:"
#    TRANSLATIONS["tr,enter_address"]="Doğrulayıcı adresini girin:"
#    TRANSLATIONS["tr,validator_info"]="Doğrulayıcı bilgisi:"
#    TRANSLATIONS["tr,address"]="Adres"
#    TRANSLATIONS["tr,stake"]="Stake"
#    TRANSLATIONS["tr,withdrawer"]="Çekici"
#    TRANSLATIONS["tr,status"]="Durum"
#    TRANSLATIONS["tr,validator_not_found"]="%s adresli doğrulayıcı bulunamadı."
#    TRANSLATIONS["tr,exiting"]="Çıkılıyor."
#    TRANSLATIONS["tr,invalid_input"]="Geçersiz giriş. Lütfen 1, 2 veya 3 seçin."
#    TRANSLATIONS["tr,status_0"]="NOT_IN_SET - Doğrulayıcı, doğrulayıcı setinde değil"
#    TRANSLATIONS["tr,status_1"]="AKTİF - Doğrulayıcı şu anda doğrulayıcı setinde"
#    TRANSLATIONS["tr,status_2"]="PASİF - Doğrulayıcı aktif değil; muhtemelen çekme gecikmesinde"
#    TRANSLATIONS["tr,status_3"]="ÇIKIŞA_HAZIR - Doğrulayıcı çıkış gecikmesini tamamladı ve çıkış yapılabilir"
#    TRANSLATIONS["tr,error_rpc_missing"]="Hata: /root/.env-aztec-agent dosyasında RPC_URL bulunamadı"
#    TRANSLATIONS["tr,error_file_missing"]="Hata: /root/.env-aztec-agent dosyası bulunamadı"
#    TRANSLATIONS["tr,select_mode"]="Yükleme modunu seçin:"
#    TRANSLATIONS["tr,mode_fast"]="1. Hızlı mod (yüksek CPU yükü)"
#    TRANSLATIONS["tr,mode_slow"]="2. Yavaş mod (düşük CPU yükü)"
#    TRANSLATIONS["tr,mode_invalid"]="Geçersiz mod. Lütfen 1 или 2 seçin."
#    TRANSLATIONS["tr,checking_queue"]="Doğrulayıcı kuyruğu kontrol ediliyor..."
#    TRANSLATIONS["tr,validator_in_queue"]="Doğrulayıcı kuyrukta bulundu:"
#    TRANSLATIONS["tr,position"]="Pozisyon"
#    TRANSLATIONS["tr,queued_at"]="Kuyruğa eklendi"
#    TRANSLATIONS["tr,not_in_queue"]="Doğrulayıcı kuyrukta da yok."
#    TRANSLATIONS["tr,fetching_queue"]="Doğrulayıcı kuyruk verileri alınıyor..."
#}
#
#t() {
#    local key=$1
#    local value="${TRANSLATIONS[$LANG,$key]}"
#    if [[ $# -gt 1 ]]; then
#        printf -v value "${value}" "${@:2}"
#    fi
#    echo "${value}"
#}
#
#init_languages "$1"
#
#ROLLUP_ADDRESS="0x216f071653a82ced3ef9d29f3f0c0ed7829c8f81"
#QUEUE_URL="https://dashtec.xyz/api/validators/queue"
#
#load_rpc_config
#
## Цвета
#RED="\e[31m"
#GREEN="\e[32m"
#YELLOW="\e[33m"
#GRAY="\e[90m"
#CYAN="\e[36m"
#BOLD="\e[1m"
#RESET="\e[0m"
#
#declare -A STATUS_MAP=(
#    [0]=$(t "status_0")
#    [1]=$(t "status_1")
#    [2]=$(t "status_2")
#    [3]=$(t "status_3")
#)
#
#declare -A STATUS_COLOR=(
#    [0]="$GRAY"
#    [1]="$GREEN"
#    [2]="$YELLOW"
#    [3]="$RED"
#)
#
#hex_to_dec() {
#    local hex=${1^^}
#    echo "ibase=16; $hex" | bc
#}
#
#hex_to_address() {
#    local hex=$1
#    echo "0x${hex:24:40}"
#}
#
#wei_to_token() {
#    local wei_value=$1
#    local int_part=$(echo "$wei_value / 1000000000000000000" | bc)
#    local frac_part=$(echo "$wei_value % 1000000000000000000" | bc)
#    local frac_str=$(printf "%018d" $frac_part)
#    frac_str=$(echo "$frac_str" | sed 's/0*$//')
#    if [[ -z "$frac_str" ]]; then
#        echo "$int_part"
#    else
#        echo "$int_part.$frac_str"
#    fi
#}
#
#progress_bar() {
#    local current=$1
#    local total=$2
#    local width=40
#    local filled=$(( current * width / total ))
#    local empty=$(( width - filled ))
#
#    printf "\r["
#    for ((i=0; i<filled; i++)); do printf "="; done
#    for ((i=0; i<empty; i++)); do printf " "; done
#    printf "] %d/%d" "$current" "$total"
#}
#
## Функция для проверки очереди валидаторов
#check_validator_queue() {
#    local validator_address=$1
#    echo -e "${YELLOW}$(t "fetching_queue")${RESET}"
#
#    # Загружаем данные очереди
#    queue_data=$(curl -s "$QUEUE_URL")
#    if [ $? -ne 0 ] || [ -z "$queue_data" ]; then
#        echo -e "${RED}Error fetching validator queue data${RESET}"
#        return 1
#    fi
#
#    # Проверяем валидность JSON
#    if ! jq -e . >/dev/null 2>&1 <<<"$queue_data"; then
#        echo -e "${RED}Invalid JSON data received from queue API${RESET}"
#        return 1
#    fi
#
#    # Извлекаем список валидаторов в очереди
#    validators_in_queue=$(echo "$queue_data" | jq -r '.validatorsInQueue[]?.address // empty')
#    if [ -z "$validators_in_queue" ]; then
#        echo -e "${YELLOW}No validators found in queue${RESET}"
#        return 1
#    fi
#
#    # Нормализуем адрес для поиска (нижний регистр)
#    search_address_lower=${validator_address,,}
#
#    # Проверяем наличие валидатора в очереди
#    while IFS= read -r queue_address; do
#        if [ "${queue_address,,}" == "$search_address_lower" ]; then
#            # Получаем полную информацию о валидаторе из очереди
#            validator_info=$(echo "$queue_data" | jq -r ".validatorsInQueue[] | select(.address? | ascii_downcase == \"$search_address_lower\")")
#
#            if [ -n "$validator_info" ]; then
#                echo -e "\n${GREEN}$(t "validator_in_queue")${RESET}"
#                echo -e "  ${BOLD}$(t "address"):${RESET} $(echo "$validator_info" | jq -r '.address')"
#                echo -e "  ${BOLD}$(t "position"):${RESET} $(echo "$validator_info" | jq -r '.position')"
#                echo -e "  ${BOLD}$(t "withdrawer"):${RESET} $(echo "$validator_info" | jq -r '.withdrawerAddress')"
#                echo -e "  ${BOLD}$(t "queued_at"):${RESET} $(echo "$validator_info" | jq -r '.queuedAt')"
#                return 0
#            fi
#        fi
#    done <<< "$validators_in_queue"
#
#    echo -e "\n${RED}$(t "not_in_queue")${RESET}"
#    return 1
#}
#
## Функция для быстрой загрузки (асинхронной)
#fast_load_validators() {
#    local TMP_RESULTS=$(mktemp)
#    trap 'rm -f "$TMP_RESULTS"' EXIT
#
#    CURRENT=0
#    for validator in "${VALIDATOR_ADDRESSES[@]}"; do
#        (
#            # Получаем данные через getAttesterView()
#            response=$(cast call $ROLLUP_ADDRESS "getAttesterView(address)" $validator --rpc-url $RPC_URL 2>/dev/null)
#            if [[ $? -ne 0 || -z "$response" ]]; then
#                echo "$validator|ERROR" >> "$TMP_RESULTS"
#                exit 0
#            fi
#
#            # Получаем отдельно withdrawer адрес через getConfig()
#            config_response=$(cast call $ROLLUP_ADDRESS "getConfig(address)" $validator --rpc-url $RPC_URL 2>/dev/null)
#            withdrawer="0x${config_response:26:40}"
#
#            # Парсим данные из getAttesterView()
#            data=${response:2}
#            status_hex=${data:0:64}
#            stake_hex=${data:64:64}
#
#            status=$(hex_to_dec "$status_hex")
#            stake=$(wei_to_token $(hex_to_dec "$stake_hex"))
#
#            echo "$validator|$stake|$withdrawer|$status" >> "$TMP_RESULTS"
#        ) &
#    done
#
#    while true; do
#        CURRENT=$(wc -l < "$TMP_RESULTS" 2>/dev/null || echo 0)
#        progress_bar $CURRENT $VALIDATOR_COUNT
#        if [[ $CURRENT -ge $VALIDATOR_COUNT ]]; then
#            break
#        fi
#        sleep 0.1
#    done
#
#    while IFS='|' read -r validator stake withdrawer status; do
#        if [[ "$stake" == "ERROR" ]]; then
#            echo -e "${RED}Error fetching info for $validator${RESET}"
#            continue
#        fi
#
#        status_text=${STATUS_MAP[$status]:-UNKNOWN}
#        status_color=${STATUS_COLOR[$status]:-$RESET}
#
#        RESULTS+=("$validator|$stake|$withdrawer|$status|$status_text|$status_color")
#    done < "$TMP_RESULTS"
#}
#
## Функция для медленной загрузки (синхронной)
#slow_load_validators() {
#    CURRENT=0
#    for validator in "${VALIDATOR_ADDRESSES[@]}"; do
#        # Получаем данные через getAttesterView()
#        response=$(cast call $ROLLUP_ADDRESS "getAttesterView(address)" $validator --rpc-url $RPC_URL 2>/dev/null)
#        if [[ $? -ne 0 || -z "$response" ]]; then
#            echo -e "${RED}Error fetching info for $validator${RESET}"
#            continue
#        fi
#
#        # Получаем отдельно withdrawer адрес через getConfig()
#        config_response=$(cast call $ROLLUP_ADDRESS "getConfig(address)" $validator --rpc-url $RPC_URL 2>/dev/null)
#        withdrawer="0x${config_response:26:40}"
#
#        # Парсим данные из getAttesterView()
#        data=${response:2}
#        status_hex=${data:0:64}
#        stake_hex=${data:64:64}
#
#        status=$(hex_to_dec "$status_hex")
#        stake=$(wei_to_token $(hex_to_dec "$stake_hex"))
#
#        status_text=${STATUS_MAP[$status]:-UNKNOWN}
#        status_color=${STATUS_COLOR[$status]:-$RESET}
#
#        RESULTS+=("$validator|$stake|$withdrawer|$status|$status_text|$status_color")
#
#        CURRENT=$((CURRENT + 1))
#        progress_bar $CURRENT $VALIDATOR_COUNT
#    done
#}
#
## Основной код
#echo -e "${BOLD}$(t "fetching_validators") ${CYAN}$ROLLUP_ADDRESS${RESET}..."
#VALIDATORS_RESPONSE=$(cast call $ROLLUP_ADDRESS "getAttesters()" --rpc-url $RPC_URL)
#VALIDATORS_HEX=${VALIDATORS_RESPONSE:130}
#VALIDATOR_COUNT=$(( ${#VALIDATORS_HEX} / 64 ))
#VALIDATOR_ADDRESSES=()
#
#for (( i=0; i<$VALIDATOR_COUNT; i++ )); do
#    PART=${VALIDATORS_HEX:$((i*64)):64}
#    ADDRESS_HEX=${PART:24:40}
#    VALIDATOR_ADDRESSES+=("0x$ADDRESS_HEX")
#done
#
#echo -e "${GREEN}$(t "found_validators")${RESET} ${BOLD}${#VALIDATOR_ADDRESSES[@]}${RESET}"
#echo "----------------------------------------"
#
## Выбор режима загрузки
#echo ""
#echo -e "${BOLD}$(t "select_mode")${RESET}"
#echo -e "${CYAN}$(t "mode_fast")${RESET}"
#echo -e "${CYAN}$(t "mode_slow")${RESET}"
#read -p "$(t "enter_option") " mode
#
#declare -a RESULTS
#echo -e "${BOLD}$(t "checking_validators")${RESET}"
#
#case $mode in
#    1)
#        fast_load_validators
#        ;;
#    2)
#        slow_load_validators
#        ;;
#    *)
#        echo -e "\n${RED}$(t "mode_invalid")${RESET}"
#        exit 1
#        ;;
#esac
#
#echo -e "\n${GREEN}${BOLD}$(t "check_completed")${RESET}"
#echo "----------------------------------------"
#
#while true; do
#    echo ""
#    echo -e "${BOLD}$(t "select_action")${RESET}"
#    echo -e "${CYAN}$(t "option1")${RESET}"
#    echo -e "${CYAN}$(t "option2")${RESET}"
#    echo -e "${RED}$(t "option3")${RESET}"
#    read -p "$(t "enter_option") " choice
#
#    case $choice in
#        1)
#            read -p "$(t "enter_address") " search_address
#            found=false
#            for line in "${RESULTS[@]}"; do
#                IFS='|' read -r validator stake withdrawer status status_text status_color <<< "$line"
#                if [[ "${validator,,}" == "${search_address,,}" ]]; then
#                    echo -e "\n${BOLD}$(t "validator_info")${RESET}\n"
#                    echo -e "  ${BOLD}$(t "address"):${RESET} $validator"
#                    echo -e "  ${BOLD}$(t "stake"):${RESET} $stake STK"
#                    echo -e "  ${BOLD}$(t "withdrawer"):${RESET} $withdrawer"
#                    echo -e "  ${BOLD}$(t "status"):${RESET} ${status_color}$status ($status_text)${RESET}\n"
#                    found=true
#                    break
#                fi
#            done
#            if ! $found; then
#                echo -e "\n${YELLOW}$(t "validator_not_found" "$search_address")${RESET}"
#                echo -e "${YELLOW}$(t "checking_queue")${RESET}"
#                check_validator_queue "$search_address"
#            fi
#            ;;
#        2)
#            echo ""
#            for line in "${RESULTS[@]}"; do
#                IFS='|' read -r validator stake withdrawer status status_text status_color <<< "$line"
#                echo -e "${BOLD}$(t "address"):${RESET} $validator"
#                echo -e "  ${BOLD}$(t "stake"):${RESET} $stake STK"
#                echo -e "  ${BOLD}$(t "withdrawer"):${RESET} $withdrawer"
#                echo -e "  ${BOLD}$(t "status"):${RESET} ${status_color}$status ($status_text)${RESET}"
#                echo -e ""
#                echo "----------------------------------------"
#            done
#            ;;
#        3)
#            echo -e "\n${CYAN}$(t "exiting")${RESET}"
#            break
#            ;;
#        *)
#            echo -e "\n${RED}$(t "invalid_input")${RESET}"
#            ;;
#    esac
#done
