#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
VIOLET='\033[0;35m'
NC='\033[0m' # No Color

function show_logo() {
    echo -e " "
    echo -e " "
    echo -e "${NC}$(t "welcome")${NC}"
    curl -s https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/logo.sh | bash
}

# === Language settings ===
LANG=""
declare -A TRANSLATIONS

# Translation function
t() {
  local key=$1
  echo "${TRANSLATIONS[$LANG,$key]}"
}

# Initialize languages
init_languages() {
  echo -e "\n${BLUE}Select language / Выберите язык:${NC}"
  echo -e "1. English"
  echo -e "2. Русский"
  read -p "> " lang_choice

  case $lang_choice in
    1) LANG="en" ;;
    2) LANG="ru" ;;
    *) LANG="en" ;;
  esac

  # English translations
  TRANSLATIONS["en,welcome"]="Welcome to the Aztec node monitoring script"
  TRANSLATIONS["en,title"]="========= Main Menu ========="
  TRANSLATIONS["en,option1"]="1. Check container and current block"
  TRANSLATIONS["en,option2"]="2. Install cron monitoring agent"
  TRANSLATIONS["en,option3"]="3. Remove cron agent and files"
  TRANSLATIONS["en,option4"]="4. Find rollupAddress in logs"
  TRANSLATIONS["en,option5"]="5. Find PeerID in logs"
  TRANSLATIONS["en,option6"]="6. Find governanceProposerPayload in logs"
  TRANSLATIONS["en,option7"]="7. Check Proven L2 Block and Sync Proof"
  TRANSLATIONS["en,option8"]="8. Change RPC URL"
  TRANSLATIONS["en,option9"]="9. Search for validator and check status"
  TRANSLATIONS["en,option0"]="0. Exit"
  TRANSLATIONS["en,rpc_change_prompt"]="Enter new RPC URL:"
  TRANSLATIONS["en,rpc_change_success"]="✅ RPC URL successfully updated"
  TRANSLATIONS["en,choose_option"]="Select option:"
  TRANSLATIONS["en,checking_deps"]="🔍 Checking required components:"
  TRANSLATIONS["en,missing_tools"]="Required components are missing:"
  TRANSLATIONS["en,install_prompt"]="Do you want to install them now? (Y/n):"
  TRANSLATIONS["en,missing_required"]="⚠️ Script cannot work without required components. Exiting."
  TRANSLATIONS["en,rpc_prompt"]="Enter RPC URL:"
  TRANSLATIONS["en,env_created"]="✅ Created .env file with RPC URL"
  TRANSLATIONS["en,env_exists"]="✅ Using existing .env file with RPC URL:"
  TRANSLATIONS["en,search_container"]="🔍 Searching for 'aztec' container..."
  TRANSLATIONS["en,container_not_found"]="❌ Container 'aztec' not found."
  TRANSLATIONS["en,container_found"]="✅ Container found:"
  TRANSLATIONS["en,get_block"]="🔗 Getting current block from contract..."
  TRANSLATIONS["en,block_error"]="❌ Error: Failed to get block number. Check RPC or contract."
  TRANSLATIONS["en,current_block"]="📦 Current block number:"
  TRANSLATIONS["en,node_ok"]="✅ Node is working and processing current block"
  TRANSLATIONS["en,node_behind"]="⚠️ Current block not found in logs. Node might be behind."
  TRANSLATIONS["en,search_rollup"]="🔍 Searching for rollupAddress in 'aztec' container logs..."
  TRANSLATIONS["en,rollup_found"]="✅ Current rollupAddress:"
  TRANSLATIONS["en,rollup_not_found"]="❌ rollupAddress not found in logs."
  TRANSLATIONS["en,search_peer"]="🔍 Searching for PeerID in 'aztec' container logs..."
  TRANSLATIONS["en,peers_found"]="Found PeerIDs:"
  TRANSLATIONS["en,peer_not_found"]="❌ No PeerID found in logs."
  TRANSLATIONS["en,search_gov"]="🔍 Searching for governanceProposerPayload in 'aztec' container logs..."
  TRANSLATIONS["en,gov_found"]="Found governanceProposerPayload values:"
  TRANSLATIONS["en,gov_not_found"]="❌ No governanceProposerPayload found."
  TRANSLATIONS["en,gov_changed"]="🛑 GovernanceProposerPayload change detected!"
  TRANSLATIONS["en,gov_was"]="⚠️ Was:"
  TRANSLATIONS["en,gov_now"]="Now:"
  TRANSLATIONS["en,gov_no_changes"]="✅ No changes detected."
  TRANSLATIONS["en,token_prompt"]="Enter Telegram Bot Token:"
  TRANSLATIONS["en,chatid_prompt"]="Enter Telegram Chat ID:"
  TRANSLATIONS["en,agent_added"]="✅ Agent added to cron and will run every minute."
  TRANSLATIONS["en,agent_exists"]="ℹ️ Agent already exists in cron."
  TRANSLATIONS["en,removing_agent"]="🗑 Removing agent and cron task..."
  TRANSLATIONS["en,agent_removed"]="✅ Agent and cron task removed."
  TRANSLATIONS["en,goodbye"]="👋 Goodbye."
  TRANSLATIONS["en,invalid_choice"]="❌ Invalid choice. Try again."
  TRANSLATIONS["en,searching"]="Searching..."
  TRANSLATIONS["en,get_proven_block"]="🔍 Getting proven L2 block number..."
  TRANSLATIONS["en,proven_block_found"]="✅ Proven L2 Block Number:"
  TRANSLATIONS["en,proven_block_error"]="❌ Failed to retrieve the proven L2 block number."
  TRANSLATIONS["en,get_sync_proof"]="🔍 Fetching Sync Proof..."
  TRANSLATIONS["en,sync_proof_found"]="✅ Sync Proof:"
  TRANSLATIONS["en,sync_proof_error"]="❌ Failed to retrieve sync proof."
  TRANSLATIONS["en,token_check"]="🔍 Checking Telegram token and ChatID..."
  TRANSLATIONS["en,token_valid"]="✅ Telegram token is valid"
  TRANSLATIONS["en,token_invalid"]="❌ Invalid Telegram token"
  TRANSLATIONS["en,chatid_valid"]="✅ ChatID is valid and bot has access"
  TRANSLATIONS["en,chatid_invalid"]="❌ Invalid ChatID or bot has no access"
  TRANSLATIONS["en,agent_created"]="✅ Agent successfully created and configured!"
  TRANSLATIONS["en,running_validator_script"]="Running Check Validator script from GitHub..."
  TRANSLATIONS["en,failed_run_validator"]="Failed to run Check Validator script."
  TRANSLATIONS["en,enter_aztec_port_prompt"]="Enter Aztec node port number"
  TRANSLATIONS["en,port_saved_successfully"]="✅ Port saved successfully"
  TRANSLATIONS["en,checking_port"]="Checking port"
  TRANSLATIONS["en,port_not_available"]="Aztec port not available on"
  TRANSLATIONS["en,current_aztec_port"]="Current Aztec node port:"

  # Russian translations
  TRANSLATIONS["ru,welcome"]="Добро пожаловать в скрипт мониторинга ноды Aztec"
  TRANSLATIONS["ru,title"]="========= Главное меню ========="
  TRANSLATIONS["ru,option1"]="1. Проверить контейнер и актуальный блок"
  TRANSLATIONS["ru,option2"]="2. Установить cron-агент для мониторинга"
  TRANSLATIONS["ru,option3"]="3. Удалить cron-агент и файлы"
  TRANSLATIONS["ru,option4"]="4. Найти адрес rollupAddress в логах"
  TRANSLATIONS["ru,option5"]="5. Найти PeerID в логах"
  TRANSLATIONS["ru,option6"]="6. Найти governanceProposerPayload в логах"
  TRANSLATIONS["ru,option7"]="7. Проверить Proven L2 блок и Sync Proof"
  TRANSLATIONS["ru,option8"]="8. Изменить RPC URL"
  TRANSLATIONS["ru,option9"]="9. Поиск валидатора и проверка статуса"
  TRANSLATIONS["ru,option0"]="0. Выход"
  TRANSLATIONS["ru,rpc_change_prompt"]="Введите новый RPC URL:"
  TRANSLATIONS["ru,rpc_change_success"]="✅ RPC URL успешно обновлен"
  TRANSLATIONS["ru,choose_option"]="Выберите опцию:"
  TRANSLATIONS["ru,checking_deps"]="🔍 Проверка необходимых компонентов:"
  TRANSLATIONS["ru,missing_tools"]="Необходимые компоненты отсутствуют:"
  TRANSLATIONS["ru,install_prompt"]="Хотите установить их сейчас? (Y/n):"
  TRANSLATIONS["ru,missing_required"]="⚠️ Без необходимых компонентов скрипт не сможет работать. Завершение."
  TRANSLATIONS["ru,rpc_prompt"]="Введите RPC URL:"
  TRANSLATIONS["ru,env_created"]="✅ Создан файл .env с RPC URL"
  TRANSLATIONS["ru,env_exists"]="✅ Используется существующий .env файл с RPC URL:"
  TRANSLATIONS["ru,search_container"]="🔍 Поиск контейнера с именем 'aztec'..."
  TRANSLATIONS["ru,container_not_found"]="❌ Контейнер с именем 'aztec' не найден."
  TRANSLATIONS["ru,container_found"]="✅ Найден контейнер:"
  TRANSLATIONS["ru,get_block"]="🔗 Получение актуального блока из контракта..."
  TRANSLATIONS["ru,block_error"]="❌ Ошибка: не удалось получить номер блока. Проверьте RPC или контракт."
  TRANSLATIONS["ru,current_block"]="📦 Актуальный номер блока:"
  TRANSLATIONS["ru,node_ok"]="✅ Нода работает и обрабатывает актуальный блок"
  TRANSLATIONS["ru,node_behind"]="⚠️ Актуальный блок не найден в логах. Возможно, нода отстаёт."
  TRANSLATIONS["ru,search_rollup"]="🔍 Поиск rollupAddress в логах контейнера 'aztec'..."
  TRANSLATIONS["ru,rollup_found"]="✅ Актуальный rollupAddress:"
  TRANSLATIONS["ru,rollup_not_found"]="❌ Адрес rollupAddress не найден в логе."
  TRANSLATIONS["ru,search_peer"]="🔍 Поиск PeerID в логах контейнера 'aztec'..."
  TRANSLATIONS["ru,peers_found"]="Найденные PeerID:"
  TRANSLATIONS["ru,peer_not_found"]="❌ В логах PeerID не найден."
  TRANSLATIONS["ru,search_gov"]="🔍 Поиск governanceProposerPayload в логах контейнера 'aztec'..."
  TRANSLATIONS["ru,gov_found"]="Найденные значения governanceProposerPayload:"
  TRANSLATIONS["ru,gov_not_found"]="❌ Ни одного governanceProposerPayload не найдено."
  TRANSLATIONS["ru,gov_changed"]="🛑 Обнаружено изменение governanceProposerPayload!"
  TRANSLATIONS["ru,gov_was"]="⚠️ Было:"
  TRANSLATIONS["ru,gov_now"]="Стало:"
  TRANSLATIONS["ru,gov_no_changes"]="✅ Изменений не обнаружено."
  TRANSLATIONS["ru,token_prompt"]="Введите Telegram Bot Token:"
  TRANSLATIONS["ru,chatid_prompt"]="Введите Telegram Chat ID:"
  TRANSLATIONS["ru,agent_added"]="✅ Агент добавлен в cron и будет выполняться каждую минуту."
  TRANSLATIONS["ru,agent_exists"]="ℹ️ Агент уже есть в cron."
  TRANSLATIONS["ru,removing_agent"]="🗑 Удаление агента и cron-задачи..."
  TRANSLATIONS["ru,agent_removed"]="✅ Агент и cron-задача удалены."
  TRANSLATIONS["ru,goodbye"]="👋 Выход."
  TRANSLATIONS["ru,invalid_choice"]="❌ Неверный выбор. Попробуйте снова."
  TRANSLATIONS["ru,searching"]="Поиск..."
  TRANSLATIONS["ru,get_proven_block"]="🔍 Получение номера proven L2 блока..."
  TRANSLATIONS["ru,proven_block_found"]="✅ Номер Proven L2 блока:"
  TRANSLATIONS["ru,proven_block_error"]="❌ Не удалось получить номер proven L2 блока."
  TRANSLATIONS["ru,get_sync_proof"]="🔍 Получение Sync Proof..."
  TRANSLATIONS["ru,sync_proof_found"]="✅ Sync Proof:"
  TRANSLATIONS["ru,sync_proof_error"]="❌ Не удалось получить sync proof."
  TRANSLATIONS["ru,token_check"]="🔍 Проверка Telegram токена и ChatID..."
  TRANSLATIONS["ru,token_valid"]="✅ Telegram токен действителен"
  TRANSLATIONS["ru,token_invalid"]="❌ Неверный Telegram токен"
  TRANSLATIONS["ru,chatid_valid"]="✅ ChatID действителен и бот имеет доступ"
  TRANSLATIONS["ru,chatid_invalid"]="❌ Неверный ChatID или бот не имеет доступа"
  TRANSLATIONS["ru,agent_created"]="✅ Агент успешно создан и настроен!"
  TRANSLATIONS["ru,running_validator_script"]="Запуск скрипта проверки валидатора из GitHub..."
  TRANSLATIONS["ru,failed_run_validator"]="Не удалось запустить скрипт проверки валидатора."
  TRANSLATIONS["ru,enter_aztec_port_prompt"]="Введите номер порта Aztec"
  TRANSLATIONS["ru,port_saved_successfully"]="✅ Порт успешно сохранен"
  TRANSLATIONS["ru,checking_port"]="Проверка порта"
  TRANSLATIONS["ru,port_not_available"]="Aztec порт недоступен на"
  TRANSLATIONS["ru,current_aztec_port"]="Текущий порт ноды Aztec:"
}

