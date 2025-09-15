#!/bin/bash

#
# for Aztec Node Monitoring Agent by Pittpv
# https://github.com/pittpv/aztec-monitoring-script
#

set -e

# === Language settings ===
LANG="en"
declare -A TRANSLATIONS

# Translation function
t() {
  local key=$1
  echo "${TRANSLATIONS["${LANG},${key}"]:-$key}"
}

# Initialize languages
init_languages() {
  # Check if language is passed as argument
  if [ -n "$1" ]; then
    case $1 in
      "en") LANG="en" ;;
      "ru") LANG="ru" ;;
      "tr") LANG="tr" ;;
    esac
  fi

  # English translations
  TRANSLATIONS["en,installing_deps"]="🔧 Installing system dependencies..."
  TRANSLATIONS["en,deps_installed"]="✅ Dependencies installed"
  TRANSLATIONS["en,checking_docker"]="🔍 Checking Docker and docker compose..."
  TRANSLATIONS["en,docker_not_found"]="❌ Docker not installed"
  TRANSLATIONS["en,docker_compose_not_found"]="❌ docker compose (v2+) not found"
  TRANSLATIONS["en,install_docker_prompt"]="Install Docker? (y/n) "
  TRANSLATIONS["en,install_compose_prompt"]="Install Docker Compose? (y/n) "
  TRANSLATIONS["en,docker_required"]="❌ Docker is required for the script. Exiting."
  TRANSLATIONS["en,compose_required"]="❌ Docker Compose is required for the script. Exiting."
  TRANSLATIONS["en,installing_docker"]="Installing Docker..."
  TRANSLATIONS["en,installing_compose"]="Installing Docker Compose..."
  TRANSLATIONS["en,docker_installed"]="✅ Docker successfully installed"
  TRANSLATIONS["en,compose_installed"]="✅ Docker Compose successfully installed"
  TRANSLATIONS["en,docker_found"]="✅ Docker and docker compose found"
  TRANSLATIONS["en,installing_aztec"]="⬇️ Installing Aztec node..."
  TRANSLATIONS["en,aztec_not_installed"]="❌ Aztec node not installed. Check installation."
  TRANSLATIONS["en,aztec_installed"]="✅ Aztec node installed"
  TRANSLATIONS["en,running_aztec_up"]="🚀 Running aztec-up latest..."
  TRANSLATIONS["en,opening_ports"]="🌐 Opening ports 40400 and 8080..."
  TRANSLATIONS["en,ports_opened"]="✅ Ports opened"
  TRANSLATIONS["en,creating_folder"]="📁 Creating ~/aztec folder..."
  TRANSLATIONS["en,creating_env"]="📝 Creating .env file..."
  TRANSLATIONS["en,env_created"]="✅ .env file created"
  TRANSLATIONS["en,creating_compose"]="🛠️ Creating docker-compose.yml with Watchtower"
  TRANSLATIONS["en,compose_created"]="✅ docker-compose.yml created"
  TRANSLATIONS["en,starting_node"]="🚀 Starting Aztec node..."
  TRANSLATIONS["en,showing_logs"]="📄 Showing last 200 lines of logs..."
  TRANSLATIONS["en,logs_starting"]="Logs will start in 5 seconds... Press Ctrl+C to exit logs"
  TRANSLATIONS["en,checking_ports"]="Checking ports..."
  TRANSLATIONS["en,port_error"]="Error: Port $port is busy. The program cannot continue."
  TRANSLATIONS["en,ports_free"]="All ports are free! Installation will start now...\n"
  TRANSLATIONS["en,ports_busy"]="The following ports are busy:"
  TRANSLATIONS["en,change_ports_prompt"]="Do you want to change ports? (y/n) "
  TRANSLATIONS["en,enter_new_ports"]="Enter new port numbers:"
  TRANSLATIONS["en,enter_http_port"]="Enter HTTP port"
  TRANSLATIONS["en,enter_p2p_port"]="Enter P2P port"
  TRANSLATIONS["en,installation_aborted"]="Installation aborted by user"
  TRANSLATIONS["en,checking_ports_desc"]="Making sure ports are not used by other processes..."
  TRANSLATIONS["en,scanning_ports"]="Scanning ports"
  TRANSLATIONS["en,busy"]="busy"
  TRANSLATIONS["en,free"]="free"
  TRANSLATIONS["en,ports_free_success"]="All ports are available"
  TRANSLATIONS["en,ports_busy_error"]="Some ports are already in use"
  TRANSLATIONS["en,enter_new_ports_prompt"]="Please enter new port numbers"
  TRANSLATIONS["en,ports_updated"]="Port numbers have been updated"
  TRANSLATIONS["en,installing_ss"]="Installing iproute2 (contains ss utility)..."
  TRANSLATIONS["en,ss_installed"]="iproute2 installed successfully"
  TRANSLATIONS["en,delete_node"]="🗑️ Deleting Aztec Node..."
  TRANSLATIONS["en,delete_confirm"]="Are you sure you want to delete the Aztec node? This will stop containers and remove all data. (y/n) "
  TRANSLATIONS["en,node_deleted"]="✅ Aztec node successfully deleted"
  TRANSLATIONS["en,delete_canceled"]="✖ Node deletion canceled"
  TRANSLATIONS["en,warn_orig_install"]="⚠️ Type 'n' when prompted with the question:"
  TRANSLATIONS["en,warn_orig_install_2"]="Add it to /root/.bash_profile to make the aztec binaries accessible?"
  TRANSLATIONS["en,watchtower_exists"]="✅ Watchtower is already installed"
  TRANSLATIONS["en,installing_watchtower"]="⬇️ Installing Watchtower..."
  TRANSLATIONS["en,creating_watchtower_compose"]="🛠️ Creating Watchtower docker-compose.yml"
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
  TRANSLATIONS["en,validator_setup_header"]="=== Validator Setup ==="
  TRANSLATIONS["en,multiple_validators_prompt"]="Do you want to run multiple validators? (y/n) "
  TRANSLATIONS["en,ufw_not_installed"]="⚠️ ufw is not installed"
  TRANSLATIONS["en,ufw_not_active"]="⚠️ ufw is not active"

  # Russian translations
  TRANSLATIONS["ru,installing_deps"]="🔧 Установка системных зависимостей..."
  TRANSLATIONS["ru,deps_installed"]="✅ Зависимости установлены"
  TRANSLATIONS["ru,checking_docker"]="🔍 Проверка Docker и docker compose..."
  TRANSLATIONS["ru,docker_not_found"]="❌ Docker не установлен"
  TRANSLATIONS["ru,docker_compose_not_found"]="❌ docker compose (v2+) не найден"
  TRANSLATIONS["ru,install_docker_prompt"]="Установить Docker? (y/n) "
  TRANSLATIONS["ru,install_compose_prompt"]="Установить Docker Compose? (y/n) "
  TRANSLATIONS["ru,docker_required"]="❌ Docker необходим для работы скрипта. Выход."
  TRANSLATIONS["ru,compose_required"]="❌ Docker Compose необходим для работы скрипта. Выход."
  TRANSLATIONS["ru,installing_docker"]="Установка Docker..."
  TRANSLATIONS["ru,installing_compose"]="Установка Docker Compose..."
  TRANSLATIONS["ru,docker_installed"]="✅ Docker успешно установлен"
  TRANSLATIONS["ru,compose_installed"]="✅ Docker Compose успешно установлен"
  TRANSLATIONS["ru,docker_found"]="✅ Docker и docker compose найдены"
  TRANSLATIONS["ru,installing_aztec"]="⬇️ Установка ноды Aztec..."
  TRANSLATIONS["ru,aztec_not_installed"]="❌ Aztec нода не установлена. Проверьте установку."
  TRANSLATIONS["ru,aztec_installed"]="✅ Aztec нода установлена"
  TRANSLATIONS["ru,running_aztec_up"]="🚀 Запуск aztec-up latest..."
  TRANSLATIONS["ru,opening_ports"]="🌐 Открытие портов 40400 и 8080..."
  TRANSLATIONS["ru,ports_opened"]="✅ Порты открыты"
  TRANSLATIONS["ru,creating_folder"]="📁 Создание папки ~/aztec..."
  TRANSLATIONS["ru,creating_env"]="📝 Заполнение файла .env..."
  TRANSLATIONS["ru,env_created"]="✅ Файл .env создан"
  TRANSLATIONS["ru,creating_compose"]="🛠️ Создание docker-compose.yml c Watchtower"
  TRANSLATIONS["ru,compose_created"]="✅ docker-compose.yml создан"
  TRANSLATIONS["ru,starting_node"]="🚀 Запуск ноды Aztec..."
  TRANSLATIONS["ru,showing_logs"]="📄 Показываю последние 200 строк логов..."
  TRANSLATIONS["ru,logs_starting"]="Логи запустятся через 5 секунд... Нажмите Ctrl+C чтобы выйти из логов"
  TRANSLATIONS["ru,checking_ports"]="Проверка портов..."
  TRANSLATIONS["ru,port_error"]="Ошибка: Порт $port занят. Программа не сможет выполниться."
  TRANSLATIONS["ru,ports_free"]="Все порты свободны! Сейчас начнется установка...\n"
  TRANSLATIONS["ru,ports_busy"]="Следующие порты заняты:"
  TRANSLATIONS["ru,change_ports_prompt"]="Хотите изменить порты? (y/n) "
  TRANSLATIONS["ru,enter_new_ports"]="Введите новые номера портов:"
  TRANSLATIONS["ru,enter_http_port"]="Введите HTTP порт"
  TRANSLATIONS["ru,enter_p2p_port"]="Введите P2P порт"
  TRANSLATIONS["ru,installation_aborted"]="Установка прервана пользователем"
  TRANSLATIONS["ru,checking_ports_desc"]="Проверка, что порты не используются другим процессами..."
  TRANSLATIONS["ru,scanning_ports"]="Сканирование портов"
  TRANSLATIONS["ru,busy"]="занят"
  TRANSLATIONS["ru,free"]="свободен"
  TRANSLATIONS["ru,ports_free_success"]="Все порты доступны"
  TRANSLATIONS["ru,ports_busy_error"]="Некоторые порты уже используются"
  TRANSLATIONS["ru,enter_new_ports_prompt"]="Введите новые номера портов"
  TRANSLATIONS["ru,ports_updated"]="Номера портов обновлены"
  TRANSLATIONS["ru,installing_ss"]="Установка iproute2 (содержит утилиту ss)..."
  TRANSLATIONS["ru,ss_installed"]="iproute2 успешно установлен"
  TRANSLATIONS["ru,delete_node"]="🗑️ Удаление ноды Aztec..."
  TRANSLATIONS["ru,delete_confirm"]="Вы уверены, что хотите удалить ноду Aztec? Это остановит контейнеры и удалит все данные. (y/n) "
  TRANSLATIONS["ru,node_deleted"]="✅ Нода Aztec успешно удалена"
  TRANSLATIONS["ru,delete_canceled"]="✖ Удаление ноды отменено"
  TRANSLATIONS["ru,warn_orig_install"]="⚠️ Введите 'n' когда появится вопрос:"
  TRANSLATIONS["ru,warn_orig_install_2"]="Add it to /root/.bash_profile to make the aztec binaries accessible?"
  TRANSLATIONS["ru,watchtower_exists"]="✅ Watchtower уже установлен"
  TRANSLATIONS["ru,installing_watchtower"]="⬇️ Установка Watchtower..."
  TRANSLATIONS["ru,creating_watchtower_compose"]="🛠️ Создание Watchtower docker-compose.yml"
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
  TRANSLATIONS["ru,validator_setup_header"]="=== Настройка валидатора ==="
  TRANSLATIONS["ru,multiple_validators_prompt"]="Вы хотите запустить несколько валидаторов? (y/n)"
  TRANSLATIONS["ru,ufw_not_installed"]="⚠️ ufw не установлен"
  TRANSLATIONS["ru,ufw_not_active"]="⚠️ ufw не активен"

  # Turkish translations
  TRANSLATIONS["tr,installing_deps"]="🔧 Sistem bağımlılıkları yükleniyor..."
  TRANSLATIONS["tr,deps_installed"]="✅ Bağımlılıklar yüklendi"
  TRANSLATIONS["tr,checking_docker"]="🔍 Docker ve docker compose kontrol ediliyor..."
  TRANSLATIONS["tr,docker_not_found"]="❌ Docker yüklü değil"
  TRANSLATIONS["tr,docker_compose_not_found"]="❌ docker compose (v2+) bulunamadı"
  TRANSLATIONS["tr,install_docker_prompt"]="Docker yüklensin mi? (y/n) "
  TRANSLATIONS["tr,install_compose_prompt"]="Docker Compose yüklensin mi? (y/n) "
  TRANSLATIONS["tr,docker_required"]="❌ Scriptin çalışması için Docker gereklidir. Çıkılıyor."
  TRANSLATIONS["tr,compose_required"]="❌ Scriptin çalışması için Docker Compose gereklidir. Çıkılıyor."
  TRANSLATIONS["tr,installing_docker"]="Docker yükleniyor..."
  TRANSLATIONS["tr,installing_compose"]="Docker Compose yükleniyor..."
  TRANSLATIONS["tr,docker_installed"]="✅ Docker başarıyla yüklendi"
  TRANSLATIONS["tr,compose_installed"]="✅ Docker Compose başarıyla yüklendi"
  TRANSLATIONS["tr,docker_found"]="✅ Docker ve docker compose bulundu"
  TRANSLATIONS["tr,installing_aztec"]="⬇️ Aztec yükleniyor..."
  TRANSLATIONS["tr,aztec_not_installed"]="❌ Aztec yüklü değil. Kurulumu kontrol edin."
  TRANSLATIONS["tr,aztec_installed"]="✅ Aztec yüklendi"
  TRANSLATIONS["tr,running_aztec_up"]="🚀 aztec-up latest çalıştırılıyor..."
  TRANSLATIONS["tr,opening_ports"]="🌐 40400 ve 8080 portları açılıyor..."
  TRANSLATIONS["tr,ports_opened"]="✅ Portlar açıldı"
  TRANSLATIONS["tr,creating_folder"]="📁 ~/aztec klasörü oluşturuluyor..."
  TRANSLATIONS["tr,creating_env"]="📝 .env dosyası oluşturuluyor..."
  TRANSLATIONS["tr,env_created"]="✅ .env dosyası oluşturuldu"
  TRANSLATIONS["tr,creating_compose"]="🛠️ Watchtower ile docker-compose.yml oluşturuluyor"
  TRANSLATIONS["tr,compose_created"]="✅ docker-compose.yml oluşturuldu"
  TRANSLATIONS["tr,starting_node"]="🚀 Aztec node başlatılıyor..."
  TRANSLATIONS["tr,showing_logs"]="📄 Son 200 log satırı gösteriliyor..."
  TRANSLATIONS["tr,logs_starting"]="Loglar 5 saniye içinde başlayacak... Loglardan çıkmak için Ctrl+C'ye basın"
  TRANSLATIONS["tr,checking_ports"]="Portlar kontrol ediliyor..."
  TRANSLATIONS["tr,port_error"]="Hata: $port portu dolu. Program devam edemez."
  TRANSLATIONS["tr,ports_free"]="Tüm portlar boş! Kurulum şimdi başlayacak...\n"
  TRANSLATIONS["tr,ports_busy"]="Şu portlar dolu:"
  TRANSLATIONS["tr,change_ports_prompt"]="Portları değiştirmek ister misiniz? (y/n) "
  TRANSLATIONS["tr,enter_new_ports"]="Yeni port numaralarını girin:"
  TRANSLATIONS["tr,enter_http_port"]="HTTP portunu girin"
  TRANSLATIONS["tr,enter_p2p_port"]="P2P portunu girin"
  TRANSLATIONS["tr,installation_aborted"]="Kurulum kullanıcı tarafından iptal edildi"
  TRANSLATIONS["tr,checking_ports_desc"]="Başka süreçler tarafından kullanılmadığından emin olmak için portlar kontrol ediliyor..."
  TRANSLATIONS["tr,scanning_ports"]="Portlar taranıyor"
  TRANSLATIONS["tr,busy"]="meşgul"
  TRANSLATIONS["tr,free"]="boşta"
  TRANSLATIONS["tr,ports_free_success"]="Tüm portlar kullanıma hazır"
  TRANSLATIONS["tr,ports_busy_error"]="Bazı portlar zaten kullanımda"
  TRANSLATIONS["tr,enter_new_ports_prompt"]="Yeni port numaralarını girin"
  TRANSLATIONS["tr,ports_updated"]="Port numaraları güncellendi"
  TRANSLATIONS["tr,installing_ss"]="iproute2 yükleniyor (ss aracı içerir)..."
  TRANSLATIONS["tr,ss_installed"]="iproute2 başarıyla yüklendi"
  TRANSLATIONS["tr,delete_node"]="🗑️ Aztec Node siliniyor..."
  TRANSLATIONS["tr,delete_confirm"]="Aztec node'u silmek istediğinize emin misiniz? Bu işlem konteynerleri durduracak ve tüm verileri silecektir. (y/n) "
  TRANSLATIONS["tr,node_deleted"]="✅ Aztec node başarıyla silindi"
  TRANSLATIONS["tr,delete_canceled"]="✖ Node silme işlemi iptal edildi"
  TRANSLATIONS["tr,warn_orig_install"]="⚠️ Şu soru çıktığında 'n' yazın:"
  TRANSLATIONS["tr,warn_orig_install_2"]="Add it to /root/.bash_profile to make the aztec binaries accessible?"
  TRANSLATIONS["tr,watchtower_exists"]="✅ Watchtower zaten yüklü"
  TRANSLATIONS["tr,installing_watchtower"]="⬇️ Watchtower yükleniyor..."
  TRANSLATIONS["tr,creating_watchtower_compose"]="🛠️ Watchtower docker-compose.yml oluşturuluyor"
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
  TRANSLATIONS["tr,validator_setup_header"]="=== Validator Kurulumu ==="
  TRANSLATIONS["tr,multiple_validators_prompt"]="Birden fazla validator çalıştırmak istiyor musunuz? (y/n) "
  TRANSLATIONS["tr,ufw_not_installed"]="⚠️ ufw yüklü değil"
  TRANSLATIONS["tr,ufw_not_active"]="⚠️ ufw aktif değil"
}

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m'

