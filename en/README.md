# Aztec Node Monitoring Agent

[🇷🇺 Русская версия](https://github.com/pittpv/aztec-monitoring-script/blob/main/ru/ "Russian version of description")

![Bash](https://img.shields.io/badge/Bash-5.2-blue)
![Docker](https://img.shields.io/badge/Docker-20.10+-blue)
![Telegram](https://img.shields.io/badge/Telegram-API-blue)

![First Screen](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/img-ru-2025-05-25-05-45-23.png)

## 📌 Overview

This script provides Aztec node monitoring with the following features:

* Container status check
* Block sync monitoring
* Telegram notifications
* Dual language support
* Simple cron job setup
* Getting proof for discord role

## 🛠 Features

1. **Monitoring**:

   * Checks if the Aztec container is running
   * Verifies that the latest block is being processed

2. **Log Analysis**:

   * Searches for `rollupAddress`
   * Extracts `PeerID`
   * Tracks changes to `governanceProposerPayload`
   * Finds the latest proven block number and corresponding proof code (useful for acquiring the Apprentice role)

3. **Notifications**:

   * Telegram alerts when the node lags behind the network
   * Welcome message upon activation
   * Server identification via external IP address

4. **Automation**:

   * Sets up a cron job
   * Runs a check every minute
   * Log rotation support

## ⚙️ Installation & Run

1. **Requirements**:
   The script checks for necessary components and offers to install missing ones.

2. **Run**:

   ```bash
   curl -o aztec-logs.sh https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/aztec-logs.sh  
   chmod +x aztec-logs.sh  
   ./aztec-logs.sh  
   ```

3. **Follow the instructions** to:

   * Select language
   * Enter RPC URL
   * Configure Telegram bot
   * Activate monitoring

## 🚀 Using the Cron Agent

After installing the script, select option Install cron agent for monitoring:

* Create an agent in `~/aztec-monitor-agent`
* Configure a cron job
* Send an initial status message to Telegram
* Continuously monitor the node and log output to `agent.log`
* Send Telegram alerts if the node fails to process the current block

## 📝 Telegram Messages

* **First run**:

  ```
  🤖 Agent successfully launched on server: 192.168.1.1  
  ✅ Node is processing the latest block 12345  
  ℹ️ Further notifications will only be sent if the node falls behind  
  ```

* **Block lag alert**:

  ```
  ❗ Node is NOT processing the current block 12345  
  🌐 Server: 192.168.1.1  
  ```

## 📜 License

MIT License © 2023 Aztec Monitor Project
