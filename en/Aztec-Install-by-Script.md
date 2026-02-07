# Installing an Aztec Node Using the Script from pittpv

This guide will help you quickly and easily deploy an Aztec node using the convenient monitoring and management script from **pittpv**. The script automates most of the routine tasks, minimizing the risk of errors.

## Launching the Script

To run the script for the first time, execute the following one-line command in your terminal:

```bash
curl -o aztec-logs.sh https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/aztec-logs.sh && chmod +x aztec-logs.sh && ./aztec-logs.sh
```

> **Important:** For all later launches, use the command:
> ```bash
> cd $HOME && ./aztec-logs.sh
> ```

## Initial Setup

After launch, the script will check for the necessary system software (such as `docker`, `docker-compose`, `jq`, etc.) and offer to install it if missing. **Agree to the installation** by answering `y` (yes).

In the script's main menu, you will be presented with a list of options. To begin the node installation:

1.  **Select item `11` from the main menu and press Enter.**

    ![Script Main Menu](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/Aztec-Install-by-Script/1.jpg)

## Port Check and Dependency Installation

The script will automatically check if the ports required for the node to operate (40400, 8080) are occupied. If they are, it will offer to assign different ones, but **it is recommended to use the standard ports** if possible.

Next, it will check for software specific to the Aztec node and again offer to install it. **Agree to the installation**.

> **Note:** If the `ufw` firewall is active on your server, the script will automatically open all necessary ports.

## Installing Binaries and the Docker Image

At this stage, the script will initiate the download and installation of node components using the original script from the Aztec team.

**Attention! If the following prompt appears:**
```
Add it to /root/.bash_profile to make the aztec binaries accessible?
```

**Enter `n` (no).** Only for the question listed above. Please be careful.

![Prompt about adding to .bash_profile](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/Aztec-Install-by-Script/2.jpg)

## Validator Setup

The next questions is:
```
Do you want to run multiple validators? (y/n)

Do you have BLS keys? (y/n)
```

*   If you are running **one validator**, enter `n`.
*   If you plan to run **multiple validators**, enter `y`.

    ![Choosing the number of validators](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/Aztec-Install-by-Script/3.jpg)

### For multivalidator mode

Next, you need to enter the validator data. For each validator, enter the data in the strict format:

`private_key_with_0x,validator_address`

Example:
`0xa1b2c3d4e5f6...,0x742d35Cc6634C0532925a3b844Bc454e4438f44e`

If the option with BLS keys is selected, then in strict format:

`private_key_with_0x,validator_address,private_BLS_key_with_0x,public_BLS_address`

Example:
`0xa1b2c3d4e5f6...,0x742d35Cc6634C0532925a3b844Bc454e4438f44e,0xa1b2c3d4e5f6...,0x12d4720c311e6d2e0826738a071fa06743f6cb8efd586ed718c3b020f09b5c8d`

⚠️ If you plan to use **one address** to pay Sepolia ETH for transactions of **all** validators, then enter the data of that address first. After entering the data of all validators the script will ask whether to use the first address as the publisher address for all validators (`Use first address as publisher for all validators?`) - choose **`y`**.

If Sepolia ETH is present on all addresses, you can choose **`n`**

![Entering validator data](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/Aztec-Install-by-Script/4.jpg)

### For single validator mode

Enter the private key and the validator's eth address separately.

### Aztec L2 address for feeRecipient

After this, the script will request your **Aztec L2 address**, which you can create on the website: https://app.obsidion.xyz/ or extension https://azguardwallet.io/.

If for some reason you cannot create an Aztec L2 address, then insert `0x0000000000000000000000000000000000000000000000000000000000000000`

If you wish, you can later replace it with a real L2 address.

![Entering L2 address](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/Aztec-Install-by-Script/5.jpg)

> **Important:** The script will automatically create all necessary configuration files (`YML` for web3signer in `/root/aztec/keys` and `keystore.json` in `/root/aztec/config`).

## Docker Compose Configuration

For the final node setup, the script will request data to generate the `docker-compose.yml` file:

*   **`ETHEREUM_RPC_URL`** — Your RPC URL for Ethereum L1. **Important:** For mainnet, use mainnet RPC; for testnet, use Sepolia testnet RPC.
*   **`CONSENSUS_BEACON_URL`** — Your RPC URL for the Beacon Chain. **Important:** For mainnet, use mainnet Beacon Chain RPC; for testnet, use Sepolia testnet Beacon Chain RPC.
*   **`COINBASE`** — The Ethereum wallet address. Enter the address of your validator.
*   **`P2P_IP`** — This parameter will be determined automatically by the script. **If you are using a VPN on the server**, after completing the node installation, you must enter the real IP address **manually** in the `.env` file in the `/root/aztec` folder

    ![Entering RPC and other data](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/Aztec-Install-by-Script/6.jpg)

## Network Selection (Mainnet/Testnet)

After entering the RPC addresses, the script will prompt you to select the network for the node:

1.  **Mainnet** — Aztec main network
2.  **Testnet** — Aztec test network

Select the desired network by entering the corresponding number (1 or 2).

> **Important:** 
> *   The selected network determines which network your node will operate on
> *   Node data will be stored in different directories: `/root/.aztec/mainnet/data/` for mainnet and `/root/.aztec/testnet/data/` for testnet
> *   Make sure you use the correct RPC addresses for the selected network
> *   The selected network is saved in the `~/.env-aztec-agent` file in the `NETWORK` variable

## Installing Watchtower

The script will offer to install **Watchtower** — a service for automatically updating your node's containers. To configure Telegram notifications about the update process, you will need:

