#!/bin/bash

# Цвета
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
GRAY="\e[90m"
CYAN="\e[36m"
BLUE="\e[34m"
BOLD="\e[1m"
RESET="\e[0m"

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
    TRANSLATIONS["en,status_0"]="NONE - The validator is not in the validator set"
    TRANSLATIONS["en,status_1"]="VALIDATING - The validator is currently in the validator set"
    TRANSLATIONS["en,status_2"]="ZOMBIE - Not participating as validator, but have funds in setup, hit if slashes and going below the minimum"
    TRANSLATIONS["en,status_3"]="EXITING - In the process of exiting the system"
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
    TRANSLATIONS["en,loading_validators"]="Loading validator data..."
    TRANSLATIONS["en,validators_loaded"]="Validator data loaded successfully"
    TRANSLATIONS["en,rpc_error"]="RPC error occurred, trying alternative RPC"
    TRANSLATIONS["en,getting_new_rpc"]="Getting new RPC URL..."
    TRANSLATIONS["en,rate_limit_notice"]="Using backup RPC - rate limiting to 1 request per second"
    TRANSLATIONS["en,getting_validator_count"]="Getting validator count..."
    TRANSLATIONS["en,getting_current_slot"]="Getting current slot..."
    TRANSLATIONS["en,deriving_timestamp"]="Deriving timestamp for slot..."
    TRANSLATIONS["en,querying_attesters"]="Querying attesters from GSE contract..."

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
    TRANSLATIONS["ru,status_0"]="NONE - Валидатор не в наборе валидаторов"
    TRANSLATIONS["ru,status_1"]="VALIDATING - Валидатор в настоящее время в наборе валидаторов"
    TRANSLATIONS["ru,status_2"]="ZOMBIE - Не участвует в качестве валидатора, но есть средства в стейкинге, получает штраф за слэшинг, баланс снижается до минимума"
    TRANSLATIONS["ru,status_3"]="EXITING - В процессе выхода из системы"
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
    TRANSLATIONS["ru,loading_validators"]="Загрузка данных валидаторов..."
    TRANSLATIONS["ru,validators_loaded"]="Данные валидаторов успешно загружены"
    TRANSLATIONS["ru,rpc_error"]="Произошла ошибка RPC, пробуем альтернативный RPC"
    TRANSLATIONS["ru,getting_new_rpc"]="Получение нового RPC URL..."
    TRANSLATIONS["ru,rate_limit_notice"]="Используется резервный RPC - ограничение скорости: 1 запрос в секунду"
    TRANSLATIONS["ru,getting_validator_count"]="Получение количества валидаторов..."
    TRANSLATIONS["ru,getting_current_slot"]="Получение текущего слота..."
    TRANSLATIONS["ru,deriving_timestamp"]="Получение временной метки для слота..."
    TRANSLATIONS["ru,querying_attesters"]="Запрос аттестующих из GSE контракта..."

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
    TRANSLATIONS["tr,status_0"]="NONE - Doğrulayıcı, doğrulayıcı setinde değil"
    TRANSLATIONS["tr,status_1"]="VALIDATING - Doğrulayıcı şu anda doğrulayıcı setinde"
    TRANSLATIONS["tr,status_2"]="ZOMBIE - Doğrulayıcı (validator) olarak katılmıyor, ancak staking'te fonları bulunuyor. Slashing (kesinti) cezası alıyor и bakiyesi minimum seviyeye düşüyor."
    TRANSLATIONS["tr,status_3"]="EXITING - Sistemden çıkış sürecinde"
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
    TRANSLATIONS["tr,notification_script_created"]="Bildirim betiği oluşturuldu и zamanlandı. İzlenen doğrulayıcı: %s"
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
    TRANSLATIONS["tr,loading_validators"]="Doğrulayıcı verileri yükleniyor..."
    TRANSLATIONS["tr,validators_loaded"]="Doğrulayıcı verileri başarıyla yüklendi"
    TRANSLATIONS["tr,rpc_error"]="RPC hatası oluştu, alternatif RPC deneniyor"
    TRANSLATIONS["tr,getting_new_rpc"]="Yeni RPC URL alınıyor..."
    TRANSLATIONS["tr,rate_limit_notice"]="Yedek RPC kullanılıyor - hız sınırlaması: saniyede 1 istek"
    TRANSLATIONS["tr,getting_validator_count"]="Doğrulayıcı sayısı alınıyor..."
    TRANSLATIONS["tr,getting_current_slot"]="Mevcut slot alınıyor..."
    TRANSLATIONS["tr,deriving_timestamp"]="Slot için zaman damgası türetiliyor..."
    TRANSLATIONS["tr,querying_attesters"]="GSE kontratından onaylayıcılar sorgulanıyor..."
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

#ROLLUP_ADDRESS="0x1bb7836854ce5dc7d84a32cb75c7480c72767132"
ROLLUP_ADDRESS="0x29fa27e173f058d0f5f618f5abad2757747f673f"
GSE_ADDRESS="0x67788e5083646ccedeeb07e7bc35ab0d511fc8b9"
QUEUE_URL="https://dev.dashtec.xyz/api/validators/queue"
MONITOR_DIR="/root/aztec-monitor-agent"

