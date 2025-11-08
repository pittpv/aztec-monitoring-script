#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
VIOLET='\033[0;35m'
NC='\033[0m' # No Color

SCRIPT_VERSION="2.2.1"

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
  echo -e "3. Türkçe"
  read -p "> " lang_choice

  case $lang_choice in
    1) LANG="en" ;;
    2) LANG="ru" ;;
    3) LANG="tr" ;;
    *) LANG="en" ;;
  esac

  # English translations
  TRANSLATIONS["en,welcome"]="Welcome to the Aztec node monitoring script"
  TRANSLATIONS["en,title"]="========= Main Menu ========="
  TRANSLATIONS["en,option1"]="1. Check container and node synchronization"
  TRANSLATIONS["en,option2"]="2. Install node monitoring agent with notifications"
  TRANSLATIONS["en,option3"]="3. Remove node monitoring agent and files"
  TRANSLATIONS["en,option4"]="4. Find rollupAddress in logs"
  TRANSLATIONS["en,option5"]="5. Find PeerID in logs"
  TRANSLATIONS["en,option6"]="6. Find governanceProposerPayload in logs"
  TRANSLATIONS["en,option7"]="7. Check Proven L2 Block and Sync Proof"
  TRANSLATIONS["en,option8"]="8. Change RPC URL"
  TRANSLATIONS["en,option9"]="9. Search for validator and check status"
  TRANSLATIONS["en,option10"]="10. View Aztec logs"
  TRANSLATIONS["en,option11"]="11. Install Aztec Node with Watchtower"
  TRANSLATIONS["en,option12"]="12. Delete Aztec node"
  TRANSLATIONS["en,option13"]="13. Stop Aztec node containers"
  TRANSLATIONS["en,option14"]="14. Start Aztec node containers"
  TRANSLATIONS["en,option15"]="15. Update Aztec node"
  TRANSLATIONS["en,option16"]="16. Downgrade Aztec node"
  TRANSLATIONS["en,option17"]="17. Check Aztec version"
  TRANSLATIONS["en,option18"]="18. Generate BLS keys from mnemonic"
  TRANSLATIONS["en,option19"]="19. Approve"
  TRANSLATIONS["en,option20"]="20. Stake"
  TRANSLATIONS["en,option0"]="0. Exit"
  TRANSLATIONS["en,bls_mnemonic_prompt"]="Enter mnemonic phrase (hidden input):"
  TRANSLATIONS["en,bls_wallet_count_prompt"]="Enter the number of wallets to generate. \nFor example: if your seed phrase contains only one wallet, insert the digit 1. \nIf your seed phrase contains several wallets for multiple validators, insert approximately the maximum number of the last wallet, for example 30, 50. \nIt is better to specify a larger number if you are not sure, the script will collect all keys and remove the extras."
  TRANSLATIONS["en,bls_invalid_number"]="Invalid number. Please enter a positive integer."
  TRANSLATIONS["en,bls_keystore_not_found"]="❌ keystore.json not found at /root/aztec/config/keystore.json"
  TRANSLATIONS["en,bls_fee_recipient_not_found"]="❌ feeRecipient not found in keystore.json"
  TRANSLATIONS["en,bls_generating_keys"]="🔑 Generating BLS keys..."
  TRANSLATIONS["en,bls_generation_success"]="✅ BLS keys generated successfully"
  TRANSLATIONS["en,bls_generation_failed"]="❌ Failed to generate BLS keys"
  TRANSLATIONS["en,bls_searching_matches"]="🔍 Searching for matching addresses in keystore..."
  TRANSLATIONS["en,bls_matches_found"]="✅ Found %d matching addresses"
  TRANSLATIONS["en,bls_no_matches"]="❌ No matching addresses found in keystore.json"
  TRANSLATIONS["en,bls_filtered_file_created"]="✅ Filtered BLS keys saved to: %s"
  TRANSLATIONS["en,bls_file_not_found"]="❌ Generated BLS file not found"
  TRANSLATIONS["en,staking_title"]="Validators Staking"
  TRANSLATIONS["en,staking_no_validators"]="No validators found in"
  TRANSLATIONS["en,staking_found_validators"]="Found %d validators"
  TRANSLATIONS["en,staking_processing"]="Processing validator %d of %d"
  TRANSLATIONS["en,staking_data_loaded"]="Validator data loaded"
  TRANSLATIONS["en,staking_trying_rpc"]="Trying RPC: %s"
  TRANSLATIONS["en,staking_command_prompt"]="Do you want to execute this command?"
  TRANSLATIONS["en,staking_execute_prompt"]="Enter 'y' to proceed, 's' to skip this validator, 'q' to quit"
  TRANSLATIONS["en,staking_executing"]="Executing command..."
  TRANSLATIONS["en,staking_success"]="Successfully staked validator %d using RPC: %s"
  TRANSLATIONS["en,staking_failed"]="Failed to stake validator %d using RPC: %s"
  TRANSLATIONS["en,staking_skipped_validator"]="Skipping validator %d"
  TRANSLATIONS["en,staking_cancelled"]="Operation cancelled by user"
  TRANSLATIONS["en,staking_skipped_rpc"]="Skipping this RPC provider"
  TRANSLATIONS["en,staking_all_failed"]="Failed to stake validator %d with all RPC providers"
  TRANSLATIONS["en,staking_completed"]="Staking process completed"
  TRANSLATIONS["en,file_not_found"]="%s not found at %s"
  TRANSLATIONS["en,contract_not_set"]="CONTRACT_ADDRESS is not set"
  TRANSLATIONS["en,using_contract_address"]="Using contract address: %s"
  TRANSLATIONS["en,staking_failed_private_key"]="Failed to get private key for validator %d"
  TRANSLATIONS["en,staking_failed_eth_address"]="Failed to get ETH address for validator %d"
  TRANSLATIONS["en,staking_failed_bls_key"]="Failed to get BLS private key for validator %d"
  TRANSLATIONS["en,eth_address"]="ETH Address"
  TRANSLATIONS["en,private_key"]="Private Key"
  TRANSLATIONS["en,bls_key"]="BLS Key"
  TRANSLATIONS["en,command_to_execute"]="Command to execute"
  TRANSLATIONS["en,trying_next_rpc"]="Trying next RPC provider..."
  TRANSLATIONS["en,continuing_next_validator"]="Continuing with next validator..."
  TRANSLATIONS["en,waiting_before_next_validator"]="Waiting 2 seconds before next validator"
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
  TRANSLATIONS["en,agent_added"]="✅ Agent added to systemd and will run every minute."
  TRANSLATIONS["en,agent_exists"]="ℹ️ Agent already exists in systemd."
  TRANSLATIONS["en,removing_agent"]="🗑 Removing agent and systemd task..."
  TRANSLATIONS["en,agent_removed"]="✅ Agent and systemd task removed."
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
  TRANSLATIONS["en,log_block_not_found"]="❌ No line with 'Downloaded L2 block' found in logs."
  TRANSLATIONS["en,log_block_extract_failed"]="❌ Failed to extract block number from the line:"
  TRANSLATIONS["en,log_block_number"]="📄 Latest block from logs:"
  TRANSLATIONS["en,log_behind_details"]="⚠️ Logs are behind. Latest block in logs: %s, from contract: %s"
  TRANSLATIONS["en,log_line_example"]="🔎 Example log line:"
  TRANSLATIONS["en,press_ctrlc"]="Press Ctrl+C to exit and return to the menu"
  TRANSLATIONS["en,logs_starting"]="Logs will start in 5 seconds..."
  TRANSLATIONS["en,return_main_menu"]="Returning to the main menu..."
  TRANSLATIONS["en,current_script_version"]="📌 Current script version:"
  TRANSLATIONS["en,new_version_avialable"]="🚀 New version available:"
  TRANSLATIONS["en,new_version_update"]="Please update your script"
  TRANSLATIONS["en,version_up_to_date"]="✅ You are using the latest version"
  TRANSLATIONS["en,agent_log_cleaned"]="✅ Log file cleaned."
  TRANSLATIONS["en,agent_container_not_found"]="❌ Aztec Container Not Found"
  TRANSLATIONS["en,agent_block_fetch_error"]="❌ Block Fetch Error"
  TRANSLATIONS["en,agent_no_block_in_logs"]="❌ No 'Downloaded L2 block' found"
  TRANSLATIONS["en,agent_failed_extract_block"]="❌ Failed to extract blockNumber"
  TRANSLATIONS["en,agent_node_behind"]="⚠️ Node is behind by %d blocks"
  TRANSLATIONS["en,agent_started"]="🤖 Aztec Monitoring Agent Started"
  TRANSLATIONS["en,agent_log_size_warning"]="⚠️ Log file cleaned due to size limit"
  TRANSLATIONS["en,agent_server_info"]="🌐 Server: %s"
  TRANSLATIONS["en,agent_file_info"]="🗃 File: %s"
  TRANSLATIONS["en,agent_size_info"]="📏 Previous size: %s bytes"
  TRANSLATIONS["en,agent_rpc_info"]="🔗 RPC: %s"
  TRANSLATIONS["en,agent_error_info"]="💬 Error: %s"
  TRANSLATIONS["en,agent_block_info"]="📦 Contract block: %s"
  TRANSLATIONS["en,agent_log_block_info"]="📝 Logs block: %s"
  TRANSLATIONS["en,agent_time_info"]="🕒 %s"
  TRANSLATIONS["en,agent_line_info"]="📋 Line: %s"
  TRANSLATIONS["en,agent_notifications_info"]="ℹ️ Notifications will be sent for issues"
  TRANSLATIONS["en,agent_node_synced"]="✅ Node synced (block %s)"
  TRANSLATIONS["en,chatid_linked"]="✅ ChatID successfully linked to Aztec Agent"
  TRANSLATIONS["en,invalid_token"]="Invalid Telegram bot token. Please try again."
  TRANSLATIONS["en,token_format"]="Token should be in format: 1234567890:ABCdefGHIJKlmNoPQRsTUVwxyZ"
  TRANSLATIONS["en,invalid_chatid"]="Invalid Telegram chat ID or the bot doesn't have access to this chat. Please try again."
  TRANSLATIONS["en,chatid_number"]="Chat ID must be a number (can start with - for group chats). Please try again."
  TRANSLATIONS["en,running_install_node"]="Running Install Aztec node script from GitHub..."
  TRANSLATIONS["en,failed_running_install_node"]="Failed to run Aztec node install script from GitHub..."
  TRANSLATIONS["en,failed_downloading_script"]="❌ Failed to download installation script"
  TRANSLATIONS["en,install_completed_successfully"]="✅ Installation completed successfully"
  TRANSLATIONS["en,logs_stopped_by_user"]="⚠ Log viewing stopped by user"
  TRANSLATIONS["en,installation_cancelled_by_user"]="✖ Installation cancelled by user"
  TRANSLATIONS["en,unknown_error_occurred"]="⚠ An unknown error occurred during installation"
  TRANSLATIONS["en,stop_method_prompt"]="Choose method to stop Aztec node (docker-compose / cli): "
  TRANSLATIONS["en,enter_compose_path"]="Enter full path to folder with docker-compose.yml (/root/your_path or ./your_path): "
  TRANSLATIONS["en,docker_stop_success"]="Containers stopped and docker path saved to .env-aztec-agent"
  TRANSLATIONS["en,no_aztec_screen"]="No active Aztec screen sessions found."
  TRANSLATIONS["en,cli_stop_success"]="Aztec CLI node stopped and session saved to .env-aztec-agent"
  TRANSLATIONS["en,invalid_path"]="Invalid path or docker-compose.yml not found."
  TRANSLATIONS["en,starting_node"]="Starting Aztec node..."
  TRANSLATIONS["en,node_started"]="Aztec node started."
  TRANSLATIONS["en,missing_compose"]="Path to docker-compose.yml not found in .env-aztec-agent."
  TRANSLATIONS["en,run_type_not_set"]="RUN_TYPE not set in configuration."
  TRANSLATIONS["en,confirm_cli_run"]="Do you want to run the container in CLI mode?"
  TRANSLATIONS["en,run_type_set_to_cli"]="RUN_TYPE set to CLI."
  TRANSLATIONS["en,run_aborted"]="Run aborted by user."
  TRANSLATIONS["en,checking_aztec_version"]="Checking Aztec version..."
  TRANSLATIONS["en,aztec_version_failed"]="Failed to retrieve aztec version."
  TRANSLATIONS["en,aztec_node_version"]="Aztec Node version:"
  TRANSLATIONS["en,critical_error_found"]="Critical error detected"
  TRANSLATIONS["en,error_prefix"]="ERROR:"
  TRANSLATIONS["en,solution_prefix"]="Solution:"
  TRANSLATIONS["en,notifications_prompt"]="Do you want to receive additional notifications?"
  TRANSLATIONS["en,notifications_option1"]="1. Critical errors only"
  TRANSLATIONS["en,notifications_option2"]="2. All notifications (including committee participation and validators activity)"
  TRANSLATIONS["en,notifications_debug_warning"]="DEBUG log level is required for committee and slot statistics notifications"
  TRANSLATIONS["en,notifications_input_error"]="Error: please enter 1 or 2"
  TRANSLATIONS["en,choose_option_prompt"]="Choose option"
  TRANSLATIONS["en,committee_selected"]="🎉 You've been selected for the committee"
  TRANSLATIONS["en,found_validators"]="Found validators in committee: %s"
  TRANSLATIONS["en,epoch_info"]="Epoch %s"
  TRANSLATIONS["en,block_built"]="✅ Block %s successfully built"
  TRANSLATIONS["en,slot_info"]="Slot %s"
  TRANSLATIONS["en,validators_prompt"]="Enter your validator addresses (comma separated, without spaces):"
  TRANSLATIONS["en,validators_format"]="Example: 0x123...,0x456...,0x789..."
  TRANSLATIONS["en,validators_empty"]="Error: Validators list cannot be empty"
  TRANSLATIONS["en,status_legend"]="Status Legend:"
  TRANSLATIONS["en,status_empty"]="⬜️ Empty slot"
  TRANSLATIONS["en,status_attestation_sent"]="🟩 Attestation sent"
  TRANSLATIONS["en,status_attestation_missed"]="🟥 Attestation missed"
  TRANSLATIONS["en,status_block_mined"]="🟦 Block mined"
  TRANSLATIONS["en,status_block_missed"]="🟨 Block missed"
  TRANSLATIONS["en,status_block_proposed"]="🟪 Block proposed"
  TRANSLATIONS["en,current_slot"]="Current slot: %s"
  TRANSLATIONS["en,agent_notifications_full_info"]="ℹ️ Notifications will be sent for issues, committee, slot stats"
  TRANSLATIONS["en,attestation_status"]="ℹ️ Slot stats"
  #find peerID
  TRANSLATIONS["en,fetching_peer_info"]="Fetching peer information from API..."
  TRANSLATIONS["en,peer_found"]="Peer ID found in logs"
  TRANSLATIONS["en,peer_not_in_list"]="Peer not found in the public peers list"
  TRANSLATIONS["en,peer_id_not_critical"]="The presence or absence of a Peer ID in Nethermind.io is not a critical parameter. The data may be outdated."
  TRANSLATIONS["en,searching_latest"]="Searching in current data..."
  TRANSLATIONS["en,searching_archive"]="Searching in archive data..."
  TRANSLATIONS["en,peer_found_archive"]="Note: This peer was found in archive data"
  #
  TRANSLATIONS["en,cli_quit_old_sessions"]="Closed existing session:"
  #install section
  TRANSLATIONS["en,delete_node"]="🗑️ Deleting Aztec Node..."
  TRANSLATIONS["en,delete_confirm"]="Are you sure you want to delete the Aztec node? This will stop containers and remove all data. (y/n) "
  TRANSLATIONS["en,node_deleted"]="✅ Aztec node successfully deleted"
  TRANSLATIONS["en,delete_canceled"]="✖ Node deletion canceled"
  TRANSLATIONS["en,delete_watchtower_confirm"]="Do you want to also delete Watchtower? (y/n) "
  TRANSLATIONS["en,watchtower_deleted"]="✅ Watchtower successfully deleted"
  TRANSLATIONS["en,watchtower_kept"]="✅ Watchtower kept intact"
  TRANSLATIONS["en,enter_tg_token"]="Enter Telegram bot token: "
  TRANSLATIONS["en,enter_tg_chat_id"]="Enter Telegram chat ID: "
  TRANSLATIONS["en,single_validator_mode"]="🔹 Single validator mode selected"
  TRANSLATIONS["en,multi_validator_mode"]="🔹 Multiple validators mode selected"
  TRANSLATIONS["en,enter_validator_keys"]="Enter validator private keys (comma-separated with 0x, up to 10): "
  TRANSLATIONS["en,enter_validator_key"]="Enter validator private key (with 0x): "
  TRANSLATIONS["en,enter_seq_publisher_key"]="Enter SEQ_PUBLISHER_PRIVATE_KEY (with 0x): "
  TRANSLATIONS["en,enter_yn"]="Please enter Y or N: "
  TRANSLATIONS["en,stopping_containers"]="Stopping containers..."
  TRANSLATIONS["en,removing_node_data"]="Removing Aztec node data..."
  TRANSLATIONS["en,stopping_watchtower"]="Stopping Watchtower..."
  TRANSLATIONS["en,removing_watchtower_data"]="Removing Watchtower data..."
  #update
  TRANSLATIONS["en,update_title"]="Updating Aztec node to the latest version"
  TRANSLATIONS["en,update_folder_error"]="Error: Folder $HOME/aztec does not exist"
  TRANSLATIONS["en,update_stopping"]="Stopping containers..."
  TRANSLATIONS["en,update_stop_error"]="Error stopping containers"
  TRANSLATIONS["en,update_pulling"]="Pulling latest aztecprotocol/aztec image..."
  TRANSLATIONS["en,update_pull_error"]="Error pulling image"
  TRANSLATIONS["en,update_starting"]="Starting updated node..."
  TRANSLATIONS["en,update_start_error"]="Error starting containers"
  TRANSLATIONS["en,update_success"]="Aztec node successfully updated to the latest version!"
  TRANSLATIONS["en,tag_check"]="Found tag: %s, replacing with latest"
  #downgrade
  TRANSLATIONS["en,downgrade_title"]="Downgrading Aztec node"
  TRANSLATIONS["en,downgrade_fetching"]="Fetching available versions list..."
  TRANSLATIONS["en,downgrade_fetch_error"]="Failed to get versions list"
  TRANSLATIONS["en,downgrade_available"]="Available versions (enter number):"
  TRANSLATIONS["en,downgrade_invalid_choice"]="Invalid choice, please try again"
  TRANSLATIONS["en,downgrade_selected"]="Selected version:"
  TRANSLATIONS["en,downgrade_folder_error"]="Error: Folder $HOME/aztec does not exist"
  TRANSLATIONS["en,downgrade_stopping"]="Stopping containers..."
  TRANSLATIONS["en,downgrade_stop_error"]="Error stopping containers"
  TRANSLATIONS["en,downgrade_pulling"]="Pulling aztecprotocol/aztec image:"
  TRANSLATIONS["en,downgrade_pull_error"]="Error pulling image"
  TRANSLATIONS["en,downgrade_updating"]="Updating configuration..."
  TRANSLATIONS["en,downgrade_update_error"]="Error updating docker-compose.yml"
  TRANSLATIONS["en,downgrade_starting"]="Starting node with version"
  TRANSLATIONS["en,downgrade_start_error"]="Error starting containers"
  TRANSLATIONS["en,downgrade_success"]="Aztec node successfully downgraded to version"
  #agent
  TRANSLATIONS["en,agent_systemd_added"]="Agent added (running every 37 seconds via systemd)"
  TRANSLATIONS["en,agent_timer_status"]="Timer status:"
  TRANSLATIONS["en,agent_timer_error"]="Error while creating systemd timer"
  TRANSLATIONS["en,removing_systemd_agent"]="Removing agent and systemd units..."
  TRANSLATIONS["en,agent_systemd_removed"]="Agent removed successfully"
  #version module
  TRANSLATIONS["en,update_changes"]="Changes in the update"
  TRANSLATIONS["en,installed"]="installed"
  TRANSLATIONS["en,not_installed"]="not installed"
  TRANSLATIONS["en,curl_cffi_not_installed"]="The Python package curl_cffi is not installed."
  TRANSLATIONS["en,install_curl_cffi_prompt"]="Do you want to install curl_cffi now? (Y/n)"
  TRANSLATIONS["en,installing_curl_cffi"]="Installing curl_cffi..."
  TRANSLATIONS["en,curl_cffi_optional"]="curl_cffi installation skipped (optional)."

  TRANSLATIONS["en,installing_foundry"]="Installing Foundry..."
  TRANSLATIONS["en,installing_curl"]="Installing curl..."
  TRANSLATIONS["en,installing_utils"]="Installing utilities (grep, sed)..."
  TRANSLATIONS["en,installing_jq"]="Installing jq..."
  TRANSLATIONS["en,installing_bc"]="Installing bc..."
  TRANSLATIONS["en,installing_python3"]="Installing Python3..."

  # Russian translations
  TRANSLATIONS["ru,welcome"]="Добро пожаловать в скрипт мониторинга ноды Aztec"
  TRANSLATIONS["ru,title"]="========= Главное меню ========="
  TRANSLATIONS["ru,option1"]="1. Проверить контейнер и синхронизацию ноды"
  TRANSLATIONS["ru,option2"]="2. Установить агент мониторинга ноды с уведомлениями"
  TRANSLATIONS["ru,option3"]="3. Удалить агент мониторинга и файлы"
  TRANSLATIONS["ru,option4"]="4. Найти адрес rollupAddress в логах"
  TRANSLATIONS["ru,option5"]="5. Найти PeerID в логах"
  TRANSLATIONS["ru,option6"]="6. Найти governanceProposerPayload в логах"
  TRANSLATIONS["ru,option7"]="7. Проверить Proven L2 блок и Sync Proof"
  TRANSLATIONS["ru,option8"]="8. Изменить RPC URL"
  TRANSLATIONS["ru,option9"]="9. Поиск валидатора и проверка статуса"
  TRANSLATIONS["ru,option10"]="10. Просмотреть логи Aztec"
  TRANSLATIONS["ru,option11"]="11. Установить Aztec ноду с Watchtower"
  TRANSLATIONS["ru,option12"]="12. Удалить ноду Aztec"
  TRANSLATIONS["ru,option13"]="13. Остановить контейнеры ноды Aztec"
  TRANSLATIONS["ru,option14"]="14. Запустить контейнеры ноды Aztec"
  TRANSLATIONS["ru,option15"]="15. Обновить ноду Aztec"
  TRANSLATIONS["ru,option16"]="16. Сделать даунгрейд ноды Aztec"
  TRANSLATIONS["ru,option17"]="17. Проверить версию ноды Aztec"
  TRANSLATIONS["ru,option18"]="18. Сгенерировать BLS ключи из мнемонической фразы"
  TRANSLATIONS["ru,option19"]="19. Аппрув"
  TRANSLATIONS["ru,option20"]="20. Стейк"
  TRANSLATIONS["ru,option0"]="0. Выход"
  TRANSLATIONS["ru,bls_mnemonic_prompt"]="Введите мнемоническую фразу (ввод скрыт):"
  TRANSLATIONS["ru,bls_wallet_count_prompt"]="Введите количество кошельков для генерации. \nНапример: если у вас в сид-фразе всего один кошелек, вставьте цифру 1. \nЕсли в вашей сид-фразе несколько кошельков для нескольких валидаторов, вставьте примернуо максимальную цифру последнего кошелька, например 30, 50. \nЛучше укажите больше, если не уверены, скрипт соберет все ключи и удалит лишние.):"
  TRANSLATIONS["ru,bls_invalid_number"]="Неверное число. Введите положительное целое число."
  TRANSLATIONS["ru,bls_keystore_not_found"]="❌ Файл keystore.json не найден в /root/aztec/config/keystore.json"
  TRANSLATIONS["ru,bls_fee_recipient_not_found"]="❌ feeRecipient не найден в keystore.json"
  TRANSLATIONS["ru,bls_generating_keys"]="🔑 Генерация BLS ключей..."
  TRANSLATIONS["ru,bls_generation_success"]="✅ BLS ключи успешно сгенерированы"
  TRANSLATIONS["ru,bls_generation_failed"]="❌ Не удалось сгенерировать BLS ключи"
  TRANSLATIONS["ru,bls_searching_matches"]="🔍 Поиск совпадающих адресов в keystore..."
  TRANSLATIONS["ru,bls_matches_found"]="✅ Найдено %d совпадающих адресов"
  TRANSLATIONS["ru,bls_no_matches"]="❌ Совпадающие адреса не найдены в keystore.json"
  TRANSLATIONS["ru,bls_filtered_file_created"]="✅ Отфильтрованные BLS ключи сохранены в: %s"
  TRANSLATIONS["ru,bls_file_not_found"]="❌ Сгенерированный BLS файл не найден"
  TRANSLATIONS["ru,staking_title"]="Стейкинг валидаторов"
  TRANSLATIONS["ru,staking_no_validators"]="Валидаторы не найдены"
  TRANSLATIONS["ru,staking_found_validators"]="Найдено %d валидаторов"
  TRANSLATIONS["ru,staking_processing"]="Обработка валидатора %d из %d"
  TRANSLATIONS["ru,staking_data_loaded"]="Данные валидатора загружены"
  TRANSLATIONS["ru,staking_trying_rpc"]="Пробуем RPC: %s"
  TRANSLATIONS["ru,staking_command_prompt"]="Выполнить эту команду?"
  TRANSLATIONS["ru,staking_execute_prompt"]="Введите 'y' чтобы продолжить, 's' чтобы пропустить валидатора, 'q' чтобы выйти"
  TRANSLATIONS["ru,staking_executing"]="Выполнение команды..."
  TRANSLATIONS["ru,staking_success"]="Успешно застейкан валидатор %d через RPC: %s"
  TRANSLATIONS["ru,staking_failed"]="Не удалось застейкать валидатор %d через RPC: %s"
  TRANSLATIONS["ru,staking_skipped_validator"]="Пропускаем валидатора %d"
  TRANSLATIONS["ru,staking_cancelled"]="Операция отменена пользователем"
  TRANSLATIONS["ru,staking_skipped_rpc"]="Пропускаем этого RPC провайдера"
  TRANSLATIONS["ru,staking_all_failed"]="Не удалось застейкать валидатор %d со всеми RPC провайдерами"
  TRANSLATIONS["ru,staking_completed"]="Процесс стейкинга завершен"
  TRANSLATIONS["ru,file_not_found"]="%s не найден в %s"
  TRANSLATIONS["ru,contract_not_set"]="CONTRACT_ADDRESS не установлен"
  TRANSLATIONS["ru,using_contract_address"]="Используется адрес контракта: %s"
  TRANSLATIONS["ru,staking_failed_private_key"]="Не удалось получить приватный ключ для валидатора %d"
  TRANSLATIONS["ru,staking_failed_eth_address"]="Не удалось получить ETH адрес для валидатора %d"
  TRANSLATIONS["ru,staking_failed_bls_key"]="Не удалось получить BLS приватный ключ для валидатора %d"
  TRANSLATIONS["ru,eth_address"]="ETH Адрес"
  TRANSLATIONS["ru,private_key"]="Приватный ключ"
  TRANSLATIONS["ru,bls_key"]="BLS ключ"
  TRANSLATIONS["ru,command_to_execute"]="Команда для выполнения"
  TRANSLATIONS["ru,trying_next_rpc"]="Пробуем следующий RPC провайдер..."
  TRANSLATIONS["ru,continuing_next_validator"]="Переходим к следующему валидатору..."
  TRANSLATIONS["ru,waiting_before_next_validator"]="Ожидание 2 секунды перед следующим валидатором"
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
  TRANSLATIONS["ru,agent_added"]="✅ Агент добавлен в systemd и будет выполняться каждую минуту."
  TRANSLATIONS["ru,agent_exists"]="ℹ️ Агент уже есть в systemd."
  TRANSLATIONS["ru,removing_agent"]="🗑 Удаление агента и systemd-задачи..."
  TRANSLATIONS["ru,agent_removed"]="✅ Агент и systemd-задача удалены."
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
  TRANSLATIONS["ru,log_block_not_found"]="❌ Не найдена строка с 'Downloaded L2 block' в логах."
  TRANSLATIONS["ru,log_block_extract_failed"]="❌ Не удалось извлечь номер блока из строки:"
  TRANSLATIONS["ru,log_block_number"]="📄 Последний блок из логов:"
  TRANSLATIONS["ru,log_behind_details"]="⚠️ Логи отстают. Последний блок из логов: %s, из контракта: %s"
  TRANSLATIONS["ru,log_line_example"]="🔎 Пример строки из логов:"
  TRANSLATIONS["ru,press_ctrlc"]="Нажмите Ctrl+C, чтобы выйти и вернуться в меню"
  TRANSLATIONS["ru,logs_starting"]="Логи запустятся через 5 секунд..."
  TRANSLATIONS["ru,return_main_menu"]="Возврат в главное меню..."
  TRANSLATIONS["ru,current_script_version"]="📌 Текущая версия скрипта:"
  TRANSLATIONS["ru,new_version_avialable"]="🚀 Доступна новая версия:"
  TRANSLATIONS["ru,new_version_update"]="Пожалуйста, обновите скрипт"
  TRANSLATIONS["ru,version_up_to_date"]="✅ Установлена актуальная версия"
  TRANSLATIONS["ru,agent_log_cleaned"]="✅ Лог-файл очищен."
  TRANSLATIONS["ru,agent_container_not_found"]="❌ Контейнер Aztec не найден"
  TRANSLATIONS["ru,agent_block_fetch_error"]="❌ Ошибка получения блока"
  TRANSLATIONS["ru,agent_no_block_in_logs"]="❌ Блок 'Downloaded L2 block' не найден"
  TRANSLATIONS["ru,agent_failed_extract_block"]="❌ Не удалось извлечь номер блока"
  TRANSLATIONS["ru,agent_node_behind"]="⚠️ Узел отстает на %d блоков"
  TRANSLATIONS["ru,agent_started"]="🤖 Агент мониторинга Aztec запущен"
  TRANSLATIONS["ru,agent_log_size_warning"]="⚠️ Лог-файл очищен из-за превышения размера"
  TRANSLATIONS["ru,agent_server_info"]="🌐 Сервер: %s"
  TRANSLATIONS["ru,agent_file_info"]="🗃 Файл: %s"
  TRANSLATIONS["ru,agent_size_info"]="📏 Предыдущий размер: %s байт"
  TRANSLATIONS["ru,agent_rpc_info"]="🔗 RPC: %s"
  TRANSLATIONS["ru,agent_error_info"]="💬 Ошибка: %s"
  TRANSLATIONS["ru,agent_block_info"]="📦 Блок в контракте: %s"
  TRANSLATIONS["ru,agent_log_block_info"]="📝 Блок в логах: %s"
  TRANSLATIONS["ru,agent_time_info"]="🕒 %s"
  TRANSLATIONS["ru,agent_line_info"]="📋 Строка: %s"
  TRANSLATIONS["ru,agent_notifications_info"]="ℹ️ Уведомления будут отправляться при проблемах"
  TRANSLATIONS["ru,agent_node_synced"]="✅ Узел синхронизирован (блок %s)"
  TRANSLATIONS["ru,chatid_linked"]="✅ ChatID успешно связан с Aztec Agent"
  TRANSLATIONS["ru,invalid_token"]="Неверный токен Telegram бота. Пожалуйста, попробуйте снова."
  TRANSLATIONS["ru,token_format"]="Токен должен быть в формате: 1234567890:ABCdefGHIJKlmNoPQRsTUVwxyZ"
  TRANSLATIONS["ru,invalid_chatid"]="Неверный Chat ID или бот не имеет доступа к этому чату. Пожалуйста, попробуйте снова."
  TRANSLATIONS["ru,chatid_number"]="Chat ID должен быть числом (может начинаться с - для групповых чатов). Пожалуйста, попробуйте снова."
  TRANSLATIONS["ru,running_install_node"]="Запуск скрипта установки Aztec node из GitHub..."
  TRANSLATIONS["ru,failed_running_install_node"]="Не удалось запустить скрипт установки узла Aztec из GitHub..."
  TRANSLATIONS["ru,failed_downloading_script"]="❌ Не удалось загрузить скрипт установки"
  TRANSLATIONS["ru,install_completed_successfully"]="✅ Установка успешно завершена"
  TRANSLATIONS["ru,logs_stopped_by_user"]="⚠ Просмотр логов остановлен пользователем"
  TRANSLATIONS["ru,installation_cancelled_by_user"]="✖ Установка отменена пользователем"
  TRANSLATIONS["ru,unknown_error_occurred"]="⚠ Произошла неизвестная ошибка при установке"
  TRANSLATIONS["ru,stop_method_prompt"]="Выберите способ остановки ноды Aztec (docker-compose / cli): "
  TRANSLATIONS["ru,enter_compose_path"]="Введите полный путь к папке с docker-compose.yml (/root/your_path or ./your_path): "
  TRANSLATIONS["ru,docker_stop_success"]="Контейнеры остановлены, путь сохранён в .env-aztec-agent"
  TRANSLATIONS["ru,no_aztec_screen"]="Активных screen-сессий с Aztec не найдено."
  TRANSLATIONS["ru,cli_stop_success"]="Нода Aztec CLI остановлена, сессия сохранена в .env-aztec-agent"
  TRANSLATIONS["ru,invalid_path"]="Неверный путь или файл docker-compose.yml не найден."
  TRANSLATIONS["ru,starting_node"]="Запуск ноды Aztec..."
  TRANSLATIONS["ru,node_started"]="Нода Aztec запущена."
  TRANSLATIONS["ru,missing_compose"]="Путь к docker-compose.yml не найден в .env-aztec-agent."
  TRANSLATIONS["ru,run_type_not_set"]="RUN_TYPE не задан в конфигурации."
  TRANSLATIONS["ru,confirm_cli_run"]="Вы хотите запустить контейнер в CLI режиме?"
  TRANSLATIONS["ru,run_type_set_to_cli"]="RUN_TYPE установлен в CLI."
  TRANSLATIONS["ru,run_aborted"]="Запуск отменен пользователем."
  TRANSLATIONS["ru,checking_aztec_version"]="Проверка версии Aztec..."
  TRANSLATIONS["ru,aztec_version_failed"]="Не удалось получить версию aztec."
  TRANSLATIONS["ru,aztec_node_version"]="Версия ноды Aztec:"
  TRANSLATIONS["ru,critical_error_found"]="Найдена критическая ошибка"
  TRANSLATIONS["ru,error_prefix"]="ОШИБКА:"
  TRANSLATIONS["ru,solution_prefix"]="Решение:"
  TRANSLATIONS["ru,notifications_prompt"]="Хотите получать дополнительные уведомления?"
  TRANSLATIONS["ru,notifications_option1"]="1. Только критические ошибки"
  TRANSLATIONS["ru,notifications_option2"]="2. Все уведомления (включая попадание в комитет и активность валидатора)"
  TRANSLATIONS["ru,notifications_debug_warning"]="Для получения уведомлений о попадании в комитет и статистике слотов требуется уровень логов DEBUG"
  TRANSLATIONS["ru,notifications_input_error"]="Ошибка: введите 1 или 2"
  TRANSLATIONS["ru,choose_option_prompt"]="Выберите вариант"
  TRANSLATIONS["ru,committee_selected"]="🎉 Тебя выбрали в комитет"
  TRANSLATIONS["ru,found_validators"]="Найдены валидаторы в комитете: %s"
  TRANSLATIONS["ru,epoch_info"]="Эпоха %s"
  TRANSLATIONS["ru,block_built"]="✅ Блок %s успешно построен"
  TRANSLATIONS["ru,slot_info"]="Слот %s"
  TRANSLATIONS["ru,validators_prompt"]="Введите адреса валидаторов (через запятую, без пробелов):"
  TRANSLATIONS["ru,validators_format"]="Пример: 0x123...,0x456...,0x789..."
  TRANSLATIONS["ru,validators_empty"]="Ошибка: Список валидаторов не может быть пустым"
  TRANSLATIONS["ru,status_legend"]="Легенда статусов:"
  TRANSLATIONS["ru,status_empty"]="⬜️ Пустой слот"
  TRANSLATIONS["ru,status_attestation_sent"]="🟩 Аттестация отправлена"
  TRANSLATIONS["ru,status_attestation_missed"]="🟥 Аттестация пропущена"
  TRANSLATIONS["ru,status_block_mined"]="🟦 Блок добыт"
  TRANSLATIONS["ru,status_block_missed"]="🟨 Блок пропущен"
  TRANSLATIONS["ru,status_block_proposed"]="🟪 Блок предложен"
  TRANSLATIONS["ru,current_slot"]="Текущий слот: %s"
  TRANSLATIONS["ru,agent_notifications_full_info"]="ℹ️ Уведомления будут отправляться при проблемах, выборе в комитет, статистике слотов"
  TRANSLATIONS["ru,attestation_status"]="ℹ️ Статистика слота"
  #peerID
  TRANSLATIONS["ru,fetching_peer_info"]="Получение информации о пире из API..."
  TRANSLATIONS["ru,peer_found"]="Peer ID найден в логах"
  TRANSLATIONS["ru,peer_not_in_list"]="Пир не найден в публичном списке"
  TRANSLATIONS["ru,peer_id_not_critical"]="Наличие или отсутствие Peer ID в Nethermind.io не является критично важным параметром. Данные могут быть неактуальными."
  TRANSLATIONS["ru,searching_latest"]="Поиск в актуальных данных..."
  TRANSLATIONS["ru,searching_archive"]="Поиск в архивных данных..."
  TRANSLATIONS["ru,peer_found_archive"]="Примечание: Этот пир был найден в архивных данных"
  #
  TRANSLATIONS["ru,cli_quit_old_sessions"]="Закрыта старая сессия:"
  #delete section
  TRANSLATIONS["ru,delete_node"]="🗑️ Удаление ноды Aztec..."
  TRANSLATIONS["ru,delete_confirm"]="Вы уверены, что хотите удалить ноду Aztec? Это остановит контейнеры и удалит все данные. (y/n) "
  TRANSLATIONS["ru,node_deleted"]="✅ Нода Aztec успешно удалена"
  TRANSLATIONS["ru,delete_canceled"]="✖ Удаление ноды отменено"
  TRANSLATIONS["ru,delete_watchtower_confirm"]="Хотите также удалить Watchtower? (y/n) "
  TRANSLATIONS["ru,watchtower_deleted"]="✅ Watchtower успешно удален"
  TRANSLATIONS["ru,watchtower_kept"]="✅ Watchtower оставлен без изменений"
  TRANSLATIONS["ru,enter_tg_token"]="Введите токен Telegram бота: "
  TRANSLATIONS["ru,enter_tg_chat_id"]="Введите ID Telegram чата: "
  TRANSLATIONS["ru,single_validator_mode"]="🔹 Выбран режим одного валидатора"
  TRANSLATIONS["ru,multi_validator_mode"]="🔹 Выбран режим нескольких валидаторов"
  TRANSLATIONS["ru,enter_validator_keys"]="Введите приватные ключи валидаторов (c 0x через запятую, до 10): "
  TRANSLATIONS["ru,enter_validator_key"]="Введите приватный ключ валидатора (с 0x): "
  TRANSLATIONS["ru,enter_seq_publisher_key"]="Введите SEQ_PUBLISHER_PRIVATE_KEY (с 0x): "
  TRANSLATIONS["ru,enter_yn"]="Пожалуйста, введите Y или N: "
  TRANSLATIONS["ru,stopping_containers"]="Остановка контейнеров..."
  TRANSLATIONS["ru,removing_node_data"]="Удаление данных ноды Aztec..."
  TRANSLATIONS["ru,stopping_watchtower"]="Остановка Watchtower..."
  TRANSLATIONS["ru,removing_watchtower_data"]="Удаление данных Watchtower..."
  #update
  TRANSLATIONS["ru,update_title"]="Обновление ноды Aztec до последней версии"
  TRANSLATIONS["ru,update_folder_error"]="Ошибка: Папка $HOME/aztec не существует"
  TRANSLATIONS["ru,update_stopping"]="Остановка контейнеров..."
  TRANSLATIONS["ru,update_stop_error"]="Ошибка при остановке контейнеров"
  TRANSLATIONS["ru,update_pulling"]="Загрузка последнего образа aztecprotocol/aztec..."
  TRANSLATIONS["ru,update_pull_error"]="Ошибка при загрузке образа"
  TRANSLATIONS["ru,update_starting"]="Запуск обновленной ноды..."
  TRANSLATIONS["ru,update_start_error"]="Ошибка при запуске контейнеров"
  TRANSLATIONS["ru,update_success"]="Нода Aztec успешно обновлена до последней версии!"
  TRANSLATIONS["ru,tag_check"]="Обнаружен тег: %s, заменяем на latest"
  #downgrade
  TRANSLATIONS["ru,downgrade_title"]="Даунгрейд ноды Aztec"
  TRANSLATIONS["ru,downgrade_fetching"]="Получение списка доступных версий..."
  TRANSLATIONS["ru,downgrade_fetch_error"]="Не удалось получить список версий"
  TRANSLATIONS["ru,downgrade_available"]="Доступные версии (введите номер):"
  TRANSLATIONS["ru,downgrade_invalid_choice"]="Неверный выбор, попробуйте еще раз"
  TRANSLATIONS["ru,downgrade_selected"]="Выбрана версия:"
  TRANSLATIONS["ru,downgrade_folder_error"]="Ошибка: Папка $HOME/aztec не существует"
  TRANSLATIONS["ru,downgrade_stopping"]="Остановка контейнеров..."
  TRANSLATIONS["ru,downgrade_stop_error"]="Ошибка при остановке контейнеров"
  TRANSLATIONS["ru,downgrade_pulling"]="Загрузка образа aztecprotocol/aztec:"
  TRANSLATIONS["ru,downgrade_pull_error"]="Ошибка при загрузке образа"
  TRANSLATIONS["ru,downgrade_updating"]="Обновление конфигурации..."
  TRANSLATIONS["ru,downgrade_update_error"]="Ошибка при обновлении docker-compose.yml"
  TRANSLATIONS["ru,downgrade_starting"]="Запуск ноды с версией"
  TRANSLATIONS["ru,downgrade_start_error"]="Ошибка при запуске контейнеров"
  TRANSLATIONS["ru,downgrade_success"]="Нода Aztec успешно даунгрейднута до версии"
  #agent
  TRANSLATIONS["ru,agent_systemd_added"]="Агент добавлен (запуск каждые 37 секунд через systemd)"
  TRANSLATIONS["ru,agent_timer_status"]="Статус таймера:"
  TRANSLATIONS["ru,agent_timer_error"]="Ошибка при создании systemd таймера"
  TRANSLATIONS["ru,removing_systemd_agent"]="Удаление агента и systemd unit-файлов..."
  TRANSLATIONS["ru,agent_systemd_removed"]="Агент успешно удалён"
  #version module
  TRANSLATIONS["ru,update_changes"]="Изменения в обновлении"
  TRANSLATIONS["ru,installed"]="установлен"
  TRANSLATIONS["ru,not_installed"]="не установлен"
  TRANSLATIONS["ru,curl_cffi_not_installed"]="Python-пакет curl_cffi не установлен."
  TRANSLATIONS["ru,install_curl_cffi_prompt"]="Хотите установить curl_cffi сейчас? (Y/n)"
  TRANSLATIONS["ru,installing_curl_cffi"]="Устанавливается curl_cffi..."
  TRANSLATIONS["ru,curl_cffi_optional"]="Установка curl_cffi пропущена (необязательно)."

  TRANSLATIONS["ru,installing_foundry"]="Устанавливается Foundry..."
  TRANSLATIONS["ru,installing_curl"]="Устанавливается curl..."
  TRANSLATIONS["ru,installing_utils"]="Устанавливаются утилиты (grep, sed)..."
  TRANSLATIONS["ru,installing_jq"]="Устанавливается jq..."
  TRANSLATIONS["ru,installing_bc"]="Устанавливается bc..."
  TRANSLATIONS["ru,installing_python3"]="Устанавливается Python3..."

  # Turkish translations
  TRANSLATIONS["tr,welcome"]="Aztec düğüm izleme betiğine hoş geldiniz"
  TRANSLATIONS["tr,title"]="========= Ana Menü ========="
  TRANSLATIONS["tr,option1"]="1. Konteyner ve düğüm senkronizasyonunun kontrol et"
  TRANSLATIONS["tr,option2"]="2. Bildirimlerle düğüm izleme aracısını yükleyin"
  TRANSLATIONS["tr,option3"]="3. Düğüm izleme aracısını ve dosyalarını kaldırın"
  TRANSLATIONS["tr,option4"]="4. Loglarda rollupAddress bul"
  TRANSLATIONS["tr,option5"]="5. Loglarda PeerID bul"
  TRANSLATIONS["tr,option6"]="6. Loglarda governanceProposerPayload bul"
  TRANSLATIONS["tr,option7"]="7. Kanıtlanmış L2 Bloğunu ve Sync Proof'u Kontrol Et"
  TRANSLATIONS["tr,option8"]="8. RPC URL'sini değiştir"
  TRANSLATIONS["tr,option9"]="9. Validator ara ve durumunu kontrol et"
  TRANSLATIONS["tr,option10"]="10. Aztec loglarını görüntüle"
  TRANSLATIONS["tr,option11"]="11. Watchtower ile birlikte Aztec Node Kurulumu"
  TRANSLATIONS["tr,option12"]="12. Aztec düğümünü sil"
  TRANSLATIONS["tr,option13"]="13. Aztec düğüm konteynerlerini durdur"
  TRANSLATIONS["tr,option14"]="14. Aztec düğüm konteynerlerini başlat"
  TRANSLATIONS["tr,option15"]="15. Aztec düğümünü güncelle"
  TRANSLATIONS["tr,option16"]="16. Aztec düğümünü eski sürüme düşür"
  TRANSLATIONS["tr,option17"]="17. Aztek sürümünü kontrol edin"
  TRANSLATIONS["tr,option18"]="18. Anımsatıcı ifadeden BLS anahtarları oluştur"
  TRANSLATIONS["tr,option19"]="19. Approve"
  TRANSLATIONS["tr,option20"]="20. Stake"
  TRANSLATIONS["tr,option0"]="0. Çıkış"
  TRANSLATIONS["tr,bls_mnemonic_prompt"]="Anımsatıcı ifadeyi girin (gizli giriş):"
  TRANSLATIONS["tr,bls_wallet_count_prompt"]="Oluşturulacak cüzdan sayısını girin. \nÖrneğin: seed ifadenizde yalnızca bir cüzdan varsa, 1 rakamını girin. \nSeed ifadenizde birden fazla doğrulayıcı için birden fazla cüzdan varsa, son cüzdanın yaklaşık en yüksek numarasını girin, örneğin 30, 50. \nEmin değilseniz daha büyük bir sayı belirtmeniz daha iyidir, betik tüm anahtarları toplayacak ve fazlalıkları silecektir."
  TRANSLATIONS["tr,bls_invalid_number"]="Geçersiz sayı. Lütfen pozitif bir tam sayı girin."
  TRANSLATIONS["tr,bls_keystore_not_found"]="❌ /root/aztec/config/keystore.json konumunda keystore.json bulunamadı"
  TRANSLATIONS["tr,bls_fee_recipient_not_found"]="❌ keystore.json dosyasında feeRecipient bulunamadı"
  TRANSLATIONS["tr,bls_generating_keys"]="🔑 BLS anahtarları oluşturuluyor..."
  TRANSLATIONS["tr,bls_generation_success"]="✅ BLS anahtarları başarıyla oluşturuldu"
  TRANSLATIONS["tr,bls_generation_failed"]="❌ BLS anahtarları oluşturulamadı"
  TRANSLATIONS["tr,bls_searching_matches"]="🔍 Keystore'da eşleşen adresler aranıyor..."
  TRANSLATIONS["tr,bls_matches_found"]="✅ %d eşleşen adres bulundu"
  TRANSLATIONS["tr,bls_no_matches"]="❌ Keystore.json dosyasında eşleşen adres bulunamadı"
  TRANSLATIONS["tr,bls_filtered_file_created"]="✅ Filtrelenmiş BLS anahtarları şuraya kaydedildi: %s"
  TRANSLATIONS["tr,bls_file_not_found"]="❌ Oluşturulan BLS dosyası bulunamadı"
  TRANSLATIONS["tr,staking_title"]="Validator Staking"
  TRANSLATIONS["tr,staking_no_validators"]="Validator bulunamadı"
  TRANSLATIONS["tr,staking_found_validators"]="%d validator bulundu"
  TRANSLATIONS["tr,staking_processing"]="Validator %d/%d işleniyor"
  TRANSLATIONS["tr,staking_data_loaded"]="Validator verileri yüklendi"
  TRANSLATIONS["tr,staking_trying_rpc"]="RPC deneniyor: %s"
  TRANSLATIONS["tr,staking_command_prompt"]="Bu komutu çalıştırmak istiyor musunuz?"
  TRANSLATIONS["tr,staking_execute_prompt"]="Devam etmek için 'y', bu validatoru atlamak için 's', çıkmak için 'q' girin"
  TRANSLATIONS["tr,staking_executing"]="Komut çalıştırılıyor..."
  TRANSLATIONS["tr,staking_success"]="Validator %d başarıyla stake edildi, RPC: %s"
  TRANSLATIONS["tr,staking_failed"]="Validator %d stake edilemedi, RPC: %s"
  TRANSLATIONS["tr,staking_skipped_validator"]="Validator %d atlanıyor"
  TRANSLATIONS["tr,staking_cancelled"]="İşlem kullanıcı tarafından iptal edildi"
  TRANSLATIONS["tr,staking_skipped_rpc"]="Bu RPC sağlayıcısı atlanıyor"
  TRANSLATIONS["tr,staking_all_failed"]="Validator %d tüm RPC sağlayıcıları ile stake edilemedi"
  TRANSLATIONS["tr,staking_completed"]="Staking işlemi tamamlandı"
  TRANSLATIONS["tr,file_not_found"]="%s, %s konumunda bulunamadı"
  TRANSLATIONS["tr,contract_not_set"]="CONTRACT_ADDRESS ayarlanmamış"
  TRANSLATIONS["tr,using_contract_address"]="Kontrat adresi kullanılıyor: %s"
  TRANSLATIONS["tr,staking_failed_private_key"]="%d. doğrulayıcı için özel anahtar alınamadı"
  TRANSLATIONS["tr,staking_failed_eth_address"]="%d. doğrulayıcı için ETH adresi alınamadı"
  TRANSLATIONS["tr,staking_failed_bls_key"]="%d. doğrulayıcı için BLS özel anahtarı alınamadı"
  TRANSLATIONS["tr,eth_address"]="ETH Adresi"
  TRANSLATIONS["tr,private_key"]="Özel Anahtar"
  TRANSLATIONS["tr,bls_key"]="BLS Anahtarı"
  TRANSLATIONS["tr,command_to_execute"]="Yürütülecek komut"
  TRANSLATIONS["tr,trying_next_rpc"]="Sonraki RPC sağlayıcı deneniyor..."
  TRANSLATIONS["tr,continuing_next_validator"]="Sonraki doğrulayıcıya devam ediliyor..."
  TRANSLATIONS["tr,waiting_before_next_validator"]="Sonraki doğrulayıcıdan önce 2 saniye bekleniyor"
  TRANSLATIONS["tr,rpc_change_prompt"]="Yeni RPC URL'sini girin:"
  TRANSLATIONS["tr,rpc_change_success"]="✅ RPC URL başarıyla güncellendi"
  TRANSLATIONS["tr,choose_option"]="Seçenek seçin:"
  TRANSLATIONS["tr,checking_deps"]="🔍 Gerekli bileşenler kontrol ediliyor:"
  TRANSLATIONS["tr,missing_tools"]="Gerekli bileşenler eksik:"
  TRANSLATIONS["tr,install_prompt"]="Şimdi yüklemek istiyor musunuz? (Y/n):"
  TRANSLATIONS["tr,missing_required"]="⚠️ Betik, gerekli bileşenler olmadan çalışamaz. Çıkılıyor."
  TRANSLATIONS["tr,rpc_prompt"]="RPC URL'sini girin:"
  TRANSLATIONS["tr,env_created"]="✅ RPC URL'si ile .env dosyası oluşturuldu"
  TRANSLATIONS["tr,env_exists"]="✅ Mevcut .env dosyası kullanılıyor, RPC URL:"
  TRANSLATIONS["tr,search_container"]="🔍 'aztec' konteyneri aranıyor..."
  TRANSLATIONS["tr,container_not_found"]="❌ 'aztec' konteyneri bulunamadı."
  TRANSLATIONS["tr,container_found"]="✅ Konteyner bulundu:"
  TRANSLATIONS["tr,get_block"]="🔗 Kontraktan mevcut blok alınıyor..."
  TRANSLATIONS["tr,block_error"]="❌ Hata: Blok numarası alınamadı. RPC veya kontratı kontrol edin."
  TRANSLATIONS["tr,current_block"]="📦 Mevcut blok numarası:"
  TRANSLATIONS["tr,node_ok"]="✅ Düğüm çalışıyor ve mevcut bloğu işliyor"
  TRANSLATIONS["tr,node_behind"]="⚠️ Mevcut blok loglarda bulunamadı. Düğüm geride olabilir."
  TRANSLATIONS["tr,search_rollup"]="🔍 'aztec' konteyner loglarında rollupAddress aranıyor..."
  TRANSLATIONS["tr,rollup_found"]="✅ Mevcut rollupAddress:"
  TRANSLATIONS["tr,rollup_not_found"]="❌ Loglarda rollupAddress bulunamadı."
  TRANSLATIONS["tr,search_peer"]="🔍 'aztec' konteyner loglarında PeerID aranıyor..."
  TRANSLATIONS["tr,peer_not_found"]="❌ Loglarda PeerID bulunamadı."
  TRANSLATIONS["tr,search_gov"]="🔍 'aztec' konteyner loglarında governanceProposerPayload aranıyor..."
  TRANSLATIONS["tr,gov_found"]="Bulunan governanceProposerPayload değerleri:"
  TRANSLATIONS["tr,gov_not_found"]="❌ governanceProposerPayload bulunamadı."
  TRANSLATIONS["tr,gov_changed"]="🛑 GovernanceProposerPayload değişikliği tespit edildi!"
  TRANSLATIONS["tr,gov_was"]="⚠️ Önceki:"
  TRANSLATIONS["tr,gov_now"]="Şimdi:"
  TRANSLATIONS["tr,gov_no_changes"]="✅ Değişiklik tespit edilmedi."
  TRANSLATIONS["tr,token_prompt"]="Telegram Bot Token'ını girin:"
  TRANSLATIONS["tr,chatid_prompt"]="Telegram Chat ID'yi girin:"
  TRANSLATIONS["tr,agent_added"]="✅ Aracı systemd'a eklendi ve her dakika çalışacak."
  TRANSLATIONS["tr,agent_exists"]="ℹ️ Aracı zaten systemd'da mevcut."
  TRANSLATIONS["tr,removing_agent"]="🗑 Aracı ve systemd görevi kaldırılıyor..."
  TRANSLATIONS["tr,agent_removed"]="✅ Aracı ve systemd görevi kaldırıldı."
  TRANSLATIONS["tr,goodbye"]="👋 Güle güle."
  TRANSLATIONS["tr,invalid_choice"]="❌ Geçersiz seçim. Tekrar deneyin."
  TRANSLATIONS["tr,searching"]="Aranıyor..."
  TRANSLATIONS["tr,get_proven_block"]="🔍 Kanıtlanmış L2 blok numarası alınıyor..."
  TRANSLATIONS["tr,proven_block_found"]="✅ Kanıtlanmış L2 Blok Numarası:"
  TRANSLATIONS["tr,proven_block_error"]="❌ Kanıtlanmış L2 blok numarası alınamadı."
  TRANSLATIONS["tr,get_sync_proof"]="🔍 Sync Proof alınıyor..."
  TRANSLATIONS["tr,sync_proof_found"]="✅ Sync Proof:"
  TRANSLATIONS["tr,sync_proof_error"]="❌ Sync Proof alınamadı."
  TRANSLATIONS["tr,token_check"]="🔍 Telegram token ve ChatID kontrol ediliyor..."
  TRANSLATIONS["tr,token_valid"]="✅ Telegram token geçerli"
  TRANSLATIONS["tr,token_invalid"]="❌ Geçersiz Telegram token"
  TRANSLATIONS["tr,chatid_valid"]="✅ ChatID geçerli ve bota erişim var"
  TRANSLATIONS["tr,chatid_invalid"]="❌ Geçersiz ChatID veya bota erişim yok"
  TRANSLATIONS["tr,agent_created"]="✅ Aracı başarıyla oluşturuldu ve yapılandırıldı!"
  TRANSLATIONS["tr,running_validator_script"]="GitHub'dan Check Validator betiği çalıştırılıyor..."
  TRANSLATIONS["tr,failed_run_validator"]="Check Validator betiği çalıştırılamadı."
  TRANSLATIONS["tr,enter_aztec_port_prompt"]="Aztec düğüm port numarasını girin"
  TRANSLATIONS["tr,port_saved_successfully"]="✅ Port başarıyla kaydedildi"
  TRANSLATIONS["tr,checking_port"]="Port kontrol ediliyor"
  TRANSLATIONS["tr,port_not_available"]="Aztec portu şurada mevcut değil:"
  TRANSLATIONS["tr,current_aztec_port"]="Mevcut Aztec düğüm portu:"
  TRANSLATIONS["tr,log_block_not_found"]="❌ Loglarda 'Downloaded L2 block' içeren satır bulunamadı."
  TRANSLATIONS["tr,log_block_extract_failed"]="❌ Blok numarası satırdan çıkarılamadı:"
  TRANSLATIONS["tr,log_block_number"]="📄 Loglardaki son blok:"
  TRANSLATIONS["tr,log_behind_details"]="⚠️ Loglar geride. Loglardaki son blok: %s, kontraktaki: %s"
  TRANSLATIONS["tr,log_line_example"]="🔎 Örnek log satırı:"
  TRANSLATIONS["tr,press_ctrlc"]="Menüye dönmek için Ctrl+C'ye basın"
  TRANSLATIONS["tr,logs_starting"]="Loglar 5 saniye içinde başlayacak..."
  TRANSLATIONS["tr,return_main_menu"]="Ana menüye dönülüyor..."
  TRANSLATIONS["tr,current_script_version"]="📌 Mevcut betik versiyonu:"
  TRANSLATIONS["tr,new_version_avialable"]="🚀 Yeni versiyon mevcut:"
  TRANSLATIONS["tr,new_version_update"]="Lütfen betiğinizi güncelleyin"
  TRANSLATIONS["tr,version_up_to_date"]="✅ En son versiyonu kullanıyorsunuz"
  TRANSLATIONS["tr,agent_log_cleaned"]="✅ Log dosyası temizlendi."
  TRANSLATIONS["tr,agent_container_not_found"]="❌ Aztec Konteyneri Bulunamadı"
  TRANSLATIONS["tr,agent_block_fetch_error"]="❌ Blok Alma Hatası"
  TRANSLATIONS["tr,agent_no_block_in_logs"]="❌ 'Downloaded L2 block' bulunamadı"
  TRANSLATIONS["tr,agent_failed_extract_block"]="❌ Blok numarası çıkarılamadı"
  TRANSLATIONS["tr,agent_node_behind"]="⚠️ Düğüm %d blok geride"
  TRANSLATIONS["tr,agent_started"]="🤖 Aztec İzleme Aracı Başlatıldı"
  TRANSLATIONS["tr,agent_log_size_warning"]="⚠️ Boyut sınırı nedeniyle log dosyası temizlendi"
  TRANSLATIONS["tr,agent_server_info"]="🌐 Sunucu: %s"
  TRANSLATIONS["tr,agent_file_info"]="🗃 Dosya: %s"
  TRANSLATIONS["tr,agent_size_info"]="📏 Önceki boyut: %s bayt"
  TRANSLATIONS["tr,agent_rpc_info"]="🔗 RPC: %s"
  TRANSLATIONS["tr,agent_error_info"]="💬 Hata: %s"
  TRANSLATIONS["tr,agent_block_info"]="📦 Kontrakt blok: %s"
  TRANSLATIONS["tr,agent_log_block_info"]="📝 Log blok: %s"
  TRANSLATIONS["tr,agent_time_info"]="🕒 %s"
  TRANSLATIONS["tr,agent_line_info"]="📋 Satır: %s"
  TRANSLATIONS["tr,agent_notifications_info"]="ℹ️ Sorunlar için bildirimler gönderilecek"
  TRANSLATIONS["tr,agent_node_synced"]="✅ Düğüm senkronize (blok %s)"
  TRANSLATIONS["tr,chatid_linked"]="✅ ChatID başarıyla Aztec Aracı'na bağlandı"
  TRANSLATIONS["tr,invalid_token"]="Geçersiz Telegram bot tokenı. Lütfen tekrar deneyin."
  TRANSLATIONS["tr,token_format"]="Token formatı: 1234567890:ABCdefGHIJKlmNoPQRsTUVwxyZ"
  TRANSLATIONS["tr,invalid_chatid"]="Geçersiz Telegram chat ID veya botun bu sohbete erişimi yok. Lütfen tekrar deneyin."
  TRANSLATIONS["tr,chatid_number"]="Chat ID bir sayı olmalıdır (grup sohbetleri için - ile başlayabilir). Lütfen tekrar deneyin."
  TRANSLATIONS["tr,running_install_node"]="GitHub'dan Aztec node kurulum betiği çalıştırılıyor..."
  TRANSLATIONS["tr,failed_running_install_node"]="GitHub'dan Aztec düğüm yükleme betiği çalıştırılamadı..."
  TRANSLATIONS["tr,failed_downloading_script"]="❌ Kurulum betiği indirilemedi"
  TRANSLATIONS["tr,install_completed_successfully"]="✅ Kurulum başarıyla tamamlandı"
  TRANSLATIONS["tr,logs_stopped_by_user"]="⚠ Log görüntüleme kullanıcı tarafından durduruldu"
  TRANSLATIONS["tr,installation_cancelled_by_user"]="✖ Kurulum kullanıcı tarafından iptal edildi"
  TRANSLATIONS["tr,unknown_error_occurred"]="⚠ Kurulum sırasında bilinmeyen bir hata oluştu"
  TRANSLATIONS["tr,stop_method_prompt"]="Aztec düğümünü durdurma yöntemi seçin (docker-compose / cli): "
  TRANSLATIONS["tr,enter_compose_path"]="docker-compose.yml dosyasının bulunduğu klasörün tam yolunu girin  (/root/your_path veya ./your_path): "
  TRANSLATIONS["tr,docker_stop_success"]="Konteynerler durduruldu ve yol .env-aztec-agent dosyasına kaydedildi"
  TRANSLATIONS["tr,no_aztec_screen"]="Aktif Aztec screen oturumu bulunamadı."
  TRANSLATIONS["tr,cli_stop_success"]="Aztec CLI düğümü durduruldu ve oturum .env-aztec-agent dosyasına kaydedildi"
  TRANSLATIONS["tr,invalid_path"]="Geçersiz yol veya docker-compose.yml dosyası bulunamadı."
  TRANSLATIONS["tr,starting_node"]="Aztec düğümü başlatılıyor..."
  TRANSLATIONS["tr,node_started"]="Aztec düğümü başlatıldı."
  TRANSLATIONS["tr,missing_compose"]="docker-compose.yml yolu .env-aztec-agent dosyasında bulunamadı."
  TRANSLATIONS["tr,run_type_not_set"]="Yapılandırmada RUN_TYPE ayarlanmamış."
  TRANSLATIONS["tr,confirm_cli_run"]="Kapsayıcıyı CLI modunda çalıştırmak istiyor musunuz?"
  TRANSLATIONS["tr,run_type_set_to_cli"]="RUN_TYPE CLI olarak ayarlandı."
  TRANSLATIONS["tr,run_aborted"]="Çalıştırma kullanıcı tarafından iptal edildi."
  TRANSLATIONS["tr,checking_aztec_version"]="Aztec sürümü kontrol ediliyor..."
  TRANSLATIONS["tr,aztec_version_failed"]="Aztec sürümü alınamadı."
  TRANSLATIONS["tr,aztec_node_version"]="Aztec Node sürümü:"
  TRANSLATIONS["tr,critical_error_found"]="Kritik hata tespit edildi"
  TRANSLATIONS["tr,error_prefix"]="HATA:"
  TRANSLATIONS["tr,solution_prefix"]="Çözüm:"
  TRANSLATIONS["tr,notifications_prompt"]="Ek bildirim almak istiyor musunuz?"
  TRANSLATIONS["tr,notifications_option1"]="1. Sadece kritik hatalar"
  TRANSLATIONS["tr,notifications_option2"]="2. Tüm bildirimler (komite katılımı ve doğrulayıcı etkinliği dahil)"
  TRANSLATIONS["tr,notifications_debug_warning"]="Komite ve slot istatistik bildirimleri için DEBUG günlük seviyesi gereklidir"
  TRANSLATIONS["tr,notifications_input_error"]="Hata: lütfen 1 veya 2 girin"
  TRANSLATIONS["tr,choose_option_prompt"]="Seçenek belirleyin"
  TRANSLATIONS["tr,committee_selected"]="🎉 Komiteye seçildiniz"
  TRANSLATIONS["tr,found_validators"]="Komitede bulunan doğrulayıcılar: %s"
  TRANSLATIONS["tr,epoch_info"]="Dönem %s"
  TRANSLATIONS["tr,block_built"]="✅ %s bloğu başarıyla oluşturuldu"
  TRANSLATIONS["tr,slot_info"]="Slot %s"
  TRANSLATIONS["tr,validators_prompt"]="Validator adreslerinizi girin (virgülle ayırarak, boşluk olmadan):"
  TRANSLATIONS["tr,validators_format"]="Örnek: 0x123...,0x456...,0x789..."
  TRANSLATIONS["tr,validators_empty"]="Hata: Validator listesi boş olamaz"
  TRANSLATIONS["tr,status_legend"]="Durum Açıklaması:"
  TRANSLATIONS["tr,status_empty"]="⬜️ Boş slot"
  TRANSLATIONS["tr,status_attestation_sent"]="🟩 Doğrulama gönderildi"
  TRANSLATIONS["tr,status_attestation_missed"]="🟥 Doğrulama kaçırıldı"
  TRANSLATIONS["tr,status_block_mined"]="🟦 Blok çıkarıldı"
  TRANSLATIONS["tr,status_block_missed"]="🟨 Blok kaçırıldı"
  TRANSLATIONS["tr,status_block_proposed"]="🟪 Blok önerildi"
  TRANSLATIONS["tr,current_slot"]="Mevcut slot: %s"
  TRANSLATIONS["tr,agent_notifications_full_info"]="ℹ️ Sorunlar, komite ve slot istatistikleri için bildirimler gönderilecektir"
  TRANSLATIONS["tr,attestation_status"]="ℹ️ Slot istatistik"
  #peerID
  TRANSLATIONS["tr,fetching_peer_info"]="API'den eş (peer) bilgisi alınıyor..."
  TRANSLATIONS["tr,peer_found"]="Loglarda Peer ID bulundu"
  TRANSLATIONS["tr,peer_not_in_list"]="Eş, genel listede bulunamadı"
  TRANSLATIONS["tr,peer_id_not_critical"]="Nethermind.io'da Peer ID'nin olup olmaması kritik bir parametre değildir. Veriler güncel olmayabilir."
  TRANSLATIONS["tr,searching_latest"]="Güncel verilerde aranıyor..."
  TRANSLATIONS["tr,searching_archive"]="Arşiv verilerinde aranıyor..."
  TRANSLATIONS["tr,peer_found_archive"]="Not: Bu eş (peer) arşiv verilerinde bulundu"
  #
  TRANSLATIONS["tr,cli_quit_old_sessions"]="Eski oturum kapatıldı:"
  # install section
  TRANSLATIONS["tr,delete_node"]="🗑️ Aztec Node siliniyor..."
  TRANSLATIONS["tr,delete_confirm"]="Aztec node'u silmek istediğinize emin misiniz? Bu işlem konteynerleri durduracak ve tüm verileri silecektir. (y/n) "
  TRANSLATIONS["tr,node_deleted"]="✅ Aztec node başarıyla silindi"
  TRANSLATIONS["tr,delete_canceled"]="✖ Node silme işlemi iptal edildi"
  TRANSLATIONS["tr,delete_watchtower_confirm"]="Watchtower'ı da silmek istiyor musunuz? (y/n) "
  TRANSLATIONS["tr,watchtower_deleted"]="✅ Watchtower başarıyla silindi"
  TRANSLATIONS["tr,watchtower_kept"]="✅ Watchtower korundu"
  TRANSLATIONS["tr,enter_tg_token"]="Telegram bot tokenini girin: "
  TRANSLATIONS["tr,enter_tg_chat_id"]="Telegram chat ID'sini girin: "
  TRANSLATIONS["tr,single_validator_mode"]="🔹 Tek validatör modu seçildi"
  TRANSLATIONS["tr,multi_validator_mode"]="🔹 Çoklu validatör modu seçildi"
  TRANSLATIONS["tr,enter_validator_keys"]="Validatör özel anahtarlarını girin (0x ile virgülle ayrılmış, en fazla 10): "
  TRANSLATIONS["tr,enter_validator_key"]="Validatör özel anahtar girin (0x ile): "
  TRANSLATIONS["tr,enter_seq_publisher_key"]="SEQ_PUBLISHER_PRIVATE_KEY girin (0x ile): "
  TRANSLATIONS["tr,enter_yn"]="Lütfen Y veya N girin: "
  TRANSLATIONS["tr,stopping_containers"]="Konteynerler durduruluyor..."
  TRANSLATIONS["tr,removing_node_data"]="Aztec node verileri kaldırılıyor..."
  TRANSLATIONS["tr,stopping_watchtower"]="Watchtower durduruluyor..."
  TRANSLATIONS["tr,removing_watchtower_data"]="Watchtower verileri kaldırılıyor..."
  # Güncelleme
  TRANSLATIONS["tr,update_title"]="Aztec düğümü en son sürüme güncelleniyor"
  TRANSLATIONS["tr,update_folder_error"]="Hata: $HOME/aztec klasörü mevcut değil"
  TRANSLATIONS["tr,update_stopping"]="Kapsayıcılar durduruluyor..."
  TRANSLATIONS["tr,update_stop_error"]="Kapsayıcılar durdurulurken hata oluştu"
  TRANSLATIONS["tr,update_pulling"]="Son aztecprotocol/aztec imajı çekiliyor..."
  TRANSLATIONS["tr,update_pull_error"]="İmaj çekilirken hata oluştu"
  TRANSLATIONS["tr,update_starting"]="Güncellenmiş düğüm başlatılıyor..."
  TRANSLATIONS["tr,update_start_error"]="Kapsayıcılar başlatılırken hata oluştu"
  TRANSLATIONS["tr,update_success"]="Aztec düğümü başarıyla en son sürüme güncellendi!"
  TRANSLATIONS["tr,tag_check"]="Etiket bulundu: %s, en son sürümle değiştiriliyor"
  # Sürüm düşürme
  TRANSLATIONS["tr,downgrade_title"]="Aztec düğümü sürüm düşürülüyor"
  TRANSLATIONS["tr,downgrade_fetching"]="Mevcut sürüm listesi alınıyor..."
  TRANSLATIONS["tr,downgrade_fetch_error"]="Sürüm listesi alınamadı"
  TRANSLATIONS["tr,downgrade_available"]="Mevcut sürümler (numarayı girin):"
  TRANSLATIONS["tr,downgrade_invalid_choice"]="Geçersiz seçim, lütfen tekrar deneyin"
  TRANSLATIONS["tr,downgrade_selected"]="Seçilen sürüm:"
  TRANSLATIONS["tr,downgrade_folder_error"]="Hata: $HOME/aztec klasörü mevcut değil"
  TRANSLATIONS["tr,downgrade_stopping"]="Kapsayıcılar durduruluyor..."
  TRANSLATIONS["tr,downgrade_stop_error"]="Kapsayıcılar durdurulurken hata oluştu"
  TRANSLATIONS["tr,downgrade_pulling"]="aztecprotocol/aztec imajı çekiliyor:"
  TRANSLATIONS["tr,downgrade_pull_error"]="İmaj çekilirken hata oluştu"
  TRANSLATIONS["tr,downgrade_updating"]="Yapılandırma güncelleniyor..."
  TRANSLATIONS["tr,downgrade_update_error"]="docker-compose.yml güncellenirken hata oluştu"
  TRANSLATIONS["tr,downgrade_starting"]="Düğüm şu sürümle başlatılıyor"
  TRANSLATIONS["tr,downgrade_start_error"]="Kapsayıcılar başlatılırken hata oluştu"
  TRANSLATIONS["tr,downgrade_success"]="Aztec düğümü başarıyla şu sürüme düşürüldü"
  #agent
  TRANSLATIONS["tr,agent_systemd_added"]="Aracı eklendi (systemd ile her 37 saniyede bir çalışıyor)"
  TRANSLATIONS["tr,agent_timer_status"]="Zamanlayıcı durumu:"
  TRANSLATIONS["tr,agent_timer_error"]="Systemd zamanlayıcı oluşturulurken hata oluştu"
  TRANSLATIONS["tr,removing_systemd_agent"]="Aracı ve systemd birimlerini kaldırılıyor..."
  TRANSLATIONS["tr,agent_systemd_removed"]="Aracı başarıyla kaldırıldı"
  #version module
  TRANSLATIONS["tr,update_changes"]="Güncellemedeki değişiklikler"
  TRANSLATIONS["tr,installed"]="kuruldu"
  TRANSLATIONS["tr,not_installed"]="kurulu değil"
  TRANSLATIONS["tr,install_curl_cffi_prompt"]="curl_cffi şimdi yüklensin mi? (Y/n)"
  TRANSLATIONS["tr,installing_curl_cffi"]="curl_cffi yükleniyor..."
  TRANSLATIONS["tr,curl_cffi_optional"]="curl_cffi kurulumu atlandı (isteğe bağlı)."

  TRANSLATIONS["tr,installing_foundry"]="Foundry yükleniyor..."
  TRANSLATIONS["tr,installing_curl"]="curl yükleniyor..."
  TRANSLATIONS["tr,installing_utils"]="Araçlar yükleniyor (grep, sed)..."
  TRANSLATIONS["tr,installing_jq"]="jq yükleniyor..."
  TRANSLATIONS["tr,installing_bc"]="bc yükleniyor..."
  TRANSLATIONS["tr,installing_python3"]="Python3 yükleniyor..."
}

