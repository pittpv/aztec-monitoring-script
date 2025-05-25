# Aztec Node Monitoring Agent

[🇷🇺 Русская Версия](https://github.com/pittpv/aztec-monitoring-script/blob/main/ "Russian version of description")

![Bash](https://img.shields.io/badge/Bash-5.2-blue)
![Docker](https://img.shields.io/badge/Docker-20.10+-blue)
![Telegram](https://img.shields.io/badge/Telegram-API-blue)

![First screen](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/img-en-2025-05-25-05-44-01.png)

### 📌 Overview

This script provides comprehensive monitoring for Aztec node containers with the following features:

- Real-time container status checks
- Block synchronization monitoring
- Automatic Telegram notifications
- Multi-language support (English/Russian)
- Easy cron job setup

### 🛠 Features

1. **Container Monitoring**:
   - Checks if Aztec container is running
   - Verifies block processing status

2. **Log Analysis**:
   - Finds rollupAddress in logs
   - Extracts PeerID information
   - Tracks governanceProposerPayload changes

3. **Notifications**:
   - Telegram alerts for node issues
   - First-run welcome message
   - Server IP identification

4. **Automation**:
   - Automatic cron job setup
   - Minute-by-minute monitoring
   - Log rotation

### ⚙️ Installation

1. **Prerequisites**:
   ```bash
   sudo apt-get install curl git docker.io
   ```

2. **Clone repository**:
   ```bash
   git clone https://github.com/yourrepo/aztec-monitor.git
   cd aztec-monitor
   ```

3. **Run setup**:
   ```bash
   chmod +x aztec-monitor.sh
   ./aztec-monitor.sh
   ```

4. **Follow prompts** to:
   - Select language
   - Enter RPC URL
   - Configure Telegram bot
   - Set up monitoring

### 🚀 Usage

After installation, the script will:

- Create agent in `~/aztec-monitor-agent`
- Add cron job running every minute
- Send initial status to Telegram
- Monitor node continuously

Manual commands:
```bash
# Check container status
./aztec-monitor.sh

# Remove agent
./aztec-monitor.sh (select option 3)
```

### 📝 Telegram Messages

- **First run**:
  ```
  🤖 Agent successfully started on server: 192.168.1.1
  ✅ Aztec node is processing current block 12345
  ℹ️ Further notifications will be sent only if blocks are delayed
  ```

- **Block delay alert**:
  ```
  ❗ Aztec node is NOT processing current block 12345
  🌐 Server: 192.168.1.1
  ```
  
## 📜 License

MIT License © 2023 Aztec Monitor Project
