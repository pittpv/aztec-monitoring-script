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
  TRANSLATIONS["ru,checking_ports_desc"]="Проверка, что порты не используются другими процессами..."
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
}

# Initialize language (default to en if no argument)
init_languages "$1"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m'

delete_aztec_node() {
    echo -e "\n${RED}=== $(t "delete_node") ===${NC}"
    read -p "$(t "delete_confirm")" -n 1 -r
    echo

    # Очистка ввода перед выходом
    while [[ -n $REPLY && ! $REPLY =~ ^[YyNn]$ ]]; do
        read -p "Please enter Y or N: " -n 1 -r
        echo
    done

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Stopping containers...${NC}"
        docker compose -f "$HOME/aztec/docker-compose.yml" down || true

        echo -e "${YELLOW}Removing Aztec node data...${NC}"
        sudo rm -rf "$HOME/.aztec" "$HOME/aztec"

        echo -e "${GREEN}$(t "node_deleted")${NC}"

        # Ask about Watchtower deletion if it exists
        if [ -d "$HOME/watchtower" ]; then
            REPLY=""  # Сброс переменной перед новым запросом
            read -p "$(t "delete_watchtower_confirm")" -n 1 -r
            echo

            # Проверка ввода для Watchtower
            while [[ -n $REPLY && ! $REPLY =~ ^[YyNn]$ ]]; do
                read -p "Please enter Y or N: " -n 1 -r
                echo
            done

            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo -e "${YELLOW}Stopping Watchtower...${NC}"
                docker compose -f "$HOME/watchtower/docker-compose.yml" down || true
                echo -e "${YELLOW}Removing Watchtower data...${NC}"
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

# Вызываем проверку портов
check_and_set_ports

echo -e "\n${GREEN}$(t "installing_deps")${NC}"
sudo apt update
sudo apt install curl iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y

echo -e "\n${GREEN}$(t "deps_installed")${NC}"

echo -e "\n${GREEN}$(t "checking_docker")${NC}"

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

echo -e "\n${GREEN}$(t "running_aztec_up")${NC}"
aztec-up latest

# Обновляем настройки firewall
echo -e "\n${GREEN}$(t "opening_ports")${NC}"
sudo ufw allow "$p2p_port"
sudo ufw allow "$http_port"
echo -e "\n${GREEN}$(t "ports_opened")${NC}"

# Create Aztec node folder and files
echo -e "\n${GREEN}$(t "creating_folder")${NC}"
mkdir -p "$HOME/aztec"
cd "$HOME/aztec"

# Ask if user wants to run single or multiple validators
echo -e "\n${CYAN}=== Validator Setup ===${NC}"
read -p "Do you want to run multiple validators? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "\n${GREEN}$(t "multi_validator_mode")${NC}"
    read -p "$(t "enter_validator_keys") " VALIDATOR_PRIVATE_KEYS
    read -p "$(t "enter_seq_publisher_key") " SEQ_PUBLISHER_PRIVATE_KEY
else
    echo -e "\n${GREEN}$(t "single_validator_mode")${NC}"
    read -p "$(t "enter_validator_key") " VALIDATOR_PRIVATE_KEYS
    SEQ_PUBLISHER_PRIVATE_KEY=""
fi

echo -e "\n${GREEN}$(t "creating_env")${NC}"
read -p "ETHEREUM_RPC_URL: " ETHEREUM_RPC_URL
read -p "CONSENSUS_BEACON_URL: " CONSENSUS_BEACON_URL
read -p "COINBASE: " COINBASE
read -p "P2P_IP: " P2P_IP

cat > .env <<EOF
ETHEREUM_RPC_URL=${ETHEREUM_RPC_URL}
CONSENSUS_BEACON_URL=${CONSENSUS_BEACON_URL}
VALIDATOR_PRIVATE_KEYS=${VALIDATOR_PRIVATE_KEYS}
SEQ_PUBLISHER_PRIVATE_KEY=${SEQ_PUBLISHER_PRIVATE_KEY}
COINBASE=${COINBASE}
P2P_IP=${P2P_IP}
EOF

echo -e "\n${GREEN}$(t "creating_compose")${NC}"

# Создаем docker-compose.yml с учетом выбранного режима
if [[ -n "$SEQ_PUBLISHER_PRIVATE_KEY" ]]; then
    # Режим нескольких валидаторов - включаем SEQ_PUBLISHER_PRIVATE_KEY
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
      VALIDATOR_PRIVATE_KEYS: \${VALIDATOR_PRIVATE_KEYS}
      SEQ_PUBLISHER_PRIVATE_KEY: \${SEQ_PUBLISHER_PRIVATE_KEY}
      COINBASE: \${COINBASE}
      P2P_IP: \${P2P_IP}
      LOG_LEVEL: debug
    entrypoint: >
      sh -c 'node --no-warnings /usr/src/yarn-project/aztec/dest/bin/index.js start --network alpha-testnet --node --archiver --sequencer'
    ports:
      - ${p2p_port}:${p2p_port}/tcp
      - ${p2p_port}:${p2p_port}/udp
      - ${http_port}:${http_port}
    volumes:
      - /root/.aztec/alpha-testnet/data/:/data
EOF
else
    # Режим одного валидатора - не включаем SEQ_PUBLISHER_PRIVATE_KEY
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
      VALIDATOR_PRIVATE_KEYS: \${VALIDATOR_PRIVATE_KEYS}
      COINBASE: \${COINBASE}
      P2P_IP: \${P2P_IP}
      LOG_LEVEL: debug
    entrypoint: >
      sh -c 'node --no-warnings /usr/src/yarn-project/aztec/dest/bin/index.js start --network alpha-testnet --node --archiver --sequencer'
    ports:
      - ${p2p_port}:${p2p_port}/tcp
      - ${p2p_port}:${p2p_port}/udp
      - ${http_port}:${http_port}
    volumes:
      - /root/.aztec/alpha-testnet/data/:/data
EOF
fi

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