# ========= HTTP via curl_cffi =========
# cffi_http_get <url>
cffi_http_get() {
  local url="$1"
  python3 - "$url" <<'PY'
import sys, json
from curl_cffi import requests
u = sys.argv[1]
headers = {
  "accept": "application/json, text/plain, */*",
  "origin": "https://dev.dashtec.xyz",
  "referer": "https://dev.dashtec.xyz/",
}
try:
    r = requests.get(u, headers=headers, impersonate="chrome131", timeout=30)
    ct = (r.headers.get("content-type") or "").lower()
    txt = r.text
    if "application/json" in ct:
        sys.stdout.write(txt)
    else:
        i, j = txt.find("{"), txt.rfind("}")
        if i != -1 and j != -1 and j > i:
            sys.stdout.write(txt[i:j+1])
        else:
            sys.stdout.write(txt)
except Exception as e:
    sys.stdout.write("")
    sys.stderr.write(f"{e}")
PY
}

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

        # Если есть резервный RPC, используем его
        if [ -n "$RPC_URL_VCHECK" ]; then
            echo -e "${YELLOW}Using backup RPC to load the list of validators: $RPC_URL_VCHECK${RESET}"
            USING_BACKUP_RPC=true
        else
            USING_BACKUP_RPC=false
        fi
    else
        echo -e "${RED}$(t "error_file_missing")${RESET}"
        exit 1
    fi
}

# Функция для получения нового RPC URL
get_new_rpc_url() {
    echo -e "${YELLOW}$(t "getting_new_rpc")${RESET}"

    # Список возможных RPC провайдеров (можно расширить)
    local rpc_providers=(
        "https://ethereum-sepolia-rpc.publicnode.com"
        "https://1rpc.io/sepolia"
        "https://sepolia.drpc.org"
    )

    # Пробуем каждый RPC пока не найдем рабочий
    for rpc_url in "${rpc_providers[@]}"; do
        echo -e "${YELLOW}Trying RPC: $rpc_url${RESET}"

        # Проверяем доступность RPC
        if curl -s --head --connect-timeout 5 "$rpc_url" >/dev/null; then
            echo -e "${GREEN}RPC is available: $rpc_url${RESET}"

            # Проверяем, что RPC может отвечать на запросы
            if cast block latest --rpc-url "$rpc_url" >/dev/null 2>&1; then
                echo -e "${GREEN}RPC is working properly: $rpc_url${RESET}"

                # Добавляем новый RPC в файл конфигурации
                if grep -q "RPC_URL_VCHECK=" "/root/.env-aztec-agent"; then
                    sed -i "s|RPC_URL_VCHECK=.*|RPC_URL_VCHECK=$rpc_url|" "/root/.env-aztec-agent"
                else
                    echo "RPC_URL_VCHECK=$rpc_url" >> "/root/.env-aztec-agent"
                fi

                # Обновляем текущую переменную
                RPC_URL_VCHECK="$rpc_url"
                USING_BACKUP_RPC=true

                # Перезагружаем конфигурацию, чтобы обновить переменные
                source "/root/.env-aztec-agent"

                return 0
            else
                echo -e "${RED}RPC is not responding properly: $rpc_url${RESET}"
            fi
        else
            echo -e "${RED}RPC is not available: $rpc_url${RESET}"
        fi
    done

    echo -e "${RED}Failed to find a working RPC URL${RESET}"
    return 1
}

## Функция для выполнения cast call с обработкой ошибок RPC
cast_call_with_fallback() {
    local contract_address=$1
    local function_signature=$2
    local max_retries=3
    local retry_count=0
    local use_validator_rpc=${3:-false}  # По умолчанию используем основной RPC

    while [ $retry_count -lt $max_retries ]; do
        # Определяем какой RPC использовать
        local current_rpc
        if [ "$use_validator_rpc" = true ] && [ -n "$RPC_URL_VCHECK" ]; then
            current_rpc="$RPC_URL_VCHECK"
            echo -e "${YELLOW}Using validator RPC: $current_rpc (attempt $((retry_count + 1))/$max_retries)${RESET}"
        else
            current_rpc="$RPC_URL"
            echo -e "${YELLOW}Using main RPC: $current_rpc (attempt $((retry_count + 1))/$max_retries)${RESET}"
        fi

        local response=$(cast call "$contract_address" "$function_signature" --rpc-url "$current_rpc" 2>&1)

        # Проверяем на ошибки RPC (но игнорируем успешные ответы, которые могут содержать текст)
        if echo "$response" | grep -q -E "^(Error|error|timed out|connection refused|connection reset)"; then
            echo -e "${RED}RPC error: $response${RESET}"

            # Если это запрос валидаторов, получаем новый RPC URL
            if [ "$use_validator_rpc" = true ]; then
                if get_new_rpc_url; then
                    retry_count=$((retry_count + 1))
                    sleep 2
                    continue
                else
                    echo -e "${RED}All RPC attempts failed${RESET}"
                    return 1
                fi
            else
                # Для других запросов просто увеличиваем счетчик попыток
                retry_count=$((retry_count + 1))
                sleep 2
                continue
            fi
        fi

        # Если нет ошибки, возвращаем ответ
        echo "$response"
        return 0
    done

    echo -e "${RED}Maximum retries exceeded${RESET}"
    return 1
}

# Глобальная переменная для отслеживания использования резервного RPC
USING_BACKUP_RPC=false

# Глобальная переменная для хранения количества найденных в очереди валидаторов
QUEUE_FOUND_COUNT=0

# Глобальный массив для хранения адресов валидаторов, найденных в очереди
declare -a QUEUE_FOUND_ADDRESSES=()

load_rpc_config

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

