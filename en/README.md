# Aztec Node Monitoring Agent

**Description in:**
- [🇷🇺 Russian Version](https://github.com/pittpv/aztec-monitoring-script/blob/main/ "Русская версия описания")
- [🇹🇷 Turkish Version](https://github.com/pittpv/aztec-monitoring-script/blob/main/tr/ "Turkish version of description")

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
| 🌐 **Languages** | Language support English/Russian/Turkish                  |
| ⚙️ **RPC**       | Flexible RPC endpoint configuration               |

## 📌 Latest Updates 06-06-2025

Translate into Turkish:

- Full localization, including the script and Telegram notifications, into three languages. Turkish language has been added.
- Added a function for installing the Aztec node with Docker and **Watchtower**. Watchtower is configured to automatically update the node container while preserving the configuration.
  - Installation of dependencies
  - Check for Docker and Docker Compose, and install them if necessary
  - Checking default port availability with the option to change ports if needed.
  - Installation of the latest node binary
  - Automatic creation of `.env` and `docker-compose` files
  - Opening ports 8080 and 40400 in UFW
  - Starting the node and displaying the initial logs
- Added function to delete Aztec node  

---

<details>
<summary>📅 Version History</summary>

### 05-06-2025
- Update for Watchtower compatibility

### 04-06-2025
- Improved block number search mechanism (Option 1 and cron agent) in debug-level logs. Supports debug, info (and likely all other) log levels. Maximally accurate search results.
- Enhanced block validation error handling
- Added a new option – View node logs directly from the script (Ctrl+C to exit logs)
- Added block number output from logs when executing Option 1.
- Added script version control. If there are updates, the script will notify you about it.
- Minor improvements 

### 02-06-2025
- Updated log reading filter values for better compatibility with different versions of the Aztec node
- Added logging for RPC/cast errors
- Added script version logging

### 01-06-2025
- Improved compatibility. The script now works with both Docker-based and CLI Aztec nodes
- Added support for the new log format "block NNNN"
- Automatic check and installation of the `bc` utility for calculations in option 9
- Removal of ANSI codes before analysis for more reliable data parsing
- Fixed issue with PeerID detection in logs
- Optimized handling of block hex values
- Improved Telegram notification system


### 30-05-2025
- Added validator check function. Analyzes all validators, shows information for specific ones, displays full list.
- Aztec node custom port setup for proof generation option. This is necessary if you changed the node port during installation.

### 29-05-2025
- Log file cleanup when reaching 1 MB, initial report is preserved.
</details>

## ⚙️ Installation and Launch

1. **Requirements**:
   The script will check for required components and offer to install any that are missing.

2. **Launch or Update**:

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
   - Now you can set your own port (default port 8080). The new port number will be saved in the environment file .env-aztec-agent
8. 🔌 Change RPC URL
9. 🔍 Search for validator and check status
10. View Aztec logs
11. Install Aztec Node with Watchtower
12. Delete Aztec node
0. 🚪 Exit

## 🚀 Using the Cron Agent

After running the script, select the option to **Install the cron monitoring agent**:

- Creates an agent at `~/aztec-monitor-agent`
- Sets up a cron job
- Sends an initial status update to Telegram
- Continuously monitors the node and logs to `~/aztec-monitor-agent/agent.log`
- Sends Telegram alerts if:
   - The Aztec container is not found
   - There is a mismatch between the latest block in the logs and in the smart contract **> 3 blocks**
   - There is an RPC server issue
- Clears the log file when it reaches 1 MB in size, saving the very first report.

### Requirements for Cron Agent:

1. Get a Telegram token from [BotFather](https://t.me/BotFather)
2. Find your `chat_id` using [IDBot](https://t.me/myidbot)
3. Enter these in the script during cron-agent setup.
   The script validates both token and chat ID — if entered incorrectly, you will see a warning.

### Updating the cron agent

If there is an update for the cron-agent, first update the entire script. Then delete the old agent and create a new one.

## ⚠️ Important

This script is not an official product of Aztec Protocol and is provided "as is".

## 📜 License

MIT License © 2025

## ✍️ Feedback

For any issues, suggestions, or feedback:

[https://t.me/+DLsyG6ol3SFjM2Vk](https://t.me/+DLsyG6ol3SFjM2Vk)

## 🔗 Useful Links

[One-click RPC setup script](https://github.com/pittpv/sepolia-auto-install "Quickly set up a Sepolia node for RPC")
