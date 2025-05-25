# Aztec Node Monitoring Agent

[🇷🇺 Russian Version](https://github.com/pittpv/aztec-monitoring-script/blob/main/ "Русская версия описания")

![Bash](https://img.shields.io/badge/Bash-5.2-blue)
![Docker](https://img.shields.io/badge/Docker-20.10+-blue)
![Telegram](https://img.shields.io/badge/Telegram-API-blue)

![Main Screen](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/img-en-2025-05-25-05-44-01.png)

## 📝 Description

This script provides a comprehensive solution for monitoring the Aztec node, including container status checks, block synchronization verification, and Telegram notifications.

## 🌟 Key Features

* 🐳 Aztec container monitoring
* 🔗 Block freshness checks (compared to the smart contract)
* 🔍 Log parsing for critical parameters
* 📨 Telegram alerts on issues
* ⏰ Cron job for automatic monitoring

## 🛠️ Functionality

| Feature          | Description                                       |
| ---------------- | ------------------------------------------------- |
| ✅ **Container**  | Monitors the status of the Aztec Docker container |
| 🔄 **Blocks**    | Compares local block height with on-chain height  |
| 🤖 **Telegram**  | Instant issue alerts via Telegram                 |
| 🌐 **Languages** | English/Russian language support                  |
| ⚙️ **RPC**       | Flexible RPC endpoint configuration               |

## ⚙️ Installation and Launch

1. **Requirements**:
   The script will check for required components and offer to install any that are missing.

2. **Launch**:

   ```bash
   curl -o aztec-logs.sh https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/aztec-logs.sh && chmod +x aztec-logs.sh && ./aztec-logs.sh
   ```

   For future runs:

   ```bash
   cd $HOME && ./aztec-logs.sh
   ```

3. **Follow the instructions** to:

   * Select a language
   * Enter RPC URL
   * Configure the Telegram bot
   * Enable monitoring

## 🖥️ Usage

Main menu:

1. 🔍 Check container and blocks
2. ⚙️ Install monitoring agent
3. 🗑️ Remove monitoring agent
4. 🏷️ Find rollupAddress
5. 👥 Find PeerID
6. 🏛️ Find governanceProposerPayload
7. 🔗 Check Proven L2 Block *(data for getting Apprentice role in Discord)*
8. 🔌 Change RPC URL
0. 🚪 Exit

## 🚀 Using the Cron Agent

After running the script, select the option to **Install the cron monitoring agent**:

* Creates an agent at `~/aztec-monitor-agent`
* Sets up a cron job
* Sends an initial status update to Telegram
* Continuously monitors the node and logs to `~/aztec-monitor-agent/agent.log`
* Sends Telegram alerts if:

  * The Aztec container is not found
  * There is a mismatch between the latest block in the logs and in the smart contract (minor differences are acceptable)
  * There is an RPC server issue

### Requirements for Cron Agent:

1. Get a Telegram token from [BotFather](https://t.me/BotFather)
2. Find your `chat_id` using [IDBot](https://t.me/myidbot)
3. Enter these in the script during cron-agent setup.
   The script validates both token and chat ID — if entered incorrectly, you will see a warning.

## ⚠️ Important

This script is not an official product of Aztec Protocol and is provided "as is".

## 📜 License

MIT License © 2025

## ✍️ Feedback

For any issues, suggestions, or feedback:

[https://t.me/+DLsyG6ol3SFjM2Vk](https://t.me/+DLsyG6ol3SFjM2Vk)

## 🔗 Useful Links

[One-click RPC setup script](https://github.com/pittpv/sepolia-auto-install "Quickly set up a Sepolia node for RPC")
