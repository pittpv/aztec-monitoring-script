# Aztec Node Install & Monitoring script (mainnet & testnet)

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

* 🐳 Monitoring the operation of the Aztec node
* 🏃🏻‍ Node launch (docker-compose or CLI)
* 🔗 Block freshness checks (compared to the smart contract)
* 🔍 Log parsing for critical parameters
* 📨 Telegram alerts on issues and validator activity
* ⏰ systemd service for automatic monitoring

## 🛠️ Functionality

| Feature          | Description                                              |
| ---------------- |----------------------------------------------------------|
| ✅ **Container**  | Monitors the status of the Aztec Docker container        |
| 🔄 **Blocks**    | Compares local block height with on-chain height         |
| 🤖 **Telegram**  | Instant notifications about problems and slot statistics |
| 🌐 **Languages** | Language support English/Russian/Turkish                 |
| ⚙️ **RPC**       | Flexible RPC endpoint configuration                      |

## 📌 Latest Updates 19-12-2025

⚠️ After updating the script, delete the old critical error definitions file (`aztec_error_definitions.json` or `error_definitions.json`) in the script root directory and download a new one via **Option 24**. Also delete the old monitoring agent (option 3) and create a new agent (option 2).

- Full support for mainnet and testnet in all script functions
- Security update of the script
  - Removed automatic downloading and execution of external files
  - All additional scripts (logo.sh, install_aztec.sh, check-validator.sh) are integrated into the main aztec-logs.sh script
  - Added a manual function to check for a new script version (Option 23) with file hash verification and user confirmation prompts
  - Added a manual function to check for a new critical error definitions file version (Option 24) with file hash verification and user confirmation prompts. On first run, you must use this option to download the error_definitions.json file.
- Improved `claim_rewards` function (Option 21)
  - If a coinbase address is not specified, the check will be performed using the attester's ETH address
  - Improved output to display the correct ticker depending on the network: STK for testnet, AZTEC for mainnet
- Node installation function update
  - `docker-compose.yml` aligned with the official documentation
  - `web3signer` correctly configured to work in the isolated Aztec network
  - If using a firewall, open RPC ports for the Docker subnet used by the Aztec network
- Node removal function update
  - Added an option to remove `web3signer` after confirmation
- Critical error definitions file update
  - Added a new error
  - Updated structure, added version specification
- Removed the last hardcoded `root` reference in the systemd service file for the monitoring agent. If you are not `root`, ensure your user has sufficient system permissions!
- Script code refactoring
- Improved translations in three languages
- Minor improvements

**error_definitions.json**
SHA256: `506e6e023f63e1068cd2b5529acbde16e42ec34cace4fcc6b9a8abc41730f4b4`

**version_control.json**
SHA256: `9f05c9e36c83b6574dadb5c8ce73078b5037bd2440915ed440e7ab0a67f45e92`

<details>
<summary>📅 Version History</summary>

### 10-12-2025

⚠️ After updating the script, delete the old agent (option 3) and create a new agent (option 2)

- **Menu Options Reordered**
  - Options have been reordered according to new requirements

- **Publisher Balance Monitoring (Option 10)**
  - Added monitoring management function with three sub-options:
    - Sub-option 1: Add addresses and start balance monitoring (The default minimum is 0.15 ETH)
    - Sub-option 2: Configure minimum balance threshold to a value other than the default
    - Sub-option 3: Stop balance monitoring
  - Addresses are saved to `.env-aztec-agent` in the `PUBLISHERS` variable
  - Minimum balance is saved to the `MIN_BALANCE_FOR_WARNING` variable
  - Implemented automatic balance checking in agent script:
    - When monitoring is enabled (`MONITORING_PUBLISHERS=true`), the agent checks balances of all addresses from `PUBLISHERS`
    - Balance checking is performed via `cast balance` using `RPC_URL`
    - When balance reaches the `MIN_BALANCE_FOR_WARNING` threshold, a Telegram notification is sent
  - Balance message formatting:
    - Addresses are displayed in monospace format (copyable)
    - Balance is shown on a new line below the address
    - Empty line added between addresses for better readability