# === Configuration ===
CONTRACT_ADDRESS="0xee6d4e937f0493fb461f28a75cf591f1dba8704e"
FUNCTION_SIG="getPendingBlockNumber()"

REQUIRED_TOOLS=("cast" "curl" "crontab" "grep" "sed" "jq" "bc")
AGENT_SCRIPT_PATH="$HOME/aztec-monitor-agent"
LOG_FILE="$AGENT_SCRIPT_PATH/agent.log"

# === Dependency check ===

check_dependencies() {
  missing=()
  echo -e "\n${BLUE}$(t "checking_deps")${NC}\n"

  for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
      echo -e "${RED}❌ $tool $(t "not_installed")${NC}"
      missing+=("$tool")
    else
      echo -e "${GREEN}✅ $tool $(t "installed")${NC}"
    fi
  done

  if [ ${#missing[@]} -gt 0 ]; then
    echo -e "\n${YELLOW}$(t "missing_tools") ${missing[*]}${NC}"
    read -p "$(t "install_prompt") " confirm
    confirm=${confirm:-Y}

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      for tool in "${missing[@]}"; do
        case "$tool" in
          cast)
            echo -e "\n${CYAN}$(t "installing_foundry")${NC}"
            curl -L https://foundry.paradigm.xyz | bash

            if ! grep -q 'foundry/bin'  ~/.bash_profile; then
              echo 'export PATH="$PATH:$HOME/.foundry/bin"' >> ~/.bash_profile
            fi

            export PATH="$PATH:$HOME/.foundry/bin"
            foundryup
            ;;

          curl)
            echo -e "\n${CYAN}$(t "installing_curl")${NC}"
            sudo apt-get install -y curl || brew install curl
            ;;

          crontab)
            echo -e "\n${CYAN}$(t "installing_cron")${NC}"
            sudo apt-get install -y cron || brew install cronie
            ;;

          grep|sed)
            echo -e "\n${CYAN}$(t "installing_utils")${NC}"
            sudo apt-get install -y grep sed || brew install grep gnu-sed
            ;;

          jq)
            echo -e "\n${CYAN}$(t "installing_jq")${NC}"
            sudo apt-get install -y jq || brew install jq
            ;;

          bc)
            echo -e "\n${CYAN}$(t "installing_bc")${NC}"
            sudo apt-get install -y bc || brew install bc
            ;;
        esac
      done
    else
      echo -e "\n${RED}$(t "missing_required")${NC}"
      exit 1
    fi
  fi


  # Request RPC URL from user and create .env file
  if [ ! -f .env-aztec-agent ]; then
    echo -e "\n${BLUE}$(t "rpc_prompt")${NC}"
    read -p "> " RPC_URL
    echo "RPC_URL=$RPC_URL" > .env-aztec-agent
    echo -e "\n${GREEN}$(t "env_created")${NC}"
  else
    source .env-aztec-agent
    echo -e "\n${GREEN}$(t "env_exists") $RPC_URL${NC}"
  fi
}

