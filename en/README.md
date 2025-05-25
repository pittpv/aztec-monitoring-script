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
   The script will check for the required components and offer to install any missing ones.

2. **Run setup**:
   ```bash
   curl -o aztec-logs.sh https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/aztec-logs.sh  
   chmod +x aztec-logs.sh 
   ./aztec-logs.sh 
   ```

3. **Follow prompts** to:
   - Select language
   - Enter RPC URL
   - Configure Telegram bot
   - Set up monitoring

### 🚀 Using the cron agent

After installation, the script will:

* Create the agent in `~/aztec-monitor-agent`
* Configure a cron job
* Send the initial status to Telegram
* Continuously monitor the node and log activity to `agent.log`
* Send a notification to Telegram if it fails to find the latest block


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
