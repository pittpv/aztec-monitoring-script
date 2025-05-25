#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

function show_logo() {
    echo -e "${BLUE}$(t "welcome")${RESET}"
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
  TRANSLATIONS["en,welcome"]="     Welcome to the Aztec node monitoring script     "
  TRANSLATIONS["en,title"]="========= Main Menu ========="
  TRANSLATIONS["en,option1"]="1. Check container and current block"
  TRANSLATIONS["en,option2"]="2. Install cron monitoring agent"
  TRANSLATIONS["en,option3"]="3. Remove cron agent and files"
  TRANSLATIONS["en,option4"]="4. Find rollupAddress in logs"
  TRANSLATIONS["en,option5"]="5. Find PeerID in logs"
  TRANSLATIONS["en,option6"]="6. Find governanceProposerPayload in logs"
  TRANSLATIONS["en,option0"]="0. Exit"
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

  # Russian translations
  TRANSLATIONS["ru,welcome"]="   Добро пожаловать в скрипт мониторинга ноды Aztec   "
  TRANSLATIONS["ru,title"]="========= Главное меню ========="
  TRANSLATIONS["ru,option1"]="1. Проверить контейнер и актуальный блок"
  TRANSLATIONS["ru,option2"]="2. Установить cron-агент для мониторинга"
  TRANSLATIONS["ru,option3"]="3. Удалить cron-агент и файлы"
  TRANSLATIONS["ru,option4"]="4. Найти адрес rollupAddress в логах"
  TRANSLATIONS["ru,option5"]="5. Найти PeerID в логах"
  TRANSLATIONS["ru,option6"]="6. Найти governanceProposerPayload в логах"
  TRANSLATIONS["ru,option0"]="0. Выход"
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
}

# === Configuration ===
CONTRACT_ADDRESS="0xee6d4e937f0493fb461f28a75cf591f1dba8704e"
FUNCTION_SIG="getPendingBlockNumber()"

REQUIRED_TOOLS=("cast" "curl" "crontab" "grep" "sed")
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
            source ~/.bashrc 2>/dev/null || source ~/.zshrc 2>/dev/null
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

  block_number=$((block_hex))
  echo -e "\n${GREEN}$(t "current_block") $block_number${NC}"

  logs=$(docker logs --tail 500 "$container_id")

  if echo "$logs" | grep -q "$block_number"; then
    echo -e "\n${GREEN}$(t "node_ok")${NC}"
  else
    echo -e "\n${YELLOW}$(t "node_behind")${NC}"
  fi
}

# === Find rollupAddress in logs ===
find_rollup_address() {
  echo -e "\n${BLUE}$(t "search_rollup")${NC}"

  container_id=$(docker ps --filter "name=aztec" --format "{{.ID}}" | head -n 1)

  if [ -z "$container_id" ]; then
    echo -e "\n${RED}$(t "container_not_found")${NC}"
    return
  fi

  tmp_log=$(mktemp)
  docker logs "$container_id" > "$tmp_log" 2>/dev/null &

  spinner $!

  # Get last occurrence of rollupAddress
  rollup_address=$(grep -oP '"rollupAddress"\s*:\s*"\K0x[a-fA-F0-9]{40}' "$tmp_log" | tail -n 1)

  rm "$tmp_log"

  if [ -n "$rollup_address" ]; then
    echo -e "\n${GREEN}$(t "rollup_found") $rollup_address${NC}"
  else
    echo -e "\n${RED}$(t "rollup_not_found")${NC}"
  fi
}

# === Find PeerID in logs ===
find_peer_id() {
  echo -e "\n${BLUE}$(t "search_peer")${NC}"

  container_id=$(docker ps --filter "name=aztec" --format "{{.ID}}" | head -n 1)

  if [ -z "$container_id" ]; then
    echo -e "\n${RED}$(t "container_not_found")${NC}"
    return
  fi

  tmp_log=$(mktemp)
  docker logs "$container_id" > "$tmp_log" 2>/dev/null &

  spinner $!

  echo -e "\n${CYAN}$(t "peers_found")${NC}"
  # Show unique PeerIDs matching 16Uiu2... format
  grep -oP '"peerId"\s*:\s*"\K16U[^\"]+' "$tmp_log" | sort | uniq || echo -e "${RED}$(t "peer_not_found")${NC}"

  rm "$tmp_log"
}