# === Configuration ===
CONTRACT_ADDRESS="0xebd99ff0ff6677205509ae73f93d0ca52ac85d67"
FUNCTION_SIG="getPendingBlockNumber()"

REQUIRED_TOOLS=("cast" "curl" "grep" "sed" "jq" "bc" "python3")
AGENT_SCRIPT_PATH="$HOME/aztec-monitor-agent"
LOG_FILE="$AGENT_SCRIPT_PATH/agent.log"

# === Dependency check ===
check_dependencies() {
  missing=()
  echo -e "\n${BLUE}$(t "checking_deps")${NC}\n"

  # Создаем ассоциативный массив для отображения имен
  declare -A tool_names=(
    ["cast"]="foundry"
    ["curl"]="curl"
    ["grep"]="grep"
    ["sed"]="sed"
    ["jq"]="jq"
    ["bc"]="bc"
    ["python3"]="python3"
  )

  # Проверяем основные утилиты
  for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
      display_name=${tool_names[$tool]:-$tool}
      echo -e "${RED}❌ $display_name $(t "not_installed")${NC}"
      missing+=("$tool")
    else
      display_name=${tool_names[$tool]:-$tool}
      echo -e "${GREEN}✅ $display_name $(t "installed")${NC}"
    fi
  done

  # Отдельная проверка для curl_cffi
  if command -v python3 &>/dev/null; then
    if python3 -c "import curl_cffi" 2>/dev/null; then
      echo -e "${GREEN}✅ curl_cffi $(t "installed")${NC}"
    else
      echo -e "${YELLOW}⚠️  curl_cffi $(t "not_installed")${NC}"
      # Добавляем python3 в missing только если нужно установить curl_cffi
      if [[ ! " ${missing[@]} " =~ " python3 " ]]; then
        missing+=("python3_curl_cffi")
      fi
    fi
  else
    # python3 не установлен, это уже обрабатывается выше
    echo -e "${YELLOW}⚠️  curl_cffi $(t "not_installed") (requires python3)${NC}"
  fi

  if [ ${#missing[@]} -gt 0 ]; then
    # Преобразуем имена для отображения в списке отсутствующих инструментов
    missing_display=()
    for tool in "${missing[@]}"; do
      if [ "$tool" == "python3_curl_cffi" ]; then
        missing_display+=("curl_cffi")
      else
        missing_display+=("${tool_names[$tool]:-$tool}")
      fi
    done

    echo -e "\n${YELLOW}$(t "missing_tools") ${missing_display[*]}${NC}"
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

          python3)
            echo -e "\n${CYAN}$(t "installing_python3")${NC}"
            # Устанавливаем python3 и pip отдельно
            if command -v apt-get &>/dev/null; then
              sudo apt-get install -y python3 python3-pip
            elif command -v brew &>/dev/null; then
              brew install python3
            fi

            # Устанавливаем curl_cffi с обходом externally-managed-environment
            echo -e "\n${CYAN}$(t "installing_curl_cffi")${NC}"
            python3 -m pip install --break-system-packages --quiet curl_cffi 2>/dev/null || \
            python3 -m pip install --quiet curl_cffi
            ;;

          python3_curl_cffi)
            # Устанавливаем только curl_cffi с обходом externally-managed-environment
            echo -e "\n${CYAN}$(t "installing_curl_cffi")${NC}"
            python3 -m pip install --break-system-packages --quiet curl_cffi 2>/dev/null || \
            python3 -m pip install --quiet curl_cffi
            ;;
        esac
      done
    else
      echo -e "\n${RED}$(t "missing_required")${NC}"
      exit 1
    fi
  fi

  # Дополнительная проверка curl_cffi на случай, если пользователь пропустил установку
  if command -v python3 &>/dev/null; then
    if ! python3 -c "import curl_cffi" 2>/dev/null; then
      echo -e "\n${YELLOW}$(t "curl_cffi_not_installed")${NC}"
      read -p "$(t "install_curl_cffi_prompt") " confirm
      confirm=${confirm:-Y}

      if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "\n${CYAN}$(t "installing_curl_cffi")${NC}"
        python3 -m pip install --break-system-packages --quiet curl_cffi 2>/dev/null || \
        python3 -m pip install --quiet curl_cffi
      else
        echo -e "\n${YELLOW}$(t "curl_cffi_optional")${NC}"
      fi
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

  # === Проверяем и добавляем ключ VERSION в ~/.env-aztec-agent ===
  # Если ключа VERSION в .env-aztec-agent нет – дописать его, не затронув остальные переменные
  INSTALLED_VERSION=$(grep '^VERSION=' ~/.env-aztec-agent | cut -d'=' -f2)

  if [ -z "$INSTALLED_VERSION" ]; then
    echo "VERSION=$SCRIPT_VERSION" >> ~/.env-aztec-agent
    INSTALLED_VERSION="$SCRIPT_VERSION"
  elif [ "$INSTALLED_VERSION" != "$SCRIPT_VERSION" ]; then
  # Обновляем строку VERSION в .env-aztec-agent
    sed -i "s/^VERSION=.*/VERSION=$SCRIPT_VERSION/" ~/.env-aztec-agent
    INSTALLED_VERSION="$SCRIPT_VERSION"
  fi

  # === Скачиваем remote version_control.json и определяем последнюю версию ===
  REMOTE_VC_URL="https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/version_control.json"
  # Скачиваем весь JSON, отбираем массив .[].VERSION, сортируем, берём последний
  if remote_data=$(curl -fsSL "$REMOTE_VC_URL"); then
    REMOTE_LATEST_VERSION=$(echo "$remote_data" | jq -r '.[].VERSION' | sort -V | tail -n1)
  else
    REMOTE_LATEST_VERSION=""
  fi

  # === Выводим текущую версию и, если надо, предупреждение об обновлении ===
  echo -e "\n${CYAN}$(t "current_script_version") ${INSTALLED_VERSION}${NC}"
  if [ -n "$REMOTE_LATEST_VERSION" ] && [ "$REMOTE_LATEST_VERSION" != "$INSTALLED_VERSION" ]; then
    echo -e "${YELLOW}$(t "new_version_avialable") ${REMOTE_LATEST_VERSION}. $(t "new_version_update").${NC}"

    # === ВЫВОД СПИСКА ОБНОВЛЕНИЙ ===
    echo -e "\n${BLUE}=== $(t "update_changes") ===${NC}"

    # Функция для сравнения версий (правильная реализация)
    version_gt() {
      if [ "$1" = "$2" ]; then
        return 1
      fi
      local IFS=.
      local i ver1=($1) ver2=($2)
      for ((i=0; i<${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]; then
          ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]})); then
          return 0
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
          return 1
        fi
      done
      return 1
    }

    # Выводим обновления только для версий НОВЕЕ текущей
    echo "$remote_data" | jq -c '.[]' | while read -r update; do
      version=$(echo "$update" | jq -r '.VERSION')
      date=$(echo "$update" | jq -r '.UPDATE_DATE')

      # Используем правильное сравнение версий
      if version_gt "$version" "$INSTALLED_VERSION"; then
        echo -e "\n${GREEN}Version: $version (${date})${NC}"

        # Выводим список изменений
        echo "$update" | jq -r '.CHANGES[]' | while read -r change; do
          echo -e "  • ${YELLOW}$change${NC}"
        done
      fi
    done

  elif [ -n "$REMOTE_LATEST_VERSION" ]; then
    echo -e "${GREEN}$(t "version_up_to_date")${NC}"
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