# Функция для проверки очереди валидаторов (пакетная обработка)
# ========= Queue check via curl_cffi (batch) =========
check_validator_queue(){
    local validator_addresses=("$@")
    local results=(); local found_count=0; local not_found_count=0
    echo -e "${YELLOW}$(t "fetching_queue")${RESET}"
    echo -e "${GRAY}Checking ${#validator_addresses[@]} validators in queue...${RESET}"
    local temp_file; temp_file=$(mktemp)

    check_single_validator(){
        local validator_address=$1; local temp_file=$2
        local search_address_lower=${validator_address,,}
        local search_url="${QUEUE_URL}?page=1&limit=10&search=${search_address_lower}"
        local response_data; response_data="$(cffi_http_get "$search_url")"
        if [ -z "$response_data" ]; then
            echo "$validator_address|ERROR|Error fetching data" >> "$temp_file"; return 1
        fi
        if ! jq -e . >/dev/null 2>&1 <<<"$response_data"; then
            echo "$validator_address|ERROR|Invalid JSON response" >> "$temp_file"; return 1
        fi
        local validator_info; validator_info=$(echo "$response_data" | jq -r ".validatorsInQueue[] | select(.address? | ascii_downcase == \"$search_address_lower\")")
        local filtered_count; filtered_count=$(echo "$response_data" | jq -r '.filteredCount // 0')
        if [ -n "$validator_info" ] && [ "$filtered_count" -gt 0 ]; then
            local position withdrawer queued_at tx_hash
            position=$(echo "$validator_info" | jq -r '.position')
            withdrawer=$(echo "$validator_info" | jq -r '.withdrawerAddress')
            queued_at=$(echo "$validator_info" | jq -r '.queuedAt')
            tx_hash=$(echo "$validator_info" | jq -r '.transactionHash')
            echo "$validator_address|FOUND|$position|$withdrawer|$queued_at|$tx_hash" >> "$temp_file"
        else
            echo "$validator_address|NOT_FOUND||" >> "$temp_file"
        fi
    }

    local pids=()
    for validator_address in "${validator_addresses[@]}"; do
        check_single_validator "$validator_address" "$temp_file" &
        pids+=($!)
    done
    for pid in "${pids[@]}"; do wait "$pid" 2>/dev/null || true; done

    while IFS='|' read -r address status position withdrawer queued_at tx_hash; do
        case "$status" in
            FOUND) results+=("FOUND|$address|$position|$withdrawer|$queued_at|$tx_hash"); found_count=$((found_count+1));;
            NOT_FOUND) results+=("NOT_FOUND|$address"); not_found_count=$((not_found_count+1));;
            ERROR) results+=("ERROR|$address|$position"); not_found_count=$((not_found_count+1));;
        esac
    done < "$temp_file"
    rm -f "$temp_file"

    echo -e "\n${CYAN}=== Queue Check Results ===${RESET}"
    echo -e "Found in queue: ${GREEN}$found_count${RESET}"
    echo -e "Not found: ${RED}$not_found_count${RESET}"
    echo -e "Total checked: ${BOLD}${#validator_addresses[@]}${RESET}"

    if [ $found_count -gt 0 ]; then
        echo -e "\n${GREEN}Validators found in queue:${RESET}"
        for result in "${results[@]}"; do
            IFS='|' read -r status address position withdrawer queued_at tx_hash <<<"$result"
            if [ "$status" == "FOUND" ]; then
                local formatted_date; formatted_date=$(date -d "$queued_at" '+%d.%m.%Y %H:%M UTC' 2>/dev/null || echo "$queued_at")
                echo -e "  ${CYAN}• ${address}${RESET}"
                echo -e "    ${BOLD}Position:${RESET} $position"
                echo -e "    ${BOLD}Withdrawer:${RESET} $withdrawer"
                echo -e "    ${BOLD}Queued at:${RESET} $formatted_date"
                echo -e "    ${BOLD}Tx Hash:${RESET} $tx_hash"
            fi
        done
    fi

    if [ $not_found_count -gt 0 ]; then
        echo -e "\n${RED}Validators not found in queue:${RESET}"
        for result in "${results[@]}"; do
            IFS='|' read -r status address error_msg <<<"$result"
            if [ "$status" == "NOT_FOUND" ]; then
                echo -e "  ${RED}• ${address}${RESET}"
            elif [ "$status" == "ERROR" ]; then
                echo -e "  ${RED}• ${address} (Error: ${error_msg})${RESET}"
            fi
        done
    fi

    # Устанавливаем глобальные переменные с результатами поиска
    QUEUE_FOUND_COUNT=$found_count
    QUEUE_FOUND_ADDRESSES=()

    # Заполняем массив найденными адресами
    for result in "${results[@]}"; do
        IFS='|' read -r status address position withdrawer queued_at tx_hash <<<"$result"
        if [ "$status" == "FOUND" ]; then
            QUEUE_FOUND_ADDRESSES+=("$address")
        fi
    done

    if [ $found_count -gt 0 ]; then return 0; else return 1; fi
}

# Вспомогательная функция для проверки одного валидатора (для обратной совместимости)
check_single_validator_queue() {
    local validator_address=$1
    check_validator_queue "$validator_address"
}

