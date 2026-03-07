#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
VIOLET='\033[0;35m'
NC='\033[0m' # No Color
GRAY='\e[90m'
BOLD='\e[1m'

# Source modules
source scripts/dependencies.sh
source scripts/check_updates_safely.sh
source scripts/check_error_definitions_updates_safely.sh
source scripts/check_aztec_container_logs.sh
source scripts/view_container_logs.sh
source scripts/find_rollup_address.sh
source scripts/find_peer_id.sh
source scripts/find_governance_proposer_payload.sh
source scripts/create_systemd_agent.sh
source scripts/remove_systemd_agent.sh
source scripts/check_proven_block.sh
source scripts/change_rpc_url.sh
source scripts/install_aztec.sh
source scripts/delete_aztec.sh
source scripts/update_aztec.sh
source scripts/downgrade_aztec.sh
source scripts/check_validator.sh
source scripts/stop_aztec_containers.sh
source scripts/start_aztec_containers.sh
source scripts/check_aztec_version.sh
source scripts/generate_bls_keys.sh
source scripts/approve.sh
source scripts/stake.sh
source scripts/claim_rewards.sh
source scripts/manage_publisher_balance_monitoring.sh
source scripts/utils.sh
source scripts/translations.sh

# === Language settings ===
LANG=""

# Translation function
t() {
  local key=$1
  echo "${TRANSLATIONS[$LANG,$key]}"
}

SCRIPT_VERSION="2.8.2"
ERROR_DEFINITIONS_VERSION="1.0.1"

# Function to load configuration from config.json
load_config() {
  CONFIG_FILE="$SCRIPT_DIR/config.json"
  if [ -f "$CONFIG_FILE" ]; then
    CONTRACT_ADDRESS=$(jq -r '.CONTRACT_ADDRESS' "$CONFIG_FILE")
    CONTRACT_ADDRESS_MAINNET=$(jq -r '.CONTRACT_ADDRESS_MAINNET' "$CONFIG_FILE")
    GSE_ADDRESS_TESTNET=$(jq -r '.GSE_ADDRESS_TESTNET' "$CONFIG_FILE")
    GSE_ADDRESS_MAINNET=$(jq -r '.GSE_ADDRESS_MAINNET' "$CONFIG_FILE")
    FEE_RECIPIENT_ZERO=$(jq -r '.FEE_RECIPIENT_ZERO' "$CONFIG_FILE")
  else
    echo -e "${RED}Error: config.json not found. Please create it in the same directory as the script.${NC}"
    exit 1
  fi
}

# Determine script directory for local file access (security: avoid remote code execution)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load configuration
load_config

# Required tools
REQUIRED_TOOLS=("cast" "curl" "grep" "sed" "jq" "bc" "python3")

# Agent paths
AGENT_SCRIPT_PATH="$HOME/aztec-monitor-agent"
LOG_FILE="$AGENT_SCRIPT_PATH/agent.log"