# === Check container logs for block ===
check_aztec_container_logs() {
    cd $HOME
    source .env-aztec-agent

    # URL JSON файла с ошибками на GitHub
    ERROR_DEFINITIONS_URL="https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/error_definitions.json"

    # Локальный файл для кэширования
    ERROR_DEFINITIONS_FILE="$HOME/aztec_error_definitions.json"

    # Загружаем JSON с определениями ошибок
    download_error_definitions() {
        if ! curl -s --fail "$ERROR_DEFINITIONS_URL" -o "$ERROR_DEFINITIONS_FILE"; then
            echo -e "${YELLOW}Warning: Failed to download error definitions from GitHub${NC}"
            return 1
        fi
        return 0
        return 0
    }

    # Парсим JSON и заполняем массивы
    parse_error_definitions() {
        # Используем jq для парсинга JSON, если установлен
        if command -v jq >/dev/null; then
            while IFS= read -r line; do
                pattern=$(jq -r '.pattern' <<< "$line")
                message=$(jq -r '.message' <<< "$line")
                solution=$(jq -r '.solution' <<< "$line")
                critical_errors["$pattern"]="$message"
                error_solutions["$pattern"]="$solution"
            done < <(jq -c '.[]' "$ERROR_DEFINITIONS_FILE")
        else
            # Простой парсинг без jq (ограниченная функциональность)
            while IFS= read -r line; do
                if [[ "$line" =~ \"pattern\":\"([^\"]*)\".*\"message\":\"([^\"]*)\".*\"solution\":\"([^\"]*)\" ]]; then
                    pattern="${BASH_REMATCH[1]}"
                    message="${BASH_REMATCH[2]}"
                    solution="${BASH_REMATCH[3]}"
                    critical_errors["$pattern"]="$message"
                    error_solutions["$pattern"]="$solution"
                fi
            done < <(grep -Eo '\{[^}]+\}' "$ERROR_DEFINITIONS_FILE")
        fi
    }

    # Инициализируем массивы для ошибок и решений
    declare -A critical_errors
    declare -A error_solutions

    # Загружаем и парсим определения ошибок
    if download_error_definitions; then
        parse_error_definitions
    else
        # Используем встроенные ошибки по умолчанию если не удалось загрузить
        critical_errors=(
            ["ERROR: cli Error: World state trees are out of sync, please delete your data directory and re-sync"]="World state trees are out of sync - node needs resync"
        )
        error_solutions=(
            ["ERROR: cli Error: World state trees are out of sync, please delete your data directory and re-sync"]="1. Stop the node container. Use option 13\n2. Delete data from the folder: sudo rm -rf /root/.aztec/testnet/data/\n3. Run the container. Use option 14"
        )
    fi

    echo -e "\n${BLUE}$(t "search_container")${NC}"
    container_id=$(docker ps --format "{{.ID}} {{.Names}}" \
                   | grep aztec | grep -v watchtower | head -n 1 | awk '{print $1}')

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
    block_number=$((16#${block_hex#0x}))
    echo -e "\n${GREEN}$(t "current_block") $block_number${NC}"

    # Получаем логи контейнера
    clean_logs=$(docker logs "$container_id" --tail 20000 2>&1 | sed -r 's/\x1B\[[0-9;]*[A-Za-z]//g')

    # Проверяем на наличие критических ошибок
    for error_pattern in "${!critical_errors[@]}"; do
        if echo "$clean_logs" | grep -q "$error_pattern"; then
            echo -e "\n${RED}$(t "critical_error_found")${NC}"
            echo -e "${YELLOW}$(t "error_prefix") ${critical_errors[$error_pattern]}${NC}"

            # Выводим решение для данной ошибки
            if [ -n "${error_solutions[$error_pattern]}" ]; then
                echo -e "\n${BLUE}$(t "solution_prefix")${NC}"
                echo -e "${error_solutions[$error_pattern]}"
            fi

            return
        fi
    done

    # Остальная часть функции остается без изменений
    temp_file=$(mktemp)
    {
        echo "$clean_logs" | tac | grep -m1 'Sequencer sync check succeeded' >"$temp_file" 2>/dev/null
        if [ ! -s "$temp_file" ]; then
            echo "$clean_logs" | tac | grep -m1 'Downloaded L2 block' >"$temp_file" 2>/dev/null
        fi
    } &
    search_pid=$!
    spinner $search_pid
    wait $search_pid

    latest_log_line=$(<"$temp_file")
    rm -f "$temp_file"

    if [ -z "$latest_log_line" ]; then
        echo -e "\n${RED}$(t "log_block_not_found")${NC}"
        return
    fi

    if grep -q 'Sequencer sync check succeeded' <<<"$latest_log_line"; then
        log_block_number=$(echo "$latest_log_line" \
            | grep -o '"worldState":{"number":[0-9]\+' \
            | grep -o '[0-9]\+$')
    else
        log_block_number=$(echo "$latest_log_line" \
            | grep -o '"blockNumber":[0-9]\+' \
            | head -n1 | cut -d':' -f2)
    fi

    if [ -z "$log_block_number" ]; then
        echo -e "\n${RED}$(t "log_block_extract_failed")${NC}"
        echo "$latest_log_line"
        return
    fi
    echo -e "\n${BLUE}$(t "log_block_number") $log_block_number${NC}"

    if [ "$log_block_number" -eq "$block_number" ]; then
        echo -e "\n${GREEN}$(t "node_ok")${NC}"
    else
        printf "\n${YELLOW}$(t "log_behind_details")${NC}\n" \
               "$log_block_number" "$block_number"
        echo -e "\n${BLUE}$(t "log_line_example")${NC}"
        echo "$latest_log_line"
    fi
}

# === View Aztec container logs ===
view_container_logs() {

  echo -e "\n${BLUE}$(t "search_container")${NC}"
  container_id=$(docker ps --format "{{.ID}} {{.Names}}" | grep aztec | grep -v watchtower | head -n 1 | awk '{print $1}')

  if [ -z "$container_id" ]; then
    echo -e "\n${RED}$(t "container_not_found")${NC}"
    return
  fi

  echo -e "\n${GREEN}$(t "container_found") $container_id${NC}"
  echo -e "\n${BLUE}$(t "press_ctrlc")${NC}"
  echo -e "\n${BLUE}$(t "logs_starting")${NC}"

  sleep 5

  # При получении SIGINT (Ctrl+C) выходим из функции и возвращаемся в меню
  trap "echo -e '\n${YELLOW}$(t "return_main_menu")${NC}'; trap - SIGINT; return" SIGINT

  # Показываем логи в режиме "follow"
  docker logs --tail 500 -f "$container_id"

  # Убираем ранее установленный trap, если пользователь вышел нормально
  trap - SIGINT
}


# === Find rollupAddress in logs ===
find_rollup_address() {
  echo -e "\n${BLUE}$(t "search_rollup")${NC}"

  container_id=$(docker ps --format "{{.ID}} {{.Names}}" | grep aztec | grep -v watchtower | head -n 1 | awk '{print $1}')

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

# === Find PeerID in logs ===
find_peer_id() {
  echo -e "\n${BLUE}$(t "search_peer")${NC}"

  container_id=$(docker ps --format "{{.ID}} {{.Names}}" | grep aztec | grep -v watchtower | head -n 1 | awk '{print $1}')

  if [ -z "$container_id" ]; then
    echo -e "\n${RED}$(t "container_not_found")${NC}"
    return 1
  fi

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
    echo -e "\n${GREEN}$(t "peer_found")${NC}: $peer_id"
    return 0
  fi
}

# === Find governanceProposerPayload ===
find_governance_proposer_payload() {
  echo -e "\n${BLUE}$(t "search_gov")${NC}"

  # Получаем ID контейнера
  container_id=$(docker ps --format "{{.ID}} {{.Names}}" | grep aztec | grep -v watchtower | head -n 1 | awk '{print $1}')

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
      tr '[:upper:]' '[:lower:]' | \
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

# === Create agent and systemd task ===
create_systemd_agent() {
  local env_file
  env_file=$(_ensure_env_file)
  source "$env_file"

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
      -d text="$(t "chatid_linked")" \
      -d parse_mode="Markdown")

    if [[ "$response" == *"ok\":true"* ]]; then
      return 0
    else
      return 1
    fi
  }

  # === Проверка и получение TELEGRAM_BOT_TOKEN ===
  if [ -z "$TELEGRAM_BOT_TOKEN" ]; then
    while true; do
      echo -e "\n${BLUE}$(t "token_prompt")${NC}"
      read -p "> " TELEGRAM_BOT_TOKEN

      if validate_telegram_token "$TELEGRAM_BOT_TOKEN"; then
        echo "TELEGRAM_BOT_TOKEN=\"$TELEGRAM_BOT_TOKEN\"" >> "$env_file"
        break
      else
        echo -e "${RED}$(t "invalid_token")${NC}"
        echo -e "${YELLOW}$(t "token_format")${NC}"
      fi
    done
  fi

  # === Проверка и получение TELEGRAM_CHAT_ID ===
  if [ -z "$TELEGRAM_CHAT_ID" ]; then
    while true; do
      echo -e "\n${BLUE}$(t "chatid_prompt")${NC}"
      read -p "> " TELEGRAM_CHAT_ID

      if [[ "$TELEGRAM_CHAT_ID" =~ ^-?[0-9]+$ ]]; then
        if validate_telegram_chat "$TELEGRAM_BOT_TOKEN" "$TELEGRAM_CHAT_ID"; then
          echo "TELEGRAM_CHAT_ID=\"$TELEGRAM_CHAT_ID\"" >> "$env_file"
          break
        else
          echo -e "${RED}$(t "invalid_chatid")${NC}"
        fi
      else
        echo -e "${RED}$(t "chatid_number")${NC}"
      fi
    done
  fi

  # === Запрос о дополнительных уведомлениях ===
  if [ -z "$NOTIFICATION_TYPE" ]; then
    echo -e "\n${BLUE}$(t "notifications_prompt")${NC}"
    echo -e "$(t "notifications_option1")"
    echo -e "$(t "notifications_option2")"
    echo -e "\n${YELLOW}$(t "notifications_debug_warning")${NC}"
    while true; do
      read -p "$(t "choose_option_prompt") (1/2): " NOTIFICATION_TYPE
      if [[ "$NOTIFICATION_TYPE" =~ ^[12]$ ]]; then
        if ! grep -q "NOTIFICATION_TYPE" "$env_file"; then
          echo "NOTIFICATION_TYPE=\"$NOTIFICATION_TYPE\"" >> "$env_file"
        else
          sed -i "s/^NOTIFICATION_TYPE=.*/NOTIFICATION_TYPE=\"$NOTIFICATION_TYPE\"/" "$env_file"
        fi
        break
      else
        echo -e "${RED}$(t "notifications_input_error")${NC}"
      fi
    done
  fi

  # === Проверка и получение VALIDATORS (если NOTIFICATION_TYPE == 2) ===
  if [ "$NOTIFICATION_TYPE" -eq 2 ] && [ ! -f "/root/.env-aztec-agent" ] || ! grep -q "^VALIDATORS=" "/root/.env-aztec-agent"; then
    echo -e "\n${BLUE}$(t "validators_prompt")${NC}"
    echo -e "${YELLOW}$(t "validators_format")${NC}"
    while true; do
      read -p "> " VALIDATORS
      if [[ -n "$VALIDATORS" ]]; then
        if [ -f "/root/.env-aztec-agent" ]; then
          if grep -q "^VALIDATORS=" "/root/.env-aztec-agent"; then
            sed -i "s/^VALIDATORS=.*/VALIDATORS=\"$VALIDATORS\"/" "/root/.env-aztec-agent"
          else
            echo "VALIDATORS=\"$VALIDATORS\"" >> "/root/.env-aztec-agent"
          fi
        else
          echo "VALIDATORS=\"$VALIDATORS\"" > "/root/.env-aztec-agent"
        fi
        break
      else
        echo -e "${RED}$(t "validators_empty")${NC}"
      fi
    done
  fi

  mkdir -p "$AGENT_SCRIPT_PATH"

  # Генерация скрипта агента
  cat > "$AGENT_SCRIPT_PATH/agent.sh" <<EOF
#!/bin/bash
export PATH="\$PATH:/root/.foundry/bin"

source \$HOME/.env-aztec-agent
CONTRACT_ADDRESS="$CONTRACT_ADDRESS"
FUNCTION_SIG="$FUNCTION_SIG"
TELEGRAM_BOT_TOKEN="$TELEGRAM_BOT_TOKEN"
TELEGRAM_CHAT_ID="$TELEGRAM_CHAT_ID"
LOG_FILE="$LOG_FILE"
LANG="$LANG"

# URL JSON файла с ошибками на GitHub
ERROR_DEFINITIONS_URL="https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/error_definitions.json"
ERROR_DEFINITIONS_FILE="\$HOME/aztec_error_definitions.json"

# Функция перевода
t() {
  local key=\$1
  local value1=\$2
  local value2=\$3

  case \$key in
    "log_cleaned") echo "$(t "agent_log_cleaned")" ;;
    "container_not_found") echo "$(t "agent_container_not_found")" ;;
    "block_fetch_error") echo "$(t "agent_block_fetch_error")" ;;
    "no_block_in_logs") echo "$(t "agent_no_block_in_logs")" ;;
    "failed_extract_block") echo "$(t "agent_failed_extract_block")" ;;
    "node_behind") printf "$(t "agent_node_behind")" "\$value1" ;;
    "agent_started") echo "$(t "agent_started")" ;;
    "log_size_warning") echo "$(t "agent_log_size_warning")" ;;
    "server_info") printf "$(t "agent_server_info")" "\$value1" ;;
    "file_info") printf "$(t "agent_file_info")" "\$value1" ;;
    "size_info") printf "$(t "agent_size_info")" "\$value1" ;;
    "rpc_info") printf "$(t "agent_rpc_info")" "\$value1" ;;
    "error_info") printf "$(t "agent_error_info")" "\$value1" ;;
    "block_info") printf "$(t "agent_block_info")" "\$value1" ;;
    "log_block_info") printf "$(t "agent_log_block_info")" "\$value1" ;;
    "time_info") printf "$(t "agent_time_info")" "\$value1" ;;
    "line_info") printf "$(t "agent_line_info")" "\$value1" ;;
    "notifications_info") echo "$(t "agent_notifications_info")" ;;
    "node_synced") printf "$(t "agent_node_synced")" "\$value1" ;;
    "critical_error_found") echo "$(t "critical_error_found")" ;;
    "error_prefix") echo "$(t "error_prefix")" ;;
    "solution_prefix") echo "$(t "solution_prefix")" ;;
    "notifications_full_info") echo "$(t "agent_notifications_full_info")" ;;
    "committee_selected") echo "$(t "committee_selected")" ;;
    "epoch_info") printf "$(t "epoch_info")" "\$value1" ;;
    "block_built") printf "$(t "block_built")" "\$value1" ;;
    "slot_info") printf "$(t "slot_info")" "\$value1" ;;
    "found_validators") printf "$(t "found_validators")" "\$value1" ;;
    "validators_prompt") echo "$(t "validators_prompt")" ;;
    "validators_format") echo "$(t "validators_format")" ;;
    "validators_empty") echo "$(t "validators_empty")" ;;
    "attestation_status") echo "$(t "attestation_status")" ;;
    "status_legend") echo "$(t "status_legend")" ;;
    "status_empty") echo "$(t "status_empty")" ;;
    "status_attestation_sent") echo "$(t "status_attestation_sent")" ;;
    "status_attestation_missed") echo "$(t "status_attestation_missed")" ;;
    "status_block_mined") echo "$(t "status_block_mined")" ;;
    "status_block_missed") echo "$(t "status_block_missed")" ;;
    "status_block_proposed") echo "$(t "status_block_proposed")" ;;
    "current_slot") printf "$(t "current_slot")" "\$value1" ;;
    *) echo "\$key" ;;
  esac
}

