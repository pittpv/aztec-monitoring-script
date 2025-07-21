#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
VIOLET='\033[0;35m'
NC='\033[0m' # No Color

SCRIPT_VERSION="1.9.1"

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
  TRANSLATIONS["en,option1"]="1. Check container and current block"
  TRANSLATIONS["en,option2"]="2. Install cron monitoring agent"
  TRANSLATIONS["en,option3"]="3. Remove cron agent and files"
  TRANSLATIONS["en,option4"]="4. Find rollupAddress in logs"
  TRANSLATIONS["en,option5"]="5. Find PeerID in logs and Nethermind.io"
  TRANSLATIONS["en,option6"]="6. Find governanceProposerPayload in logs"
  TRANSLATIONS["en,option7"]="7. Check Proven L2 Block and Sync Proof"
  TRANSLATIONS["en,option8"]="8. Change RPC URL"
  TRANSLATIONS["en,option9"]="9. Search for validator and check status"
  TRANSLATIONS["en,option10"]="10. View Aztec logs"
  TRANSLATIONS["en,option11"]="11. Install Aztec Node with Watchtower"
  TRANSLATIONS["en,option12"]="12. Delete Aztec node"
  TRANSLATIONS["en,option13"]="13. Stop Aztec node containers"
  TRANSLATIONS["en,option14"]="14. Start Aztec node containers"
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
  TRANSLATIONS["en,new_version_update"]="Please update your script and cron agent"
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
  TRANSLATIONS["en,delete_node"]="🗑️ Deleting Aztec Node..."
  TRANSLATIONS["en,delete_confirm"]="Are you sure you want to delete the Aztec node? This will stop containers and remove all data. (y/n) "
  TRANSLATIONS["en,node_deleted"]="✅ Aztec node successfully deleted"
  TRANSLATIONS["en,delete_canceled"]="✖ Node deletion canceled"
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
  TRANSLATIONS["en,notifications_option1"]="1. Critical errors only (recommended)"
  TRANSLATIONS["en,notifications_option2"]="2. All notifications (including committee participation and block creation)"
  TRANSLATIONS["en,notifications_debug_warning"]="DEBUG log level is required for committee and block creation notifications"
  TRANSLATIONS["en,notifications_input_error"]="Error: please enter 1 or 2"
  TRANSLATIONS["en,choose_option_prompt"]="Choose option"
  TRANSLATIONS["en,committee_selected"]="🎉 You've been selected for the committee"
  TRANSLATIONS["en,epoch_info"]="Epoch %s"
  TRANSLATIONS["en,block_built"]="✅ Block %s successfully built"
  TRANSLATIONS["en,slot_info"]="🧩 Slot: %s"
  TRANSLATIONS["en,agent_notifications_full_info"]="ℹ️ Notifications will be sent for issues, committee, blocks"
  TRANSLATIONS["en,fetching_peer_info"]="Fetching peer information from API..."
  TRANSLATIONS["en,peer_found"]="Peer ID found in logs"
  TRANSLATIONS["en,peer_not_in_list"]="Peer not found in the public peers list"
  TRANSLATIONS["en,peer_id_not_critical"]="The presence or absence of a Peer ID in Nethermind.io is not a critical parameter. The data may be outdated."
  TRANSLATIONS["en,cli_quit_old_sessions"]="Closed existing session:"


  # Russian translations
  TRANSLATIONS["ru,welcome"]="Добро пожаловать в скрипт мониторинга ноды Aztec"
  TRANSLATIONS["ru,title"]="========= Главное меню ========="
  TRANSLATIONS["ru,option1"]="1. Проверить контейнер и актуальный блок"
  TRANSLATIONS["ru,option2"]="2. Установить cron-агент для мониторинга"
  TRANSLATIONS["ru,option3"]="3. Удалить cron-агент и файлы"
  TRANSLATIONS["ru,option4"]="4. Найти адрес rollupAddress в логах"
  TRANSLATIONS["ru,option5"]="5. Найти PeerID в логах и Nethermind.io"
  TRANSLATIONS["ru,option6"]="6. Найти governanceProposerPayload в логах"
  TRANSLATIONS["ru,option7"]="7. Проверить Proven L2 блок и Sync Proof"
  TRANSLATIONS["ru,option8"]="8. Изменить RPC URL"
  TRANSLATIONS["ru,option9"]="9. Поиск валидатора и проверка статуса"
  TRANSLATIONS["ru,option10"]="10. Просмотреть логи Aztec"
  TRANSLATIONS["ru,option11"]="11. Установить Aztec ноду с Watchtower"
  TRANSLATIONS["ru,option12"]="12. Удалить ноду Aztec"
  TRANSLATIONS["ru,option13"]="13. Остановить контейнеры ноды Aztec"
  TRANSLATIONS["ru,option14"]="14. Запустить контейнеры ноды Aztec"
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
  TRANSLATIONS["ru,new_version_update"]="Пожалуйста, обновите скрипт и cron-агента"
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
  TRANSLATIONS["ru,delete_node"]="🗑️ Удаление ноды Aztec..."
  TRANSLATIONS["ru,delete_confirm"]="Вы уверены, что хотите удалить ноду Aztec? Это остановит контейнеры и удалит все данные. (y/n) "
  TRANSLATIONS["ru,node_deleted"]="✅ Нода Aztec успешно удалена"
  TRANSLATIONS["ru,delete_canceled"]="✖ Удаление ноды отменено"
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
  TRANSLATIONS["ru,notifications_option1"]="1. Только критические ошибки (рекомендуется)"
  TRANSLATIONS["ru,notifications_option2"]="2. Все уведомления (включая попадание в комитет и создание блоков)"
  TRANSLATIONS["ru,notifications_debug_warning"]="Для получения уведомлений о попадании в комитет и создании блоков требуется уровень логов DEBUG"
  TRANSLATIONS["ru,notifications_input_error"]="Ошибка: введите 1 или 2"
  TRANSLATIONS["ru,choose_option_prompt"]="Выберите вариант"
  TRANSLATIONS["ru,committee_selected"]="🎉 Тебя выбрали в комитет"
  TRANSLATIONS["ru,epoch_info"]="Эпоха %s"
  TRANSLATIONS["ru,block_built"]="✅ Блок %s успешно построен"
  TRANSLATIONS["ru,slot_info"]="🧩 Слот: %s"
  TRANSLATIONS["ru,agent_notifications_full_info"]="ℹ️ Уведомления будут отправляться при проблемах, выборе в комитет, создании блоков"
  TRANSLATIONS["ru,fetching_peer_info"]="Получение информации о пире из API..."
  TRANSLATIONS["ru,peer_found"]="Peer ID найден в логах"
  TRANSLATIONS["ru,peer_not_in_list"]="Пир не найден в публичном списке"
  TRANSLATIONS["ru,peer_id_not_critical"]="Наличие или отсутствие Peer ID в Nethermind.io не является критично важным параметром. Данные могут быть неактуальными."
  TRANSLATIONS["ru,cli_quit_old_sessions"]="Закрыта старая сессия:"


  # Turkish translations
  TRANSLATIONS["tr,welcome"]="Aztec düğüm izleme betiğine hoş geldiniz"
  TRANSLATIONS["tr,title"]="========= Ana Menü ========="
  TRANSLATIONS["tr,option1"]="1. Konteyner ve mevcut bloğu kontrol et"
  TRANSLATIONS["tr,option2"]="2. Cron izleme aracısını yükle"
  TRANSLATIONS["tr,option3"]="3. Cron aracısını ve dosyaları kaldır"
  TRANSLATIONS["tr,option4"]="4. Loglarda rollupAddress bul"
  TRANSLATIONS["tr,option5"]="5. Loglarda ve Nethermind.io PeerID bul"
  TRANSLATIONS["tr,option6"]="6. Loglarda governanceProposerPayload bul"
  TRANSLATIONS["tr,option7"]="7. Kanıtlanmış L2 Bloğunu ve Sync Proof'u Kontrol Et"
  TRANSLATIONS["tr,option8"]="8. RPC URL'sini değiştir"
  TRANSLATIONS["tr,option9"]="9. Validator ara ve durumunu kontrol et"
  TRANSLATIONS["tr,option10"]="10. Aztec loglarını görüntüle"
  TRANSLATIONS["tr,option11"]="11. Watchtower ile birlikte Aztec Node Kurulumu"
  TRANSLATIONS["tr,option12"]="12. Aztec düğümünü sil"
  TRANSLATIONS["tr,option13"]="13. Aztec düğüm konteynerlerini durdur"
  TRANSLATIONS["tr,option14"]="14. Aztec düğüm konteynerlerini başlat"
  TRANSLATIONS["tr,option0"]="0. Çıkış"
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
  TRANSLATIONS["tr,agent_added"]="✅ Aracı cron'a eklendi ve her dakika çalışacak."
  TRANSLATIONS["tr,agent_exists"]="ℹ️ Aracı zaten cron'da mevcut."
  TRANSLATIONS["tr,removing_agent"]="🗑 Aracı ve cron görevi kaldırılıyor..."
  TRANSLATIONS["tr,agent_removed"]="✅ Aracı ve cron görevi kaldırıldı."
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
  TRANSLATIONS["tr,new_version_update"]="Lütfen betiğinizi ve cron aracısını güncelleyin"
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
  TRANSLATIONS["tr,delete_node"]="🗑️ Aztec Node siliniyor..."
  TRANSLATIONS["tr,delete_confirm"]="Aztec node'u silmek istediğinize emin misiniz? Bu işlem konteynerleri durduracak ve tüm verileri silecektir. (y/n) "
  TRANSLATIONS["tr,node_deleted"]="✅ Aztec node başarıyla silindi"
  TRANSLATIONS["tr,delete_canceled"]="✖ Node silme işlemi iptal edildi"
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
  TRANSLATIONS["tr,notifications_option1"]="1. Sadece kritik hatalar (tavsiye edilen)"
  TRANSLATIONS["tr,notifications_option2"]="2. Tüm bildirimler (komite katılımı ve blok oluşturma dahil)"
  TRANSLATIONS["tr,notifications_debug_warning"]="Komite ve blok oluşturma bildirimleri için DEBUG log seviyesi gereklidir"
  TRANSLATIONS["tr,notifications_input_error"]="Hata: lütfen 1 veya 2 girin"
  TRANSLATIONS["tr,choose_option_prompt"]="Seçenek belirleyin"
  TRANSLATIONS["tr,committee_selected"]="🎉 Komiteye seçildiniz"
  TRANSLATIONS["tr,epoch_info"]="Dönem %s"
  TRANSLATIONS["tr,block_built"]="✅ %s bloğu başarıyla oluşturuldu"
  TRANSLATIONS["tr,slot_info"]="🧩 Slot: %s"
  TRANSLATIONS["tr,agent_notifications_full_info"]="ℹ️ Sorunlar, komite ve bloklar için bildirimler gönderilecek"
  TRANSLATIONS["tr,fetching_peer_info"]="API'den eş (peer) bilgisi alınıyor..."
  TRANSLATIONS["tr,peer_found"]="Loglarda Peer ID bulundu"
  TRANSLATIONS["tr,peer_not_in_list"]="Eş, genel listede bulunamadı"
  TRANSLATIONS["tr,peer_id_not_critical"]="Nethermind.io'da Peer ID'nin olup olmaması kritik bir parametre değildir. Veriler güncel olmayabilir."
  TRANSLATIONS["tr,cli_quit_old_sessions"]="Eski oturum kapatıldı:"

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

  # Создаем ассоциативный массив для отображения имен
  declare -A tool_names=(
    ["cast"]="foundry"
    ["curl"]="curl"
    ["crontab"]="cron"
    ["grep"]="grep"
    ["sed"]="sed"
    ["jq"]="jq"
    ["bc"]="bc"
  )

  for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
      # Используем отображаемое имя из массива или оригинальное имя, если нет соответствия
      display_name=${tool_names[$tool]:-$tool}
      echo -e "${RED}❌ $display_name $(t "not_installed")${NC}"
      missing+=("$tool")
    else
      display_name=${tool_names[$tool]:-$tool}
      echo -e "${GREEN}✅ $display_name $(t "installed")${NC}"
    fi
  done

  if [ ${#missing[@]} -gt 0 ]; then
    # Преобразуем имена для отображения в списке отсутствующих инструментов
    missing_display=()
    for tool in "${missing[@]}"; do
      missing_display+=("${tool_names[$tool]:-$tool}")
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
            ["ERROR: cli Error: World state trees are out of sync, please delete your data directory and re-sync"]="1. Stop the node container. Use option 13\n2. Delete data from the folder: sudo rm -rf /root/.aztec/alpha-testnet/data/\n3. Run the container. Use option 14"
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

# find_peer_id() {
  # echo -e "\n${BLUE}$(t "search_peer")${NC}"

  # container_id=$(docker ps --format "{{.ID}} {{.Names}}" | grep aztec | grep -v watchtower | head -n 1 | awk '{print $1}')

  # if [ -z "$container_id" ]; then
    # echo -e "\n${RED}$(t "container_not_found")${NC}"
    # return 1
  # fi

  # echo -e "\n${CYAN}$(t "peers_found")${NC}"

  # # Фоновый процесс для поиска peerId
  # _find_peer_id_worker() {
    # sudo docker logs "$container_id" 2>&1 | \
      # grep -i "peerId" | \
      # grep -o '"peerId":"[^"]*"' | \
      # cut -d'"' -f4 | \
      # head -n 1 > /tmp/peer_id.tmp
  # }

  # _find_peer_id_worker &
  # worker_pid=$!
  # spinner $worker_pid
  # wait $worker_pid

  # peer_id=$(< /tmp/peer_id.tmp)
  # rm -f /tmp/peer_id.tmp

  # if [ -z "$peer_id" ]; then
    # echo -e "${RED}$(t "peer_not_found")${NC}"
    # return 1
  # else
    # echo "$peer_id"
    # return 0
  # fi
# }

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

    # Получаем JSON с информацией о пирах
    echo -e "\n${CYAN}$(t "fetching_peer_info")${NC}"
    peers_json=$(curl -s "https://aztec.nethermind.io/api/peers?page_size=30000&latest=true")

    # Ищем информацию о нашем пире
    peer_info=$(echo "$peers_json" | jq -r --arg peer_id "$peer_id" '.peers[] | select(.id == $peer_id)')

    if [ -z "$peer_info" ]; then
      echo -e "${YELLOW}$(t "peer_not_in_list")${NC}"
	  echo -e "\n$(t "peer_id_not_critical")"
      return 1
    else
      # Извлекаем данные из JSON
      created_at=$(echo "$peer_info" | jq -r '.created_at')
      last_seen=$(echo "$peer_info" | jq -r '.last_seen')
      client=$(echo "$peer_info" | jq -r '.client')
      country=$(echo "$peer_info" | jq -r '.multi_addresses[0].ip_info[0].country_name')
      city=$(echo "$peer_info" | jq -r '.multi_addresses[0].ip_info[0].city_name')
      latitude=$(echo "$peer_info" | jq -r '.multi_addresses[0].ip_info[0].latitude')
      longitude=$(echo "$peer_info" | jq -r '.multi_addresses[0].ip_info[0].longitude')

      # Выводим информацию в красивом виде
      echo -e "\n${GREEN}=== Peer Information ===${NC}"
      echo -e "${BLUE}Peer ID:${NC} $peer_id"
      echo -e "${BLUE}Client Version:${NC} $client"
      echo -e "${BLUE}Created At:${NC} $created_at"
      echo -e "${BLUE}Last Seen:${NC} $last_seen"
      echo -e "${BLUE}Location:${NC} $city, $country"
      echo -e "${BLUE}Coordinates:${NC} $latitude, $longitude"

	  echo -e "\n$(t "peer_id_not_critical")"

      return 0
    fi
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


# === Новые функции для проверки комитета и создания блоков ===
check_committee() {
  if [ "\$NOTIFICATION_TYPE" -ne 2 ]; then return; fi

  container_id=\$(docker ps --format "{{.ID}} {{.Names}}" | grep aztec | grep -v watchtower | head -n 1 | awk '{print \$1}')
  if [ -z "\$container_id" ]; then return; fi

  committee_line=\$(docker logs "\$container_id" --tail 10000 2>&1 | grep -i "is on the validator committee for epoch" | tail -n 1)
  if [ -z "\$committee_line" ]; then return; fi

  # извлекаем номер эпохи
  epoch=\$(echo "\$committee_line" | grep -oE 'epoch [0-9]+' | awk '{print \$2}')
  if [ -z "\$epoch" ]; then return; fi

  last_epoch_file="$AGENT_SCRIPT_PATH/aztec_last_committee_epoch"
  if [ -f "\$last_epoch_file" ] && grep -q "\$epoch" "\$last_epoch_file"; then return; fi
  echo "\$epoch" > "\$last_epoch_file"

  current_time=\$(date '+%Y-%m-%d %H:%M:%S')
  message="\$(t "committee_selected") (\$(t "epoch_info" "\$epoch"))!%0A\$(t "server_info" "\$ip")%0A\$(t "time_info" "\$current_time")"
  send_telegram_message "\$message"
  log "Committee notification sent: \$committee_line"
}

check_block_built() {
  if [ "\$NOTIFICATION_TYPE" -ne 2 ]; then return; fi

  container_id=\$(docker ps --format "{{.ID}} {{.Names}}" | grep aztec | grep -v watchtower | head -n 1 | awk '{print \$1}')
  if [ -z "\$container_id" ]; then return; fi

  log_line=\$(docker logs "\$container_id" --tail 10000 2>&1 | grep "Built block" | grep "with" | grep "INFO: sequencer" | tail -n 1)
  if [ -z "\$log_line" ]; then return; fi

  block_number=\$(echo "\$log_line" | grep -oE 'block [0-9]+' | awk '{print \$2}')
  slot_number=\$(echo "\$log_line" | grep -oE 'slot [0-9]+' | awk '{print \$2}')
  last_block_file="$AGENT_SCRIPT_PATH/aztec_last_block_built"

  if [ -f "\$last_block_file" ] && grep -q "\$block_number" "\$last_block_file"; then return; fi
  echo "\$block_number" > "\$last_block_file"

  current_time=\$(date '+%Y-%m-%d %H:%M:%S')
  message="\$(t "block_built" "\$block_number")!%0A\$(t "slot_info" "\$slot_number")%0A\$(t "server_info" "\$ip")%0A\$(t "time_info" "\$current_time")"
  send_telegram_message "\$message"
  log "Block built notification sent: block \$block_number slot \$slot_number"
}

# === Основная функция: проверка контейнера и сравнение блоков ===
check_blocks() {
  container_id=\$(docker ps --format "{{.ID}} {{.Names}}" | grep aztec | grep -v watchtower | head -n 1 | awk '{print \$1}')
  if [ -z "\$container_id" ]; then
    log "Container 'aztec' not found."
    current_time=\$(date '+%Y-%m-%d %H:%M:%S')
    message="\$(t "container_not_found")%0A\$(t "server_info" "\$ip")%0A\$(t "time_info" "\$current_time")"
    send_telegram_message "\$message"
    exit 1
  fi

  # Проверка критических ошибок
  check_critical_errors "\$container_id"

  # Получаем текущий блок из контракта
  block_hex=\$(cast call "\$CONTRACT_ADDRESS" "\$FUNCTION_SIG" --rpc-url "\$RPC_URL" 2>&1)
  if [[ "\$block_hex" == *"Error"* || -z "\$block_hex" ]]; then
    log "Block Fetch Error. Check RPC or cast"
    current_time=\$(date '+%Y-%m-%d %H:%M:%S')
    message="\$(t "block_fetch_error")%0A\$(t "server_info" "\$ip")%0A\$(t "rpc_info" "\$RPC_URL")%0A\$(t "error_info" "\$block_hex")%0A\$(t "time_info" "\$current_time")"
    send_telegram_message "\$message"
    exit 1
  fi

  # Конвертируем hex-значение в десятичный
  block_number=\$(hex_to_dec "\$block_hex")
  log "Contract block: \$block_number"

  # Получаем последнюю релевантную строку из логов
  latest_log_line=\$(find_last_log_line "\$container_id")

  if [ -z "\$latest_log_line" ]; then
    log "No suitable block line found in logs"
    current_time=\$(date '+%Y-%m-%d %H:%M:%S')
    message="\$(t "no_block_in_logs")%0A\$(t "server_info" "\$ip")%0A\$(t "block_info" "\$block_number")%0A\$(t "time_info" "\$current_time")"
    send_telegram_message "\$message"
    exit 1
  fi

  # Извлекаем номер блока из найденной строки
  if grep -q 'Sequencer sync check succeeded' <<<"\$latest_log_line"; then
    # формат: ..."worldState":{"number":18254,...
    log_block_number=\$(echo "\$latest_log_line" | grep -o '"worldState":{"number":[0-9]\+' | grep -o '[0-9]\+$')
  else
    # формат: ..."blockNumber":18254,...
    log_block_number=\$(echo "\$latest_log_line" | grep -o '"blockNumber":[0-9]\+' | head -n1 | cut -d':' -f2)
  fi

  if [ -z "\$log_block_number" ]; then
    log "Failed to extract blockNumber from line: \$latest_log_line"
    current_time=\$(date '+%Y-%m-%d %H:%M:%S')
    message="\$(t "failed_extract_block")%0A\$(t "server_info" "\$ip")%0A\$(t "line_info" "\$latest_log_line")%0A\$(t "time_info" "\$current_time")"
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

  send_telegram_message "\$message"
  touch "\$LOG_FILE.initialized"
  echo "v.\$VERSION" >> "\$LOG_FILE"
  echo "INITIALIZED" >> "\$LOG_FILE"
fi

   # Дополнительные проверки (только если NOTIFICATION_TYPE == 2)
  check_committee
  check_block_built
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
--network alpha-testnet \
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

    version=$(docker exec "$container_id" node /usr/src/yarn-project/aztec/dest/bin/index.js --version 2>/dev/null)

    if [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo -e "${GREEN}$(t "aztec_node_version") ${BLUE}$version${NC}"
    else
        echo -e "\n${RED}$(t "aztec_version_failed")${NC}"
    fi
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
    echo -e "${CYAN}$(t "option10")${NC}"
    echo -e "${CYAN}$(t "option11")${NC}"
    echo -e "${CYAN}$(t "option12")${NC}"
    echo -e "${CYAN}$(t "option13")${NC}"
    echo -e "${CYAN}$(t "option14")${NC}"
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
      10) view_container_logs ;;
      11) install_aztec ;;
      12) delete_aztec ;;
      13) stop_aztec_containers ;;
      14) start_aztec_containers ;;
      0) echo -e "\n${GREEN}$(t "goodbye")${NC}"; exit 0 ;;
      *) echo -e "\n${RED}$(t "invalid_choice")${NC}" ;;
    esac
  done
}

# === Script launch ===
init_languages
check_dependencies
check_aztec_version
main_menu