1.  **Telegram Token:** Obtain it from [BotFather](https://t.me/BotFather) by creating a new bot.
2.  Be sure to **go to your created bot** and send the command `/start` in the chat.
3.  **Chat ID:** Find out your chat ID, for example, using the [@myidbot](https://t.me/myidbot).

Enter the requested data when the corresponding prompts appear.

![Entering data for Telegram notifications](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/Aztec-Install-by-Script/7.jpg)

## Installing web3signer

The script will automatically download the web3signer image and launch it with the required arguments.

## Completion and Verification

After completing all steps, the script will report a successful installation and automatically start showing logs (`docker-compose logs -f`).

**Wait for the logs to appear and make sure the node has started syncing.** To exit the log view mode, press **`Ctrl+C`**.

The node installation is now complete.

## Next Steps

1.  **Check the node's sync status** by selecting option `1` in the script's main menu.
2.  **Install the monitoring agent** for convenient node monitoring via option `2` in the main menu.
3.  **Download the critical error definitions file** using option `24`.
4.  **Check the validator status and set up queue position monitoring** using option `9`

Be sure to explore other features of the script available in the main menu, such as:
*   Starting and stopping containers
*   Downgrading the node version (in case of issues with an update)
*   Viewing logs and statistics

## Reinstalling the Node and Adding BLS Keys (Option 18)

When reinstalling the node (option 11) or adding BLS keys later, it helps to understand the two installation modes and how **option 18** (Generate BLS keys from mnemonic) sub-options work with them.

### Installing the Node: With or Without BLS

- **With BLS keys** — During installation (option 11), when asked “Do you have BLS keys?” answer **`y`** and enter, for each validator, data in the format:  
  `private_key,address,private_BLS,public_BLS`.  
  The script will create `keystore.json` and BLS YML files immediately. No extra BLS steps are needed.

- **Without BLS keys** — Answer **`n`**. The script will create `keystore.json` with only the validators’ eth addresses (no `bls` field). You can add BLS keys later via option 18, as described below.

### Script-Internal File

The file **`bls-filtered-pk.json`** is created and used **only by the script**. You do not need to edit it manually, except in the dashboard case (see variant 2 below). Path: `$HOME/aztec/bls-filtered-pk.json`.

---

### Variant A: BLS from the Same Mnemonic as the Addresses in Keystore (Options 18-2 and 18-3)

Use this when you installed the node with a validator whose eth address comes from your mnemonic, and you now want to generate BLS keys for that address from the same mnemonic.

1. **Option 18 → sub-option 2** (existing addresses from mnemonic).
2. Enter your mnemonic phrase and the **number of wallets** to generate (e.g. 30 or 50). The script will generate keys for that many indices, then keep only those whose eth address matches the addresses in `keystore.json`.  
   Result: **`bls-filtered-pk.json`** is created with keys for exactly the addresses you added as validators when installing the node.
3. If the node was installed **without BLS**, run **Option 18 → sub-option 3** (add BLS keys to keystore). The script will copy BLS from `bls-filtered-pk.json` into `keystore.json`.
4. Then you can either:
    - **Variant 1:** Run **options 19 (Approve)** and **20 (Stake)** to stake the validator.
    - **Variant 2 (dashboard key):** Run **Option 18 → sub-option 4** (dashboard keystores). Enter the **same number of addresses** as in step 2 (e.g. 30). The script will create files in the new format with all generated addresses. Open the created file, **manually remove the extra entries** and keep only the one that corresponds to your validator.

---

### Variant B: New Operator Address (Option 18-1)

Use this when you want to create a **new** eth address and BLS keys (e.g. to switch to a new wallet).

1. **Option 18 → sub-option 1** (new operator address).
2. Enter your old private key (or keys separated by commas). The script will generate new keys and create **`bls-filtered-pk.json`** with `new_operator_info` for each validator.
3. Fund the new eth address with Sepolia ETH (0.1–0.3), then run **options 19 (Approve)** and **20 (Stake)**. Option 20 will **update `keystore.json`** on successful stake, replacing the old address with the new operator address and creating YML files with the new keys.
4. **Option 18-3** is not used in this flow — keystore address replacement is done in option 20.

---

### Variant C: Dashboard Keystores Only (Option 18-4)

When you only need keystores for the staking dashboard (docs.aztec.network), without changing the node configuration:

- **Option 18 → sub-option 4.** Choose new mnemonic (1) or enter existing (2), and enter the number of validator identities. The script will create **`dashboard_keystore.json`** and **`dashboard_keystore_staker_output.json`** in `$HOME/aztec/`. The node’s `keystore.json` and `bls-filtered-pk.json` are not modified.

---

### Quick Reference: Option 18 Sub-options

| Sub-option | Purpose | Does it change `keystore.json`? |
|------------|---------|---------------------------------|
| **18-1** | New operator address; then 19 and 20 (20 updates keystore) | Not directly; updated in option 20 |
| **18-2** | BLS from mnemonic for addresses already in keystore from installation | No; only creates `bls-filtered-pk.json` |
| **18-3** | Copy BLS from `bls-filtered-pk.json` into `keystore.json` | Yes |
| **18-4** | Dashboard keystores (separate files in `$HOME/aztec/`) | No |

We wish you stable operation and success in running your node!

Best regards,  
pittpv

> **If you have any questions about the script's operation**, ask them in our Telegram chat: [https://t.me/+DLsyG6ol3SFjM2Vk](https://t.me/+DLsyG6ol3SFjM2Vk)