# === Создание файла лога, если его нет ===
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

# === Проверка размера файла и очистка, если больше 1 МБ ===
MAX_SIZE=1048576
current_size=\$(stat -c%s "\$LOG_FILE")

if [ "\$current_size" -gt "\$MAX_SIZE" ]; then
  temp_file=\$(mktemp)
  awk '/INITIALIZED/ {print; exit} {print}' "\$LOG_FILE" > "\$temp_file"
  mv "\$temp_file" "\$LOG_FILE"
  chmod 644 "\$LOG_FILE"

  {
    echo ""
    echo "\$(t "log_cleaned")"
    echo "Cleanup completed: \$(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
  } >> "\$LOG_FILE"

  ip=\$(curl -s https://api.ipify.org || echo "unknown-ip")
  current_time=\$(date '+%Y-%m-%d %H:%M:%S')
  message="\$(t "log_size_warning")%0A\$(t "server_info" "\$ip")%0A\$(t "file_info" "\$LOG_FILE")%0A\$(t "size_info" "\$current_size")%0A\$(t "time_info" "\$current_time")"

  curl -s -X POST "https://api.telegram.org/bot\$TELEGRAM_BOT_TOKEN/sendMessage" \\
    -d chat_id="\$TELEGRAM_CHAT_ID" \\
    -d text="\$message" \\
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

# === Функция для записи в лог-файл ===
log() {
  echo "[\$(date '+%Y-%m-%d %H:%M:%S')] \$1" >> "\$LOG_FILE"
}

# === Функция для отправки уведомлений в Telegram ===
send_telegram_message() {
  local message="\$1"
  curl -s -X POST "https://api.telegram.org/bot\$TELEGRAM_BOT_TOKEN/sendMessage" \\
    -d chat_id="\$TELEGRAM_CHAT_ID" \\
    -d text="\$message" \\
    -d parse_mode="Markdown" >/dev/null
}

# === Helper: send Telegram message and return message_id ===
send_telegram_message_get_id() {
  local message="\$1"
  local resp
  resp=\$(curl -s -X POST "https://api.telegram.org/bot\$TELEGRAM_BOT_TOKEN/sendMessage" \\
    -d chat_id="\$TELEGRAM_CHAT_ID" \\
    -d text="\$message" \\
    -d parse_mode="Markdown")
  echo "\$resp" | jq -r '.result.message_id'
}

# === Helper: edit Telegram message by message_id ===
edit_telegram_message() {
  local message_id="\$1"
  local text="\$2"
  curl -s -X POST "https://api.telegram.org/bot\$TELEGRAM_BOT_TOKEN/editMessageText" \\
    -d chat_id="\$TELEGRAM_CHAT_ID" \\
    -d message_id="\$message_id" \\
    -d text="\$text" \\
    -d parse_mode="Markdown" >/dev/null
}

# === Helper: build a 32-slot board (8 per line) ===
build_slots_board() {
  # expects 32 items passed as args (each is an emoji)
  local slots=("\$@")
  local out=""
  for i in {0..31}; do
    out+="\${slots[\$i]}"
    if [ \$(((i+1)%8)) -eq 0 ]; then
      out+="%0A"
    fi
  done
  echo "\$out"
}

# === Получаем свой публичный IP для включения в уведомления ===
get_ip_address() {
  curl -s https://api.ipify.org || echo "unknown-ip"
}
ip=\$(get_ip_address)

# === Переводим hex -> decimal ===
hex_to_dec() {
  local hex=\$1
  hex=\${hex#0x}
  hex=\$(echo \$hex | sed 's/^0*//')
  [ -z "\$hex" ] && echo 0 && return
  echo \$((16#\$hex))
}

# === Проверка критических ошибок в логах ===
check_critical_errors() {
  local container_id=\$1
  local clean_logs=\$(docker logs "\$container_id" --tail 10000 2>&1 | sed -r 's/\x1B\[[0-9;]*[A-Za-z]//g')

  # Загружаем JSON с определениями ошибок
  if ! curl -s --fail "\$ERROR_DEFINITIONS_URL" -o "\$ERROR_DEFINITIONS_FILE"; then
    log "Failed to download error definitions from GitHub"
    return
  fi

  # Парсим JSON с ошибками
  errors_count=\$(jq '. | length' "\$ERROR_DEFINITIONS_FILE")
  for ((i=0; i<\$errors_count; i++)); do
    pattern=\$(jq -r ".[\$i].pattern" "\$ERROR_DEFINITIONS_FILE")
    message=\$(jq -r ".[\$i].message" "\$ERROR_DEFINITIONS_FILE")
    solution=\$(jq -r ".[\$i].solution" "\$ERROR_DEFINITIONS_FILE")

    if echo "\$clean_logs" | grep -q "\$pattern"; then
      log "Critical error detected: \$pattern"
      current_time=\$(date '+%Y-%m-%d %H:%M:%S')
      full_message="\$(t "critical_error_found")%0A\$(t "server_info" "\$ip")%0A\$(t "error_prefix") \$message%0A\$(t "solution_prefix")%0A\$solution%0A\$(t "time_info" "\$current_time")"
      send_telegram_message "\$full_message"
      exit 1
    fi
  done
}

# === Оптимизированная функция для поиска строк в логах ===
find_last_log_line() {
  local container_id=\$1
  local temp_file=\$(mktemp)

  # Получаем логи с ограничением по объему и сразу фильтруем нужные строки
  docker logs "\$container_id" --tail 10000 2>&1 | \
    sed -r 's/\x1B\[[0-9;]*[A-Za-z]//g' | \
    grep -E 'Sequencer sync check succeeded|Downloaded L2 block' | \
    tail -100 > "\$temp_file"

  # Сначала ищем Sequencer sync check succeeded
  local line=\$(tac "\$temp_file" | grep -m1 'Sequencer sync check succeeded')

  # Если не нашли, ищем Downloaded L2 block
  if [ -z "\$line" ]; then
    line=\$(tac "\$temp_file" | grep -m1 'Downloaded L2 block')
  fi

  rm -f "\$temp_file"
  echo "\$line"
}

# === Функция для проверки и добавления переменной DEBUG ===
ensure_debug_variable() {
  local env_file="/root/.env-aztec-agent"
  if [ ! -f "\$env_file" ]; then
    return
  fi

  # Проверяем, существует ли уже переменная DEBUG
  if ! grep -q "^DEBUG=" "\$env_file"; then
    # Добавляем DEBUG переменную в конец файла
    echo "DEBUG=false" >> "\$env_file"
    log "Added DEBUG variable to \$env_file"
  fi
}

# Вызываем функцию при загрузке скрипта
ensure_debug_variable

# === Функция для проверки отладочного режима ===
is_debug_enabled() {
  if [ ! -f "/root/.env-aztec-agent" ]; then
    return 1
  fi

  # Загружаем только переменную DEBUG
  debug_value=\$(grep "^DEBUG=" "/root/.env-aztec-agent" | cut -d'=' -f2 | tr -d '"' | tr -d "'" | tr '[:upper:]' '[:lower:]')

  if [ "\$debug_value" = "true" ] || [ "\$debug_value" = "1" ] || [ "\$debug_value" = "yes" ]; then
    return 0
  else
    return 1
  fi
}

# === Функция для отладочного логирования ===
debug_log() {
  if is_debug_enabled; then
    log "DEBUG: \$1"
  fi
}

# === Новая версия функции для проверки комитета и статусов ===
check_committee() {
  debug_log "check_committee started. NOTIFICATION_TYPE=\$NOTIFICATION_TYPE"

  if [ "\$NOTIFICATION_TYPE" -ne 2 ]; then
    debug_log "NOTIFICATION_TYPE != 2, skipping committee check"
    return
  fi

  # Загружаем список валидаторов
  if [ ! -f "/root/.env-aztec-agent" ]; then
    log "Validator file /root/.env-aztec-agent not found"
    return
  fi

  source /root/.env-aztec-agent
  if [ -z "\$VALIDATORS" ]; then
    log "No validators defined in VALIDATORS variable"
    return
  fi

  IFS=',' read -ra VALIDATOR_ARRAY <<< "\$VALIDATORS"
  debug_log "Validators loaded: \${VALIDATOR_ARRAY[*]}"

  container_id=\$(docker ps --format "{{.ID}} {{.Names}}" | grep aztec | grep -v watchtower | head -n 1 | awk '{print \$1}')
  if [ -z "\$container_id" ]; then
    debug_log "No aztec container found"
    return
  fi
  debug_log "Container ID: \$container_id"

  # --- Получаем данные о комитете ---
  committee_line=\$(docker logs "\$container_id" --tail 10000 2>&1 | grep -a "Computing stats for slot" | tail -n 1)
  [ -z "\$committee_line" ] && { debug_log "No committee line found in logs"; return; }
  debug_log "Committee line found: \$committee_line"

  json_part=\$(echo "\$committee_line" | sed -n 's/.*\({.*}\).*/\1/p')
  [ -z "\$json_part" ] && { debug_log "No JSON part extracted"; return; }
  debug_log "JSON part: \$json_part"

  epoch=\$(echo "\$json_part" | jq -r '.epoch')
  slot=\$(echo "\$json_part" | jq -r '.slot')
  committee=\$(echo "\$json_part" | jq -r '.committee[]')

  if [ -z "\$epoch" ] || [ -z "\$slot" ] || [ -z "\$committee" ]; then
    debug_log "Missing epoch/slot/committee data. epoch=\$epoch, slot=\$slot, committee=\$committee"
    return
  fi
  debug_log "Epoch=\$epoch, Slot=\$slot, Committee=\$committee"

  found_validators=()
  committee_validators=()
  for validator in "\${VALIDATOR_ARRAY[@]}"; do
    validator_lower=\$(echo "\$validator" | tr '[:upper:]' '[:lower:]')
    if echo "\$committee" | grep -qi "\$validator_lower"; then
      validator_link="[\$validator](https://dashtec.xyz/validators/\$validator)"
      found_validators+=("\$validator_link")
      committee_validators+=("\$validator_lower")
      debug_log "Validator \$validator found in committee"
    fi
  done

  # Если не нашли валидаторов в комитете - выходим
  if [ \${#found_validators[@]} -eq 0 ]; then
    debug_log "No validators found in committee"
    return
  fi
  debug_log "Found validators: \${found_validators[*]}"

  # === Уведомление о включении в комитет (раз за эпоху) ===
  last_epoch_file="$AGENT_SCRIPT_PATH/aztec_last_committee_epoch"
  if [ ! -f "\$last_epoch_file" ] || ! grep -q "\$epoch" "\$last_epoch_file"; then
    current_time=\$(date '+%Y-%m-%d %H:%M:%S')
    echo "\$epoch" > "\$last_epoch_file"
    # Для каждого валидатора создаём отдельное сообщение и отдельное состояние из 32 слотов
    for idx in "\${!committee_validators[@]}"; do
      v_lower="\${committee_validators[\$idx]}"
      v_link="\${found_validators[\$idx]}"
      epoch_state_file="$AGENT_SCRIPT_PATH/epoch_\${epoch}_\${v_lower}_slots_state"
      epoch_msg_file="$AGENT_SCRIPT_PATH/epoch_\${epoch}_\${v_lower}_message_id"
      # initialize 32 empty slots
      slots_arr=()
      for i in {0..31}; do slots_arr+=("⬜️"); done
      board=\$(build_slots_board "\${slots_arr[@]}")
      committee_message="\$(t "committee_selected") (\$(t "epoch_info" "\$epoch"))!%0A"
      committee_message+="%0A\$(t "found_validators" "\$v_link")%0A"
      committee_message+="%0A\$(t "current_slot" "0")%0A"
      committee_message+="%0ASlots:%0A\${board}%0A"
      committee_message+="%0A\$(t "status_legend")%0A"
      committee_message+="\$(t "status_empty")%0A"
      committee_message+="\$(t "status_attestation_sent")%0A"
      committee_message+="\$(t "status_attestation_missed")%0A"
      committee_message+="\$(t "status_block_mined")%0A"
      committee_message+="\$(t "status_block_missed")%0A"
      committee_message+="\$(t "status_block_proposed")%0A"
      committee_message+="%0A\$(t "server_info" "\$ip")%0A"
      committee_message+="\$(t "time_info" "\$current_time")"

      debug_log "Sending committee message for validator \$v_lower: \$committee_message"
      message_id=\$(send_telegram_message_get_id "\$committee_message")
      if [ -n "\$message_id" ] && [ "\$message_id" != "null" ]; then
        echo "\$message_id" > "\$epoch_msg_file"
      fi
      printf "%s " "\${slots_arr[@]}" > "\$epoch_state_file"
      # Очистим файл учета слотов для этого валидатора
      : > "$AGENT_SCRIPT_PATH/aztec_last_committee_slot_\${v_lower}"
    done
    log "Committee selection notification sent for epoch \$epoch: found validators \${found_validators[*]}"
  else
    debug_log "Already notified for epoch \$epoch"
  fi

  # === Уведомление о статусах аттестаций (обновление отдельных сообщений по каждому валидатору) ===
  last_slot_key="\${epoch}_\${slot}"

  # Проверяем, что слот принадлежит текущей эпохе (очищенной при смене эпохи)
  current_epoch=\$(cat "\$last_epoch_file" 2>/dev/null)
  if [ -n "\$current_epoch" ] && [ "\$epoch" != "\$current_epoch" ]; then
    debug_log "Slot \$slot belongs to epoch \$epoch, but current epoch is \$current_epoch - skipping"
    return
  fi

  activity_line=\$(docker logs "\$container_id" --tail 10000 2>&1 | grep -a "Updating L2 slot \$slot observed activity" | tail -n 1)
  if [ -n "\$activity_line" ]; then
    debug_log "Activity line found: \$activity_line"
    activity_json=\$(echo "\$activity_line" | sed 's/.*observed activity //')

    # Обрабатываем каждого валидатора отдельно
    for idx in "\${!committee_validators[@]}"; do
      v_lower="\${committee_validators[\$idx]}"
      v_link="\${found_validators[\$idx]}"

      last_slot_file="$AGENT_SCRIPT_PATH/aztec_last_committee_slot_\${v_lower}"
      # Пропускаем если уже обработали этот слот для данного валидатора
      if [ -f "\$last_slot_file" ] && grep -q "\$last_slot_key" "\$last_slot_file"; then
        debug_log "Already processed slot \$last_slot_key for \$v_lower"
        continue
      fi

      epoch_state_file="$AGENT_SCRIPT_PATH/epoch_\${epoch}_\${v_lower}_slots_state"
      epoch_msg_file="$AGENT_SCRIPT_PATH/epoch_\${epoch}_\${v_lower}_message_id"
      if [ ! -f "\$epoch_state_file" ]; then
        slots_arr=()
        for i in {0..31}; do slots_arr+=("⬜️"); done
        printf "%s " "\${slots_arr[@]}" > "\$epoch_state_file"
      fi
      read -ra slots_arr < "\$epoch_state_file"

      slot_idx=\$((slot % 32))
      slot_icon=""
      if [ -n "\$activity_json" ]; then
        status=\$(echo "\$activity_json" | jq -r ".\"\$v_lower\"")
        if [ "\$status" != "null" ] && [ -n "\$status" ]; then
          case "\$status" in
            block-proposed) slot_icon="🟪" ;;
            block-mined)    slot_icon="🟦" ;;
            block-missed)   slot_icon="🟨" ;;
            attestation-missed) slot_icon="🟥" ;;
            attestation-sent)   slot_icon="🟩" ;;
          esac
        fi
      fi

      if [ -n "\$slot_icon" ]; then
        slots_arr[\$slot_idx]="\$slot_icon"
        printf "%s " "\${slots_arr[@]}" > "\$epoch_state_file"

        board=\$(build_slots_board "\${slots_arr[@]}")
        current_time=\$(date '+%Y-%m-%d %H:%M:%S')
        updated_message="\$(t "committee_selected") (\$(t "epoch_info" "\$epoch"))!%0A"
        updated_message+="%0A\$(t "found_validators" "\$v_link")%0A"
        updated_message+="%0A\$(t "current_slot" "\$slot")%0A"
        updated_message+="%0ASlots:%0A\${board}%0A"
        updated_message+="%0A\$(t "status_legend")%0A"
        updated_message+="\$(t "status_empty")%0A"
        updated_message+="\$(t "status_attestation_sent")%0A"
        updated_message+="\$(t "status_attestation_missed")%0A"
        updated_message+="\$(t "status_block_mined")%0A"
        updated_message+="\$(t "status_block_missed")%0A"
        updated_message+="\$(t "status_block_proposed")%0A"
        updated_message+="%0A\$(t "server_info" "\$ip")%0A"
        updated_message+="\$(t "time_info" "\$current_time")"

        if [ -f "\$epoch_msg_file" ]; then
          message_id=\$(cat "\$epoch_msg_file")
          if [ -n "\$message_id" ]; then
            debug_log "Editing committee message (id=\$message_id) for epoch \$epoch, slot \$slot, validator \$v_lower"
            edit_telegram_message "\$message_id" "\$updated_message"
          else
            debug_log "Message id missing; sending a fallback message"
            send_telegram_message "\$updated_message"
          fi
        else
          debug_log "Message id file not found; sending a fallback message"
          send_telegram_message "\$updated_message"
        fi

        echo "\$last_slot_key" >> "\$last_slot_file"
        debug_log "Updated slot \$slot_idx for epoch \$epoch with icon \$slot_icon for \$v_lower"
        log "Updated committee stats for epoch \$epoch, slot \$slot, validator \$v_lower"
      else
        debug_log "No mapped status for slot \$slot for \$v_lower"
      fi
    done
  else
    debug_log "No activity line found for slot \$slot"
  fi
}

# === Основная функция: проверка контейнера и сравнение блоков ===
check_blocks() {
  debug_log "check_blocks started at \$(date)"

  container_id=\$(docker ps --format "{{.ID}} {{.Names}}" | grep aztec | grep -v watchtower | head -n 1 | awk '{print \$1}')
  if [ -z "\$container_id" ]; then
    log "Container 'aztec' not found."
    current_time=\$(date '+%Y-%m-%d %H:%M:%S')
    message="\$(t "container_not_found")%0A\$(t "server_info" "\$ip")%0A\$(t "time_info" "\$current_time")"
    debug_log "Sending container not found message"
    send_telegram_message "\$message"
    exit 1
  fi
  debug_log "Container found: \$container_id"

  # Проверка критических ошибок
  check_critical_errors "\$container_id"

  # Получаем текущий блок из контракта
  debug_log "Getting block from contract: \$CONTRACT_ADDRESS"
  block_hex=\$(cast call "\$CONTRACT_ADDRESS" "\$FUNCTION_SIG" --rpc-url "\$RPC_URL" 2>&1)
  if [[ "\$block_hex" == *"Error"* || -z "\$block_hex" ]]; then
    log "Block Fetch Error. Check RPC or cast: \$block_hex"
    current_time=\$(date '+%Y-%m-%d %H:%M:%S')
    message="\$(t "block_fetch_error")%0A\$(t "server_info" "\$ip")%0A\$(t "rpc_info" "\$RPC_URL")%0A\$(t "error_info" "\$block_hex")%0A\$(t "time_info" "\$current_time")"
    debug_log "Sending block fetch error message"
    send_telegram_message "\$message"
    exit 1
  fi

  # Конвертируем hex-значение в десятичный
  block_number=\$(hex_to_dec "\$block_hex")
  log "Contract block: \$block_number"

  # Получаем последнюю релевантную строку из логов
  latest_log_line=\$(find_last_log_line "\$container_id")
  debug_log "Latest log line: \$latest_log_line"

  if [ -z "\$latest_log_line" ]; then
    log "No suitable block line found in logs"
    current_time=\$(date '+%Y-%m-%d %H:%M:%S')
    message="\$(t "no_block_in_logs")%0A\$(t "server_info" "\$ip")%0A\$(t "block_info" "\$block_number")%0A\$(t "time_info" "\$current_time")"
    debug_log "Sending no block in logs message"
    send_telegram_message "\$message"
    exit 1
  fi

  # Извлекаем номер блока из найденной строки
  if grep -q 'Sequencer sync check succeeded' <<<"\$latest_log_line"; then
    # формат: ..."worldState":{"number":18254,...
    log_block_number=\$(echo "\$latest_log_line" | grep -o '"worldState":{"number":[0-9]\+' | grep -o '[0-9]\+$')
    debug_log "Extracted from worldState: \$log_block_number"
  else
    # формат: ..."blockNumber":18254,...
    log_block_number=\$(echo "\$latest_log_line" | grep -o '"blockNumber":[0-9]\+' | head -n1 | cut -d':' -f2)
    debug_log "Extracted from blockNumber: \$log_block_number"
  fi

  if [ -z "\$log_block_number" ]; then
    log "Failed to extract blockNumber from line: \$latest_log_line"
    current_time=\$(date '+%Y-%m-%d %H:%M:%S')
    message="\$(t "failed_extract_block")%0A\$(t "server_info" "\$ip")%0A\$(t "line_info" "\$latest_log_line")%0A\$(t "time_info" "\$current_time")"
    debug_log "Sending failed extract block message"
    send_telegram_message "\$message"
    exit 1
  fi

  log "Latest log block: \$log_block_number"

  # Сравниваем блоки
  if [ "\$log_block_number" -eq "\$block_number" ]; then
    status="\$(t "node_synced" "\$block_number")"
  else
    blocks_diff=\$((block_number - log_block_number))
    status="\$(t "node_behind" "\$blocks_diff")"
    if [ "\$blocks_diff" -gt 3 ]; then
      current_time=\$(date '+%Y-%m-%d %H:%M:%S')
      message="\$(t "node_behind" "\$blocks_diff")%0A\$(t "server_info" "\$ip")%0A\$(t "block_info" "\$block_number")%0A\$(t "log_block_info" "\$log_block_number")%0A\$(t "time_info" "\$current_time")"
      debug_log "Sending node behind message, diff=\$blocks_diff"
      send_telegram_message "\$message"
    fi
  fi

  log "Status: \$status (logs: \$log_block_number, contract: \$block_number)"

  if [ ! -f "\$LOG_FILE.initialized" ]; then
    current_time=\$(date '+%Y-%m-%d %H:%M:%S')

    if [ "\$NOTIFICATION_TYPE" -eq 2 ]; then
      # Полные уведомления (все включено)
      message="\$(t "agent_started")%0A\$(t "server_info" "\$ip")%0A\$status%0A\$(t "notifications_full_info")%0A\$(t "time_info" "\$current_time")"
    else
      # Только критические уведомления
      message="\$(t "agent_started")%0A\$(t "server_info" "\$ip")%0A\$status%0A\$(t "notifications_info")%0A\$(t "time_info" "\$current_time")"
    fi

    debug_log "Sending initialization message"
    send_telegram_message "\$message"
    touch "\$LOG_FILE.initialized"
    echo "v.\$VERSION" >> "\$LOG_FILE"
    echo "INITIALIZED" >> "\$LOG_FILE"
  fi

   # Дополнительные проверки (только если NOTIFICATION_TYPE == 2)
  if [ "\$NOTIFICATION_TYPE" -eq 2 ]; then
    debug_log "Starting committee check"
    check_committee
  else
    debug_log "Skipping committee check (NOTIFICATION_TYPE=\$NOTIFICATION_TYPE)"
  fi

  debug_log "check_blocks completed at \$(date)"
}

check_blocks
EOF

  chmod +x "$AGENT_SCRIPT_PATH/agent.sh"

  # Создаем systemd сервис
  cat > /etc/systemd/system/aztec-agent.service <<EOF
[Unit]
Description=Aztec Monitoring Agent
After=network.target

[Service]
Type=oneshot
EnvironmentFile=$env_file
ExecStart=$AGENT_SCRIPT_PATH/agent.sh
User=root
WorkingDirectory=$AGENT_SCRIPT_PATH

[Install]
WantedBy=multi-user.target
EOF

  # Создаем systemd timer
  cat > /etc/systemd/system/aztec-agent.timer <<EOF
[Unit]
Description=Run Aztec Agent every 37 seconds
Requires=aztec-agent.service

[Timer]
OnBootSec=37
OnUnitActiveSec=37
AccuracySec=1us

[Install]
WantedBy=timers.target
EOF

  # Активируем и запускаем timer
  systemctl daemon-reload
  systemctl enable aztec-agent.timer
  systemctl start aztec-agent.timer

  # Проверяем статус
  if systemctl is-active --quiet aztec-agent.timer; then
    echo -e "\n${GREEN}$(t "agent_systemd_added")${NC}"
    echo -e "${GREEN}$(t "agent_timer_status")$(systemctl status aztec-agent.timer --no-pager -q | grep Active)${NC}"
  else
    echo -e "\n${RED}$(t "agent_timer_error")${NC}"
    systemctl status aztec-agent.timer --no-pager
  fi
}

