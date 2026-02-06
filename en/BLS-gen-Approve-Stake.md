# BLS: Key Generation, Approve and Stake (Options 18, 19, 20)

Detailed description of **option 18** (BLS key generation and sub-options), **option 19** (Approve), and **option 20** (Stake) in the aztec-logs script for Aztec validator staking.

---

## Option 18 — Generate BLS Keys from Mnemonic

When you select **18** in the main menu, the **"BLS Keys Generation and Transfer"** submenu opens with four ways to work with BLS keys.

### Option 18 submenu

| # | Description |
|---|-------------|
| **1** | Generate new operator address (recommended) |
| **2** | Generate using existing addresses (from mnemonic; only if all validator addresses are from the same seed phrase) |
| **3** | Add BLS keys to keystore.json |
| **4** | Generate dashboard keystores (private + staker_output for staking dashboard) — **recommended** |

---

### Sub-option 18-1: New Operator Address (recommended)

**Purpose:** Replace the validator operator: for each existing validator a **new** ETH address and new BLS key are generated. The old address remains in the contract (for withdrawals etc.), while staking is tied to the new operator.

**What the script does:**

1. Prompts for **old validator private keys** (one or more, comma-separated, no spaces; input is hidden).
2. Derives old ETH addresses from these keys and checks them against `$HOME/aztec/config/keystore.json`.
3. Reads `feeRecipient` from the first validator in keystore.
4. For **each** old key in turn:
   - Asks you to press Enter and runs `aztec validator-keys new --fee-recipient <feeRecipient>` (no mnemonic — a new key pair is generated).
   - From the generated `~/.aztec/keystore/key1.json` it extracts the new ETH private key, BLS private key, and new ETH address.
   - Associates the old address with the new keys and keeps them in memory.
5. Builds **`$HOME/aztec/bls-filtered-pk.json`** in the same order as validators in keystore. Each entry contains:
   - `attester.eth` — old private key (used to sign the staking transaction),
   - `attester.bls` — new BLS private key,
   - `attester.old_address` — old address,
   - `feeRecipient`,
   - `new_operator_info`: new ETH private key, new BLS, new ETH address, RPC URL.

**Important:**  
- Save all new data (mnemonic if used again, new addresses and BLS). Private keys are also stored in `bls-filtered-pk.json`.  
- The script then suggests: send 0.1–0.3 Sepolia ETH to the new address, then run **option 19 (Approve)** and **option 20 (Stake)**.

**When to use:** Changing the validator operator (new wallet and new BLS keys while keeping old addresses in the system).

---

### Sub-option 18-2: Existing Addresses (from one mnemonic)

**Purpose:** Get BLS keys for **existing** validator ETH addresses when all those addresses are derived from **one** mnemonic phrase.

**What the script does:**

1. Prompts for **mnemonic phrase** (hidden input) and **number of wallets** (e.g. 1, 30, 50 — better to overestimate; extras are discarded).
2. Reads **feeRecipient** from `$HOME/aztec/config/keystore.json` (first validator).
3. Runs `aztec validator-keys new` with:
   - `--fee-recipient`, `--mnemonic`, `--count`, `--file bls.json`, `--data-dir $HOME/aztec/`.
4. From the generated `bls.json`, for each validator it derives the ETH address from the private key (via `cast wallet address`), then builds a temporary `bls-ethwallet.json`.
5. Takes the list of validator addresses from keystore **in the same order** and builds **`bls-filtered-pk.json`**: only the pairs (ETH private + BLS private) whose addresses match keystore. Entry order matches keystore.
6. Temporary files `bls.json` and `bls-ethwallet.json` are removed.

**Result:** In `$HOME/aztec/bls-filtered-pk.json` you have only keys that match validators in keystore. Format is “old”: no `new_operator_info`, only `attester.eth`, `attester.bls`, `feeRecipient`. You can then run **option 19** and **option 20** (old staking format).

**When to use:** All validators from one seed phrase, addresses already in keystore — you only need to add or refresh BLS keys.

---

### Sub-option 18-3: Add BLS Keys to keystore.json

**Purpose:** Write BLS private keys from `bls-filtered-pk.json` into `$HOME/aztec/config/keystore.json` (into `attester.bls` for each validator by matching ETH address).

**What the script does:**

1. Checks that `$HOME/aztec/bls-filtered-pk.json` and `$HOME/aztec/config/keystore.json` exist.
2. Creates a timestamped backup of keystore.
3. Builds a mapping: ETH address (from private key in bls-filtered-pk) → BLS private key.
4. For each validator in keystore, by `attester.eth` (address) it looks up the matching BLS from bls-filtered-pk and updates `attester.bls`.
5. Saves the updated keystore and prints a short report.

**When to use:** Only after BLS generation (sub-option 18-1 or 18-2) and only if BLS were derived from a seed phrase or you built `bls-filtered-pk.json` correctly yourself. Do not use with arbitrary files.

---

### Sub-option 18-4: Dashboard Keystores

**Purpose:** Create files for the **staking dashboard** (Aztec docs: sequencer_management etc.): private keystore and staker_output.

**What the script does:**

