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

The next question is:
```
Do you want to run multiple validators?
```

*   If you are running **one validator**, enter `n`.
*   If you plan to run **multiple validators**, enter `y`.

    ![Choosing the number of validators](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/Aztec-Install-by-Script/3.jpg)

### For multivalidator mode

Next, you need to enter the validator data. For each validator, enter the data in the strict format:
`private_key_with_0x,validator_address`

Example:
`0xa1b2c3d4e5f6...,0x742d35Cc6634C0532925a3b844Bc454e4438f44e`

⚠️ If you plan to use **one address** to pay Sepolia ETH for transactions of **all** validators, then enter the data of that address first. After entering the data of all validators the script will ask whether to use the first address as the publisher address for all validators (`Use first address as publisher for all validators?`) - choose **`y`**.

If Sepolia ETH is present on all addresses, you can choose **`n`**

![Entering validator data](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/Aztec-Install-by-Script/4.jpg)

### For single validator mode

Enter the private key and the validator's eth address separately.

### Aztec L2 address for feeRecipient

After this, the script will request your **Aztec L2 address**, which you can create on the official website: https://app.obsidion.xyz/.

If for some reason you cannot create an Aztec L2 address, then insert any private key from an eth wallet, it has the same length as the Aztec L2 address.

If you wish, you can later replace it with a real L2 address.

![Entering L2 address](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/Aztec-Install-by-Script/5.jpg)

> **Important:** The script will automatically create all necessary configuration files (`YML` for web3signer in `/root/aztec/keys` and `keystore.json` in `/root/aztec/config`).

## Docker Compose Configuration

For the final node setup, the script will request data to generate the `docker-compose.yml` file:

*   **`ETHEREUM_RPC_URL`** — Your RPC URL for Ethereum L1.
*   **`CONSENSUS_BEACON_URL`** — Your RPC URL for the Beacon Chain.
*   **`COINBASE`** — The Ethereum wallet address. Enter the address of your validator.
*   **`P2P_IP`** — This parameter will be determined automatically by the script.

    ![Entering RPC and other data](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/Aztec-Install-by-Script/6.jpg)

## Installing Watchtower

The script will offer to install **Watchtower** — a service for automatically updating your node's containers. To configure Telegram notifications about the update process, you will need:

1.  **Telegram Token:** Obtain it from [BotFather](https://t.me/BotFather) by creating a new bot.
2.  **Chat ID:** Find out your chat ID, for example, using the [@myidbot](https://t.me/myidbot).

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
3.  **Check the validator status and set up queue position monitoring** using option `9`

Be sure to explore other features of the script available in the main menu, such as:
*   Starting and stopping containers
*   Downgrading the node version (in case of issues with an update)
*   Viewing logs and statistics

We wish you stable operation and success in running your node!

Best regards,  
pittpv

> **If you have any questions about the script's operation**, ask them in our Telegram chat: [https://t.me/+DLsyG6ol3SFjM2Vk](https://t.me/+DLsyG6ol3SFjM2Vk)