# === Remove cron task and agent ===
remove_cron_agent() {
  echo -e "\n${BLUE}$(t "removing_agent")${NC}"
  crontab -l 2>/dev/null | grep -v "$AGENT_SCRIPT_PATH/agent.sh" | crontab -
  rm -rf "$AGENT_SCRIPT_PATH"
  echo -e "\n${GREEN}$(t "agent_removed")${NC}"
}

# === Remove systemd task and agent ===
remove_systemd_agent() {
  echo -e "\n${BLUE}$(t "removing_systemd_agent")${NC}"
  systemctl stop aztec-agent.timer
  systemctl disable aztec-agent.timer
  rm /etc/systemd/system/aztec-agent.*
  rm -rf "$AGENT_SCRIPT_PATH"
  echo -e "\n${GREEN}$(t "agent_systemd_removed")${NC}"
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
  echo -e "${CYAN}$(t "running_validator_script")${NC}"
  echo -e ""

  # Передаем текущий язык как аргумент
  bash <(curl -s "$URL") "$LANG" || echo -e "${RED}$(t "failed_run_validator")${NC}"
}

# === Install Aztec node ===
function install_aztec {
  URL="https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/install_aztec.sh"
  echo -e ""
  echo -e "${CYAN}$(t "running_install_node")${NC}"
  echo -e ""

  # Временный файл для скрипта
  TEMP_SCRIPT=$(mktemp)

  # Загружаем скрипт
  curl -s "$URL" > "$TEMP_SCRIPT" || {
    echo -e "${RED}$(t "failed_downloading_script")${NC}"
    rm -f "$TEMP_SCRIPT"
    return 1
  }

  # Запускаем с обработкой Ctrl+C и других кодов возврата
  bash "$TEMP_SCRIPT" "$LANG"
  EXIT_CODE=$?

  case $EXIT_CODE in
    0)
      # Успешное выполнение
      echo -e "${GREEN}$(t "install_completed_successfully")${NC}"
      ;;
    1)
      # Ошибка установки
      echo -e "${RED}$(t "failed_running_install_node")${NC}"
      ;;
    130)
      # Ctrl+C - не считаем ошибкой
      echo -e "${YELLOW}$(t "logs_stopped_by_user")${NC}"
      ;;
    2)
      # Пользователь отменил установку из-за занятых портов
      echo -e "${YELLOW}$(t "installation_cancelled_by_user")${NC}"
      ;;
    *)
      # Неизвестная ошибка
      echo -e "${RED}$(t "unknown_error_occurred")${NC}"
      ;;
  esac

  # Удаляем временный файл
  rm -f "$TEMP_SCRIPT"

  return $EXIT_CODE
}