create_monitor_script(){
    local validator_addresses=$1; local addresses=()
    IFS=',' read -ra addresses <<<"$validator_addresses"
    for validator_address in "${addresses[@]}"; do
        validator_address=$(echo "$validator_address" | xargs)
        local normalized_address=${validator_address,,}
        local script_name="monitor_${normalized_address:2}.sh"
        local log_file="$MONITOR_DIR/monitor_${normalized_address:2}.log"
        local position_file="$MONITOR_DIR/last_position_${normalized_address:2}.txt"
        if [ -f "$MONITOR_DIR/$script_name" ]; then
            echo -e "${YELLOW}$(t "notification_exists")${RESET}"; continue
        fi
        mkdir -p "$MONITOR_DIR"

        local start_message="🎯 *Queue Monitoring Started*

🔹 *Address:* \`$validator_address\`
⏰ *Monitoring started at:* $(date '+%d.%m.%Y %H:%M UTC')
📋 *Check frequency:* Hourly
🔔 *Notifications:* Position changes"

        if [ -n "${TELEGRAM_BOT_TOKEN-}" ] && [ -n "${TELEGRAM_CHAT_ID-}" ]; then
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d chat_id="$TELEGRAM_CHAT_ID" -d text="$start_message" -d parse_mode="Markdown" >/dev/null 2>&1
        fi

        cat > "$MONITOR_DIR/$script_name" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

VALIDATOR_ADDRESS="__ADDR__"
QUEUE_URL="__QURL__"
MONITOR_DIR="__MDIR__"
LAST_POSITION_FILE="__POSFILE__"
LOG_FILE="__LOGFILE__"
TELEGRAM_BOT_TOKEN="__TBOT__"
TELEGRAM_CHAT_ID="__TCHAT__"

CURL_CONNECT_TIMEOUT=15
CURL_MAX_TIME=45
API_RETRY_DELAY=30
MAX_RETRIES=2

mkdir -p "$MONITOR_DIR"
log_message(){ echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

# Ensure curl_cffi
python3 - <<'PY' >/dev/null 2>&1 || exit 1
try:
    import pkgutil
    assert pkgutil.find_loader("curl_cffi")
except Exception:
    raise SystemExit(1)
print("OK")
PY

send_telegram(){
    local message="$1"
    if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
        log_message "No Telegram tokens"
        return 1
    fi
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d chat_id="$TELEGRAM_CHAT_ID" -d text="$message" -d parse_mode="Markdown" >/dev/null
}

format_date(){
    local iso_date="$1"
    if [[ "$iso_date" =~ ^([0-9]{4})-([0-9]{2})-([0-9]{2})T([0-9]{2}):([0-9]{2}):([0-9]{2}) ]]; then
        echo "${BASH_REMATCH[3]}.${BASH_REMATCH[2]}.${BASH_REMATCH[1]} ${BASH_REMATCH[4]}:${BASH_REMATCH[5]} UTC"
    else
        echo "$iso_date"
    fi
}

cffi_http_get(){
  local url="$1"
  python3 - "$url" <<'PY'
import sys
from curl_cffi import requests
u = sys.argv[1]
headers = {"accept":"application/json, text/plain, */*","origin":"https://dev.dashtec.xyz","referer":"https://dev.dashtec.xyz/"}
r = requests.get(u, headers=headers, impersonate="chrome131", timeout=30)
ct = (r.headers.get("content-type") or "").lower()
txt = r.text
if "application/json" in ct:
    print(txt)
else:
    i, j = txt.find("{"), txt.rfind("}")
    print(txt[i:j+1] if i!=-1 and j!=-1 and j>i else txt)
PY
}

monitor_position(){
    log_message "Start monitor_position for $VALIDATOR_ADDRESS"
    local last_position=""
    [[ -f "$LAST_POSITION_FILE" ]] && last_position=$(cat "$LAST_POSITION_FILE")

    local search_url="${QUEUE_URL}?page=1&limit=10&search=${VALIDATOR_ADDRESS,,}"
    log_message "GET $search_url"
    local response_data; response_data="$(cffi_http_get "$search_url")"
    if [ -z "$response_data" ]; then log_message "Empty response"; return 1; fi
    if ! echo "$response_data" | jq -e . >/dev/null 2>&1; then log_message "Invalid JSON"; return 1; fi

    local validator_info; validator_info=$(echo "$response_data" | jq -r ".validatorsInQueue[] | select(.address? | ascii_downcase == \"${VALIDATOR_ADDRESS,,}\")")
    local filtered_count; filtered_count=$(echo "$response_data" | jq -r '.filteredCount // 0')

    if [[ -n "$validator_info" && "$filtered_count" -gt 0 ]]; then
        local current_position queued_at withdrawer_address transaction_hash
        current_position=$(echo "$validator_info" | jq -r '.position')
        queued_at=$(format_date "$(echo "$validator_info" | jq -r '.queuedAt')")
        withdrawer_address=$(echo "$validator_info" | jq -r '.withdrawerAddress')
        transaction_hash=$(echo "$validator_info" | jq -r '.transactionHash')

        if [[ "$last_position" != "$current_position" ]]; then
            local message
            if [[ -n "$last_position" ]]; then
                message="📊 *Validator Position Update*

🔹 *Address:* $VALIDATOR_ADDRESS
🔄 *Change:* $last_position → $current_position
📅 *Queued since:* $queued_at
🏦 *Withdrawer:* $withdrawer_address
🔗 *Transaction:* $transaction_hash
⏳ *Checked at:* $(date '+%d.%m.%Y %H:%M UTC')"
            else
                message="🎉 *New Validator in Queue*

🔹 *Address:* $VALIDATOR_ADDRESS
📌 *Initial Position:* $current_position
📅 *Queued since:* $queued_at
🏦 *Withdrawer:* $withdrawer_address
🔗 *Transaction:* $transaction_hash
⏳ *Checked at:* $(date '+%d.%m.%Y %H:%M UTC')"
            fi
            send_telegram "$message" && log_message "Notification sent"
            echo "$current_position" > "$LAST_POSITION_FILE"
            log_message "Saved new position: $current_position"
        else
            log_message "Position unchanged: $current_position"
        fi
    else
        log_message "Validator not found in queue"
        if [[ -n "$last_position" ]]; then
            local message="❌ *Validator Removed from Queue*

🔹 *Address:* $VALIDATOR_ADDRESS
⌛ *Last Position:* $last_position
⏳ *Checked at:* $(date '+%d.%m.%Y %H:%M UTC')"
send_telegram "$message" && log_message "Removal notification sent"
rm -f "$LAST_POSITION_FILE"; log_message "Removed position file"
rm -f "$0"; log_message "Removed monitor script"
            (crontab -l | grep -v "$0" | crontab - 2>/dev/null) || true
            rm -f "$LOG_FILE"
        fi
    fi
    return 0
}

main(){
    log_message "===== Starting monitor cycle ====="
    ( sleep 300; log_message "ERROR: Script timed out after 5 minutes"; kill -TERM $$ 2>/dev/null ) & TO_PID=$!
    monitor_position; local ec=$?
    kill "$TO_PID" 2>/dev/null || true
    [[ $ec -ne 0 ]] && log_message "ERROR: exit $ec"
    log_message "===== Monitor cycle completed ====="
    return $ec
}
main >> "$LOG_FILE" 2>&1
EOF
        # substitute placeholders
        sed -i "s|__ADDR__|$validator_address|g" "$MONITOR_DIR/$script_name"
        sed -i "s|__QURL__|$QUEUE_URL|g" "$MONITOR_DIR/$script_name"
        sed -i "s|__MDIR__|$MONITOR_DIR|g" "$MONITOR_DIR/$script_name"
        sed -i "s|__POSFILE__|$position_file|g" "$MONITOR_DIR/$script_name"
        sed -i "s|__LOGFILE__|$log_file|g" "$MONITOR_DIR/$script_name"
        sed -i "s|__TBOT__|${TELEGRAM_BOT_TOKEN-}|g" "$MONITOR_DIR/$script_name"
        sed -i "s|__TCHAT__|${TELEGRAM_CHAT_ID-}|g" "$MONITOR_DIR/$script_name"

        chmod +x "$MONITOR_DIR/$script_name"
        if ! crontab -l 2>/dev/null | grep -q "$MONITOR_DIR/$script_name"; then
            (crontab -l 2>/dev/null; echo "0 * * * * timeout 600 $MONITOR_DIR/$script_name") | crontab -
        fi
        echo -e "\n${GREEN}$(t "notification_script_created" "$validator_address")${RESET}"
        echo -e "${YELLOW}Note: Initial notification sent. Script includes safety timeouts.${RESET}"
        echo -e "${CYAN}Running initial test...${RESET}"
        timeout 60 "$MONITOR_DIR/$script_name" >/dev/null 2>&1 || true
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

# Функция для получения списка валидаторов через GSE контракт
get_validators_via_gse() {
    echo -e "${YELLOW}$(t "getting_validator_count")${RESET}"

    # Отладочный вывод команды
    # echo -e "${GRAY}Command: cast call \"$ROLLUP_ADDRESS\" \"getActiveAttesterCount()\" --rpc-url \"$RPC_URL\" | cast to-dec${RESET}"

    VALIDATOR_COUNT=$(cast call "$ROLLUP_ADDRESS" "getActiveAttesterCount()" --rpc-url "$RPC_URL" | cast to-dec)

    # Проверяем успешность выполнения и валидность результата
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to get validator count${RESET}"
        return 1
    fi

    if ! [[ "$VALIDATOR_COUNT" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Error: Invalid validator count format: '$VALIDATOR_COUNT'${RESET}"
        return 1
    fi

    echo -e "${GREEN}Validator count: $VALIDATOR_COUNT${RESET}"

    echo -e "${YELLOW}$(t "getting_current_slot")${RESET}"
    # Отладочный вывод
    # echo -e "${GRAY}Command: cast call \"$ROLLUP_ADDRESS\" \"getCurrentSlot()\" --rpc-url \"$RPC_URL\" | cast to-dec${RESET}"

    SLOT=$(cast call "$ROLLUP_ADDRESS" "getCurrentSlot()" --rpc-url "$RPC_URL" | cast to-dec)

    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to get current slot${RESET}"
        return 1
    fi

    if ! [[ "$SLOT" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Error: Invalid slot format: '$SLOT'${RESET}"
        return 1
    fi

    echo -e "${GREEN}Current slot: $SLOT${RESET}"

    echo -e "${YELLOW}$(t "deriving_timestamp")${RESET}"
    # Отладочный вывод
    # echo -e "${GRAY}Command: cast call \"$ROLLUP_ADDRESS\" \"getTimestampForSlot(uint256)\" $SLOT --rpc-url \"$RPC_URL\" | cast to-dec${RESET}"

    TIMESTAMP=$(cast call "$ROLLUP_ADDRESS" "getTimestampForSlot(uint256)" $SLOT --rpc-url "$RPC_URL" | cast to-dec)

    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to get timestamp for slot${RESET}"
        return 1
    fi

    if ! [[ "$TIMESTAMP" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Error: Invalid timestamp format: '$TIMESTAMP'${RESET}"
        return 1
    fi

    echo -e "${GREEN}Timestamp for slot $SLOT: $TIMESTAMP${RESET}"

    # Создаем массив индексов от 0 до VALIDATOR_COUNT-1
    INDICES=()
    for ((i=0; i<VALIDATOR_COUNT; i++)); do
        INDICES+=("$i")
    done

    echo -e "${YELLOW}$(t "querying_attesters")${RESET}"
    # echo -e "${GRAY}Total indices: ${#INDICES[@]}, batch size: 5000${RESET}"

    # Инициализируем массив для всех адресов
    local ALL_VALIDATOR_ADDRESSES=()
    local BATCH_SIZE=3000
    local TOTAL_BATCHES=$(( (VALIDATOR_COUNT + BATCH_SIZE - 1) / BATCH_SIZE ))

    # Обрабатываем индексы партиями
    for ((BATCH_START=0; BATCH_START<VALIDATOR_COUNT; BATCH_START+=BATCH_SIZE)); do
        BATCH_END=$((BATCH_START + BATCH_SIZE - 1))
        if [ $BATCH_END -ge $VALIDATOR_COUNT ]; then
            BATCH_END=$((VALIDATOR_COUNT - 1))
        fi

        CURRENT_BATCH=$((BATCH_START / BATCH_SIZE + 1))
        BATCH_INDICES=("${INDICES[@]:$BATCH_START:$BATCH_SIZE}")
        BATCH_COUNT=${#BATCH_INDICES[@]}

        echo -e "${GRAY}Processing batch $CURRENT_BATCH/$TOTAL_BATCHES (indices $BATCH_START-$BATCH_END, $BATCH_COUNT addresses)${RESET}"

        # Преобразуем массив в строку для передачи в cast call
        INDICES_STR=$(printf "%s," "${BATCH_INDICES[@]}")
        INDICES_STR="${INDICES_STR%,}"  # Убираем последнюю запятую

        # Вызываем GSE контракт для получения списка валидаторов
        VALIDATORS_RESPONSE=$(cast call "$GSE_ADDRESS" \
            "getAttestersFromIndicesAtTime(address,uint256,uint256[])" \
            "$ROLLUP_ADDRESS" "$TIMESTAMP" "[$INDICES_STR]" \
            --rpc-url "$RPC_URL")
        local exit_code=$?

        if [ $exit_code -ne 0 ]; then
            echo -e "${RED}Error: GSE contract call failed for batch $CURRENT_BATCH with exit code $exit_code${RESET}"
            return 1
        fi

        if [ -z "$VALIDATORS_RESPONSE" ]; then
            echo -e "${RED}Error: Empty response from GSE contract for batch $CURRENT_BATCH${RESET}"
            return 1
        fi

        # Парсим ABI-encoded динамический массив
        # Убираем префикс 0x
        RESPONSE_WITHOUT_PREFIX=${VALIDATORS_RESPONSE#0x}

        # Извлекаем длину массива (первые 64 символа после смещения)
        OFFSET_HEX=${RESPONSE_WITHOUT_PREFIX:0:64}
        ARRAY_LENGTH_HEX=${RESPONSE_WITHOUT_PREFIX:64:64}

        # Конвертируем hex в decimal
        local ARRAY_LENGTH=$(printf "%d" "0x$ARRAY_LENGTH_HEX")

        if [ $ARRAY_LENGTH -eq 0 ]; then
            echo -e "${YELLOW}Warning: Empty validator array in batch $CURRENT_BATCH${RESET}"
            continue
        fi

        if [ $ARRAY_LENGTH -ne $BATCH_COUNT ]; then
            echo -e "${YELLOW}Warning: Batch array length ($ARRAY_LENGTH) doesn't match batch count ($BATCH_COUNT)${RESET}"
        fi

        # Извлекаем адреса из массива
        local START_POS=$((64 + 64))  # Пропускаем offset и length (по 64 символа каждый)

        for ((i=0; i<ARRAY_LENGTH; i++)); do
            # Каждый адрес занимает 64 символа (32 bytes), но нам нужны только последние 40 символов (20 bytes)
            ADDR_HEX=${RESPONSE_WITHOUT_PREFIX:$START_POS:64}
            ADDR="0x${ADDR_HEX:24:40}"  # Берем последние 20 bytes (40 символов)

            # Проверяем валидность адреса
            if [[ "$ADDR" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
                ALL_VALIDATOR_ADDRESSES+=("$ADDR")
            else
                echo -e "${YELLOW}Warning: Invalid address format at batch position $i: '$ADDR'${RESET}"
            fi

            START_POS=$((START_POS + 64))
        done

        echo -e "${GREEN}Batch $CURRENT_BATCH processed: ${#ALL_VALIDATOR_ADDRESSES[@]} total addresses so far${RESET}"

        # Небольшая задержка между батчами чтобы не перегружать RPC
        if [ $CURRENT_BATCH -lt $TOTAL_BATCHES ]; then
            sleep 1
        fi
    done

    # Сохраняем результаты в глобальный массив (перезаписываем его)
    VALIDATOR_ADDRESSES=("${ALL_VALIDATOR_ADDRESSES[@]}")

    echo -e "${GREEN}$(t "found_validators") ${#VALIDATOR_ADDRESSES[@]}${RESET}"

    if [ ${#VALIDATOR_ADDRESSES[@]} -eq 0 ]; then
        echo -e "${RED}Error: No valid validator addresses found${RESET}"
        return 1
    fi

    return 0
}

fast_load_validators() {
    echo -e "\n${YELLOW}$(t "loading_validators")${RESET}"
    echo -e "${YELLOW}Using RPC: $RPC_URL${RESET}"

    # Обрабатываем валидаторов последовательно
    for ((i=0; i<VALIDATOR_COUNT; i++)); do
        local validator="${VALIDATOR_ADDRESSES[i]}"
        echo -e "${GRAY}Processing: $validator${RESET}"

        # Получаем данные getAttesterView
        response=$(cast call "$ROLLUP_ADDRESS" "getAttesterView(address)" "$validator" --rpc-url "$RPC_URL" 2>/dev/null)

        if [[ $? -ne 0 || -z "$response" || ${#response} -lt 130 ]]; then
            echo -e "${RED}Error getting data for: $validator${RESET}"
            continue
        fi

        # Парсим данные из getAttesterView
        # Формат ответа:
        # - status (uint8, 32 bytes)
        # - stake (uint256, 32 bytes)
        # - ... другие поля ...
        # - withdrawer (address, 32 bytes) в конце

        data=${response:2}  # Убираем префикс 0x

        # Извлекаем статус (первые 64 символа)
        status_hex=${data:0:64}

        # Извлекаем стейк (следующие 64 символа)
        stake_hex=${data:64:64}

        # Извлекаем withdrawer из конца ответа (последние 64 символа)
        # withdrawer находится в последних 64 символах, но нам нужны только последние 40 символов
        withdrawer_hex=${data: -64}  # Последние 64 символа
        withdrawer="0x${withdrawer_hex:24:40}"  # Берем последние 20 bytes (40 символов)

        # Проверяем валидность адреса withdrawer
        if [[ ! "$withdrawer" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
            echo -e "${YELLOW}Warning: Invalid withdrawer format for $validator, using zero address${RESET}"
            withdrawer="0x0000000000000000000000000000000000000000"
        fi

        # Преобразуем hex в decimal с использованием вспомогательных функций
        status=$(hex_to_dec "$status_hex")
        stake_decimal=$(hex_to_dec "$stake_hex")
        stake=$(wei_to_token "$stake_decimal")

        # Безопасное получение статуса и цвета
        local status_text="${STATUS_MAP[$status]:-UNKNOWN}"
        local status_color="${STATUS_COLOR[$status]:-$RESET}"

        # Добавляем в результаты
        RESULTS+=("$validator|$stake|$withdrawer|$status|$status_text|$status_color")
        #echo -e "${GREEN}✓ Loaded: $validator - $stake STK - $status_text${RESET}"
    done

    echo -e "${GREEN}Successfully loaded: ${#RESULTS[@]}/$VALIDATOR_COUNT validators${RESET}"
}

# Основной код
echo -e "${BOLD}$(t "fetching_validators") ${CYAN}$ROLLUP_ADDRESS${RESET}..."

# Используем новую функцию для получения списка валидаторов через GSE контракт
if ! get_validators_via_gse; then
    echo -e "${RED}Error: Failed to fetch validators using GSE contract method${RESET}"
    exit 1
fi

echo "----------------------------------------"

# Запрашиваем адреса валидаторов для проверки
echo ""
echo -e "${BOLD}Enter validator addresses to check (comma separated):${RESET}"
read -p "> " input_addresses

# Парсим введенные адреса
IFS=',' read -ra INPUT_ADDRESSES <<< "$input_addresses"

# Очищаем адреса от пробелов и проверяем их наличие в общем списке
declare -a VALIDATOR_ADDRESSES_TO_CHECK=()
declare -a QUEUE_VALIDATORS=()
declare -a NOT_FOUND_ADDRESSES=()
found_count=0
not_found_count=0

# Сначала проверяем все адреса в активных валидаторах
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
            echo -e "${GREEN}✓ Found in active validators: $validator${RESET}"
            break
        fi
    done

    if ! $found; then
        NOT_FOUND_ADDRESSES+=("$clean_address")
    fi
done

# Теперь проверяем не найденные адреса в очереди (пакетно)
found_in_queue_count=0
if [ ${#NOT_FOUND_ADDRESSES[@]} -gt 0 ]; then
    echo -e "\n${YELLOW}$(t "validator_not_in_set")${RESET}"

    # Используем новую функцию для пакетной проверки в очереди
    check_validator_queue "${NOT_FOUND_ADDRESSES[@]}"
    # Функция устанавливает глобальную переменную QUEUE_FOUND_COUNT
    found_in_queue_count=$QUEUE_FOUND_COUNT

    not_found_count=$((${#NOT_FOUND_ADDRESSES[@]} - found_in_queue_count))
fi

# Показываем общую сводку
echo -e "\n${CYAN}=== Search Summary ===${RESET}"
echo -e "Found in active validators: ${GREEN}$found_count${RESET}"
echo -e "Found in queue: ${YELLOW}$found_in_queue_count${RESET}"
echo -e "Not found anywhere: ${RED}$not_found_count${RESET}"

# Обрабатываем активных валидаторов
if [[ ${#VALIDATOR_ADDRESSES_TO_CHECK[@]} -gt 0 ]]; then
    echo -e "\n${GREEN}=== Active Validators Details ===${RESET}"

    # Запускаем быструю загрузку для активных валидаторов
    declare -a RESULTS

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

    # Показываем результат
    echo ""
    echo -e "${BOLD}Validator results (${#RESULTS[@]} total):${RESET}"
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
fi

# Обрабатываем валидаторов из очереди (только если они не были уже показаны)
if [[ ${#QUEUE_FOUND_ADDRESSES[@]} -gt 0 ]]; then
    echo -e "\n${YELLOW}=== Queue Validators Available for Monitoring ===${RESET}"

    # Предлагаем добавить в мониторинг
    echo -e "${BOLD}Would you like to add these validators to queue monitoring?${RESET}"
    read -p "Enter 'yes' to add all, or 'no' to skip: " add_to_monitor

    if [[ "$add_to_monitor" == "yes" || "$add_to_monitor" == "y" ]]; then
        # Создаем мониторы для всех валидаторов из очереди
        for validator in "${QUEUE_FOUND_ADDRESSES[@]}"; do
            echo -e "\n${YELLOW}$(t "processing_address" "$validator")${RESET}"
            create_monitor_script "$validator"
        done
        echo -e "${GREEN}All queue validators added to monitoring.${RESET}"
    else
        echo -e "${YELLOW}Skipping queue monitoring setup.${RESET}"
    fi
fi

if [[ ${#VALIDATOR_ADDRESSES_TO_CHECK[@]} -eq 0 && ${#QUEUE_FOUND_ADDRESSES[@]} -eq 0 ]]; then
    echo -e "${RED}No valid addresses to check.${RESET}"
fi

# Главное меню
while true; do
    echo ""
    echo -e "${BOLD}Select an action:${RESET}"
    echo -e "${CYAN}1. Check another set of validators${RESET}"
    echo -e "${CYAN}2. Set up queue position notification for validator${RESET}"
    echo -e "${CYAN}3. Check validator in queue${RESET}"
    echo -e "${CYAN}4. List active monitors${RESET}"
    echo -e "${RED}0. Exit${RESET}"
    read -p "$(t "enter_option") " choice

    case $choice in
        1)
            echo -e "\n${CYAN}Starting new validator check...${RESET}"
            echo "----------------------------------------"

            # Запрашиваем новые адреса валидаторов для проверки
            echo ""
            echo -e "${BOLD}Enter validator addresses to check (comma separated):${RESET}"
            read -p "> " input_addresses

            # Парсим введенные адреса
            IFS=',' read -ra INPUT_ADDRESSES <<< "$input_addresses"

            # Очищаем адреса от пробелов и проверяем их наличие в общем списке
            declare -a VALIDATOR_ADDRESSES_TO_CHECK=()
            declare -a NOT_FOUND_ADDRESSES=()
            found_count=0
            not_found_count=0

            # Сначала проверяем все адреса в активных валидаторах
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
                        echo -e "${GREEN}✓ Found in active validators: $validator${RESET}"
                        break
                    fi
                done

                if ! $found; then
                    NOT_FOUND_ADDRESSES+=("$clean_address")
                fi
            done

            # Теперь проверяем не найденные адреса в очереди (пакетно)
            found_in_queue_count=0
            if [ ${#NOT_FOUND_ADDRESSES[@]} -gt 0 ]; then
                echo -e "\n${YELLOW}$(t "validator_not_in_set")${RESET}"

                # Используем новую функцию для пакетной проверки в очереди
                check_validator_queue "${NOT_FOUND_ADDRESSES[@]}"
                # Функция устанавливает глобальную переменную QUEUE_FOUND_COUNT
                found_in_queue_count=$QUEUE_FOUND_COUNT

                not_found_count=$((${#NOT_FOUND_ADDRESSES[@]} - found_in_queue_count))
            fi

            # Показываем общую сводку
            echo -e "\n${CYAN}=== Search Summary ===${RESET}"
            echo -e "Found in active validators: ${GREEN}$found_count${RESET}"
            echo -e "Found in queue: ${YELLOW}$found_in_queue_count${RESET}"
            echo -e "Not found anywhere: ${RED}$not_found_count${RESET}"

            # Обрабатываем активных валидаторов
            if [[ ${#VALIDATOR_ADDRESSES_TO_CHECK[@]} -gt 0 ]]; then
                echo -e "\n${GREEN}=== Active Validators Details ===${RESET}"

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

                echo "----------------------------------------"

                # Показываем результат
                echo ""
                echo -e "${BOLD}Validator results (${#RESULTS[@]} total):${RESET}"
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
                echo -e "\n${GREEN}${BOLD}Check completed.${RESET}"
            fi

            # Обрабатываем валидаторов из очереди (только предложение мониторинга)
            if [[ ${#QUEUE_FOUND_ADDRESSES[@]} -gt 0 ]]; then
                echo -e "\n${YELLOW}=== Queue Validators Available for Monitoring ===${RESET}"

                # Предлагаем добавить в мониторинг
                echo -e "${BOLD}Would you like to add these validators to queue monitoring?${RESET}"
                read -p "Enter 'yes' to add all, or 'no' to skip: " add_to_monitor

                if [[ "$add_to_monitor" == "yes" || "$add_to_monitor" == "y" ]]; then
                    # Создаем мониторы для всех валидаторов из очереди
                    for validator in "${QUEUE_FOUND_ADDRESSES[@]}"; do
                        echo -e "${YELLOW}$(t "processing_address" "$validator")${RESET}"
                        create_monitor_script "$validator"
                    done
                    echo -e "${GREEN}All queue validators added to monitoring.${RESET}"
                else
                    echo -e "${YELLOW}Skipping queue monitoring setup.${RESET}"
                fi
            fi

            if [[ ${#VALIDATOR_ADDRESSES_TO_CHECK[@]} -eq 0 && ${#QUEUE_FOUND_ADDRESSES[@]} -eq 0 ]]; then
                echo -e "${RED}No valid addresses to check.${RESET}"
            fi
            ;;
        2)
            echo -e "\n${BOLD}$(t "queue_notification_title")${RESET}"
            list_monitor_scripts
            echo ""
            read -p "$(t "enter_multiple_addresses") " validator_addresses

            # Создаем скрипты для всех указанных адреса
            IFS=',' read -ra ADDRESSES_TO_MONITOR <<< "$validator_addresses"
            for address in "${ADDRESSES_TO_MONITOR[@]}"; do
                clean_address=$(echo "$address" | tr -d ' ')
                echo -e "${YELLOW}$(t "processing_address" "$clean_address")${RESET}"

                # Проверяем, есть ли валидатор хотя бы в очереди
                if check_validator_queue "$clean_address"; then
                    create_monitor_script "$clean_address"
                else
                    echo -e "${RED}Validator $clean_address not found in queue. Cannot create monitor.${RESET}"
                fi
            done
            ;;
        3)
            # Новая опция: проверить валидатора в очереди
            read -p "$(t "enter_address") " validator_address
            check_validator_queue "$validator_address"
            ;;
        4)
            # Новая опция: показать активные мониторы
            list_monitor_scripts
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