# === Spinner function ===
spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'

  while kill -0 "$pid" 2>/dev/null; do
    for i in $(seq 0 3); do
      printf "\r${CYAN}$(t "searching") %c${NC}" "${spinstr:i:1}"
      sleep $delay
    done
  done

  printf "\r                 \r"
}

# === Check container logs ===
check_aztec_container_logs() {
    source .env-aztec-agent

    echo -e "\n${BLUE}$(t "search_container")${NC}"
    container_id=$(docker ps --filter "name=aztec" --format "{{.ID}}" | head -n 1)

    if [ -z "$container_id" ]; then
        echo -e "\n${RED}$(t "container_not_found")${NC}"
        return
    fi

    echo -e "\n${GREEN}$(t "container_found") $container_id${NC}"

    echo -e "\n${BLUE}$(t "get_block")${NC}"
    block_hex=$(cast call "$CONTRACT_ADDRESS" "$FUNCTION_SIG" --rpc-url "$RPC_URL" 2>/dev/null)

    if [ -z "$block_hex" ]; then
        echo -e "\n${RED}$(t "block_error")${NC}"
        return
    fi

    if [ "$block_hex" == "0x" ]; then
        echo -e "\n${RED}$(t "block_error")${NC} (received 0x)"
        echo "$(date '+%F %T') [ERROR] Received invalid block_hex (0x) from contract" >> aztec-logs.log
        return
    fi

    block_number=$((16#${block_hex#0x}))

    echo -e "\n${GREEN}$(t "current_block") $block_number${NC}"

    logs=$(docker logs --tail 500 "$container_id" 2>&1)
    clean_logs=$(echo "$logs" | sed -r 's/\x1B\[[0-9;]*[A-Za-z]//g')

    if echo "$clean_logs" | grep -E -q "\b$block_number\b"; then
        echo -e "\n${GREEN}$(t "node_ok")${NC}"
    else
        echo -e "\n${YELLOW}$(t "node_behind")${NC}"
        echo "Пример строки из логов:"
        echo "$clean_logs" | grep -m1 "$block_number" || echo "Не найдено ни одной строки с номером блока!"
    fi
}



# === Find rollupAddress in logs ===
find_rollup_address() {
  echo -e "\n${BLUE}$(t "search_rollup")${NC}"

  container_id=$(docker ps --filter "name=aztec" --format "{{.ID}}" | head -n 1)

  if [ -z "$container_id" ]; then
    echo -e "\n${RED}$(t "container_not_found")${NC}"
    return 1
  fi

  tmp_log=$(mktemp)
  # Получаем логи с очисткой ANSI-кодов
  docker logs "$container_id" 2>&1 | sed -r "s/\x1B\[[0-9;]*[mK]//g" > "$tmp_log" &

  spinner $!

  # Более надежный поиск rollupAddress
  rollup_address=$(grep -oP -m1 '"rollupAddress"\s*:\s*"\K0x[a-fA-F0-9]{40}' "$tmp_log" | tail -n 1)

  # Альтернативный вариант поиска, если стандартный не сработал
  if [ -z "$rollup_address" ]; then
    rollup_address=$(grep -oE -m1 'rollupAddress[^0-9a-fA-F]*0x[a-fA-F0-9]{40}' "$tmp_log" | grep -oE '0x[a-fA-F0-9]{40}' | tail -n 1)
  fi

  rm "$tmp_log"

  if [ -n "$rollup_address" ]; then
    echo -e "\n${GREEN}$(t "rollup_found") $rollup_address${NC}"
    return 0
  else
    echo -e "\n${RED}$(t "rollup_not_found")${NC}"
    return 1
  fi
}

find_peer_id() {
  echo -e "\n${BLUE}$(t "search_peer")${NC}"

  container_id=$(docker ps --filter "name=aztec" --format "{{.ID}}"  | head -n 1)

  if [ -z "$container_id" ]; then
    echo -e "\n${RED}$(t "container_not_found")${NC}"
    return 1
  fi

  echo -e "\n${CYAN}$(t "peers_found")${NC}"

  # Фоновый процесс для поиска peerId
  _find_peer_id_worker() {
    sudo docker logs "$container_id" 2>&1 | \
      grep -i "peerId" | \
      grep -o '"peerId":"[^"]*"' | \
      cut -d'"' -f4 | \
      head -n 1 > /tmp/peer_id.tmp
  }

  _find_peer_id_worker &
  worker_pid=$!
  spinner $worker_pid
  wait $worker_pid

  peer_id=$(< /tmp/peer_id.tmp)
  rm -f /tmp/peer_id.tmp

  if [ -z "$peer_id" ]; then
    echo -e "${RED}$(t "peer_not_found")${NC}"
    return 1
  else
    echo "$peer_id"
    return 0
  fi
}

# === Find governanceProposerPayload ===
find_governance_proposer_payload() {
  echo -e "\n${BLUE}$(t "search_gov")${NC}"

  # Получаем ID контейнера
  container_id=$(docker ps --filter "name=aztec" --format "{{.ID}}"  | head -n 1)

  if [ -z "$container_id" ]; then
    echo -e "\n${RED}$(t "container_not_found")${NC}"
    return 1
  fi

  echo -e "\n${CYAN}$(t "gov_found")${NC}"

  # Вспомогательная функция для запуска поиска в фоне
  _find_payloads_worker() {
    sudo docker logs "$container_id" 2>&1 | \
      grep -i '"governanceProposerPayload"' | \
      grep -o '"governanceProposerPayload":"0x[a-fA-F0-9]\{40\}"' | \
      cut -d'"' -f4 | \
      awk '!seen[$0]++ {print}' | \
      tail -n 10 > /tmp/gov_payloads.tmp
  }

  # Запускаем поиск в фоне и спиннер
  _find_payloads_worker &
  worker_pid=$!
  spinner $worker_pid
  wait $worker_pid

  if [ ! -s /tmp/gov_payloads.tmp ]; then
    echo -e "\n${RED}$(t "gov_not_found")${NC}"
    rm -f /tmp/gov_payloads.tmp
    return 1
  fi

  mapfile -t payloads_array < /tmp/gov_payloads.tmp
  rm -f /tmp/gov_payloads.tmp

  echo -e "\n${GREEN}$(t "gov_found_results")${NC}"
  for p in "${payloads_array[@]}"; do
    echo "• $p"
  done

  if [ "${#payloads_array[@]}" -gt 1 ]; then
    echo -e "\n${RED}$(t "gov_changed")${NC}"
    for ((i = 1; i < ${#payloads_array[@]}; i++)); do
      echo -e "${YELLOW}$(t "gov_was") ${payloads_array[i-1]} → $(t "gov_now") ${payloads_array[i]}${NC}"
    done
  else
    echo -e "\n${GREEN}$(t "gov_no_changes")${NC}"
  fi

  return 0
}

# === Create agent and cron task ===
create_cron_agent() {
  source .env-aztec-agent

  # Function to validate Telegram bot token
  validate_telegram_token() {
    local token=$1
    if [[ ! "$token" =~ ^[0-9]+:[a-zA-Z0-9_-]+$ ]]; then
      return 1
    fi
    # Test token by making API call
    local response=$(curl -s "https://api.telegram.org/bot${token}/getMe")
    if [[ "$response" == *"ok\":true"* ]]; then
      return 0
    else
      return 1
    fi
  }

  # Function to validate Telegram chat ID (updated version)
  validate_telegram_chat() {
    local token=$1
    local chat_id=$2
    # Test chat ID by trying to send a test message
    local response=$(curl -s -X POST "https://api.telegram.org/bot${token}/sendMessage" \
      -d chat_id="${chat_id}" \
      -d text="✅ ChatID successfully linked to Aztec Agent" \
      -d parse_mode="Markdown")

    if [[ "$response" == *"ok\":true"* ]]; then
      return 0
    else
      return 1
    fi
  }

  # Get and validate Telegram bot token
  while true; do
    echo -e "\n${BLUE}$(t "token_prompt")${NC}"
    read -p "> " TELEGRAM_BOT_TOKEN

    if validate_telegram_token "$TELEGRAM_BOT_TOKEN"; then
      break
    else
      echo -e "${RED}Invalid Telegram bot token. Please try again.${NC}"
      echo -e "${YELLOW}Token should be in format: 1234567890:ABCdefGHIJKlmNoPQRsTUVwxyZ${NC}"
    fi
  done

  # Get and validate Telegram chat ID
  while true; do
    echo -e "\n${BLUE}$(t "chatid_prompt")${NC}"
    read -p "> " TELEGRAM_CHAT_ID

    if [[ "$TELEGRAM_CHAT_ID" =~ ^-?[0-9]+$ ]]; then
      if validate_telegram_chat "$TELEGRAM_BOT_TOKEN" "$TELEGRAM_CHAT_ID"; then
        break
      else
        echo -e "${RED}Invalid Telegram chat ID or the bot doesn't have access to this chat. Please try again.${NC}"
      fi
    else
      echo -e "${RED}Chat ID must be a number (can start with - for group chats). Please try again.${NC}"
    fi
  done

  mkdir -p "$AGENT_SCRIPT_PATH"

cat > "$AGENT_SCRIPT_PATH/agent.sh" <<EOF
#!/bin/bash
export PATH="$PATH:/root/.foundry/bin"

source \$HOME/.env-aztec-agent
CONTRACT_ADDRESS="$CONTRACT_ADDRESS"
FUNCTION_SIG="$FUNCTION_SIG"
TELEGRAM_BOT_TOKEN="$TELEGRAM_BOT_TOKEN"
TELEGRAM_CHAT_ID="$TELEGRAM_CHAT_ID"
LOG_FILE="$LOG_FILE"

# Create log file if it doesn't exist
if [ ! -f "\$LOG_FILE" ]; then
  touch "\$LOG_FILE" 2>/dev/null || {
    echo "Error: Could not create log file \$LOG_FILE"
    exit 1
  }
fi

if [ ! -w "\$LOG_FILE" ]; then
  echo "Error: No write permission for \$LOG_FILE"
  exit 1
fi

# Check log file size and clean if exceeds 1MB
MAX_SIZE=1048576
current_size=\$(stat -c%s "\$LOG_FILE")

if [ "\$current_size" -gt "\$MAX_SIZE" ]; then

  temp_file=\$(mktemp)
  awk '/INITIALIZED/ {print; exit} {print}' "\$LOG_FILE" > "\$temp_file"
  mv "\$temp_file" "\$LOG_FILE"
  chmod 644 "\$LOG_FILE"

  {
    echo ""
    echo "✅ Log file cleaned."
    echo "Cleanup completed: \$(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
  } >> "\$LOG_FILE"

  ip=\$(curl -s https://api.ipify.org || echo "unknown-ip")
  curl -s -X POST "https://api.telegram.org/bot\$TELEGRAM_BOT_TOKEN/sendMessage" \\
    -d chat_id="\$TELEGRAM_CHAT_ID" \\
    -d text="⚠️ *Log file cleaned due to size limit*%0A🌐 Server: \$ip%0A🗃 File: \$LOG_FILE%0A📏 Previous size: \$current_size bytes." \\
    -d parse_mode="Markdown" >/dev/null
else
  {
    echo "="
    echo "Log size check"
    echo "Current size: \$current_size bytes (within limit)."
    echo "Check timestamp: \$(date '+%Y-%m-%d %H:%M:%S')"
    echo "="
  } >> "\$LOG_FILE"
fi

log() {
  echo "[\$(date '+%Y-%m-%d %H:%M:%S')] \$1" >> "\$LOG_FILE"
}

send_telegram_message() {
  local message="\$1"
  curl -s -X POST "https://api.telegram.org/bot\$TELEGRAM_BOT_TOKEN/sendMessage" \\
    -d chat_id="\$TELEGRAM_CHAT_ID" \\
    -d text="\$message" \\
    -d parse_mode="Markdown" >/dev/null
}

get_ip_address() {
  curl -s https://api.ipify.org || echo "unknown-ip"
}
ip=\$(get_ip_address)

# New hex to decimal conversion function
hex_to_dec() {
  local hex=\$1
  # Remove 0x prefix if present
  hex=\${hex#0x}
  # Remove leading zeros
  hex=\$(echo \$hex | sed 's/^0*//')
  # If empty after removing zeros, return 0
  [ -z "\$hex" ] && echo 0 && return
  echo \$((16#\$hex))
}

# Check if container exists
check_blocks() {
  container_id=\$(docker ps --filter "name=aztec" --format "{{.ID}}" | head -n 1)
  [ -z "\$container_id" ] && {
    log "Container 'aztec' not found."
    send_telegram_message "❌ *Aztec Container Not Found*%0A🌐 Server: \$ip%0A🕒 \$(date '+%Y-%m-%d %H:%M:%S')"
    return 1
  }

  # Get current block from contract
  block_hex=\$(cast call "\$CONTRACT_ADDRESS" "\$FUNCTION_SIG" --rpc-url "\$RPC_URL" 2>&1)
  [[ "\$block_hex" == *"Error"* || -z "\$block_hex" ]] && {
	log "Block Fetch Error. Check RPC or cast"
    send_telegram_message "❌ *Block Fetch Error*%0A🌐 Server: \$ip%0A🔗 RPC: \$RPC_URL%0A💬 Error: \$block_hex%0A🕒 \$(date '+%Y-%m-%d %H:%M:%S')"
    return 1
  }

  # Convert hex to decimal
  block_number=\$((16#\${block_hex#0x}))
  log "Contract block: \$block_number"

  # Очистка логов от ANSI-кодов и поиск блока
  logs=\$(docker logs --tail 1000 "\$container_id" 2>&1 | sed -r "s/\x1B\[[0-9;]*[mK]//g")

  # Поиск блока в разных форматах
  log_block=\$(echo "\$logs" | grep -oP '(block |Proven chain is now at block )\K[0-9]+' | tail -n 1)
  [ -z "\$log_block" ] && log_block="none"

  # Compare blocks
  if [ "\$log_block" == "none" ]; then
    status="❌ No blocks found in logs"
    send_telegram_message "❌ *No blocks processed*%0A🌐 Server: \$ip%0A📦 Contract block: \$block_number%0A🕒 \$(date '+%Y-%m-%d %H:%M:%S')"
  elif [ "\$log_block" -eq "\$block_number" ]; then
    status="✅ Node synced (block \$block_number)"
  else
    blocks_diff=\$((block_number - log_block))
    status="⚠️ Node behind by \$blocks_diff blocks"
    [ \$blocks_diff -gt 3 ] && send_telegram_message "⚠️ *Node is behind by \$blocks_diff blocks*%0A🌐 Server: \$ip%0A📦 Contract block: \$block_number%0A📝 Logs block: \$log_block%0A🕒 \$(date '+%Y-%m-%d %H:%M:%S')"
  fi

  log "Status: \$status (logs: \$log_block, contract: \$block_number)"
  [ ! -f "\$LOG_FILE.initialized" ] && {
    send_telegram_message "🤖 *Aztec Monitoring Agent Started*%0A🌐 Server: \$ip%0A\$status%0Aℹ️ Notifications will be sent for issues%0A🕒 \$(date '+%Y-%m-%d %H:%M:%S')"
    touch "\$LOG_FILE.initialized"
	echo "v020625-last" >> "\$LOG_FILE"
	echo "INITIALIZED" >> "\$LOG_FILE"
  }
}

check_blocks
EOF

  chmod +x "$AGENT_SCRIPT_PATH/agent.sh"

  if ! crontab -l | grep -q "$AGENT_SCRIPT_PATH/agent.sh"; then
    (crontab -l 2>/dev/null; echo "* * * * * $AGENT_SCRIPT_PATH/agent.sh") | crontab -
    echo -e "\n${GREEN}$(t "agent_added")${NC}"
  else
    echo -e "\n${YELLOW}$(t "agent_exists")${NC}"
  fi
}

# === Remove cron task and agent ===
remove_cron_agent() {
  echo -e "\n${BLUE}$(t "removing_agent")${NC}"
  crontab -l 2>/dev/null | grep -v "$AGENT_SCRIPT_PATH/agent.sh" | crontab -
  rm -rf "$AGENT_SCRIPT_PATH"
  echo -e "\n${GREEN}$(t "agent_removed")${NC}"
}

check_proven_block() {
  ENV_FILE="/root/.env-aztec-agent"

  if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
  fi

  AZTEC_PORT=${AZTEC_PORT:-8080}

  echo -e "\n${CYAN}$(t "current_aztec_port") $AZTEC_PORT${NC}"
  read -p "$(t "enter_aztec_port_prompt") [${AZTEC_PORT}]: " user_port

  if [ -n "$user_port" ]; then
    AZTEC_PORT=$user_port

    if grep -q "^AZTEC_PORT=" "$ENV_FILE" 2>/dev/null; then
      sed -i "s/^AZTEC_PORT=.*/AZTEC_PORT=$AZTEC_PORT/" "$ENV_FILE"
    else
      echo "AZTEC_PORT=$AZTEC_PORT" >> "$ENV_FILE"
    fi

    echo -e "${GREEN}$(t "port_saved_successfully")${NC}"
  fi

  echo -e "\n${BLUE}$(t "checking_port") $AZTEC_PORT...${NC}"
  if ! nc -z -w 2 localhost $AZTEC_PORT; then
    echo -e "\n${RED}$(t "port_not_available") $AZTEC_PORT${NC}"
    echo -e "${YELLOW}$(t "check_node_running")${NC}"
    return 1
  fi

  echo -e "\n${BLUE}$(t "get_proven_block")${NC}"

  # Фоновый процесс получения блока
  (
    curl -s -X POST -H 'Content-Type: application/json' \
      -d '{"jsonrpc":"2.0","method":"node_getL2Tips","params":[],"id":67}' \
      http://localhost:$AZTEC_PORT | jq -r ".result.proven.number"
  ) > /tmp/proven_block.tmp &
  pid1=$!
  spinner $pid1
  wait $pid1

  PROVEN_BLOCK=$(< /tmp/proven_block.tmp)
  rm -f /tmp/proven_block.tmp

  if [[ -z "$PROVEN_BLOCK" || "$PROVEN_BLOCK" == "null" ]]; then
    echo -e "\n${RED}$(t "proven_block_error")${NC}"
    return 1
  fi

  echo -e "\n${GREEN}$(t "proven_block_found") $PROVEN_BLOCK${NC}"

  echo -e "\n${BLUE}$(t "get_sync_proof")${NC}"

  # Фоновый процесс получения proof
  (
    curl -s -X POST -H 'Content-Type: application/json' \
      -d "{\"jsonrpc\":\"2.0\",\"method\":\"node_getArchiveSiblingPath\",\"params\":[\"$PROVEN_BLOCK\",\"$PROVEN_BLOCK\"],\"id\":68}" \
      http://localhost:$AZTEC_PORT | jq -r ".result"
  ) > /tmp/sync_proof.tmp &
  pid2=$!
  spinner $pid2
  wait $pid2

  SYNC_PROOF=$(< /tmp/sync_proof.tmp)
  rm -f /tmp/sync_proof.tmp

  if [[ -z "$SYNC_PROOF" || "$SYNC_PROOF" == "null" ]]; then
    echo -e "\n${RED}$(t "sync_proof_error")${NC}"
    return 1
  fi

  echo -e "\n${GREEN}$(t "sync_proof_found")${NC}"
  echo "$SYNC_PROOF"
  return 0
}

# === Change RPC URL ===
change_rpc_url() {
  ENV_FILE=".env-aztec-agent"

  echo -e "\n${BLUE}$(t "rpc_change_prompt")${NC}"
  read -p "> " NEW_RPC_URL

  if [ -z "$NEW_RPC_URL" ]; then
    echo -e "${RED}Error: RPC URL cannot be empty${NC}"
    return 1
  fi

  # Тестируем RPC URL
  echo -e "\n${BLUE}Testing new RPC URL...${NC}"
  response=$(curl -s -X POST -H "Content-Type: application/json" \
    --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
    "$NEW_RPC_URL" 2>/dev/null)

  if [[ -z "$response" || "$response" == *"error"* ]]; then
    echo -e "${RED}Error: Failed to connect to the RPC endpoint. Please check the URL and try again.${NC}"
    return 1
  fi

  # Обновляем или добавляем RPC_URL в файл
  if grep -q "^RPC_URL=" "$ENV_FILE" 2>/dev/null; then
    sed -i "s|^RPC_URL=.*|RPC_URL=$NEW_RPC_URL|" "$ENV_FILE"
  else
    echo "RPC_URL=$NEW_RPC_URL" >> "$ENV_FILE"
  fi

  echo -e "\n${GREEN}$(t "rpc_change_success")${NC}"
  echo -e "${YELLOW}New RPC URL: $NEW_RPC_URL${NC}"

  # Подгружаем обновления
  source "$ENV_FILE"
}

# === Check validator ===
function check_validator {
  URL="https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/check-validator.sh"
  echo -e ""
  echo -e "${CYAN}$(t "running_validator_script")${RESET}"
  echo -e ""

  # Передаем текущий язык как аргумент
  bash <(curl -s "$URL") "$LANG" || print_error "$(t "failed_run_validator")"
}

# === Main menu ===
main_menu() {
  show_logo
  while true; do
    echo -e "\n${BLUE}$(t "title")${NC}"
    echo -e "${CYAN}$(t "option1")${NC}"
    echo -e "${CYAN}$(t "option2")${NC}"
    echo -e "${CYAN}$(t "option3")${NC}"
    echo -e "${CYAN}$(t "option4")${NC}"
    echo -e "${CYAN}$(t "option5")${NC}"
    echo -e "${CYAN}$(t "option6")${NC}"
    echo -e "${CYAN}$(t "option7")${NC}"
    echo -e "${CYAN}$(t "option8")${NC}"
    echo -e "${CYAN}$(t "option9")${NC}"
    echo -e "${RED}$(t "option0")${NC}"
    echo -e "${BLUE}================================${NC}"

    read -p "$(t "choose_option") " choice

    case "$choice" in
      1) check_aztec_container_logs ;;
      2) create_cron_agent ;;
      3) remove_cron_agent ;;
      4) find_rollup_address ;;
      5) find_peer_id ;;
      6) find_governance_proposer_payload ;;
      7) check_proven_block ;;
      8) change_rpc_url ;;
      9) check_validator ;;
      0) echo -e "\n${GREEN}$(t "goodbye")${NC}"; exit 0 ;;
      *) echo -e "\n${RED}$(t "invalid_choice")${NC}" ;;
    esac
  done
}

# === Script launch ===
init_languages
check_dependencies
main_menu