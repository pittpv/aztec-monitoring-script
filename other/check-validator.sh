#!/bin/bash

ROLLUP_ADDRESS="0xeE6d4e937f0493Fb461F28A75Cf591f1dBa8704E"

# Цвета
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
GRAY="\e[90m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

# Загрузка RPC_URL из файла .env-aztec-agent
if [ -f "/root/.env-aztec-agent" ]; then
    source /root/.env-aztec-agent
    if [ -z "$RPC_URL" ]; then
        echo -e "${RED}Error: RPC_URL not found in /root/.env-aztec-agent${RESET}"
        exit 1
    fi
else
    echo -e "${RED}Error: /root/.env-aztec-agent file not found${RESET}"
    exit 1
fi

declare -A STATUS_MAP=(
    [0]="NOT_IN_SET - The validator is not in the validator set"
    [1]="ACTIVE - The validator is currently in the validator set"
    [2]="INACTIVE - The validator is not active; possibly in withdrawal delay"
    [3]="READY_TO_EXIT - The validator has completed exit delay and can be exited"
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

echo -e "${BOLD}Fetching validator list from contract ${CYAN}$ROLLUP_ADDRESS${RESET}..."
VALIDATORS_RESPONSE=$(cast call $ROLLUP_ADDRESS "getAttesters()" --rpc-url $RPC_URL)
VALIDATORS_HEX=${VALIDATORS_RESPONSE:130}
VALIDATOR_COUNT=$(( ${#VALIDATORS_HEX} / 64 ))
VALIDATOR_ADDRESSES=()

for (( i=0; i<$VALIDATOR_COUNT; i++ )); do
    PART=${VALIDATORS_HEX:$((i*64)):64}
    ADDRESS_HEX=${PART:24:40}
    VALIDATOR_ADDRESSES+=("0x$ADDRESS_HEX")
done

echo -e "${GREEN}Found validators:${RESET} ${BOLD}${#VALIDATOR_ADDRESSES[@]}${RESET}"
echo "----------------------------------------"

# Временный файл для результатов
TMP_RESULTS=$(mktemp)
trap 'rm -f "$TMP_RESULTS"' EXIT

echo -e "${BOLD}Checking validators...${RESET}"

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

echo -e "\n${GREEN}${BOLD}Check completed.${RESET}"
echo "----------------------------------------"

declare -a RESULTS

# Обработка результатов
while IFS='|' read -r validator stake withdrawer proposer status; do
    if [[ "$stake" == "ERROR" ]]; then
        echo -e "${RED}Error fetching info for validator $validator${RESET}"
        continue
    fi

    status_text=${STATUS_MAP[$status]:-UNKNOWN}
    status_color=${STATUS_COLOR[$status]:-$RESET}

    RESULTS+=("$validator|$stake|$withdrawer|$proposer|$status|$status_text|$status_color")
done < "$TMP_RESULTS"

# Меню
while true; do
    echo ""
    echo -e "${BOLD}Select an action:${RESET}"
    echo -e "  ${CYAN}1.${RESET} Search and display data for a specific validator"
    echo -e "  ${CYAN}2.${RESET} Display the full validator list"
    echo -e "  ${CYAN}3.${RESET} Exit"
    read -p "Enter option number: " choice

    case $choice in
        1)
            read -p "Enter the validator address: " search_address
            found=false
            for line in "${RESULTS[@]}"; do
                IFS='|' read -r validator stake withdrawer proposer status status_text status_color <<< "$line"
                if [[ "${validator,,}" == "${search_address,,}" ]]; then
                    echo -e "\n${BOLD}Validator information:${RESET}\n"
                    echo -e "  ${BOLD}Address    :${RESET} $validator"
                    echo -e "  ${BOLD}Stake      :${RESET} $stake STK"
                    echo -e "  ${BOLD}Withdrawer :${RESET} $withdrawer"
                    echo -e "  ${BOLD}Proposer   :${RESET} $proposer"
                    echo -e "  ${BOLD}Status     :${RESET} ${status_color}$status ($status_text)${RESET}\n"
                    found=true
                    break
                fi
            done
            if ! $found; then
                echo -e "\n${RED}Validator with address $search_address not found.${RESET}"
            fi
            ;;
        2)
            echo ""
            for line in "${RESULTS[@]}"; do
                IFS='|' read -r validator stake withdrawer proposer status status_text status_color <<< "$line"
                echo -e "${BOLD}Validator:${RESET} $validator"
                echo -e "  ${BOLD}Stake      :${RESET} $stake STK"
                echo -e "  ${BOLD}Withdrawer :${RESET} $withdrawer"
                echo -e "  ${BOLD}Proposer   :${RESET} $proposer"
                echo -e "  ${BOLD}Status     :${RESET} ${status_color}$status ($status_text)${RESET}"
                echo -e ""
                echo "----------------------------------------"
            done
            ;;
        3)
            echo -e "\n${CYAN}Exiting.${RESET}"
            break
            ;;
        *)
            echo -e "\n${RED}Invalid input. Please choose 1, 2 or 3.${RESET}"
            ;;
    esac
done