# === Delete Aztec node ===
function delete_aztec() {
    local URL="https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/install_aztec.sh"
    local FUNCTION_NAME="delete_aztec_node"

    # Загружаем скрипт во временную переменную и выполняем функцию
    source <(curl -s "$URL" | sed -n "/^$FUNCTION_NAME()/,/^}/p"; echo "$FUNCTION_NAME")
}

# === Update Aztec node ===
function update_aztec() {
    local URL="https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/install_aztec.sh"
    local FUNCTION_NAME="update_aztec_node"

    # Загружаем скрипт во временную переменную и выполняем функцию
    source <(curl -s "$URL" | sed -n "/^$FUNCTION_NAME()/,/^}/p"; echo "$FUNCTION_NAME")
}

# === Downgrade Aztec node ===
function downgrade_aztec() {
    local URL="https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/install_aztec.sh"
    local FUNCTION_NAME="downgrade_aztec_node"

    # Загружаем скрипт во временную переменную и выполняем функцию
    source <(curl -s "$URL" | sed -n "/^$FUNCTION_NAME()/,/^}/p"; echo "$FUNCTION_NAME")
}


# === Common helper functions ===
function _ensure_env_file() {
  local env_file="$HOME/.env-aztec-agent"
  [[ ! -f "$env_file" ]] && touch "$env_file"
  echo "$env_file"
}

