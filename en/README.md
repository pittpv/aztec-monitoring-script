# Aztec Node Install & Monitoring script (new testnet)

**Description in:**
- [🇷🇺 Russian Version](https://github.com/pittpv/aztec-monitoring-script/blob/main/ "Русская версия описания")
- [🇹🇷 Turkish Version](https://github.com/pittpv/aztec-monitoring-script/blob/main/tr/ "Turkish version of description")

![Bash](https://img.shields.io/badge/Bash-5.2-blue)
![Docker](https://img.shields.io/badge/Docker-20.10+-blue)
![Telegram](https://img.shields.io/badge/Telegram-API-blue)

![Main Screen](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/img-en-2025-05-25-05-44-01.png)

## 📝 Description

This script provides a complete solution for running (docker-compose or CLI) and monitoring an Aztec node, including automatic updates, checking container status, syncing blocks, getting important information about the node, and sending notifications to Telegram.

Also check out the Version History under the spoiler, there is a lot of useful information about the functions of the script.

## 🌟 Key Features

* 🏃🏻‍ Node launch (docker-compose or CLI)
* 🐳 Monitoring the operation of the Aztec node
* 🔗 Block freshness checks (compared to the smart contract)
* 🔍 Log parsing for critical parameters
* 📨 Telegram alerts on issues and validator activity
* ⏰ systemd service for automatic monitoring

## 🛠️ Functionality

| Feature          | Description                                       |
| ---------------- | ------------------------------------------------- |
| ✅ **Container**  | Monitors the status of the Aztec Docker container |
| 🔄 **Blocks**    | Compares local block height with on-chain height  |
| 🤖 **Telegram**  | Instant issue alerts via Telegram                 |
| 🌐 **Languages** | Language support English/Russian/Turkish                  |
| ⚙️ **RPC**       | Flexible RPC endpoint configuration               |

## 📌 Latest Updates 11-11-2025
- Added a method for generating a new operator from an old validator private key (requires node installation via this script, option 11)
- Minor improvements in main script
- Minor improvements in monitoring agent script
- Minor improvements in node installation script

<details>
<summary>📅 Version History</summary>

### 08-11-2025
* Full support for the new contract
    * monitoring
    * node installation
    * validator check and search
    * validator queue monitoring
* Generation of BLS keys from a mnemonic phrase for your old sequencer (requires node installation via this script, option 11)
    * support for multiple addresses from one mnemonic
    * automatic filtering and removal of unnecessary keys
* Stake approve function (requires node installation via this script, option 11)
* Staking function — adding a validator (requires node installation via this script, option 11)

### 04-10-2025
⚠️ Please Delete old monitoring agent (use option 3) and Install new agent (use option 2)

- New slot statistics notification system
    - Now statistics are updated directly in the message as live slots. Only one message instead of 25 messages
    - Support for multiple validators. Each validator has its own message with statuses
    - Fallback support. If an error occurs while updating the first message, the script will send a new message.
- Update in the installation script, new method of determining the IP address.
    - When installing a node on a server with a virtual machine, the IP address for P2P_IP was detected as local, which prevented the node from working correctly. If you have a VPN configured, specify the real IP address for P2P_IP manually.
- Update of the error file for detection by the critical error monitoring module
    - Added an error case when the node does not receive BLOB data from BEACON RPC

### 20-09-2025
- The function for searching and setting up validator monitoring in the queue (in option 9) works.
    - Added Cloudflare bypass
- Added missing translations
- New required components: Python and curl_cffi.
    - The script will suggest installing the missing components
- Fix for **curl_cffi** installation. Some users encountered the following issue when installing curl_cffi: `/usr/bin/python3: No module named pip` or `error: externally-managed-environment`
- Added new errors detected by the critical error control module

Many thanks to `@xtoun` (Discord) for the hint with the solution and to everyone who tested.

### 17-09-2025
- Full support for the new network and testnet.
- New node installation script.
  - Automatic creation of YML key files for web3signer.
  - Installation and launch of web3signer.
  - Automatic creation of keystore.json key schema.
  - Support for multi-validator mode (up to 10 per node).
  - Ability to assign one common publisher address for all validators or have each use its own address (same as attester).
  - All previous features (automatic installation of required software, port checks, ability to assign custom ports, validations).
- New monitoring agent script for the node (option 2).
  - New Telegram notifications with slot-by-slot statistics including all status types (✅ attestation, ❌ attestation, ⛏️ Block mined, 📤 Block proposed, ⚠️ Block missed).
  - Support for multi-validator mode (statistics for all validators that joined the committee), as well as single-validator mode.
  - DEBUG mode – allows receiving highly detailed monitoring logs. Log is written to /root/aztec-monitor-agent/agent.log. To enable, set DEBUG=true in /root/.env-aztec-agent (default is false).
  - Checks run exactly on a systemd timer every 37 seconds (approximate duration of one slot) – you won’t miss any status!
- All previous features (sync control, critical error detection, quick log view, automatic updates, downgrade function, container management, and more).
- New script for searching and verifying validators directly in Rollup and GSE contracts (option 9).
  - Fast validator search and status check.
  - Supports checking multiple validators in a single request.
  - Exact number of active validators in the network.
  - Always up-to-date information.
- Updated script version control function. Now short descriptions of new versions and updates are shown.
- Added new errors detected by the critical error control module, with details on how to fix them and Telegram notifications.
- Minor improvements to other features

### 21-08-2025
- Updated PeerID search function (restored function operation + new features)
    - The script finds the node's PeerID in the logs
    - Searches among current data on Nethermind.io
    - If not found in current Nethermind.io data, searches in the archive
- Updated cron agent creation function
    - Now in the committee inclusion notification, you can click on the validator address and go to its page on dashtec.xyz
- Updated Aztec node installation script
    - Added ufw activity check.
    - If ufw is active, rules for ports 8080 and 40400 are added, otherwise rules are not added.

### 06-08-2025
- The validator queue check function has been restored.

### 02-08-2025
- Updated the validator committee inclusion check function (restored function operation)
    - Multiple validator addresses can be specified

### 01-08-2025
- Updated the validator check script. Added check modes.
    - Fast processing - high CPU load
    - Slow processing - no CPU load
- Aztec node version check moved to a separate menu item to avoid wasting time during script loading.

### 29-07-2025
- Added the Aztec Node Update function. The function updates the node instantly without waiting for automatic updates from Watchtower.
    - Also use this option if you performed a downgrade and need to revert back.
    - Checks `docker-compose.yml` and replaces the tag with `latest`
- Added the Aztec Node Downgrade function. The function shows all node versions from Docker Hub, allowing rollback to any selected version from the list.
    - Selection of desired version
    - Updating the `docker-compose.yml` file
    - Stopping, downloading and launching containers

### 28-07-2025
- Updated the Aztec node installation script with Watchtower. During installation, the script will ask, "Do you want to run multiple validators? (y/n)"
    - Installation in multivalidator mode (up to 10 validators per node)
    - Installation in single-validator mode

### 21-07-2025
- Updated node launch command in CLI (validatorPrivateKey**s**) for node version 1.1.0 and above
- Added function to check for old screen sessions with node in CLI and delete them before creating a new session.
- Rollup contract address updated.

### 15-07-2025
- Improved the Telegram notification system **for validators**. Thanks for the idea @malbur187 (Discord)
    - When setting up the node monitoring cron agent, you can now choose which notifications to receive: only errors or also committee selection and block creation alerts.
    - The selection is saved in `.env-aztec-agent` and applied during subsequent agent recreations. To modify it, edit the `.env-aztec-agent` file.
- Added critical error detection. If a critical error is found in the node logs, a Telegram notification will be sent.
    - The error array is updated via a unified JSON file, allowing quick addition of new errors and their solutions.
- Updated the PeerID search function. Thanks for the idea @web3.creed (Discord)
    - After successful log detection, the PeerID is checked in the public database `aztec.nethermind.io`, and the result is displayed.
- Minor improvements

### 25-06-2025
- Added function "Stop Aztec Node Containers" – a smart function that remembers your method of running the node container (docker-compose or CLI) and continues to operate in the selected mode.
    - When prompted for the working method, specify how your node is running: `docker-compose` or `CLI`
    - When prompted for the path to the docker-compose file, provide the path from the root directory in the format: `/root/aztec` or `./aztec`
    - All settings are saved in the `.env-aztec-agent` file. You can change them if desired.
- Added function "Start Aztec Node Containers" – a smart function that uses the container running method assigned in the "Stop Aztec Node Containers" function (option 13).
    - If you **haven’t set** the container management method (option 13) and use the "Start Aztec Node Containers" function, it will work as a **wizard for starting a CLI node**. In this case, the script will prompt for the necessary CLI launch parameters, generate the command, and start the CLI node in a screen session.
    - All settings are saved in the `.env-aztec-agent` file. You can change them if desired.
- Updated the cron-agent creation function with Telegram notifications – now ChatID and Telegram token are saved in the `.env-aztec-agent` file and don’t need to be re-entered when removing/creating the cron-agent.
- Added Aztec Node version check when the script loads.

### 22-06-2025  
- View Aztec logs function – updated to show the last 500 lines with auto-refresh.  
- Check container and current block function - improved log reading and memory issue prevention
- Enhanced dependency check & installation for required script tools. 

### 06-06-2025

- Full localization, including the script and Telegram notifications, into three languages. Turkish language has been added.
- Added a function for installing the Aztec node with Docker and **Watchtower**. Watchtower is configured to automatically update the node container while preserving the configuration.
  - Installation of dependencies
  - Check for Docker and Docker Compose, and install them if necessary
  - Checking default port availability with the option to change ports if needed.
  - Installation of the latest node binary
  - Automatic creation of `.env` and `docker-compose` files
  - Opening ports in UFW
  - Starting the node and displaying the initial logs
- Added function to delete Aztec node 

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


---

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
   * Enable monitoring (option 2)

## 🖥️ Usage

Main menu:

1. 🔍 Check container and node synchronization 
2. ⚙️ Install node monitoring agent with notifications
3. 🗑️ Remove monitoring agent
4. 🏷️ Find rollupAddress
5. 👥 Find PeerID
6. 🏛️ Find governanceProposerPayload
7. 🔗 Check Proven L2 Block *(the data that was previously required to obtain the Apprentice role in Discord)*
   - Now you can set your own port (default port 8080). The new port number will be saved in the environment file .env-aztec-agent
8. 🔌 Change RPC URL
9. 🔍 Search for validator and check status
10. View Aztec logs
11. Install Aztec Node with Watchtower
12. Delete Aztec node
13. Stop Aztec node containers
14. Start Aztec node containers
15. Update Aztec node
16. Downgrade Aztec node
17. Check Aztec version
18. Generate BLS keys
19. Approve
20. Stake

0. 🚪 Exit

## 🚀 Using the Node Monitoring Agent

After running the script, select the option to `Install node monitoring agent with notifications`:

- Creates an agent at `~/aztec-monitor-agent`
- Set up a systemd service and timer (run every 37 seconds)
- Sends an initial status update to Telegram
- Continuously monitors the node and logs to `~/aztec-monitor-agent/agent.log`
- Sends Telegram alerts if:
   - The Aztec container is not found
   - There is a mismatch between the latest block in the logs and in the smart contract **> 3 blocks**
   - There is an RPC server issue
   - Critical errors found
   - Selected for committee
   - Statistics for each slot while validator to the committee (successful/missed attestation, proposed/mined/missed block)
- Clears the log file when it reaches 1 MB in size, saving the very first report.

### Requirements for Monitoring Agent:

1. Get a Telegram token from [BotFather](https://t.me/BotFather)
2. Find your `chat_id` using [IDBot](https://t.me/myidbot)
3. Enter these in the script during cron-agent setup.
   The script validates both token and chat ID — if entered incorrectly, you will see a warning.

### Updating the Monitoring Agent

If there is an update for the cron-agent, first update the entire script. Then delete the old agent and create a new one. The ChatID and Telegram token you previously entered are automatically assigned to the new agent.

## 🚀 Installing the Aztec node

To install the Aztec node, select **option 11** and follow the script instructions.

A step-by-step description of the node installation process can be found here: [Aztec-Install-by-Script.md](https://github.com/pittpv/aztec-monitoring-script/blob/main/en/Aztec-Install-by-Script.md)

## ⚠️ Important

This script is not an official product of Aztec Network and is provided "as is".

## 📜 License

MIT License © 2025

## ✍️ Feedback

For any issues, suggestions, or feedback:

[https://t.me/+DLsyG6ol3SFjM2Vk](https://t.me/+DLsyG6ol3SFjM2Vk)

## 🔗 Useful Links

[One-click RPC setup script](https://github.com/pittpv/sepolia-auto-install "Quickly set up a Sepolia node for RPC")