# Initialize language (default to en if no argument)
init_languages "$1"

# Инициализация портов по умолчанию
http_port=8080
p2p_port=40400

check_and_set_ports() {
    local new_http_port
    local new_p2p_port

    echo -e "\n${CYAN}=== $(t "checking_ports") ===${NC}"
    echo -e "${GRAY}$(t "checking_ports_desc")${NC}\n"

    # Установка iproute2 (если не установлен) - содержит утилиту ss
    if ! command -v ss &> /dev/null; then
        echo -e "${YELLOW}$(t "installing_ss")...${NC}"
        sudo apt update -q > /dev/null 2>&1
        sudo apt install -y iproute2 > /dev/null 2>&1
        echo -e "${GREEN}$(t "ss_installed") ✔${NC}\n"
    fi

    while true; do
        ports=("$http_port" "$p2p_port")
        ports_busy=()

        echo -e "${CYAN}$(t "scanning_ports")...${NC}"

        # Проверка каждого порта с визуализацией (используем ss вместо lsof)
        for port in "${ports[@]}"; do
            echo -n -e "  ${YELLOW}Port $port:${NC} "
            if sudo ss -tuln | grep -q ":${port}\b"; then
                echo -e "${RED}$(t "busy") ✖${NC}"
                ports_busy+=("$port")
            else
                echo -e "${GREEN}$(t "free") ✔${NC}"
            fi
            sleep 0.1  # Уменьшенная задержка, так как ss работает быстрее
        done

        # Все порты свободны → выход из цикла
        if [ ${#ports_busy[@]} -eq 0 ]; then
            echo -e "\n${GREEN}✓ $(t "ports_free_success")${NC}"
            echo -e "  HTTP: ${GREEN}$http_port${NC}, P2P: ${GREEN}$p2p_port${NC}\n"
            break
        else
            # Показать занятые порты
            echo -e "\n${RED}⚠ $(t "ports_busy_error")${NC}"
            echo -e "  ${RED}${ports_busy[*]}${NC}\n"

            # Предложить изменить порты
            read -p "$(t "change_ports_prompt") " -n 1 -r
            echo

            if [[ $REPLY =~ ^[Yy]$ || -z "$REPLY" ]]; then
                echo -e "\n${YELLOW}$(t "enter_new_ports_prompt")${NC}"

                # Запрос нового HTTP-порта
                read -p "  $(t "enter_http_port") [${GRAY}by default: $http_port${NC}]: " new_http_port
                http_port=${new_http_port:-$http_port}

                # Запрос нового P2P-порта
                read -p "  $(t "enter_p2p_port") [${GRAY}by default: $p2p_port${NC}]: " new_p2p_port
                p2p_port=${new_p2p_port:-$p2p_port}

                echo -e "\n${CYAN}$(t "ports_updated")${NC}"
                echo -e "  HTTP: ${YELLOW}$http_port${NC}, P2P: ${YELLOW}$p2p_port${NC}\n"
            else
                # Отмена установки
                #echo -e "\n${RED}✖ $(t "installation_aborted")${NC}\n"
                exit 2
            fi
        fi
    done
}

install_docker() {
    echo -e "\n${YELLOW}$(t "installing_docker")${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo -e "\n${GREEN}$(t "docker_installed")${NC}"
}

install_docker_compose() {
    echo -e "\n${YELLOW}$(t "installing_compose")${NC}"
    sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo -e "\n${GREEN}$(t "compose_installed")${NC}"
}

delete_aztec_node() {
    echo -e "\n${RED}=== $(t "delete_node") ===${NC}"

    # Основной запрос
    while :; do
        read -p "$(t "delete_confirm") " -n 1 -r
        [[ $REPLY =~ ^[YyNn]$ ]] && break
        # Добавляем перевод строки только если ввод был неправильный
        echo -e "\n${YELLOW}$(t "enter_yn")${NC}"
    done
    echo  # Фиксируем окончательный перевод строки

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}$(t "stopping_containers")${NC}"
        docker compose -f "$HOME/aztec/docker-compose.yml" down || true

        echo -e "${YELLOW}$(t "removing_node_data")${NC}"
        sudo rm -rf "$HOME/.aztec" "$HOME/aztec"

        echo -e "${GREEN}$(t "node_deleted")${NC}"

        # Проверяем Watchtower
        if [ -d "$HOME/watchtower" ] || docker ps -a --format '{{.Names}}' | grep -q 'watchtower'; then
            while :; do
                read -p "$(t "delete_watchtower_confirm") " -n 1 -r
                [[ $REPLY =~ ^[YyNn]$ ]] && break
                echo -e "\n${YELLOW}$(t "enter_yn")${NC}"
            done
            echo

            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo -e "${YELLOW}$(t "stopping_watchtower")${NC}"
                docker stop watchtower 2>/dev/null || true
                docker rm watchtower 2>/dev/null || true
                [ -f "$HOME/watchtower/docker-compose.yml" ] && docker compose -f "$HOME/watchtower/docker-compose.yml" down || true

                echo -e "${YELLOW}$(t "removing_watchtower_data")${NC}"
                sudo rm -rf "$HOME/watchtower"
                echo -e "${GREEN}$(t "watchtower_deleted")${NC}"
            else
                echo -e "${GREEN}$(t "watchtower_kept")${NC}"
            fi
        fi

        return 0
    else
        echo -e "${YELLOW}$(t "delete_canceled")${NC}"
        return 1
    fi
}

# Функция для обновления ноды Aztec до последней версии
update_aztec_node() {
    echo -e "\n${GREEN}=== $(t "update_title") ===${NC}"

    # Переходим в папку с нодой
    cd "$HOME/aztec" || {
        echo -e "${RED}$(t "update_folder_error")${NC}"
        return 1
    }

    # Проверяем текущий тег в docker-compose.yml
    CURRENT_TAG=$(grep -oP 'image: aztecprotocol/aztec:\K[^\s]+' docker-compose.yml || echo "")

    if [[ "$CURRENT_TAG" != "latest" ]]; then
        echo -e "${YELLOW}$(printf "$(t "tag_check")" "$CURRENT_TAG")${NC}"
        sed -i 's|image: aztecprotocol/aztec:.*|image: aztecprotocol/aztec:latest|' docker-compose.yml
    fi

    # Обновляем образ
    echo -e "${YELLOW}$(t "update_pulling")${NC}"
    docker pull aztecprotocol/aztec:latest || {
        echo -e "${RED}$(t "update_pull_error")${NC}"
        return 1
    }

    # Останавливаем контейнеры
    echo -e "${YELLOW}$(t "update_stopping")${NC}"
    docker compose down || {
        echo -e "${RED}$(t "update_stop_error")${NC}"
        return 1
    }

    # Запускаем контейнеры
    echo -e "${YELLOW}$(t "update_starting")${NC}"
    docker compose up -d || {
        echo -e "${RED}$(t "update_start_error")${NC}"
        return 1
    }

    echo -e "${GREEN}$(t "update_success")${NC}"
}

# Функция для даунгрейда ноды Aztec
downgrade_aztec_node() {
    echo -e "\n${GREEN}=== $(t "downgrade_title") ===${NC}"

    # Получаем список доступных тегов с Docker Hub
    echo -e "${YELLOW}$(t "downgrade_fetching")${NC}"
    TAGS=$(curl -s https://hub.docker.com/v2/repositories/aztecprotocol/aztec/tags/?page_size=100 | jq -r '.results[].name' | sort -Vr)

    if [ -z "$TAGS" ]; then
        echo -e "${RED}$(t "downgrade_fetch_error")${NC}"
        return 1
    fi

    # Выводим список тегов с нумерацией
    echo -e "\n${CYAN}$(t "downgrade_available")${NC}"
    select TAG in $TAGS; do
        if [ -n "$TAG" ]; then
            break
        else
            echo -e "${RED}$(t "downgrade_invalid_choice"){NC}"
        fi
    done

    echo -e "\n${YELLOW}$(t "downgrade_selected") $TAG${NC}"

    # Переходим в папку с нодой
    cd "$HOME/aztec" || {
        echo -e "${RED}$(t "downgrade_folder_error")${NC}"
        return 1
    }

    # Обновляем образ до выбранной версии
    echo -e "${YELLOW}$(t "downgrade_pulling")$TAG...${NC}"
    docker pull aztecprotocol/aztec:"$TAG" || {
        echo -e "${RED}$(t "downgrade_pull_error")${NC}"
        return 1
    }

    # Останавливаем контейнеры
    echo -e "${YELLOW}$(t "downgrade_stopping")${NC}"
    docker compose down || {
        echo -e "${RED}$(t "downgrade_stop_error")${NC}"
        return 1
    }

    # Изменяем версию в docker-compose.yml
    echo -e "${YELLOW}$(t "downgrade_updating")${NC}"
    sed -i "s|image: aztecprotocol/aztec:.*|image: aztecprotocol/aztec:$TAG|" docker-compose.yml || {
        echo -e "${RED}$(t "downgrade_update_error")${NC}"
        return 1
    }

    # Запускаем контейнеры
    echo -e "${YELLOW}$(t "downgrade_starting") $TAG...${NC}"
    docker compose up -d || {
        echo -e "${RED}$(t "downgrade_start_error")${NC}"
        return 1
    }

    echo -e "${GREEN}$(t "downgrade_success") $TAG!${NC}"
}

# Вызываем проверку портов
check_and_set_ports

echo -e "\n${GREEN}$(t "installing_deps")${NC}"
sudo apt update
sudo apt install curl iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y

echo -e "\n${GREEN}$(t "deps_installed")${NC}"

echo -e "\n${GREEN}$(t "checking_docker")${NC}"

if ! command -v docker &>/dev/null; then
    echo -e "\n${RED}$(t "docker_not_found")${NC}"
    read -p "\n$(t "install_docker_prompt")" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_docker
    else
        echo -e "\n${RED}$(t "docker_required")${NC}"
        exit 1
    fi
fi

if ! docker compose version &>/dev/null; then
    echo -e "\n${RED}$(t "docker_compose_not_found")${NC}"
    read -p "\n$(t "install_compose_prompt")" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_docker_compose
    else
        echo -e "\n${RED}$(t "compose_required")${NC}"
        exit 1
    fi
fi

echo -e "\n${GREEN}$(t "docker_found")${NC}"

echo -e "\n${GREEN}$(t "installing_aztec")${NC}"
echo -e "${YELLOW}$(t "warn_orig_install") ${NC}$(t "warn_orig_install_2")${NC}"
sleep 5
curl -s https://install.aztec.network -o install-aztec.sh
chmod +x install-aztec.sh
bash install-aztec.sh

echo 'export PATH="$HOME/.aztec/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

if ! command -v aztec &>/dev/null; then
    echo -e "\n${RED}$(t "aztec_not_installed")${NC}"
    exit 1
fi

echo -e "\n${GREEN}$(t "aztec_installed")${NC}"

# Обновляем настройки firewall
# Проверяем, установлен ли ufw
if ! command -v ufw >/dev/null 2>&1; then
  echo -e "\n${YELLOW}$(t "ufw_not_installed")${NC}"
else
  # Проверяем, активен ли ufw
  if sudo ufw status | grep -q "inactive"; then
    echo -e "\n${YELLOW}$(t "ufw_not_active")${NC}"
  else
    # Обновляем настройки firewall
    echo -e "\n${GREEN}$(t "opening_ports")${NC}"
    sudo ufw allow "$p2p_port"
    sudo ufw allow "$http_port"
    echo -e "\n${GREEN}$(t "ports_opened")${NC}"
  fi
fi

# Create Aztec node folder and files
echo -e "\n${GREEN}$(t "creating_folder")${NC}"
mkdir -p "$HOME/aztec"
cd "$HOME/aztec"

# Ask if user wants to run single or multiple validators
echo -e "\n${CYAN}$(t "validator_setup_header")${NC}"
read -p "$(t "multiple_validators_prompt")" -n 1 -r
echo

# Initialize arrays for keys and addresses
VALIDATOR_PRIVATE_KEYS_ARRAY=()
VALIDATOR_ADDRESSES_ARRAY=()
USE_FIRST_AS_PUBLISHER=false

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "\n${GREEN}$(t "multi_validator_mode")${NC}"

    # Get multiple validator key-address pairs
    echo -e "${YELLOW}Enter validator private keys and addresses (up to 10, format: private_key,address):${NC}"
    for i in {1..10}; do
        read -p "Validator $i (or press Enter to finish): " KEY_ADDRESS_PAIR
        if [ -z "$KEY_ADDRESS_PAIR" ]; then
            break
        fi

        # Split the input into private key and address
        IFS=',' read -r PRIVATE_KEY ADDRESS <<< "$KEY_ADDRESS_PAIR"

        # Remove any spaces and ensure private key starts with 0x
        PRIVATE_KEY=$(echo "$PRIVATE_KEY" | tr -d ' ')
        if [[ ! "$PRIVATE_KEY" =~ ^0x ]]; then
            PRIVATE_KEY="0x$PRIVATE_KEY"
        fi

        # Remove any spaces from address
        ADDRESS=$(echo "$ADDRESS" | tr -d ' ')

        VALIDATOR_PRIVATE_KEYS_ARRAY+=("$PRIVATE_KEY")
        VALIDATOR_ADDRESSES_ARRAY+=("$ADDRESS")

        echo -e "${GREEN}Added validator $i${NC}"
    done

    # Ask if user wants to use first address as publisher for all validators
    echo ""
    read -p "Use first address as publisher for all validators? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        USE_FIRST_AS_PUBLISHER=true
        echo -e "${GREEN}Using first address as publisher for all validators${NC}"
    else
        echo -e "${GREEN}Each validator will use their own address as publisher${NC}"
    fi

else
    echo -e "\n${GREEN}$(t "single_validator_mode")${NC}"

    # Get single validator key-address pair
    read -p "$(t "enter_validator_key") " PRIVATE_KEY
    read -p "Enter validator address: " ADDRESS

    # Remove any spaces and ensure private key starts with 0x
    PRIVATE_KEY=$(echo "$PRIVATE_KEY" | tr -d ' ')
    if [[ ! "$PRIVATE_KEY" =~ ^0x ]]; then
        PRIVATE_KEY="0x$PRIVATE_KEY"
    fi

    # Remove any spaces from address
    ADDRESS=$(echo "$ADDRESS" | tr -d ' ')

    VALIDATOR_PRIVATE_KEYS_ARRAY+=("$PRIVATE_KEY")
    VALIDATOR_ADDRESSES_ARRAY+=("$ADDRESS")
    USE_FIRST_AS_PUBLISHER=true  # For single validator, always use own address
fi

# Ask for Aztec L2 Address for feeRecipient
echo -e "\n${YELLOW}Enter Aztec L2 Address to use as feeRecipient for all validators:${NC}"
read -p "Aztec L2 Address: " FEE_RECIPIENT_ADDRESS
FEE_RECIPIENT_ADDRESS=$(echo "$FEE_RECIPIENT_ADDRESS" | tr -d ' ')

# Create keys directory and YML files
echo -e "\n${GREEN}Creating key files...${NC}"
mkdir -p "$HOME/aztec/keys"

for i in "${!VALIDATOR_PRIVATE_KEYS_ARRAY[@]}"; do
    KEY_FILE="$HOME/aztec/keys/validator_$((i+1)).yml"
    cat > "$KEY_FILE" <<EOF
type: "file-raw"
keyType: "SECP256K1"
privateKey: "${VALIDATOR_PRIVATE_KEYS_ARRAY[$i]}"
EOF
    echo -e "${GREEN}Created key file: $KEY_FILE${NC}"
done

# Create config directory and keystore.json
echo -e "\n${GREEN}Creating keystore configuration...${NC}"
mkdir -p "$HOME/aztec/config"

# Prepare validators array for keystore.json
VALIDATORS_JSON_ARRAY=()
for i in "${!VALIDATOR_ADDRESSES_ARRAY[@]}"; do
    address="${VALIDATOR_ADDRESSES_ARRAY[$i]}"

    if [ "$USE_FIRST_AS_PUBLISHER" = true ] && [ $i -gt 0 ]; then
        # Use first private key as publisher for all other validators
        publisher="${VALIDATOR_PRIVATE_KEYS_ARRAY[0]}"
    else
        # Use own private key as publisher
        publisher="${VALIDATOR_PRIVATE_KEYS_ARRAY[$i]}"
    fi

    VALIDATOR_JSON=$(cat <<EOF
    {
      "attester": "$address",
      "publisher": "$publisher",
      "feeRecipient": "$FEE_RECIPIENT_ADDRESS"
    }
EOF
    )
    VALIDATORS_JSON_ARRAY+=("$VALIDATOR_JSON")
done

# Join validators array with commas
VALIDATORS_JSON_STRING=$(IFS=,; echo "${VALIDATORS_JSON_ARRAY[*]}")

# Create keystore.json
cat > "$HOME/aztec/config/keystore.json" <<EOF
{
  "schemaVersion": 1,
  "remoteSigner": "http://127.0.0.1:10500",
  "slasher": "${VALIDATOR_ADDRESSES_ARRAY[0]}",
  "validators": [
    $VALIDATORS_JSON_STRING
  ]
}
EOF

echo -e "${GREEN}Created keystore.json configuration${NC}"

DEFAULT_IP=$(hostname -I | awk '{print $1}')

echo -e "\n${GREEN}$(t "creating_env")${NC}"
read -p "ETHEREUM_RPC_URL: " ETHEREUM_RPC_URL
read -p "CONSENSUS_BEACON_URL: " CONSENSUS_BEACON_URL
read -p "COINBASE: " COINBASE

# Create .env file without VALIDATOR_PRIVATE_KEYS
cat > .env <<EOF
ETHEREUM_RPC_URL=${ETHEREUM_RPC_URL}
CONSENSUS_BEACON_URL=${CONSENSUS_BEACON_URL}
COINBASE=${COINBASE}
P2P_IP=${DEFAULT_IP}
EOF

echo -e "\n${GREEN}$(t "creating_compose")${NC}"

# Создаем docker-compose.yml без VALIDATOR_PRIVATE_KEYS и с KEY_STORE_DIRECTORY
cat > docker-compose.yml <<EOF
services:
  aztec-node:
    container_name: aztec-sequencer
    network_mode: host
    image: aztecprotocol/aztec:latest
    restart: unless-stopped
    environment:
      ETHEREUM_HOSTS: \${ETHEREUM_RPC_URL}
      L1_CONSENSUS_HOST_URLS: \${CONSENSUS_BEACON_URL}
      DATA_DIRECTORY: /data
      KEY_STORE_DIRECTORY: /config
      COINBASE: \${COINBASE}
      P2P_IP: \${P2P_IP}
      LOG_LEVEL: debug
    entrypoint: >
      sh -c 'node --no-warnings /usr/src/yarn-project/aztec/dest/bin/index.js start --network staging-public --node --archiver --sequencer'
    ports:
      - ${p2p_port}:${p2p_port}/tcp
      - ${p2p_port}:${p2p_port}/udp
      - ${http_port}:${http_port}
    volumes:
      - /root/.aztec/staging-public/data/:/data
      - $HOME/aztec/config:/config
    labels:
      - com.centurylinklabs.watchtower.enable=true
EOF

echo -e "\n${GREEN}$(t "compose_created")${NC}"

# Check if Watchtower is already installed
if [ -d "$HOME/watchtower" ]; then
    echo -e "\n${GREEN}$(t "watchtower_exists")${NC}"
else
    # Create Watchtower folder and files
    echo -e "\n${GREEN}$(t "installing_watchtower")${NC}"
    mkdir -p "$HOME/watchtower"
    cd "$HOME/watchtower"

    # Ask for Telegram notification settings
    echo -e "\n${YELLOW}Telegram notification settings for Watchtower:${NC}"
    read -p "$(t "enter_tg_token") " TG_TOKEN
    read -p "$(t "enter_tg_chat_id") " TG_CHAT_ID

    # Create .env file for Watchtower
    cat > .env <<EOF
TG_TOKEN=${TG_TOKEN}
TG_CHAT_ID=${TG_CHAT_ID}
WATCHTOWER_NOTIFICATION_URL=telegram://${TG_TOKEN}@telegram?channels=${TG_CHAT_ID}&parseMode=html
EOF

    echo -e "\n${GREEN}$(t "env_created")${NC}"

    echo -e "\n${GREEN}$(t "creating_watchtower_compose")${NC}"
    cat > docker-compose.yml <<EOF
services:
  watchtower:
    image: containrrr/watchtower:latest
    container_name: watchtower
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    env_file:
      - .env
    environment:
      - WATCHTOWER_CLEANUP=true
      - WATCHTOWER_POLL_INTERVAL=3600
      - WATCHTOWER_NOTIFICATIONS=shoutrrr
      - WATCHTOWER_NOTIFICATION_URL
      - WATCHTOWER_INCLUDE_RESTARTING=true
      - WATCHTOWER_LABEL_ENABLE=true
EOF

    echo -e "\n${GREEN}$(t "compose_created")${NC}"
fi

# Download and run web3signer before starting the node
echo -e "\n${GREEN}Downloading and starting web3signer...${NC}"
docker pull consensys/web3signer:latest

# Stop and remove existing web3signer container if it exists
docker stop web3signer 2>/dev/null || true
docker rm web3signer 2>/dev/null || true

# Run web3signer container
docker run -d --name web3signer --restart unless-stopped \
  -p 127.0.0.1:10500:10500 \
  -v $HOME/aztec/keys:/keys \
  consensys/web3signer:latest \
  --http-listen-host=0.0.0.0 \
  --http-listen-port=10500 \
  --http-host-allowlist="*" \
  --key-store-path=/keys \
  eth1 --chain-id=11155111

echo -e "${GREEN}web3signer started successfully${NC}"

# Wait a moment for web3signer to initialize
echo -e "${YELLOW}Waiting for web3signer to initialize...${NC}"
sleep 5

echo -e "\n${GREEN}$(t "starting_node")${NC}"
cd "$HOME/aztec"
docker compose up -d

# Start Watchtower if it exists
if [ -d "$HOME/watchtower" ]; then
    cd "$HOME/watchtower"
    docker compose up -d
fi

echo -e "\n${YELLOW}$(t "showing_logs")${NC}"
echo -e "${YELLOW}$(t "logs_starting")${NC}"
sleep 5
echo -e ""
cd "$HOME/aztec"
docker compose logs -fn 200