function _update_env_var() {
  local env_file="$1" key="$2" value="$3"
  if grep -q "^$key=" "$env_file"; then
    sed -i "s|^$key=.*|$key=$value|" "$env_file"
  else
    echo "$key=$value" >> "$env_file"
  fi
}

function _read_env_var() {
  local env_file="$1" key="$2"
  grep "^$key=" "$env_file" | cut -d '=' -f2-
}

function _validate_compose_path() {
  local path="$1"
  [[ -d "$path" && -f "$path/docker-compose.yml" ]]
}

# === Stop Aztec containers ===
function stop_aztec_containers() {
  local env_file
  env_file=$(_ensure_env_file)

  local run_type
  run_type=$(_read_env_var "$env_file" "RUN_TYPE")

  case "$run_type" in
    "DOCKER")
      local compose_path
      compose_path=$(_read_env_var "$env_file" "COMPOSE_PATH")

      if ! _validate_compose_path "$compose_path"; then
        read -p "$(t "enter_compose_path")" compose_path
        if _validate_compose_path "$compose_path"; then
          _update_env_var "$env_file" "COMPOSE_PATH" "$compose_path"
        else
          echo -e "${RED}$(t "invalid_path")${NC}"
          return 1
        fi
      fi

      _update_env_var "$env_file" "RUN_TYPE" "DOCKER"

      if cd "$compose_path" && docker compose down; then
        echo -e "${GREEN}$(t "docker_stop_success")${NC}"
      else
        echo -e "${RED}Failed to stop Docker containers${NC}"
        return 1
      fi
      ;;

    "CLI")
      local session_name
      session_name=$(_read_env_var "$env_file" "SCREEN_SESSION")

      if [[ -z "$session_name" ]]; then
        session_name=$(screen -ls | grep aztec | awk '{print $1}')
        # Extract only the alphabetical part (remove numbers and .aztec)
        session_name=$(echo "$session_name" | sed 's/^[0-9]*\.//;s/\.aztec$//')
        if [[ -z "$session_name" ]]; then
          echo -e "${RED}$(t "no_aztec_screen")${NC}"
          return 1
        fi
        _update_env_var "$env_file" "SCREEN_SESSION" "$session_name"
      fi

      _update_env_var "$env_file" "RUN_TYPE" "CLI"

      screen -S "$session_name" -p 0 -X stuff $'\003'
      sleep 2
      screen -S "$session_name" -X quit
      echo -e "${GREEN}$(t "cli_stop_success")${NC}"
      ;;

    *)
      echo -e "\n${YELLOW}$(t "stop_method_prompt")${NC}"
      read -r method

      case "$method" in
        "docker-compose")
          read -p "$(t "enter_compose_path")" compose_path
          if _validate_compose_path "$compose_path"; then
            _update_env_var "$env_file" "COMPOSE_PATH" "$compose_path"
            _update_env_var "$env_file" "RUN_TYPE" "DOCKER"

            cd "$compose_path" || return 1
            docker compose down
            echo -e "${GREEN}$(t "docker_stop_success")${NC}"
          else
            echo -e "${RED}$(t "invalid_path")${NC}"
            return 1
          fi
          ;;

        "cli")
          local session_name
          session_name=$(screen -ls | grep aztec | awk '{print $1}')
          if [[ -n "$session_name" ]]; then
            # Extract only the alphabetical part (remove numbers and .aztec)
            session_name=$(echo "$session_name" | sed 's/^[0-9]*\.//;s/\.aztec$//')
            _update_env_var "$env_file" "SCREEN_SESSION" "$session_name"
            _update_env_var "$env_file" "RUN_TYPE" "CLI"

            screen -S "$session_name" -p 0 -X stuff $'\003'
            sleep 2
            screen -S "$session_name" -X quit
            echo -e "${GREEN}$(t "cli_stop_success")${NC}"
          else
            echo -e "${RED}$(t "no_aztec_screen")${NC}"
            return 1
          fi
          ;;

        *)
          echo -e "${RED}Invalid method. Choose 'docker-compose' or 'cli'.${NC}"
          return 1
          ;;
      esac
      ;;
  esac
}

# === Start Aztec containers ===
function start_aztec_containers() {
  local env_file
  env_file=$(_ensure_env_file)

  echo -e "\n${YELLOW}$(t "starting_node")${NC}"

  local run_type
  run_type=$(_read_env_var "$env_file" "RUN_TYPE")

  if [[ -z "$run_type" ]]; then
    echo -e "${YELLOW}$(t "run_type_not_set")${NC}"
    read -p "$(t "confirm_cli_run") [y/N] " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      run_type="CLI"
      _update_env_var "$env_file" "RUN_TYPE" "$run_type"
      echo -e "${GREEN}$(t "run_type_set_to_cli")${NC}"
    else
      echo -e "${RED}$(t "run_aborted")${NC}"
      return 1
    fi
  fi

  case "$run_type" in
    "DOCKER")
      local compose_path
      compose_path=$(_read_env_var "$env_file" "COMPOSE_PATH")

      if ! _validate_compose_path "$compose_path"; then
        echo -e "${RED}$(t "missing_compose")${NC}"
        read -p "$(t "enter_compose_path")" compose_path
        if ! _validate_compose_path "$compose_path"; then
          echo -e "${RED}$(t "invalid_path")${NC}"
          return 1
        fi
        _update_env_var "$env_file" "COMPOSE_PATH" "$compose_path"
      fi

      if cd "$compose_path" && docker compose up -d; then
        echo -e "${GREEN}$(t "node_started")${NC}"
      else
        echo -e "${RED}Failed to start Docker containers${NC}"
        return 1
      fi
      ;;

    "CLI")
      local p2p_ip
      p2p_ip=$(curl -s https://api.ipify.org || echo "127.0.0.1")

      declare -A vars=(
        ["RPC_URL"]="Ethereum Execution RPC URL"
        ["CONSENSUS_BEACON_URL"]="Consensus Beacon URL"
        ["VALIDATOR_PRIVATE_KEY"]="Validator Private Key (without 0x)"
        ["COINBASE"]="Coinbase (your EVM wallet address)"
        ["P2P_IP"]="$p2p_ip"
      )

      for key in "${!vars[@]}"; do
        if ! grep -q "^$key=" "$env_file"; then
          local prompt="${vars[$key]}"
          local val
          if [[ "$key" == "P2P_IP" ]]; then
            val="$p2p_ip"
          else
            read -p "$prompt: " val
          fi
          _update_env_var "$env_file" "$key" "$val"
        fi
      done

      local ethereum_rpc_url consensus_beacon_url validator_private_key coinbase
      ethereum_rpc_url=$(_read_env_var "$env_file" "RPC_URL")
      consensus_beacon_url=$(_read_env_var "$env_file" "CONSENSUS_BEACON_URL")
      validator_private_key=$(_read_env_var "$env_file" "VALIDATOR_PRIVATE_KEY")
      coinbase=$(_read_env_var "$env_file" "COINBASE")
      p2p_ip=$(_read_env_var "$env_file" "P2P_IP")

      local session_name
      session_name=$(_read_env_var "$env_file" "SCREEN_SESSION")
      [[ -z "$session_name" ]] && session_name="aztec"
      _update_env_var "$env_file" "SCREEN_SESSION" "$session_name"

      # Проверка и удаление существующих сессий с aztec
      existing_sessions=$(screen -ls | grep -oP '[0-9]+\.aztec[^\s]*')
      if [[ -n "$existing_sessions" ]]; then
        while read -r session; do
          screen -XS "$session" quit
          echo -e "${YELLOW}$(t "cli_quit_old_sessions") $session${NC}"
        done <<< "$existing_sessions"
      fi

      if screen -dmS "$session_name" && \
         screen -S "$session_name" -p 0 -X stuff "aztec start --node --archiver --sequencer \
--network testnet \
--l1-rpc-urls $ethereum_rpc_url \
--l1-consensus-host-urls $consensus_beacon_url \
--sequencer.validatorPrivateKeys 0x$validator_private_key \
--sequencer.coinbase $coinbase \
--p2p.p2pIp $p2p_ip"$'\n'; then
        echo -e "${GREEN}$(t "node_started")${NC}"
      else
        echo -e "${RED}Failed to start Aztec in screen session${NC}"
        return 1
      fi
      ;;

    *)
      echo -e "${RED}Unknown RUN_TYPE: $run_type${NC}"
      return 1
      ;;
  esac
}

# === Aztec node version check (via direct JS entrypoint) ===
function check_aztec_version() {

    echo -e "\n${CYAN}$(t "checking_aztec_version")${NC}"
    container_id=$(docker ps --format "{{.ID}} {{.Names}}" \
                   | grep aztec | grep -v watchtower | head -n 1 | awk '{print $1}')

    if [ -z "$container_id" ]; then
        echo -e "${RED}$(t "container_not_found")${NC}"
        return
    fi

    echo -e "${GREEN}$(t "container_found") ${BLUE}$container_id${NC}"

    # Получаем вывод команды и фильтруем только версию
    version_output=$(docker exec "$container_id" node /usr/src/yarn-project/aztec/dest/bin/index.js --version 2>/dev/null)

    # Извлекаем только строку с версией (игнорируем debug/verbose сообщения)
    version=$(echo "$version_output" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+' | tail -n 1)

    # Альтернативный вариант: ищем последнюю строку, которая соответствует формату версии
    if [ -z "$version" ]; then
        version=$(echo "$version_output" | tail -n 1 | grep -E '^[0-9]+\.[0-9]+\.[0-9]+')
    fi

    # Проверяем версию с поддержкой rc версий (например: 2.0.0-rc.27)
    if [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-rc\.[0-9]+)?$ ]]; then
        echo -e "${GREEN}$(t "aztec_node_version") ${BLUE}$version${NC}"
    else
        echo -e "\n${RED}$(t "aztec_version_failed")${NC}"
        echo -e "${YELLOW}$(t "raw_output"):${NC}"
        echo "$version_output"
    fi
}