- **Enter Key Wait After Menu Function Execution**
  - After executing any function, "Press Enter to continue..." message is shown
  - After pressing Enter, the screen is cleared and logo with main menu is shown again
  - Not applied for invalid choice and program exit

- **Updated Translations and Messages**
  - Updated translations for all three languages (English, Russian, Turkish)
  - Improved menu option wording

- Fixes and Improvements

### 08-12-2025

⚠️ After updating the script, delete the old agent (option 3) and create a new agent (option 2)

- Minor fix to the monitoring log file clearing function, /aztec-monitor-agent/agent.log
- New containers have been added to exceptions: watchtower, otel, prometheus, grafana

### 05-12-2025

This update improves compatibility with various systemd and Ubuntu versions. If you encounter any issues, we recommend updating to the latest version.

- Fixed line break issues in systemd unit files and .env-aztec-agent
    - Full compatibility with different systemd versions (fixed broken characters instead of line breaks)
    - All files are now created with correct line breaks (LF)
    - Added validation and cleanup function for .env-aztec-agent before creating systemd service
- Monitoring agent improvements
    - Log file size now depends on DEBUG mode: 10 MB when DEBUG=true, 1 MB when DEBUG=false
    - Improved RPC URL handling (ALT_RPC priority over RPC_URL)
    - Added FOUNDRY_DISABLE_NIGHTLY_WARNING=1 to suppress Foundry warnings
    - Improved warning filtering when executing cast call
- Improvements in monitoring agent creation function
    - Added validation check for systemd unit files before activation
    - Improved error handling when creating and starting systemd service
- Minor improvements

### 23-11-2025

⚠️ **If your script version is 2.3.2 or lower, you will need to completely reinstall the node. Prepare the data before installation!**

For multivalidator mode with BLS keys use the format: `private_key,address,private_bls,public_bls`

For multivalidator mode without BLS keys use the format: `private_key,address`

For single-validator mode the same data is required but provided separately.

- Full mainnet support in all script functions
- All `/root` replaced with `$HOME`
- Added reward collection function (Claim)
    - Checks availability of reward collection in the contract
    - Displays the nearest reward collection time, if available
    - Supports multiple coinbase addresses from the keystore
    - Collects only from validators that have rewards
    - Collects only from unique coinbase addresses
    - Processes transactions through the keystore with the appropriate signature
    - Checks transaction statuses and confirms successful execution
- Monitoring updates
    - Works with previously installed nodes (the node container name must contain the word aztec, and there must be only one container in the system containing the word aztec)
    - Added network type request on first launch and saving the variable to .env-aztec-agent
    - ALT_RPC variable — you can manually add the ALT_RPC variable to .env-aztec-agent, which will take priority over the default RPC_URL
- Minor improvements

### 20-11-2025

⚠️ **A full node reinstallation is required. Prepare the data before installation!**

For multivalidator mode with BLS keys use the format: `private_key,address,private_bls,public_bls`

For multivalidator mode without BLS keys use the format: `private_key,address`

For single-validator mode the same data is required but provided separately.

- Network selection testnet/mainnet when installing the node
    - Written to the NETWORK variable in .env-aztec-agent
    - Added to docker-compose.yml
    - Script parameters change depending on the network
- New method of adding validators with BLS keys
    - Automatic creation of BN254-type yml files for web3signer
    - Support for multivalidator and solo modes
- Updated structure of keystore.json, mainnet-ready
    - `slasher` removed
    - `attester`: with an eth field instead of a simple string
    - `publisher`: Now it is an array of strings
    - `coinbase`: now in the keystore schema, removed from env and docker-compose.yml
- Updated BLS generation functions considering the new keystore.json structure
    - Warning to save public BLS keys
- Added function for migrating BLS into keystore – Option 18-3
    - Fetching migration data from bls-filtered-pk.json, comparing, and adding a private BLS key to your attester in keystore.json
- Updated watchtower image URL to support new Docker versions
- Updated function for obtaining validator statistics from the contract (Option 9)
    - Added reward display