function show_logo() {
    # Inline logo function (merged from logo.sh)
    local b=$'\033[34m' # Blue
    local y=$'\033[33m' # Yellow
    local r=$'\033[0m'  # Reset

    echo
    echo
    echo -e "${NC}$(t "welcome")${NC}"
    echo
    echo "${b}$(echo "  █████╗ ███████╗████████╗███████╗ ██████╗" | sed -E "s/(█+)/${y}\1${b}/g")${r}"
    echo "${b}$(echo " ██╔══██╗╚══███╔╝╚══██╔══╝██╔════╝██╔════╝" | sed -E "s/(█+)/${y}\1${b}/g")${r}"
    echo "${b}$(echo " ███████║  ███╔╝    ██║   █████╗  ██║" | sed -E "s/(█+)/${y}\1${b}/g")${r}"
    echo "${b}$(echo " ██╔══██║ ███╔╝     ██║   ██╔══╝  ██║" | sed -E "s/(█+)/${y}\1${b}/g")${r}"
    echo "${b}$(echo " ██║  ██║███████╗   ██║   ███████╗╚██████╗" | sed -E "s/(█+)/${y}\1${b}/g")${r}"
    echo "${b}$(echo " ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝ ╚═════╝" | sed -E "s/(█+)/${y}\1${b}/g")${r}"
    echo

    # Information in frame
    local info_lines=(
      " Made by Pittpv"
      " Feedback & Support in Tg: https://t.me/+DLsyG6ol3SFjM2Vk"
      " Donate"
      "  EVM: 0x4FD5eC033BA33507E2dbFE57ca3ce0A6D70b48Bf"
      "  SOL: C9TV7Q4N77LrKJx4njpdttxmgpJ9HGFmQAn7GyDebH4R"
    )

    # Calculate maximum line length (accounting for Unicode, without colors)
    local max_len=0
    for line in "${info_lines[@]}"; do
      local clean_line=$(echo "$line" | sed -E 's/\x1B\[[0-9;]*[mK]//g')
      local line_length=$(echo -n "$clean_line" | wc -m)
      (( line_length > max_len )) && max_len=$line_length
    done

    # Frames
    local top_border="╔$(printf '═%.0s' $(seq 1 $((max_len + 2))))╗"
    local bottom_border="╚$(printf '═%.0s' $(seq 1 $((max_len + 2))))╝"

    # Print frame
    echo -e "${b}${top_border}${r}"
    for line in "${info_lines[@]}"; do
      local clean_line=$(echo "$line" | sed -E 's/\x1B\[[0-9;]*[mK]//g')
      local line_length=$(echo -n "$clean_line" | wc -m)
      local padding=$((max_len - line_length))
      printf "${b}║ ${y}%s%*s ${b}║\n" "$line" "$padding" ""
    done
    echo -e "${b}${bottom_border}${r}"
    echo
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
  show_logo
  while true; do
    echo -e "\n${BLUE}$(t "title")${NC}"
    echo -e "${CYAN}$(t "option1")${NC}"
    echo -e "${GREEN}$(t "option2")${NC}"
    echo -e "${RED}$(t "option3")${NC}"
    echo -e "${CYAN}$(t "option4")${NC}"
    echo -e "${CYAN}$(t "option5")${NC}"
    echo -e "${CYAN}$(t "option6")${NC}"
    echo -e "${CYAN}$(t "option7")${NC}"
    echo -e "${CYAN}$(t "option8")${NC}"
    echo -e "${CYAN}$(t "option9")${NC}"
    echo -e "${CYAN}$(t "option10")${NC}"
    echo -e "${GREEN}$(t "option11")${NC}"
    echo -e "${RED}$(t "option12")${NC}"
    echo -e "${CYAN}$(t "option13")${NC}"
    echo -e "${CYAN}$(t "option14")${NC}"
    echo -e "${CYAN}$(t "option15")${NC}"
    echo -e "${YELLOW}$(t "option16")${NC}"
    echo -e "${CYAN}$(t "option17")${NC}"
    echo -e "${NC}$(t "option18")${NC}"
    echo -e "${NC}$(t "option19")${NC}"
    echo -e "${NC}$(t "option20")${NC}"
    echo -e "${NC}$(t "option21")${NC}"
    echo -e "${CYAN}$(t "option22")${NC}"
    echo -e "${CYAN}$(t "option23")${NC}"
    echo -e "${CYAN}$(t "option24")${NC}"
    echo -e "${RED}$(t "option0")${NC}"
    echo -e "${BLUE}================================${NC}"

    read -p "$(t "choose_option") " choice

    # Flag to track if a valid command was executed
    command_executed=false

    case "$choice" in
      1) check_aztec_container_logs; command_executed=true ;;
      2) create_systemd_agent; command_executed=true ;;
      3) remove_systemd_agent; command_executed=true ;;
      4) view_container_logs; command_executed=true ;;
      5) find_rollup_address; command_executed=true ;;
      6) find_peer_id; command_executed=true ;;
      7) find_governance_proposer_payload; command_executed=true ;;
      8) check_proven_block; command_executed=true ;;
      9) check_validator; command_executed=true ;;
      10) manage_publisher_balance_monitoring; command_executed=true ;;
      11) install_aztec; command_executed=true ;;
      12) delete_aztec; command_executed=true ;;
      13) start_aztec_containers; command_executed=true ;;
      14) stop_aztec_containers; command_executed=true ;;
      15) update_aztec; command_executed=true ;;
      16) downgrade_aztec; command_executed=true ;;
      17) check_aztec_version; command_executed=true ;;
      18) generate_bls_keys; command_executed=true ;;
      19) approve_with_all_keys; command_executed=true ;;
      20) stake_validators; command_executed=true ;;
      21) claim_rewards; command_executed=true ;;
      22) change_rpc_url; command_executed=true ;;
      23) check_updates_safely; command_executed=true ;;
      24) check_error_definitions_updates_safely; command_executed=true ;;
      0) echo -e "\n${GREEN}$(t "goodbye")${NC}"; exit 0 ;;
      *) echo -e "\n${RED}$(t "invalid_choice")${NC}" ;;
    esac

    # Wait for Enter before showing menu again (only for valid commands)
    if [ "$command_executed" = true ]; then
      echo ""
      echo -e "${YELLOW}Press Enter to continue...${NC}"
      read -r
      clear
      show_logo
    fi
  done
}

# === Script launch ===
init_languages
check_dependencies
main_menu