1. Uses directory `$HOME/aztec`, GSE address from network settings (mainnet/testnet), RPC from script settings (or default Sepolia).
2. Asks: new mnemonic **(1)** or enter your own **(2)**.
3. Asks for number of validator identities (e.g. 1 or 5).
4. Runs `aztec validator-keys new` with:
   - `--fee-recipient` (zero address),
   - `--staker-output`,
   - `--gse-address`, `--l1-rpc-urls`, `--data-dir $HOME/aztec`,
   - `--file dashboard_keystore.json`,
   - if 2 was chosen — `--mnemonic "..."`,
   - `--count N`.
5. Output is saved under `$HOME/aztec/`:
   - **dashboard_keystore.json** — private keystore,
   - **dashboard_keystore_staker_output.json** — for the staking dashboard.

**When to use:** Preparing keys specifically for the Aztec staking web dashboard, not for options 19/20 in this script.

---

## Option 19 — Approve

**Purpose:** Allow the staking (rollup) smart contract to spend your staking token (approve up to 200000 ether in token units). Without this step, option 20 (Stake) cannot debit the token from your wallet.

**What the script does:**

1. Gets network, RPC, and contract address from script settings (`get_network_settings`).
2. Finds all `*.yml` files in `$HOME/aztec/keys/` (sorted by name, e.g. validator_1, validator_2). Files with “bls” in the name are skipped.
3. From each YML it extracts `privateKey:` (value in quotes).
4. For each key:
   - Computes ETH address and fetches **nonce** (pending) so nonces are not duplicated when sending several transactions in a row.
   - Gas: 50% above current gas price, minimum 10 gwei; on “replacement transaction underpriced” it retries with doubled gas and the next RPC.
   - Calls **ERC-20 approve**: token contract `0x5595cb9ed193cac2c0bc5393313bc6115817954b`, method `approve(address,uint256)` — spender is the staking (rollup) contract address, amount `200000 ether` (in token wei).
   - Uses a list of RPCs (primary + fallback Sepolia); different validators use different RPCs in rotation; ~12 second pause between transactions.

**Important:**  
- `$HOME/aztec/keys/` must contain YML files with the private keys of the wallets you will stake from.  
- If a transaction is stuck (pending), the script suggests cancelling or speeding it up (e.g. via MetaMask), then running Approve again.

**Order:** Approve (19) runs **after** BLS generation (18) and **before** Stake (20). For the “new operator” method (18-1), fund the new addresses with ETH for gas before 19.

---

## Option 20 — Stake

**Purpose:** Register the validator on the network (call the staking contract): bind the BLS key and validator data to the rollup contract. Uses data from `bls-filtered-pk.json` and, when needed, from `keystore.json`.

**What the script does:**

1. Checks that `$HOME/aztec/bls-filtered-pk.json` exists. If not — suggests running option 18 first.
2. Detects bls-filtered-pk format:
   - if the first validator has **`new_operator_info`** — **new format** (new operator method, 18-1);
   - otherwise — **old format** (existing addresses, 18-2).
3. Network, RPC, and rollup contract address come from script settings.

Behaviour then differs.

---

### Stake — Old format (existing method)

- For each validator from `bls-filtered-pk.json`:
  - ETH and BLS private keys come from `bls-filtered-pk.json` (fields `attester.eth`, `attester.bls`).
  - Attester ETH address is taken from **keystore.json** by the same index (order must match).
- Command per validator:
  - `aztec add-l1-validator`
  - `--l1-rpc-urls`, `--network`, `--private-key` (from bls-filtered-pk),
  - `--attester`, `--withdrawer` (address from keystore),
  - `--bls-secret-key` (from bls-filtered-pk),
  - `--rollup` (contract address).
- The script tries several RPCs on failure; asks for confirmation (y/s/q) before sending. After success it prints the validator link (e.g. dashtec.xyz).

---

### Stake — New format (new operator method)

- For each validator from `bls-filtered-pk.json`:
  - Old private key — `attester.eth` (used to sign the transaction).
  - New address and keys from `new_operator_info`: `eth_private_key`, `bls_private_key`, `eth_address`, and optionally `rpc_url`.
- Command is built the same way, but attester/withdrawer use the **new** address from `new_operator_info`.
- After successful stake:
  - A YML with the **new** private key is created in `$HOME/aztec/keys/` (for future Approve etc.).
  - In **keystore.json** the old validator address is replaced with the new one (so node config matches the new operator).
  - A **web3signer** restart is suggested to load the new key.

Validator links (mainnet/testnet) are printed the same as in the old format.

---

## Short step sequence

1. **Option 18** — choose the right sub-option (1: new operator, 2: existing addresses from mnemonic, 3: add BLS to keystore, 4: dashboard).
2. For **18-1**: fund the new addresses with 0.1–0.3 Sepolia ETH.
3. **Option 19** — Approve for all keys in `$HOME/aztec/keys/*.yml` (except bls).
4. **Option 20** — Stake using data from `bls-filtered-pk.json` (format is detected automatically).

After a successful Stake, validators appear in the explorer (e.g. dashtec.xyz), and the node can use the updated keystore and keys from `keys/`.