# === Approve ===
approve_with_all_keys() {
    local rpc_providers=(
        "https://ethereum-sepolia-rpc.publicnode.com"
        "https://1rpc.io/sepolia"
        "https://sepolia.drpc.org"
    )
    local key_files
    local private_key
    local rpc_url

    # Find all YML key files
    key_files=$(find /root/aztec/keys/ -name "*.yml" -type f)
    if [ -z "$key_files" ]; then
        echo "Error: No YML key files found in /root/aztec/keys/"
        return 1
    fi

    # Execute command for each private key sequentially
    for key_file in $key_files; do
        echo "Processing key file: $key_file"

        # Extract private key from YML file
        private_key=$(grep "privateKey:" "$key_file" | awk -F'"' '{print $2}')

        if [ -n "$private_key" ]; then
            echo "Executing with private key from $key_file"

            # Use the first RPC provider from the list
            rpc_url="${rpc_providers[0]}"
            echo "Using RPC URL: $rpc_url"

            # Execute the cast command
            cast send 0x139d2a7a0881e16332d7D1F8DB383A4507E1Ea7A \
                "approve(address,uint256)" \
                "$CONTRACT_ADDRESS" \
                200000ether \
                --private-key "$private_key" \
                --rpc-url "$rpc_url"

            # Wait for completion before proceeding to next key
            wait
        else
            echo "Warning: No privateKey found in $key_file"
        fi
    done
}

# === Generate BLS keys from mnemonic ===
generate_bls_keys() {
    echo -e "\n${BLUE}=== BLS Keys Generation ===${NC}"

    # 1. Запрос мнемонической фразы (скрытый ввод)
    echo -e "\n${CYAN}$(t "bls_mnemonic_prompt")${NC}"
    read -s -p "> " MNEMONIC
    echo  # Переход на новую строку после скрытого ввода

    if [ -z "$MNEMONIC" ]; then
        echo -e "${RED}Error: Mnemonic phrase cannot be empty${NC}"
        return 1
    fi

    # 2. Запрос количества кошельков
    echo -e "\n${CYAN}$(t "bls_wallet_count_prompt")${NC}"
    read -p "> " WALLET_COUNT

    # Валидация числа
    if ! [[ "$WALLET_COUNT" =~ ^[1-9][0-9]*$ ]]; then
        echo -e "${RED}$(t "bls_invalid_number")${NC}"
        return 1
    fi

    # 3. Получение feeRecipient из keystore.json (только первый)
    local KEYSTORE_FILE="/root/aztec/config/keystore.json"

    if [ ! -f "$KEYSTORE_FILE" ]; then
        echo -e "${RED}$(t "bls_keystore_not_found")${NC}"
        return 1
    fi

    local FEE_RECIPIENT_ADDRESS
    FEE_RECIPIENT_ADDRESS=$(grep -o '"feeRecipient": *"[^"]*"' "$KEYSTORE_FILE" | head -n 1 | cut -d'"' -f4)

    if [ -z "$FEE_RECIPIENT_ADDRESS" ]; then
        echo -e "${RED}$(t "bls_fee_recipient_not_found")${NC}"
        return 1
    fi

    echo -e "${GREEN}Found feeRecipient: $FEE_RECIPIENT_ADDRESS${NC}"

    # 4. Генерация BLS ключей
    echo -e "\n${BLUE}$(t "bls_generating_keys")${NC}"

    local BLS_OUTPUT_FILE="$HOME/aztec/config/bls.json"
    local BLS_FILTERED_FILE="$HOME/aztec/config/bls-filtered.json"
    local BLS_FILTERED_PK_FILE="$HOME/aztec/config/bls-filtered-pk.json"

    # Временный файл для результатов генерации
    local TEMP_OUTPUT=$(mktemp)

    # Выполнение команды генерации и сохранение вывода (очищаем от \r)
    echo -e "${YELLOW}Running command: aztec validator-keys new...${NC}"
    if aztec validator-keys new \
        --fee-recipient "$FEE_RECIPIENT_ADDRESS" \
        --mnemonic "$MNEMONIC" \
        --count "$WALLET_COUNT" \
        --file "bls.json" \
        --data-dir "$HOME/aztec/config/" 2>&1 | tee "$TEMP_OUTPUT"; then

        echo -e "${GREEN}$(t "bls_generation_success")${NC}"
    else
        echo -e "${RED}$(t "bls_generation_failed")${NC}"
        rm -f "$TEMP_OUTPUT"
        return 1
    fi

    # 5. Проверка существования сгенерированного файла
    if [ ! -f "$BLS_OUTPUT_FILE" ]; then
        echo -e "${RED}$(t "bls_file_not_found")${NC}"
        rm -f "$TEMP_OUTPUT"
        return 1
    fi

    # 6. Поиск совпадений и создание отфильтрованного файла
    echo -e "\n${BLUE}$(t "bls_searching_matches")${NC}"

    # Создаем пустой файл для отфильтрованных результатов
    echo "{" > "$BLS_FILTERED_FILE"
    local FIRST_ENTRY=true
    local MATCH_COUNT=0

    # Получаем все адреса из keystore.json в нижнем регистре
    local KEYSTORE_ADDRESSES=$(grep -o '"0x[0-9a-fA-F]\+"' "$KEYSTORE_FILE" | tr '[:upper:]' '[:lower:]' | tr -d '"')

    # Создаем очищенную версию временного файла без \r
    local TEMP_CLEAN=$(mktemp)
    sed 's/\r//g' "$TEMP_OUTPUT" > "$TEMP_CLEAN"

    # Простой и надежный парсинг - ищем пары accX + eth адрес + bls ключ
    local CURRENT_ACC=""
    local CURRENT_ETH=""
    local CURRENT_BLS=""

    while IFS= read -r line; do
        # Ищем начало аккаунта
        if [[ "$line" =~ ^(acc[0-9]+):$ ]]; then
            CURRENT_ACC="${BASH_REMATCH[1]}"
            CURRENT_ETH=""
            CURRENT_BLS=""

        # Ищем eth адрес
        elif [[ "$line" =~ ^[[:space:]]+eth:[[:space:]]+(0x[0-9a-fA-F]+) ]]; then
            CURRENT_ETH="${BASH_REMATCH[1],,}"  # Приводим к нижнему регистру

        # Ищем BLS ключ
        elif [[ "$line" =~ ^[[:space:]]+bls:[[:space:]]+(0x[0-9a-fA-F]+) ]]; then
            CURRENT_BLS="${BASH_REMATCH[1]}"

            # Когда нашли все три компонента, проверяем совпадение
            if [[ -n "$CURRENT_ACC" && -n "$CURRENT_ETH" && -n "$CURRENT_BLS" ]]; then
                # Проверяем совпадение адреса
                if echo "$KEYSTORE_ADDRESSES" | grep -q "^${CURRENT_ETH}$"; then
                    ((MATCH_COUNT++))

                    # Добавляем в отфильтрованный файл
                    if [ "$FIRST_ENTRY" = true ]; then
                        FIRST_ENTRY=false
                    else
                        echo "," >> "$BLS_FILTERED_FILE"
                    fi

                    # Сохраняем блок аккаунта
                    echo "  \"$CURRENT_ACC\": {" >> "$BLS_FILTERED_FILE"
                    echo "    \"attester\": {" >> "$BLS_FILTERED_FILE"
                    echo "      \"eth\": \"$CURRENT_ETH\"," >> "$BLS_FILTERED_FILE"
                    echo "      \"bls\": \"$CURRENT_BLS\"" >> "$BLS_FILTERED_FILE"
                    echo "    }" >> "$BLS_FILTERED_FILE"
                    echo "  }" >> "$BLS_FILTERED_FILE"
                fi

                # Сбрасываем для следующего аккаунта
                CURRENT_ACC=""
                CURRENT_ETH=""
                CURRENT_BLS=""
            fi
        fi
    done < "$TEMP_CLEAN"

    echo "}" >> "$BLS_FILTERED_FILE"

    # Очистка временных файлов
    rm -f "$TEMP_OUTPUT"
    rm -f "$TEMP_CLEAN"

    # 7. Отчет о результатах
    if [ $MATCH_COUNT -gt 0 ]; then
        echo -e "${GREEN}$(printf "$(t "bls_matches_found")" "$MATCH_COUNT")${NC}"
        echo -e "${GREEN}$(printf "$(t "bls_filtered_file_created")" "$BLS_FILTERED_FILE")${NC}"

        # 8. Генерация приватных ключей для найденных аккаунтов
        echo -e "\n${BLUE}Generating private keys for matched accounts...${NC}"

        # Получаем список аккаунтов из отфильтрованного файла
        local ACCOUNTS=$(jq -r 'keys[]' "$BLS_FILTERED_FILE" 2>/dev/null)
        local FIRST_ACCOUNT=true

        for acc in $ACCOUNTS; do
            # Извлекаем номер из acc (убираем "acc")
            local ACC_NUMBER=${acc#acc}

            # Вычисляем address-index (номер аккаунта - 1)
            local ADDRESS_IDX=$((ACC_NUMBER - 1))

            echo -e "${YELLOW}Processing $acc (address-index: $ADDRESS_IDX)...${NC}"

            if [ "$FIRST_ACCOUNT" = true ]; then
                # Для первого аккаунта используем команду new
                echo -e "${CYAN}Running: aztec validator-keys new (first account)${NC}"
                if aztec validator-keys new \
                    --fee-recipient "$FEE_RECIPIENT_ADDRESS" \
                    --mnemonic "$MNEMONIC" \
                    --address-index "$ADDRESS_IDX" \
                    --file "bls-filtered-pk.json" \
                    --data-dir "$HOME/aztec/config/"; then

                    echo -e "${GREEN}✓ Successfully generated keys for $acc${NC}"
                    FIRST_ACCOUNT=false
                else
                    echo -e "${RED}✗ Failed to generate keys for $acc${NC}"
                    return 1
                fi
            else
                # Для последующих аккаунтов используем команду add
                echo -e "${CYAN}Running: aztec validator-keys add (additional account)${NC}"
                if aztec validator-keys add "$HOME/aztec/config/bls-filtered-pk.json" \
                    --fee-recipient "$FEE_RECIPIENT_ADDRESS" \
                    --mnemonic "$MNEMONIC" \
                    --address-index "$ADDRESS_IDX" ; then

                    echo -e "${GREEN}✓ Successfully added keys for $acc${NC}"
                else
                    echo -e "${RED}✗ Failed to add keys for $acc${NC}"
                    return 1
                fi
            fi

            # Проверяем что файл создан/обновлен
            if [ ! -f "$BLS_FILTERED_PK_FILE" ]; then
                echo -e "${RED}✗ Private keys file was not created: $BLS_FILTERED_PK_FILE${NC}"
                return 1
            fi
        done

        # Финальный отчет
        echo -e "\n${GREEN}✅ Successfully generated private keys for all $MATCH_COUNT matched accounts${NC}"
        echo -e "${GREEN}📁 Private keys saved to: $BLS_FILTERED_PK_FILE${NC}"
		rm -f "$BLS_OUTPUT_FILE"
		rm -f "$BLS_FILTERED_FILE"

    else
        echo -e "${RED}$(t "bls_no_matches")${NC}"
        rm -f "$BLS_FILTERED_FILE"
        return 1
    fi

    return 0
}

# === Stake validators ===
stake_validators() {
    echo -e "\n${BLUE}=== $(t "staking_title") ===${NC}"

    # Проверяем существование необходимых файлов
    local KEYSTORE_FILE="/root/aztec/config/keystore.json"
    local BLS_PK_FILE="/root/aztec/config/bls-filtered-pk.json"

    if [ ! -f "$KEYSTORE_FILE" ]; then
        printf "${RED}❌ $(t "file_not_found")${NC}\n" \
         "keystore.json" "$KEYSTORE_FILE"
        return 1
    fi

    if [ ! -f "$BLS_PK_FILE" ]; then
        printf "${RED}❌ $(t "file_not_found")${NC}\n" \
         "bls-filtered-pk.json" "$BLS_PK_FILE"
        return 1
    fi

    # Получаем количество валидаторов
    local VALIDATOR_COUNT=$(jq -r '.validators | length' "$BLS_PK_FILE" 2>/dev/null)
    if [ -z "$VALIDATOR_COUNT" ] || [ "$VALIDATOR_COUNT" -eq 0 ]; then
        echo -e "${RED}❌ $(t "staking_no_validators") $BLS_PK_FILE${NC}"
        return 1
    fi

    printf  "${GREEN}$(t "staking_found_validators")${NC}\n" \
	 "$VALIDATOR_COUNT"
	 echo ""

    # Список RPC провайдеров
    local rpc_providers=(
        "https://ethereum-sepolia-rpc.publicnode.com"
        "https://1rpc.io/sepolia"
        "https://sepolia.drpc.org"
    )

    # Используем глобальную переменную контракта
    if [ -z "$CONTRACT_ADDRESS" ]; then
        echo -e "${RED}❌ $(t "contract_not_set")${NC}"
        return 1
    fi

    printf "${YELLOW}$(t "using_contract_address")${NC}\n" \
	 "$CONTRACT_ADDRESS"
	 echo ""

    # Цикл по всем валидаторам
    for ((i=0; i<VALIDATOR_COUNT; i++)); do
        printf "\n${BLUE}=== $(t "staking_processing") ===${NC}\n" \
		 "$((i+1))" "$VALIDATOR_COUNT"
		 echo ""

        # Из BLS файла берем приватные ключи
        local PRIVATE_KEY_OF_OLD_SEQUENCER=$(jq -r ".validators[$i].attester.eth" "$BLS_PK_FILE" 2>/dev/null)
        local BLS_ATTESTER_PRIV_KEY=$(jq -r ".validators[$i].attester.bls" "$BLS_PK_FILE" 2>/dev/null)

        # Из keystore файла берем Ethereum адреса
        local ETH_ATTESTER_ADDRESS=$(jq -r ".validators[$i].attester" "$KEYSTORE_FILE" 2>/dev/null)

        # Проверяем что все данные получены
        if [ -z "$PRIVATE_KEY_OF_OLD_SEQUENCER" ] || [ "$PRIVATE_KEY_OF_OLD_SEQUENCER" = "null" ]; then
            printf "${RED}❌ $(t "staking_failed_private_key")${NC}\n" \
            "$((i+1))"
            continue
        fi

        if [ -z "$ETH_ATTESTER_ADDRESS" ] || [ "$ETH_ATTESTER_ADDRESS" = "null" ]; then
            printf "${RED}❌ $(t "staking_failed_eth_address")${NC}\n" \
            "$((i+1))"
            continue
        fi

        if [ -z "$BLS_ATTESTER_PRIV_KEY" ] || [ "$BLS_ATTESTER_PRIV_KEY" = "null" ]; then
            printf "${RED}❌ $(t "staking_failed_bls_key")${NC}\n" \
            "$((i+1))"
            continue
        fi

        echo -e "${GREEN}✓ $(t "staking_data_loaded")${NC}"
        echo -e "  $(t "eth_address"): $ETH_ATTESTER_ADDRESS"
        echo -e "  $(t "private_key"): ${PRIVATE_KEY_OF_OLD_SEQUENCER:0:10}..."
        echo -e "  $(t "bls_key"): ${BLS_ATTESTER_PRIV_KEY:0:20}..."

        # Цикл по RPC провайдерам
        local success=false
        for rpc_url in "${rpc_providers[@]}"; do
            printf "\n${YELLOW}$(t "staking_trying_rpc")${NC}\n" \
			      "$rpc_url"
			 echo ""

            # Формируем команду
            local cmd="aztec add-l1-validator \\
  --l1-rpc-urls \"$rpc_url\" \\
  --network testnet \\
  --private-key \"$PRIVATE_KEY_OF_OLD_SEQUENCER\" \\
  --attester \"$ETH_ATTESTER_ADDRESS\" \\
  --withdrawer \"$ETH_ATTESTER_ADDRESS\" \\
  --bls-secret-key \"$BLS_ATTESTER_PRIV_KEY\" \\
  --rollup \"$CONTRACT_ADDRESS\""

            # Показываем команду с частичными приватными ключами (первые 7 символов)
            local PRIVATE_KEY_PREVIEW="${PRIVATE_KEY_OF_OLD_SEQUENCER:0:7}..."
            local BLS_KEY_PREVIEW="${BLS_ATTESTER_PRIV_KEY:0:7}..."

            local safe_cmd="aztec add-l1-validator \\
  --l1-rpc-urls \"$rpc_url\" \\
  --network testnet \\
  --private-key \"$PRIVATE_KEY_PREVIEW\" \\
  --attester \"$ETH_ATTESTER_ADDRESS\" \\
  --withdrawer \"$ETH_ATTESTER_ADDRESS\" \\
  --bls-secret-key \"$BLS_KEY_PREVIEW\" \\
  --rollup \"$CONTRACT_ADDRESS\""

            echo -e "${CYAN}$(t "command_to_execute")${NC}"
            echo -e "$safe_cmd"

            # Запрос подтверждения
            echo -e "\n${YELLOW}$(t "staking_command_prompt")${NC}"
            read -p "$(t "staking_execute_prompt"): " confirm

            case "$confirm" in
                [yY])
                    echo -e "${GREEN}$(t "staking_executing")${NC}"

                    # Выполняем команду
                    if eval "$cmd"; then
                        printf "${GREEN}✅ $(t "staking_success")${NC}\n" \
						            "$((i+1))" "$rpc_url"
						 echo ""

                        success=true
                        break  # Переходим к следующему валидатору
                    else
                        printf "${RED}❌ $(t "staking_failed")${NC}\n" \
						 "$((i+1))" "$rpc_url"
						 echo ""
                        echo -e "${YELLOW}$(t "trying_next_rpc")${NC}"
                    fi
                    ;;
                [sS])
                    printf "${YELLOW}⏭️ $(t "staking_skipped_validator")${NC}\n" \
                     "$((i+1))"
                    success=true  # Помечаем как "успех" чтобы перейти к следующему
                    break
                    ;;
                [qQ])
                    echo -e "${YELLOW}🛑 $(t "staking_cancelled")${NC}"
                    return 0
                    ;;
                *)
                    echo -e "${YELLOW}⏭️ $(t "staking_skipped_rpc")${NC}"
                    ;;
            esac
        done

        if [ "$success" = false ]; then
            printf "${RED}❌ $(t "staking_all_failed")${NC}\n" \
			 "$((i+1))"
			 echo ""
            echo -e "${YELLOW}$(t "continuing_next_validator")${NC}"
        fi

        # Небольшая пауза между валидаторами
        if [ $i -lt $((VALIDATOR_COUNT-1)) ]; then
            echo -e "\n${BLUE}--- $(t "waiting_before_next_validator") ---${NC}"
            sleep 2
        fi
    done

    echo -e "\n${GREEN}✅ $(t "staking_completed")${NC}"
    return 0
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
    echo -e "${CYAN}$(t "option18")${NC}"
    echo -e "${CYAN}$(t "option19")${NC}"
    echo -e "${CYAN}$(t "option20")${NC}"
    echo -e "${RED}$(t "option0")${NC}"
    echo -e "${BLUE}================================${NC}"

    read -p "$(t "choose_option") " choice

    case "$choice" in
      1) check_aztec_container_logs ;;
      2) create_systemd_agent ;;
      3) remove_systemd_agent ;;
      4) find_rollup_address ;;
      5) find_peer_id ;;
      6) find_governance_proposer_payload ;;
      7) check_proven_block ;;
      8) change_rpc_url ;;
      9) check_validator ;;
      10) view_container_logs ;;
      11) install_aztec ;;
      12) delete_aztec ;;
      13) stop_aztec_containers ;;
      14) start_aztec_containers ;;
      15) update_aztec ;;
      16) downgrade_aztec ;;
      17) check_aztec_version ;;
      18) generate_bls_keys ;;
      19) approve_with_all_keys ;;
      20) stake_validators ;;
      0) echo -e "\n${GREEN}$(t "goodbye")${NC}"; exit 0 ;;
      *) echo -e "\n${RED}$(t "invalid_choice")${NC}" ;;
    esac
  done
}

# === Script launch ===
init_languages
check_dependencies
main_menu