# === Find governanceProposerPayload ===
find_governance_proposer_payload() {
  echo -e "\n${BLUE}$(t "search_gov")${NC}"

  container_id=$(docker ps --filter "name=aztec" --format "{{.ID}}" | tail -n 1)

  if [ -z "$container_id" ]; then
    echo -e "\n${RED}$(t "container_not_found")${NC}"
    return
  fi

  tmp_log=$(mktemp)
  docker logs "$container_id" > "$tmp_log" 2>/dev/null &

  spinner $!

  echo -e "\n${CYAN}$(t "gov_found")${NC}"

  # Extract all occurrences, remove consecutive duplicates but keep order
  mapfile -t payloads < <(grep -oE '"governanceProposerPayload":"0x[a-fA-F0-9]{40}"' "$tmp_log" | \
    sed -E 's/.*"governanceProposerPayload":"(0x[a-fA-F0-9]{40})"/\1/' | awk 'a != $0 {print; a = $0}')

  if [ "${#payloads[@]}" -eq 0 ]; then
    echo -e "\n${RED}$(t "gov_not_found")${NC}"
    rm "$tmp_log"
    return
  fi

  for p in "${payloads[@]}"; do
    echo "• $p"
  done

  if [ "${#payloads[@]}" -gt 1 ]; then
    echo -e "\n${RED}$(t "gov_changed")${NC}"
    for ((i = 1; i < ${#payloads[@]}; i++)); do
      echo -e "${YELLOW}$(t "gov_was") ${payloads[i-1]} → $(t "gov_now") ${payloads[i]}${NC}"
    done
  else
    echo -e "\n${GREEN}$(t "gov_no_changes")${NC}"
  fi

  rm "$tmp_log"
}

# === Create agent and cron task ===
create_cron_agent() {
  source .env-aztec-agent
  
  echo -e "\n${BLUE}$(t "token_prompt")${NC}"
  read -p "> " TELEGRAM_BOT_TOKEN
  
  echo -e "\n${BLUE}$(t "chatid_prompt")${NC}"
  read -p "> " TELEGRAM_CHAT_ID

  mkdir -p "$AGENT_SCRIPT_PATH"

cat > "$AGENT_SCRIPT_PATH/agent.sh" <<EOF
#!/bin/bash

source \$HOME/.env-aztec-agent
CONTRACT_ADDRESS="$CONTRACT_ADDRESS"
FUNCTION_SIG="$FUNCTION_SIG"
TELEGRAM_BOT_TOKEN="$TELEGRAM_BOT_TOKEN"
TELEGRAM_CHAT_ID="$TELEGRAM_CHAT_ID"
LOG_FILE="$LOG_FILE"

if [ ! -f "\$LOG_FILE" ]; then
  touch "\$LOG_FILE" 2>/dev/null
fi

if [ ! -w "\$LOG_FILE" ]; then
  echo "Error: No write permission for \$LOG_FILE"
  exit 1
fi

log() {
  echo "[\$(date '+%Y-%m-%d %H:%M:%S')] \$1" >> "\$LOG_FILE"
}

get_ip_address() {
  curl -s https://api.ipify.org
}

container_id=\$(docker ps --filter "name=aztec" --format "{{.ID}}" | head -n 1)

if [ -z "\$container_id" ]; then
  log "Container 'aztec' not found."
  exit 0
fi

block_hex=\$(cast call "\$CONTRACT_ADDRESS" "\$FUNCTION_SIG" --rpc-url "\$RPC_URL" 2>&1)

if [[ -z "\$block_hex" || "\$block_hex" == *"error"* ]]; then
  log "Error in cast call: \$block_hex"
  exit 0
fi

block_number=\$((block_hex))
logs=\$(docker logs --tail 500 "\$container_id")

ip=\$(get_ip_address)

if ! echo "\$logs" | grep -q "\$block_number"; then
  status="❗ Aztec node is NOT processing current block \$block_number"
  log "Block \$block_number not found in logs - sending notification."
  curl -s -X POST "https://api.telegram.org/bot\$TELEGRAM_BOT_TOKEN/sendMessage" \\
    -d chat_id="\$TELEGRAM_CHAT_ID" \\
    -d text="\$status%0A🌐 Server: \$ip"
else
  status="✅ Aztec node is processing current block \$block_number"
  log "\$status"
fi

# Send welcome message on first run
if ! grep -q "INITIALIZED" "\$LOG_FILE"; then
  curl -s -X POST "https://api.telegram.org/bot\$TELEGRAM_BOT_TOKEN/sendMessage" \\
    -d chat_id="\$TELEGRAM_CHAT_ID" \\
    -d text="🤖 Agent successfully started on server: \$ip%0A\$status%0Aℹ️ Further notifications will be sent only if blocks are delayed."
  echo "INITIALIZED" >> "\$LOG_FILE"
fi
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

# === Main menu ===
main_menu() {
  while true; do
    echo -e "\n${BLUE}$(t "title")${NC}"
    echo -e "${CYAN}$(t "option1")${NC}"
    echo -e "${CYAN}$(t "option2")${NC}"
    echo -e "${CYAN}$(t "option3")${NC}"
    echo -e "${CYAN}$(t "option4")${NC}"
    echo -e "${CYAN}$(t "option5")${NC}"
    echo -e "${CYAN}$(t "option6")${NC}"
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
      0) echo -e "\n${GREEN}$(t "goodbye")${NC}"; exit 0 ;;
      *) echo -e "\n${RED}$(t "invalid_choice")${NC}" ;;
    esac
  done
}

# === Script launch ===
init_languages
check_dependencies
main_menu