- Updated validator queue monitoring function (recreate monitoring)
    - Added check for presence in the active set
    - Added notification about API issues or other reasons for removal from queue
    - Added index
- Added translation on the first RPC request – Enter Ethereum RPC URL

### 13-11-2025

- Added a method for generating a new operator from an old validator private key (requires node installation via this script, option 11)
    - support for multivalidator mode
    - creation of a new address, private, and BLS keys from old private keys
    - correct data sorting according to the order of addresses in keystore.json, regardless of the order in which you enter the old private keys for generating new ones.
- Staking function update
    - automatic detection of the selected BLS key generation method
    - automatic replacement of the validator address in keystore.json when creating new addresses
    - automatic creation of new yml files with private keys
    - keystore.json backup
    - automatic restart of web3signer
    - preview of the staking command before execution
- Updated the Validator Search and Status Check function (**Option 9**)
    - **Restored** the validator queue monitoring function
    - Added a function to delete the validator queue monitoring
    - New URL for displaying sequencer data on the test network at Dashtec.xyz
    - Easily copy the attester and withdraw address, as well as the transaction hash
- Slot statistics monitoring
    - New URL for the sequencer page
- Minor improvements in main script
- Minor improvements in monitoring agent script
- Minor improvements in node installation script

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

❗️It is recommended to run as `root` user in the root directory.

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
   * Enter RPC URL (RPC must be available at `http://localhost:8545` or `http://127.0.0.1:8545` or `http://YOUR_EXTERNAL_IP:PORT`)
   * Enter the network type (mainnet, testnet)
   * Configure the Telegram bot
   * Enable monitoring (option 2)

❗️To obtain slot statistics, the node **must** have the log level set to: `info;debug:node:sentinel` or `debug`

## 🖥️ Usage

Main menu:

1. Check container and node synchronization
2. Install node monitoring agent with notifications
3. Remove monitoring agent
4. View Aztec logs
5. Find rollupAddress
6. Find PeerID
7. Find governanceProposerPayload
8. Check Proven L2 Block
9. Validator search, status check and queue monitoring
10. Publisher balance monitoring
11. Install Aztec Node with Watchtower
12. Delete Aztec node
13. Start Aztec node containers
14. Stop Aztec node containers
15. Update Aztec node
16. Downgrade Aztec node
17. Check Aztec version
18. Generate BLS keys from mnemonic
19. Approve
20. Stake
21. Claim rewards
22. Change RPC URL

`0.` 🚪 Exit

## 🚀 Using the Node Monitoring Agent

After running the script, select the option to `Install node monitoring agent with notifications`:

- Creates an agent at `~/aztec-monitor-agent`
- Set up a systemd service and timer (run every 37 seconds)
- Sends two messages to Telegram: about connecting your ChatID to monitoring and the initial status of the node
- Continuously monitors the node and logs to `~/aztec-monitor-agent/agent.log`
  - You can enable extended logging with `DEBUG=true` in the `/.env-aztec-agent` file
- Sends Telegram alerts if:
  - The Aztec container is not found
  - There is a mismatch between the latest block in the logs and in the smart contract **> 3 blocks**
  - There is an RPC server issue
  - Critical errors found
  - Selected for committee
  - Statistics for each slot while validator to the committee (successful/missed attestation, proposed/mined/missed block)
- Clears the log file when it reaches 1 MB in normal mode and 10 MB in `DEBUG=true` mode, saving the very first report.

### Requirements for Monitoring Agent:

1. Get a Telegram token from [BotFather](https://t.me/BotFather)
2. Find your `chat_id` using [IDBot](https://t.me/myidbot)
3. Enter these in the script during cron-agent setup.
   The script validates both token and chat ID — if entered incorrectly, you will see a warning.

### Updating the Monitoring Agent

If there is an update for the cron-agent, first update the entire script. Then delete the old agent and create a new one. The ChatID and Telegram token you previously entered are automatically assigned to the new agent.

## 🚀 Installing the Aztec node v 2.1.9

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
