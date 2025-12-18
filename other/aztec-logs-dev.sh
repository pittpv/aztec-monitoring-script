#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
VIOLET='\033[0;35m'
NC='\033[0m' # No Color

SCRIPT_VERSION="2.5.3"

# Determine script directory for local file access (security: avoid remote code execution)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# === Language settings ===
LANG=""
declare -A TRANSLATIONS

# Global status maps (will be filled in check_validator_main)
declare -gA STATUS_MAP
declare -gA STATUS_COLOR

# Translation function
t() {
  local key=$1
  echo "${TRANSLATIONS[$LANG,$key]}"
}

# Initialize languages
init_languages() {
  echo -e "\n${BLUE}Select language / Выберите язык:${NC}"
  echo -e "1. English"
  echo -e "2. Русский"
  echo -e "3. Türkçe"
  read -p "> " lang_choice

  case $lang_choice in
    1) LANG="en" ;;
    2) LANG="ru" ;;
    3) LANG="tr" ;;
    *) LANG="en" ;;
  esac

  # English translations
  TRANSLATIONS["en,welcome"]="Welcome to the Aztec node monitoring script"
  TRANSLATIONS["en,title"]="========= Main Menu ========="
  TRANSLATIONS["en,option1"]="1. Check container and node synchronization"
  TRANSLATIONS["en,option2"]="2. Install node monitoring agent with notifications"
  TRANSLATIONS["en,option3"]="3. Remove monitoring agent"
  TRANSLATIONS["en,option4"]="4. View Aztec logs"
  TRANSLATIONS["en,option5"]="5. Find rollupAddress"
  TRANSLATIONS["en,option6"]="6. Find PeerID"
  TRANSLATIONS["en,option7"]="7. Find governanceProposerPayload"
  TRANSLATIONS["en,option8"]="8. Check Proven L2 Block"
  TRANSLATIONS["en,option9"]="9. Validator search, status check and queue monitoring"
  TRANSLATIONS["en,option10"]="10. Publisher balance monitoring"
  TRANSLATIONS["en,option11"]="11. Install Aztec Node with Watchtower"
  TRANSLATIONS["en,option12"]="12. Delete Aztec node"
  TRANSLATIONS["en,option13"]="13. Start Aztec node containers"
  TRANSLATIONS["en,option14"]="14. Stop Aztec node containers"
  TRANSLATIONS["en,option15"]="15. Update Aztec node"
  TRANSLATIONS["en,option16"]="16. Downgrade Aztec node"
  TRANSLATIONS["en,option17"]="17. Check Aztec version"
  TRANSLATIONS["en,option18"]="18. Generate BLS keys from mnemonic"
  TRANSLATIONS["en,option19"]="19. Approve"
  TRANSLATIONS["en,option20"]="20. Stake"
  TRANSLATIONS["en,option21"]="21. Claim rewards"
  TRANSLATIONS["en,option22"]="22. Change RPC URL"
  TRANSLATIONS["en,option23"]="23. Check for script updates (safe, with hash verification)"
  TRANSLATIONS["en,option24"]="24. Check for error definitions updates (safe, with hash verification)"
  TRANSLATIONS["en,option0"]="0. Exit"

  # Update check translations
  TRANSLATIONS["en,local_version_shows"]="Local version file shows version:"
  TRANSLATIONS["en,note_check_updates_safely"]="Note: To check for remote updates safely, use the optional update check function"
  TRANSLATIONS["en,local_version_up_to_date"]="Local version file is up to date"
  TRANSLATIONS["en,safe_update_check"]="Safe Update Check"
  TRANSLATIONS["en,update_check_warning"]="This will download version_control.json from GitHub with SHA256 verification."
  TRANSLATIONS["en,file_not_executed_auto"]="The file will be downloaded but NOT executed automatically."
  TRANSLATIONS["en,continue_prompt"]="Continue? (y/n)"
  TRANSLATIONS["en,update_check_cancelled"]="Update check cancelled."
  TRANSLATIONS["en,downloading_version_control"]="Downloading version_control.json..."
  TRANSLATIONS["en,failed_download_version_control"]="Failed to download version_control.json"
  TRANSLATIONS["en,downloaded_file_sha256"]="Downloaded file SHA256:"
  TRANSLATIONS["en,verify_hash_match"]="Please verify this hash matches the expected hash from the repository."
  TRANSLATIONS["en,current_installed_version"]="Current installed version:"
  TRANSLATIONS["en,latest_version_repo"]="Latest version in repository:"
  TRANSLATIONS["en,new_version_available"]="New version available:"
  TRANSLATIONS["en,version_label"]="Version:"
  TRANSLATIONS["en,note_update_manually"]="Note: To update, pull the latest changes from the repository manually."
  TRANSLATIONS["en,safe_error_def_update_check"]="Safe Error Definitions Update Check"
  TRANSLATIONS["en,error_def_update_warning"]="This will download error_definitions.json from GitHub with SHA256 verification."
  TRANSLATIONS["en,downloading_error_definitions"]="Downloading error_definitions.json..."
  TRANSLATIONS["en,failed_download_error_definitions"]="Failed to download error_definitions.json"
  TRANSLATIONS["en,error_def_matches_remote"]="Local error_definitions.json matches the remote version."
  TRANSLATIONS["en,local_remote_versions_differ"]="Local and remote versions differ."
  TRANSLATIONS["en,local_hash"]="Local hash:"
  TRANSLATIONS["en,remote_hash"]="Remote hash:"
  TRANSLATIONS["en,local_error_def_not_found"]="Local error_definitions.json not found."
  TRANSLATIONS["en,bls_mnemonic_prompt"]="Copy all 12 words of your mnemonic phrase, paste it and press Enter (the input will be hidden, but pasted):"
  TRANSLATIONS["en,bls_wallet_count_prompt"]="Enter the number of wallets to generate. \nFor example: if your seed phrase contains only one wallet, insert the digit 1. \nIf your seed phrase contains several wallets for multiple validators, insert approximately the maximum number of the last wallet, for example 30, 50. \nIt is better to specify a larger number if you are not sure, the script will collect all keys and remove the extras."
  TRANSLATIONS["en,bls_invalid_number"]="Invalid number. Please enter a positive integer."
  TRANSLATIONS["en,bls_keystore_not_found"]="❌ keystore.json not found at $HOME/aztec/config/keystore.json"
  TRANSLATIONS["en,bls_fee_recipient_not_found"]="❌ feeRecipient not found in keystore.json"
  TRANSLATIONS["en,bls_generating_keys"]="🔑 Generating BLS keys..."
  TRANSLATIONS["en,bls_generation_success"]="✅ BLS keys generated successfully"
  TRANSLATIONS["en,bls_public_save_attention"]="⚠️ ATTENTION: Copy the account details above (white text) and save them, they contain eth addresses and public bls keys that you may need in the future."
  TRANSLATIONS["en,bls_generation_failed"]="❌ Failed to generate BLS keys"
  TRANSLATIONS["en,bls_searching_matches"]="🔍 Searching for matching addresses in keystore..."
  TRANSLATIONS["en,bls_matches_found"]="✅ Found %d matching addresses"
  TRANSLATIONS["en,bls_no_matches"]="❌ No matching addresses found in keystore.json"
  TRANSLATIONS["en,bls_filtered_file_created"]="✅ Filtered BLS keys saved to: %s"
  TRANSLATIONS["en,bls_file_not_found"]="❌ Generated BLS file not found"
  TRANSLATIONS["en,staking_title"]="Validators Staking"
  TRANSLATIONS["en,staking_no_validators"]="No validators found in"
  TRANSLATIONS["en,staking_found_validators"]="Found %d validators"
  TRANSLATIONS["en,staking_processing"]="Processing validator %d of %d"
  TRANSLATIONS["en,staking_data_loaded"]="Validator data loaded"
  TRANSLATIONS["en,staking_trying_rpc"]="Trying RPC: %s"
  TRANSLATIONS["en,staking_command_prompt"]="Do you want to execute this command?"
  TRANSLATIONS["en,staking_execute_prompt"]="Enter 'y' to proceed, 's' to skip this validator, 'q' to quit"
  TRANSLATIONS["en,staking_executing"]="Executing command..."
  TRANSLATIONS["en,staking_success"]="Successfully staked validator %d using RPC: %s"
  TRANSLATIONS["en,staking_failed"]="Failed to stake validator %d using RPC: %s"
  TRANSLATIONS["en,staking_skipped_validator"]="Skipping validator %d"
  TRANSLATIONS["en,staking_cancelled"]="Operation cancelled by user"
  TRANSLATIONS["en,staking_skipped_rpc"]="Skipping this RPC provider"
  TRANSLATIONS["en,staking_all_failed"]="Failed to stake validator %d with all RPC providers"
  TRANSLATIONS["en,staking_completed"]="Staking process completed"
  TRANSLATIONS["en,file_not_found"]="%s not found at %s"
  TRANSLATIONS["en,contract_not_set"]="CONTRACT_ADDRESS is not set"
  TRANSLATIONS["en,using_contract_address"]="Using contract address: %s"
  TRANSLATIONS["en,staking_failed_private_key"]="Failed to get private key for validator %d"
  TRANSLATIONS["en,staking_failed_eth_address"]="Failed to get ETH address for validator %d"
  TRANSLATIONS["en,staking_failed_bls_key"]="Failed to get BLS private key for validator %d"
  TRANSLATIONS["en,eth_address"]="ETH Address"
  TRANSLATIONS["en,private_key"]="Private Key"
  TRANSLATIONS["en,bls_key"]="BLS Key"
  TRANSLATIONS["en,bls_method_existing"]="Generate using existing addresses (from mnemonic, only if all validator addresses are from the same seed phrase)"
  TRANSLATIONS["en,bls_method_new_operator"]="Generate new operator address (recommended)"
  TRANSLATIONS["en,bls_method_prompt"]="Choose method (1/2): "
  TRANSLATIONS["en,bls_invalid_method"]="Invalid method selected"
  TRANSLATIONS["en,bls_existing_method_title"]="Existing Address Method"
  TRANSLATIONS["en,bls_new_operator_title"]="New Operator Address Method"
  TRANSLATIONS["en,bls_old_validator_info"]="Please provide your old validator info:"
  TRANSLATIONS["en,bls_old_private_key_prompt"]="Copy and paste one or more OLD private keys, separated by commas without spaces, and press Enter (the input is hidden, but pasted): "
  TRANSLATIONS["en,bls_sepolia_rpc_prompt"]="Enter your Sepolia RPC URL: "
  TRANSLATIONS["en,bls_starting_generation"]="Starting generation process..."
  TRANSLATIONS["en,bls_ready_to_generate"]="⚠️ ATTENTION: BE READY to write down all the new operator's details: the mnemonic phrase, public address and public BLS key. The private key and private BLS key will be saved in the file $HOME/aztec/bls-filtered-pk.json"
  TRANSLATIONS["en,bls_press_enter_to_generate"]="Press [Enter] to generate your new keys..."
  TRANSLATIONS["en,bls_add_to_keystore_title"]="Add BLS Keys to Keystore"
  TRANSLATIONS["en,bls_pk_file_not_found"]="BLS keys file not found: $HOME/aztec/bls-filtered-pk.json"
  TRANSLATIONS["en,bls_keystore_not_found"]="Keystore file not found: $HOME/aztec/config/keystore.json"
  TRANSLATIONS["en,bls_creating_backup"]="Creating backup of keystore.json..."
  TRANSLATIONS["en,bls_backup_created"]="Backup created"
  TRANSLATIONS["en,bls_processing_validators"]="Processing validators"
  TRANSLATIONS["en,bls_reading_bls_keys"]="Reading BLS keys from filtered file..."
  TRANSLATIONS["en,bls_mapped_address"]="Mapped address to BLS key"
  TRANSLATIONS["en,bls_failed_generate_address"]="Failed to generate address from private key"
  TRANSLATIONS["en,bls_no_valid_mappings"]="No valid address to BLS key mappings found"
  TRANSLATIONS["en,bls_total_mappings"]="Total address mappings found"
  TRANSLATIONS["en,bls_updating_keystore"]="Updating keystore with BLS keys..."
  TRANSLATIONS["en,bls_key_added"]="BLS key added for address"
  TRANSLATIONS["en,bls_no_key_for_address"]="No BLS key found for address"
  TRANSLATIONS["en,bls_no_matches_found"]="No matching addresses found between BLS keys and keystore"
  TRANSLATIONS["en,bls_keystore_updated"]="Keystore successfully updated with BLS keys"
  TRANSLATIONS["en,bls_total_updated"]="Validators updated"
  TRANSLATIONS["en,bls_updated_structure_sample"]="Updated validator structure sample"
  TRANSLATIONS["en,bls_invalid_json"]="Invalid JSON generated, restoring from backup"
  TRANSLATIONS["en,bls_restoring_backup"]="Restoring original keystore from backup"
  TRANSLATIONS["en,bls_operation_completed"]="BLS keys addition completed successfully"
  TRANSLATIONS["en,bls_to_keystore"]="Add BLS keys to keystore.json (run ONLY after BLS generation and ONLY if BLS are generated from a SEED phrase or you have correctly created bls-filtered-pk.json yourself)"
  TRANSLATIONS["en,bls_new_keys_generated"]="Good! Your new keys are below. SAVE THIS INFO SECURELY!"
  TRANSLATIONS["en,bls_new_eth_private_key"]="NEW ETH Private Key"
  TRANSLATIONS["en,bls_new_bls_private_key"]="NEW BLS Private Key"
  TRANSLATIONS["en,bls_new_public_address"]="NEW Public Address"
  TRANSLATIONS["en,bls_funding_required"]="You need to send 0.1 to 0.3 Sepolia ETH to this new address:"
  TRANSLATIONS["en,bls_funding_confirmation"]="After the funding transaction is confirmed, press [Enter] to continue..."
  TRANSLATIONS["en,bls_approving_stake"]="Approving STAKE spending..."
  TRANSLATIONS["en,bls_approve_failed"]="Approve transaction failed"
  TRANSLATIONS["en,bls_joining_testnet"]="Joining the testnet..."
  TRANSLATIONS["en,bls_staking_failed"]="Staking failed"
  TRANSLATIONS["en,staking_yml_file_created"]="YML key file created:"
  TRANSLATIONS["en,staking_yml_file_failed"]="Failed to create YML key file:"
  TRANSLATIONS["en,staking_total_yml_files_created"]="Total YML key files created:"
  TRANSLATIONS["en,staking_yml_files_location"]="Key files location:"
  TRANSLATIONS["en,bls_new_operator_success"]="All done! You have successfully joined the new testnet"
  TRANSLATIONS["en,bls_restart_node_notice"]="Now restart your node, check that YML files with new private keys have been added to /aztec/keys, and that /aztec/config/keystore.json has been replaced with the new eth addresses of the validators."
  TRANSLATIONS["en,bls_key_extraction_failed"]="Failed to extract keys from generated file"
  TRANSLATIONS["en,staking_run_bls_generation_first"]="Please run BLS keys generation first (option 18) or add "
  TRANSLATIONS["en,staking_invalid_bls_file"]="Invalid BLS keys file format"
  TRANSLATIONS["en,staking_failed_generate_address"]="Failed to generate address from private key"
  TRANSLATIONS["en,staking_found_single_validator"]="Found single validator for new operator method"
  TRANSLATIONS["en,staking_old_sequencer_prompt"]="For staking with new operator method, we need your old sequencer private key:"
  TRANSLATIONS["en,staking_old_private_key_prompt"]="Enter OLD Sequencer Private Key (hidden): "
  TRANSLATIONS["en,staking_success_single"]="Successfully staked validator with new operator method"
  TRANSLATIONS["en,staking_failed_single"]="Failed to stake validator with new operator method"
  TRANSLATIONS["en,staking_all_failed_single"]="All RPC providers failed for new operator staking"
  TRANSLATIONS["en,staking_skipped"]="Staking skipped"
  TRANSLATIONS["en,staking_keystore_backup_created"]="Keystore backup created:"
  TRANSLATIONS["en,staking_updating_keystore"]="Updating keystore.json - replacing old validator address with new operator address"
  TRANSLATIONS["en,staking_keystore_updated"]="Keystore updated successfully:"
  TRANSLATIONS["en,staking_keystore_no_change"]="No changes made to keystore (address not found):"
  TRANSLATIONS["en,staking_keystore_update_failed"]="Failed to update keystore.json"
  TRANSLATIONS["en,staking_keystore_skip_update"]="Skipping keystore update (old address not available)"
  TRANSLATIONS["en,bls_no_private_keys"]="No private keys provided"
  TRANSLATIONS["en,bls_found_private_keys"]="Found private keys:"
  TRANSLATIONS["en,bls_keys_saved_success"]="BLS keys successfully generated and saved"
  TRANSLATIONS["en,bls_next_steps"]="Next steps:"
  TRANSLATIONS["en,bls_send_eth_step"]="Send 0.1-0.3 Sepolia ETH to the address above"
  TRANSLATIONS["en,bls_run_approve_step"]="Run option 19 (Approve) to approve stake spending"
  TRANSLATIONS["en,bls_run_stake_step"]="Run option 20 (Stake) to complete validator staking"
  TRANSLATIONS["en,staking_missing_new_operator_info"]="Missing new operator information in BLS file"
  TRANSLATIONS["en,staking_found_validators_new_operator"]="Found validators for new operator method:"
  TRANSLATIONS["en,staking_processing_new_operator"]="Processing validator %s/%s (new operator method)"
  TRANSLATIONS["en,staking_success_new_operator"]="Successfully staked validator %s with new operator method using %s"
  TRANSLATIONS["en,validator_link"]="Validator link"
  TRANSLATIONS["en,staking_failed_new_operator"]="Failed to stake validator %s with new operator method using %s"
  TRANSLATIONS["en,staking_all_failed_new_operator"]="All RPC providers failed for validator %s with new operator method"
  TRANSLATIONS["en,staking_completed_new_operator"]="New operator staking completed!"
  TRANSLATIONS["en,command_to_execute"]="Command to execute"
  TRANSLATIONS["en,trying_next_rpc"]="Trying next RPC provider..."
  TRANSLATIONS["en,continuing_next_validator"]="Continuing with next validator..."
  TRANSLATIONS["en,waiting_before_next_validator"]="Waiting 2 seconds before next validator"
  TRANSLATIONS["en,rpc_change_prompt"]="Enter new RPC URL:"
  TRANSLATIONS["en,rpc_change_success"]="✅ RPC URL successfully updated"
  TRANSLATIONS["en,choose_option"]="Select option:"
  TRANSLATIONS["en,checking_deps"]="🔍 Checking required components:"
  TRANSLATIONS["en,missing_tools"]="Required components are missing:"
  TRANSLATIONS["en,install_prompt"]="Do you want to install them now? (Y/n):"
  TRANSLATIONS["en,missing_required"]="⚠️ Script cannot work without required components. Exiting."
  TRANSLATIONS["en,rpc_prompt"]="Enter Ethereum RPC URL:"
  TRANSLATIONS["en,network_prompt"]="Enter network type (e.g. testnet or mainnet):"
  TRANSLATIONS["en,env_created"]="✅ Created .env file with RPC URL"
  TRANSLATIONS["en,env_exists"]="✅ Using existing .env file with RPC URL:"
  TRANSLATIONS["en,rpc_empty_error"]="RPC URL cannot be empty. Please enter a valid URL."
  TRANSLATIONS["en,network_empty_error"]="Network cannot be empty. Please enter a network name."
  TRANSLATIONS["en,search_container"]="🔍 Searching for 'aztec' container..."
  TRANSLATIONS["en,container_not_found"]="❌ Container 'aztec' not found."
  TRANSLATIONS["en,container_found"]="✅ Container found:"
  TRANSLATIONS["en,get_block"]="🔗 Getting current block from contract..."
  TRANSLATIONS["en,block_error"]="❌ Error: Failed to get block number. Check RPC or contract."
  TRANSLATIONS["en,current_block"]="📦 Current block number:"
  TRANSLATIONS["en,node_ok"]="✅ Node is working and processing current block"
  TRANSLATIONS["en,node_behind"]="⚠️ Current block not found in logs. Node might be behind."
  TRANSLATIONS["en,search_rollup"]="🔍 Searching for rollupAddress in 'aztec' container logs..."
  TRANSLATIONS["en,rollup_found"]="✅ Current rollupAddress:"
  TRANSLATIONS["en,rollup_not_found"]="❌ rollupAddress not found in logs."
  TRANSLATIONS["en,search_peer"]="🔍 Searching for PeerID in 'aztec' container logs..."
  TRANSLATIONS["en,peer_not_found"]="❌ No PeerID found in logs."
  TRANSLATIONS["en,search_gov"]="🔍 Searching for governanceProposerPayload in 'aztec' container logs..."
  TRANSLATIONS["en,gov_found"]="Found governanceProposerPayload values:"
  TRANSLATIONS["en,gov_not_found"]="❌ No governanceProposerPayload found."
  TRANSLATIONS["en,gov_changed"]="🛑 GovernanceProposerPayload change detected!"
  TRANSLATIONS["en,gov_was"]="⚠️ Was:"
  TRANSLATIONS["en,gov_now"]="Now:"
  TRANSLATIONS["en,gov_no_changes"]="✅ No changes detected."
  TRANSLATIONS["en,token_prompt"]="Enter Telegram Bot Token:"
  TRANSLATIONS["en,chatid_prompt"]="Enter Telegram Chat ID:"
  TRANSLATIONS["en,removing_agent"]="🗑 Removing agent and systemd task..."
  TRANSLATIONS["en,agent_removed"]="✅ Agent and systemd task removed."
  TRANSLATIONS["en,goodbye"]="👋 Goodbye."
  TRANSLATIONS["en,invalid_choice"]="❌ Invalid choice. Try again."
  TRANSLATIONS["en,searching"]="Searching..."
  TRANSLATIONS["en,get_proven_block"]="🔍 Getting proven L2 block number..."
  TRANSLATIONS["en,proven_block_found"]="✅ Proven L2 Block Number:"
  TRANSLATIONS["en,proven_block_error"]="❌ Failed to retrieve the proven L2 block number."
  TRANSLATIONS["en,get_sync_proof"]="🔍 Fetching Sync Proof..."
  TRANSLATIONS["en,sync_proof_found"]="✅ Sync Proof:"
  TRANSLATIONS["en,sync_proof_error"]="❌ Failed to retrieve sync proof."
  TRANSLATIONS["en,token_check"]="🔍 Checking Telegram token and ChatID..."
  TRANSLATIONS["en,token_valid"]="✅ Telegram token is valid"
  TRANSLATIONS["en,token_invalid"]="❌ Invalid Telegram token"
  TRANSLATIONS["en,chatid_valid"]="✅ ChatID is valid and bot has access"
  TRANSLATIONS["en,chatid_invalid"]="❌ Invalid ChatID or bot has no access"
  TRANSLATIONS["en,agent_created"]="✅ Agent successfully created and configured!"
  TRANSLATIONS["en,running_validator_script"]="Running Check Validator script locally..."
  TRANSLATIONS["en,failed_run_validator"]="Failed to run Check Validator script."
  TRANSLATIONS["en,enter_aztec_port_prompt"]="Enter Aztec node port number"
  TRANSLATIONS["en,port_saved_successfully"]="✅ Port saved successfully"
  TRANSLATIONS["en,checking_port"]="Checking port"
  TRANSLATIONS["en,port_not_available"]="Aztec port not available on"
  TRANSLATIONS["en,current_aztec_port"]="Current Aztec node port:"
  TRANSLATIONS["en,log_block_not_found"]="❌ No line with 'Downloaded L2 block' found in logs."
  TRANSLATIONS["en,log_block_extract_failed"]="❌ Failed to extract block number from the line:"
  TRANSLATIONS["en,log_block_number"]="📄 Latest block from logs:"
  TRANSLATIONS["en,log_behind_details"]="⚠️ Logs are behind. Latest block in logs: %s, from contract: %s"
  TRANSLATIONS["en,log_line_example"]="🔎 Example log line:"
  TRANSLATIONS["en,press_ctrlc"]="Press Ctrl+C to exit and return to the menu"
  TRANSLATIONS["en,logs_starting"]="Logs will start in 5 seconds..."
  TRANSLATIONS["en,return_main_menu"]="Returning to the main menu..."
  TRANSLATIONS["en,current_script_version"]="📌 Current script version:"
  TRANSLATIONS["en,new_version_avialable"]="🚀 New version available:"
  TRANSLATIONS["en,new_version_update"]="Please update your script"
  TRANSLATIONS["en,version_up_to_date"]="✅ You are using the latest version"
  TRANSLATIONS["en,agent_log_cleaned"]="✅ Log file cleaned."
  TRANSLATIONS["en,agent_container_not_found"]="❌ Aztec Container Not Found"
  TRANSLATIONS["en,agent_block_fetch_error"]="❌ Block Fetch Error"
  TRANSLATIONS["en,agent_no_block_in_logs"]="❌ Block number not found in node logs"
  TRANSLATIONS["en,agent_failed_extract_block"]="❌ Failed to extract blockNumber"
  TRANSLATIONS["en,agent_node_behind"]="⚠️ Node is behind by %d blocks"
  TRANSLATIONS["en,agent_started"]="🤖 Aztec Monitoring Agent Started"
  TRANSLATIONS["en,agent_log_size_warning"]="⚠️ Log file cleaned due to size limit"
  TRANSLATIONS["en,agent_server_info"]="🌐 Server: %s"
  TRANSLATIONS["en,agent_file_info"]="🗃 File: %s"
  TRANSLATIONS["en,agent_size_info"]="📏 Previous size: %s bytes"
  TRANSLATIONS["en,agent_rpc_info"]="🔗 RPC: %s"
  TRANSLATIONS["en,agent_error_info"]="💬 Error: %s"
  TRANSLATIONS["en,agent_block_info"]="📦 Contract block: %s"
  TRANSLATIONS["en,agent_log_block_info"]="📝 Logs block: %s"
  TRANSLATIONS["en,agent_time_info"]="🕒 %s"
  TRANSLATIONS["en,agent_line_info"]="📋 Line: %s"
  TRANSLATIONS["en,agent_notifications_info"]="ℹ️ Notifications will be sent for issues"
  TRANSLATIONS["en,agent_node_synced"]="✅ Node synced (block %s)"
  TRANSLATIONS["en,chatid_linked"]="✅ ChatID successfully linked to Aztec Agent"
  TRANSLATIONS["en,invalid_token"]="Invalid Telegram bot token. Please try again."
  TRANSLATIONS["en,token_format"]="Token should be in format: 1234567890:ABCdefGHIJKlmNoPQRsTUVwxyZ"
  TRANSLATIONS["en,invalid_chatid"]="Invalid Telegram chat ID or the bot doesn't have access to this chat. Please try again."
  TRANSLATIONS["en,chatid_number"]="Chat ID must be a number (can start with - for group chats). Please try again."
  TRANSLATIONS["en,running_install_node"]="Running Install Aztec node script from GitHub..."
  TRANSLATIONS["en,failed_running_install_node"]="Failed to run Aztec node install script from GitHub..."
  TRANSLATIONS["en,failed_downloading_script"]="❌ Failed to download installation script"
  TRANSLATIONS["en,install_completed_successfully"]="✅ Installation completed successfully"
  TRANSLATIONS["en,logs_stopped_by_user"]="⚠ Log viewing stopped by user"
  TRANSLATIONS["en,installation_cancelled_by_user"]="✖ Installation cancelled by user"
  TRANSLATIONS["en,unknown_error_occurred"]="⚠ An unknown error occurred during installation"
  TRANSLATIONS["en,stop_method_prompt"]="Choose method to stop Aztec node (docker-compose / cli): "
  TRANSLATIONS["en,enter_compose_path"]="Enter full path to folder with docker-compose.yml ($HOME/your_path or ./your_path): "
  TRANSLATIONS["en,docker_stop_success"]="Containers stopped and docker path saved to .env-aztec-agent"
  TRANSLATIONS["en,no_aztec_screen"]="No active Aztec screen sessions found."
  TRANSLATIONS["en,cli_stop_success"]="Aztec CLI node stopped and session saved to .env-aztec-agent"
  TRANSLATIONS["en,invalid_path"]="Invalid path or docker-compose.yml not found."
  TRANSLATIONS["en,starting_node"]="Starting Aztec node..."
  TRANSLATIONS["en,node_started"]="Aztec node started."
  TRANSLATIONS["en,missing_compose"]="Path to docker-compose.yml not found in .env-aztec-agent."
  TRANSLATIONS["en,run_type_not_set"]="RUN_TYPE not set in configuration."
  TRANSLATIONS["en,confirm_cli_run"]="Do you want to run the container in CLI mode?"
  TRANSLATIONS["en,run_type_set_to_cli"]="RUN_TYPE set to CLI."
  TRANSLATIONS["en,run_aborted"]="Run aborted by user."
  TRANSLATIONS["en,checking_aztec_version"]="Checking Aztec version..."
  TRANSLATIONS["en,aztec_version_failed"]="Failed to retrieve aztec version."
  TRANSLATIONS["en,aztec_node_version"]="Aztec Node version:"
  TRANSLATIONS["en,critical_error_found"]="🚨 Critical error detected"
  TRANSLATIONS["en,error_prefix"]="ERROR:"
  TRANSLATIONS["en,solution_prefix"]="Solution:"
  TRANSLATIONS["en,notifications_prompt"]="Do you want to receive additional notifications?"
  TRANSLATIONS["en,notifications_option1"]="1. Critical errors only"
  TRANSLATIONS["en,notifications_option2"]="2. All notifications (including committee participation and validators activity)"
  TRANSLATIONS["en,notifications_debug_warning"]="DEBUG log level is required for committee and slot statistics notifications"
  TRANSLATIONS["en,notifications_input_error"]="Error: please enter 1 or 2"
  TRANSLATIONS["en,choose_option_prompt"]="Choose option"
  TRANSLATIONS["en,committee_selected"]="🎉 You've been selected for the committee"
  TRANSLATIONS["en,found_validators"]="Found validators in committee: %s"
  TRANSLATIONS["en,epoch_info"]="Epoch %s"
  TRANSLATIONS["en,block_built"]="✅ Block %s successfully built"
  TRANSLATIONS["en,slot_info"]="Slot %s"
  TRANSLATIONS["en,validators_prompt"]="Enter your validator addresses (comma separated, without spaces):"
  TRANSLATIONS["en,validators_format"]="Example: 0x123...,0x456...,0x789..."
  TRANSLATIONS["en,validators_empty"]="Error: Validators list cannot be empty"
  TRANSLATIONS["en,status_legend"]="Status Legend:"
  TRANSLATIONS["en,status_empty"]="⬜️ Empty slot"
  TRANSLATIONS["en,status_attestation_sent"]="🟩 Attestation sent"
  TRANSLATIONS["en,status_attestation_missed"]="🟥 Attestation missed"
  TRANSLATIONS["en,status_block_mined"]="🟦 Block mined"
  TRANSLATIONS["en,status_block_missed"]="🟨 Block missed"
  TRANSLATIONS["en,status_block_proposed"]="🟪 Block proposed"
  TRANSLATIONS["en,publisher_monitoring_title"]="=== Publisher Balance Monitoring ==="
  TRANSLATIONS["en,publisher_monitoring_option1"]="1. Add addresses and start balance monitoring"
  TRANSLATIONS["en,publisher_monitoring_option2"]="2. Configure minimum balance threshold"
  TRANSLATIONS["en,publisher_monitoring_option3"]="3. Stop balance monitoring"
  TRANSLATIONS["en,publisher_monitoring_choose"]="Choose option (1/2/3):"
  TRANSLATIONS["en,publisher_addresses_prompt"]="Enter publisher addresses for balance monitoring (comma separated, without spaces):"
  TRANSLATIONS["en,publisher_addresses_format"]="Example: 0x123...,0x456...,0x789..."
  TRANSLATIONS["en,publisher_addresses_empty"]="Error: Publisher addresses list cannot be empty"
  TRANSLATIONS["en,publisher_min_balance_prompt"]="Enter minimum balance threshold for notification (default: 0.15 ETH):"
  TRANSLATIONS["en,publisher_min_balance_invalid"]="Error: Invalid balance value. Please enter a positive number."
  TRANSLATIONS["en,publisher_monitoring_enabled"]="Publisher balance monitoring enabled"
  TRANSLATIONS["en,publisher_monitoring_disabled"]="Publisher balance monitoring disabled"
  TRANSLATIONS["en,publisher_balance_warning"]="⚠️ Low balance detected on publisher addresses"
  TRANSLATIONS["en,publisher_balance_address"]="Address: %s, Balance: %s ETH"
  TRANSLATIONS["en,current_slot"]="Current slot: %s"
  TRANSLATIONS["en,agent_notifications_full_info"]="ℹ️ Notifications will be sent for issues, committee, slot stats"
  TRANSLATIONS["en,attestation_status"]="ℹ️ Slot stats"
  #find peerID
  TRANSLATIONS["en,fetching_peer_info"]="Fetching peer information from API..."
  TRANSLATIONS["en,peer_found"]="Peer ID found in logs"
  TRANSLATIONS["en,peer_not_in_list"]="Peer not found in the public peers list"
  TRANSLATIONS["en,peer_id_not_critical"]="The presence or absence of a Peer ID in Nethermind.io is not a critical parameter. The data may be outdated."
  TRANSLATIONS["en,searching_latest"]="Searching in current data..."
  TRANSLATIONS["en,searching_archive"]="Searching in archive data..."
  TRANSLATIONS["en,peer_found_archive"]="Note: This peer was found in archive data"
  #
  TRANSLATIONS["en,cli_quit_old_sessions"]="Closed existing session:"
  #install section
  TRANSLATIONS["en,node_deleted"]="✅ Aztec node successfully deleted"
  #agent
  TRANSLATIONS["en,agent_systemd_added"]="Agent added (running every 37 seconds via systemd)"
  TRANSLATIONS["en,agent_timer_status"]="Timer status:"
  TRANSLATIONS["en,agent_timer_error"]="Error while creating systemd timer"
  TRANSLATIONS["en,removing_systemd_agent"]="Removing agent and systemd units..."
  TRANSLATIONS["en,agent_systemd_removed"]="Agent removed successfully"
  #version module
  TRANSLATIONS["en,update_changes"]="Changes in the update"
  TRANSLATIONS["en,installed"]="installed"
  TRANSLATIONS["en,not_installed"]="not installed"
  TRANSLATIONS["en,curl_cffi_not_installed"]="The Python package curl_cffi is not installed."
  TRANSLATIONS["en,install_curl_cffi_prompt"]="Do you want to install curl_cffi now? (Y/n)"
  TRANSLATIONS["en,installing_curl_cffi"]="Installing curl_cffi..."
  TRANSLATIONS["en,curl_cffi_optional"]="curl_cffi installation skipped (optional)."

  # Translations from install_aztec.sh
  TRANSLATIONS["en,installing_deps"]="🔧 Installing system dependencies..."
  TRANSLATIONS["en,deps_installed"]="✅ Dependencies installed"
  TRANSLATIONS["en,checking_docker"]="🔍 Checking Docker and docker compose..."
  TRANSLATIONS["en,docker_not_found"]="❌ Docker not installed"
  TRANSLATIONS["en,docker_compose_not_found"]="❌ docker compose (v2+) not found"
  TRANSLATIONS["en,install_docker_prompt"]="Install Docker? (y/n) "
  TRANSLATIONS["en,install_compose_prompt"]="Install Docker Compose? (y/n) "
  TRANSLATIONS["en,docker_required"]="❌ Docker is required for the script. Exiting."
  TRANSLATIONS["en,compose_required"]="❌ Docker Compose is required for the script. Exiting."
  TRANSLATIONS["en,installing_docker"]="Installing Docker..."
  TRANSLATIONS["en,installing_compose"]="Installing Docker Compose..."
  TRANSLATIONS["en,docker_installed"]="✅ Docker successfully installed"
  TRANSLATIONS["en,compose_installed"]="✅ Docker Compose successfully installed"
  TRANSLATIONS["en,docker_found"]="✅ Docker and docker compose found"
  TRANSLATIONS["en,installing_aztec"]="⬇️ Installing Aztec node..."
  TRANSLATIONS["en,aztec_not_installed"]="❌ Aztec node not installed. Check installation."
  TRANSLATIONS["en,aztec_installed"]="✅ Aztec node installed"
  TRANSLATIONS["en,running_aztec_up"]="🚀 Running aztec-up latest..."
  TRANSLATIONS["en,opening_ports"]="🌐 Opening ports 40400 and 8080..."
  TRANSLATIONS["en,ports_opened"]="✅ Ports opened"
  TRANSLATIONS["en,creating_folder"]="📁 Creating ~/aztec folder..."
  TRANSLATIONS["en,creating_env"]="📝 Creating .env file..."
  TRANSLATIONS["en,env_created"]="✅ .env file created"
  TRANSLATIONS["en,creating_compose"]="🛠️ Creating docker-compose.yml with Watchtower"
  TRANSLATIONS["en,compose_created"]="✅ docker-compose.yml created"
  TRANSLATIONS["en,starting_node"]="🚀 Starting Aztec node..."
  TRANSLATIONS["en,showing_logs"]="📄 Showing last 200 lines of logs..."
  TRANSLATIONS["en,logs_starting"]="Logs will start in 5 seconds... Press Ctrl+C to exit logs"
  TRANSLATIONS["en,checking_ports"]="Checking ports..."
  TRANSLATIONS["en,port_error"]="Error: Port $port is busy. The program cannot continue."
  TRANSLATIONS["en,ports_free"]="All ports are free! Installation will start now...\n"
  TRANSLATIONS["en,ports_busy"]="The following ports are busy:"
  TRANSLATIONS["en,change_ports_prompt"]="Do you want to change ports? (y/n) "
  TRANSLATIONS["en,enter_new_ports"]="Enter new port numbers:"
  TRANSLATIONS["en,enter_http_port"]="Enter HTTP port"
  TRANSLATIONS["en,enter_p2p_port"]="Enter P2P port"
  TRANSLATIONS["en,installation_aborted"]="Installation aborted by user"
  TRANSLATIONS["en,checking_ports_desc"]="Making sure ports are not used by other processes..."
  TRANSLATIONS["en,scanning_ports"]="Scanning ports"
  TRANSLATIONS["en,busy"]="busy"
  TRANSLATIONS["en,free"]="free"
  TRANSLATIONS["en,ports_free_success"]="All ports are available"
  TRANSLATIONS["en,ports_busy_error"]="Some ports are already in use"
  TRANSLATIONS["en,enter_new_ports_prompt"]="Please enter new port numbers"
  TRANSLATIONS["en,ports_updated"]="Port numbers have been updated"
  TRANSLATIONS["en,installing_ss"]="Installing iproute2 (contains ss utility)..."
  TRANSLATIONS["en,ss_installed"]="iproute2 installed successfully"
  TRANSLATIONS["en,delete_node"]="🗑️ Deleting Aztec Node..."
  TRANSLATIONS["en,delete_confirm"]="Are you sure you want to delete the Aztec node? This will stop containers and remove all data. (y/n) "
  TRANSLATIONS["en,delete_canceled"]="✖ Node deletion canceled"
  TRANSLATIONS["en,warn_orig_install"]="⚠️ Type 'n' when prompted with the question:"
  TRANSLATIONS["en,warn_orig_install_2"]="Add it to $HOME/.bash_profile to make the aztec binaries accessible?"
  TRANSLATIONS["en,watchtower_exists"]="✅ Watchtower is already installed"
  TRANSLATIONS["en,installing_watchtower"]="⬇️ Installing Watchtower..."
  TRANSLATIONS["en,creating_watchtower_compose"]="🛠️ Creating Watchtower docker-compose.yml"
  TRANSLATIONS["en,delete_watchtower_confirm"]="Do you want to also delete Watchtower? (y/n) "
  TRANSLATIONS["en,watchtower_deleted"]="✅ Watchtower successfully deleted"
  TRANSLATIONS["en,watchtower_kept"]="✅ Watchtower kept intact"
  TRANSLATIONS["en,enter_tg_token"]="Enter Telegram bot token: "
  TRANSLATIONS["en,enter_tg_chat_id"]="Enter Telegram chat ID: "
  TRANSLATIONS["en,single_validator_mode"]="🔹 Single validator mode selected"
  TRANSLATIONS["en,multi_validator_mode"]="🔹 Multiple validators mode selected"
  TRANSLATIONS["en,enter_validator_keys"]="Enter validator private keys (comma-separated with 0x, up to 10): "
  TRANSLATIONS["en,enter_validator_key"]="Enter validator private key (with 0x): "
  TRANSLATIONS["en,enter_seq_publisher_key"]="Enter SEQ_PUBLISHER_PRIVATE_KEY (with 0x): "
  TRANSLATIONS["en,validator_setup_header"]="=== Validator Setup ==="
  TRANSLATIONS["en,multiple_validators_prompt"]="Do you want to run multiple validators? (y/n) "
  TRANSLATIONS["en,ufw_not_installed"]="⚠️ ufw is not installed"
  TRANSLATIONS["en,ufw_not_active"]="⚠️ ufw is not active"
  TRANSLATIONS["en,has_bls_keys"]="Do you have BLS keys? (y/n) "
  TRANSLATIONS["en,multi_validator_format"]="Enter validator data (format: private_key,address,private_bls,public_bls):"
  TRANSLATIONS["en,single_validator_bls_private"]="Enter validator BLS private key:"
  TRANSLATIONS["en,single_validator_bls_public"]="Enter validator BLS public key:"
  TRANSLATIONS["en,bls_keys_added"]="BLS keys added to validator configuration"
  TRANSLATIONS["en,select_network"]="Select network"
  TRANSLATIONS["en,enter_choice"]="Enter choice:"
  TRANSLATIONS["en,selected_network"]="Selected network:"
  TRANSLATIONS["en,mainnet"]="mainnet"
  TRANSLATIONS["en,testnet"]="testnet"
  TRANSLATIONS["en,update_title"]="Update Aztec node to latest version"
  TRANSLATIONS["en,update_folder_error"]="Error: Folder $HOME/aztec does not exist"
  TRANSLATIONS["en,update_stopping"]="Stopping containers..."
  TRANSLATIONS["en,update_stop_error"]="Error stopping containers"
  TRANSLATIONS["en,update_pulling"]="Pulling latest aztecprotocol/aztec image..."
  TRANSLATIONS["en,update_pull_error"]="Error pulling image"
  TRANSLATIONS["en,update_starting"]="Starting updated node..."
  TRANSLATIONS["en,update_start_error"]="Error starting containers"
  TRANSLATIONS["en,update_success"]="Aztec node successfully updated to latest version!"
  TRANSLATIONS["en,tag_check"]="Found tag: %s, replacing with latest"
  TRANSLATIONS["en,downgrade_title"]="Downgrade Aztec node"
  TRANSLATIONS["en,downgrade_fetching"]="Fetching available versions..."
  TRANSLATIONS["en,downgrade_fetch_error"]="Failed to fetch versions"
  TRANSLATIONS["en,downgrade_available"]="Available versions (enter number):"
  TRANSLATIONS["en,downgrade_invalid_choice"]="Invalid choice, please try again"
  TRANSLATIONS["en,downgrade_selected"]="Selected version:"
  TRANSLATIONS["en,downgrade_folder_error"]="Error: Folder $HOME/aztec does not exist"
  TRANSLATIONS["en,downgrade_stopping"]="Stopping containers..."
  TRANSLATIONS["en,downgrade_stop_error"]="Error stopping containers"
  TRANSLATIONS["en,downgrade_pulling"]="Pulling aztecprotocol/aztec image:"
  TRANSLATIONS["en,downgrade_pull_error"]="Error pulling image"
  TRANSLATIONS["en,downgrade_updating"]="Updating configuration..."
  TRANSLATIONS["en,downgrade_update_error"]="Error updating docker-compose.yml"
  TRANSLATIONS["en,downgrade_starting"]="Starting downgraded node:"
  TRANSLATIONS["en,downgrade_start_error"]="Error starting containers"
  TRANSLATIONS["en,downgrade_success"]="Aztec node successfully downgraded to version"
  TRANSLATIONS["en,stopping_containers"]="Stopping containers..."
  TRANSLATIONS["en,removing_node_data"]="Removing Aztec node data..."
  TRANSLATIONS["en,stopping_watchtower"]="Stopping Watchtower..."
  TRANSLATIONS["en,removing_watchtower_data"]="Removing Watchtower data..."
  TRANSLATIONS["en,enter_yn"]="Please enter Y or N: "

  # Translations from check-validator.sh
  TRANSLATIONS["en,fetching_validators"]="Fetching validator list from contract"
  TRANSLATIONS["en,found_validators"]="Found validators:"
  TRANSLATIONS["en,checking_validators"]="Checking validators..."
  TRANSLATIONS["en,check_completed"]="Check completed."
  TRANSLATIONS["en,select_action"]="Select an action:"
  TRANSLATIONS["en,validator_submenu_option1"]="1. Check another set of validators"
  TRANSLATIONS["en,validator_submenu_option2"]="2. Set up queue position notification for validator"
  TRANSLATIONS["en,validator_submenu_option3"]="3. Check validator in queue"
  TRANSLATIONS["en,validator_submenu_option4"]="4. List active monitors"
  TRANSLATIONS["en,validator_submenu_option5"]="5. Remove existing monitoring"
  TRANSLATIONS["en,enter_option"]="Select option:"
  TRANSLATIONS["en,enter_address"]="Enter the validator address:"
  TRANSLATIONS["en,validator_info"]="Validator information:"
  TRANSLATIONS["en,address"]="Address"
  TRANSLATIONS["en,stake"]="Stake"
  TRANSLATIONS["en,withdrawer"]="Withdrawer"
  TRANSLATIONS["en,rewards"]="Rewards"
  TRANSLATIONS["en,status"]="Status"
  TRANSLATIONS["en,status_0"]="NONE - The validator is not in the validator set"
  TRANSLATIONS["en,status_1"]="VALIDATING - The validator is currently in the validator set"
  TRANSLATIONS["en,status_2"]="ZOMBIE - Not participating as validator, but have funds in setup, hit if slashes and going below the minimum"
  TRANSLATIONS["en,status_3"]="EXITING - In the process of exiting the system"
  TRANSLATIONS["en,validator_not_found"]="Validator with address %s not found."
  TRANSLATIONS["en,exiting"]="Exiting."
  TRANSLATIONS["en,invalid_input"]="Invalid input. Please choose 1, 2, 3 or 0."
  TRANSLATIONS["en,error_rpc_missing"]="Error: RPC_URL not found in $HOME/.env-aztec-agent"
  TRANSLATIONS["en,error_file_missing"]="Error: $HOME/.env-aztec-agent file not found"
  TRANSLATIONS["en,select_mode"]="Select loading mode:"
  TRANSLATIONS["en,mode_fast"]="1. Fast mode (high CPU load)"
  TRANSLATIONS["en,mode_slow"]="2. Slow mode (low CPU load)"
  TRANSLATIONS["en,mode_invalid"]="Invalid mode selected. Please choose 1 or 2."
  TRANSLATIONS["en,checking_queue"]="Checking validator queue..."
  TRANSLATIONS["en,validator_in_queue"]="Validator found in queue:"
  TRANSLATIONS["en,position"]="Position"
  TRANSLATIONS["en,queued_at"]="Queued at"
  TRANSLATIONS["en,not_in_queue"]="Validator is not in the queue either."
  TRANSLATIONS["en,fetching_queue"]="Fetching validator queue data..."
  TRANSLATIONS["en,notification_script_created"]="Notification script created and scheduled. Monitoring validator: %s"
  TRANSLATIONS["en,notification_exists"]="Notification for this validator already exists."
  TRANSLATIONS["en,enter_validator_address"]="Enter validator address to monitor:"
  TRANSLATIONS["en,notification_removed"]="Notification for validator %s has been removed."
  TRANSLATIONS["en,no_notifications"]="No active notifications found."
  TRANSLATIONS["en,validator_not_in_queue"]="Validator not found in queue either. Please check the address."
  TRANSLATIONS["en,validator_not_in_set"]="Validator not found in current validator set. Checking queue..."
  TRANSLATIONS["en,queue_notification_title"]="Validator queue position notification"
  TRANSLATIONS["en,active_monitors"]="Active validator monitors:"
  TRANSLATIONS["en,enter_multiple_addresses"]="Enter validator addresses to monitor (comma separated):"
  TRANSLATIONS["en,invalid_address_format"]="Invalid address format: %s"
  TRANSLATIONS["en,processing_address"]="Processing address: %s"
  TRANSLATIONS["en,add_validators_to_queue_prompt"]="Would you like to add these validators to queue monitoring?"
  TRANSLATIONS["en,enter_yes_to_add"]="Enter 'yes' to add all, or 'no' to skip:"
  TRANSLATIONS["en,queue_validators_added"]="All queue validators added to monitoring."
  TRANSLATIONS["en,skipping_queue_setup"]="Skipping queue monitoring setup."
  TRANSLATIONS["en,queue_validators_available"]="Queue Validators Available for Monitoring"
  TRANSLATIONS["en,initial_notification_note"]="Note: Initial notification sent. Script includes safety timeouts."
  TRANSLATIONS["en,running_initial_test"]="Running initial test..."
  TRANSLATIONS["en,no_valid_addresses"]="No valid addresses to check."
  TRANSLATIONS["en,fetching_page"]="Fetching page %d of %d..."
  TRANSLATIONS["en,loading_validators"]="Loading validator data..."
  TRANSLATIONS["en,validators_loaded"]="Validator data loaded successfully"
  TRANSLATIONS["en,rpc_error"]="RPC error occurred, trying alternative RPC"
  TRANSLATIONS["en,getting_new_rpc"]="Getting new RPC URL..."
  TRANSLATIONS["en,rate_limit_notice"]="Using backup RPC - rate limiting to 1 request per second"
  TRANSLATIONS["en,getting_validator_count"]="Getting validator count..."
  TRANSLATIONS["en,getting_current_slot"]="Getting current slot..."
  TRANSLATIONS["en,deriving_timestamp"]="Deriving timestamp for slot..."
  TRANSLATIONS["en,querying_attesters"]="Querying attesters from GSE contract..."
  TRANSLATIONS["en,select_monitor_to_remove"]="Select monitor to remove:"
  TRANSLATIONS["en,monitor_removed"]="Monitoring for validator %s has been removed."
  TRANSLATIONS["en,all_monitors_removed"]="All monitoring scripts have been removed."
  TRANSLATIONS["en,remove_all"]="Remove all monitoring scripts"
  TRANSLATIONS["en,remove_specific"]="Remove specific monitor"
  TRANSLATIONS["en,api_error"]="Possible problems with Dashtec API"
  TRANSLATIONS["en,contact_developer"]="Contact developer: https://t.me/+zEaCtoXYYwIyZjQ0"

  TRANSLATIONS["en,installing_foundry"]="Installing Foundry..."
  TRANSLATIONS["en,installing_curl"]="Installing curl..."
  TRANSLATIONS["en,installing_utils"]="Installing utilities (grep, sed)..."
  TRANSLATIONS["en,installing_jq"]="Installing jq..."
  TRANSLATIONS["en,installing_bc"]="Installing bc..."
  TRANSLATIONS["en,installing_python3"]="Installing Python3..."
  # Web3signer restart translations
  TRANSLATIONS["en,bls_restarting_web3signer"]="Restarting web3signer to load new key"
  TRANSLATIONS["en,bls_web3signer_restarted"]="Web3signer successfully restarted"
  TRANSLATIONS["en,bls_web3signer_running"]="Web3signer is running after restart"
  TRANSLATIONS["en,bls_web3signer_not_running"]="Web3signer is not running after restart"
  TRANSLATIONS["en,bls_web3signer_restart_failed"]="Failed to restart web3signer"
  TRANSLATIONS["en,bls_final_web3signer_restart"]="Performing final web3signer restart to load all keys"
  TRANSLATIONS["en,bls_final_web3signer_restarted"]="Final web3signer restart completed"
  TRANSLATIONS["en,bls_final_web3signer_restart_failed"]="Final web3signer restart failed"

  TRANSLATIONS["en,aztec_rewards_claim"]="Aztec Rewards Claim"
  TRANSLATIONS["en,environment_file_not_found"]="Environment file not found"
  TRANSLATIONS["en,rpc_url_not_set"]="RPC_URL not set"
  TRANSLATIONS["en,contract_address_not_set"]="CONTRACT_ADDRESS not set"
  TRANSLATIONS["en,using_contract"]="Using contract:"
  TRANSLATIONS["en,using_rpc"]="Using RPC:"
  TRANSLATIONS["en,checking_rewards_claimable"]="Checking if rewards are claimable..."
  TRANSLATIONS["en,failed_check_rewards_claimable"]="Failed to check rewards claimable status"
  TRANSLATIONS["en,rewards_not_claimable"]="Rewards are not claimable at this time"
  TRANSLATIONS["en,rewards_are_claimable"]="Rewards are claimable"
  TRANSLATIONS["en,keystore_file_not_found"]="Keystore file not found:"
  TRANSLATIONS["en,extracting_validator_addresses"]="Extracting validator addresses..."
  TRANSLATIONS["en,no_coinbase_addresses_found"]="No coinbase addresses found in keystore"
  TRANSLATIONS["en,found_unique_coinbase_addresses"]="Found unique coinbase addresses:"
  TRANSLATIONS["en,repeats_times"]="repeats %s times"
  TRANSLATIONS["en,checking_rewards"]="Checking rewards..."
  TRANSLATIONS["en,checking_address"]="Checking address"
  TRANSLATIONS["en,failed_get_rewards_for_address"]="Failed to get rewards for address"
  TRANSLATIONS["en,failed_convert_rewards_amount"]="Failed to convert rewards amount for address"
  TRANSLATIONS["en,failed_convert_to_eth"]="Failed to convert amount for address"
  TRANSLATIONS["en,rewards_amount"]="Rewards: %s"
  TRANSLATIONS["en,no_rewards"]="No rewards"
  TRANSLATIONS["en,no_rewards_to_claim"]="No rewards to claim at this time"
  TRANSLATIONS["en,found_unique_addresses_with_rewards"]="Found unique addresses with rewards to claim:"
  TRANSLATIONS["en,already_claimed_this_session"]="Already claimed address"
  TRANSLATIONS["en,skipping"]="skipping"
  TRANSLATIONS["en,address_label"]="Address:"
  TRANSLATIONS["en,amount_eth"]="Amount: %s"
  TRANSLATIONS["en,address_appears_times"]="This address appears %s times in keystore"
  TRANSLATIONS["en,claim_rewards_confirmation"]="Do you want to claim these rewards? (y/n/skip):"
  TRANSLATIONS["en,claiming_rewards"]="Claiming rewards..."
  TRANSLATIONS["en,transaction_sent"]="Transaction sent:"
  TRANSLATIONS["en,waiting_confirmation"]="Waiting for confirmation..."
  TRANSLATIONS["en,transaction_confirmed_successfully"]="Transaction confirmed successfully"
  TRANSLATIONS["en,rewards_successfully_claimed"]="Rewards successfully claimed"
  TRANSLATIONS["en,rewards_claimed_balance_not_zero"]="Rewards claimed but balance not zero: %s"
  TRANSLATIONS["en,claimed_rewards_for_address_appears_times"]="Claimed rewards for %s (appears %s times)"
  TRANSLATIONS["en,transaction_failed"]="Transaction failed"
  TRANSLATIONS["en,could_not_get_receipt_transaction_sent"]="Could not get receipt, but transaction was sent"
  TRANSLATIONS["en,failed_send_transaction"]="Failed to send transaction"
  TRANSLATIONS["en,skipping_claim_for_address"]="Skipping claim for address"
  TRANSLATIONS["en,skipping_all_remaining_claims"]="Skipping all remaining claims"
  TRANSLATIONS["en,waiting_seconds"]="Waiting 5 seconds..."
  TRANSLATIONS["en,summary"]="SUMMARY"
  TRANSLATIONS["en,successfully_claimed"]="Successfully claimed:"
  TRANSLATIONS["en,failed_count"]="Failed:"
  TRANSLATIONS["en,unique_addresses_with_rewards"]="Unique addresses with rewards:"
  TRANSLATIONS["en,total_coinbase_addresses_in_keystore"]="Total coinbase addresses in keystore:"
  TRANSLATIONS["en,contract_used"]="Contract used:"
  TRANSLATIONS["en,earliest_rewards_claimable_timestamp"]="Earliest rewards claimable timestamp: %s (%s)"
  TRANSLATIONS["en,claim_function_not_activated"]="Currently the claim function is not activated in contract"

  # Russian translations
  TRANSLATIONS["ru,welcome"]="Добро пожаловать в скрипт мониторинга ноды Aztec"
  TRANSLATIONS["ru,title"]="========= Главное меню ========="
  TRANSLATIONS["ru,option1"]="1. Проверить контейнер и синхронизацию ноды"
  TRANSLATIONS["ru,option2"]="2. Установить агент мониторинга ноды с уведомлениями"
  TRANSLATIONS["ru,option3"]="3. Удалить агент мониторинга"
  TRANSLATIONS["ru,option4"]="4. Просмотреть логи Aztec"
  TRANSLATIONS["ru,option5"]="5. Найти rollupAddress"
  TRANSLATIONS["ru,option6"]="6. Найти PeerID"
  TRANSLATIONS["ru,option7"]="7. Найти governanceProposerPayload"
  TRANSLATIONS["ru,option8"]="8. Проверить Proven L2 блок"
  TRANSLATIONS["ru,option9"]="9. Поиск валидатора, проверка статуса и мониторинг очереди"
  TRANSLATIONS["ru,option10"]="10. Мониторинг баланса publisher"
  TRANSLATIONS["ru,option11"]="11. Установить Aztec ноду с Watchtower"
  TRANSLATIONS["ru,option12"]="12. Удалить ноду Aztec"
  TRANSLATIONS["ru,option13"]="13. Запустить контейнеры ноды Aztec"
  TRANSLATIONS["ru,option14"]="14. Остановить контейнеры ноды Aztec"
  TRANSLATIONS["ru,option15"]="15. Обновить ноду Aztec"
  TRANSLATIONS["ru,option16"]="16. Сделать даунгрейд ноды Aztec"
  TRANSLATIONS["ru,option17"]="17. Проверить версию ноды Aztec"
  TRANSLATIONS["ru,option18"]="18. Сгенерировать BLS ключи из мнемоники"
  TRANSLATIONS["ru,option19"]="19. Апрув"
  TRANSLATIONS["ru,option20"]="20. Стейк"
  TRANSLATIONS["ru,option21"]="21. Получить награды"
  TRANSLATIONS["ru,option22"]="22. Изменить RPC URL"
  TRANSLATIONS["ru,option23"]="23. Проверить обновления скрипта (безопасно, с проверкой хеша)"
  TRANSLATIONS["ru,option24"]="24. Проверить обновления определений ошибок (безопасно, с проверкой хеша)"
  TRANSLATIONS["ru,option0"]="0. Выход"

  # Переводы для проверки обновлений
  TRANSLATIONS["ru,local_version_shows"]="Локальный файл версий показывает версию:"
  TRANSLATIONS["ru,note_check_updates_safely"]="Примечание: Для безопасной проверки удалённых обновлений используйте опциональную функцию проверки обновлений"
  TRANSLATIONS["ru,local_version_up_to_date"]="Локальный файл версий актуален"
  TRANSLATIONS["ru,safe_update_check"]="Безопасная проверка обновлений"
  TRANSLATIONS["ru,update_check_warning"]="Будет загружен version_control.json из GitHub с проверкой SHA256."
  TRANSLATIONS["ru,file_not_executed_auto"]="Файл будет загружен, но НЕ будет выполнен автоматически."
  TRANSLATIONS["ru,continue_prompt"]="Продолжить? (y/n)"
  TRANSLATIONS["ru,update_check_cancelled"]="Проверка обновлений отменена."
  TRANSLATIONS["ru,downloading_version_control"]="Загрузка version_control.json..."
  TRANSLATIONS["ru,failed_download_version_control"]="Не удалось загрузить version_control.json"
  TRANSLATIONS["ru,downloaded_file_sha256"]="SHA256 загруженного файла:"
  TRANSLATIONS["ru,verify_hash_match"]="Пожалуйста, убедитесь, что этот хеш соответствует ожидаемому хешу из репозитория."
  TRANSLATIONS["ru,current_installed_version"]="Текущая установленная версия:"
  TRANSLATIONS["ru,latest_version_repo"]="Последняя версия в репозитории:"
  TRANSLATIONS["ru,new_version_available"]="Доступна новая версия:"
  TRANSLATIONS["ru,version_label"]="Версия:"
  TRANSLATIONS["ru,note_update_manually"]="Примечание: Для обновления вручную загрузите последние изменения из репозитория."
  TRANSLATIONS["ru,safe_error_def_update_check"]="Безопасная проверка обновлений определений ошибок"
  TRANSLATIONS["ru,error_def_update_warning"]="Будет загружен error_definitions.json из GitHub с проверкой SHA256."
  TRANSLATIONS["ru,downloading_error_definitions"]="Загрузка error_definitions.json..."
  TRANSLATIONS["ru,failed_download_error_definitions"]="Не удалось загрузить error_definitions.json"
  TRANSLATIONS["ru,error_def_matches_remote"]="Локальный error_definitions.json соответствует удалённой версии."
  TRANSLATIONS["ru,local_remote_versions_differ"]="Локальная и удалённая версии различаются."
  TRANSLATIONS["ru,local_hash"]="Локальный хеш:"
  TRANSLATIONS["ru,remote_hash"]="Удалённый хеш:"
  TRANSLATIONS["ru,local_error_def_not_found"]="Локальный error_definitions.json не найден."
  TRANSLATIONS["ru,bls_mnemonic_prompt"]="Скопируйте все 12 слов вашей мнемонической фразы, вставьте и нажмите Enter (ввод будет скрыт, но вставлен):"
  TRANSLATIONS["ru,bls_wallet_count_prompt"]="Введите количество кошельков для генерации. \nНапример: если у вас в сид-фразе всего один кошелек, вставьте цифру 1. \nЕсли в вашей сид-фразе несколько кошельков для нескольких валидаторов, вставьте примернуо максимальную цифру последнего кошелька, например 30, 50. \nЛучше укажите больше, если не уверены, скрипт соберет все ключи и удалит лишние.):"
  TRANSLATIONS["ru,bls_invalid_number"]="Неверное число. Введите положительное целое число."
  TRANSLATIONS["ru,bls_keystore_not_found"]="❌ Файл keystore.json не найден в $HOME/aztec/config/keystore.json"
  TRANSLATIONS["ru,bls_fee_recipient_not_found"]="❌ feeRecipient не найден в keystore.json"
  TRANSLATIONS["ru,bls_generating_keys"]="🔑 Генерация BLS ключей..."
  TRANSLATIONS["ru,bls_generation_success"]="✅ BLS ключи успешно сгенерированы"
  TRANSLATIONS["ru,bls_public_save_attention"]="⚠️ ВНИМАНИЕ: скопируйте данные аккаунтов выше (белый текст) и сохраните, в них содержатся eth-адреса публичные bls-ключи, которые могут вам пригодиться в будущем."
  TRANSLATIONS["ru,bls_generation_failed"]="❌ Не удалось сгенерировать BLS ключи"
  TRANSLATIONS["ru,bls_searching_matches"]="🔍 Поиск совпадающих адресов в keystore..."
  TRANSLATIONS["ru,bls_matches_found"]="✅ Найдено %d совпадающих адресов"
  TRANSLATIONS["ru,bls_no_matches"]="❌ Совпадающие адреса не найдены в keystore.json"
  TRANSLATIONS["ru,bls_filtered_file_created"]="✅ Отфильтрованные BLS ключи сохранены в: %s"
  TRANSLATIONS["ru,bls_file_not_found"]="❌ Сгенерированный BLS файл не найден"
  TRANSLATIONS["ru,staking_title"]="Стейкинг валидаторов"
  TRANSLATIONS["ru,staking_no_validators"]="Валидаторы не найдены"
  TRANSLATIONS["ru,staking_found_validators"]="Найдено %d валидаторов"
  TRANSLATIONS["ru,staking_processing"]="Обработка валидатора %d из %d"
  TRANSLATIONS["ru,staking_data_loaded"]="Данные валидатора загружены"
  TRANSLATIONS["ru,staking_trying_rpc"]="Пробуем RPC: %s"
  TRANSLATIONS["ru,staking_command_prompt"]="Выполнить эту команду?"
  TRANSLATIONS["ru,staking_execute_prompt"]="Введите 'y' чтобы продолжить, 's' чтобы пропустить валидатора, 'q' чтобы выйти"
  TRANSLATIONS["ru,staking_executing"]="Выполнение команды..."
  TRANSLATIONS["ru,staking_success"]="Успешно застейкан валидатор %d через RPC: %s"
  TRANSLATIONS["ru,staking_failed"]="Не удалось застейкать валидатор %d через RPC: %s"
  TRANSLATIONS["ru,staking_skipped_validator"]="Пропускаем валидатора %d"
  TRANSLATIONS["ru,staking_cancelled"]="Операция отменена пользователем"
  TRANSLATIONS["ru,staking_skipped_rpc"]="Пропускаем этого RPC провайдера"
  TRANSLATIONS["ru,staking_all_failed"]="Не удалось застейкать валидатор %d со всеми RPC провайдерами"
  TRANSLATIONS["ru,staking_completed"]="Процесс стейкинга завершен"
  TRANSLATIONS["ru,file_not_found"]="%s не найден в %s"
  TRANSLATIONS["ru,contract_not_set"]="CONTRACT_ADDRESS не установлен"
  TRANSLATIONS["ru,using_contract_address"]="Используется адрес контракта: %s"
  TRANSLATIONS["ru,staking_failed_private_key"]="Не удалось получить приватный ключ для валидатора %d"
  TRANSLATIONS["ru,staking_failed_eth_address"]="Не удалось получить ETH адрес для валидатора %d"
  TRANSLATIONS["ru,staking_failed_bls_key"]="Не удалось получить BLS приватный ключ для валидатора %d"
  TRANSLATIONS["ru,eth_address"]="ETH Адрес"
  TRANSLATIONS["ru,private_key"]="Приватный ключ"
  TRANSLATIONS["ru,bls_key"]="BLS ключ"
  TRANSLATIONS["ru,bls_method_existing"]="Сгенерировать используя существующие адреса (из mnemonic, только если все адреса валидаторов из одной сид фразы)"
  TRANSLATIONS["ru,bls_method_new_operator"]="Сгенерировать новый адрес оператора (рекомендуется)"
  TRANSLATIONS["ru,bls_method_prompt"]="Выберите метод (1/2): "
  TRANSLATIONS["ru,bls_invalid_method"]="Выбран неверный метод"
  TRANSLATIONS["ru,bls_existing_method_title"]="Метод существующих адресов"
  TRANSLATIONS["ru,bls_new_operator_title"]="Метод нового адреса оператора"
  TRANSLATIONS["ru,bls_old_validator_info"]="Пожалуйста, предоставьте информацию о вашем старом валидаторе:"
  TRANSLATIONS["ru,bls_old_private_key_prompt"]="Скопируйте и вставьте один или несколько СТАРЫХ приватных ключей через запятую без пробелов и нажмите Enter (ввод скрыт, но вставлен): "
  TRANSLATIONS["ru,bls_sepolia_rpc_prompt"]="Введите ваш Sepolia RPC URL: "
  TRANSLATIONS["ru,bls_starting_generation"]="Запуск процесса генерации..."
  TRANSLATIONS["ru,bls_ready_to_generate"]="⚠️ ATTENTION: БУДЬТЕ ГОТОВЫ записать все данные нового оператора: мнемоническую фразу, публичный адрес и публичный BLS-ключ. Приватный ключ и приватный BLS-ключ буду сохранены в файл $HOME/aztec/bls-filtered-pk.json"
  TRANSLATIONS["ru,bls_press_enter_to_generate"]="Нажмите [Enter] для генерации новых ключей..."
  TRANSLATIONS["ru,bls_add_to_keystore_title"]="Добавление BLS ключей в Keystore"
  TRANSLATIONS["ru,bls_pk_file_not_found"]="Файл BLS ключей не найден: $HOME/aztec/bls-filtered-pk.json"
  TRANSLATIONS["ru,bls_keystore_not_found"]="Файл keystore не найден: $HOME/aztec/config/keystore.json"
  TRANSLATIONS["ru,bls_creating_backup"]="Создание резервной копии keystore.json..."
  TRANSLATIONS["ru,bls_backup_created"]="Резервная копия создана"
  TRANSLATIONS["ru,bls_processing_validators"]="Обработка валидаторов"
  TRANSLATIONS["ru,bls_reading_bls_keys"]="Чтение BLS ключей из фильтрованного файла..."
  TRANSLATIONS["ru,bls_mapped_address"]="Сопоставлен адрес с BLS ключом"
  TRANSLATIONS["ru,bls_failed_generate_address"]="Не удалось сгенерировать адрес из приватного ключа"
  TRANSLATIONS["ru,bls_no_valid_mappings"]="Не найдено сопоставлений адресов с BLS ключами"
  TRANSLATIONS["ru,bls_total_mappings"]="Всего сопоставлений адресов найдено"
  TRANSLATIONS["ru,bls_updating_keystore"]="Обновление keystore с BLS ключами..."
  TRANSLATIONS["ru,bls_key_added"]="BLS ключ добавлен для адреса"
  TRANSLATIONS["ru,bls_no_key_for_address"]="BLS ключ не найден для адреса"
  TRANSLATIONS["ru,bls_no_matches_found"]="Не найдено совпадающих адресов между BLS ключами и keystore"
  TRANSLATIONS["ru,bls_keystore_updated"]="Keystore успешно обновлен с BLS ключами"
  TRANSLATIONS["ru,bls_total_updated"]="Валидаторов обновлено"
  TRANSLATIONS["ru,bls_updated_structure_sample"]="Пример обновленной структуры валидатора"
  TRANSLATIONS["ru,bls_invalid_json"]="Сгенерирован невалидный JSON, восстанавливаем из резервной копии"
  TRANSLATIONS["ru,bls_restoring_backup"]="Восстановление оригинального keystore из резервной копии"
  TRANSLATIONS["ru,bls_operation_completed"]="Добавление BLS ключей успешно завершено"
  TRANSLATIONS["ru,bls_to_keystore"]="Добавить ключи BLS в keystore.json (запускать только после генерации BLS и только если BLS сгенерированы из сид-фразы или вы самостоятельно верно создали bls-filtered-pk.json)"
  TRANSLATIONS["ru,bls_new_keys_generated"]="Отлично! Ваши новые ключи ниже. СОХРАНИТЕ ЭТУ ИНФОРМАЦИЮ В БЕЗОПАСНОМ МЕСТЕ!"
  TRANSLATIONS["ru,bls_new_eth_private_key"]="НОВЫЙ приватный ключ ETH"
  TRANSLATIONS["ru,bls_new_bls_private_key"]="НОВЫЙ приватный ключ BLS"
  TRANSLATIONS["ru,bls_new_public_address"]="НОВЫЙ публичный адрес"
  TRANSLATIONS["ru,bls_funding_required"]="Вам нужно отправить от 0.1 до 0.3 Sepolia ETH на этот новый адрес:"
  TRANSLATIONS["ru,bls_funding_confirmation"]="После подтверждения транзакции пополнения, нажмите [Enter] для продолжения..."
  TRANSLATIONS["ru,bls_approving_stake"]="Подтверждение расходов STAKE..."
  TRANSLATIONS["ru,bls_approve_failed"]="Транзакция подтверждения не удалась"
  TRANSLATIONS["ru,bls_joining_testnet"]="Присоединение к тестовой сети..."
  TRANSLATIONS["ru,bls_staking_failed"]="Стейкинг не удался"
  TRANSLATIONS["ru,staking_yml_file_created"]="YML файл с ключами создан:"
  TRANSLATIONS["ru,staking_yml_file_failed"]="Не удалось создать YML файл с ключами:"
  TRANSLATIONS["ru,staking_total_yml_files_created"]="Всего создано YML файлов с ключами:"
  TRANSLATIONS["ru,staking_yml_files_location"]="Расположение файлов с ключами:"
  TRANSLATIONS["ru,bls_new_operator_success"]="Все готово! Вы успешно присоединились к новой тестовой сети"
  TRANSLATIONS["ru,bls_restart_node_notice"]="Теперь перезапустите вашу ноду, проверьте что в /aztec/keys добавились YML-файлы с новыми приватными ключами, а в /aztec/config/keystore.json заменились на новые eth адреса валидаторов"
  TRANSLATIONS["ru,bls_key_extraction_failed"]="Не удалось извлечь ключи из сгенерированного файла"
  TRANSLATIONS["ru,staking_run_bls_generation_first"]="Пожалуйста, сначала запустите генерацию BLS ключей (опция 18)"
  TRANSLATIONS["ru,staking_invalid_bls_file"]="Неверный формат файла BLS ключей"
  TRANSLATIONS["ru,staking_failed_generate_address"]="Не удалось сгенерировать адрес из приватного ключа"
  TRANSLATIONS["ru,staking_found_single_validator"]="Найден один валидатор для метода нового оператора"
  TRANSLATIONS["ru,staking_old_sequencer_prompt"]="Для стейкинга методом нового оператора нам нужен ваш старый приватный ключ секвенсера:"
  TRANSLATIONS["ru,staking_old_private_key_prompt"]="Введите СТАРЫЙ приватный ключ Секвенсера (скрытый ввод): "
  TRANSLATIONS["ru,staking_success_single"]="Успешный стейкинг валидатора методом нового оператора"
  TRANSLATIONS["ru,staking_failed_single"]="Не удалось выполнить стейкинг валидатора методом нового оператора"
  TRANSLATIONS["ru,staking_all_failed_single"]="Все RPC провайдеры не сработали для стейкинга новым оператором"
  TRANSLATIONS["ru,staking_skipped"]="Стейкинг пропущен"
  TRANSLATIONS["ru,staking_keystore_backup_created"]="Резервная копия keystore создана:"
  TRANSLATIONS["ru,staking_updating_keystore"]="Обновление keystore.json - замена старого адреса валидатора на новый адрес оператора"
  TRANSLATIONS["ru,staking_keystore_updated"]="Keystore успешно обновлен:"
  TRANSLATIONS["ru,staking_keystore_no_change"]="Изменения в keystore не внесены (адрес не найден):"
  TRANSLATIONS["ru,staking_keystore_update_failed"]="Не удалось обновить keystore.json"
  TRANSLATIONS["ru,staking_keystore_skip_update"]="Пропуск обновления keystore (старый адрес недоступен)"
  TRANSLATIONS["ru,bls_no_private_keys"]="Приватные ключи не предоставлены"
  TRANSLATIONS["ru,bls_found_private_keys"]="Найдено приватных ключей:"
  TRANSLATIONS["ru,bls_keys_saved_success"]="BLS ключи успешно сгенерированы и сохранены"
  TRANSLATIONS["ru,bls_next_steps"]="Следующие шаги:"
  TRANSLATIONS["ru,bls_send_eth_step"]="Отправьте 0.1-0.3 Sepolia ETH на указанный выше адрес"
  TRANSLATIONS["ru,bls_run_approve_step"]="Запустите опцию 19 (Approve) для подтверждения расходов стейкинга"
  TRANSLATIONS["ru,bls_run_stake_step"]="Запустите опцию 20 (Stake) для завершения стейкинга валидатора"
  TRANSLATIONS["ru,staking_missing_new_operator_info"]="Отсутствует информация о новом операторе в BLS файле"
  TRANSLATIONS["ru,staking_found_validators_new_operator"]="Найдено валидаторов для метода нового оператора:"
  TRANSLATIONS["ru,staking_processing_new_operator"]="Обработка валидатора %s/%s (метод нового оператора)"
  TRANSLATIONS["ru,staking_success_new_operator"]="Успешный стейкинг валидатора %s методом нового оператора с использованием %s"
  TRANSLATIONS["ru,validator_link"]="Ссылка на валидатора"
  TRANSLATIONS["ru,staking_failed_new_operator"]="Не удалось выполнить стейкинг валидатора %s методом нового оператора с использованием %s"
  TRANSLATIONS["ru,staking_all_failed_new_operator"]="Все RPC провайдеры не сработали для валидатора %s с методом нового оператора"
  TRANSLATIONS["ru,staking_completed_new_operator"]="Стейкинг нового оператора завершен!"
  TRANSLATIONS["ru,command_to_execute"]="Команда для выполнения"
  TRANSLATIONS["ru,trying_next_rpc"]="Пробуем следующий RPC провайдер..."
  TRANSLATIONS["ru,continuing_next_validator"]="Переходим к следующему валидатору..."
  TRANSLATIONS["ru,waiting_before_next_validator"]="Ожидание 2 секунды перед следующим валидатором"
  TRANSLATIONS["ru,rpc_change_prompt"]="Введите новый RPC URL:"
  TRANSLATIONS["ru,rpc_change_success"]="✅ RPC URL успешно обновлен"
  TRANSLATIONS["ru,choose_option"]="Выберите опцию:"
  TRANSLATIONS["ru,checking_deps"]="🔍 Проверка необходимых компонентов:"
  TRANSLATIONS["ru,missing_tools"]="Необходимые компоненты отсутствуют:"
  TRANSLATIONS["ru,install_prompt"]="Хотите установить их сейчас? (Y/n):"
  TRANSLATIONS["ru,missing_required"]="⚠️ Без необходимых компонентов скрипт не сможет работать. Завершение."
  TRANSLATIONS["ru,rpc_prompt"]="Введите Ethereum RPC URL:"
  TRANSLATIONS["ru,network_prompt"]="Введите тип сети (например: testnet или mainnet):"
  TRANSLATIONS["ru,env_created"]="✅ Создан файл .env с RPC URL"
  TRANSLATIONS["ru,env_exists"]="✅ Используется существующий .env файл с RPC URL:"
  TRANSLATIONS["ru,rpc_empty_error"]="RPC URL не может быть пустым. Пожалуйста, введите действительный URL."
  TRANSLATIONS["ru,network_empty_error"]="Название сети не может быть пустым. Пожалуйста, введите название сети."
  TRANSLATIONS["ru,search_container"]="🔍 Поиск контейнера с именем 'aztec'..."
  TRANSLATIONS["ru,container_not_found"]="❌ Контейнер с именем 'aztec' не найден."
  TRANSLATIONS["ru,container_found"]="✅ Найден контейнер:"
  TRANSLATIONS["ru,get_block"]="🔗 Получение актуального блока из контракта..."
  TRANSLATIONS["ru,block_error"]="❌ Ошибка: не удалось получить номер блока. Проверьте RPC или контракт."
  TRANSLATIONS["ru,current_block"]="📦 Актуальный номер блока:"
  TRANSLATIONS["ru,node_ok"]="✅ Нода работает и обрабатывает актуальный блок"
  TRANSLATIONS["ru,node_behind"]="⚠️ Актуальный блок не найден в логах. Возможно, нода отстаёт."
  TRANSLATIONS["ru,search_rollup"]="🔍 Поиск rollupAddress в логах контейнера 'aztec'..."
  TRANSLATIONS["ru,rollup_found"]="✅ Актуальный rollupAddress:"
  TRANSLATIONS["ru,rollup_not_found"]="❌ Адрес rollupAddress не найден в логе."
  TRANSLATIONS["ru,search_peer"]="🔍 Поиск PeerID в логах контейнера 'aztec'..."
  TRANSLATIONS["ru,peer_not_found"]="❌ В логах PeerID не найден."
  TRANSLATIONS["ru,search_gov"]="🔍 Поиск governanceProposerPayload в логах контейнера 'aztec'..."
  TRANSLATIONS["ru,gov_found"]="Найденные значения governanceProposerPayload:"
  TRANSLATIONS["ru,gov_not_found"]="❌ Ни одного governanceProposerPayload не найдено."
  TRANSLATIONS["ru,gov_changed"]="🛑 Обнаружено изменение governanceProposerPayload!"
  TRANSLATIONS["ru,gov_was"]="⚠️ Было:"
  TRANSLATIONS["ru,gov_now"]="Стало:"
  TRANSLATIONS["ru,gov_no_changes"]="✅ Изменений не обнаружено."
  TRANSLATIONS["ru,token_prompt"]="Введите Telegram Bot Token:"
  TRANSLATIONS["ru,chatid_prompt"]="Введите Telegram Chat ID:"
  TRANSLATIONS["ru,agent_added"]="✅ Агент добавлен в systemd и будет выполняться каждую минуту."
  TRANSLATIONS["ru,agent_exists"]="ℹ️ Агент уже есть в systemd."
  TRANSLATIONS["ru,removing_agent"]="🗑 Удаление агента и systemd-задачи..."
  TRANSLATIONS["ru,agent_removed"]="✅ Агент и systemd-задача удалены."
  TRANSLATIONS["ru,goodbye"]="👋 Выход."
  TRANSLATIONS["ru,invalid_choice"]="❌ Неверный выбор. Попробуйте снова."
  TRANSLATIONS["ru,searching"]="Поиск..."
  TRANSLATIONS["ru,get_proven_block"]="🔍 Получение номера proven L2 блока..."
  TRANSLATIONS["ru,proven_block_found"]="✅ Номер Proven L2 блока:"
  TRANSLATIONS["ru,proven_block_error"]="❌ Не удалось получить номер proven L2 блока."
  TRANSLATIONS["ru,get_sync_proof"]="🔍 Получение Sync Proof..."
  TRANSLATIONS["ru,sync_proof_found"]="✅ Sync Proof:"
  TRANSLATIONS["ru,sync_proof_error"]="❌ Не удалось получить sync proof."
  TRANSLATIONS["ru,token_check"]="🔍 Проверка Telegram токена и ChatID..."
  TRANSLATIONS["ru,token_valid"]="✅ Telegram токен действителен"
  TRANSLATIONS["ru,token_invalid"]="❌ Неверный Telegram токен"
  TRANSLATIONS["ru,chatid_valid"]="✅ ChatID действителен и бот имеет доступ"
  TRANSLATIONS["ru,chatid_invalid"]="❌ Неверный ChatID или бот не имеет доступа"
  TRANSLATIONS["ru,agent_created"]="✅ Агент успешно создан и настроен!"
  TRANSLATIONS["ru,running_validator_script"]="Запуск скрипта проверки валидатора локально..."
  TRANSLATIONS["ru,failed_run_validator"]="Не удалось запустить скрипт проверки валидатора."
  TRANSLATIONS["ru,enter_aztec_port_prompt"]="Введите номер порта Aztec"
  TRANSLATIONS["ru,port_saved_successfully"]="✅ Порт успешно сохранен"
  TRANSLATIONS["ru,checking_port"]="Проверка порта"
  TRANSLATIONS["ru,port_not_available"]="Aztec порт недоступен на"
  TRANSLATIONS["ru,current_aztec_port"]="Текущий порт ноды Aztec:"
  TRANSLATIONS["ru,log_block_not_found"]="❌ Не найдена строка с 'Downloaded L2 block' в логах."
  TRANSLATIONS["ru,log_block_extract_failed"]="❌ Не удалось извлечь номер блока из строки:"
  TRANSLATIONS["ru,log_block_number"]="📄 Последний блок из логов:"
  TRANSLATIONS["ru,log_behind_details"]="⚠️ Логи отстают. Последний блок из логов: %s, из контракта: %s"
  TRANSLATIONS["ru,log_line_example"]="🔎 Пример строки из логов:"
  TRANSLATIONS["ru,press_ctrlc"]="Нажмите Ctrl+C, чтобы выйти и вернуться в меню"
  TRANSLATIONS["ru,logs_starting"]="Логи запустятся через 5 секунд..."
  TRANSLATIONS["ru,return_main_menu"]="Возврат в главное меню..."
  TRANSLATIONS["ru,current_script_version"]="📌 Текущая версия скрипта:"
  TRANSLATIONS["ru,new_version_avialable"]="🚀 Доступна новая версия:"
  TRANSLATIONS["ru,new_version_update"]="Пожалуйста, обновите скрипт"
  TRANSLATIONS["ru,version_up_to_date"]="✅ Установлена актуальная версия"
  TRANSLATIONS["ru,agent_log_cleaned"]="✅ Лог-файл очищен."
  TRANSLATIONS["ru,agent_container_not_found"]="❌ Контейнер Aztec не найден"
  TRANSLATIONS["ru,agent_block_fetch_error"]="❌ Ошибка получения блока"
  TRANSLATIONS["ru,agent_no_block_in_logs"]="❌ Номер блока не найден в логах ноды"
  TRANSLATIONS["ru,agent_failed_extract_block"]="❌ Не удалось извлечь номер блока"
  TRANSLATIONS["ru,agent_node_behind"]="⚠️ Узел отстает на %d блоков"
  TRANSLATIONS["ru,agent_started"]="🤖 Агент мониторинга Aztec запущен"
  TRANSLATIONS["ru,agent_log_size_warning"]="⚠️ Лог-файл очищен из-за превышения размера"
  TRANSLATIONS["ru,agent_server_info"]="🌐 Сервер: %s"
  TRANSLATIONS["ru,agent_file_info"]="🗃 Файл: %s"
  TRANSLATIONS["ru,agent_size_info"]="📏 Предыдущий размер: %s байт"
  TRANSLATIONS["ru,agent_rpc_info"]="🔗 RPC: %s"
  TRANSLATIONS["ru,agent_error_info"]="💬 Ошибка: %s"
  TRANSLATIONS["ru,agent_block_info"]="📦 Блок в контракте: %s"
  TRANSLATIONS["ru,agent_log_block_info"]="📝 Блок в логах: %s"
  TRANSLATIONS["ru,agent_time_info"]="🕒 %s"
  TRANSLATIONS["ru,agent_line_info"]="📋 Строка: %s"
  TRANSLATIONS["ru,agent_notifications_info"]="ℹ️ Уведомления будут отправляться при проблемах"
  TRANSLATIONS["ru,agent_node_synced"]="✅ Узел синхронизирован (блок %s)"
  TRANSLATIONS["ru,chatid_linked"]="✅ ChatID успешно связан с Aztec Agent"
  TRANSLATIONS["ru,invalid_token"]="Неверный токен Telegram бота. Пожалуйста, попробуйте снова."
  TRANSLATIONS["ru,token_format"]="Токен должен быть в формате: 1234567890:ABCdefGHIJKlmNoPQRsTUVwxyZ"
  TRANSLATIONS["ru,invalid_chatid"]="Неверный Chat ID или бот не имеет доступа к этому чату. Пожалуйста, попробуйте снова."
  TRANSLATIONS["ru,chatid_number"]="Chat ID должен быть числом (может начинаться с - для групповых чатов). Пожалуйста, попробуйте снова."
  TRANSLATIONS["ru,running_install_node"]="Запуск скрипта установки Aztec node из GitHub..."
  TRANSLATIONS["ru,failed_running_install_node"]="Не удалось запустить скрипт установки узла Aztec из GitHub..."
  TRANSLATIONS["ru,failed_downloading_script"]="❌ Не удалось загрузить скрипт установки"
  TRANSLATIONS["ru,install_completed_successfully"]="✅ Установка успешно завершена"
  TRANSLATIONS["ru,logs_stopped_by_user"]="⚠ Просмотр логов остановлен пользователем"
  TRANSLATIONS["ru,installation_cancelled_by_user"]="✖ Установка отменена пользователем"
  TRANSLATIONS["ru,unknown_error_occurred"]="⚠ Произошла неизвестная ошибка при установке"
  TRANSLATIONS["ru,stop_method_prompt"]="Выберите способ остановки ноды Aztec (docker-compose / cli): "
  TRANSLATIONS["ru,enter_compose_path"]="Введите полный путь к папке с docker-compose.yml ($HOME/your_path or ./your_path): "
  TRANSLATIONS["ru,docker_stop_success"]="Контейнеры остановлены, путь сохранён в .env-aztec-agent"
  TRANSLATIONS["ru,no_aztec_screen"]="Активных screen-сессий с Aztec не найдено."
  TRANSLATIONS["ru,cli_stop_success"]="Нода Aztec CLI остановлена, сессия сохранена в .env-aztec-agent"
  TRANSLATIONS["ru,invalid_path"]="Неверный путь или файл docker-compose.yml не найден."
  TRANSLATIONS["ru,starting_node"]="Запуск ноды Aztec..."
  TRANSLATIONS["ru,node_started"]="Нода Aztec запущена."
  TRANSLATIONS["ru,missing_compose"]="Путь к docker-compose.yml не найден в .env-aztec-agent."
  TRANSLATIONS["ru,run_type_not_set"]="RUN_TYPE не задан в конфигурации."
  TRANSLATIONS["ru,confirm_cli_run"]="Вы хотите запустить контейнер в CLI режиме?"
  TRANSLATIONS["ru,run_type_set_to_cli"]="RUN_TYPE установлен в CLI."
  TRANSLATIONS["ru,run_aborted"]="Запуск отменен пользователем."
  TRANSLATIONS["ru,checking_aztec_version"]="Проверка версии Aztec..."
  TRANSLATIONS["ru,aztec_version_failed"]="Не удалось получить версию aztec."
  TRANSLATIONS["ru,aztec_node_version"]="Версия ноды Aztec:"
  TRANSLATIONS["ru,critical_error_found"]="🚨 Найдена критическая ошибка"
  TRANSLATIONS["ru,error_prefix"]="ОШИБКА:"
  TRANSLATIONS["ru,solution_prefix"]="Решение:"
  TRANSLATIONS["ru,notifications_prompt"]="Хотите получать дополнительные уведомления?"
  TRANSLATIONS["ru,notifications_option1"]="1. Только критические ошибки"
  TRANSLATIONS["ru,notifications_option2"]="2. Все уведомления (включая попадание в комитет и активность валидатора)"
  TRANSLATIONS["ru,notifications_debug_warning"]="Для получения уведомлений о попадании в комитет и статистике слотов требуется уровень логов DEBUG"
  TRANSLATIONS["ru,notifications_input_error"]="Ошибка: введите 1 или 2"
  TRANSLATIONS["ru,choose_option_prompt"]="Выберите вариант"
  TRANSLATIONS["ru,committee_selected"]="🎉 Тебя выбрали в комитет"
  TRANSLATIONS["ru,found_validators"]="Найдены валидаторы в комитете: %s"
  TRANSLATIONS["ru,epoch_info"]="Эпоха %s"
  TRANSLATIONS["ru,block_built"]="✅ Блок %s успешно построен"
  TRANSLATIONS["ru,slot_info"]="Слот %s"
  TRANSLATIONS["ru,validators_prompt"]="Введите адреса валидаторов (через запятую, без пробелов):"
  TRANSLATIONS["ru,validators_format"]="Пример: 0x123...,0x456...,0x789..."
  TRANSLATIONS["ru,validators_empty"]="Ошибка: Список валидаторов не может быть пустым"
  TRANSLATIONS["ru,status_legend"]="Легенда статусов:"
  TRANSLATIONS["ru,status_empty"]="⬜️ Пустой слот"
  TRANSLATIONS["ru,status_attestation_sent"]="🟩 Аттестация отправлена"
  TRANSLATIONS["ru,status_attestation_missed"]="🟥 Аттестация пропущена"
  TRANSLATIONS["ru,status_block_mined"]="🟦 Блок добыт"
  TRANSLATIONS["ru,status_block_missed"]="🟨 Блок пропущен"
  TRANSLATIONS["ru,status_block_proposed"]="🟪 Блок предложен"
  TRANSLATIONS["ru,publisher_monitoring_title"]="=== Мониторинг баланса publisher ==="
  TRANSLATIONS["ru,publisher_monitoring_option1"]="1. Добавить адреса и запустить мониторинг баланса"
  TRANSLATIONS["ru,publisher_monitoring_option2"]="2. Настроить значение минимального баланса"
  TRANSLATIONS["ru,publisher_monitoring_option3"]="3. Остановить мониторинг балансов"
  TRANSLATIONS["ru,publisher_monitoring_choose"]="Выберите опцию (1/2/3):"
  TRANSLATIONS["ru,publisher_addresses_prompt"]="Введите адреса publisher для мониторинга баланса (через запятую, без пробелов):"
  TRANSLATIONS["ru,publisher_addresses_format"]="Пример: 0x123...,0x456...,0x789..."
  TRANSLATIONS["ru,publisher_addresses_empty"]="Ошибка: Список адресов publisher не может быть пустым"
  TRANSLATIONS["ru,publisher_min_balance_prompt"]="Введите минимальное значение баланса для уведомления (по умолчанию: 0.15 ETH):"
  TRANSLATIONS["ru,publisher_min_balance_invalid"]="Ошибка: Неверное значение баланса. Введите положительное число."
  TRANSLATIONS["ru,publisher_monitoring_enabled"]="Мониторинг баланса publisher включен"
  TRANSLATIONS["ru,publisher_monitoring_disabled"]="Мониторинг баланса publisher отключен"
  TRANSLATIONS["ru,publisher_balance_warning"]="⚠️ Обнаружен низкий баланс на адресах publisher"
  TRANSLATIONS["ru,publisher_balance_address"]="Адрес: %s, Баланс: %s ETH"
  TRANSLATIONS["ru,current_slot"]="Текущий слот: %s"
  TRANSLATIONS["ru,agent_notifications_full_info"]="ℹ️ Уведомления будут отправляться при проблемах, выборе в комитет, статистике слотов"
  TRANSLATIONS["ru,attestation_status"]="ℹ️ Статистика слота"
  #peerID
  TRANSLATIONS["ru,fetching_peer_info"]="Получение информации о пире из API..."
  TRANSLATIONS["ru,peer_found"]="Peer ID найден в логах"
  TRANSLATIONS["ru,peer_not_in_list"]="Пир не найден в публичном списке"
  TRANSLATIONS["ru,peer_id_not_critical"]="Наличие или отсутствие Peer ID в Nethermind.io не является критично важным параметром. Данные могут быть неактуальными."
  TRANSLATIONS["ru,searching_latest"]="Поиск в актуальных данных..."
  TRANSLATIONS["ru,searching_archive"]="Поиск в архивных данных..."
  TRANSLATIONS["ru,peer_found_archive"]="Примечание: Этот пир был найден в архивных данных"
  #
  TRANSLATIONS["ru,cli_quit_old_sessions"]="Закрыта старая сессия:"
  #delete section
  TRANSLATIONS["ru,delete_node"]="🗑️ Удаление ноды Aztec..."
  TRANSLATIONS["ru,delete_confirm"]="Вы уверены, что хотите удалить ноду Aztec? Это остановит контейнеры и удалит все данные. (y/n) "
  TRANSLATIONS["ru,node_deleted"]="✅ Нода Aztec успешно удалена"
  TRANSLATIONS["ru,delete_canceled"]="✖ Удаление ноды отменено"
  TRANSLATIONS["ru,delete_watchtower_confirm"]="Хотите также удалить Watchtower? (y/n) "
  TRANSLATIONS["ru,watchtower_deleted"]="✅ Watchtower успешно удален"
  TRANSLATIONS["ru,watchtower_kept"]="✅ Watchtower оставлен без изменений"
  TRANSLATIONS["ru,enter_tg_token"]="Введите токен Telegram бота: "
  TRANSLATIONS["ru,enter_tg_chat_id"]="Введите ID Telegram чата: "
  TRANSLATIONS["ru,single_validator_mode"]="🔹 Выбран режим одного валидатора"
  TRANSLATIONS["ru,multi_validator_mode"]="🔹 Выбран режим нескольких валидаторов"
  TRANSLATIONS["ru,enter_validator_keys"]="Введите приватные ключи валидаторов (c 0x через запятую, до 10): "
  TRANSLATIONS["ru,enter_validator_key"]="Введите приватный ключ валидатора (с 0x): "
  TRANSLATIONS["ru,enter_seq_publisher_key"]="Введите SEQ_PUBLISHER_PRIVATE_KEY (с 0x): "
  TRANSLATIONS["ru,enter_yn"]="Пожалуйста, введите Y или N: "
  TRANSLATIONS["ru,stopping_containers"]="Остановка контейнеров..."
  TRANSLATIONS["ru,removing_node_data"]="Удаление данных ноды Aztec..."
  TRANSLATIONS["ru,stopping_watchtower"]="Остановка Watchtower..."
  TRANSLATIONS["ru,removing_watchtower_data"]="Удаление данных Watchtower..."
  #update
  TRANSLATIONS["ru,update_title"]="Обновление ноды Aztec до последней версии"
  TRANSLATIONS["ru,update_folder_error"]="Ошибка: Папка $HOME/aztec не существует"
  TRANSLATIONS["ru,update_stopping"]="Остановка контейнеров..."
  TRANSLATIONS["ru,update_stop_error"]="Ошибка при остановке контейнеров"
  TRANSLATIONS["ru,update_pulling"]="Загрузка последнего образа aztecprotocol/aztec..."
  TRANSLATIONS["ru,update_pull_error"]="Ошибка при загрузке образа"
  TRANSLATIONS["ru,update_starting"]="Запуск обновленной ноды..."
  TRANSLATIONS["ru,update_start_error"]="Ошибка при запуске контейнеров"
  TRANSLATIONS["ru,update_success"]="Нода Aztec успешно обновлена до последней версии!"
  TRANSLATIONS["ru,tag_check"]="Обнаружен тег: %s, заменяем на latest"
  #downgrade
  TRANSLATIONS["ru,downgrade_title"]="Даунгрейд ноды Aztec"
  TRANSLATIONS["ru,downgrade_fetching"]="Получение списка доступных версий..."
  TRANSLATIONS["ru,downgrade_fetch_error"]="Не удалось получить список версий"
  TRANSLATIONS["ru,downgrade_available"]="Доступные версии (введите номер):"
  TRANSLATIONS["ru,downgrade_invalid_choice"]="Неверный выбор, попробуйте еще раз"
  TRANSLATIONS["ru,downgrade_selected"]="Выбрана версия:"
  TRANSLATIONS["ru,downgrade_folder_error"]="Ошибка: Папка $HOME/aztec не существует"
  TRANSLATIONS["ru,downgrade_stopping"]="Остановка контейнеров..."
  TRANSLATIONS["ru,downgrade_stop_error"]="Ошибка при остановке контейнеров"
  TRANSLATIONS["ru,downgrade_pulling"]="Загрузка образа aztecprotocol/aztec:"
  TRANSLATIONS["ru,downgrade_pull_error"]="Ошибка при загрузке образа"
  TRANSLATIONS["ru,downgrade_updating"]="Обновление конфигурации..."
  TRANSLATIONS["ru,downgrade_update_error"]="Ошибка при обновлении docker-compose.yml"
  TRANSLATIONS["ru,downgrade_starting"]="Запуск ноды с версией"
  TRANSLATIONS["ru,downgrade_start_error"]="Ошибка при запуске контейнеров"
  TRANSLATIONS["ru,downgrade_success"]="Нода Aztec успешно даунгрейднута до версии"
  #agent
  TRANSLATIONS["ru,agent_systemd_added"]="Агент добавлен (запуск каждые 37 секунд через systemd)"
  TRANSLATIONS["ru,agent_timer_status"]="Статус таймера:"
  TRANSLATIONS["ru,agent_timer_error"]="Ошибка при создании systemd таймера"
  TRANSLATIONS["ru,removing_systemd_agent"]="Удаление агента и systemd unit-файлов..."
  TRANSLATIONS["ru,agent_systemd_removed"]="Агент успешно удалён"
  #version module
  TRANSLATIONS["ru,update_changes"]="Изменения в обновлении"
  TRANSLATIONS["ru,installed"]="установлен"
  TRANSLATIONS["ru,not_installed"]="не установлен"
  TRANSLATIONS["ru,curl_cffi_not_installed"]="Python-пакет curl_cffi не установлен."
  TRANSLATIONS["ru,install_curl_cffi_prompt"]="Хотите установить curl_cffi сейчас? (Y/n)"
  TRANSLATIONS["ru,installing_curl_cffi"]="Устанавливается curl_cffi..."
  TRANSLATIONS["ru,curl_cffi_optional"]="Установка curl_cffi пропущена (необязательно)."

  # Translations from install_aztec.sh (Russian)
  TRANSLATIONS["ru,installing_deps"]="🔧 Установка системных зависимостей..."
  TRANSLATIONS["ru,deps_installed"]="✅ Зависимости установлены"
  TRANSLATIONS["ru,checking_docker"]="🔍 Проверка Docker и docker compose..."
  TRANSLATIONS["ru,docker_not_found"]="❌ Docker не установлен"
  TRANSLATIONS["ru,docker_compose_not_found"]="❌ docker compose (v2+) не найден"
  TRANSLATIONS["ru,install_docker_prompt"]="Установить Docker? (y/n) "
  TRANSLATIONS["ru,install_compose_prompt"]="Установить Docker Compose? (y/n) "
  TRANSLATIONS["ru,docker_required"]="❌ Docker необходим для работы скрипта. Выход."
  TRANSLATIONS["ru,compose_required"]="❌ Docker Compose необходим для работы скрипта. Выход."
  TRANSLATIONS["ru,installing_docker"]="Установка Docker..."
  TRANSLATIONS["ru,installing_compose"]="Установка Docker Compose..."
  TRANSLATIONS["ru,docker_installed"]="✅ Docker успешно установлен"
  TRANSLATIONS["ru,compose_installed"]="✅ Docker Compose успешно установлен"
  TRANSLATIONS["ru,docker_found"]="✅ Docker и docker compose найдены"
  TRANSLATIONS["ru,installing_aztec"]="⬇️ Установка ноды Aztec..."
  TRANSLATIONS["ru,aztec_not_installed"]="❌ Aztec нода не установлена. Проверьте установку."
  TRANSLATIONS["ru,aztec_installed"]="✅ Aztec нода установлена"
  TRANSLATIONS["ru,running_aztec_up"]="🚀 Запуск aztec-up latest..."
  TRANSLATIONS["ru,opening_ports"]="🌐 Открытие портов 40400 и 8080..."
  TRANSLATIONS["ru,ports_opened"]="✅ Порты открыты"
  TRANSLATIONS["ru,creating_folder"]="📁 Создание папки ~/aztec..."
  TRANSLATIONS["ru,creating_env"]="📝 Заполнение файла .env..."
  TRANSLATIONS["ru,env_created"]="✅ Файл .env создан"
  TRANSLATIONS["ru,creating_compose"]="🛠️ Создание docker-compose.yml c Watchtower"
  TRANSLATIONS["ru,compose_created"]="✅ docker-compose.yml создан"
  TRANSLATIONS["ru,starting_node"]="🚀 Запуск ноды Aztec..."
  TRANSLATIONS["ru,showing_logs"]="📄 Показываю последние 200 строк логов..."
  TRANSLATIONS["ru,logs_starting"]="Логи запустятся через 5 секунд... Нажмите Ctrl+C чтобы выйти из логов"
  TRANSLATIONS["ru,checking_ports"]="Проверка портов..."
  TRANSLATIONS["ru,port_error"]="Ошибка: Порт $port занят. Программа не сможет выполниться."
  TRANSLATIONS["ru,ports_free"]="Все порты свободны! Сейчас начнется установка...\n"
  TRANSLATIONS["ru,ports_busy"]="Следующие порты заняты:"
  TRANSLATIONS["ru,change_ports_prompt"]="Хотите изменить порты? (y/n) "
  TRANSLATIONS["ru,enter_new_ports"]="Введите новые номера портов:"
  TRANSLATIONS["ru,enter_http_port"]="Введите HTTP порт"
  TRANSLATIONS["ru,enter_p2p_port"]="Введите P2P порт"
  TRANSLATIONS["ru,installation_aborted"]="Установка прервана пользователем"
  TRANSLATIONS["ru,checking_ports_desc"]="Проверка, что порты не используются другим процессами..."
  TRANSLATIONS["ru,scanning_ports"]="Сканирование портов"
  TRANSLATIONS["ru,busy"]="занят"
  TRANSLATIONS["ru,free"]="свободен"
  TRANSLATIONS["ru,ports_free_success"]="Все порты доступны"
  TRANSLATIONS["ru,ports_busy_error"]="Некоторые порты уже используются"
  TRANSLATIONS["ru,enter_new_ports_prompt"]="Введите новые номера портов"
  TRANSLATIONS["ru,ports_updated"]="Номера портов обновлены"
  TRANSLATIONS["ru,installing_ss"]="Установка iproute2 (содержит утилиту ss)..."
  TRANSLATIONS["ru,ss_installed"]="iproute2 успешно установлен"
  TRANSLATIONS["ru,delete_node"]="🗑️ Удаление ноды Aztec..."
  TRANSLATIONS["ru,delete_confirm"]="Вы уверены, что хотите удалить ноду Aztec? Это остановит контейнеры и удалит все данные. (y/n) "
  TRANSLATIONS["ru,delete_canceled"]="✖ Удаление ноды отменено"
  TRANSLATIONS["ru,warn_orig_install"]="⚠️ Введите 'n' когда появится вопрос:"
  TRANSLATIONS["ru,warn_orig_install_2"]="Add it to $HOME/.bash_profile to make the aztec binaries accessible?"
  TRANSLATIONS["ru,watchtower_exists"]="✅ Watchtower уже установлен"
  TRANSLATIONS["ru,installing_watchtower"]="⬇️ Установка Watchtower..."
  TRANSLATIONS["ru,creating_watchtower_compose"]="🛠️ Создание Watchtower docker-compose.yml"
  TRANSLATIONS["ru,delete_watchtower_confirm"]="Хотите также удалить Watchtower? (y/n) "
  TRANSLATIONS["ru,watchtower_deleted"]="✅ Watchtower успешно удален"
  TRANSLATIONS["ru,watchtower_kept"]="✅ Watchtower оставлен без изменений"
  TRANSLATIONS["ru,enter_tg_token"]="Введите токен Telegram бота: "
  TRANSLATIONS["ru,enter_tg_chat_id"]="Введите ID Telegram чата: "
  TRANSLATIONS["ru,single_validator_mode"]="🔹 Выбран режим одного валидатора"
  TRANSLATIONS["ru,multi_validator_mode"]="🔹 Выбран режим нескольких валидаторов"
  TRANSLATIONS["ru,enter_validator_keys"]="Введите приватные ключи валидаторов (c 0x через запятую, до 10): "
  TRANSLATIONS["ru,enter_validator_key"]="Введите приватный ключ валидатора (с 0x): "
  TRANSLATIONS["ru,enter_seq_publisher_key"]="Введите SEQ_PUBLISHER_PRIVATE_KEY (с 0x): "
  TRANSLATIONS["ru,validator_setup_header"]="=== Настройка валидатора ==="
  TRANSLATIONS["ru,multiple_validators_prompt"]="Вы хотите запустить несколько валидаторов? (y/n)"
  TRANSLATIONS["ru,ufw_not_installed"]="⚠️ ufw не установлен"
  TRANSLATIONS["ru,ufw_not_active"]="⚠️ ufw не активен"
  TRANSLATIONS["ru,has_bls_keys"]="У вас есть BLS ключи? (y/n) "
  TRANSLATIONS["ru,multi_validator_format"]="Введите данные валидатора (формат: private_key,address,private_bls,public_bls):"
  TRANSLATIONS["ru,single_validator_bls_private"]="Введите приватный BLS ключ валидатора:"
  TRANSLATIONS["ru,single_validator_bls_public"]="Введите публичный BLS ключ валидатора:"
  TRANSLATIONS["ru,bls_keys_added"]="BLS ключи добавлены в конфигурацию валидатора"
  TRANSLATIONS["ru,select_network"]="Выберите сеть"
  TRANSLATIONS["ru,enter_choice"]="Введите:"
  TRANSLATIONS["ru,selected_network"]="Выбрана сеть:"
  TRANSLATIONS["ru,mainnet"]="mainnet"
  TRANSLATIONS["ru,testnet"]="testnet"

  # Translations from check-validator.sh (Russian)
  TRANSLATIONS["ru,fetching_validators"]="Получение списка валидаторов из контракта"
  TRANSLATIONS["ru,found_validators"]="Найдено валидаторов:"
  TRANSLATIONS["ru,checking_validators"]="Проверка валидаторов..."
  TRANSLATIONS["ru,check_completed"]="Проверка завершена."
  TRANSLATIONS["ru,select_action"]="Выберите действие:"
  TRANSLATIONS["ru,validator_submenu_option1"]="1. Проверить другой набор валидаторов"
  TRANSLATIONS["ru,validator_submenu_option2"]="2. Настроить уведомление о позиции в очереди для валидатора"
  TRANSLATIONS["ru,validator_submenu_option3"]="3. Проверить валидатора в очереди"
  TRANSLATIONS["ru,validator_submenu_option4"]="4. Список активных мониторов"
  TRANSLATIONS["ru,validator_submenu_option5"]="5. Удалить существующий мониторинг"
  TRANSLATIONS["ru,enter_option"]="Выберите опцию:"
  TRANSLATIONS["ru,enter_address"]="Введите адрес валидатора:"
  TRANSLATIONS["ru,validator_info"]="Информация о валидаторе:"
  TRANSLATIONS["ru,address"]="Адрес"
  TRANSLATIONS["ru,stake"]="Стейк"
  TRANSLATIONS["ru,withdrawer"]="Withdrawer адрес"
  TRANSLATIONS["ru,rewards"]="Реварды"
  TRANSLATIONS["ru,status"]="Статус"
  TRANSLATIONS["ru,status_0"]="NONE - Валидатор не в наборе валидаторов"
  TRANSLATIONS["ru,status_1"]="VALIDATING - Валидатор в настоящее время в наборе валидаторов"
  TRANSLATIONS["ru,status_2"]="ZOMBIE - Не участвует в качестве валидатора, но есть средства в стейкинге, получает штраф за слэшинг, баланс снижается до минимума"
  TRANSLATIONS["ru,status_3"]="EXITING - В процессе выхода из системы"
  TRANSLATIONS["ru,validator_not_found"]="Валидатор с адресом %s не найден."
  TRANSLATIONS["ru,exiting"]="Выход."
  TRANSLATIONS["ru,invalid_input"]="Неверный ввод. Пожалуйста, выберите 1, 2, 3 или 0."
  TRANSLATIONS["ru,error_rpc_missing"]="Ошибка: RPC_URL не найден в $HOME/.env-aztec-agent"
  TRANSLATIONS["ru,error_file_missing"]="Ошибка: файл $HOME/.env-aztec-agent не найден"
  TRANSLATIONS["ru,select_mode"]="Выберите режим загрузки:"
  TRANSLATIONS["ru,mode_fast"]="1. Быстрый режим (высокая нагрузка на CPU)"
  TRANSLATIONS["ru,mode_slow"]="2. Медленный режим (низкая нагрузка на CPU)"
  TRANSLATIONS["ru,mode_invalid"]="Неверный режим. Пожалуйста, выберите 1 или 2."
  TRANSLATIONS["ru,checking_queue"]="Проверка очереди валидаторов..."
  TRANSLATIONS["ru,validator_in_queue"]="Валидатор найден в очереди:"
  TRANSLATIONS["ru,position"]="Позиция"
  TRANSLATIONS["ru,queued_at"]="Добавлен в очередь"
  TRANSLATIONS["ru,not_in_queue"]="Валидатора нет и в очереди."
  TRANSLATIONS["ru,fetching_queue"]="Получение данных очереди валидаторов..."
  TRANSLATIONS["ru,notification_script_created"]="Скрипт уведомления создан и запланирован. Мониторинг валидатора: %s"
  TRANSLATIONS["ru,notification_exists"]="Уведомление для этого валидатора уже существует."
  TRANSLATIONS["ru,enter_validator_address"]="Введите адрес валидатора для мониторинга:"
  TRANSLATIONS["ru,notification_removed"]="Уведомление для валидатора %s удалено."
  TRANSLATIONS["ru,no_notifications"]="Активных уведомлений не найдено."
  TRANSLATIONS["ru,validator_not_in_queue"]="Валидатор не найден и в очереди. Пожалуйста, проверьте адрес."
  TRANSLATIONS["ru,validator_not_in_set"]="Валидатор не найден в текущем наборе. Проверяем очередь..."
  TRANSLATIONS["ru,queue_notification_title"]="Уведомление о позиции в очереди валидаторов"
  TRANSLATIONS["ru,active_monitors"]="Активные мониторы валидаторов:"
  TRANSLATIONS["ru,enter_multiple_addresses"]="Введите адреса валидаторов для мониторинга (через запятую):"
  TRANSLATIONS["ru,invalid_address_format"]="Неверный формат адреса: %s"
  TRANSLATIONS["ru,processing_address"]="Обработка адреса: %s"
  TRANSLATIONS["ru,add_validators_to_queue_prompt"]="Хотите добавить этих валидаторов в мониторинг очереди?"
  TRANSLATIONS["ru,enter_yes_to_add"]="Введите 'yes' для добавления всех, или 'no' для пропуска:"
  TRANSLATIONS["ru,queue_validators_added"]="Все валидаторы из очереди добавлены в мониторинг."
  TRANSLATIONS["ru,skipping_queue_setup"]="Пропуск настройки мониторинга очереди."
  TRANSLATIONS["ru,queue_validators_available"]="Валидаторы из очереди доступны для мониторинга"
  TRANSLATIONS["ru,initial_notification_note"]="Примечание: Начальное уведомление отправлено. Скрипт включает защитные таймауты."
  TRANSLATIONS["ru,running_initial_test"]="Запуск начального теста..."
  TRANSLATIONS["ru,no_valid_addresses"]="Нет действительных адресов для проверки."
  TRANSLATIONS["ru,fetching_page"]="Получение страницы %d из %d..."
  TRANSLATIONS["ru,loading_validators"]="Загрузка данных валидаторов..."
  TRANSLATIONS["ru,validators_loaded"]="Данные валидаторов успешно загружены"
  TRANSLATIONS["ru,rpc_error"]="Произошла ошибка RPC, пробуем альтернативный RPC"
  TRANSLATIONS["ru,getting_new_rpc"]="Получение нового RPC URL..."
  TRANSLATIONS["ru,rate_limit_notice"]="Используется резервный RPC - ограничение скорости: 1 запрос в секунду"
  TRANSLATIONS["ru,getting_validator_count"]="Получение количества валидаторов..."
  TRANSLATIONS["ru,getting_current_slot"]="Получение текущего слота..."
  TRANSLATIONS["ru,deriving_timestamp"]="Получение временной метки для слота..."
  TRANSLATIONS["ru,querying_attesters"]="Запрос аттестующих из GSE контракта..."
  TRANSLATIONS["ru,select_monitor_to_remove"]="Выберите монитор для удаления:"
  TRANSLATIONS["ru,monitor_removed"]="Мониторинг для валидатора %s удален."
  TRANSLATIONS["ru,all_monitors_removed"]="Все скрипты мониторинга удалены."
  TRANSLATIONS["ru,remove_all"]="Удалить все скрипты мониторинга"
  TRANSLATIONS["ru,remove_specific"]="Удалить конкретный монитор"
  TRANSLATIONS["ru,api_error"]="Возможны проблемы с Dashtec API"
  TRANSLATIONS["ru,contact_developer"]="Сообщите разработчику: https://t.me/+zEaCtoXYYwIyZjQ0"

  TRANSLATIONS["ru,installing_foundry"]="Устанавливается Foundry..."
  TRANSLATIONS["ru,installing_curl"]="Устанавливается curl..."
  TRANSLATIONS["ru,installing_utils"]="Устанавливаются утилиты (grep, sed)..."
  TRANSLATIONS["ru,installing_jq"]="Устанавливается jq..."
  TRANSLATIONS["ru,installing_bc"]="Устанавливается bc..."
  TRANSLATIONS["ru,installing_python3"]="Устанавливается Python3..."

  TRANSLATIONS["ru,bls_restarting_web3signer"]="Перезапускаем web3signer для загрузки нового ключа"
  TRANSLATIONS["ru,bls_web3signer_restarted"]="Web3signer успешно перезапущен"
  TRANSLATIONS["ru,bls_web3signer_running"]="Web3signer работает после перезапуска"
  TRANSLATIONS["ru,bls_web3signer_not_running"]="Web3signer не запущен после перезапуска"
  TRANSLATIONS["ru,bls_web3signer_restart_failed"]="Не удалось перезапустить web3signer"
  TRANSLATIONS["ru,bls_final_web3signer_restart"]="Выполняем финальный перезапуск web3signer для загрузки всех ключей"
  TRANSLATIONS["ru,bls_final_web3signer_restarted"]="Финальный перезапуск web3signer завершен"
  TRANSLATIONS["ru,bls_final_web3signer_restart_failed"]="Финальный перезапуск web3signer не удался"

  TRANSLATIONS["ru,aztec_rewards_claim"]="Aztec Rewards Claim"
  TRANSLATIONS["ru,environment_file_not_found"]="Файл окружения не найден"
  TRANSLATIONS["ru,rpc_url_not_set"]="RPC_URL не установлен"
  TRANSLATIONS["ru,contract_address_not_set"]="CONTRACT_ADDRESS не установлен"
  TRANSLATIONS["ru,using_contract"]="Используется контракт:"
  TRANSLATIONS["ru,using_rpc"]="Используется RPC:"
  TRANSLATIONS["ru,checking_rewards_claimable"]="Проверка доступности наград..."
  TRANSLATIONS["ru,failed_check_rewards_claimable"]="Не удалось проверить статус доступности наград"
  TRANSLATIONS["ru,rewards_not_claimable"]="Награды не доступны для получения в данный момент"
  TRANSLATIONS["ru,rewards_are_claimable"]="Награды доступны для получения"
  TRANSLATIONS["ru,keystore_file_not_found"]="Файл keystore не найден:"
  TRANSLATIONS["ru,extracting_validator_addresses"]="Извлечение адресов валидаторов..."
  TRANSLATIONS["ru,no_coinbase_addresses_found"]="Адреса coinbase не найдены в keystore"
  TRANSLATIONS["ru,found_unique_coinbase_addresses"]="Найдено уникальных адресов coinbase:"
  TRANSLATIONS["ru,repeats_times"]="повторяется %s раз"
  TRANSLATIONS["ru,checking_rewards"]="Проверка наград..."
  TRANSLATIONS["ru,checking_address"]="Проверка адреса"
  TRANSLATIONS["ru,failed_get_rewards_for_address"]="Не удалось получить награды для адреса"
  TRANSLATIONS["ru,failed_convert_rewards_amount"]="Не удалось конвертировать сумму наград для адреса"
  TRANSLATIONS["ru,failed_convert_to_eth"]="Не удалось конвертировать сумму для адреса"
  TRANSLATIONS["ru,rewards_amount"]="Награды: %s"
  TRANSLATIONS["ru,no_rewards"]="Нет наград"
  TRANSLATIONS["ru,no_rewards_to_claim"]="Нет наград для получения в данный момент"
  TRANSLATIONS["ru,found_unique_addresses_with_rewards"]="Найдено уникальных адресов с наградами для получения:"
  TRANSLATIONS["ru,already_claimed_this_session"]="Уже получено для адреса"
  TRANSLATIONS["ru,skipping"]="пропускаем"
  TRANSLATIONS["ru,address_label"]="Адрес:"
  TRANSLATIONS["ru,amount_eth"]="Сумма: %s"
  TRANSLATIONS["ru,address_appears_times"]="Этот адрес появляется %s раз в keystore"
  TRANSLATIONS["ru,claim_rewards_confirmation"]="Хотите получить эти награды? (y/n/skip):"
  TRANSLATIONS["ru,claiming_rewards"]="Получение наград..."
  TRANSLATIONS["ru,transaction_sent"]="Транзакция отправлена:"
  TRANSLATIONS["ru,waiting_confirmation"]="Ожидание подтверждения..."
  TRANSLATIONS["ru,transaction_confirmed_successfully"]="Транзакция успешно подтверждена"
  TRANSLATIONS["ru,rewards_successfully_claimed"]="Награды успешно получены"
  TRANSLATIONS["ru,rewards_claimed_balance_not_zero"]="Награды получены, но баланс не обнулен: %s"
  TRANSLATIONS["ru,claimed_rewards_for_address_appears_times"]="Получены награды для %s (появляется %s раз)"
  TRANSLATIONS["ru,transaction_failed"]="Транзакция не удалась"
  TRANSLATIONS["ru,could_not_get_receipt_transaction_sent"]="Не удалось получить квитанцию, но транзакция была отправлена"
  TRANSLATIONS["ru,failed_send_transaction"]="Не удалось отправить транзакцию"
  TRANSLATIONS["ru,skipping_claim_for_address"]="Пропускаем получение для адреса"
  TRANSLATIONS["ru,skipping_all_remaining_claims"]="Пропускаем все оставшиеся получения"
  TRANSLATIONS["ru,waiting_seconds"]="Ожидание 5 секунд..."
  TRANSLATIONS["ru,summary"]="СВОДКА"
  TRANSLATIONS["ru,successfully_claimed"]="Успешно получено:"
  TRANSLATIONS["ru,failed_count"]="Не удалось:"
  TRANSLATIONS["ru,unique_addresses_with_rewards"]="Уникальных адресов с наградами:"
  TRANSLATIONS["ru,total_coinbase_addresses_in_keystore"]="Всего адресов coinbase в keystore:"
  TRANSLATIONS["ru,contract_used"]="Использованный контракт:"
  TRANSLATIONS["ru,earliest_rewards_claimable_timestamp"]="Самая ранняя метка времени для получения наград: %s (%s)"
  TRANSLATIONS["ru,claim_function_not_activated"]="В настоящее время функция клейма неактивирована в контракте"

  # Turkish translations
  TRANSLATIONS["tr,welcome"]="Aztec düğüm izleme betiğine hoş geldiniz"
  TRANSLATIONS["tr,title"]="========= Ana Menü ========="
  TRANSLATIONS["tr,option1"]="1. Konteyner ve düğüm senkronizasyonunun kontrol et"
  TRANSLATIONS["tr,option2"]="2. Bildirimlerle düğüm izleme aracısını yükleyin"
  TRANSLATIONS["tr,option3"]="3. İzleme aracısını kaldır"
  TRANSLATIONS["tr,option4"]="4. Aztec loglarını görüntüle"
  TRANSLATIONS["tr,option5"]="5. rollupAddress bul"
  TRANSLATIONS["tr,option6"]="6. PeerID bul"
  TRANSLATIONS["tr,option7"]="7. governanceProposerPayload bul"
  TRANSLATIONS["tr,option8"]="8. Kanıtlanmış L2 Bloğunu Kontrol Et"
  TRANSLATIONS["tr,option9"]="9. Validator arama, durum kontrolü ve sıra izleme"
  TRANSLATIONS["tr,option10"]="10. Publisher bakiye izleme"
  TRANSLATIONS["tr,option11"]="11. Watchtower ile birlikte Aztec Node Kurulumu"
  TRANSLATIONS["tr,option12"]="12. Aztec düğümünü sil"
  TRANSLATIONS["tr,option13"]="13. Aztec düğüm konteynerlerini başlat"
  TRANSLATIONS["tr,option14"]="14. Aztec düğüm konteynerlerini durdur"
  TRANSLATIONS["tr,option15"]="15. Aztec düğümünü güncelle"
  TRANSLATIONS["tr,option16"]="16. Aztec düğümünü eski sürüme düşür"
  TRANSLATIONS["tr,option17"]="17. Aztek sürümünü kontrol edin"
  TRANSLATIONS["tr,option18"]="18. Mnemonic'ten BLS anahtarları oluştur"
  TRANSLATIONS["tr,option19"]="19. Approve"
  TRANSLATIONS["tr,option20"]="20. Stake"
  TRANSLATIONS["tr,option21"]="21. Ödülleri talep edin"
  TRANSLATIONS["tr,option22"]="22. RPC URL'sini değiştir"
  TRANSLATIONS["tr,option23"]="23. Script güncellemelerini kontrol et (güvenli, hash doğrulama ile)"
  TRANSLATIONS["tr,option24"]="24. Hata tanımları güncellemelerini kontrol et (güvenli, hash doğrulama ile)"
  TRANSLATIONS["tr,option0"]="0. Çıkış"

  # Güncelleme kontrolü çevirileri
  TRANSLATIONS["tr,local_version_shows"]="Yerel sürüm dosyası sürümü gösteriyor:"
  TRANSLATIONS["tr,note_check_updates_safely"]="Not: Uzaktan güncellemeleri güvenli bir şekilde kontrol etmek için isteğe bağlı güncelleme kontrolü işlevini kullanın"
  TRANSLATIONS["tr,local_version_up_to_date"]="Yerel sürüm dosyası güncel"
  TRANSLATIONS["tr,safe_update_check"]="Güvenli Güncelleme Kontrolü"
  TRANSLATIONS["tr,update_check_warning"]="Bu, SHA256 doğrulaması ile GitHub'dan version_control.json dosyasını indirecektir."
  TRANSLATIONS["tr,file_not_executed_auto"]="Dosya indirilecek ancak otomatik olarak ÇALIŞTIRILMAYACAKTIR."
  TRANSLATIONS["tr,continue_prompt"]="Devam edilsin mi? (y/n)"
  TRANSLATIONS["tr,update_check_cancelled"]="Güncelleme kontrolü iptal edildi."
  TRANSLATIONS["tr,downloading_version_control"]="version_control.json indiriliyor..."
  TRANSLATIONS["tr,failed_download_version_control"]="version_control.json indirilemedi"
  TRANSLATIONS["tr,downloaded_file_sha256"]="İndirilen dosya SHA256:"
  TRANSLATIONS["tr,verify_hash_match"]="Lütfen bu hash'in depodaki beklenen hash ile eşleştiğini doğrulayın."
  TRANSLATIONS["tr,current_installed_version"]="Mevcut yüklü sürüm:"
  TRANSLATIONS["tr,latest_version_repo"]="Depodaki en son sürüm:"
  TRANSLATIONS["tr,new_version_available"]="Yeni sürüm mevcut:"
  TRANSLATIONS["tr,version_label"]="Sürüm:"
  TRANSLATIONS["tr,note_update_manually"]="Not: Güncellemek için depodan en son değişiklikleri manuel olarak çekin."
  TRANSLATIONS["tr,safe_error_def_update_check"]="Güvenli Hata Tanımları Güncelleme Kontrolü"
  TRANSLATIONS["tr,error_def_update_warning"]="Bu, SHA256 doğrulaması ile GitHub'dan error_definitions.json dosyasını indirecektir."
  TRANSLATIONS["tr,downloading_error_definitions"]="error_definitions.json indiriliyor..."
  TRANSLATIONS["tr,failed_download_error_definitions"]="error_definitions.json indirilemedi"
  TRANSLATIONS["tr,error_def_matches_remote"]="Yerel error_definitions.json uzak sürümle eşleşiyor."
  TRANSLATIONS["tr,local_remote_versions_differ"]="Yerel ve uzak sürümler farklı."
  TRANSLATIONS["tr,local_hash"]="Yerel hash:"
  TRANSLATIONS["tr,remote_hash"]="Uzak hash:"
  TRANSLATIONS["tr,local_error_def_not_found"]="Yerel error_definitions.json bulunamadı."
  TRANSLATIONS["tr,bls_mnemonic_prompt"]="Hafıza ifadenizin 12 kelimesinin tamamını kopyalayın, yapıştırın ve Enter'a basın (giriş gizlenecek, ancak yapıştırılacak):"
  TRANSLATIONS["tr,bls_wallet_count_prompt"]="Oluşturulacak cüzdan sayısını girin. \nÖrneğin: seed ifadenizde yalnızca bir cüzdan varsa, 1 rakamını girin. \nSeed ifadenizde birden fazla doğrulayıcı için birden fazla cüzdan varsa, son cüzdanın yaklaşık en yüksek numarasını girin, örneğin 30, 50. \nEmin değilseniz daha büyük bir sayı belirtmeniz daha iyidir, betik tüm anahtarları toplayacak ve fazlalıkları silecektir."
  TRANSLATIONS["tr,bls_invalid_number"]="Geçersiz sayı. Lütfen pozitif bir tam sayı girin."
  TRANSLATIONS["tr,bls_keystore_not_found"]="❌ $HOME/aztec/config/keystore.json konumunda keystore.json bulunamadı"
  TRANSLATIONS["tr,bls_fee_recipient_not_found"]="❌ keystore.json dosyasında feeRecipient bulunamadı"
  TRANSLATIONS["tr,bls_generating_keys"]="🔑 BLS anahtarları oluşturuluyor..."
  TRANSLATIONS["tr,bls_generation_success"]="✅ BLS anahtarları başarıyla oluşturuldu"
  TRANSLATIONS["tr,bls_public_save_attention"]="⚠️ DİKKAT: Yukarıdaki hesap bilgilerini (beyaz metin) kopyalayın ve kaydedin, bunlar gelecekte ihtiyaç duyabileceğiniz eth adreslerini ve genel bls anahtarlarını içerir."
  TRANSLATIONS["tr,bls_generation_failed"]="❌ BLS anahtarları oluşturulamadı"
  TRANSLATIONS["tr,bls_searching_matches"]="🔍 Keystore'da eşleşen adresler aranıyor..."
  TRANSLATIONS["tr,bls_matches_found"]="✅ %d eşleşen adres bulundu"
  TRANSLATIONS["tr,bls_no_matches"]="❌ Keystore.json dosyasında eşleşen adres bulunamadı"
  TRANSLATIONS["tr,bls_filtered_file_created"]="✅ Filtrelenmiş BLS anahtarları şuraya kaydedildi: %s"
  TRANSLATIONS["tr,bls_file_not_found"]="❌ Oluşturulan BLS dosyası bulunamadı"
  TRANSLATIONS["tr,staking_title"]="Validator Staking"
  TRANSLATIONS["tr,staking_no_validators"]="Validator bulunamadı"
  TRANSLATIONS["tr,staking_found_validators"]="%d validator bulundu"
  TRANSLATIONS["tr,staking_processing"]="Validator %d/%d işleniyor"
  TRANSLATIONS["tr,staking_data_loaded"]="Validator verileri yüklendi"
  TRANSLATIONS["tr,staking_trying_rpc"]="RPC deneniyor: %s"
  TRANSLATIONS["tr,staking_command_prompt"]="Bu komutu çalıştırmak istiyor musunuz?"
  TRANSLATIONS["tr,staking_execute_prompt"]="Devam etmek için 'y', bu validatoru atlamak için 's', çıkmak için 'q' girin"
  TRANSLATIONS["tr,staking_executing"]="Komut çalıştırılıyor..."
  TRANSLATIONS["tr,staking_success"]="Validator %d başarıyla stake edildi, RPC: %s"
  TRANSLATIONS["tr,staking_failed"]="Validator %d stake edilemedi, RPC: %s"
  TRANSLATIONS["tr,staking_skipped_validator"]="Validator %d atlanıyor"
  TRANSLATIONS["tr,staking_cancelled"]="İşlem kullanıcı tarafından iptal edildi"
  TRANSLATIONS["tr,staking_skipped_rpc"]="Bu RPC sağlayıcısı atlanıyor"
  TRANSLATIONS["tr,staking_all_failed"]="Validator %d tüm RPC sağlayıcıları ile stake edilemedi"
  TRANSLATIONS["tr,staking_completed"]="Staking işlemi tamamlandı"
  TRANSLATIONS["tr,file_not_found"]="%s, %s konumunda bulunamadı"
  TRANSLATIONS["tr,contract_not_set"]="CONTRACT_ADDRESS ayarlanmamış"
  TRANSLATIONS["tr,using_contract_address"]="Kontrat adresi kullanılıyor: %s"
  TRANSLATIONS["tr,staking_failed_private_key"]="%d. doğrulayıcı için özel anahtar alınamadı"
  TRANSLATIONS["tr,staking_failed_eth_address"]="%d. doğrulayıcı için ETH adresi alınamadı"
  TRANSLATIONS["tr,staking_failed_bls_key"]="%d. doğrulayıcı için BLS özel anahtarı alınamadı"
  TRANSLATIONS["tr,eth_address"]="ETH Adresi"
  TRANSLATIONS["tr,private_key"]="Özel Anahtar"
  TRANSLATIONS["tr,bls_key"]="BLS Anahtarı"
  TRANSLATIONS["tr,bls_method_existing"]="Mevcut adresleri kullanarak üret (yalnızca tüm doğrulayıcı adresleri aynı başlangıç ​​ifadesinden geliyorsa, anımsatıcıdan)"
  TRANSLATIONS["tr,bls_method_new_operator"]="Yeni operatör adresi oluştur (tavsiye edilen)"
  TRANSLATIONS["tr,bls_method_prompt"]="Yöntem seçin (1/2): "
  TRANSLATIONS["tr,bls_invalid_method"]="Geçersiz yöntem seçildi"
  TRANSLATIONS["tr,bls_existing_method_title"]="Mevcut Adres Yöntemi"
  TRANSLATIONS["tr,bls_new_operator_title"]="Yeni Operatör Adresi Yöntemi"
  TRANSLATIONS["tr,bls_old_validator_info"]="Lütfen eski validatör bilgilerinizi sağlayın:"
  TRANSLATIONS["tr,bls_old_private_key_prompt"]="Bir veya daha fazla ESKİ özel anahtarı, aralarında boşluk olmadan virgülle ayırarak kopyalayıp yapıştırın ve Enter'a basın (giriş gizlidir, ancak yapıştırılır): "
  TRANSLATIONS["tr,bls_sepolia_rpc_prompt"]="Sepolia RPC URL'nizi girin: "
  TRANSLATIONS["tr,bls_starting_generation"]="Oluşturma süreci başlatılıyor..."
  TRANSLATIONS["tr,bls_ready_to_generate"]="⚠️ DİKKAT: Yeni operatörün tüm bilgilerini yazmaya HAZIR OLUN: anımsatıcı ifade, genel adres ve genel BLS anahtarı. Özel anahtar ve özel BLS anahtarı $HOME/aztec/bls-filtered-pk.json dosyasına kaydedilecektir."
  TRANSLATIONS["tr,bls_press_enter_to_generate"]="Yeni anahtarlarınızı oluşturmak için [Enter] tuşuna basın..."
  TRANSLATIONS["tr,bls_add_to_keystore_title"]="Keystore'a BLS Anahtarları Ekleme"
  TRANSLATIONS["tr,bls_pk_file_not_found"]="BLS anahtar dosyası bulunamadı: $HOME/aztec/bls-filtered-pk.json"
  TRANSLATIONS["tr,bls_keystore_not_found"]="Keystore dosyası bulunamadı: $HOME/aztec/config/keystore.json"
  TRANSLATIONS["tr,bls_creating_backup"]="keystore.json yedekleniyor..."
  TRANSLATIONS["tr,bls_backup_created"]="Yedek oluşturuldu"
  TRANSLATIONS["tr,bls_processing_validators"]="Validatörler işleniyor"
  TRANSLATIONS["tr,bls_reading_bls_keys"]="Filtrelenmiş dosyadan BLS anahtarları okunuyor..."
  TRANSLATIONS["tr,bls_mapped_address"]="Adres BLS anahtarıyla eşleştirildi"
  TRANSLATIONS["tr,bls_failed_generate_address"]="Özel anahtardan adres oluşturulamadı"
  TRANSLATIONS["tr,bls_no_valid_mappings"]="Geçerli adres-BLS anahtarı eşlemesi bulunamadı"
  TRANSLATIONS["tr,bls_total_mappings"]="Toplam adres eşlemesi bulundu"
  TRANSLATIONS["tr,bls_updating_keystore"]="Keystore BLS anahtarlarıyla güncelleniyor..."
  TRANSLATIONS["tr,bls_key_added"]="Adres için BLS anahtarı eklendi"
  TRANSLATIONS["tr,bls_no_key_for_address"]="Adres için BLS anahtarı bulunamadı"
  TRANSLATIONS["tr,bls_no_matches_found"]="BLS anahtarları ve keystore arasında eşleşen adres bulunamadı"
  TRANSLATIONS["tr,bls_keystore_updated"]="Keystore BLS anahtarlarıyla başarıyla güncellendi"
  TRANSLATIONS["tr,bls_total_updated"]="Validatör güncellendi"
  TRANSLATIONS["tr,bls_updated_structure_sample"]="Güncellenmiş validatör yapısı örneği"
  TRANSLATIONS["tr,bls_invalid_json"]="Geçersiz JSON oluşturuldu, yedekten geri yükleniyor"
  TRANSLATIONS["tr,bls_restoring_backup"]="Orijinal keystore yedekten geri yükleniyor"
  TRANSLATIONS["tr,bls_operation_completed"]="BLS anahtarı ekleme işlemi başarıyla tamamlandı"
  TRANSLATIONS["tr,bls_to_keystore"]="BLS anahtarlarını keystore.json dosyasına ekleyin (yalnızca BLS oluşturulduktan sonra ve yalnızca BLS bir başlangıç ​​ifadesinden oluşturulduysa veya bls-filtered-pk.json dosyasını kendiniz doğru bir şekilde oluşturduysanız çalıştırın)"
  TRANSLATIONS["tr,bls_new_keys_generated"]="Harika! Yeni anahtarlarınız aşağıdadır. BU BİLGİYİ GÜVENLİ BİR YERE KAYDEDİN!"
  TRANSLATIONS["tr,bls_new_eth_private_key"]="YENİ ETH Özel Anahtarı"
  TRANSLATIONS["tr,bls_new_bls_private_key"]="YENİ BLS Özel Anahtarı"
  TRANSLATIONS["tr,bls_new_public_address"]="YENİ Genel Adres"
  TRANSLATIONS["tr,bls_funding_required"]="Bu yeni adrese 0.1 ila 0.3 Sepolia ETH göndermeniz gerekiyor:"
  TRANSLATIONS["tr,bls_funding_confirmation"]="Fonlama işlemi onaylandıktan sonra devam etmek için [Enter] tuşuna basın..."
  TRANSLATIONS["tr,bls_approving_stake"]="STAKE harcaması onaylanıyor..."
  TRANSLATIONS["tr,bls_approve_failed"]="Onay işlemi başarısız oldu"
  TRANSLATIONS["tr,bls_joining_testnet"]="Test ağına katılıyor..."
  TRANSLATIONS["tr,bls_staking_failed"]="Staking başarısız oldu"
  TRANSLATIONS["tr,staking_yml_file_created"]="YML anahtar dosyası oluşturuldu:"
  TRANSLATIONS["tr,staking_yml_file_failed"]="YML anahtar dosyası oluşturulamadı:"
  TRANSLATIONS["tr,staking_total_yml_files_created"]="Toplam oluşturulan YML anahtar dosyası:"
  TRANSLATIONS["tr,staking_yml_files_location"]="Anahtar dosyalarının konumu:"
  TRANSLATIONS["tr,bls_new_operator_success"]="Hepsi tamam! Yeni test ağına başarıyla katıldınız"
  TRANSLATIONS["tr,bls_restart_node_notice"]="Şimdi düğümünüzü yeniden başlatın, yeni özel anahtarlara sahip YML dosyalarının /aztec/keys'e eklendiğini ve /aztec/config/keystore.json'un doğrulayıcıların yeni eth adresleriyle değiştirildiğini kontrol edin."
  TRANSLATIONS["tr,bls_key_extraction_failed"]="Oluşturulan dosyadan anahtarlar çıkarılamadı"
  TRANSLATIONS["tr,staking_run_bls_generation_first"]="Lütfen önce BLS anahtarı oluşturmayı çalıştırın (seçenek 18)"
  TRANSLATIONS["tr,staking_invalid_bls_file"]="Geçersiz BLS anahtar dosyası formatı"
  TRANSLATIONS["tr,staking_failed_generate_address"]="Özel anahtardan adres oluşturulamadı"
  TRANSLATIONS["tr,staking_found_single_validator"]="Yeni operatör yöntemi için tek validatör bulundu"
  TRANSLATIONS["tr,staking_old_sequencer_prompt"]="Yeni operatör yöntemiyle staking için, eski sequencer özel anahtarınıza ihtiyacımız var:"
  TRANSLATIONS["tr,staking_old_private_key_prompt"]="ESKİ Sequencer Özel Anahtarını girin (gizli): "
  TRANSLATIONS["tr,staking_success_single"]="Yeni operatör yöntemiyle validatör başarıyla stake edildi"
  TRANSLATIONS["tr,staking_failed_single"]="Yeni operatör yöntemiyle validatör stake edilemedi"
  TRANSLATIONS["tr,staking_all_failed_single"]="Yeni operatör staking için tüm RPC sağlayıcıları başarısız oldu"
  TRANSLATIONS["tr,staking_skipped"]="Staking atlandı"
  TRANSLATIONS["tr,staking_keystore_backup_created"]="Keystore yedegi olusturuldu:"
  TRANSLATIONS["tr,staking_updating_keystore"]="Keystore.json güncelleniyor - eski validatör adresi yeni operatör adresiyle değiştiriliyor"
  TRANSLATIONS["tr,staking_keystore_updated"]="Keystore başarıyla güncellendi:"
  TRANSLATIONS["tr,staking_keystore_no_change"]="Keystore'da değişiklik yapılmadı (adres bulunamadı):"
  TRANSLATIONS["tr,staking_keystore_update_failed"]="Keystore.json güncellenemedi"
  TRANSLATIONS["tr,staking_keystore_skip_update"]="Keystore güncellemesi atlandı (eski adres mevcut değil)"
  TRANSLATIONS["tr,bls_no_private_keys"]="Özel anahtar sağlanmadı"
  TRANSLATIONS["tr,bls_found_private_keys"]="Bulunan özel anahtarlar:"
  TRANSLATIONS["tr,bls_keys_saved_success"]="BLS anahtarları başarıyla oluşturuldu ve kaydedildi"
  TRANSLATIONS["tr,bls_next_steps"]="Sonraki adımlar:"
  TRANSLATIONS["tr,bls_send_eth_step"]="Yukarıdaki adrese 0.1-0.3 Sepolia ETH gönderin"
  TRANSLATIONS["tr,bls_run_approve_step"]="Stake harcamasını onaylamak için seçenek 19'u (Approve) çalıştırın"
  TRANSLATIONS["tr,bls_run_stake_step"]="Validator staking'i tamamlamak için seçenek 20'yi (Stake) çalıştırın"
  TRANSLATIONS["tr,staking_missing_new_operator_info"]="BLS dosyasında yeni operatör bilgisi eksik"
  TRANSLATIONS["tr,staking_found_validators_new_operator"]="Yeni operatör yöntemi için validatörler bulundu:"
  TRANSLATIONS["tr,staking_processing_new_operator"]="Validatör %s/%s işleniyor (yeni operatör yöntemi)"
  TRANSLATIONS["tr,staking_success_new_operator"]="Validatör %s, yeni operatör yöntemiyle %s kullanılarak başarıyla stake edildi"
  TRANSLATIONS["tr,validator_link"]="Validator bağlantısı"
  TRANSLATIONS["tr,staking_failed_new_operator"]="Validatör %s, yeni operatör yöntemiyle %s kullanılarak stake edilemedi"
  TRANSLATIONS["tr,staking_all_failed_new_operator"]="Validatör %s için tüm RPC sağlayıcıları yeni operatör yöntemiyle başarısız oldu"
  TRANSLATIONS["tr,staking_completed_new_operator"]="Yeni operatör staking tamamlandı!"
  TRANSLATIONS["tr,command_to_execute"]="Yürütülecek komut"
  TRANSLATIONS["tr,trying_next_rpc"]="Sonraki RPC sağlayıcı deneniyor..."
  TRANSLATIONS["tr,continuing_next_validator"]="Sonraki doğrulayıcıya devam ediliyor..."
  TRANSLATIONS["tr,waiting_before_next_validator"]="Sonraki doğrulayıcıdan önce 2 saniye bekleniyor"
  TRANSLATIONS["tr,rpc_change_prompt"]="Yeni RPC URL'sini girin:"
  TRANSLATIONS["tr,rpc_change_success"]="✅ RPC URL başarıyla güncellendi"
  TRANSLATIONS["tr,choose_option"]="Seçenek seçin:"
  TRANSLATIONS["tr,checking_deps"]="🔍 Gerekli bileşenler kontrol ediliyor:"
  TRANSLATIONS["tr,missing_tools"]="Gerekli bileşenler eksik:"
  TRANSLATIONS["tr,install_prompt"]="Şimdi yüklemek istiyor musunuz? (Y/n):"
  TRANSLATIONS["tr,missing_required"]="⚠️ Betik, gerekli bileşenler olmadan çalışamaz. Çıkılıyor."
  TRANSLATIONS["tr,rpc_prompt"]="Ethereum RPC URL'sini girin:"
  TRANSLATIONS["tr,network_prompt"]="Ağ türünü girin (örneğin testnet veya mainnet):"
  TRANSLATIONS["tr,env_created"]="✅ RPC URL'si ile .env dosyası oluşturuldu"
  TRANSLATIONS["tr,env_exists"]="✅ Mevcut .env dosyası kullanılıyor, RPC URL:"
  TRANSLATIONS["tr,rpc_empty_error"]="RPC URL boş olamaz. Lütfen geçerli bir URL girin."
  TRANSLATIONS["tr,network_empty_error"]="Ağ adı boş olamaz. Lütfen bir ağ adı girin."
  TRANSLATIONS["tr,search_container"]="🔍 'aztec' konteyneri aranıyor..."
  TRANSLATIONS["tr,container_not_found"]="❌ 'aztec' konteyneri bulunamadı."
  TRANSLATIONS["tr,container_found"]="✅ Konteyner bulundu:"
  TRANSLATIONS["tr,get_block"]="🔗 Kontraktan mevcut blok alınıyor..."
  TRANSLATIONS["tr,block_error"]="❌ Hata: Blok numarası alınamadı. RPC veya kontratı kontrol edin."
  TRANSLATIONS["tr,current_block"]="📦 Mevcut blok numarası:"
  TRANSLATIONS["tr,node_ok"]="✅ Düğüm çalışıyor ve mevcut bloğu işliyor"
  TRANSLATIONS["tr,node_behind"]="⚠️ Mevcut blok loglarda bulunamadı. Düğüm geride olabilir."
  TRANSLATIONS["tr,search_rollup"]="🔍 'aztec' konteyner loglarında rollupAddress aranıyor..."
  TRANSLATIONS["tr,rollup_found"]="✅ Mevcut rollupAddress:"
  TRANSLATIONS["tr,rollup_not_found"]="❌ Loglarda rollupAddress bulunamadı."
  TRANSLATIONS["tr,search_peer"]="🔍 'aztec' konteyner loglarında PeerID aranıyor..."
  TRANSLATIONS["tr,peer_not_found"]="❌ Loglarda PeerID bulunamadı."
  TRANSLATIONS["tr,search_gov"]="🔍 'aztec' konteyner loglarında governanceProposerPayload aranıyor..."
  TRANSLATIONS["tr,gov_found"]="Bulunan governanceProposerPayload değerleri:"
  TRANSLATIONS["tr,gov_not_found"]="❌ governanceProposerPayload bulunamadı."
  TRANSLATIONS["tr,gov_changed"]="🛑 GovernanceProposerPayload değişikliği tespit edildi!"
  TRANSLATIONS["tr,gov_was"]="⚠️ Önceki:"
  TRANSLATIONS["tr,gov_now"]="Şimdi:"
  TRANSLATIONS["tr,gov_no_changes"]="✅ Değişiklik tespit edilmedi."
  TRANSLATIONS["tr,token_prompt"]="Telegram Bot Token'ını girin:"
  TRANSLATIONS["tr,chatid_prompt"]="Telegram Chat ID'yi girin:"
  TRANSLATIONS["tr,agent_added"]="✅ Aracı systemd'a eklendi ve her dakika çalışacak."
  TRANSLATIONS["tr,agent_exists"]="ℹ️ Aracı zaten systemd'da mevcut."
  TRANSLATIONS["tr,removing_agent"]="🗑 Aracı ve systemd görevi kaldırılıyor..."
  TRANSLATIONS["tr,agent_removed"]="✅ Aracı ve systemd görevi kaldırıldı."
  TRANSLATIONS["tr,goodbye"]="👋 Güle güle."
  TRANSLATIONS["tr,invalid_choice"]="❌ Geçersiz seçim. Tekrar deneyin."
  TRANSLATIONS["tr,searching"]="Aranıyor..."
  TRANSLATIONS["tr,get_proven_block"]="🔍 Kanıtlanmış L2 blok numarası alınıyor..."
  TRANSLATIONS["tr,proven_block_found"]="✅ Kanıtlanmış L2 Blok Numarası:"
  TRANSLATIONS["tr,proven_block_error"]="❌ Kanıtlanmış L2 blok numarası alınamadı."
  TRANSLATIONS["tr,get_sync_proof"]="🔍 Sync Proof alınıyor..."
  TRANSLATIONS["tr,sync_proof_found"]="✅ Sync Proof:"
  TRANSLATIONS["tr,sync_proof_error"]="❌ Sync Proof alınamadı."
  TRANSLATIONS["tr,token_check"]="🔍 Telegram token ve ChatID kontrol ediliyor..."
  TRANSLATIONS["tr,token_valid"]="✅ Telegram token geçerli"
  TRANSLATIONS["tr,token_invalid"]="❌ Geçersiz Telegram token"
  TRANSLATIONS["tr,chatid_valid"]="✅ ChatID geçerli ve bota erişim var"
  TRANSLATIONS["tr,chatid_invalid"]="❌ Geçersiz ChatID veya bota erişim yok"
  TRANSLATIONS["tr,agent_created"]="✅ Aracı başarıyla oluşturuldu ve yapılandırıldı!"
  TRANSLATIONS["tr,running_validator_script"]="Check Validator betiği yerel olarak çalıştırılıyor..."
  TRANSLATIONS["tr,failed_run_validator"]="Check Validator betiği çalıştırılamadı."
  TRANSLATIONS["tr,enter_aztec_port_prompt"]="Aztec düğüm port numarasını girin"
  TRANSLATIONS["tr,port_saved_successfully"]="✅ Port başarıyla kaydedildi"
  TRANSLATIONS["tr,checking_port"]="Port kontrol ediliyor"
  TRANSLATIONS["tr,port_not_available"]="Aztec portu şurada mevcut değil:"
  TRANSLATIONS["tr,current_aztec_port"]="Mevcut Aztec düğüm portu:"
  TRANSLATIONS["tr,log_block_not_found"]="❌ Loglarda 'Downloaded L2 block' içeren satır bulunamadı."
  TRANSLATIONS["tr,log_block_extract_failed"]="❌ Blok numarası satırdan çıkarılamadı:"
  TRANSLATIONS["tr,log_block_number"]="📄 Loglardaki son blok:"
  TRANSLATIONS["tr,log_behind_details"]="⚠️ Loglar geride. Loglardaki son blok: %s, kontraktaki: %s"
  TRANSLATIONS["tr,log_line_example"]="🔎 Örnek log satırı:"
  TRANSLATIONS["tr,press_ctrlc"]="Menüye dönmek için Ctrl+C'ye basın"
  TRANSLATIONS["tr,logs_starting"]="Loglar 5 saniye içinde başlayacak..."
  TRANSLATIONS["tr,return_main_menu"]="Ana menüye dönülüyor..."
  TRANSLATIONS["tr,current_script_version"]="📌 Mevcut betik versiyonu:"
  TRANSLATIONS["tr,new_version_avialable"]="🚀 Yeni versiyon mevcut:"
  TRANSLATIONS["tr,new_version_update"]="Lütfen betiğinizi güncelleyin"
  TRANSLATIONS["tr,version_up_to_date"]="✅ En son versiyonu kullanıyorsunuz"
  TRANSLATIONS["tr,agent_log_cleaned"]="✅ Log dosyası temizlendi."
  TRANSLATIONS["tr,agent_container_not_found"]="❌ Aztec Konteyneri Bulunamadı"
  TRANSLATIONS["tr,agent_block_fetch_error"]="❌ Blok Alma Hatası"
  TRANSLATIONS["tr,agent_no_block_in_logs"]="❌ Düğüm günlüklerinde blok numarası bulunamadı"
  TRANSLATIONS["tr,agent_failed_extract_block"]="❌ Blok numarası çıkarılamadı"
  TRANSLATIONS["tr,agent_node_behind"]="⚠️ Düğüm %d blok geride"
  TRANSLATIONS["tr,agent_started"]="🤖 Aztec İzleme Aracı Başlatıldı"
  TRANSLATIONS["tr,agent_log_size_warning"]="⚠️ Boyut sınırı nedeniyle log dosyası temizlendi"
  TRANSLATIONS["tr,agent_server_info"]="🌐 Sunucu: %s"
  TRANSLATIONS["tr,agent_file_info"]="🗃 Dosya: %s"
  TRANSLATIONS["tr,agent_size_info"]="📏 Önceki boyut: %s bayt"
  TRANSLATIONS["tr,agent_rpc_info"]="🔗 RPC: %s"
  TRANSLATIONS["tr,agent_error_info"]="💬 Hata: %s"
  TRANSLATIONS["tr,agent_block_info"]="📦 Kontrakt blok: %s"
  TRANSLATIONS["tr,agent_log_block_info"]="📝 Log blok: %s"
  TRANSLATIONS["tr,agent_time_info"]="🕒 %s"
  TRANSLATIONS["tr,agent_line_info"]="📋 Satır: %s"
  TRANSLATIONS["tr,agent_notifications_info"]="ℹ️ Sorunlar için bildirimler gönderilecek"
  TRANSLATIONS["tr,agent_node_synced"]="✅ Düğüm senkronize (blok %s)"
  TRANSLATIONS["tr,chatid_linked"]="✅ ChatID başarıyla Aztec Aracı'na bağlandı"
  TRANSLATIONS["tr,invalid_token"]="Geçersiz Telegram bot tokenı. Lütfen tekrar deneyin."
  TRANSLATIONS["tr,token_format"]="Token formatı: 1234567890:ABCdefGHIJKlmNoPQRsTUVwxyZ"
  TRANSLATIONS["tr,invalid_chatid"]="Geçersiz Telegram chat ID veya botun bu sohbete erişimi yok. Lütfen tekrar deneyin."
  TRANSLATIONS["tr,chatid_number"]="Chat ID bir sayı olmalıdır (grup sohbetleri için - ile başlayabilir). Lütfen tekrar deneyin."
  TRANSLATIONS["tr,running_install_node"]="GitHub'dan Aztec node kurulum betiği çalıştırılıyor..."
  TRANSLATIONS["tr,failed_running_install_node"]="GitHub'dan Aztec düğüm yükleme betiği çalıştırılamadı..."
  TRANSLATIONS["tr,failed_downloading_script"]="❌ Kurulum betiği indirilemedi"
  TRANSLATIONS["tr,install_completed_successfully"]="✅ Kurulum başarıyla tamamlandı"
  TRANSLATIONS["tr,logs_stopped_by_user"]="⚠ Log görüntüleme kullanıcı tarafından durduruldu"
  TRANSLATIONS["tr,installation_cancelled_by_user"]="✖ Kurulum kullanıcı tarafından iptal edildi"
  TRANSLATIONS["tr,unknown_error_occurred"]="⚠ Kurulum sırasında bilinmeyen bir hata oluştu"
  TRANSLATIONS["tr,stop_method_prompt"]="Aztec düğümünü durdurma yöntemi seçin (docker-compose / cli): "
  TRANSLATIONS["tr,enter_compose_path"]="docker-compose.yml dosyasının bulunduğu klasörün tam yolunu girin  ($HOME/your_path veya ./your_path): "
  TRANSLATIONS["tr,docker_stop_success"]="Konteynerler durduruldu ve yol .env-aztec-agent dosyasına kaydedildi"
  TRANSLATIONS["tr,no_aztec_screen"]="Aktif Aztec screen oturumu bulunamadı."
  TRANSLATIONS["tr,cli_stop_success"]="Aztec CLI düğümü durduruldu ve oturum .env-aztec-agent dosyasına kaydedildi"
  TRANSLATIONS["tr,invalid_path"]="Geçersiz yol veya docker-compose.yml dosyası bulunamadı."
  TRANSLATIONS["tr,starting_node"]="Aztec düğümü başlatılıyor..."
  TRANSLATIONS["tr,node_started"]="Aztec düğümü başlatıldı."
  TRANSLATIONS["tr,missing_compose"]="docker-compose.yml yolu .env-aztec-agent dosyasında bulunamadı."
  TRANSLATIONS["tr,run_type_not_set"]="Yapılandırmada RUN_TYPE ayarlanmamış."
  TRANSLATIONS["tr,confirm_cli_run"]="Kapsayıcıyı CLI modunda çalıştırmak istiyor musunuz?"
  TRANSLATIONS["tr,run_type_set_to_cli"]="RUN_TYPE CLI olarak ayarlandı."
  TRANSLATIONS["tr,run_aborted"]="Çalıştırma kullanıcı tarafından iptal edildi."
  TRANSLATIONS["tr,checking_aztec_version"]="Aztec sürümü kontrol ediliyor..."
  TRANSLATIONS["tr,aztec_version_failed"]="Aztec sürümü alınamadı."
  TRANSLATIONS["tr,aztec_node_version"]="Aztec Node sürümü:"
  TRANSLATIONS["tr,critical_error_found"]="🚨 Kritik hata tespit edildi"
  TRANSLATIONS["tr,error_prefix"]="HATA:"
  TRANSLATIONS["tr,solution_prefix"]="Çözüm:"
  TRANSLATIONS["tr,notifications_prompt"]="Ek bildirim almak istiyor musunuz?"
  TRANSLATIONS["tr,notifications_option1"]="1. Sadece kritik hatalar"
  TRANSLATIONS["tr,notifications_option2"]="2. Tüm bildirimler (komite katılımı ve doğrulayıcı etkinliği dahil)"
  TRANSLATIONS["tr,notifications_debug_warning"]="Komite ve slot istatistik bildirimleri için DEBUG günlük seviyesi gereklidir"
  TRANSLATIONS["tr,notifications_input_error"]="Hata: lütfen 1 veya 2 girin"
  TRANSLATIONS["tr,choose_option_prompt"]="Seçenek belirleyin"
  TRANSLATIONS["tr,committee_selected"]="🎉 Komiteye seçildiniz"
  TRANSLATIONS["tr,found_validators"]="Komitede bulunan doğrulayıcılar: %s"
  TRANSLATIONS["tr,epoch_info"]="Dönem %s"
  TRANSLATIONS["tr,block_built"]="✅ %s bloğu başarıyla oluşturuldu"
  TRANSLATIONS["tr,slot_info"]="Slot %s"
  TRANSLATIONS["tr,validators_prompt"]="Validator adreslerinizi girin (virgülle ayırarak, boşluk olmadan):"
  TRANSLATIONS["tr,validators_format"]="Örnek: 0x123...,0x456...,0x789..."
  TRANSLATIONS["tr,validators_empty"]="Hata: Validator listesi boş olamaz"
  TRANSLATIONS["tr,status_legend"]="Durum Açıklaması:"
  TRANSLATIONS["tr,status_empty"]="⬜️ Boş slot"
  TRANSLATIONS["tr,status_attestation_sent"]="🟩 Doğrulama gönderildi"
  TRANSLATIONS["tr,status_attestation_missed"]="🟥 Doğrulama kaçırıldı"
  TRANSLATIONS["tr,status_block_mined"]="🟦 Blok çıkarıldı"
  TRANSLATIONS["tr,status_block_missed"]="🟨 Blok kaçırıldı"
  TRANSLATIONS["tr,status_block_proposed"]="🟪 Blok önerildi"
  TRANSLATIONS["tr,publisher_monitoring_title"]="=== Publisher Bakiye İzleme ==="
  TRANSLATIONS["tr,publisher_monitoring_option1"]="1. Adresleri ekleyin ve bakiye izlemeyi başlatın"
  TRANSLATIONS["tr,publisher_monitoring_option2"]="2. Minimum bakiye eşiğini yapılandır"
  TRANSLATIONS["tr,publisher_monitoring_option3"]="3. Bakiye izlemeyi durdur"
  TRANSLATIONS["tr,publisher_monitoring_choose"]="Seçenek seçin (1/2/3):"
  TRANSLATIONS["tr,publisher_addresses_prompt"]="Bakiye izleme için publisher adreslerini girin (virgülle ayırarak, boşluk olmadan):"
  TRANSLATIONS["tr,publisher_addresses_format"]="Örnek: 0x123...,0x456...,0x789..."
  TRANSLATIONS["tr,publisher_addresses_empty"]="Hata: Publisher adres listesi boş olamaz"
  TRANSLATIONS["tr,publisher_min_balance_prompt"]="Bildirim için minimum bakiye eşiğini girin (varsayılan: 0.15 ETH):"
  TRANSLATIONS["tr,publisher_min_balance_invalid"]="Hata: Geçersiz bakiye değeri. Lütfen pozitif bir sayı girin."
  TRANSLATIONS["tr,publisher_monitoring_enabled"]="Publisher bakiye izleme etkinleştirildi"
  TRANSLATIONS["tr,publisher_monitoring_disabled"]="Publisher bakiye izleme devre dışı bırakıldı"
  TRANSLATIONS["tr,publisher_balance_warning"]="⚠️ Publisher adreslerinde düşük bakiye tespit edildi"
  TRANSLATIONS["tr,publisher_balance_address"]="Adres: %s, Bakiye: %s ETH"
  TRANSLATIONS["tr,current_slot"]="Mevcut slot: %s"
  TRANSLATIONS["tr,agent_notifications_full_info"]="ℹ️ Sorunlar, komite ve slot istatistikleri için bildirimler gönderilecektir"
  TRANSLATIONS["tr,attestation_status"]="ℹ️ Slot istatistik"
  #peerID
  TRANSLATIONS["tr,fetching_peer_info"]="API'den eş (peer) bilgisi alınıyor..."
  TRANSLATIONS["tr,peer_found"]="Loglarda Peer ID bulundu"
  TRANSLATIONS["tr,peer_not_in_list"]="Eş, genel listede bulunamadı"
  TRANSLATIONS["tr,peer_id_not_critical"]="Nethermind.io'da Peer ID'nin olup olmaması kritik bir parametre değildir. Veriler güncel olmayabilir."
  TRANSLATIONS["tr,searching_latest"]="Güncel verilerde aranıyor..."
  TRANSLATIONS["tr,searching_archive"]="Arşiv verilerinde aranıyor..."
  TRANSLATIONS["tr,peer_found_archive"]="Not: Bu eş (peer) arşiv verilerinde bulundu"
  #
  TRANSLATIONS["tr,cli_quit_old_sessions"]="Eski oturum kapatıldı:"
  # install section
  TRANSLATIONS["tr,delete_node"]="🗑️ Aztec Node siliniyor..."
  TRANSLATIONS["tr,delete_confirm"]="Aztec node'u silmek istediğinize emin misiniz? Bu işlem konteynerleri durduracak ve tüm verileri silecektir. (y/n) "
  TRANSLATIONS["tr,node_deleted"]="✅ Aztec node başarıyla silindi"
  TRANSLATIONS["tr,delete_canceled"]="✖ Node silme işlemi iptal edildi"
  TRANSLATIONS["tr,delete_watchtower_confirm"]="Watchtower'ı da silmek istiyor musunuz? (y/n) "
  TRANSLATIONS["tr,watchtower_deleted"]="✅ Watchtower başarıyla silindi"
  TRANSLATIONS["tr,watchtower_kept"]="✅ Watchtower korundu"
  TRANSLATIONS["tr,enter_tg_token"]="Telegram bot tokenini girin: "
  TRANSLATIONS["tr,enter_tg_chat_id"]="Telegram chat ID'sini girin: "
  TRANSLATIONS["tr,single_validator_mode"]="🔹 Tek validatör modu seçildi"
  TRANSLATIONS["tr,multi_validator_mode"]="🔹 Çoklu validatör modu seçildi"
  TRANSLATIONS["tr,enter_validator_keys"]="Validatör özel anahtarlarını girin (0x ile virgülle ayrılmış, en fazla 10): "
  TRANSLATIONS["tr,enter_validator_key"]="Validatör özel anahtar girin (0x ile): "
  TRANSLATIONS["tr,enter_seq_publisher_key"]="SEQ_PUBLISHER_PRIVATE_KEY girin (0x ile): "
  TRANSLATIONS["tr,enter_yn"]="Lütfen Y veya N girin: "
  TRANSLATIONS["tr,stopping_containers"]="Konteynerler durduruluyor..."
  TRANSLATIONS["tr,removing_node_data"]="Aztec node verileri kaldırılıyor..."
  TRANSLATIONS["tr,stopping_watchtower"]="Watchtower durduruluyor..."
  TRANSLATIONS["tr,removing_watchtower_data"]="Watchtower verileri kaldırılıyor..."
  # Güncelleme
  TRANSLATIONS["tr,update_title"]="Aztec düğümü en son sürüme güncelleniyor"
  TRANSLATIONS["tr,update_folder_error"]="Hata: $HOME/aztec klasörü mevcut değil"
  TRANSLATIONS["tr,update_stopping"]="Kapsayıcılar durduruluyor..."
  TRANSLATIONS["tr,update_stop_error"]="Kapsayıcılar durdurulurken hata oluştu"
  TRANSLATIONS["tr,update_pulling"]="Son aztecprotocol/aztec imajı çekiliyor..."
  TRANSLATIONS["tr,update_pull_error"]="İmaj çekilirken hata oluştu"
  TRANSLATIONS["tr,update_starting"]="Güncellenmiş düğüm başlatılıyor..."
  TRANSLATIONS["tr,update_start_error"]="Kapsayıcılar başlatılırken hata oluştu"
  TRANSLATIONS["tr,update_success"]="Aztec düğümü başarıyla en son sürüme güncellendi!"
  TRANSLATIONS["tr,tag_check"]="Etiket bulundu: %s, en son sürümle değiştiriliyor"
  # Sürüm düşürme
  TRANSLATIONS["tr,downgrade_title"]="Aztec düğümü sürüm düşürülüyor"
  TRANSLATIONS["tr,downgrade_fetching"]="Mevcut sürüm listesi alınıyor..."
  TRANSLATIONS["tr,downgrade_fetch_error"]="Sürüm listesi alınamadı"
  TRANSLATIONS["tr,downgrade_available"]="Mevcut sürümler (numarayı girin):"
  TRANSLATIONS["tr,downgrade_invalid_choice"]="Geçersiz seçim, lütfen tekrar deneyin"
  TRANSLATIONS["tr,downgrade_selected"]="Seçilen sürüm:"
  TRANSLATIONS["tr,downgrade_folder_error"]="Hata: $HOME/aztec klasörü mevcut değil"
  TRANSLATIONS["tr,downgrade_stopping"]="Kapsayıcılar durduruluyor..."
  TRANSLATIONS["tr,downgrade_stop_error"]="Kapsayıcılar durdurulurken hata oluştu"
  TRANSLATIONS["tr,downgrade_pulling"]="aztecprotocol/aztec imajı çekiliyor:"
  TRANSLATIONS["tr,downgrade_pull_error"]="İmaj çekilirken hata oluştu"
  TRANSLATIONS["tr,downgrade_updating"]="Yapılandırma güncelleniyor..."
  TRANSLATIONS["tr,downgrade_update_error"]="docker-compose.yml güncellenirken hata oluştu"
  TRANSLATIONS["tr,downgrade_starting"]="Düğüm şu sürümle başlatılıyor"
  TRANSLATIONS["tr,downgrade_start_error"]="Kapsayıcılar başlatılırken hata oluştu"
  TRANSLATIONS["tr,downgrade_success"]="Aztec düğümü başarıyla şu sürüme düşürüldü"
  #agent
  TRANSLATIONS["tr,agent_systemd_added"]="Aracı eklendi (systemd ile her 37 saniyede bir çalışıyor)"
  TRANSLATIONS["tr,agent_timer_status"]="Zamanlayıcı durumu:"
  TRANSLATIONS["tr,agent_timer_error"]="Systemd zamanlayıcı oluşturulurken hata oluştu"
  TRANSLATIONS["tr,removing_systemd_agent"]="Aracı ve systemd birimlerini kaldırılıyor..."
  TRANSLATIONS["tr,agent_systemd_removed"]="Aracı başarıyla kaldırıldı"
  #version module
  TRANSLATIONS["tr,update_changes"]="Güncellemedeki değişiklikler"
  TRANSLATIONS["tr,installed"]="kuruldu"
  TRANSLATIONS["tr,not_installed"]="kurulu değil"
  TRANSLATIONS["tr,install_curl_cffi_prompt"]="curl_cffi şimdi yüklensin mi? (Y/n)"
  TRANSLATIONS["tr,installing_curl_cffi"]="curl_cffi yükleniyor..."
  TRANSLATIONS["tr,curl_cffi_optional"]="curl_cffi kurulumu atlandı (isteğe bağlı)."

  # Translations from install_aztec.sh (Turkish)
  TRANSLATIONS["tr,installing_deps"]="🔧 Sistem bağımlılıkları yükleniyor..."
  TRANSLATIONS["tr,deps_installed"]="✅ Bağımlılıklar yüklendi"
  TRANSLATIONS["tr,checking_docker"]="🔍 Docker ve docker compose kontrol ediliyor..."
  TRANSLATIONS["tr,docker_not_found"]="❌ Docker yüklü değil"
  TRANSLATIONS["tr,docker_compose_not_found"]="❌ docker compose (v2+) bulunamadı"
  TRANSLATIONS["tr,install_docker_prompt"]="Docker yüklensin mi? (y/n) "
  TRANSLATIONS["tr,install_compose_prompt"]="Docker Compose yüklensin mi? (y/n) "
  TRANSLATIONS["tr,docker_required"]="❌ Scriptin çalışması için Docker gereklidir. Çıkılıyor."
  TRANSLATIONS["tr,compose_required"]="❌ Scriptin çalışması için Docker Compose gereklidir. Çıkılıyor."
  TRANSLATIONS["tr,installing_docker"]="Docker yükleniyor..."
  TRANSLATIONS["tr,installing_compose"]="Docker Compose yükleniyor..."
  TRANSLATIONS["tr,docker_installed"]="✅ Docker başarıyla yüklendi"
  TRANSLATIONS["tr,compose_installed"]="✅ Docker Compose başarıyla yüklendi"
  TRANSLATIONS["tr,docker_found"]="✅ Docker ve docker compose bulundu"
  TRANSLATIONS["tr,installing_aztec"]="⬇️ Aztec yükleniyor..."
  TRANSLATIONS["tr,aztec_not_installed"]="❌ Aztec yüklü değil. Kurulumu kontrol edin."
  TRANSLATIONS["tr,aztec_installed"]="✅ Aztec yüklendi"
  TRANSLATIONS["tr,running_aztec_up"]="🚀 aztec-up latest çalıştırılıyor..."
  TRANSLATIONS["tr,opening_ports"]="🌐 40400 ve 8080 portları açılıyor..."
  TRANSLATIONS["tr,ports_opened"]="✅ Portlar açıldı"
  TRANSLATIONS["tr,creating_folder"]="📁 ~/aztec klasörü oluşturuluyor..."
  TRANSLATIONS["tr,creating_env"]="📝 .env dosyası oluşturuluyor..."
  TRANSLATIONS["tr,env_created"]="✅ .env dosyası oluşturuldu"
  TRANSLATIONS["tr,creating_compose"]="🛠️ Watchtower ile docker-compose.yml oluşturuluyor"
  TRANSLATIONS["tr,compose_created"]="✅ docker-compose.yml oluşturuldu"
  TRANSLATIONS["tr,starting_node"]="🚀 Aztec node başlatılıyor..."
  TRANSLATIONS["tr,showing_logs"]="📄 Son 200 log satırı gösteriliyor..."
  TRANSLATIONS["tr,logs_starting"]="Loglar 5 saniye içinde başlayacak... Loglardan çıkmak için Ctrl+C'ye basın"
  TRANSLATIONS["tr,checking_ports"]="Portlar kontrol ediliyor..."
  TRANSLATIONS["tr,port_error"]="Hata: $port portu dolu. Program devam edemez."
  TRANSLATIONS["tr,ports_free"]="Tüm portlar boş! Kurulum şimdi başlayacak...\n"
  TRANSLATIONS["tr,ports_busy"]="Şu portlar dolu:"
  TRANSLATIONS["tr,change_ports_prompt"]="Portları değiştirmek ister misiniz? (y/n) "
  TRANSLATIONS["tr,enter_new_ports"]="Yeni port numaralarını girin:"
  TRANSLATIONS["tr,enter_http_port"]="HTTP portunu girin"
  TRANSLATIONS["tr,enter_p2p_port"]="P2P portunu girin"
  TRANSLATIONS["tr,installation_aborted"]="Kurulum kullanıcı tarafından iptal edildi"
  TRANSLATIONS["tr,checking_ports_desc"]="Başka süreçler tarafından kullanılmadığından emin olmak için portlar kontrol ediliyor..."
  TRANSLATIONS["tr,scanning_ports"]="Portlar taranıyor"
  TRANSLATIONS["tr,busy"]="meşgul"
  TRANSLATIONS["tr,free"]="boşta"
  TRANSLATIONS["tr,ports_free_success"]="Tüm portlar kullanıma hazır"
  TRANSLATIONS["tr,ports_busy_error"]="Bazı portlar zaten kullanımda"
  TRANSLATIONS["tr,enter_new_ports_prompt"]="Yeni port numaralarını girin"
  TRANSLATIONS["tr,ports_updated"]="Port numaraları güncellendi"
  TRANSLATIONS["tr,installing_ss"]="iproute2 yükleniyor (ss aracı içerir)..."
  TRANSLATIONS["tr,ss_installed"]="iproute2 başarıyla yüklendi"
  TRANSLATIONS["tr,delete_node"]="🗑️ Aztec Node siliniyor..."
  TRANSLATIONS["tr,delete_confirm"]="Aztec node'u silmek istediğinize emin misiniz? Bu işlem konteynerleri durduracak ve tüm verileri silecektir. (y/n) "
  TRANSLATIONS["tr,delete_canceled"]="✖ Node silme işlemi iptal edildi"
  TRANSLATIONS["tr,warn_orig_install"]="⚠️ Şu soru çıktığında 'n' yazın:"
  TRANSLATIONS["tr,warn_orig_install_2"]="Add it to $HOME/.bash_profile to make the aztec binaries accessible?"
  TRANSLATIONS["tr,watchtower_exists"]="✅ Watchtower zaten yüklü"
  TRANSLATIONS["tr,installing_watchtower"]="⬇️ Watchtower yükleniyor..."
  TRANSLATIONS["tr,creating_watchtower_compose"]="🛠️ Watchtower docker-compose.yml oluşturuluyor"
  TRANSLATIONS["tr,delete_watchtower_confirm"]="Watchtower'ı da silmek istiyor musunuz? (y/n) "
  TRANSLATIONS["tr,watchtower_deleted"]="✅ Watchtower başarıyla silindi"
  TRANSLATIONS["tr,watchtower_kept"]="✅ Watchtower korundu"
  TRANSLATIONS["tr,enter_tg_token"]="Telegram bot tokenini girin: "
  TRANSLATIONS["tr,enter_tg_chat_id"]="Telegram chat ID'sini girin: "
  TRANSLATIONS["tr,single_validator_mode"]="🔹 Tek validatör modu seçildi"
  TRANSLATIONS["tr,multi_validator_mode"]="🔹 Çoklu validatör modu seçildi"
  TRANSLATIONS["tr,enter_validator_keys"]="Validatör özel anahtarlarını girin (0x ile virgülle ayrılmış, en fazla 10): "
  TRANSLATIONS["tr,enter_validator_key"]="Validatör özel anahtar girin (0x ile): "
  TRANSLATIONS["tr,enter_seq_publisher_key"]="SEQ_PUBLISHER_PRIVATE_KEY girin (0x ile): "
  TRANSLATIONS["tr,validator_setup_header"]="=== Validator Kurulumu ==="
  TRANSLATIONS["tr,multiple_validators_prompt"]="Birden fazla validator çalıştırmak istiyor musunuz? (y/n) "
  TRANSLATIONS["tr,ufw_not_installed"]="⚠️ ufw yüklü değil"
  TRANSLATIONS["tr,ufw_not_active"]="⚠️ ufw aktif değil"
  TRANSLATIONS["tr,has_bls_keys"]="BLS anahtarlarınız var mı? (y/n) "
  TRANSLATIONS["tr,multi_validator_format"]="Validator verilerini girin (format: private_key,address,private_bls,public_bls):"
  TRANSLATIONS["tr,single_validator_bls_private"]="Validator BLS özel anahtarını girin:"
  TRANSLATIONS["tr,single_validator_bls_public"]="Validator BLS genel anahtarını girin:"
  TRANSLATIONS["tr,bls_keys_added"]="BLS anahtarları validator konfigürasyonuna eklendi"
  TRANSLATIONS["tr,select_network"]="Ağ seçin"
  TRANSLATIONS["tr,enter_choice"]="Seçimi girin:"
  TRANSLATIONS["tr,selected_network"]="Seçilen ağ:"
  TRANSLATIONS["tr,mainnet"]="mainnet"
  TRANSLATIONS["tr,testnet"]="testnet"
  TRANSLATIONS["tr,stopping_containers"]="Konteynerler durduruluyor..."
  TRANSLATIONS["tr,removing_node_data"]="Aztec node verileri kaldırılıyor..."
  TRANSLATIONS["tr,stopping_watchtower"]="Watchtower durduruluyor..."
  TRANSLATIONS["tr,removing_watchtower_data"]="Watchtower verileri kaldırılıyor..."
  TRANSLATIONS["tr,enter_yn"]="Lütfen Y veya N girin: "

  # Translations from check-validator.sh (Turkish)
  TRANSLATIONS["tr,fetching_validators"]="Doğrulayıcı listesi kontrattan alınıyor"
  TRANSLATIONS["tr,found_validators"]="Bulunan doğrulayıcılar:"
  TRANSLATIONS["tr,checking_validators"]="Doğrulayıcılar kontrol ediliyor..."
  TRANSLATIONS["tr,check_completed"]="Kontrol tamamlandı."
  TRANSLATIONS["tr,select_action"]="Bir işlem seçin:"
  TRANSLATIONS["tr,validator_submenu_option1"]="1. Başka bir doğrulayıcı setini kontrol et"
  TRANSLATIONS["tr,validator_submenu_option2"]="2. Doğrulayıcı için kuyruk pozisyon bildirimi ayarla"
  TRANSLATIONS["tr,validator_submenu_option3"]="3. Kuyruktaki doğrulayıcıyı kontrol et"
  TRANSLATIONS["tr,validator_submenu_option4"]="4. Aktif izleyicileri listele"
  TRANSLATIONS["tr,validator_submenu_option5"]="5. Mevcut izlemeyi kaldır"
  TRANSLATIONS["tr,enter_option"]="Seçenek seçin:"
  TRANSLATIONS["tr,enter_address"]="Doğrulayıcı adresini girin:"
  TRANSLATIONS["tr,validator_info"]="Doğrulayıcı bilgisi:"
  TRANSLATIONS["tr,address"]="Adres"
  TRANSLATIONS["tr,stake"]="Stake"
  TRANSLATIONS["tr,withdrawer"]="Çekici"
  TRANSLATIONS["tr,rewards"]="Ödüller"
  TRANSLATIONS["tr,status"]="Durum"
  TRANSLATIONS["tr,status_0"]="NONE - Doğrulayıcı, doğrulayıcı setinde değil"
  TRANSLATIONS["tr,status_1"]="VALIDATING - Doğrulayıcı şu anda doğrulayıcı setinde"
  TRANSLATIONS["tr,status_2"]="ZOMBIE - Doğrulayıcı (validator) olarak katılmıyor, ancak staking'te fonları bulunuyor. Slashing (kesinti) cezası alıyor ve bakiyesi minimum seviyeye düşüyor."
  TRANSLATIONS["tr,status_3"]="EXITING - Sistemden çıkış sürecinde"
  TRANSLATIONS["tr,validator_not_found"]="%s adresli doğrulayıcı bulunamadı."
  TRANSLATIONS["tr,exiting"]="Çıkılıyor."
  TRANSLATIONS["tr,invalid_input"]="Geçersiz giriş. Lütfen 1, 2, 3 veya 0 seçin."
  TRANSLATIONS["tr,error_rpc_missing"]="Hata: $HOME/.env-aztec-agent dosyasında RPC_URL bulunamadı"
  TRANSLATIONS["tr,error_file_missing"]="Hata: $HOME/.env-aztec-agent dosyası bulunamadı"
  TRANSLATIONS["tr,select_mode"]="Yükleme modunu seçin:"
  TRANSLATIONS["tr,mode_fast"]="1. Hızlı mod (yüksek CPU yükü)"
  TRANSLATIONS["tr,mode_slow"]="2. Yavaş mod (düşük CPU yükü)"
  TRANSLATIONS["tr,mode_invalid"]="Geçersiz mod. Lütfen 1 или 2 seçin."
  TRANSLATIONS["tr,checking_queue"]="Doğrulayıcı kuyruğu kontrol ediliyor..."
  TRANSLATIONS["tr,validator_in_queue"]="Doğrulayıcı kuyrukta bulundu:"
  TRANSLATIONS["tr,position"]="Pozisyon"
  TRANSLATIONS["tr,queued_at"]="Kuyruğa eklendi"
  TRANSLATIONS["tr,not_in_queue"]="Doğrulayıcı kuyrukta da yok."
  TRANSLATIONS["tr,fetching_queue"]="Doğrulayıcı kuyruk verileri alınıyor..."
  TRANSLATIONS["tr,notification_script_created"]="Bildirim betiği oluşturuldu и zamanlandı. İzlenen doğrulayıcı: %s"
  TRANSLATIONS["tr,notification_exists"]="Bu doğrulayıcı için zaten bir bildirim var."
  TRANSLATIONS["tr,enter_validator_address"]="İzlemek için doğrulayıcı adresini girin:"
  TRANSLATIONS["tr,notification_removed"]="%s doğrulayıcısı için bildirim kaldırıldı."
  TRANSLATIONS["tr,no_notifications"]="Aktif bildirim bulunamadı."
  TRANSLATIONS["tr,validator_not_in_queue"]="Doğrulayıcı kuyrukta da bulunamadı. Lütfen adresi kontrol edin."
  TRANSLATIONS["tr,validator_not_in_set"]="Doğrulayıcı mevcut doğrulayıcı setinde bulunamadı. Kuyruk kontrol ediliyor..."
  TRANSLATIONS["tr,queue_notification_title"]="Doğrulayıcı sıra pozisyon bildirimi"
  TRANSLATIONS["tr,active_monitors"]="Aktif doğrulayıcı izleyicileri:"
  TRANSLATIONS["tr,enter_multiple_addresses"]="İzlemek için doğrulayıcı adreslerini girin (virgülle ayrılmış):"
  TRANSLATIONS["tr,invalid_address_format"]="Geçersiz adres formatı: %s"
  TRANSLATIONS["tr,processing_address"]="Adres işleniyor: %s"
  TRANSLATIONS["tr,add_validators_to_queue_prompt"]="Bu doğrulayıcıları kuyruk izlemeye eklemek ister misiniz?"
  TRANSLATIONS["tr,enter_yes_to_add"]="Tümünü eklemek için 'yes' veya atlamak için 'no' girin:"
  TRANSLATIONS["tr,queue_validators_added"]="Tüm kuyruk doğrulayıcıları izlemeye eklendi."
  TRANSLATIONS["tr,skipping_queue_setup"]="Kuyruk izleme kurulumu atlanıyor."
  TRANSLATIONS["tr,queue_validators_available"]="İzleme için Kuyruk Doğrulayıcıları Mevcut"
  TRANSLATIONS["tr,initial_notification_note"]="Not: İlk bildirim gönderildi. Betik güvenlik zaman aşımlarını içerir."
  TRANSLATIONS["tr,running_initial_test"]="İlk test çalıştırılıyor..."
  TRANSLATIONS["tr,no_valid_addresses"]="Kontrol edilecek geçerli adres yok."
  TRANSLATIONS["tr,fetching_page"]="Sayfa %d/%d alınıyor..."
  TRANSLATIONS["tr,loading_validators"]="Doğrulayıcı verileri yükleniyor..."
  TRANSLATIONS["tr,validators_loaded"]="Doğrulayıcı verileri başarıyla yüklendi"
  TRANSLATIONS["tr,rpc_error"]="RPC hatası oluştu, alternatif RPC deneniyor"
  TRANSLATIONS["tr,getting_new_rpc"]="Yeni RPC URL alınıyor..."
  TRANSLATIONS["tr,rate_limit_notice"]="Yedek RPC kullanılıyor - hız sınırlaması: saniyede 1 istek"
  TRANSLATIONS["tr,getting_validator_count"]="Doğrulayıcı sayısı alınıyor..."
  TRANSLATIONS["tr,getting_current_slot"]="Mevcut slot alınıyor..."
  TRANSLATIONS["tr,deriving_timestamp"]="Slot için zaman damgası türetiliyor..."
  TRANSLATIONS["tr,querying_attesters"]="GSE kontratından onaylayıcılar sorgulanıyor..."
  TRANSLATIONS["tr,select_monitor_to_remove"]="Kaldırılacak izleyiciyi seçin:"
  TRANSLATIONS["tr,monitor_removed"]="%s doğrulayıcısı için izleme kaldırıldı."
  TRANSLATIONS["tr,all_monitors_removed"]="Tüm izleme betikleri kaldırıldı."
  TRANSLATIONS["tr,remove_all"]="Tüm izleme betiklerini kaldır"
  TRANSLATIONS["tr,remove_specific"]="Belirli izleyiciyi kaldır"
  TRANSLATIONS["tr,api_error"]="Dashtec API'de olası sorunlar"
  TRANSLATIONS["tr,contact_developer"]="Geliştiriciye bildirin: https://t.me/+zEaCtoXYYwIyZjQ0"

  TRANSLATIONS["tr,installing_foundry"]="Foundry yükleniyor..."
  TRANSLATIONS["tr,installing_curl"]="curl yükleniyor..."
  TRANSLATIONS["tr,installing_utils"]="Araçlar yükleniyor (grep, sed)..."
  TRANSLATIONS["tr,installing_jq"]="jq yükleniyor..."
  TRANSLATIONS["tr,installing_bc"]="bc yükleniyor..."
  TRANSLATIONS["tr,installing_python3"]="Python3 yükleniyor..."

  TRANSLATIONS["tr,bls_restarting_web3signer"]="Yeni anahtarı yüklemek için web3signer yeniden başlatılıyor"
  TRANSLATIONS["tr,bls_web3signer_restarted"]="Web3signer başarıyla yeniden başlatıldı"
  TRANSLATIONS["tr,bls_web3signer_running"]="Web3signer yeniden başlatıldıktan sonra çalışıyor"
  TRANSLATIONS["tr,bls_web3signer_not_running"]="Web3signer yeniden başlatıldıktan sonra çalışmıyor"
  TRANSLATIONS["tr,bls_web3signer_restart_failed"]="Web3signer yeniden başlatılamadı"
  TRANSLATIONS["tr,bls_final_web3signer_restart"]="Tüm anahtarları yüklemek için son web3signer yeniden başlatma işlemi yapılıyor"
  TRANSLATIONS["tr,bls_final_web3signer_restarted"]="Son web3signer yeniden başlatma işlemi tamamlandı"
  TRANSLATIONS["tr,bls_final_web3signer_restart_failed"]="Son web3signer yeniden başlatma işlemi başarısız oldu"

  TRANSLATIONS["tr,aztec_rewards_claim"]="Aztec Ödül Talep"
  TRANSLATIONS["tr,environment_file_not_found"]="Ortam dosyası bulunamadı"
  TRANSLATIONS["tr,rpc_url_not_set"]="RPC_URL ayarlanmamış"
  TRANSLATIONS["tr,contract_address_not_set"]="CONTRACT_ADDRESS ayarlanmamış"
  TRANSLATIONS["tr,using_contract"]="Kullanılan kontrat:"
  TRANSLATIONS["tr,using_rpc"]="Kullanılan RPC:"
  TRANSLATIONS["tr,checking_rewards_claimable"]="Ödüllerin talep edilip edilemeyeceği kontrol ediliyor..."
  TRANSLATIONS["tr,failed_check_rewards_claimable"]="Ödül talep durumu kontrol edilemedi"
  TRANSLATIONS["tr,rewards_not_claimable"]="Ödüller şu anda talep edilemez"
  TRANSLATIONS["tr,rewards_are_claimable"]="Ödüller talep edilebilir"
  TRANSLATIONS["tr,keystore_file_not_found"]="Keystore dosyası bulunamadı:"
  TRANSLATIONS["tr,extracting_validator_addresses"]="Doğrulayıcı adresleri çıkarılıyor..."
  TRANSLATIONS["tr,no_coinbase_addresses_found"]="Keystore'da coinbase adresi bulunamadı"
  TRANSLATIONS["tr,found_unique_coinbase_addresses"]="Benzersiz coinbase adresleri bulundu:"
  TRANSLATIONS["tr,repeats_times"]="%s kez tekrarlanıyor"
  TRANSLATIONS["tr,checking_rewards"]="Ödüller kontrol ediliyor..."
  TRANSLATIONS["tr,checking_address"]="Adres kontrol ediliyor"
  TRANSLATIONS["tr,failed_get_rewards_for_address"]="Adres için ödüller alınamadı"
  TRANSLATIONS["tr,failed_convert_rewards_amount"]="Adres için ödül miktarı dönüştürülemedi"
  TRANSLATIONS["tr,failed_convert_to_eth"]="Adres için tutar dönüştürülemedi"
  TRANSLATIONS["tr,rewards_amount"]="Ödüller: %s"
  TRANSLATIONS["tr,no_rewards"]="Ödül yok"
  TRANSLATIONS["tr,no_rewards_to_claim"]="Şu anda talep edilecek ödül yok"
  TRANSLATIONS["tr,found_unique_addresses_with_rewards"]="Talep edilecek ödülü olan benzersiz adresler bulundu:"
  TRANSLATIONS["tr,already_claimed_this_session"]="Bu oturumda zaten talep edildi"
  TRANSLATIONS["tr,skipping"]="atlanıyor"
  TRANSLATIONS["tr,address_label"]="Adres:"
  TRANSLATIONS["tr,amount_eth"]="Miktar: %s"
  TRANSLATIONS["tr,address_appears_times"]="Bu adres keystore'da %s kez görünüyor"
  TRANSLATIONS["tr,claim_rewards_confirmation"]="Bu ödülleri talep etmek istiyor musunuz? (y/n/skip):"
  TRANSLATIONS["tr,claiming_rewards"]="Ödüller talep ediliyor..."
  TRANSLATIONS["tr,transaction_sent"]="İşlem gönderildi:"
  TRANSLATIONS["tr,waiting_confirmation"]="Onay bekleniyor..."
  TRANSLATIONS["tr,transaction_confirmed_successfully"]="İşlem başarıyla onaylandı"
  TRANSLATIONS["tr,rewards_successfully_claimed"]="Ödüller başarıyla talep edildi"
  TRANSLATIONS["tr,rewards_claimed_balance_not_zero"]="Ödüller talep edildi ancak bakiye sıfır değil: %s"
  TRANSLATIONS["tr,claimed_rewards_for_address_appears_times"]="%s için ödüller talep edildi (%s kez görünüyor)"
  TRANSLATIONS["tr,transaction_failed"]="İşlem başarısız oldu"
  TRANSLATIONS["tr,could_not_get_receipt_transaction_sent"]="Makbuz alınamadı, ancak işlem gönderildi"
  TRANSLATIONS["tr,failed_send_transaction"]="İşlem gönderilemedi"
  TRANSLATIONS["tr,skipping_claim_for_address"]="Adres için talep atlanıyor"
  TRANSLATIONS["tr,skipping_all_remaining_claims"]="Kalan tüm talepler atlanıyor"
  TRANSLATIONS["tr,waiting_seconds"]="5 saniye bekleniyor..."
  TRANSLATIONS["tr,summary"]="ÖZET"
  TRANSLATIONS["tr,successfully_claimed"]="Başarıyla talep edildi:"
  TRANSLATIONS["tr,failed_count"]="Başarısız:"
  TRANSLATIONS["tr,unique_addresses_with_rewards"]="Ödüllü benzersiz adresler:"
  TRANSLATIONS["tr,total_coinbase_addresses_in_keystore"]="Keystore'daki toplam coinbase adresleri:"
  TRANSLATIONS["tr,contract_used"]="Kullanılan kontrat:"
  TRANSLATIONS["tr,earliest_rewards_claimable_timestamp"]="En erken ödül talep edilebilir zaman damgası: %s (%s)"
  TRANSLATIONS["tr,claim_function_not_activated"]="Şu anda kontratta talep işlevi etkinleştirilmemiş"
}

# === Configuration ===
CONTRACT_ADDRESS="0xebd99ff0ff6677205509ae73f93d0ca52ac85d67"
CONTRACT_ADDRESS_MAINNET="0x603bb2c05d474794ea97805e8de69bccfb3bca12"
FUNCTION_SIG="getPendingBlockNumber()"

REQUIRED_TOOLS=("cast" "curl" "grep" "sed" "jq" "bc" "python3")
AGENT_SCRIPT_PATH="$HOME/aztec-monitor-agent"
LOG_FILE="$AGENT_SCRIPT_PATH/agent.log"

function show_logo() {
    # Inline logo function (merged from logo.sh)
    local b=$'\033[34m' # Blue
    local y=$'\033[33m' # Yellow
    local r=$'\033[0m'  # Reset

    echo
    echo
    echo -e "${NC}$(t "welcome")${NC}"
    echo
    echo "${b}$(echo "  █████╗ ███████╗████████╗███████╗ ██████╗" | sed -E "s/(█+)/${y}\1${b}/g")${r}"
    echo "${b}$(echo " ██╔══██╗╚══███╔╝╚══██╔══╝██╔════╝██╔════╝" | sed -E "s/(█+)/${y}\1${b}/g")${r}"
    echo "${b}$(echo " ███████║  ███╔╝    ██║   █████╗  ██║" | sed -E "s/(█+)/${y}\1${b}/g")${r}"
    echo "${b}$(echo " ██╔══██║ ███╔╝     ██║   ██╔══╝  ██║" | sed -E "s/(█+)/${y}\1${b}/g")${r}"
    echo "${b}$(echo " ██║  ██║███████╗   ██║   ███████╗╚██████╗" | sed -E "s/(█+)/${y}\1${b}/g")${r}"
    echo "${b}$(echo " ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝ ╚═════╝" | sed -E "s/(█+)/${y}\1${b}/g")${r}"
    echo

    # Information in frame
    local info_lines=(
      " Made by Pittpv"
      " Feedback & Support in Tg: https://t.me/+DLsyG6ol3SFjM2Vk"
      " Donate"
      "  EVM: 0x4FD5eC033BA33507E2dbFE57ca3ce0A6D70b48Bf"
      "  SOL: C9TV7Q4N77LrKJx4njpdttxmgpJ9HGFmQAn7GyDebH4R"
    )

    # Calculate maximum line length (accounting for Unicode, without colors)
    local max_len=0
    for line in "${info_lines[@]}"; do
      local clean_line=$(echo "$line" | sed -E 's/\x1B\[[0-9;]*[mK]//g')
      local line_length=$(echo -n "$clean_line" | wc -m)
      (( line_length > max_len )) && max_len=$line_length
    done

    # Frames
    local top_border="╔$(printf '═%.0s' $(seq 1 $((max_len + 2))))╗"
    local bottom_border="╚$(printf '═%.0s' $(seq 1 $((max_len + 2))))╝"

    # Print frame
    echo -e "${b}${top_border}${r}"
    for line in "${info_lines[@]}"; do
      local clean_line=$(echo "$line" | sed -E 's/\x1B\[[0-9;]*[mK]//g')
      local line_length=$(echo -n "$clean_line" | wc -m)
      local padding=$((max_len - line_length))
      printf "${b}║ ${y}%s%*s ${b}║\n" "$line" "$padding" ""
    done
    echo -e "${b}${bottom_border}${r}"
    echo
}

# === Helper function to get network and RPC settings ===
get_network_settings() {
    local env_file="$HOME/.env-aztec-agent"
    local network="testnet"
    local rpc_url="$RPC_URL"

    if [[ -f "$env_file" ]]; then
        source "$env_file"
        [[ -n "$NETWORK" ]] && network="$NETWORK"
        [[ -n "$ALT_RPC" ]] && rpc_url="$ALT_RPC"
    fi

    # Determine contract address based on network
    local contract_address="$CONTRACT_ADDRESS"
    if [[ "$network" == "mainnet" ]]; then
        contract_address="$CONTRACT_ADDRESS_MAINNET"
    fi

    echo "$network|$rpc_url|$contract_address"
}

# === Dependency check ===
check_dependencies() {
  missing=()
  echo -e "\n${BLUE}$(t "checking_deps")${NC}\n"

  # Создаем ассоциативный массив для отображения имен
  declare -A tool_names=(
    ["cast"]="foundry"
    ["curl"]="curl"
    ["grep"]="grep"
    ["sed"]="sed"
    ["jq"]="jq"
    ["bc"]="bc"
    ["python3"]="python3"
  )

  # Проверяем основные утилиты
  for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
      display_name=${tool_names[$tool]:-$tool}
      echo -e "${RED}❌ $display_name $(t "not_installed")${NC}"
      missing+=("$tool")
    else
      display_name=${tool_names[$tool]:-$tool}
      echo -e "${GREEN}✅ $display_name $(t "installed")${NC}"
    fi
  done

  # Отдельная проверка для curl_cffi
  if command -v python3 &>/dev/null; then
    if python3 -c "import curl_cffi" 2>/dev/null; then
      echo -e "${GREEN}✅ curl_cffi $(t "installed")${NC}"
    else
      echo -e "${YELLOW}⚠️  curl_cffi $(t "not_installed")${NC}"
      # Добавляем python3 в missing только если нужно установить curl_cffi
      if [[ ! " ${missing[@]} " =~ " python3 " ]]; then
        missing+=("python3_curl_cffi")
      fi
    fi
  else
    # python3 не установлен, это уже обрабатывается выше
    echo -e "${YELLOW}⚠️  curl_cffi $(t "not_installed") (requires python3)${NC}"
  fi

  if [ ${#missing[@]} -gt 0 ]; then
    # Преобразуем имена для отображения в списке отсутствующих инструментов
    missing_display=()
    for tool in "${missing[@]}"; do
      if [ "$tool" == "python3_curl_cffi" ]; then
        missing_display+=("curl_cffi")
      else
        missing_display+=("${tool_names[$tool]:-$tool}")
      fi
    done

    echo -e "\n${YELLOW}$(t "missing_tools") ${missing_display[*]}${NC}"
    read -p "$(t "install_prompt") " confirm
    confirm=${confirm:-Y}

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      for tool in "${missing[@]}"; do
        case "$tool" in
          cast)
            echo -e "\n${CYAN}$(t "installing_foundry")${NC}"
            # Security warning: This is a third-party script execution. Consider pinning to a specific version
            # or verifying checksums in production environments to prevent supply chain attacks.
            curl -L https://foundry.paradigm.xyz | bash

            if ! grep -q 'foundry/bin'  ~/.bash_profile; then
              echo 'export PATH="$PATH:$HOME/.foundry/bin"' >> ~/.bash_profile
            fi

            export PATH="$PATH:$HOME/.foundry/bin"
            foundryup
            ;;

          curl)
            echo -e "\n${CYAN}$(t "installing_curl")${NC}"
            sudo apt-get install -y curl || brew install curl
            ;;

          grep|sed)
            echo -e "\n${CYAN}$(t "installing_utils")${NC}"
            sudo apt-get install -y grep sed || brew install grep gnu-sed
            ;;

          jq)
            echo -e "\n${CYAN}$(t "installing_jq")${NC}"
            sudo apt-get install -y jq || brew install jq
            ;;

          bc)
            echo -e "\n${CYAN}$(t "installing_bc")${NC}"
            sudo apt-get install -y bc || brew install bc
            ;;

          python3)
            echo -e "\n${CYAN}$(t "installing_python3")${NC}"
            # Устанавливаем python3 и pip отдельно
            if command -v apt-get &>/dev/null; then
              sudo apt-get install -y python3 python3-pip
            elif command -v brew &>/dev/null; then
              brew install python3
            fi

            # Устанавливаем curl_cffi с обходом externally-managed-environment
            echo -e "\n${CYAN}$(t "installing_curl_cffi")${NC}"
            # Сначала проверяем доступность pip
            if python3 -m pip --version &>/dev/null; then
              python3 -m pip install --break-system-packages --quiet curl_cffi 2>/dev/null || \
              python3 -m pip install --quiet curl_cffi
            else
              # Если pip недоступен, устанавливаем через ensurepip
              python3 -m ensurepip --user 2>/dev/null || true
              python3 -m pip install --user --quiet curl_cffi 2>/dev/null || \
              curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
              python3 get-pip.py --user && \
              python3 -m pip install --user --quiet curl_cffi
              rm -f get-pip.py
            fi
            ;;

          python3_curl_cffi)
            # Устанавливаем только curl_cffi с обходом externally-managed-environment
            echo -e "\n${CYAN}$(t "installing_curl_cffi")${NC}"
            # Сначала проверяем доступность pip
            if python3 -m pip --version &>/dev/null; then
              python3 -m pip install --break-system-packages --quiet curl_cffi 2>/dev/null || \
              python3 -m pip install --quiet curl_cffi
            else
              # Если pip недоступен, устанавливаем через ensurepip
              python3 -m ensurepip --user 2>/dev/null || true
              python3 -m pip install --user --quiet curl_cffi 2>/dev/null || \
              curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
              python3 get-pip.py --user && \
              python3 -m pip install --user --quiet curl_cffi
              rm -f get-pip.py
            fi
            ;;
        esac
      done
    else
      echo -e "\n${RED}$(t "missing_required")${NC}"
      exit 1
    fi
  fi

  # Дополнительная проверка curl_cffi на случай, если пользователь пропустил установку
  if command -v python3 &>/dev/null; then
    if ! python3 -c "import curl_cffi" 2>/dev/null; then
      echo -e "\n${YELLOW}$(t "curl_cffi_not_installed")${NC}"
      read -p "$(t "install_curl_cffi_prompt") " confirm
      confirm=${confirm:-Y}

      if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "\n${CYAN}$(t "installing_curl_cffi")${NC}"
        # Сначала проверяем доступность pip
        if python3 -m pip --version &>/dev/null; then
          python3 -m pip install --break-system-packages --quiet curl_cffi 2>/dev/null || \
          python3 -m pip install --quiet curl_cffi
        else
          # Если pip недоступен, устанавливаем через ensurepip
          python3 -m ensurepip --user 2>/dev/null || true
          python3 -m pip install --user --quiet curl_cffi 2>/dev/null || \
          curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
          python3 get-pip.py --user && \
          python3 -m pip install --user --quiet curl_cffi
          rm -f get-pip.py
        fi
      else
        echo -e "\n${YELLOW}$(t "curl_cffi_optional")${NC}"
      fi
    fi
  fi

  # Request RPC URL from user and create .env file
  if [ ! -f .env-aztec-agent ]; then
      echo -e "\n${BLUE}$(t "rpc_prompt")${NC}"

      # Запрос RPC URL с проверкой
      while true; do
          read -p "> " RPC_URL
          if [ -n "$RPC_URL" ]; then
              break
          else
              echo -e "${RED}$(t "rpc_empty_error")${NC}"
          fi
      done

      echo -e "\n${BLUE}$(t "network_prompt")${NC}"

      # Запрос сети с проверкой
      while true; do
          read -p "> " NETWORK
          if [ -n "$NETWORK" ]; then
              break
          else
              echo -e "${RED}$(t "network_empty_error")${NC}"
          fi
      done

      # Создание файла с обеими переменными
      {
          printf 'RPC_URL=%s\n' "$RPC_URL"
          printf 'NETWORK=%s\n' "$NETWORK"
      } > .env-aztec-agent

      echo -e "\n${GREEN}$(t "env_created")${NC}"
  else
      source .env-aztec-agent
      DISPLAY_NETWORK="${NETWORK:-testnet}"
      echo -e "\n${GREEN}$(t "env_exists") $RPC_URL, NETWORK: $DISPLAY_NETWORK${NC}"
  fi

  # === Проверяем и добавляем ключ VERSION в ~/.env-aztec-agent ===
  # Если ключа VERSION в .env-aztec-agent нет – дописать его, не затронув остальные переменные
  INSTALLED_VERSION=$(grep '^VERSION=' ~/.env-aztec-agent | cut -d'=' -f2)

  if [ -z "$INSTALLED_VERSION" ]; then
    printf 'VERSION=%s\n' "$SCRIPT_VERSION" >> ~/.env-aztec-agent
    INSTALLED_VERSION="$SCRIPT_VERSION"
  elif [ "$INSTALLED_VERSION" != "$SCRIPT_VERSION" ]; then
  # Обновляем строку VERSION в .env-aztec-agent
    sed -i "s/^VERSION=.*/VERSION=$SCRIPT_VERSION/" ~/.env-aztec-agent
    INSTALLED_VERSION="$SCRIPT_VERSION"
  fi

  # === Используем локальный version_control.json для определения последней версии ===
  # Security: Use local file instead of remote download to prevent supply chain attacks
  # По умолчанию показываем только локальную версию. Для проверки обновлений используйте опциональную функцию check_updates_safely()
  LOCAL_VC_FILE="$SCRIPT_DIR/aztec-script-files/version_control.json"
  # Читаем локальный JSON, отбираем массив .[].VERSION, сортируем, берём последний
  if [ -f "$LOCAL_VC_FILE" ] && local_data=$(cat "$LOCAL_VC_FILE"); then
    LOCAL_LATEST_VERSION=$(echo "$local_data" | jq -r '.[].VERSION' | sort -V | tail -n1)
  else
    LOCAL_LATEST_VERSION=""
  fi

  # === Выводим текущую версию из локального файла ===
  echo -e "\n${CYAN}$(t "current_script_version") ${INSTALLED_VERSION}${NC}"
  if [ -n "$LOCAL_LATEST_VERSION" ]; then
    if [ "$LOCAL_LATEST_VERSION" != "$INSTALLED_VERSION" ]; then
      echo -e "${YELLOW}$(t "local_version_shows") ${LOCAL_LATEST_VERSION}${NC}"
      echo -e "${BLUE}$(t "note_check_updates_safely")${NC}"
    else
      echo -e "${GREEN}$(t "local_version_up_to_date")${NC}"
    fi
  fi
}

# === Безопасная проверка обновлений с подтверждением и проверкой хешей ===
# Security: Optional update check with hash verification to prevent supply chain attacks
check_updates_safely() {
  echo -e "\n${BLUE}=== $(t "safe_update_check") ===${NC}"
  echo -e "${YELLOW}$(t "update_check_warning")${NC}"
  echo -e "${YELLOW}$(t "file_not_executed_auto")${NC}"
  read -p "$(t "continue_prompt"): " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}$(t "update_check_cancelled")${NC}"
    return 0
  fi

  REMOTE_VC_URL="https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/version_control.json"
  TEMP_VC_FILE=$(mktemp)

  echo -e "\n${CYAN}$(t "downloading_version_control")${NC}"
  if ! curl -fsSL "$REMOTE_VC_URL" -o "$TEMP_VC_FILE"; then
    echo -e "${RED}$(t "failed_download_version_control")${NC}"
    rm -f "$TEMP_VC_FILE"
    return 1
  fi

  # Вычисляем SHA256 хеш загруженного файла
  if command -v sha256sum >/dev/null 2>&1; then
    DOWNLOADED_HASH=$(sha256sum "$TEMP_VC_FILE" | cut -d' ' -f1)
    echo -e "${GREEN}$(t "downloaded_file_sha256") ${DOWNLOADED_HASH}${NC}"
    echo -e "${YELLOW}$(t "verify_hash_match")${NC}"
  elif command -v shasum >/dev/null 2>&1; then
    DOWNLOADED_HASH=$(shasum -a 256 "$TEMP_VC_FILE" | cut -d' ' -f1)
    echo -e "${GREEN}$(t "downloaded_file_sha256") ${DOWNLOADED_HASH}${NC}"
    echo -e "${YELLOW}$(t "verify_hash_match")${NC}"
  fi

  # Парсим и показываем информацию об обновлениях
  if remote_data=$(cat "$TEMP_VC_FILE"); then
    REMOTE_LATEST_VERSION=$(echo "$remote_data" | jq -r '.[].VERSION' | sort -V | tail -n1)

    echo -e "\n${CYAN}$(t "current_installed_version") ${INSTALLED_VERSION}${NC}"
    echo -e "${CYAN}$(t "latest_version_repo") ${REMOTE_LATEST_VERSION}${NC}"

    if [ -n "$REMOTE_LATEST_VERSION" ] && [ "$REMOTE_LATEST_VERSION" != "$INSTALLED_VERSION" ]; then
      echo -e "\n${YELLOW}$(t "new_version_available") ${REMOTE_LATEST_VERSION}${NC}"

      # Функция для сравнения версий
      version_gt() {
        if [ "$1" = "$2" ]; then
          return 1
        fi
        local IFS=.
        local i ver1=($1) ver2=($2)
        for ((i=0; i<${#ver1[@]}; i++)); do
          if [[ -z ${ver2[i]} ]]; then
            ver2[i]=0
          fi
          if ((10#${ver1[i]} > 10#${ver2[i]})); then
            return 0
          fi
          if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 1
          fi
        done
        return 1
      }

      # Выводим обновления только для версий НОВЕЕ текущей
      echo -e "\n${BLUE}=== $(t "update_changes") ===${NC}"
      echo "$remote_data" | jq -c '.[]' | while read -r update; do
        version=$(echo "$update" | jq -r '.VERSION')
        date=$(echo "$update" | jq -r '.UPDATE_DATE')

        if version_gt "$version" "$INSTALLED_VERSION"; then
          echo -e "\n${GREEN}$(t "version_label") $version (${date})${NC}"
          echo "$update" | jq -r '.CHANGES[]' | while read -r change; do
            echo -e "  • ${YELLOW}$change${NC}"
          done
        fi
      done

      echo -e "\n${BLUE}$(t "note_update_manually")${NC}"
    elif [ -n "$REMOTE_LATEST_VERSION" ]; then
      echo -e "${GREEN}$(t "version_up_to_date")${NC}"
    fi
  fi

  # Удаляем временный файл
  rm -f "$TEMP_VC_FILE"
}

# === Безопасная проверка обновлений error_definitions.json ===
check_error_definitions_updates_safely() {
  echo -e "\n${BLUE}=== $(t "safe_error_def_update_check") ===${NC}"
  echo -e "${YELLOW}$(t "error_def_update_warning")${NC}"
  echo -e "${YELLOW}$(t "file_not_executed_auto")${NC}"
  read -p "$(t "continue_prompt"): " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}$(t "update_check_cancelled")${NC}"
    return 0
  fi

  REMOTE_ERROR_DEF_URL="https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/error_definitions.json"
  TEMP_ERROR_FILE=$(mktemp)

  echo -e "\n${CYAN}$(t "downloading_error_definitions")${NC}"
  if ! curl -fsSL "$REMOTE_ERROR_DEF_URL" -o "$TEMP_ERROR_FILE"; then
    echo -e "${RED}$(t "failed_download_error_definitions")${NC}"
    rm -f "$TEMP_ERROR_FILE"
    return 1
  fi

  # Вычисляем SHA256 хеш загруженного файла
  if command -v sha256sum >/dev/null 2>&1; then
    DOWNLOADED_HASH=$(sha256sum "$TEMP_ERROR_FILE" | cut -d' ' -f1)
    echo -e "${GREEN}$(t "downloaded_file_sha256") ${DOWNLOADED_HASH}${NC}"
    echo -e "${YELLOW}$(t "verify_hash_match")${NC}"
  elif command -v shasum >/dev/null 2>&1; then
    DOWNLOADED_HASH=$(shasum -a 256 "$TEMP_ERROR_FILE" | cut -d' ' -f1)
    echo -e "${GREEN}$(t "downloaded_file_sha256") ${DOWNLOADED_HASH}${NC}"
    echo -e "${YELLOW}$(t "verify_hash_match")${NC}"
  fi

  # Сравниваем с локальным файлом
  LOCAL_ERROR_FILE="$SCRIPT_DIR/aztec-script-files/error_definitions.json"
  if [ -f "$LOCAL_ERROR_FILE" ]; then
    if command -v sha256sum >/dev/null 2>&1; then
      LOCAL_HASH=$(sha256sum "$LOCAL_ERROR_FILE" | cut -d' ' -f1)
    elif command -v shasum >/dev/null 2>&1; then
      LOCAL_HASH=$(shasum -a 256 "$LOCAL_ERROR_FILE" | cut -d' ' -f1)
    fi

    if [ "$DOWNLOADED_HASH" = "$LOCAL_HASH" ]; then
      echo -e "${GREEN}$(t "error_def_matches_remote")${NC}"
    else
      echo -e "${YELLOW}$(t "local_remote_versions_differ")${NC}"
      echo -e "${BLUE}$(t "local_hash") ${LOCAL_HASH}${NC}"
      echo -e "${BLUE}$(t "remote_hash") ${DOWNLOADED_HASH}${NC}"
      echo -e "${BLUE}$(t "note_update_manually")${NC}"
    fi
  else
    echo -e "${YELLOW}$(t "local_error_def_not_found")${NC}"
  fi

  # Удаляем временный файл
  rm -f "$TEMP_ERROR_FILE"
}

# === Spinner function ===
spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'

  while kill -0 "$pid" 2>/dev/null; do
    for i in $(seq 0 3); do
      printf "\r${CYAN}$(t "searching") %c${NC}" "${spinstr:i:1}"
      sleep $delay
    done
  done

  printf "\r                 \r"
}

# === Check container logs for block ===
check_aztec_container_logs() {
    cd $HOME

    # Get network settings
    local settings
    settings=$(get_network_settings)
    local network=$(echo "$settings" | cut -d'|' -f1)
    local rpc_url=$(echo "$settings" | cut -d'|' -f2)
    local contract_address=$(echo "$settings" | cut -d'|' -f3)

    # Security: Use local file instead of remote download to prevent supply chain attacks
    ERROR_DEFINITIONS_FILE="$SCRIPT_DIR/aztec-script-files/error_definitions.json"

    # Загружаем JSON с определениями ошибок из локального файла
    download_error_definitions() {
        if [ ! -f "$ERROR_DEFINITIONS_FILE" ]; then
            echo -e "${YELLOW}Warning: Error definitions file not found at $ERROR_DEFINITIONS_FILE${NC}"
            return 1
        fi
        return 0
    }

    # Парсим JSON и заполняем массивы
    parse_error_definitions() {
        # Используем jq для парсинга JSON, если установлен
        if command -v jq >/dev/null; then
            while IFS= read -r line; do
                pattern=$(jq -r '.pattern' <<< "$line")
                message=$(jq -r '.message' <<< "$line")
                solution=$(jq -r '.solution' <<< "$line")
                critical_errors["$pattern"]="$message"
                error_solutions["$pattern"]="$solution"
            done < <(jq -c '.[]' "$ERROR_DEFINITIONS_FILE")
        else
            # Простой парсинг без jq (ограниченная функциональность)
            while IFS= read -r line; do
                if [[ "$line" =~ \"pattern\":\"([^\"]*)\".*\"message\":\"([^\"]*)\".*\"solution\":\"([^\"]*)\" ]]; then
                    pattern="${BASH_REMATCH[1]}"
                    message="${BASH_REMATCH[2]}"
                    solution="${BASH_REMATCH[3]}"
                    critical_errors["$pattern"]="$message"
                    error_solutions["$pattern"]="$solution"
                fi
            done < <(grep -Eo '\{[^}]+\}' "$ERROR_DEFINITIONS_FILE")
        fi
    }

    # Инициализируем массивы для ошибок и решений
    declare -A critical_errors
    declare -A error_solutions

    # Загружаем и парсим определения ошибок
    if download_error_definitions; then
        parse_error_definitions
    else
        # Используем встроенные ошибки по умолчанию если не удалось загрузить
        critical_errors=(
            ["ERROR: cli Error: World state trees are out of sync, please delete your data directory and re-sync"]="World state trees are out of sync - node needs resync"
        )
        error_solutions=(
            ["ERROR: cli Error: World state trees are out of sync, please delete your data directory and re-sync"]="1. Stop the node container. Use option 14\n2. Delete data from the folder: sudo rm -rf $HOME/.aztec/testnet/data/\n3. Run the container. Use option 13"
        )
    fi

    echo -e "\n${BLUE}$(t "search_container")${NC}"
    container_id=$(docker ps --format "{{.ID}} {{.Names}}" \
                   | grep aztec | grep -vE 'watchtower|otel|prometheus|grafana' | head -n 1 | awk '{print $1}')

    if [ -z "$container_id" ]; then
        echo -e "\n${RED}$(t "container_not_found")${NC}"
        return
    fi
    echo -e "\n${GREEN}$(t "container_found") $container_id${NC}"

    echo -e "\n${BLUE}$(t "get_block")${NC}"
    block_hex=$(cast call "$contract_address" "$FUNCTION_SIG" --rpc-url "$rpc_url" 2>/dev/null)
    if [ -z "$block_hex" ]; then
        echo -e "\n${RED}$(t "block_error")${NC}"
        return
    fi
    block_number=$((16#${block_hex#0x}))
    echo -e "\n${GREEN}$(t "current_block") $block_number${NC}"

    # Получаем логи контейнера
    clean_logs=$(docker logs "$container_id" --tail 20000 2>&1 | sed -r 's/\x1B\[[0-9;]*[A-Za-z]//g')

    # Проверяем на наличие критических ошибок
    for error_pattern in "${!critical_errors[@]}"; do
        if echo "$clean_logs" | grep -q "$error_pattern"; then
            echo -e "\n${RED}$(t "critical_error_found")${NC}"
            echo -e "${YELLOW}$(t "error_prefix") ${critical_errors[$error_pattern]}${NC}"

            # Выводим решение для данной ошибки
            if [ -n "${error_solutions[$error_pattern]}" ]; then
                echo -e "\n${BLUE}$(t "solution_prefix")${NC}"
                echo -e "${error_solutions[$error_pattern]}"
            fi

            return
        fi
    done

    temp_file=$(mktemp)
    {
        echo "$clean_logs" | tac | grep -m1 'Sequencer sync check succeeded' >"$temp_file" 2>/dev/null
        if [ ! -s "$temp_file" ]; then
            echo "$clean_logs" | tac | grep -m1 'Downloaded L2 block' >"$temp_file" 2>/dev/null
        fi
    } &
    search_pid=$!
    spinner $search_pid
    wait $search_pid

    latest_log_line=$(<"$temp_file")
    rm -f "$temp_file"

    if [ -z "$latest_log_line" ]; then
        echo -e "\n${RED}$(t "log_block_not_found")${NC}"
        return
    fi

    if grep -q 'Sequencer sync check succeeded' <<<"$latest_log_line"; then
        log_block_number=$(echo "$latest_log_line" \
            | grep -o '"worldState":{"number":[0-9]\+' \
            | grep -o '[0-9]\+$')
    else
        log_block_number=$(echo "$latest_log_line" \
            | grep -o '"blockNumber":[0-9]\+' \
            | head -n1 | cut -d':' -f2)
    fi

    if [ -z "$log_block_number" ]; then
        echo -e "\n${RED}$(t "log_block_extract_failed")${NC}"
        echo "$latest_log_line"
        return
    fi
    echo -e "\n${BLUE}$(t "log_block_number") $log_block_number${NC}"

    if [ "$log_block_number" -eq "$block_number" ]; then
        echo -e "\n${GREEN}$(t "node_ok")${NC}"
    else
        printf -v message "$(t "log_behind_details")" "$log_block_number" "$block_number"
        echo -e "\n${YELLOW}${message}${NC}"
        echo -e "\n${BLUE}$(t "log_line_example")${NC}"
        echo "$latest_log_line"
    fi
}

# === View Aztec container logs ===
view_container_logs() {

  echo -e "\n${BLUE}$(t "search_container")${NC}"
  container_id=$(docker ps --format "{{.ID}} {{.Names}}" | grep aztec | grep -vE 'watchtower|otel|prometheus|grafana' | head -n 1 | awk '{print $1}')

  if [ -z "$container_id" ]; then
    echo -e "\n${RED}$(t "container_not_found")${NC}"
    return
  fi

  echo -e "\n${GREEN}$(t "container_found") $container_id${NC}"
  echo -e "\n${BLUE}$(t "press_ctrlc")${NC}"
  echo -e "\n${BLUE}$(t "logs_starting")${NC}"

  sleep 5

  # При получении SIGINT (Ctrl+C) выходим из функции и возвращаемся в меню
  trap "echo -e '\n${YELLOW}$(t "return_main_menu")${NC}'; trap - SIGINT; return" SIGINT

  # Показываем логи в режиме "follow"
  docker logs --tail 500 -f "$container_id"

  # Убираем ранее установленный trap, если пользователь вышел нормально
  trap - SIGINT
}


# === Find rollupAddress in logs ===
find_rollup_address() {
  echo -e "\n${BLUE}$(t "search_rollup")${NC}"

  container_id=$(docker ps --format "{{.ID}} {{.Names}}" | grep aztec | grep -vE 'watchtower|otel|prometheus|grafana' | head -n 1 | awk '{print $1}')

  if [ -z "$container_id" ]; then
    echo -e "\n${RED}$(t "container_not_found")${NC}"
    return 1
  fi

  tmp_log=$(mktemp)
  # Получаем логи с очисткой ANSI-кодов
  docker logs "$container_id" 2>&1 | sed -r "s/\x1B\[[0-9;]*[mK]//g" > "$tmp_log" &

  spinner $!

  # Более надежный поиск rollupAddress
  rollup_address=$(grep -oP -m1 '"rollupAddress"\s*:\s*"\K0x[a-fA-F0-9]{40}' "$tmp_log" | tail -n 1)

  # Альтернативный вариант поиска, если стандартный не сработал
  if [ -z "$rollup_address" ]; then
    rollup_address=$(grep -oE -m1 'rollupAddress[^0-9a-fA-F]*0x[a-fA-F0-9]{40}' "$tmp_log" | grep -oE '0x[a-fA-F0-9]{40}' | tail -n 1)
  fi

  rm "$tmp_log"

  if [ -n "$rollup_address" ]; then
    echo -e "\n${GREEN}$(t "rollup_found") $rollup_address${NC}"
    return 0
  else
    echo -e "\n${RED}$(t "rollup_not_found")${NC}"
    return 1
  fi
}

# === Find PeerID in logs ===
find_peer_id() {
  echo -e "\n${BLUE}$(t "search_peer")${NC}"

  container_id=$(docker ps --format "{{.ID}} {{.Names}}" | grep aztec | grep -vE 'watchtower|otel|prometheus|grafana' | head -n 1 | awk '{print $1}')

  if [ -z "$container_id" ]; then
    echo -e "\n${RED}$(t "container_not_found")${NC}"
    return 1
  fi

  # Фоновый процесс для поиска peerId
  _find_peer_id_worker() {
    sudo docker logs "$container_id" 2>&1 | \
      grep -i "peerId" | \
      grep -o '"peerId":"[^"]*"' | \
      cut -d'"' -f4 | \
      head -n 1 > /tmp/peer_id.tmp
  }

  _find_peer_id_worker &
  worker_pid=$!
  spinner $worker_pid
  wait $worker_pid

  peer_id=$(< /tmp/peer_id.tmp)
  rm -f /tmp/peer_id.tmp

  if [ -z "$peer_id" ]; then
    echo -e "${RED}$(t "peer_not_found")${NC}"
    return 1
  else
    echo -e "\n${GREEN}$(t "peer_found")${NC}: $peer_id"
    return 0
  fi
}

# === Find governanceProposerPayload ===
find_governance_proposer_payload() {
  echo -e "\n${BLUE}$(t "search_gov")${NC}"

  # Получаем ID контейнера
  container_id=$(docker ps --format "{{.ID}} {{.Names}}" | grep aztec | grep -vE 'watchtower|otel|prometheus|grafana' | head -n 1 | awk '{print $1}')

  if [ -z "$container_id" ]; then
    echo -e "\n${RED}$(t "container_not_found")${NC}"
    return 1
  fi

  echo -e "\n${CYAN}$(t "gov_found")${NC}"

  # Вспомогательная функция для запуска поиска в фоне
  _find_payloads_worker() {
    sudo docker logs "$container_id" 2>&1 | \
      grep -i '"governanceProposerPayload"' | \
      grep -o '"governanceProposerPayload":"0x[a-fA-F0-9]\{40\}"' | \
      cut -d'"' -f4 | \
      tr '[:upper:]' '[:lower:]' | \
      awk '!seen[$0]++ {print}' | \
      tail -n 10 > /tmp/gov_payloads.tmp
  }

  # Запускаем поиск в фоне и спиннер
  _find_payloads_worker &
  worker_pid=$!
  spinner $worker_pid
  wait $worker_pid

  if [ ! -s /tmp/gov_payloads.tmp ]; then
    echo -e "\n${RED}$(t "gov_not_found")${NC}"
    rm -f /tmp/gov_payloads.tmp
    return 1
  fi

  mapfile -t payloads_array < /tmp/gov_payloads.tmp
  rm -f /tmp/gov_payloads.tmp

  echo -e "\n${GREEN}$(t "gov_found_results")${NC}"
  for p in "${payloads_array[@]}"; do
    echo "• $p"
  done

  if [ "${#payloads_array[@]}" -gt 1 ]; then
    echo -e "\n${RED}$(t "gov_changed")${NC}"
    for ((i = 1; i < ${#payloads_array[@]}; i++)); do
      echo -e "${YELLOW}$(t "gov_was") ${payloads_array[i-1]} → $(t "gov_now") ${payloads_array[i]}${NC}"
    done
  else
    echo -e "\n${GREEN}$(t "gov_no_changes")${NC}"
  fi

  return 0
}

# === Create agent and systemd task ===
create_systemd_agent() {
  local env_file
  env_file=$(_ensure_env_file)
  source "$env_file"

  # Function to validate Telegram bot token
  validate_telegram_token() {
    local token=$1
    if [[ ! "$token" =~ ^[0-9]+:[a-zA-Z0-9_-]+$ ]]; then
      return 1
    fi
    # Test token by making API call
    local response=$(curl -s "https://api.telegram.org/bot${token}/getMe")
    if [[ "$response" == *"ok\":true"* ]]; then
      return 0
    else
      return 1
    fi
  }

  # Function to validate Telegram chat ID (updated version)
  validate_telegram_chat() {
    local token=$1
    local chat_id=$2
    # Test chat ID by trying to send a test message
    local response=$(curl -s -X POST "https://api.telegram.org/bot${token}/sendMessage" \
      -d chat_id="${chat_id}" \
      -d text="$(t "chatid_linked")" \
      -d parse_mode="Markdown")

    if [[ "$response" == *"ok\":true"* ]]; then
      return 0
    else
      return 1
    fi
  }

  # === Проверка и получение TELEGRAM_BOT_TOKEN ===
  if [ -z "$TELEGRAM_BOT_TOKEN" ]; then
    while true; do
      echo -e "\n${BLUE}$(t "token_prompt")${NC}"
      read -p "> " TELEGRAM_BOT_TOKEN

      if validate_telegram_token "$TELEGRAM_BOT_TOKEN"; then
        echo "TELEGRAM_BOT_TOKEN=\"$TELEGRAM_BOT_TOKEN\"" >> "$env_file"
        break
      else
        echo -e "${RED}$(t "invalid_token")${NC}"
        echo -e "${YELLOW}$(t "token_format")${NC}"
      fi
    done
  fi

  # === Проверка и получение TELEGRAM_CHAT_ID ===
  if [ -z "$TELEGRAM_CHAT_ID" ]; then
    while true; do
      echo -e "\n${BLUE}$(t "chatid_prompt")${NC}"
      read -p "> " TELEGRAM_CHAT_ID

      if [[ "$TELEGRAM_CHAT_ID" =~ ^-?[0-9]+$ ]]; then
        if validate_telegram_chat "$TELEGRAM_BOT_TOKEN" "$TELEGRAM_CHAT_ID"; then
          echo "TELEGRAM_CHAT_ID=\"$TELEGRAM_CHAT_ID\"" >> "$env_file"
          break
        else
          echo -e "${RED}$(t "invalid_chatid")${NC}"
        fi
      else
        echo -e "${RED}$(t "chatid_number")${NC}"
      fi
    done
  fi

  # === Запрос о дополнительных уведомлениях ===
  if [ -z "$NOTIFICATION_TYPE" ]; then
    echo -e "\n${BLUE}$(t "notifications_prompt")${NC}"
    echo -e "$(t "notifications_option1")"
    echo -e "$(t "notifications_option2")"
    echo -e "\n${YELLOW}$(t "notifications_debug_warning")${NC}"
    while true; do
      read -p "$(t "choose_option_prompt") (1/2): " NOTIFICATION_TYPE
      if [[ "$NOTIFICATION_TYPE" =~ ^[12]$ ]]; then
        if ! grep -q "NOTIFICATION_TYPE" "$env_file"; then
          echo "NOTIFICATION_TYPE=\"$NOTIFICATION_TYPE\"" >> "$env_file"
        else
          sed -i "s/^NOTIFICATION_TYPE=.*/NOTIFICATION_TYPE=\"$NOTIFICATION_TYPE\"/" "$env_file"
        fi
        break
      else
        echo -e "${RED}$(t "notifications_input_error")${NC}"
      fi
    done
  fi

  # === Проверка и получение VALIDATORS (если NOTIFICATION_TYPE == 2) ===
  if [ "$NOTIFICATION_TYPE" -eq 2 ] && [ ! -f "$HOME/.env-aztec-agent" ] || ! grep -q "^VALIDATORS=" "$HOME/.env-aztec-agent"; then
    echo -e "\n${BLUE}$(t "validators_prompt")${NC}"
    echo -e "${YELLOW}$(t "validators_format")${NC}"
    while true; do
      read -p "> " VALIDATORS
      if [[ -n "$VALIDATORS" ]]; then
        if [ -f "$HOME/.env-aztec-agent" ]; then
          if grep -q "^VALIDATORS=" "$HOME/.env-aztec-agent"; then
            sed -i "s/^VALIDATORS=.*/VALIDATORS=\"$VALIDATORS\"/" "$HOME/.env-aztec-agent"
          else
            printf 'VALIDATORS="%s"\n' "$VALIDATORS" >> "$HOME/.env-aztec-agent"
          fi
        else
          printf 'VALIDATORS="%s"\n' "$VALIDATORS" > "$HOME/.env-aztec-agent"
        fi
        break
      else
        echo -e "${RED}$(t "validators_empty")${NC}"
      fi
    done
  fi

  mkdir -p "$AGENT_SCRIPT_PATH"

  # Security: Copy local error_definitions.json to agent directory to avoid remote downloads
  if [ -f "$SCRIPT_DIR/aztec-script-files/error_definitions.json" ]; then
    cp "$SCRIPT_DIR/aztec-script-files/error_definitions.json" "$HOME/aztec_error_definitions.json"
  fi

  # Генерация скрипта агента
  cat > "$AGENT_SCRIPT_PATH/agent.sh" <<EOF
#!/bin/bash
export PATH="\$PATH:\$HOME/.foundry/bin"
export FOUNDRY_DISABLE_NIGHTLY_WARNING=1

source \$HOME/.env-aztec-agent
CONTRACT_ADDRESS="$CONTRACT_ADDRESS"
CONTRACT_ADDRESS_MAINNET="$CONTRACT_ADDRESS_MAINNET"
FUNCTION_SIG="$FUNCTION_SIG"
TELEGRAM_BOT_TOKEN="$TELEGRAM_BOT_TOKEN"
TELEGRAM_CHAT_ID="$TELEGRAM_CHAT_ID"
LOG_FILE="$LOG_FILE"
LANG="$LANG"

# === Helper function to get network and RPC settings ===
get_network_settings() {
    local env_file="\$HOME/.env-aztec-agent"
    local network="testnet"
    local rpc_url=""

    if [[ -f "\$env_file" ]]; then
        source "\$env_file"
        [[ -n "\$NETWORK" ]] && network="\$NETWORK"
        if [[ -n "\$ALT_RPC" ]]; then
            rpc_url="\$ALT_RPC"
        elif [[ -n "\$RPC_URL" ]]; then
            rpc_url="\$RPC_URL"
        fi
    fi

    # Determine contract address based on network
    local contract_address="\$CONTRACT_ADDRESS"
    if [[ "\$network" == "mainnet" ]]; then
        contract_address="\$CONTRACT_ADDRESS_MAINNET"
    fi

    echo "\$network|\$rpc_url|\$contract_address"
}

# Получаем настройки сети
NETWORK_SETTINGS=\$(get_network_settings)
NETWORK=\$(echo "\$NETWORK_SETTINGS" | cut -d'|' -f1)
RPC_URL=\$(echo "\$NETWORK_SETTINGS" | cut -d'|' -f2)
CONTRACT_ADDRESS=\$(echo "\$NETWORK_SETTINGS" | cut -d'|' -f3)

# Security: Use local error definitions file instead of remote download to prevent supply chain attacks
ERROR_DEFINITIONS_FILE="\$HOME/aztec_error_definitions.json"

# Функция перевода
t() {
  local key=\$1
  local value1=\$2
  local value2=\$3

  case \$key in
    "log_cleaned") echo "$(t "agent_log_cleaned")" ;;
    "container_not_found") echo "$(t "agent_container_not_found")" ;;
    "block_fetch_error") echo "$(t "agent_block_fetch_error")" ;;
    "no_block_in_logs") echo "$(t "agent_no_block_in_logs")" ;;
    "failed_extract_block") echo "$(t "agent_failed_extract_block")" ;;
    "node_behind") printf "$(t "agent_node_behind")" "\$value1" ;;
    "agent_started") echo "$(t "agent_started")" ;;
    "log_size_warning") echo "$(t "agent_log_size_warning")" ;;
    "server_info") printf "$(t "agent_server_info")" "\$value1" ;;
    "file_info") printf "$(t "agent_file_info")" "\$value1" ;;
    "size_info") printf "$(t "agent_size_info")" "\$value1" ;;
    "rpc_info") printf "$(t "agent_rpc_info")" "\$value1" ;;
    "error_info") printf "$(t "agent_error_info")" "\$value1" ;;
    "block_info") printf "$(t "agent_block_info")" "\$value1" ;;
    "log_block_info") printf "$(t "agent_log_block_info")" "\$value1" ;;
    "time_info") printf "$(t "agent_time_info")" "\$value1" ;;
    "line_info") printf "$(t "agent_line_info")" "\$value1" ;;
    "notifications_info") echo "$(t "agent_notifications_info")" ;;
    "node_synced") printf "$(t "agent_node_synced")" "\$value1" ;;
    "critical_error_found") echo "$(t "critical_error_found")" ;;
    "error_prefix") echo "$(t "error_prefix")" ;;
    "solution_prefix") echo "$(t "solution_prefix")" ;;
    "notifications_full_info") echo "$(t "agent_notifications_full_info")" ;;
    "committee_selected") echo "$(t "committee_selected")" ;;
    "epoch_info") printf "$(t "epoch_info")" "\$value1" ;;
    "block_built") printf "$(t "block_built")" "\$value1" ;;
    "slot_info") printf "$(t "slot_info")" "\$value1" ;;
    "found_validators") printf "$(t "found_validators")" "\$value1" ;;
    "validators_prompt") echo "$(t "validators_prompt")" ;;
    "validators_format") echo "$(t "validators_format")" ;;
    "validators_empty") echo "$(t "validators_empty")" ;;
    "attestation_status") echo "$(t "attestation_status")" ;;
    "status_legend") echo "$(t "status_legend")" ;;
    "status_empty") echo "$(t "status_empty")" ;;
    "status_attestation_sent") echo "$(t "status_attestation_sent")" ;;
    "status_attestation_missed") echo "$(t "status_attestation_missed")" ;;
    "status_block_mined") echo "$(t "status_block_mined")" ;;
    "status_block_missed") echo "$(t "status_block_missed")" ;;
    "status_block_proposed") echo "$(t "status_block_proposed")" ;;
    "current_slot") printf "$(t "current_slot")" "\$value1" ;;
    "publisher_balance_warning") echo "$(t "publisher_balance_warning")" ;;
    *) echo "\$key" ;;
  esac
}

# === Создание файла лога, если его нет ===
if [ ! -f "\$LOG_FILE" ]; then
  touch "\$LOG_FILE" 2>/dev/null || {
    echo "Error: Could not create log file \$LOG_FILE"
    exit 1
  }
fi

if [ ! -w "\$LOG_FILE" ]; then
  echo "Error: No write permission for \$LOG_FILE"
  exit 1
fi

# === Проверка размера файла и очистка, если больше 1 МБ ===
# Устанавливаем MAX_SIZE в зависимости от DEBUG
# Если DEBUG=true, то MAX_SIZE=10 МБ (10485760 байт)
# Если DEBUG=false или не установлен, то MAX_SIZE=1 МБ (1048576 байт)
if [ -n "\$DEBUG" ]; then
  debug_value=\$(echo "\$DEBUG" | tr '[:upper:]' '[:lower:]' | tr -d '"' | tr -d "'")
  if [ "\$debug_value" = "true" ] || [ "\$debug_value" = "1" ] || [ "\$debug_value" = "yes" ]; then
    MAX_SIZE=10485760  # 10 МБ
  else
    MAX_SIZE=1048576   # 1 МБ
  fi
else
  MAX_SIZE=1048576    # 1 МБ по умолчанию
fi

current_size=\$(stat -c%s "\$LOG_FILE")

if [ "\$current_size" -gt "\$MAX_SIZE" ]; then
  temp_file=\$(mktemp)
  if grep -q "INITIALIZED" "\$LOG_FILE"; then
    awk '/INITIALIZED/ {print; exit} {print}' "\$LOG_FILE" > "\$temp_file"
  else
    head -n 8 "\$LOG_FILE" > "\$temp_file"
  fi
  mv "\$temp_file" "\$LOG_FILE"
  chmod 644 "\$LOG_FILE"

  {
    echo ""
    echo "\$(t "log_cleaned")"
    echo "Cleanup completed: \$(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
  } >> "\$LOG_FILE"

  ip=\$(curl -s https://api.ipify.org || echo "unknown-ip")
  current_time=\$(date '+%Y-%m-%d %H:%M:%S')
  message="\$(t "log_size_warning")%0A\$(t "server_info" "\$ip")%0A\$(t "file_info" "\$LOG_FILE")%0A\$(t "size_info" "\$current_size")%0A\$(t "time_info" "\$current_time")"

  curl -s -X POST "https://api.telegram.org/bot\$TELEGRAM_BOT_TOKEN/sendMessage" \\
    -d chat_id="\$TELEGRAM_CHAT_ID" \\
    -d text="\$message" \\
    -d parse_mode="Markdown" >/dev/null
else
  {
    echo "="
    echo "Log size check"
    echo "Current size: \$current_size bytes (within limit)."
    echo "Check timestamp: \$(date '+%Y-%m-%d %H:%M:%S')"
    echo "="
  } >> "\$LOG_FILE"
fi

# === Функция для записи в лог-файл ===
log() {
  echo "[\$(date '+%Y-%m-%d %H:%M:%S')] \$1" >> "\$LOG_FILE"
}

# === Функция для отправки уведомлений в Telegram ===
send_telegram_message() {
  local message="\$1"
  curl -s -X POST "https://api.telegram.org/bot\$TELEGRAM_BOT_TOKEN/sendMessage" \\
    -d chat_id="\$TELEGRAM_CHAT_ID" \\
    -d text="\$message" \\
    -d parse_mode="Markdown" >/dev/null
}

# === Helper: send Telegram message and return message_id ===
send_telegram_message_get_id() {
  local message="\$1"
  local resp
  resp=\$(curl -s -X POST "https://api.telegram.org/bot\$TELEGRAM_BOT_TOKEN/sendMessage" \\
    -d chat_id="\$TELEGRAM_CHAT_ID" \\
    -d text="\$message" \\
    -d parse_mode="Markdown")
  echo "\$resp" | jq -r '.result.message_id'
}

# === Helper: edit Telegram message by message_id ===
edit_telegram_message() {
  local message_id="\$1"
  local text="\$2"
  curl -s -X POST "https://api.telegram.org/bot\$TELEGRAM_BOT_TOKEN/editMessageText" \\
    -d chat_id="\$TELEGRAM_CHAT_ID" \\
    -d message_id="\$message_id" \\
    -d text="\$text" \\
    -d parse_mode="Markdown" >/dev/null
}

# === Helper: build a 32-slot board (8 per line) ===
build_slots_board() {
  # expects 32 items passed as args (each is an emoji)
  local slots=("\$@")
  local out=""
  for i in {0..31}; do
    out+="\${slots[\$i]}"
    if [ \$(((i+1)%8)) -eq 0 ]; then
      out+="%0A"
    fi
  done
  echo "\$out"
}

# === Получаем свой публичный IP для включения в уведомления ===
get_ip_address() {
  curl -s https://api.ipify.org || echo "unknown-ip"
}
ip=\$(get_ip_address)

# === Переводим hex -> decimal ===
hex_to_dec() {
  local hex=\$1
  hex=\${hex#0x}
  hex=\$(echo \$hex | sed 's/^0*//')
  [ -z "\$hex" ] && echo 0 && return
  echo \$((16#\$hex))
}

# === Проверка критических ошибок в логах ===
check_critical_errors() {
  local container_id=\$1
  local clean_logs=\$(docker logs "\$container_id" --tail 10000 2>&1 | sed -r 's/\x1B\[[0-9;]*[A-Za-z]//g')

  # Используем локальный JSON файл с определениями ошибок (безопасность: избегаем удалённых загрузок)
  if [ ! -f "\$ERROR_DEFINITIONS_FILE" ]; then
    log "Error definitions file not found at \$ERROR_DEFINITIONS_FILE"
    return
  fi

  # Парсим JSON с ошибками
  errors_count=\$(jq '. | length' "\$ERROR_DEFINITIONS_FILE")
  for ((i=0; i<\$errors_count; i++)); do
    pattern=\$(jq -r ".[\$i].pattern" "\$ERROR_DEFINITIONS_FILE")
    message=\$(jq -r ".[\$i].message" "\$ERROR_DEFINITIONS_FILE")
    solution=\$(jq -r ".[\$i].solution" "\$ERROR_DEFINITIONS_FILE")

    if echo "\$clean_logs" | grep -q "\$pattern"; then
      log "Critical error detected: \$pattern"
      current_time=\$(date '+%Y-%m-%d %H:%M:%S')
      full_message="\$(t "critical_error_found")%0A\$(t "server_info" "\$ip")%0A\$(t "error_prefix") \$message%0A\$(t "solution_prefix")%0A\$solution%0A\$(t "time_info" "\$current_time")"
      send_telegram_message "\$full_message"
      exit 1
    fi
  done
}

# === Оптимизированная функция для поиска строк в логах ===
find_last_log_line() {
  local container_id=\$1
  local temp_file=\$(mktemp)

  # Получаем логи с ограничением по объему и сразу фильтруем нужные строки
  docker logs "\$container_id" --tail 20000 2>&1 | \
    sed -r 's/\x1B\[[0-9;]*[A-Za-z]//g' | \
    grep -E 'Sequencer sync check succeeded|Downloaded L2 block' | \
    tail -100 > "\$temp_file"

  # Сначала ищем Sequencer sync check succeeded
  local line=\$(tac "\$temp_file" | grep -m1 'Sequencer sync check succeeded')

  # Если не нашли, ищем Downloaded L2 block
  if [ -z "\$line" ]; then
    line=\$(tac "\$temp_file" | grep -m1 'Downloaded L2 block')
  fi

  rm -f "\$temp_file"
  echo "\$line"
}

# === Функция для проверки и добавления переменной DEBUG ===
ensure_debug_variable() {
  local env_file="\$HOME/.env-aztec-agent"
  if [ ! -f "\$env_file" ]; then
    return
  fi

  # Проверяем, существует ли уже переменная DEBUG
  if ! grep -q "^DEBUG=" "\$env_file"; then
    # Добавляем DEBUG переменную в конец файла
    echo "DEBUG=false" >> "\$env_file"
    log "Added DEBUG variable to \$env_file"
  fi
}

# Вызываем функцию при загрузке скрипта
ensure_debug_variable

# === Функция для проверки отладочного режима ===
is_debug_enabled() {
  if [ ! -f "\$HOME/.env-aztec-agent" ]; then
    return 1
  fi

  # Загружаем только переменную DEBUG
  debug_value=\$(grep "^DEBUG=" "\$HOME/.env-aztec-agent" | cut -d'=' -f2 | tr -d '"' | tr -d "'" | tr '[:upper:]' '[:lower:]')

  if [ "\$debug_value" = "true" ] || [ "\$debug_value" = "1" ] || [ "\$debug_value" = "yes" ]; then
    return 0
  else
    return 1
  fi
}

# === Функция для отладочного логирования ===
debug_log() {
  if is_debug_enabled; then
    log "DEBUG: \$1"
  fi
}

# === Новая версия функции для проверки комитета и статусов ===
check_committee() {
  debug_log "check_committee started. NOTIFICATION_TYPE=\$NOTIFICATION_TYPE"

  if [ "\$NOTIFICATION_TYPE" -ne 2 ]; then
    debug_log "NOTIFICATION_TYPE != 2, skipping committee check"
    return
  fi

  # Загружаем список валидаторов
  if [ ! -f "\$HOME/.env-aztec-agent" ]; then
    log "Validator file \$HOME/.env-aztec-agent not found"
    return
  fi

  source \$HOME/.env-aztec-agent
  if [ -z "\$VALIDATORS" ]; then
    log "No validators defined in VALIDATORS variable"
    return
  fi

  IFS=',' read -ra VALIDATOR_ARRAY <<< "\$VALIDATORS"
  debug_log "Validators loaded: \${VALIDATOR_ARRAY[*]}"

  container_id=\$(docker ps --format "{{.ID}} {{.Names}}" | grep aztec | grep -vE 'watchtower|otel|prometheus|grafana' | head -n 1 | awk '{print \$1}')
  if [ -z "\$container_id" ]; then
    debug_log "No aztec container found"
    return
  fi
  debug_log "Container ID: \$container_id"

  # --- Получаем данные о комитете ---
  committee_line=\$(docker logs "\$container_id" --tail 20000 2>&1 | grep -a "Computing stats for slot" | tail -n 1)
  [ -z "\$committee_line" ] && { debug_log "No committee line found in logs"; return; }
  debug_log "Committee line found: \$committee_line"

  json_part=\$(echo "\$committee_line" | sed -n 's/.*\({.*}\).*/\1/p')
  [ -z "\$json_part" ] && { debug_log "No JSON part extracted"; return; }
  debug_log "JSON part: \$json_part"

  epoch=\$(echo "\$json_part" | jq -r '.epoch')
  slot=\$(echo "\$json_part" | jq -r '.slot')
  committee=\$(echo "\$json_part" | jq -r '.committee[]')

  if [ -z "\$epoch" ] || [ -z "\$slot" ] || [ -z "\$committee" ]; then
    debug_log "Missing epoch/slot/committee data. epoch=\$epoch, slot=\$slot, committee=\$committee"
    return
  fi
  debug_log "Epoch=\$epoch, Slot=\$slot, Committee=\$committee"

  found_validators=()
  committee_validators=()
  for validator in "\${VALIDATOR_ARRAY[@]}"; do
    validator_lower=\$(echo "\$validator" | tr '[:upper:]' '[:lower:]')
    if echo "\$committee" | grep -qi "\$validator_lower"; then
      # Формируем ссылку в зависимости от сети
      if [[ "\$NETWORK" == "mainnet" ]]; then
        validator_link="[\$validator](https://dashtec.xyz/validators/\$validator)"
      else
        validator_link="[\$validator](https://\${NETWORK}.dashtec.xyz/validators/\$validator)"
      fi
      found_validators+=("\$validator_link")
      committee_validators+=("\$validator_lower")
      debug_log "Validator \$validator found in committee"
    fi
  done

  # Если не нашли валидаторов в комитете - выходим
  if [ \${#found_validators[@]} -eq 0 ]; then
    debug_log "No validators found in committee"
    return
  fi
  debug_log "Found validators: \${found_validators[*]}"

  # === Уведомление о включении в комитет (раз за эпоху) ===
  last_epoch_file="$AGENT_SCRIPT_PATH/aztec_last_committee_epoch"
  if [ ! -f "\$last_epoch_file" ] || ! grep -q "\$epoch" "\$last_epoch_file"; then
    current_time=\$(date '+%Y-%m-%d %H:%M:%S')
    echo "\$epoch" > "\$last_epoch_file"
    # Для каждого валидатора создаём отдельное сообщение и отдельное состояние из 32 слотов
    for idx in "\${!committee_validators[@]}"; do
      v_lower="\${committee_validators[\$idx]}"
      v_link="\${found_validators[\$idx]}"
      epoch_state_file="$AGENT_SCRIPT_PATH/epoch_\${epoch}_\${v_lower}_slots_state"
      epoch_msg_file="$AGENT_SCRIPT_PATH/epoch_\${epoch}_\${v_lower}_message_id"
      # initialize 32 empty slots
      slots_arr=()
      for i in {0..31}; do slots_arr+=("⬜️"); done
      board=\$(build_slots_board "\${slots_arr[@]}")
      committee_message="\$(t "committee_selected") (\$(t "epoch_info" "\$epoch"))!%0A"
      committee_message+="%0A\$(t "found_validators" "\$v_link")%0A"
      committee_message+="%0A\$(t "current_slot" "0")%0A"
      committee_message+="%0ASlots:%0A\${board}%0A"
      committee_message+="%0A\$(t "status_legend")%0A"
      committee_message+="\$(t "status_empty")%0A"
      committee_message+="\$(t "status_attestation_sent")%0A"
      committee_message+="\$(t "status_attestation_missed")%0A"
      committee_message+="\$(t "status_block_mined")%0A"
      committee_message+="\$(t "status_block_missed")%0A"
      committee_message+="\$(t "status_block_proposed")%0A"
      committee_message+="%0A\$(t "server_info" "\$ip")%0A"
      committee_message+="\$(t "time_info" "\$current_time")"

      debug_log "Sending committee message for validator \$v_lower: \$committee_message"
      message_id=\$(send_telegram_message_get_id "\$committee_message")
      if [ -n "\$message_id" ] && [ "\$message_id" != "null" ]; then
        echo "\$message_id" > "\$epoch_msg_file"
      fi
      printf "%s " "\${slots_arr[@]}" > "\$epoch_state_file"
      # Очистим файл учета слотов для этого валидатора
      : > "$AGENT_SCRIPT_PATH/aztec_last_committee_slot_\${v_lower}"
    done
    log "Committee selection notification sent for epoch \$epoch: found validators \${found_validators[*]}"
  else
    debug_log "Already notified for epoch \$epoch"
  fi

  # === Уведомление о статусах аттестаций (обновление отдельных сообщений по каждому валидатору) ===
  last_slot_key="\${epoch}_\${slot}"

  # Проверяем, что слот принадлежит текущей эпохе (очищенной при смене эпохи)
  current_epoch=\$(cat "\$last_epoch_file" 2>/dev/null)
  if [ -n "\$current_epoch" ] && [ "\$epoch" != "\$current_epoch" ]; then
    debug_log "Slot \$slot belongs to epoch \$epoch, but current epoch is \$current_epoch - skipping"
    return
  fi

  activity_line=\$(docker logs "\$container_id" --tail 20000 2>&1 | grep -a "Updating L2 slot \$slot observed activity" | tail -n 1)
  if [ -n "\$activity_line" ]; then
    debug_log "Activity line found: \$activity_line"
    activity_json=\$(echo "\$activity_line" | sed 's/.*observed activity //')

    # Обрабатываем каждого валидатора отдельно
    for idx in "\${!committee_validators[@]}"; do
      v_lower="\${committee_validators[\$idx]}"
      v_link="\${found_validators[\$idx]}"

      last_slot_file="$AGENT_SCRIPT_PATH/aztec_last_committee_slot_\${v_lower}"
      # Пропускаем если уже обработали этот слот для данного валидатора
      if [ -f "\$last_slot_file" ] && grep -q "\$last_slot_key" "\$last_slot_file"; then
        debug_log "Already processed slot \$last_slot_key for \$v_lower"
        continue
      fi

      epoch_state_file="$AGENT_SCRIPT_PATH/epoch_\${epoch}_\${v_lower}_slots_state"
      epoch_msg_file="$AGENT_SCRIPT_PATH/epoch_\${epoch}_\${v_lower}_message_id"
      if [ ! -f "\$epoch_state_file" ]; then
        slots_arr=()
        for i in {0..31}; do slots_arr+=("⬜️"); done
        printf "%s " "\${slots_arr[@]}" > "\$epoch_state_file"
      fi
      read -ra slots_arr < "\$epoch_state_file"

      slot_idx=\$((slot % 32))
      slot_icon=""
      if [ -n "\$activity_json" ]; then
        status=\$(echo "\$activity_json" | jq -r ".\"\$v_lower\"")
        if [ "\$status" != "null" ] && [ -n "\$status" ]; then
          case "\$status" in
            block-proposed) slot_icon="🟪" ;;
            block-mined)    slot_icon="🟦" ;;
            block-missed)   slot_icon="🟨" ;;
            attestation-missed) slot_icon="🟥" ;;
            attestation-sent)   slot_icon="🟩" ;;
          esac
        fi
      fi

      if [ -n "\$slot_icon" ]; then
        slots_arr[\$slot_idx]="\$slot_icon"
        printf "%s " "\${slots_arr[@]}" > "\$epoch_state_file"

        board=\$(build_slots_board "\${slots_arr[@]}")
        current_time=\$(date '+%Y-%m-%d %H:%M:%S')
        updated_message="\$(t "committee_selected") (\$(t "epoch_info" "\$epoch"))!%0A"
        updated_message+="%0A\$(t "found_validators" "\$v_link")%0A"
        updated_message+="%0A\$(t "current_slot" "\$slot")%0A"
        updated_message+="%0ASlots:%0A\${board}%0A"
        updated_message+="%0A\$(t "status_legend")%0A"
        updated_message+="\$(t "status_empty")%0A"
        updated_message+="\$(t "status_attestation_sent")%0A"
        updated_message+="\$(t "status_attestation_missed")%0A"
        updated_message+="\$(t "status_block_mined")%0A"
        updated_message+="\$(t "status_block_missed")%0A"
        updated_message+="\$(t "status_block_proposed")%0A"
        updated_message+="%0A\$(t "server_info" "\$ip")%0A"
        updated_message+="\$(t "time_info" "\$current_time")"

        if [ -f "\$epoch_msg_file" ]; then
          message_id=\$(cat "\$epoch_msg_file")
          if [ -n "\$message_id" ]; then
            debug_log "Editing committee message (id=\$message_id) for epoch \$epoch, slot \$slot, validator \$v_lower"
            edit_telegram_message "\$message_id" "\$updated_message"
          else
            debug_log "Message id missing; sending a fallback message"
            send_telegram_message "\$updated_message"
          fi
        else
          debug_log "Message id file not found; sending a fallback message"
          send_telegram_message "\$updated_message"
        fi

        echo "\$last_slot_key" >> "\$last_slot_file"
        debug_log "Updated slot \$slot_idx for epoch \$epoch with icon \$slot_icon for \$v_lower"
        log "Updated committee stats for epoch \$epoch, slot \$slot, validator \$v_lower"
      else
        debug_log "No mapped status for slot \$slot for \$v_lower"
      fi
    done
  else
    debug_log "No activity line found for slot \$slot"
  fi
}

# === Основная функция: проверка контейнера и сравнение блоков ===
check_blocks() {
  debug_log "check_blocks started at \$(date)"

  container_id=\$(docker ps --format "{{.ID}} {{.Names}}" | grep aztec | grep -vE 'watchtower|otel|prometheus|grafana' | head -n 1 | awk '{print \$1}')
  if [ -z "\$container_id" ]; then
    log "Container 'aztec' not found."
    current_time=\$(date '+%Y-%m-%d %H:%M:%S')
    message="\$(t "container_not_found")%0A\$(t "server_info" "\$ip")%0A\$(t "time_info" "\$current_time")"
    debug_log "Sending container not found message"
    send_telegram_message "\$message"
    exit 1
  fi
  debug_log "Container found: \$container_id"

  # Проверка критических ошибок
  check_critical_errors "\$container_id"

  # Получаем текущий блок из контракта
  debug_log "Getting block from contract: \$CONTRACT_ADDRESS"
  debug_log "Using RPC: \$RPC_URL"
  debug_log "Using RPC: \$FUNCTION_SIG"
  debug_log "Command: \$(cast call "\$CONTRACT_ADDRESS" "\$FUNCTION_SIG" --rpc-url "\$RPC_URL" 2>&1)"
  # Выполняем cast call и фильтруем предупреждения, оставляя только hex-значение
  # Фильтруем строки, начинающиеся с "Warning:", и извлекаем hex-значение (0x...)
  block_hex=\$(cast call "\$CONTRACT_ADDRESS" "\$FUNCTION_SIG" --rpc-url "\$RPC_URL" 2>&1 | grep -vE '^Warning:' | grep -oE '0x[0-9a-fA-F]+' | head -1)
  if [[ "\$block_hex" == *"Error"* || -z "\$block_hex" ]]; then
    log "Block Fetch Error. Check RPC or cast: \$block_hex"
    current_time=\$(date '+%Y-%m-%d %H:%M:%S')
    message="\$(t "block_fetch_error")%0A\$(t "server_info" "\$ip")%0A\$(t "rpc_info" "\$RPC_URL")%0A\$(t "error_info" "\$block_hex")%0A\$(t "time_info" "\$current_time")"
    debug_log "Sending block fetch error message"
    send_telegram_message "\$message"
    exit 1
  fi

  # Конвертируем hex-значение в десятичный
  block_number=\$(hex_to_dec "\$block_hex")
  log "Contract block: \$block_number"

  # Получаем последнюю релевантную строку из логов
  latest_log_line=\$(find_last_log_line "\$container_id")
  debug_log "Latest log line: \$latest_log_line"

  if [ -z "\$latest_log_line" ]; then
    log "No suitable block line found in logs"
    current_time=\$(date '+%Y-%m-%d %H:%M:%S')
    message="\$(t "no_block_in_logs")%0A\$(t "server_info" "\$ip")%0A\$(t "block_info" "\$block_number")%0A\$(t "time_info" "\$current_time")"
    debug_log "Sending no block in logs message"
    send_telegram_message "\$message"
    exit 1
  fi

  # Извлекаем номер блока из найденной строки
  if grep -q 'Sequencer sync check succeeded' <<<"\$latest_log_line"; then
    # формат: ..."worldState":{"number":18254,...
    log_block_number=\$(echo "\$latest_log_line" | grep -o '"worldState":{"number":[0-9]\+' | grep -o '[0-9]\+$')
    debug_log "Extracted from worldState: \$log_block_number"
  else
    # формат: ..."blockNumber":18254,...
    log_block_number=\$(echo "\$latest_log_line" | grep -o '"blockNumber":[0-9]\+' | head -n1 | cut -d':' -f2)
    debug_log "Extracted from blockNumber: \$log_block_number"
  fi

  if [ -z "\$log_block_number" ]; then
    log "Failed to extract blockNumber from line: \$latest_log_line"
    current_time=\$(date '+%Y-%m-%d %H:%M:%S')
    message="\$(t "failed_extract_block")%0A\$(t "server_info" "\$ip")%0A\$(t "line_info" "\$latest_log_line")%0A\$(t "time_info" "\$current_time")"
    debug_log "Sending failed extract block message"
    send_telegram_message "\$message"
    exit 1
  fi

  log "Latest log block: \$log_block_number"

  # Сравниваем блоки
  if [ "\$log_block_number" -eq "\$block_number" ]; then
    status="\$(t "node_synced" "\$block_number")"
  else
    blocks_diff=\$((block_number - log_block_number))
    status="\$(t "node_behind" "\$blocks_diff")"
    if [ "\$blocks_diff" -gt 3 ]; then
      current_time=\$(date '+%Y-%m-%d %H:%M:%S')
      message="\$(t "node_behind" "\$blocks_diff")%0A\$(t "server_info" "\$ip")%0A\$(t "block_info" "\$block_number")%0A\$(t "log_block_info" "\$log_block_number")%0A\$(t "time_info" "\$current_time")"
      debug_log "Sending node behind message, diff=\$blocks_diff"
      send_telegram_message "\$message"
    fi
  fi

  log "Status: \$status (logs: \$log_block_number, contract: \$block_number)"

  if [ ! -f "\$LOG_FILE.initialized" ]; then
    current_time=\$(date '+%Y-%m-%d %H:%M:%S')

    if [ "\$NOTIFICATION_TYPE" -eq 2 ]; then
      # Полные уведомления (все включено)
      message="\$(t "agent_started")%0A\$(t "server_info" "\$ip")%0A\$status%0A\$(t "notifications_full_info")%0A\$(t "time_info" "\$current_time")"
    else
      # Только критические уведомления
      message="\$(t "agent_started")%0A\$(t "server_info" "\$ip")%0A\$status%0A\$(t "notifications_info")%0A\$(t "time_info" "\$current_time")"
    fi

    debug_log "Sending initialization message"
    send_telegram_message "\$message"
    touch "\$LOG_FILE.initialized"
    echo "v.\$VERSION" >> "\$LOG_FILE"
    echo "INITIALIZED" >> "\$LOG_FILE"
  fi

   # Дополнительные проверки (только если NOTIFICATION_TYPE == 2)
  if [ "\$NOTIFICATION_TYPE" -eq 2 ]; then
    debug_log "Starting committee check"
    check_committee
  else
    debug_log "Skipping committee check (NOTIFICATION_TYPE=\$NOTIFICATION_TYPE)"
  fi

  debug_log "check_blocks completed at \$(date)"
}

# === Function to check publisher balances ===
check_publisher_balances() {
  # Check if monitoring is enabled
  if [ ! -f "\$HOME/.env-aztec-agent" ]; then
    return
  fi

  source \$HOME/.env-aztec-agent

  # Check if monitoring is enabled
  if [ -z "\$MONITORING_PUBLISHERS" ] || [ "\$MONITORING_PUBLISHERS" != "true" ]; then
    debug_log "Publisher balance monitoring is disabled"
    return
  fi

  # Check if publishers are defined
  if [ -z "\$PUBLISHERS" ]; then
    debug_log "No publishers defined for balance monitoring"
    return
  fi

  # Get minimum balance threshold (default 0.15 ETH)
  local min_balance="0.15"
  if [ -n "\$MIN_BALANCE_FOR_WARNING" ]; then
    min_balance="\$MIN_BALANCE_FOR_WARNING"
  fi

  # Get RPC URL from environment
  if [ -z "\$RPC_URL" ]; then
    debug_log "RPC_URL not set, cannot check publisher balances"
    return
  fi

  debug_log "Checking publisher balances (threshold: \$min_balance ETH)"

  # Parse publisher addresses
  IFS=',' read -ra PUBLISHER_ARRAY <<< "\$PUBLISHERS"
  local low_balance_addresses=()
  local low_balance_values=()

  for publisher in "\${PUBLISHER_ARRAY[@]}"; do
    publisher=\$(echo "\$publisher" | xargs | tr '[:upper:]' '[:lower:]') # trim and lowercase
    if [ -z "\$publisher" ]; then
      continue
    fi

    debug_log "Checking balance for publisher: \$publisher"

    # Get balance using cast
    local balance_wei=\$(cast balance "\$publisher" --rpc-url "\$RPC_URL" 2>/dev/null)
    if [ -z "\$balance_wei" ] || [[ "\$balance_wei" == *"Error"* ]]; then
      log "Failed to get balance for publisher \$publisher: \$balance_wei"
      continue
    fi

    # Convert wei to ETH (1 ETH = 10^18 wei)
    # Use awk for reliable formatting with leading zero
    local balance_eth=\$(awk -v wei="\$balance_wei" "BEGIN {printf \"%.6f\", wei / 1000000000000000000}")

    debug_log "Publisher \$publisher balance: \$balance_eth ETH"

    # Compare with threshold
    if awk -v balance="\$balance_eth" -v threshold="\$min_balance" "BEGIN {exit !(balance < threshold)}"; then
      low_balance_addresses+=("\$publisher")
      low_balance_values+=("\$balance_eth")
      log "Low balance detected for publisher \$publisher: \$balance_eth ETH (threshold: \$min_balance ETH)"
    fi
  done

  # Send notification if any addresses have low balance
  if [ \${#low_balance_addresses[@]} -gt 0 ]; then
    current_time=\$(date '+%Y-%m-%d %H:%M:%S')
    # Define backtick character for Markdown formatting
    BT='\`'
    message="\$(t "publisher_balance_warning")%0A%0A"
    for idx in "\${!low_balance_addresses[@]}"; do
      addr="\${low_balance_addresses[\$idx]}"
      bal="\${low_balance_values[\$idx]}"
      # Format: Address in monospace (copyable), Balance on new line
      # Use backticks for Markdown monospace formatting in Telegram
      message+="\${BT}\$addr\${BT}%0ABalance: \$bal ETH%0A%0A"
    done
    message+="\$(t "server_info" "\$ip")%0A"
    message+="\$(t "time_info" "\$current_time")"
    send_telegram_message "\$message"
  else
    debug_log "All publisher balances are above threshold"
  fi
}

# Check publisher balances if monitoring is enabled
check_publisher_balances

check_blocks
EOF

  chmod +x "$AGENT_SCRIPT_PATH/agent.sh"

  # Функция для валидации и очистки файла окружения для systemd
  validate_and_clean_env_file() {
    local env_file="$1"
    local temp_file=$(mktemp)

    sed 's/\r$//' "$env_file" | \
      sed 's/\r/\n/g' | \
      sed 's/\.\([A-Z_]\)/\n\1/g' | \
      sed 's/\.$/\n/' > "${temp_file}.normalized"

    while IFS= read -r line || [ -n "$line" ]; do

      line=$(printf '%s\n' "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -d '\r' | sed 's/\.$//' | sed 's/^\.//')

      [[ -z "$line" ]] && continue

      [[ "$line" =~ ^# ]] && continue

      if [[ "$line" =~ = ]]; then
        local key=$(printf '%s\n' "$line" | cut -d'=' -f1 | sed 's/[[:space:]]*$//' | tr -d '\r')
        local value=$(printf '%s\n' "$line" | cut -d'=' -f2- | sed 's/^[[:space:]]*//' | tr -d '\r')

        [[ -z "$key" ]] && continue

        if [[ "$key" =~ ^[A-Za-z_] ]]; then
          if [[ -z "$value" ]]; then
            printf '%s\n' "${key}=" >> "$temp_file"
          else
            if [[ "$value" =~ ^\".*\"$ ]] || [[ "$value" =~ ^\'.*\'$ ]]; then
              printf '%s\n' "${key}=${value}" >> "$temp_file"
            elif [[ "$value" =~ [[:space:]] ]] || [[ "$value" =~ [^A-Za-z0-9_./-] ]] || [[ "$value" =~ ^[0-9] ]]; then
              value=$(printf '%s\n' "$value" | sed 's/"/\\"/g')
              printf '%s\n' "${key}=\"${value}\"" >> "$temp_file"
            else
              printf '%s\n' "${key}=${value}" >> "$temp_file"
            fi
          fi
        fi
      fi
    done < "${temp_file}.normalized"

    if [ -s "$temp_file" ]; then
      sed 's/\r$//' "$temp_file" | sed -e '$a\' > "${temp_file}.final"
      mv "${temp_file}.final" "$temp_file"
    fi

    mv "$temp_file" "$env_file"
    chmod 600 "$env_file"
    rm -f "${temp_file}.normalized"
  }

  validate_and_clean_env_file "$env_file"

  if [ ! -s "$env_file" ]; then
    echo -e "\n${RED}Error: Environment file is empty or invalid${NC}"
    return 1
  fi

  if ! grep -qE '^[A-Za-z_][A-Za-z0-9_]*=' "$env_file"; then
    echo -e "\n${RED}Error: Environment file does not contain valid variables${NC}"
    return 1
  fi

  env_file=$(readlink -f "$env_file" 2>/dev/null || realpath "$env_file" 2>/dev/null || echo "$env_file")
  if [[ ! "$env_file" =~ ^/ ]]; then
    env_file="$HOME/.env-aztec-agent"
  fi

  if [ ! -r "$env_file" ]; then
    echo -e "\n${RED}Error: Environment file $env_file does not exist or is not readable${NC}"
    return 1
  fi

  local agent_script_path=$(readlink -f "$AGENT_SCRIPT_PATH/agent.sh" 2>/dev/null || realpath "$AGENT_SCRIPT_PATH/agent.sh" 2>/dev/null || echo "$AGENT_SCRIPT_PATH/agent.sh")
  if [[ ! "$agent_script_path" =~ ^/ ]]; then
    agent_script_path="$HOME/aztec-monitor-agent/agent.sh"
  fi

  local working_dir=$(readlink -f "$AGENT_SCRIPT_PATH" 2>/dev/null || realpath "$AGENT_SCRIPT_PATH" 2>/dev/null || echo "$AGENT_SCRIPT_PATH")
  if [[ ! "$working_dir" =~ ^/ ]]; then
    working_dir="$HOME/aztec-monitor-agent"
  fi

  if [ ! -f "$agent_script_path" ]; then
    echo -e "\n${RED}Error: Agent script $agent_script_path does not exist${NC}"
    return 1
  fi

  {
    printf '[Unit]\n'
    printf 'Description=Aztec Monitoring Agent\n'
    printf 'After=network.target\n'
    printf '\n'
    printf '[Service]\n'
    printf 'Type=oneshot\n'
    printf 'EnvironmentFile=%s\n' "$env_file"
    printf 'ExecStart=%s\n' "$agent_script_path"
    printf 'User=root\n'
    printf 'WorkingDirectory=%s\n' "$working_dir"
    printf 'LimitNOFILE=65535\n'
    printf '\n'
    printf '[Install]\n'
    printf 'WantedBy=multi-user.target\n'
  } > /etc/systemd/system/aztec-agent.service

  sed -i 's/\r$//' /etc/systemd/system/aztec-agent.service

  {
    printf '[Unit]\n'
    printf 'Description=Run Aztec Agent every 37 seconds\n'
    printf 'Requires=aztec-agent.service\n'
    printf '\n'
    printf '[Timer]\n'
    printf 'OnBootSec=37\n'
    printf 'OnUnitActiveSec=37\n'
    printf 'AccuracySec=1us\n'
    printf '\n'
    printf '[Install]\n'
    printf 'WantedBy=timers.target\n'
  } > /etc/systemd/system/aztec-agent.timer

  sed -i 's/\r$//' /etc/systemd/system/aztec-agent.timer

  if ! systemd-analyze verify /etc/systemd/system/aztec-agent.service 2>/dev/null; then
    echo -e "\n${YELLOW}Warning: systemd-analyze verify failed, but continuing...${NC}"
  fi

  # Активируем и запускаем timer
  if ! systemctl daemon-reload; then
    echo -e "\n${RED}Error: Failed to reload systemd daemon${NC}"
    return 1
  fi

  # Проверяем, что сервис может быть загружен
  if ! systemctl show aztec-agent.service &>/dev/null; then
    echo -e "\n${RED}Error: Failed to load aztec-agent.service${NC}"
    echo -e "${YELLOW}Checking service file syntax...${NC}"
    systemctl cat aztec-agent.service 2>&1 | head -20
    return 1
  fi

  if ! systemctl enable aztec-agent.timer; then
    echo -e "\n${RED}Error: Failed to enable aztec-agent.timer${NC}"
    return 1
  fi

  if ! systemctl start aztec-agent.timer; then
    echo -e "\n${RED}Error: Failed to start aztec-agent.timer${NC}"
    systemctl status aztec-agent.timer --no-pager
    return 1
  fi

  # Проверяем статус
  if systemctl is-active --quiet aztec-agent.timer; then
    echo -e "\n${GREEN}$(t "agent_systemd_added")${NC}"
    echo -e "${GREEN}$(t "agent_timer_status")$(systemctl status aztec-agent.timer --no-pager -q | grep Active)${NC}"
  else
    echo -e "\n${RED}$(t "agent_timer_error")${NC}"
    systemctl status aztec-agent.timer --no-pager
    return 1
  fi
}

# === Remove cron task and agent ===
remove_cron_agent() {
  echo -e "\n${BLUE}$(t "removing_agent")${NC}"
  crontab -l 2>/dev/null | grep -v "$AGENT_SCRIPT_PATH/agent.sh" | crontab -
  rm -rf "$AGENT_SCRIPT_PATH"
  echo -e "\n${GREEN}$(t "agent_removed")${NC}"
}

# === Remove systemd task and agent ===
remove_systemd_agent() {
  echo -e "\n${BLUE}$(t "removing_systemd_agent")${NC}"
  systemctl stop aztec-agent.timer
  systemctl disable aztec-agent.timer
  rm /etc/systemd/system/aztec-agent.*
  rm -rf "$AGENT_SCRIPT_PATH"
  echo -e "\n${GREEN}$(t "agent_systemd_removed")${NC}"
}

# === Publisher Balance Monitoring Management ===
manage_publisher_balance_monitoring() {
  local env_file
  env_file=$(_ensure_env_file)
  source "$env_file"

  echo -e "\n${BLUE}$(t "publisher_monitoring_title")${NC}"
  echo -e "\n${NC}$(t "publisher_monitoring_option1")${NC}"
  echo -e "${NC}$(t "publisher_monitoring_option2")${NC}"
  echo -e "${NC}$(t "publisher_monitoring_option3")${NC}"

  while true; do
    echo ""
    read -p "$(t "publisher_monitoring_choose") " choice
    case "$choice" in
      1)
        # Configure balance monitoring
        echo -e "\n${BLUE}$(t "publisher_addresses_prompt")${NC}"
        echo -e "${YELLOW}$(t "publisher_addresses_format")${NC}"
        while true; do
          read -p "> " PUBLISHERS
          if [[ -n "$PUBLISHERS" ]]; then
            # Validate addresses format (basic check for 0x prefix)
            local valid=true
            IFS=',' read -ra ADDR_ARRAY <<< "$PUBLISHERS"
            for addr in "${ADDR_ARRAY[@]}"; do
              addr=$(echo "$addr" | xargs) # trim whitespace
              if [[ ! "$addr" =~ ^0x[0-9a-fA-F]{40}$ ]]; then
                echo -e "${RED}Invalid address format: $addr${NC}"
                valid=false
                break
              fi
            done
            if [ "$valid" = true ]; then
              # Save to .env-aztec-agent (append or update)
              if [ -f "$env_file" ]; then
                if grep -q "^PUBLISHERS=" "$env_file"; then
                  # Escape special characters in PUBLISHERS for sed (using | as delimiter)
                  PUBLISHERS_ESCAPED=$(printf '%s\n' "$PUBLISHERS" | sed 's/[[\.*^$()+?{|]/\\&/g' | sed 's/|/\\|/g')
                  sed -i "s|^PUBLISHERS=.*|PUBLISHERS=\"$PUBLISHERS_ESCAPED\"|" "$env_file"
                else
                  printf 'PUBLISHERS="%s"\n' "$PUBLISHERS" >> "$env_file"
                fi
              else
                printf 'PUBLISHERS="%s"\n' "$PUBLISHERS" > "$env_file"
              fi
              # Enable monitoring
              if grep -q "^MONITORING_PUBLISHERS=" "$env_file"; then
                sed -i "s|^MONITORING_PUBLISHERS=.*|MONITORING_PUBLISHERS=true|" "$env_file"
              else
                printf 'MONITORING_PUBLISHERS=true\n' >> "$env_file"
              fi
              echo -e "\n${GREEN}$(t "publisher_monitoring_enabled")${NC}"
              break
            fi
          else
            echo -e "\n${RED}$(t "publisher_addresses_empty")${NC}"
          fi
        done
        ;;
      2)
        # Configure minimum balance threshold
        echo -e "\n${BLUE}$(t "publisher_min_balance_prompt")${NC}"
        while true; do
          read -p "> " min_balance
          if [[ -z "$min_balance" ]]; then
            min_balance="0.15"
          fi
          # Validate that it's a positive number
          if [[ "$min_balance" =~ ^[0-9]+\.?[0-9]*$ ]] && awk "BEGIN {exit !($min_balance > 0)}"; then
            # Save to .env-aztec-agent (append or update)
            if [ -f "$env_file" ]; then
              if grep -q "^MIN_BALANCE_FOR_WARNING=" "$env_file"; then
                # Escape special characters in min_balance for sed (using | as delimiter)
                MIN_BALANCE_ESCAPED=$(printf '%s\n' "$min_balance" | sed 's/[[\.*^$()+?{|]/\\&/g' | sed 's/|/\\|/g')
                sed -i "s|^MIN_BALANCE_FOR_WARNING=.*|MIN_BALANCE_FOR_WARNING=\"$MIN_BALANCE_ESCAPED\"|" "$env_file"
              else
                printf 'MIN_BALANCE_FOR_WARNING="%s"\n' "$min_balance" >> "$env_file"
              fi
            else
              printf 'MIN_BALANCE_FOR_WARNING="%s"\n' "$min_balance" > "$env_file"
            fi
            echo -e "\n${GREEN}Minimum balance threshold set to $min_balance ETH${NC}"
            break
          else
            echo -e "\n${RED}$(t "publisher_min_balance_invalid")${NC}"
          fi
        done
        ;;
      3)
        # Stop balance monitoring
        if [ -f "$env_file" ]; then
          if grep -q "^MONITORING_PUBLISHERS=" "$env_file"; then
            sed -i "s|^MONITORING_PUBLISHERS=.*|MONITORING_PUBLISHERS=false|" "$env_file"
          else
            printf 'MONITORING_PUBLISHERS=false\n' >> "$env_file"
          fi
        else
          printf 'MONITORING_PUBLISHERS=false\n' > "$env_file"
        fi
        echo -e "\n${GREEN}$(t "publisher_monitoring_disabled")${NC}"
        ;;
      *)
        echo -e "\n${RED}$(t "invalid_choice")${NC}"
        continue
        ;;
    esac
    break
  done
}

# === Check Proven L2 Block and Sync Proof ===
check_proven_block() {
    ENV_FILE="$HOME/.env-aztec-agent"

    # Get network settings
    local settings
    settings=$(get_network_settings)
    local network=$(echo "$settings" | cut -d'|' -f1)
    local rpc_url=$(echo "$settings" | cut -d'|' -f2)
    local contract_address=$(echo "$settings" | cut -d'|' -f3)

    if [ -f "$ENV_FILE" ]; then
        source "$ENV_FILE"
    fi

    AZTEC_PORT=${AZTEC_PORT:-8080}

    echo -e "\n${CYAN}$(t "current_aztec_port") $AZTEC_PORT${NC}"
    read -p "$(t "enter_aztec_port_prompt") [${AZTEC_PORT}]: " user_port

    if [ -n "$user_port" ]; then
        AZTEC_PORT=$user_port

        if grep -q "^AZTEC_PORT=" "$ENV_FILE" 2>/dev/null; then
            sed -i "s/^AZTEC_PORT=.*/AZTEC_PORT=$AZTEC_PORT/" "$ENV_FILE"
        else
            echo "AZTEC_PORT=$AZTEC_PORT" >> "$ENV_FILE"
        fi

        echo -e "${GREEN}$(t "port_saved_successfully")${NC}"
    fi

    echo -e "\n${BLUE}$(t "checking_port") $AZTEC_PORT...${NC}"
    if ! nc -z -w 2 localhost $AZTEC_PORT; then
        echo -e "\n${RED}$(t "port_not_available") $AZTEC_PORT${NC}"
        echo -e "${YELLOW}$(t "check_node_running")${NC}"
        return 1
    fi

    echo -e "\n${BLUE}$(t "get_proven_block")${NC}"

    # Фоновый процесс получения блока
    (
        curl -s -X POST -H 'Content-Type: application/json' \
          -d '{"jsonrpc":"2.0","method":"node_getL2Tips","params":[],"id":67}' \
          http://localhost:$AZTEC_PORT | jq -r ".result.proven.number"
    ) > /tmp/proven_block.tmp &
    pid1=$!
    spinner $pid1
    wait $pid1

    PROVEN_BLOCK=$(< /tmp/proven_block.tmp)
    rm -f /tmp/proven_block.tmp

    if [[ -z "$PROVEN_BLOCK" || "$PROVEN_BLOCK" == "null" ]]; then
        echo -e "\n${RED}$(t "proven_block_error")${NC}"
        return 1
    fi

    echo -e "\n${GREEN}$(t "proven_block_found") $PROVEN_BLOCK${NC}"

    echo -e "\n${BLUE}$(t "get_sync_proof")${NC}"

    # Фоновый процесс получения proof
    (
        curl -s -X POST -H 'Content-Type: application/json' \
          -d "{\"jsonrpc\":\"2.0\",\"method\":\"node_getArchiveSiblingPath\",\"params\":[\"$PROVEN_BLOCK\",\"$PROVEN_BLOCK\"],\"id\":68}" \
          http://localhost:$AZTEC_PORT | jq -r ".result"
    ) > /tmp/sync_proof.tmp &
    pid2=$!
    spinner $pid2
    wait $pid2

    SYNC_PROOF=$(< /tmp/sync_proof.tmp)
    rm -f /tmp/sync_proof.tmp

    if [[ -z "$SYNC_PROOF" || "$SYNC_PROOF" == "null" ]]; then
        echo -e "\n${RED}$(t "sync_proof_error")${NC}"
        return 1
    fi

    echo -e "\n${GREEN}$(t "sync_proof_found")${NC}"
    echo "$SYNC_PROOF"
    return 0
}

# === Change RPC URL ===
change_rpc_url() {
  ENV_FILE=".env-aztec-agent"

  echo -e "\n${BLUE}$(t "rpc_change_prompt")${NC}"
  read -p "> " NEW_RPC_URL

  if [ -z "$NEW_RPC_URL" ]; then
    echo -e "${RED}Error: RPC URL cannot be empty${NC}"
    return 1
  fi

  # Тестируем RPC URL
  echo -e "\n${BLUE}Testing new RPC URL...${NC}"
  response=$(curl -s -X POST -H "Content-Type: application/json" \
    --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
    "$NEW_RPC_URL" 2>/dev/null)

  if [[ -z "$response" || "$response" == *"error"* ]]; then
    echo -e "${RED}Error: Failed to connect to the RPC endpoint. Please check the URL and try again.${NC}"
    return 1
  fi

  # Обновляем или добавляем RPC_URL в файл
  if grep -q "^RPC_URL=" "$ENV_FILE" 2>/dev/null; then
    sed -i "s|^RPC_URL=.*|RPC_URL=$NEW_RPC_URL|" "$ENV_FILE"
  else
    echo "RPC_URL=$NEW_RPC_URL" >> "$ENV_FILE"
  fi

  echo -e "\n${GREEN}$(t "rpc_change_success")${NC}"
  echo -e "${YELLOW}New RPC URL: $NEW_RPC_URL${NC}"

  # Подгружаем обновления
  source "$ENV_FILE"
}

# === Functions from install_aztec.sh (merged) ===
# Инициализация портов по умолчанию
http_port=8080
p2p_port=40400

check_and_set_ports() {
    local new_http_port
    local new_p2p_port

    echo -e "\n${CYAN}=== $(t "checking_ports") ===${NC}"
    echo -e "${GRAY}$(t "checking_ports_desc")${NC}\n"

    # Установка iproute2 (если не установлен) - содержит утилиту ss
    if ! command -v ss &> /dev/null; then
        echo -e "${YELLOW}$(t "installing_ss")...${NC}"
        sudo apt update -q > /dev/null 2>&1
        sudo apt install -y iproute2 > /dev/null 2>&1
        echo -e "${GREEN}$(t "ss_installed") ✔${NC}\n"
    fi

    while true; do
        ports=("$http_port" "$p2p_port")
        ports_busy=()

        echo -e "${CYAN}$(t "scanning_ports")...${NC}"

        # Проверка каждого порта с визуализацией (используем ss вместо lsof)
        for port in "${ports[@]}"; do
            echo -n -e "  ${YELLOW}Port $port:${NC} "
            if sudo ss -tuln | grep -q ":${port}\b"; then
                echo -e "${RED}$(t "busy") ✖${NC}"
                ports_busy+=("$port")
            else
                echo -e "${GREEN}$(t "free") ✔${NC}"
            fi
            sleep 0.1  # Уменьшенная задержка, так как ss работает быстрее
        done

        # Все порты свободны → выход из цикла
        if [ ${#ports_busy[@]} -eq 0 ]; then
            echo -e "\n${GREEN}✓ $(t "ports_free_success")${NC}"
            echo -e "  HTTP: ${GREEN}$http_port${NC}, P2P: ${GREEN}$p2p_port${NC}\n"
            break
        else
            # Показать занятые порты
            echo -e "\n${RED}⚠ $(t "ports_busy_error")${NC}"
            echo -e "  ${RED}${ports_busy[*]}${NC}\n"

            # Предложить изменить порты
            read -p "$(t "change_ports_prompt") " -n 1 -r
            echo

            if [[ $REPLY =~ ^[Yy]$ || -z "$REPLY" ]]; then
                echo -e "\n${YELLOW}$(t "enter_new_ports_prompt")${NC}"

                # Запрос нового HTTP-порта
                read -p "  $(t "enter_http_port") [${GRAY}by default: $http_port${NC}]: " new_http_port
                http_port=${new_http_port:-$http_port}

                # Запрос нового P2P-порта
                read -p "  $(t "enter_p2p_port") [${GRAY}by default: $p2p_port${NC}]: " new_p2p_port
                p2p_port=${new_p2p_port:-$p2p_port}

                echo -e "\n${CYAN}$(t "ports_updated")${NC}"
                echo -e "  HTTP: ${YELLOW}$http_port${NC}, P2P: ${YELLOW}$p2p_port${NC}\n"
            else
                # Отмена установки
                return 2
            fi
        fi
    done
}

install_docker() {
    echo -e "\n${YELLOW}$(t "installing_docker")${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo -e "\n${GREEN}$(t "docker_installed")${NC}"
}

install_docker_compose() {
    echo -e "\n${YELLOW}$(t "installing_compose")${NC}"
    sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo -e "\n${GREEN}$(t "compose_installed")${NC}"
}

delete_aztec_node() {
    echo -e "\n${RED}=== $(t "delete_node") ===${NC}"

    # Основной запрос
    while :; do
        read -p "$(t "delete_confirm") " -n 1 -r
        [[ $REPLY =~ ^[YyNn]$ ]] && break
        echo -e "\n${YELLOW}$(t "enter_yn")${NC}"
    done
    echo  # Фиксируем окончательный перевод строки

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}$(t "stopping_containers")${NC}"
        docker compose -f "$HOME/aztec/docker-compose.yml" down || true

        echo -e "${YELLOW}$(t "removing_node_data")${NC}"
        sudo rm -rf "$HOME/.aztec" "$HOME/aztec"

        echo -e "${GREEN}$(t "node_deleted")${NC}"

        # Проверяем Watchtower
        if [ -d "$HOME/watchtower" ] || docker ps -a --format '{{.Names}}' | grep -q 'watchtower'; then
            while :; do
                read -p "$(t "delete_watchtower_confirm") " -n 1 -r
                [[ $REPLY =~ ^[YyNn]$ ]] && break
                echo -e "\n${YELLOW}$(t "enter_yn")${NC}"
            done
            echo

            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo -e "${YELLOW}$(t "stopping_watchtower")${NC}"
                docker stop watchtower 2>/dev/null || true
                docker rm watchtower 2>/dev/null || true
                [ -f "$HOME/watchtower/docker-compose.yml" ] && docker compose -f "$HOME/watchtower/docker-compose.yml" down || true

                echo -e "${YELLOW}$(t "removing_watchtower_data")${NC}"
                sudo rm -rf "$HOME/watchtower"
                echo -e "${GREEN}$(t "watchtower_deleted")${NC}"
            else
                echo -e "${GREEN}$(t "watchtower_kept")${NC}"
            fi
        fi

        return 0
    else
        echo -e "${YELLOW}$(t "delete_canceled")${NC}"
        return 1
    fi
}

# Функция для обновления ноды Aztec до последней версии
update_aztec_node() {
    echo -e "\n${GREEN}=== $(t "update_title") ===${NC}"

    # Переходим в папку с нодой
    cd "$HOME/aztec" || {
        echo -e "${RED}$(t "update_folder_error")${NC}"
        return 1
    }

    # Проверяем текущий тег в docker-compose.yml
    CURRENT_TAG=$(grep -oP 'image: aztecprotocol/aztec:\K[^\s]+' docker-compose.yml || echo "")

    if [[ "$CURRENT_TAG" != "latest" ]]; then
        echo -e "${YELLOW}$(printf "$(t "tag_check")" "$CURRENT_TAG")${NC}"
        sed -i 's|image: aztecprotocol/aztec:.*|image: aztecprotocol/aztec:latest|' docker-compose.yml
    fi

    # Обновляем образ
    echo -e "${YELLOW}$(t "update_pulling")${NC}"
    docker pull aztecprotocol/aztec:latest || {
        echo -e "${RED}$(t "update_pull_error")${NC}"
        return 1
    }

    # Останавливаем контейнеры
    echo -e "${YELLOW}$(t "update_stopping")${NC}"
    docker compose down || {
        echo -e "${RED}$(t "update_stop_error")${NC}"
        return 1
    }

    # Запускаем контейнеры
    echo -e "${YELLOW}$(t "update_starting")${NC}"
    docker compose up -d || {
        echo -e "${RED}$(t "update_start_error")${NC}"
        return 1
    }

    echo -e "${GREEN}$(t "update_success")${NC}"
}

# Функция для даунгрейда ноды Aztec
downgrade_aztec_node() {
    echo -e "\n${GREEN}=== $(t "downgrade_title") ===${NC}"

    # Получаем список доступных тегов с Docker Hub
    echo -e "${YELLOW}$(t "downgrade_fetching")${NC}"
    TAGS=$(curl -s https://hub.docker.com/v2/repositories/aztecprotocol/aztec/tags/?page_size=100 | jq -r '.results[].name' | sort -Vr)

    if [ -z "$TAGS" ]; then
        echo -e "${RED}$(t "downgrade_fetch_error")${NC}"
        return 1
    fi

    # Выводим список тегов с нумерацией
    echo -e "\n${CYAN}$(t "downgrade_available")${NC}"
    select TAG in $TAGS; do
        if [ -n "$TAG" ]; then
            break
        else
            echo -e "${RED}$(t "downgrade_invalid_choice")${NC}"
        fi
    done

    echo -e "\n${YELLOW}$(t "downgrade_selected") $TAG${NC}"

    # Переходим в папку с нодой
    cd "$HOME/aztec" || {
        echo -e "${RED}$(t "downgrade_folder_error")${NC}"
        return 1
    }

    # Обновляем образ до выбранной версии
    echo -e "${YELLOW}$(t "downgrade_pulling")$TAG...${NC}"
    docker pull aztecprotocol/aztec:"$TAG" || {
        echo -e "${RED}$(t "downgrade_pull_error")${NC}"
        return 1
    }

    # Останавливаем контейнеры
    echo -e "${YELLOW}$(t "downgrade_stopping")${NC}"
    docker compose down || {
        echo -e "${RED}$(t "downgrade_stop_error")${NC}"
        return 1
    }

    # Изменяем версию в docker-compose.yml
    echo -e "${YELLOW}$(t "downgrade_updating")${NC}"
    sed -i "s|image: aztecprotocol/aztec:.*|image: aztecprotocol/aztec:$TAG|" docker-compose.yml || {
        echo -e "${RED}$(t "downgrade_update_error")${NC}"
        return 1
    }

    # Запускаем контейнеры
    echo -e "${YELLOW}$(t "downgrade_starting") $TAG...${NC}"
    docker compose up -d || {
        echo -e "${RED}$(t "downgrade_start_error")${NC}"
        return 1
    }

    echo -e "${GREEN}$(t "downgrade_success") $TAG!${NC}"
}

# === Functions from check-validator.sh (merged) ===
# Получаем значение NETWORK из env-aztec-agent
get_network_for_validator() {
    local network="testnet"
    if [[ -f "$HOME/.env-aztec-agent" ]]; then
        source "$HOME/.env-aztec-agent"
        [[ -n "$NETWORK" ]] && network="$NETWORK"
    fi
    echo "$network"
}

# === Адреса контрактов в зависимости от сети ===
# Testnet адреса
ROLLUP_ADDRESS_TESTNET="0xebd99ff0ff6677205509ae73f93d0ca52ac85d67"
GSE_ADDRESS_TESTNET="0xFb243b9112Bb65785A4A8eDAf32529accf003614"

# Mainnet адреса
ROLLUP_ADDRESS_MAINNET="0x603bb2c05d474794ea97805e8de69bccfb3bca12"
GSE_ADDRESS_MAINNET="0xa92ecfd0e70c9cd5e5cd76c50af0f7da93567a4f"

# ========= HTTP via curl_cffi =========
# cffi_http_get <url>
cffi_http_get() {
  local url="$1"
  local network="$2"
  python3 - "$url" "$network" <<'PY'
import sys, json
from curl_cffi import requests
u = sys.argv[1]
network = sys.argv[2]

# Формируем origin и referer в зависимости от сети
if network == "mainnet":
    base_url = "https://dashtec.xyz"
else:
    base_url = f"https://{network}.dashtec.xyz"

headers = {
  "accept": "application/json, text/plain, */*",
  "origin": base_url,
  "referer": base_url + "/",
}
try:
    r = requests.get(u, headers=headers, impersonate="chrome131", timeout=30)
    ct = (r.headers.get("content-type") or "").lower()
    txt = r.text
    if "application/json" in ct:
        sys.stdout.write(txt)
    else:
        i, j = txt.find("{"), txt.rfind("}")
        if i != -1 and j != -1 and j > i:
            sys.stdout.write(txt[i:j+1])
        else:
            sys.stdout.write(txt)
except Exception as e:
    sys.stdout.write("")
    sys.stderr.write(f"{e}")
PY
}

# Функция загрузки RPC URL с обработкой ошибок
load_rpc_config() {
    if [ -f "$HOME/.env-aztec-agent" ]; then
        source "$HOME/.env-aztec-agent"
        if [ -z "$RPC_URL" ]; then
            echo -e "${RED}$(t "error_rpc_missing")${NC}"
            return 1
        fi
        if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
            echo -e "${YELLOW}Warning: TELEGRAM_BOT_TOKEN or TELEGRAM_CHAT_ID not found in $HOME/.env-aztec-agent${NC}"
        fi

        # Если есть резервный RPC, используем его
        if [ -n "$ALT_RPC" ]; then
            echo -e "${YELLOW}Using backup RPC to load the list of validators: $ALT_RPC${NC}"
            USING_BACKUP_RPC=true
        else
            USING_BACKUP_RPC=false
        fi
    else
        echo -e "${RED}$(t "error_file_missing")${NC}"
        return 1
    fi
}

# Функция для получения нового RPC URL
get_new_rpc_url() {
    local network="$1"
    echo -e "${YELLOW}$(t "getting_new_rpc")${NC}"

    # Список возможных RPC провайдеров в зависимости от сети
    local rpc_providers=()

    if [[ "$network" == "mainnet" ]]; then
        rpc_providers=(
            "https://ethereum-rpc.publicnode.com"
            "https://eth.llamarpc.com"
        )
    else
        rpc_providers=(
            "https://ethereum-sepolia-rpc.publicnode.com"
            "https://1rpc.io/sepolia"
            "https://sepolia.drpc.org"
        )
    fi

    # Пробуем каждый RPC пока не найдем рабочий
    for rpc_url in "${rpc_providers[@]}"; do
        echo -e "${YELLOW}Trying RPC: $rpc_url${NC}"

        # Проверяем доступность RPC
        if curl -s --head --connect-timeout 5 "$rpc_url" >/dev/null; then
            echo -e "${GREEN}RPC is available: $rpc_url${NC}"

            # Проверяем, что RPC может отвечать на запросы
            if cast block latest --rpc-url "$rpc_url" >/dev/null 2>&1; then
                echo -e "${GREEN}RPC is working properly: $rpc_url${NC}"

                # Добавляем новый RPC в файл конфигурации
                if grep -q "ALT_RPC=" "$HOME/.env-aztec-agent"; then
                    sed -i "s|ALT_RPC=.*|ALT_RPC=$rpc_url|" "$HOME/.env-aztec-agent"
                else
                    printf 'ALT_RPC=%s\n' "$rpc_url" >> "$HOME/.env-aztec-agent"
                fi

                # Обновляем текущую переменную
                ALT_RPC="$rpc_url"
                USING_BACKUP_RPC=true

                # Перезагружаем конфигурацию, чтобы обновить переменные
                source "$HOME/.env-aztec-agent"

                return 0
            else
                echo -e "${RED}RPC is not responding properly: $rpc_url${NC}"
            fi
        else
            echo -e "${RED}RPC is not available: $rpc_url${NC}"
        fi
    done

    echo -e "${RED}Failed to find a working RPC URL${NC}"
    return 1
}

## Функция для выполнения cast call с обработкой ошибок RPC
cast_call_with_fallback() {
    local contract_address=$1
    local function_signature=$2
    local max_retries=3
    local retry_count=0
    local use_validator_rpc=${3:-false}  # По умолчанию используем основной RPC
    local network="$4"

    while [ $retry_count -lt $max_retries ]; do
        # Определяем какой RPC использовать
        local current_rpc
        if [ "$use_validator_rpc" = true ] && [ -n "$ALT_RPC" ]; then
            current_rpc="$ALT_RPC"
            echo -e "${YELLOW}Using validator RPC: $current_rpc (attempt $((retry_count + 1))/$max_retries)${NC}"
        else
            current_rpc="$RPC_URL"
            echo -e "${YELLOW}Using main RPC: $current_rpc (attempt $((retry_count + 1))/$max_retries)${NC}"
        fi

        local response=$(cast call "$contract_address" "$function_signature" --rpc-url "$current_rpc" 2>&1)

        # Проверяем на ошибки RPC (но игнорируем успешные ответы, которые могут содержать текст)
        if echo "$response" | grep -q -E "^(Error|error|timed out|connection refused|connection reset)"; then
            echo -e "${RED}RPC error: $response${NC}"

            # Если это запрос валидаторов, получаем новый RPC URL
            if [ "$use_validator_rpc" = true ]; then
                if get_new_rpc_url "$network"; then
                    retry_count=$((retry_count + 1))
                    sleep 2
                    continue
                else
                    echo -e "${RED}All RPC attempts failed${NC}"
                    return 1
                fi
            else
                # Для других запросов просто увеличиваем счетчик попыток
                retry_count=$((retry_count + 1))
                sleep 2
                continue
            fi
        fi

        # Если нет ошибки, возвращаем ответ
        echo "$response"
        return 0
    done

    echo -e "${RED}Maximum retries exceeded${NC}"
    return 1
}

hex_to_dec() {
    local hex=${1^^}
    echo "ibase=16; $hex" | bc
}

wei_to_token() {
    local wei_value=$1
    local int_part=$(echo "$wei_value / 1000000000000000000" | bc)
    local frac_part=$(echo "$wei_value % 1000000000000000000" | bc)
    local frac_str=$(printf "%018d" $frac_part)
    frac_str=$(echo "$frac_str" | sed 's/0*$//')
    if [[ -z "$frac_str" ]]; then
        echo "$int_part"
    else
        echo "$int_part.$frac_str"
    fi
}

# Функция для отправки уведомления в Telegram
send_telegram_notification() {
    local message="$1"
    if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
        echo -e "${YELLOW}Telegram notification not sent: missing TELEGRAM_BOT_TOKEN or TELEGRAM_CHAT_ID${NC}"
        return 1
    fi

    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d chat_id="$TELEGRAM_CHAT_ID" \
        -d text="$message" \
        -d parse_mode="Markdown" > /dev/null
}

# Функция для проверки очереди валидаторов (пакетная обработка)
check_validator_queue(){
    local validator_addresses=("$@")
    local network="${NETWORK:-$(get_network_for_validator)}"
    local results=()
    local found_count=0
    local not_found_count=0

    # Выбор адресов в зависимости от сети
    local QUEUE_URL
    if [[ "$network" == "mainnet" ]]; then
        QUEUE_URL="https://dashtec.xyz/api/sequencers/queue"
    else
        QUEUE_URL="https://${network}.dashtec.xyz/api/sequencers/queue"
    fi

    echo -e "${YELLOW}$(t "fetching_queue")${NC}"
    echo -e "${GRAY}Checking ${#validator_addresses[@]} validators in queue...${NC}"
    local temp_file
    temp_file=$(mktemp)

    # Функция для отправки уведомления об ошибке API
    send_api_error_notification() {
        local error_type="$1"
        local validator_address="$2"
        local message="🚨 *Dashtec API Error*

🔧 *Error Type:* $error_type
🔍 *Validator:* \`${validator_address:-"Batch check"}\`
⏰ *Time:* $(date '+%d.%m.%Y %H:%M UTC')
⚠️ *Issue:* Possible problems with Dashtec API

📞 *Contact developer:* https://t.me/+zEaCtoXYYwIyZjQ0"

        if [ -n "${TELEGRAM_BOT_TOKEN-}" ] && [ -n "${TELEGRAM_CHAT_ID-}" ]; then
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d chat_id="$TELEGRAM_CHAT_ID" -d text="$message" -d parse_mode="Markdown" >/dev/null 2>&1
        fi
    }

    check_single_validator(){
        local validator_address=$1
        local temp_file=$2
        local search_address_lower=${validator_address,,}
        local search_url="${QUEUE_URL}?page=1&limit=10&search=${search_address_lower}"
        local response_data
        response_data="$(cffi_http_get "$search_url" "$network")"

        if [ -z "$response_data" ]; then
            echo "$validator_address|ERROR|Empty API response" >> "$temp_file"
            send_api_error_notification "Empty response" "$validator_address"
            return 1
        fi

        if ! jq -e . >/dev/null 2>&1 <<<"$response_data"; then
            echo "$validator_address|ERROR|Invalid JSON response" >> "$temp_file"
            send_api_error_notification "Invalid JSON" "$validator_address"
            return 1
        fi

        # Проверяем статус ответа
        local status=$(echo "$response_data" | jq -r '.status')
        if [ "$status" != "ok" ]; then
            echo "$validator_address|ERROR|API returned non-ok status: $status" >> "$temp_file"
            send_api_error_notification "Non-OK status: $status" "$validator_address"
            return 1
        fi

        local validator_info
        validator_info=$(echo "$response_data" | jq -r ".validatorsInQueue[] | select(.address? | ascii_downcase == \"$search_address_lower\")")
        local filtered_count
        filtered_count=$(echo "$response_data" | jq -r '.filteredCount // 0')

        if [ -n "$validator_info" ] && [ "$filtered_count" -gt 0 ]; then
            local position withdrawer queued_at tx_hash index
            position=$(echo "$validator_info" | jq -r '.position')
            withdrawer=$(echo "$validator_info" | jq -r '.withdrawerAddress')
            queued_at=$(echo "$validator_info" | jq -r '.queuedAt')
            tx_hash=$(echo "$validator_info" | jq -r '.transactionHash')
            index=$(echo "$validator_info" | jq -r '.index')
            echo "$validator_address|FOUND|$position|$withdrawer|$queued_at|$tx_hash|$index" >> "$temp_file"
        else
            echo "$validator_address|NOT_FOUND||" >> "$temp_file"
        fi
    }

    local pids=()
    for validator_address in "${validator_addresses[@]}"; do
        check_single_validator "$validator_address" "$temp_file" &
        pids+=($!)
    done

    # Ожидаем завершения всех процессов
    local api_errors=0
    for pid in "${pids[@]}"; do
        wait "$pid" 2>/dev/null || ((api_errors++))
    done

    # Если все запросы завершились с ошибкой API, отправляем общее уведомление
    if [ $api_errors -eq ${#validator_addresses[@]} ] && [ ${#validator_addresses[@]} -gt 0 ]; then
        send_api_error_notification "All API requests failed" "Batch check"
    fi

    # Обрабатываем результаты
    while IFS='|' read -r address status position withdrawer queued_at tx_hash index; do
        case "$status" in
            FOUND) results+=("FOUND|$address|$position|$withdrawer|$queued_at|$tx_hash|$index"); found_count=$((found_count+1));;
            NOT_FOUND) results+=("NOT_FOUND|$address"); not_found_count=$((not_found_count+1));;
            ERROR) results+=("ERROR|$address|$position"); not_found_count=$((not_found_count+1));;
        esac
    done < "$temp_file"
    rm -f "$temp_file"

    echo -e "\n${CYAN}=== Queue Check Results ===${NC}"
    echo -e "Found in queue: ${GREEN}$found_count${NC}"
    echo -e "Not found: ${RED}$not_found_count${NC}"
    echo -e "Total checked: ${BOLD}${#validator_addresses[@]}${NC}"

    if [ $found_count -gt 0 ]; then
        echo -e "\n${GREEN}Validators found in queue:${NC}"
        for result in "${results[@]}"; do
            IFS='|' read -r status address position withdrawer queued_at tx_hash index <<<"$result"
            if [ "$status" == "FOUND" ]; then
                local formatted_date
                formatted_date=$(date -d "$queued_at" '+%d.%m.%Y %H:%M UTC' 2>/dev/null || echo "$queued_at")
                echo -e "  ${CYAN}• ${address}${NC}"
                echo -e "    ${BOLD}Position:${NC} $position"
                echo -e "    ${BOLD}Withdrawer:${NC} $withdrawer"
                echo -e "    ${BOLD}Queued at:${NC} $formatted_date"
                echo -e "    ${BOLD}Tx Hash:${NC} $tx_hash"
                echo -e "    ${BOLD}Index:${NC} $index"
            fi
        done
    fi

    if [ $not_found_count -gt 0 ]; then
        echo -e "\n${RED}Validators not found in queue:${NC}"
        for result in "${results[@]}"; do
            IFS='|' read -r status address error_msg <<<"$result"
            if [ "$status" == "NOT_FOUND" ]; then
                echo -e "  ${RED}• ${address}${NC}"
            elif [ "$status" == "ERROR" ]; then
                echo -e "  ${RED}• ${address} (Error: ${error_msg})${NC}"
            fi
        done
    fi

    # Устанавливаем глобальные переменные с результатами поиска
    QUEUE_FOUND_COUNT=$found_count
    QUEUE_FOUND_ADDRESSES=()

    # Заполняем массив найденными адресами
    for result in "${results[@]}"; do
        IFS='|' read -r status address position withdrawer queued_at tx_hash index <<<"$result"
        if [ "$status" == "FOUND" ]; then
            QUEUE_FOUND_ADDRESSES+=("$address")
        fi
    done

    if [ $found_count -gt 0 ]; then return 0; else return 1; fi
}

# Вспомогательная функция для проверки одного валидатора (для обратной совместимости)
check_single_validator_queue() {
    local validator_address=$1
    check_validator_queue "$validator_address"
}

create_monitor_script(){
    local validator_address=$1
    local network=$2
    local MONITOR_DIR=$3
    local QUEUE_URL=$4
    local validator_address=$(echo "$validator_address" | xargs)
    local normalized_address=${validator_address,,}
    local script_name="monitor_${normalized_address:2}.sh"
    local log_file="$MONITOR_DIR/monitor_${normalized_address:2}.log"
    local position_file="$MONITOR_DIR/last_position_${normalized_address:2}.txt"
    if [ -f "$MONITOR_DIR/$script_name" ]; then
        echo -e "${YELLOW}$(t "notification_exists")${NC}"
        return
    fi
    mkdir -p "$MONITOR_DIR"

    local start_message="🎯 *Queue Monitoring Started*

🔹 *Address:* \`$validator_address\`
⏰ *Monitoring started at:* $(date '+%d.%m.%Y %H:%M UTC')
📋 *Check frequency:* Hourly
🔔 *Notifications:* Position changes"

    if [ -n "${TELEGRAM_BOT_TOKEN-}" ] && [ -n "${TELEGRAM_CHAT_ID-}" ]; then
        curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
            -d chat_id="$TELEGRAM_CHAT_ID" -d text="$start_message" -d parse_mode="Markdown" >/dev/null 2>&1
    fi

    cat > "$MONITOR_DIR/$script_name" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

VALIDATOR_ADDRESS="__ADDR__"
NETWORK="__NETWORK__"
MONITOR_DIR="__MDIR__"
LAST_POSITION_FILE="__POSFILE__"
LOG_FILE="__LOGFILE__"
TELEGRAM_BOT_TOKEN="__TBOT__"
TELEGRAM_CHAT_ID="__TCHAT__"

CURL_CONNECT_TIMEOUT=15
CURL_MAX_TIME=45
API_RETRY_DELAY=30
MAX_RETRIES=2

mkdir -p "$MONITOR_DIR"
log_message(){ echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

# Ensure curl_cffi
python3 - <<'PY' >/dev/null 2>&1 || exit 1
try:
    import pkgutil
    assert pkgutil.find_loader("curl_cffi")
except Exception:
    raise SystemExit(1)
print("OK")
PY

send_telegram(){
    local message="$1"
    if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
        log_message "No Telegram tokens"
        return 1
    fi
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d chat_id="$TELEGRAM_CHAT_ID" -d text="$message" -d parse_mode="Markdown" >/dev/null
}

format_date(){
    local iso_date="$1"
    if [[ "$iso_date" =~ ^([0-9]{4})-([0-9]{2})-([0-9]{2})T([0-9]{2}):([0-9]{2}):([0-9]{2}) ]]; then
        echo "${BASH_REMATCH[3]}.${BASH_REMATCH[2]}.${BASH_REMATCH[1]} ${BASH_REMATCH[4]}:${BASH_REMATCH[5]} UTC"
    else
        echo "$iso_date"
    fi
}

cffi_http_get(){
  local url="$1"
  python3 - "$url" "$NETWORK" <<'PY'
import sys
from curl_cffi import requests
u = sys.argv[1]
network = sys.argv[2]

# Формируем origin и referer в зависимости от сети
if network == "mainnet":
    base_url = "https://dashtec.xyz"
else:
    base_url = f"https://{network}.dashtec.xyz"

headers = {
    "accept": "application/json, text/plain, */*",
    "origin": base_url,
    "referer": base_url + "/"
}
try:
    r = requests.get(u, headers=headers, impersonate="chrome131", timeout=30)
    ct = (r.headers.get("content-type") or "").lower()
    txt = r.text
    if "application/json" in ct:
        print(txt)
    else:
        i, j = txt.find("{"), txt.rfind("}")
        print(txt[i:j+1] if i!=-1 and j!=-1 and j>i else txt)
except Exception as e:
    print(f'{{"error": "Request failed: {e}"}}')
PY
}

monitor_position(){
    log_message "Start monitor_position for $VALIDATOR_ADDRESS"
    local last_position=""
    [[ -f "$LAST_POSITION_FILE" ]] && last_position=$(cat "$LAST_POSITION_FILE")

    # Функция для отправки уведомления об ошибке API в мониторе
    send_monitor_api_error(){
        local error_type="$1"
        local message="🚨 *Dashtec API Error - Monitor*

🔧 *Error Type:* $error_type
🔍 *Validator:* \`$VALIDATOR_ADDRESS\`
⏰ *Time:* $(date '+%d.%m.%Y %H:%M UTC')
⚠️ *Issue:* Possible problems with Dashtec API
📞 *Contact developer:* https://t.me/+zEaCtoXYYwIyZjQ0"

        if [ -n "$TELEGRAM_BOT_TOKEN" ] && [ -n "$TELEGRAM_CHAT_ID" ]; then
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d chat_id="$TELEGRAM_CHAT_ID" -d text="$message" -d parse_mode="Markdown" >/dev/null
        fi
    }

    # Формируем URL для очереди в зависимости от сети
    local queue_url
    if [[ "$NETWORK" == "mainnet" ]]; then
        queue_url="https://dashtec.xyz/api/sequencers/queue"
    else
        queue_url="https://${NETWORK}.dashtec.xyz/api/sequencers/queue"
    fi

    local search_url="${queue_url}?page=1&limit=10&search=${VALIDATOR_ADDRESS,,}"
    log_message "GET $search_url"
    local response_data; response_data="$(cffi_http_get "$search_url")"

    if [ -z "$response_data" ]; then
        log_message "Empty API response"
        send_monitor_api_error "Empty response"
        return 1
    fi

    # Проверяем наличие ошибки в ответе
    if echo "$response_data" | jq -e 'has("error")' >/dev/null 2>&1; then
        local error_msg=$(echo "$response_data" | jq -r '.error')
        log_message "API request failed: $error_msg"
        send_monitor_api_error "Request failed: $error_msg"
        return 1
    fi

    if ! echo "$response_data" | jq -e . >/dev/null 2>&1; then
        log_message "Invalid JSON response: $response_data"
        send_monitor_api_error "Invalid JSON"
        return 1
    fi

    # Проверяем статус ответа
    local api_status=$(echo "$response_data" | jq -r '.status')
    if [ "$api_status" != "ok" ]; then
        log_message "API returned non-ok status: $api_status"
        send_monitor_api_error "Non-OK status: $api_status"
        return 1
    fi

    local validator_info; validator_info=$(echo "$response_data" | jq -r ".validatorsInQueue[] | select(.address? | ascii_downcase == \"${VALIDATOR_ADDRESS,,}\")")
    local filtered_count; filtered_count=$(echo "$response_data" | jq -r '.filteredCount // 0')

    if [[ -n "$validator_info" && "$filtered_count" -gt 0 ]]; then
        local current_position queued_at withdrawer_address transaction_hash index
        current_position=$(echo "$validator_info" | jq -r '.position')
        queued_at=$(format_date "$(echo "$validator_info" | jq -r '.queuedAt')")
        withdrawer_address=$(echo "$validator_info" | jq -r '.withdrawerAddress')
        transaction_hash=$(echo "$validator_info" | jq -r '.transactionHash')
        index=$(echo "$validator_info" | jq -r '.index')

        if [[ "$last_position" != "$current_position" ]]; then
            local message
            if [[ -n "$last_position" ]]; then
                message="📊 *Validator Position Update*

🔹 *Address:* \`$VALIDATOR_ADDRESS\`
🔄 *Change:* $last_position → $current_position
📅 *Queued since:* $queued_at
🏦 *Withdrawer:* \`$withdrawer_address\`
🔗 *Transaction:* \`$transaction_hash\`
🏷️ *Index:* $index
⏳ *Checked at:* $(date '+%d.%m.%Y %H:%M UTC')"
            else
                message="🎉 *New Validator in Queue*

🔹 *Address:* \`$VALIDATOR_ADDRESS\`
📌 *Initial Position:* $current_position
📅 *Queued since:* $queued_at
🏦 *Withdrawer:* \`$withdrawer_address\`
🔗 *Transaction:* \`$transaction_hash\`
🏷️ *Index:* $index
⏳ *Checked at:* $(date '+%d.%m.%Y %H:%M UTC')"
            fi
            if send_telegram "$message"; then
                log_message "Notification sent"
            else
                log_message "Failed to send notification"
            fi
            echo "$current_position" > "$LAST_POSITION_FILE"
            log_message "Saved new position: $current_position"
        else
            log_message "Position unchanged: $current_position"
        fi
    else
        log_message "Validator not found in queue"
        if [[ -n "$last_position" ]]; then
            # Формируем URL для активного набора в зависимости от сети
            local active_url
            if [[ "$NETWORK" == "mainnet" ]]; then
                active_url="https://dashtec.xyz/api/validators?page=1&limit=10&sortBy=rank&sortOrder=asc&search=${VALIDATOR_ADDRESS,,}"
            else
                active_url="https://${NETWORK}.dashtec.xyz/api/validators?page=1&limit=10&sortBy=rank&sortOrder=asc&search=${VALIDATOR_ADDRESS,,}"
            fi

            log_message "Checking active set: $active_url"
            local active_response; active_response="$(cffi_http_get "$active_url" 2>/dev/null || echo "")"

            if [[ -n "$active_response" ]] && echo "$active_response" | jq -e . >/dev/null 2>&1; then
                local api_status_active=$(echo "$active_response" | jq -r '.status')

                if [[ "$api_status_active" == "ok" ]]; then
                    local active_validator; active_validator=$(echo "$active_response" | jq -r ".validators[] | select(.address? | ascii_downcase == \"${VALIDATOR_ADDRESS,,}\")")

                    if [[ -n "$active_validator" ]]; then
                        # Валидатор найден в активном наборе
                        local status balance rank attestation_success proposal_success
                        status=$(echo "$active_validator" | jq -r '.status')
                        rank=$(echo "$active_validator" | jq -r '.rank')

                        # Формируем ссылку для валидатора в зависимости от сети
                        local validator_link
                        if [[ "$NETWORK" == "mainnet" ]]; then
                            validator_link="https://dashtec.xyz/validators"
                        else
                            validator_link="https://${NETWORK}.dashtec.xyz/validators"
                        fi

                        local message="✅ *Validator Moved to Active Set*

🔹 *Address:* \`$VALIDATOR_ADDRESS\`
🎉 *Status:* $status
🏆 *Rank:* $rank
⌛ *Last Queue Position:* $last_position
🔗 *Validator Link:* $validator_link/$VALIDATOR_ADDRESS
⏳ *Checked at:* $(date '+%d.%m.%Y %H:%M UTC')"
                        send_telegram "$message" && log_message "Active set notification sent"
                    else
                        # Формируем ссылку для очереди в зависимости от сети
                        local queue_link
                        if [[ "$NETWORK" == "mainnet" ]]; then
                            queue_link="https://dashtec.xyz/queue"
                        else
                            queue_link="https://${NETWORK}.dashtec.xyz/queue"
                        fi

                        # Валидатор не найден ни в очереди, ни в активном наборе
                        local message="❌ *Validator Removed from Queue*

🔹 *Address:* \`$VALIDATOR_ADDRESS\`
⌛ *Last Position:* $last_position
⏳ *Checked at:* $(date '+%d.%m.%Y %H:%M UTC')

⚠️ *Possible reasons:*
• Validator was removed from queue
• Validator activation failed
• Technical issue with the validator

📊 Check queue: $queue_link"
                        send_telegram "$message" && log_message "Removal notification sent"
                    fi
                else
                    log_message "Active set API returned non-ok status: $api_status_active"
                    # Формируем ссылку для очереди в зависимости от сети
                    local queue_link
                    if [[ "$NETWORK" == "mainnet" ]]; then
                        queue_link="https://dashtec.xyz/queue"
                    else
                        queue_link="https://${NETWORK}.dashtec.xyz/queue"
                    fi

                    # Не удалось проверить активный набор из-за статуса API
                    local message="❌ *Validator No Longer in Queue*

🔹 *Address:* \`$VALIDATOR_ADDRESS\`
⌛ *Last Position:* $last_position
⏳ *Checked at:* $(date '+%d.%m.%Y %H:%M UTC')

ℹ️ *Note:* Could not verify active set status (API error)
📊 Check status: $queue_link"
                    send_telegram "$message" && log_message "General removal notification sent"
                fi
            else
                # Формируем ссылку для очереди в зависимости от сети
                local queue_link
                if [[ "$NETWORK" == "mainnet" ]]; then
                    queue_link="https://dashtec.xyz/queue"
                else
                    queue_link="https://${NETWORK}.dashtec.xyz/queue"
                fi

                # Не удалось получить ответ от API активного набора
                local message="❌ *Validator No Longer in Queue*

🔹 *Address:* \`$VALIDATOR_ADDRESS\`
⌛ *Last Position:* $last_position
⏳ *Checked at:* $(date '+%d.%m.%Y %H:%M UTC')

ℹ️ *Note:* Could not verify active set status
📊 Check status: $queue_link"
                send_telegram "$message" && log_message "General removal notification sent"
            fi

            # Очищаем ресурсы в любом случае
            rm -f "$LAST_POSITION_FILE"; log_message "Removed position file"
            rm -f "$0"; log_message "Removed monitor script"
            (crontab -l | grep -v "$0" | crontab - 2>/dev/null) || true
            rm -f "$LOG_FILE"
        fi
    fi
    return 0
}

main(){
    log_message "===== Starting monitor cycle ====="
    ( sleep 300; log_message "ERROR: Script timed out after 5 minutes"; kill -TERM $$ 2>/dev/null ) & TO_PID=$!
    monitor_position; local ec=$?
    kill "$TO_PID" 2>/dev/null || true
    [[ $ec -ne 0 ]] && log_message "ERROR: exit $ec"
    log_message "===== Monitor cycle completed ====="
    return $ec
}
main >> "$LOG_FILE" 2>&1
EOF
    # substitute placeholders
    sed -i "s|__ADDR__|$validator_address|g" "$MONITOR_DIR/$script_name"
    sed -i "s|__NETWORK__|$network|g" "$MONITOR_DIR/$script_name"
    sed -i "s|__MDIR__|$MONITOR_DIR|g" "$MONITOR_DIR/$script_name"
    sed -i "s|__POSFILE__|$position_file|g" "$MONITOR_DIR/$script_name"
    sed -i "s|__LOGFILE__|$log_file|g" "$MONITOR_DIR/$script_name"
    sed -i "s|__TBOT__|${TELEGRAM_BOT_TOKEN-}|g" "$MONITOR_DIR/$script_name"
    sed -i "s|__TCHAT__|${TELEGRAM_CHAT_ID-}|g" "$MONITOR_DIR/$script_name"

    chmod +x "$MONITOR_DIR/$script_name"
    if ! crontab -l 2>/dev/null | grep -q "$MONITOR_DIR/$script_name"; then
        (crontab -l 2>/dev/null; echo "0 * * * * timeout 600 $MONITOR_DIR/$script_name") | crontab -
    fi
    printf -v message "$(t "notification_script_created")" "$validator_address"
    echo -e "\n${GREEN}${message}${NC}"
    echo -e "${YELLOW}$(t "initial_notification_note")${NC}"
    echo -e "${CYAN}$(t "running_initial_test")${NC}"
    timeout 60 "$MONITOR_DIR/$script_name" >/dev/null 2>&1 || true
}

# Функция для отображения списка активных мониторингов
list_monitor_scripts() {
    local MONITOR_DIR="$1"
    local scripts=($(ls "$MONITOR_DIR"/monitor_*.sh 2>/dev/null))

    if [ ${#scripts[@]} -eq 0 ]; then
        echo -e "${YELLOW}$(t "no_notifications")${NC}"
        return
    fi

    echo -e "${BOLD}$(t "active_monitors")${NC}"
    for script in "${scripts[@]}"; do
        local address=$(grep -oP 'VALIDATOR_ADDRESS="\K[^"]+' "$script")
        echo -e "  ${CYAN}$address${NC}"
    done
}

# Функция для получения списка валидаторов через GSE контракт
get_validators_via_gse() {
    local network="$1"
    local ROLLUP_ADDRESS="$2"
    local GSE_ADDRESS="$3"

    echo -e "${YELLOW}$(t "getting_validator_count")${NC}"

    # Используем правильный RPC URL в зависимости от сети
    local current_rpc="$RPC_URL"
    if [[ "$network" == "mainnet" && -n "$ALT_RPC" ]]; then
        current_rpc="$ALT_RPC"
        echo -e "${YELLOW}Using mainnet RPC: $current_rpc${NC}"
    fi

    VALIDATOR_COUNT=$(cast call "$ROLLUP_ADDRESS" "getActiveAttesterCount()" --rpc-url "$current_rpc" | cast to-dec)

    # Проверяем успешность выполнения и валидность результата
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to get validator count${NC}"
        return 1
    fi

    if ! [[ "$VALIDATOR_COUNT" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Error: Invalid validator count format: '$VALIDATOR_COUNT'${NC}"
        return 1
    fi

    echo -e "${GREEN}Validator count: $VALIDATOR_COUNT${NC}"

    echo -e "${YELLOW}$(t "getting_current_slot")${NC}"

    SLOT=$(cast call "$ROLLUP_ADDRESS" "getCurrentSlot()" --rpc-url "$current_rpc" | cast to-dec)

    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to get current slot${NC}"
        return 1
    fi

    if ! [[ "$SLOT" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Error: Invalid slot format: '$SLOT'${NC}"
        return 1
    fi

    echo -e "${GREEN}Current slot: $SLOT${NC}"

    echo -e "${YELLOW}$(t "deriving_timestamp")${NC}"

    TIMESTAMP=$(cast call "$ROLLUP_ADDRESS" "getTimestampForSlot(uint256)" $SLOT --rpc-url "$current_rpc" | cast to-dec)

    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to get timestamp for slot${NC}"
        return 1
    fi

    if ! [[ "$TIMESTAMP" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Error: Invalid timestamp format: '$TIMESTAMP'${NC}"
        return 1
    fi

    echo -e "${GREEN}Timestamp for slot $SLOT: $TIMESTAMP${NC}"

    # Создаем массив индексов от 0 до VALIDATOR_COUNT-1
    INDICES=()
    for ((i=0; i<VALIDATOR_COUNT; i++)); do
        INDICES+=("$i")
    done

    echo -e "${YELLOW}$(t "querying_attesters")${NC}"

    # Инициализируем массив для всех адресов
    local ALL_VALIDATOR_ADDRESSES=()
    local BATCH_SIZE=3000
    local TOTAL_BATCHES=$(( (VALIDATOR_COUNT + BATCH_SIZE - 1) / BATCH_SIZE ))

    # Обрабатываем индексы партиями
    for ((BATCH_START=0; BATCH_START<VALIDATOR_COUNT; BATCH_START+=BATCH_SIZE)); do
        BATCH_END=$((BATCH_START + BATCH_SIZE - 1))
        if [ $BATCH_END -ge $VALIDATOR_COUNT ]; then
            BATCH_END=$((VALIDATOR_COUNT - 1))
        fi

        CURRENT_BATCH=$((BATCH_START / BATCH_SIZE + 1))
        BATCH_INDICES=("${INDICES[@]:$BATCH_START:$BATCH_SIZE}")
        BATCH_COUNT=${#BATCH_INDICES[@]}

        echo -e "${GRAY}Processing batch $CURRENT_BATCH/$TOTAL_BATCHES (indices $BATCH_START-$BATCH_END, $BATCH_COUNT addresses)${NC}"

        # Преобразуем массив в строку для передачи в cast call
        INDICES_STR=$(printf "%s," "${BATCH_INDICES[@]}")
        INDICES_STR="${INDICES_STR%,}"  # Убираем последнюю запятую

        # Вызываем GSE контракт для получения списка валидаторов
        VALIDATORS_RESPONSE=$(cast call "$GSE_ADDRESS" \
            "getAttestersFromIndicesAtTime(address,uint256,uint256[])" \
            "$ROLLUP_ADDRESS" "$TIMESTAMP" "[$INDICES_STR]" \
            --rpc-url "$current_rpc")
        local exit_code=$?

        if [ $exit_code -ne 0 ]; then
            echo -e "${RED}Error: GSE contract call failed for batch $CURRENT_BATCH with exit code $exit_code${NC}"
            return 1
        fi

        if [ -z "$VALIDATORS_RESPONSE" ]; then
            echo -e "${RED}Error: Empty response from GSE contract for batch $CURRENT_BATCH${NC}"
            return 1
        fi

        # Парсим ABI-encoded динамический массив
        # Убираем префикс 0x
        RESPONSE_WITHOUT_PREFIX=${VALIDATORS_RESPONSE#0x}

        # Извлекаем длину массива (первые 64 символа после смещения)
        OFFSET_HEX=${RESPONSE_WITHOUT_PREFIX:0:64}
        ARRAY_LENGTH_HEX=${RESPONSE_WITHOUT_PREFIX:64:64}

        # Конвертируем hex в decimal
        local ARRAY_LENGTH=$(printf "%d" "0x$ARRAY_LENGTH_HEX")

        if [ $ARRAY_LENGTH -eq 0 ]; then
            echo -e "${YELLOW}Warning: Empty validator array in batch $CURRENT_BATCH${NC}"
            continue
        fi

        if [ $ARRAY_LENGTH -ne $BATCH_COUNT ]; then
            echo -e "${YELLOW}Warning: Batch array length ($ARRAY_LENGTH) doesn't match batch count ($BATCH_COUNT)${NC}"
        fi

        # Извлекаем адреса из массива
        local START_POS=$((64 + 64))  # Пропускаем offset и length (по 64 символа каждый)

        for ((i=0; i<ARRAY_LENGTH; i++)); do
            # Каждый адрес занимает 64 символа (32 bytes), но нам нужны только последние 40 символов (20 bytes)
            ADDR_HEX=${RESPONSE_WITHOUT_PREFIX:$START_POS:64}
            ADDR="0x${ADDR_HEX:24:40}"  # Берем последние 20 bytes (40 символов)

            # Проверяем валидность адреса
            if [[ "$ADDR" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
                ALL_VALIDATOR_ADDRESSES+=("$ADDR")
            else
                echo -e "${YELLOW}Warning: Invalid address format at batch position $i: '$ADDR'${NC}"
            fi

            START_POS=$((START_POS + 64))
        done

        echo -e "${GREEN}Batch $CURRENT_BATCH processed: ${#ALL_VALIDATOR_ADDRESSES[@]} total addresses so far${NC}"

        # Небольшая задержка между батчами чтобы не перегружать RPC
        if [ $CURRENT_BATCH -lt $TOTAL_BATCHES ]; then
            sleep 1
        fi
    done

    # Сохраняем результаты в глобальный массив (перезаписываем его)
    VALIDATOR_ADDRESSES=("${ALL_VALIDATOR_ADDRESSES[@]}")

    echo -e "${GREEN}$(t "found_validators") ${#VALIDATOR_ADDRESSES[@]}${NC}"

    if [ ${#VALIDATOR_ADDRESSES[@]} -eq 0 ]; then
        echo -e "${RED}Error: No valid validator addresses found${NC}"
        return 1
    fi

    return 0
}

fast_load_validators() {
    local network="$1"
    local ROLLUP_ADDRESS="$2"

    echo -e "\n${YELLOW}$(t "loading_validators")${NC}"

    # Используем правильный RPC URL в зависимости от сети
    local current_rpc="$RPC_URL"
    if [[ "$network" == "mainnet" && -n "$ALT_RPC" ]]; then
        current_rpc="$ALT_RPC"
    fi

    echo -e "${YELLOW}Using RPC: $current_rpc${NC}"

    # Обрабатываем валидаторов последовательно
    for ((i=0; i<VALIDATOR_COUNT; i++)); do
        local validator="${VALIDATOR_ADDRESSES[i]}"
        echo -e "${GRAY}Processing: $validator${NC}"

        # Получаем данные getAttesterView
        response=$(cast call "$ROLLUP_ADDRESS" "getAttesterView(address)" "$validator" --rpc-url "$current_rpc" 2>/dev/null)

        if [[ $? -ne 0 || -z "$response" || ${#response} -lt 130 ]]; then
            echo -e "${RED}Error getting data for: $validator${NC}"
            continue
        fi

        # Парсим данные из getAttesterView
        data=${response:2}  # Убираем префикс 0x

        # Извлекаем статус (первые 64 символа)
        status_hex=${data:0:64}

        # Извлекаем стейк (следующие 64 символа)
        stake_hex=${data:64:64}

        # Извлекаем withdrawer из конца ответа (последние 64 символа)
        withdrawer_hex=${data: -64}  # Последние 64 символа
        withdrawer="0x${withdrawer_hex:24:40}"  # Берем последние 20 bytes (40 символов)

        # Проверяем валидность адреса withdrawer
        if [[ ! "$withdrawer" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
            echo -e "${YELLOW}Warning: Invalid withdrawer format for $validator, using zero address${NC}"
            withdrawer="0x0000000000000000000000000000000000000000"
        fi

        # Получаем информацию о ревардах
        rewards_response=$(cast call "$ROLLUP_ADDRESS" "getSequencerRewards(address)" "$validator" --rpc-url "$current_rpc" 2>/dev/null)
        if [[ $? -eq 0 && -n "$rewards_response" ]]; then
            rewards_decimal=$(echo "$rewards_response" | cast --to-dec 2>/dev/null)
            rewards_wei=$(echo "$rewards_decimal" | cast --from-wei 2>/dev/null)
            # Оставляем только целую часть
            rewards=$(echo "$rewards_wei" | cut -d. -f1)
        else
            rewards="0"
        fi

        # Преобразуем hex в decimal с использованием вспомогательных функций
        status=$(hex_to_dec "$status_hex")
        # Убираем пробелы и лишние символы из статуса
        status=$(echo "$status" | tr -d '[:space:]')
        stake_decimal=$(hex_to_dec "$stake_hex")
        stake=$(wei_to_token "$stake_decimal")

        # Безопасное получение статуса и цвета
        # Проверяем, что STATUS_MAP доступен и содержит нужный ключ
        if [[ -n "${STATUS_MAP[$status]:-}" ]]; then
            local status_text="${STATUS_MAP[$status]}"
        else
            # Если STATUS_MAP не доступен или ключ не найден, используем дефолтные значения
            case "$status" in
                0) local status_text="NONE - The validator is not in the validator set" ;;
                1) local status_text="VALIDATING - The validator is currently in the validator set" ;;
                2) local status_text="ZOMBIE - Not participating as validator, but have funds in setup" ;;
                3) local status_text="EXITING - In the process of exiting the system" ;;
                *) local status_text="UNKNOWN (status=$status)" ;;
            esac
        fi
        
        if [[ -n "${STATUS_COLOR[$status]:-}" ]]; then
            local status_color="${STATUS_COLOR[$status]}"
        else
            # Дефолтные цвета для статусов
            case "$status" in
                0) local status_color="$GRAY" ;;
                1) local status_color="$GREEN" ;;
                2) local status_color="$YELLOW" ;;
                3) local status_color="$RED" ;;
                *) local status_color="$NC" ;;
            esac
        fi

        # Добавляем в результаты
        RESULTS+=("$validator|$stake|$withdrawer|$rewards|$status|$status_text|$status_color")
    done

    echo -e "${GREEN}Successfully loaded: ${#RESULTS[@]}/$VALIDATOR_COUNT validators${NC}"
}

# Функция для удаления мониторинга очереди валидаторов
remove_monitor_scripts() {
    local MONITOR_DIR="$1"
    local scripts=($(ls "$MONITOR_DIR"/monitor_*.sh 2>/dev/null))

    if [ ${#scripts[@]} -eq 0 ]; then
        echo -e "${YELLOW}$(t "no_notifications")${NC}"
        return
    fi

    echo -e "\n${YELLOW}$(t "select_monitor_to_remove")${NC}"
    echo -e "1. $(t "remove_all")"

    local i=2
    declare -A script_map
    for script in "${scripts[@]}"; do
        local address=$(grep -oP 'VALIDATOR_ADDRESS="\K[^"]+' "$script")
        echo -e "$i. $address"
        script_map[$i]="$script|$address"
        ((i++))
    done

    echo ""
    read -p "$(t "enter_choice"): " choice

    case $choice in
        1)
            # Удаление всех скриптов мониторинга
            for script in "${scripts[@]}"; do
                local address=$(grep -oP 'VALIDATOR_ADDRESS="\K[^"]+' "$script")
                local base_name=$(basename "$script" .sh)
                local log_file="$MONITOR_DIR/${base_name}.log"
                local position_file="$MONITOR_DIR/last_position_${base_name#monitor_}.txt"

                # Удаляем из crontab
                (crontab -l | grep -v "$script" | crontab - 2>/dev/null) || true

                # Удаляем файлы
                rm -f "$script" "$log_file" "$position_file"

                printf -v message "$(t "monitor_removed")" "$address"
                echo -e "${GREEN}${message}${NC}"
            done
            echo -e "${GREEN}$(t "all_monitors_removed")${NC}"
            ;;
        [2-9]|1[0-9])
            # Удаление конкретного монитора
            if [[ -n "${script_map[$choice]}" ]]; then
                IFS='|' read -r script address <<< "${script_map[$choice]}"
                local base_name=$(basename "$script" .sh)
                local log_file="$MONITOR_DIR/${base_name}.log"
                local position_file="$MONITOR_DIR/last_position_${base_name#monitor_}.txt"

                # Удаляем из crontab
                (crontab -l | grep -v "$script" | crontab - 2>/dev/null) || true

                # Удаляем файлы
                rm -f "$script" "$log_file" "$position_file"

                printf -v message "$(t "monitor_removed")" "$address"
                echo -e "${GREEN}${message}${NC}"
            else
                echo -e "${RED}$(t "invalid_choice")${NC}"
            fi
            ;;
        *)
            echo -e "${RED}$(t "invalid_choice")${NC}"
            ;;
    esac
}

# Основная функция для запуска check-validator (merged from check-validator.sh main code)
check_validator_main() {
    local network=$(get_network_for_validator)

    # Выбор адресов в зависимости от сети
    local ROLLUP_ADDRESS
    local GSE_ADDRESS
    local QUEUE_URL
    if [[ "$network" == "mainnet" ]]; then
        ROLLUP_ADDRESS="$ROLLUP_ADDRESS_MAINNET"
        GSE_ADDRESS="$GSE_ADDRESS_MAINNET"
        QUEUE_URL="https://dashtec.xyz/api/sequencers/queue"
    else
        ROLLUP_ADDRESS="$ROLLUP_ADDRESS_TESTNET"
        GSE_ADDRESS="$GSE_ADDRESS_TESTNET"
        QUEUE_URL="https://${network}.dashtec.xyz/api/sequencers/queue"
    fi

    local MONITOR_DIR="$HOME/aztec-monitor-agent"

    # Загружаем конфигурацию RPC
    if ! load_rpc_config; then
        return 1
    fi

    # Глобальная переменная для отслеживания использования резервного RPC
    USING_BACKUP_RPC=false

    # Глобальная переменная для хранения количества найденных в очереди валидаторов
    QUEUE_FOUND_COUNT=0

    # Глобальный массив для хранения адресов валидаторов, найденных в очереди
    declare -a QUEUE_FOUND_ADDRESSES=()

    # Заполняем глобальные массивы статусов (объявлены на уровне скрипта)
    STATUS_MAP[0]=$(t "status_0")
    STATUS_MAP[1]=$(t "status_1")
    STATUS_MAP[2]=$(t "status_2")
    STATUS_MAP[3]=$(t "status_3")

    STATUS_COLOR[0]="$GRAY"
    STATUS_COLOR[1]="$GREEN"
    STATUS_COLOR[2]="$YELLOW"
    STATUS_COLOR[3]="$RED"

    echo -e "${BOLD}$(t "fetching_validators") ${CYAN}$ROLLUP_ADDRESS${NC}..."

    # Используем функцию для получения списка валидаторов через GSE контракт
    if ! get_validators_via_gse "$network" "$ROLLUP_ADDRESS" "$GSE_ADDRESS"; then
        echo -e "${RED}Error: Failed to fetch validators using GSE contract method${NC}"
        return 1
    fi

    echo "----------------------------------------"

    # Запрашиваем адреса валидаторов для проверки
    echo ""
    echo -e "${BOLD}Enter validator addresses to check (comma separated):${NC}"
    read -p "> " input_addresses

    # Парсим введенные адреса
    IFS=',' read -ra INPUT_ADDRESSES <<< "$input_addresses"

    # Очищаем адреса от пробелов и проверяем их наличие в общем списке
    declare -a VALIDATOR_ADDRESSES_TO_CHECK=()
    declare -a QUEUE_VALIDATORS=()
    declare -a NOT_FOUND_ADDRESSES=()
    found_count=0
    not_found_count=0

    # Сначала проверяем все адреса в активных валидаторах
    for address in "${INPUT_ADDRESSES[@]}"; do
        # Очищаем адрес от пробелов
        clean_address=$(echo "$address" | tr -d ' ')

        # Проверяем, есть ли адрес в общем списке
        found=false
        for validator in "${VALIDATOR_ADDRESSES[@]}"; do
            if [[ "${validator,,}" == "${clean_address,,}" ]]; then
                VALIDATOR_ADDRESSES_TO_CHECK+=("$validator")
                found=true
                found_count=$((found_count + 1))
                echo -e "${GREEN}✓ Found in active validators: $validator${NC}"
                break
            fi
        done

        if ! $found; then
            NOT_FOUND_ADDRESSES+=("$clean_address")
        fi
    done

    # Теперь проверяем не найденные адреса в очереди (пакетно)
    found_in_queue_count=0
    if [ ${#NOT_FOUND_ADDRESSES[@]} -gt 0 ]; then
        echo -e "\n${YELLOW}$(t "validator_not_in_set")${NC}"

        # Используем новую функцию для пакетной проверки в очереди
        check_validator_queue "${NOT_FOUND_ADDRESSES[@]}"
        # Функция устанавливает глобальную переменную QUEUE_FOUND_COUNT
        found_in_queue_count=$QUEUE_FOUND_COUNT

        not_found_count=$((${#NOT_FOUND_ADDRESSES[@]} - found_in_queue_count))
    fi

    # Показываем общую сводку
    echo -e "\n${CYAN}=== Search Summary ===${NC}"
    echo -e "Found in active validators: ${GREEN}$found_count${NC}"
    echo -e "Found in queue: ${YELLOW}$found_in_queue_count${NC}"
    echo -e "Not found anywhere: ${RED}$not_found_count${NC}"

    # Обрабатываем активных валидаторов
    if [[ ${#VALIDATOR_ADDRESSES_TO_CHECK[@]} -gt 0 ]]; then
        echo -e "\n${GREEN}=== Active Validators Details ===${NC}"

        # Запускаем быструю загрузку для активных валидаторов
        declare -a RESULTS

        # Временно заменяем массив для обработки только выбранных валидаторов
        ORIGINAL_VALIDATOR_ADDRESSES=("${VALIDATOR_ADDRESSES[@]}")
        ORIGINAL_VALIDATOR_COUNT=$VALIDATOR_COUNT
        VALIDATOR_ADDRESSES=("${VALIDATOR_ADDRESSES_TO_CHECK[@]}")
        VALIDATOR_COUNT=${#VALIDATOR_ADDRESSES_TO_CHECK[@]}

        # Запускаем быструю загрузку
        fast_load_validators "$network" "$ROLLUP_ADDRESS"

        # Восстанавливаем оригинальный массив
        VALIDATOR_ADDRESSES=("${ORIGINAL_VALIDATOR_ADDRESSES[@]}")
        VALIDATOR_COUNT=$ORIGINAL_VALIDATOR_COUNT

        # Показываем результат
        echo ""
        echo -e "${BOLD}Validator results (${#RESULTS[@]} total):${NC}"
        echo "----------------------------------------"
        local validator_num=1
        for line in "${RESULTS[@]}"; do
            IFS='|' read -r validator stake withdrawer rewards status status_text status_color <<< "$line"
            echo -e "${BOLD}Validator #$validator_num${NC}"
            echo -e "  ${BOLD}$(t "address"):${NC} $validator"
            echo -e "  ${BOLD}$(t "stake"):${NC} $stake STK"
            echo -e "  ${BOLD}$(t "withdrawer"):${NC} $withdrawer"
            echo -e "  ${BOLD}$(t "rewards"):${NC} $rewards STK"
            echo -e "  ${BOLD}$(t "status"):${NC} ${status_color}$status - $status_text${NC}"
            echo -e ""
            echo "----------------------------------------"
            validator_num=$((validator_num + 1))
        done
    fi

    # Обрабатываем валидаторов из очереди (только если они не были уже показаны)
    if [[ ${#QUEUE_FOUND_ADDRESSES[@]} -gt 0 ]]; then
        echo -e "\n${YELLOW}=== $(t "queue_validators_available") ===${NC}"

        # Предлагаем добавить в мониторинг
        echo -e "${BOLD}$(t "add_validators_to_queue_prompt")${NC}"
        read -p "$(t "enter_yes_to_add") " add_to_monitor

        if [[ "$add_to_monitor" == "yes" || "$add_to_monitor" == "y" ]]; then
            # Создаем мониторы для всех валидаторов из очереди
            for validator in "${QUEUE_FOUND_ADDRESSES[@]}"; do
                printf -v message "$(t "processing_address")" "$validator"
                echo -e "\n${YELLOW}${message}${NC}"
                create_monitor_script "$validator" "$network" "$MONITOR_DIR" "$QUEUE_URL"
            done
            echo -e "\n${GREEN}$(t "queue_validators_added")${NC}"
        else
            echo -e "${YELLOW}$(t "skipping_queue_setup")${NC}"
        fi
    fi

    if [[ ${#VALIDATOR_ADDRESSES_TO_CHECK[@]} -eq 0 && ${#QUEUE_FOUND_ADDRESSES[@]} -eq 0 ]]; then
        echo -e "${RED}$(t "no_valid_addresses")${NC}"
    fi
}

# === Validator submenu ===
validator_submenu() {
    local MONITOR_DIR="$HOME/aztec-monitor-agent"
    local network=$(get_network_for_validator)
    
    # Выбор адресов в зависимости от сети
    local QUEUE_URL
    if [[ "$network" == "mainnet" ]]; then
        QUEUE_URL="https://dashtec.xyz/api/sequencers/queue"
    else
        QUEUE_URL="https://${network}.dashtec.xyz/api/sequencers/queue"
    fi

    while true; do
        echo ""
        echo -e "${BOLD}$(t "select_action")${NC}"
        echo -e "${CYAN}$(t "validator_submenu_option1")${NC}"
        echo -e "${CYAN}$(t "validator_submenu_option2")${NC}"
        echo -e "${CYAN}$(t "validator_submenu_option3")${NC}"
        echo -e "${CYAN}$(t "validator_submenu_option4")${NC}"
        echo -e "${CYAN}$(t "validator_submenu_option5")${NC}"
        echo -e "${RED}$(t "option0")${NC}"
        read -p "$(t "enter_option") " choice

        case $choice in
            1)
                # Check another set of validators
                check_validator_main
                echo ""
                echo -e "${YELLOW}Press Enter to continue...${NC}"
                read -r
                ;;
            2)
                # Set up queue position notification for validator
                echo -e "\n${BOLD}$(t "queue_notification_title")${NC}"
                list_monitor_scripts "$MONITOR_DIR"
                echo ""
                read -p "$(t "enter_multiple_addresses") " validator_addresses

                # Создаем скрипты для всех указанных адресов
                IFS=',' read -ra ADDRESSES_TO_MONITOR <<< "$validator_addresses"
                for address in "${ADDRESSES_TO_MONITOR[@]}"; do
                    clean_address=$(echo "$address" | tr -d ' ')
                    printf -v message "$(t "processing_address")" "$clean_address"
                    echo -e "${YELLOW}${message}${NC}"

                    # Проверяем, есть ли валидатор хотя бы в очереди
                    if check_validator_queue "$clean_address"; then
                        create_monitor_script "$clean_address" "$network" "$MONITOR_DIR" "$QUEUE_URL"
                    else
                        echo -e "${RED}$(t "validator_not_in_queue")${NC}"
                    fi
                done
                echo ""
                echo -e "${YELLOW}Press Enter to continue...${NC}"
                read -r
                ;;
            3)
                # Check validator in queue
                read -p "$(t "enter_address") " validator_address
                check_validator_queue "$validator_address"
                echo ""
                echo -e "${YELLOW}Press Enter to continue...${NC}"
                read -r
                ;;
            4)
                # List active monitors
                list_monitor_scripts "$MONITOR_DIR"
                echo ""
                echo -e "${YELLOW}Press Enter to continue...${NC}"
                read -r
                ;;
            5)
                # Remove existing monitoring
                remove_monitor_scripts "$MONITOR_DIR"
                echo ""
                echo -e "${YELLOW}Press Enter to continue...${NC}"
                read -r
                ;;
            0)
                echo -e "\n${CYAN}$(t "exiting")${NC}"
                break
                ;;
            *)
                echo -e "\n${RED}$(t "invalid_input")${NC}"
                echo ""
                echo -e "${YELLOW}Press Enter to continue...${NC}"
                read -r
                ;;
        esac
    done
}

# === Check validator ===
function check_validator {
  echo -e ""
  echo -e "${CYAN}$(t "running_validator_script")${NC}"
  echo -e ""

  validator_submenu
}

# === Main installation function (merged from install_aztec.sh) ===
install_aztec_node_main() {
    set -e

    # Вызываем проверку портов
    check_and_set_ports || return 2

    echo -e "\n${GREEN}$(t "installing_deps")${NC}"
    sudo apt update
    sudo apt install curl iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y

    echo -e "\n${GREEN}$(t "deps_installed")${NC}"

    echo -e "\n${GREEN}$(t "checking_docker")${NC}"

    if ! command -v docker &>/dev/null; then
        echo -e "\n${RED}$(t "docker_not_found")${NC}"
        read -p "\n$(t "install_docker_prompt")" -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_docker
        else
            echo -e "\n${RED}$(t "docker_required")${NC}"
            return 1
        fi
    fi

    if ! docker compose version &>/dev/null; then
        echo -e "\n${RED}$(t "docker_compose_not_found")${NC}"
        read -p "\n$(t "install_compose_prompt")" -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_docker_compose
        else
            echo -e "\n${RED}$(t "compose_required")${NC}"
            return 1
        fi
    fi

    echo -e "\n${GREEN}$(t "docker_found")${NC}"

    echo -e "\n${GREEN}$(t "installing_aztec")${NC}"
    echo -e "${YELLOW}$(t "warn_orig_install") ${NC}$(t "warn_orig_install_2")${NC}"
    sleep 5
    curl -s https://install.aztec.network -o install-aztec.sh
    chmod +x install-aztec.sh
    bash install-aztec.sh

    echo 'export PATH="$HOME/.aztec/bin:$PATH"' >> ~/.bash_profile
    source ~/.bash_profile

    if ! command -v aztec &>/dev/null; then
        echo -e "\n${RED}$(t "aztec_not_installed")${NC}"
        return 1
    fi

    echo -e "\n${GREEN}$(t "aztec_installed")${NC}"

    # Обновляем настройки firewall
    # Проверяем, установлен ли ufw
    if ! command -v ufw >/dev/null 2>&1; then
      echo -e "\n${YELLOW}$(t "ufw_not_installed")${NC}"
    else
      # Проверяем, активен ли ufw
      if sudo ufw status | grep -q "inactive"; then
        echo -e "\n${YELLOW}$(t "ufw_not_active")${NC}"
      else
        # Обновляем настройки firewall
        echo -e "\n${GREEN}$(t "opening_ports")${NC}"
        sudo ufw allow "$p2p_port"
        sudo ufw allow "$http_port"
        echo -e "\n${GREEN}$(t "ports_opened")${NC}"
      fi
    fi

    # Create Aztec node folder and files
    echo -e "\n${GREEN}$(t "creating_folder")${NC}"
    mkdir -p "$HOME/aztec"
    cd "$HOME/aztec"

    # Ask if user wants to run single or multiple validators
    echo -e "\n${CYAN}$(t "validator_setup_header")${NC}"
    read -p "$(t "multiple_validators_prompt")" -n 1 -r
    echo

    # Store the response for validator mode selection
    VALIDATOR_MODE_REPLY=$REPLY

    # Initialize arrays for keys and addresses
    VALIDATOR_PRIVATE_KEYS_ARRAY=()
    VALIDATOR_ADDRESSES_ARRAY=()
    VALIDATOR_BLS_PRIVATE_KEYS_ARRAY=()
    VALIDATOR_BLS_PUBLIC_KEYS_ARRAY=()
    USE_FIRST_AS_PUBLISHER=false
    HAS_BLS_KEYS=false

    # Ask if user has BLS keys
    read -p "$(t "has_bls_keys") " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        HAS_BLS_KEYS=true
        echo -e "${GREEN}BLS keys will be added to configuration${NC}"
    fi

    # Use the stored response for validator mode selection
    if [[ $VALIDATOR_MODE_REPLY =~ ^[Yy]$ ]]; then
        echo -e "\n${GREEN}$(t "multi_validator_mode")${NC}"

        if [ "$HAS_BLS_KEYS" = true ]; then
            # Get multiple validator key-address-bls data
            echo -e "${YELLOW}$(t "multi_validator_format")${NC}"
            for i in {1..10}; do
                read -p "Validator $i (or press Enter to finish): " KEY_ADDRESS_BLS_PAIR
                if [ -z "$KEY_ADDRESS_BLS_PAIR" ]; then
                    break
                fi

                # Split the input into private key, address, private bls, and public bls
                IFS=',' read -r PRIVATE_KEY ADDRESS PRIVATE_BLS PUBLIC_BLS <<< "$KEY_ADDRESS_BLS_PAIR"

                # Remove any spaces and ensure private key starts with 0x
                PRIVATE_KEY=$(echo "$PRIVATE_KEY" | tr -d ' ')
                if [[ ! "$PRIVATE_KEY" =~ ^0x ]]; then
                    PRIVATE_KEY="0x$PRIVATE_KEY"
                fi

                # Remove any spaces from address
                ADDRESS=$(echo "$ADDRESS" | tr -d ' ')

                # Remove any spaces from BLS keys
                PRIVATE_BLS=$(echo "$PRIVATE_BLS" | tr -d ' ')
                PUBLIC_BLS=$(echo "$PUBLIC_BLS" | tr -d ' ')

                VALIDATOR_PRIVATE_KEYS_ARRAY+=("$PRIVATE_KEY")
                VALIDATOR_ADDRESSES_ARRAY+=("$ADDRESS")
                VALIDATOR_BLS_PRIVATE_KEYS_ARRAY+=("$PRIVATE_BLS")
                VALIDATOR_BLS_PUBLIC_KEYS_ARRAY+=("$PUBLIC_BLS")

                echo -e "${GREEN}Added validator $i with BLS keys${NC}"
            done
        else
            # Get multiple validator key-address pairs (original logic)
            echo -e "${YELLOW}Enter validator private keys and addresses (up to 10, format: private_key,address):${NC}"
            for i in {1..10}; do
                read -p "Validator $i (or press Enter to finish): " KEY_ADDRESS_PAIR
                if [ -z "$KEY_ADDRESS_PAIR" ]; then
                    break
                fi

                # Split the input into private key and address
                IFS=',' read -r PRIVATE_KEY ADDRESS <<< "$KEY_ADDRESS_PAIR"

                # Remove any spaces and ensure private key starts with 0x
                PRIVATE_KEY=$(echo "$PRIVATE_KEY" | tr -d ' ')
                if [[ ! "$PRIVATE_KEY" =~ ^0x ]]; then
                    PRIVATE_KEY="0x$PRIVATE_KEY"
                fi

                # Remove any spaces from address
                ADDRESS=$(echo "$ADDRESS" | tr -d ' ')

                VALIDATOR_PRIVATE_KEYS_ARRAY+=("$PRIVATE_KEY")
                VALIDATOR_ADDRESSES_ARRAY+=("$ADDRESS")
                # Add empty BLS keys for consistency
                VALIDATOR_BLS_PRIVATE_KEYS_ARRAY+=("")
                VALIDATOR_BLS_PUBLIC_KEYS_ARRAY+=("")
            done
        fi

        # Ask if user wants to use first address as publisher for all validators
        echo ""
        read -p "Use first address as publisher for all validators? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            USE_FIRST_AS_PUBLISHER=true
            echo -e "${GREEN}Using first address as publisher for all validators${NC}"
        else
            echo -e "${GREEN}Each validator will use their own address as publisher${NC}"
        fi

    else
        echo -e "\n${GREEN}$(t "single_validator_mode")${NC}"

        # Get single validator key-address pair
        read -p "$(t "enter_validator_key") " PRIVATE_KEY
        read -p "Enter validator address: " ADDRESS

        # Remove any spaces and ensure private key starts with 0x
        PRIVATE_KEY=$(echo "$PRIVATE_KEY" | tr -d ' ')
        if [[ ! "$PRIVATE_KEY" =~ ^0x ]]; then
            PRIVATE_KEY="0x$PRIVATE_KEY"
        fi

        # Remove any spaces from address
        ADDRESS=$(echo "$ADDRESS" | tr -d ' ')

        VALIDATOR_PRIVATE_KEYS_ARRAY+=("$PRIVATE_KEY")
        VALIDATOR_ADDRESSES_ARRAY+=("$ADDRESS")

        if [ "$HAS_BLS_KEYS" = true ]; then
            # Get BLS keys for single validator
            read -p "$(t "single_validator_bls_private") " PRIVATE_BLS
            read -p "$(t "single_validator_bls_public") " PUBLIC_BLS

            # Remove any spaces from BLS keys
            PRIVATE_BLS=$(echo "$PRIVATE_BLS" | tr -d ' ')
            PUBLIC_BLS=$(echo "$PUBLIC_BLS" | tr -d ' ')

            VALIDATOR_BLS_PRIVATE_KEYS_ARRAY+=("$PRIVATE_BLS")
            VALIDATOR_BLS_PUBLIC_KEYS_ARRAY+=("$PUBLIC_BLS")
            echo -e "${GREEN}$(t "bls_keys_added")${NC}"
        else
            # Add empty BLS keys for consistency
            VALIDATOR_BLS_PRIVATE_KEYS_ARRAY+=("")
            VALIDATOR_BLS_PUBLIC_KEYS_ARRAY+=("")
        fi

        USE_FIRST_AS_PUBLISHER=true  # For single validator, always use own address
    fi

    # Ask for Aztec L2 Address for feeRecipient и COINBASE
    echo -e "\n${YELLOW}Enter Aztec L2 Address to use as feeRecipient for all validators:${NC}"
    read -p "Aztec L2 Address: " FEE_RECIPIENT_ADDRESS
    FEE_RECIPIENT_ADDRESS=$(echo "$FEE_RECIPIENT_ADDRESS" | tr -d ' ')

    # Добавляем запрос COINBASE сразу после Aztec L2 Address
    read -p "COINBASE: " COINBASE
    COINBASE=$(echo "$COINBASE" | tr -d ' ')

    # Create keys directory and separate YML files
    echo -e "\n${GREEN}Creating key files...${NC}"
    mkdir -p "$HOME/aztec/keys"

    for i in "${!VALIDATOR_PRIVATE_KEYS_ARRAY[@]}"; do
        # Create SECP256K1 YML file for validator
        KEY_FILE="$HOME/aztec/keys/validator_$((i+1)).yml"
        cat > "$KEY_FILE" <<EOF
type: "file-raw"
keyType: "SECP256K1"
privateKey: "${VALIDATOR_PRIVATE_KEYS_ARRAY[$i]}"
EOF
        echo -e "${GREEN}Created SECP256K1 key file: $KEY_FILE${NC}"

        if [ "$HAS_BLS_KEYS" = true ] && [ -n "${VALIDATOR_BLS_PRIVATE_KEYS_ARRAY[$i]}" ]; then
            # Create separate BLS YML file
            BLS_KEY_FILE="$HOME/aztec/keys/bls_validator_$((i+1)).yml"
            cat > "$BLS_KEY_FILE" <<EOF
type: "file-raw"
keyType: "BN254"
privateKey: "${VALIDATOR_BLS_PRIVATE_KEYS_ARRAY[$i]}"
EOF
            echo -e "${GREEN}Created BLS key file: $BLS_KEY_FILE${NC}"
        fi
    done

    # Create config directory and keystore.json
    echo -e "\n${GREEN}Creating keystore configuration...${NC}"
    mkdir -p "$HOME/aztec/config"

    # Prepare validators array for keystore.json
    VALIDATORS_JSON_ARRAY=()
    for i in "${!VALIDATOR_ADDRESSES_ARRAY[@]}"; do
        address="${VALIDATOR_ADDRESSES_ARRAY[$i]}"

        if [ "$USE_FIRST_AS_PUBLISHER" = true ] && [ $i -gt 0 ]; then
            # Use first address as publisher for all other validators
            publisher="${VALIDATOR_ADDRESSES_ARRAY[0]}"
        else
            # Use own address as publisher
            publisher="${VALIDATOR_ADDRESSES_ARRAY[$i]}"
        fi

        if [ "$HAS_BLS_KEYS" = true ] && [ -n "${VALIDATOR_BLS_PUBLIC_KEYS_ARRAY[$i]}" ]; then
            # Create validator JSON with BLS key
            VALIDATOR_JSON=$(cat <<EOF
{
      "attester": {
        "eth": "$address",
        "bls": "${VALIDATOR_BLS_PUBLIC_KEYS_ARRAY[$i]}"
      },
      "publisher": ["$publisher"],
      "coinbase": "$COINBASE",
      "feeRecipient": "$FEE_RECIPIENT_ADDRESS"
    }
EOF
            )
        else
            # Create validator JSON without BLS key (original format)
            VALIDATOR_JSON=$(cat <<EOF
{
      "attester": {
        "eth": "$address"
      },
      "publisher": ["$publisher"],
      "coinbase": "$COINBASE",
      "feeRecipient": "$FEE_RECIPIENT_ADDRESS"
    }
EOF
            )
        fi
        VALIDATORS_JSON_ARRAY+=("$VALIDATOR_JSON")
    done

    # Join validators array with commas
    VALIDATORS_JSON_STRING=$(IFS=,; echo "${VALIDATORS_JSON_ARRAY[*]}")

    # Create keystore.json with updated schema
    cat > "$HOME/aztec/config/keystore.json" <<EOF
{
  "schemaVersion": 1,
  "remoteSigner": "http://127.0.0.1:10500",
  "validators": [
    $VALIDATORS_JSON_STRING
  ]
}
EOF

    echo -e "${GREEN}Created keystore.json configuration${NC}"

    DEFAULT_IP=$(curl -s https://api.ipify.org || curl -s https://ifconfig.me)

    echo -e "\n${GREEN}$(t "creating_env")${NC}"
    read -p "ETHEREUM_RPC_URL: " ETHEREUM_RPC_URL
    read -p "CONSENSUS_BEACON_URL: " CONSENSUS_BEACON_URL

    # Create .env file без COINBASE
    cat > .env <<EOF
ETHEREUM_RPC_URL=${ETHEREUM_RPC_URL}
CONSENSUS_BEACON_URL=${CONSENSUS_BEACON_URL}
P2P_IP=${DEFAULT_IP}
EOF

    # Запрашиваем выбор сети
    echo -e "\n${GREEN}$(t "select_network")${NC}"
    echo "1) $(t "mainnet")"
    echo "2) $(t "testnet")"
    read -p "$(t "enter_choice") " network_choice

    case $network_choice in
        1)
            NETWORK="mainnet"
            DATA_DIR="$HOME/.aztec/mainnet/data/"
            ;;
        2)
            NETWORK="testnet"
            DATA_DIR="$HOME/.aztec/testnet/data/"
            ;;
        *)
            echo -e "\n${RED}$(t "invalid_choice")${NC}"
            return 1
            ;;
    esac

    echo -e "\n${GREEN}$(t "selected_network")${NC}: ${YELLOW}$NETWORK${NC}"

    # Сохраняем/обновляем NETWORK в файле .env-aztec-agent
    ENV_FILE="$HOME/.env-aztec-agent"

    # Если файл существует, обновляем переменную NETWORK
    if [ -f "$ENV_FILE" ]; then
        # Если NETWORK уже существует в файле, заменяем её значение
        if grep -q "^NETWORK=" "$ENV_FILE"; then
            sed -i "s/^NETWORK=.*/NETWORK=$NETWORK/" "$ENV_FILE"
        else
            # Если NETWORK нет, добавляем в конец файла
            printf 'NETWORK=%s\n' "$NETWORK" >> "$ENV_FILE"
        fi
    else
        # Если файла нет, создаем его с переменной NETWORK
        printf 'NETWORK=%s\n' "$NETWORK" > "$ENV_FILE"
    fi

    echo -e "${GREEN}Network saved to $ENV_FILE${NC}"

    # Создаем docker-compose.yml
    echo -e "\n${GREEN}$(t "creating_compose")${NC}"

    cat > docker-compose.yml <<EOF
services:
  aztec-node:
    container_name: aztec-sequencer
    networks:
      - aztec
    image: aztecprotocol/aztec:latest
    restart: unless-stopped
    environment:
      ETHEREUM_HOSTS: \${ETHEREUM_RPC_URL}
      L1_CONSENSUS_HOST_URLS: \${CONSENSUS_BEACON_URL}
      DATA_DIRECTORY: /data
      KEY_STORE_DIRECTORY: /config
      P2P_IP: \${P2P_IP}
      LOG_LEVEL: info;debug:node:sentinel
      AZTEC_PORT: ${http_port}
      AZTEC_ADMIN_PORT: 8880
    entrypoint: >
      sh -c 'node --no-warnings /usr/src/yarn-project/aztec/dest/bin/index.js start --node --archiver --sequencer --network $NETWORK'
    ports:
      - ${p2p_port}:${p2p_port}/tcp
      - ${p2p_port}:${p2p_port}/udp
      - ${http_port}:${http_port}
    volumes:
      - $DATA_DIR:/data
      - $HOME/aztec/config:/config
    labels:
      - com.centurylinklabs.watchtower.enable=true
networks:
  aztec:
    name: aztec
EOF

    echo -e "\n${GREEN}$(t "compose_created")${NC}"

    # Check if Watchtower is already installed
    if [ -d "$HOME/watchtower" ]; then
        echo -e "\n${GREEN}$(t "watchtower_exists")${NC}"
    else
        # Create Watchtower folder and files
        echo -e "\n${GREEN}$(t "installing_watchtower")${NC}"
        mkdir -p "$HOME/watchtower"
        cd "$HOME/watchtower"

        # Ask for Telegram notification settings
        echo -e "\n${YELLOW}Telegram notification settings for Watchtower:${NC}"
        read -p "$(t "enter_tg_token") " TG_TOKEN
        read -p "$(t "enter_tg_chat_id") " TG_CHAT_ID

        # Create .env file for Watchtower
        cat > .env <<EOF
TG_TOKEN=${TG_TOKEN}
TG_CHAT_ID=${TG_CHAT_ID}
WATCHTOWER_NOTIFICATION_URL=telegram://${TG_TOKEN}@telegram?channels=${TG_CHAT_ID}&parseMode=html
EOF

        echo -e "\n${GREEN}$(t "env_created")${NC}"

        echo -e "\n${GREEN}$(t "creating_watchtower_compose")${NC}"
        cat > docker-compose.yml <<EOF
services:
  watchtower:
    image: nickfedor/watchtower:latest
    container_name: watchtower
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    env_file:
      - .env
    environment:
      - WATCHTOWER_CLEANUP=true
      - WATCHTOWER_POLL_INTERVAL=3600
      - WATCHTOWER_NOTIFICATIONS=shoutrrr
      - WATCHTOWER_NOTIFICATION_URL
      - WATCHTOWER_INCLUDE_RESTARTING=true
      - WATCHTOWER_LABEL_ENABLE=true
EOF

        echo -e "\n${GREEN}$(t "compose_created")${NC}"
    fi

    # Download and run web3signer before starting the node
    echo -e "\n${GREEN}Downloading and starting web3signer...${NC}"
    docker pull consensys/web3signer:latest

    # Stop and remove existing web3signer container if it exists
    docker stop web3signer 2>/dev/null || true
    docker rm web3signer 2>/dev/null || true

    # Run web3signer container
    docker run -d --name web3signer --restart unless-stopped \
      -p 127.0.0.1:10500:10500 \
      -v $HOME/aztec/keys:/keys \
      consensys/web3signer:latest \
      --http-listen-host=0.0.0.0 \
      --http-listen-port=10500 \
      --http-host-allowlist="*" \
      --key-store-path=/keys \
      eth1 --chain-id=11155111

    echo -e "${GREEN}web3signer started successfully${NC}"

    # Wait a moment for web3signer to initialize
    echo -e "${YELLOW}Waiting for web3signer to initialize...${NC}"
    sleep 5

    echo -e "\n${GREEN}$(t "starting_node")${NC}"
    cd "$HOME/aztec"
    docker compose up -d

    # Start Watchtower if it exists
    if [ -d "$HOME/watchtower" ]; then
        cd "$HOME/watchtower"
        docker compose up -d
    fi

    echo -e "\n${YELLOW}$(t "showing_logs")${NC}"
    echo -e "${YELLOW}$(t "logs_starting")${NC}"
    sleep 5
    echo -e ""
    cd "$HOME/aztec"
    docker compose logs -fn 200

    set +e
}

# === Install Aztec node ===
function install_aztec {
  echo -e ""
  echo -e "${CYAN}$(t "running_install_node")${NC}"
  echo -e ""

  # Запускаем с обработкой Ctrl+C и других кодов возврата
  install_aztec_node_main
  EXIT_CODE=$?

  case $EXIT_CODE in
    0)
      # Успешное выполнение
      echo -e "${GREEN}$(t "install_completed_successfully")${NC}"
      ;;
    1)
      # Ошибка установки
      echo -e "${RED}$(t "failed_running_install_node")${NC}"
      ;;
    130)
      # Ctrl+C - не считаем ошибкой
      echo -e "${YELLOW}$(t "logs_stopped_by_user")${NC}"
      ;;
    2)
      # Пользователь отменил установку из-за занятых портов
      echo -e "${YELLOW}$(t "installation_cancelled_by_user")${NC}"
      ;;
    *)
      # Неизвестная ошибка
      echo -e "${RED}$(t "unknown_error_occurred")${NC}"
      ;;
  esac

  return $EXIT_CODE
}

# === Delete Aztec node ===
function delete_aztec() {
    delete_aztec_node
}

# === Update Aztec node ===
function update_aztec() {
    update_aztec_node
}

# === Downgrade Aztec node ===
function downgrade_aztec() {
    downgrade_aztec_node
}


# === Common helper functions ===
function _ensure_env_file() {
  local env_file="$HOME/.env-aztec-agent"
  [[ ! -f "$env_file" ]] && touch "$env_file"
  echo "$env_file"
}

function _update_env_var() {
  local env_file="$1" key="$2" value="$3"
  if grep -q "^$key=" "$env_file"; then
    sed -i "s|^$key=.*|$key=$value|" "$env_file"
  else
    printf '%s=%s\n' "$key" "$value" >> "$env_file"
  fi
}

function _read_env_var() {
  local env_file="$1" key="$2"
  grep "^$key=" "$env_file" | cut -d '=' -f2-
}

function _validate_compose_path() {
  local path="$1"
  [[ -d "$path" && -f "$path/docker-compose.yml" ]]
}

# === Stop Aztec containers ===
function stop_aztec_containers() {
  local env_file
  env_file=$(_ensure_env_file)

  local run_type
  run_type=$(_read_env_var "$env_file" "RUN_TYPE")

  case "$run_type" in
    "DOCKER")
      local compose_path
      compose_path=$(_read_env_var "$env_file" "COMPOSE_PATH")

      if ! _validate_compose_path "$compose_path"; then
        read -p "$(t "enter_compose_path")" compose_path
        if _validate_compose_path "$compose_path"; then
          _update_env_var "$env_file" "COMPOSE_PATH" "$compose_path"
        else
          echo -e "${RED}$(t "invalid_path")${NC}"
          return 1
        fi
      fi

      _update_env_var "$env_file" "RUN_TYPE" "DOCKER"

      if cd "$compose_path" && docker compose down; then
        echo -e "${GREEN}$(t "docker_stop_success")${NC}"
      else
        echo -e "${RED}Failed to stop Docker containers${NC}"
        return 1
      fi
      ;;

    "CLI")
      local session_name
      session_name=$(_read_env_var "$env_file" "SCREEN_SESSION")

      if [[ -z "$session_name" ]]; then
        session_name=$(screen -ls | grep aztec | awk '{print $1}')
        # Extract only the alphabetical part (remove numbers and .aztec)
        session_name=$(echo "$session_name" | sed 's/^[0-9]*\.//;s/\.aztec$//')
        if [[ -z "$session_name" ]]; then
          echo -e "${RED}$(t "no_aztec_screen")${NC}"
          return 1
        fi
        _update_env_var "$env_file" "SCREEN_SESSION" "$session_name"
      fi

      _update_env_var "$env_file" "RUN_TYPE" "CLI"

      screen -S "$session_name" -p 0 -X stuff $'\003'
      sleep 2
      screen -S "$session_name" -X quit
      echo -e "${GREEN}$(t "cli_stop_success")${NC}"
      ;;

    *)
      echo -e "\n${YELLOW}$(t "stop_method_prompt")${NC}"
      read -r method

      case "$method" in
        "docker-compose")
          read -p "$(t "enter_compose_path")" compose_path
          if _validate_compose_path "$compose_path"; then
            _update_env_var "$env_file" "COMPOSE_PATH" "$compose_path"
            _update_env_var "$env_file" "RUN_TYPE" "DOCKER"

            cd "$compose_path" || return 1
            docker compose down
            echo -e "${GREEN}$(t "docker_stop_success")${NC}"
          else
            echo -e "${RED}$(t "invalid_path")${NC}"
            return 1
          fi
          ;;

        "cli")
          local session_name
          session_name=$(screen -ls | grep aztec | awk '{print $1}')
          if [[ -n "$session_name" ]]; then
            # Extract only the alphabetical part (remove numbers and .aztec)
            session_name=$(echo "$session_name" | sed 's/^[0-9]*\.//;s/\.aztec$//')
            _update_env_var "$env_file" "SCREEN_SESSION" "$session_name"
            _update_env_var "$env_file" "RUN_TYPE" "CLI"

            screen -S "$session_name" -p 0 -X stuff $'\003'
            sleep 2
            screen -S "$session_name" -X quit
            echo -e "${GREEN}$(t "cli_stop_success")${NC}"
          else
            echo -e "${RED}$(t "no_aztec_screen")${NC}"
            return 1
          fi
          ;;

        *)
          echo -e "${RED}Invalid method. Choose 'docker-compose' or 'cli'.${NC}"
          return 1
          ;;
      esac
      ;;
  esac
}

# === Start Aztec containers ===
function start_aztec_containers() {
  local env_file
  env_file=$(_ensure_env_file)

  echo -e "\n${YELLOW}$(t "starting_node")${NC}"

  local run_type
  run_type=$(_read_env_var "$env_file" "RUN_TYPE")

  if [[ -z "$run_type" ]]; then
    echo -e "${YELLOW}$(t "run_type_not_set")${NC}"
    read -p "$(t "confirm_cli_run") [y/N] " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      run_type="CLI"
      _update_env_var "$env_file" "RUN_TYPE" "$run_type"
      echo -e "${GREEN}$(t "run_type_set_to_cli")${NC}"
    else
      echo -e "${RED}$(t "run_aborted")${NC}"
      return 1
    fi
  fi

  # Получаем значение NETWORK из env-aztec-agent
  local aztec_agent_env="$HOME/.env-aztec-agent"
  local network="testnet"
  if [[ -f "$aztec_agent_env" ]]; then
    network=$(_read_env_var "$aztec_agent_env" "NETWORK")
    [[ -z "$network" ]] && network="testnet"
  fi

  case "$run_type" in
    "DOCKER")
      local compose_path
      compose_path=$(_read_env_var "$env_file" "COMPOSE_PATH")

      if ! _validate_compose_path "$compose_path"; then
        echo -e "${RED}$(t "missing_compose")${NC}"
        read -p "$(t "enter_compose_path")" compose_path
        if ! _validate_compose_path "$compose_path"; then
          echo -e "${RED}$(t "invalid_path")${NC}"
          return 1
        fi
        _update_env_var "$env_file" "COMPOSE_PATH" "$compose_path"
      fi

      if cd "$compose_path" && docker compose up -d; then
        echo -e "${GREEN}$(t "node_started")${NC}"
      else
        echo -e "${RED}Failed to start Docker containers${NC}"
        return 1
      fi
      ;;

    "CLI")
      local p2p_ip
      p2p_ip=$(curl -s https://api.ipify.org || echo "127.0.0.1")

      declare -A vars=(
        ["RPC_URL"]="Ethereum Execution RPC URL"
        ["CONSENSUS_BEACON_URL"]="Consensus Beacon URL"
        ["VALIDATOR_PRIVATE_KEY"]="Validator Private Key (without 0x)"
        ["COINBASE"]="Coinbase (your EVM wallet address)"
        ["P2P_IP"]="$p2p_ip"
      )

      for key in "${!vars[@]}"; do
        if ! grep -q "^$key=" "$env_file"; then
          local prompt="${vars[$key]}"
          local val
          if [[ "$key" == "P2P_IP" ]]; then
            val="$p2p_ip"
          else
            read -p "$prompt: " val
          fi
          _update_env_var "$env_file" "$key" "$val"
        fi
      done

      local ethereum_rpc_url consensus_beacon_url validator_private_key coinbase
      ethereum_rpc_url=$(_read_env_var "$env_file" "RPC_URL")
      consensus_beacon_url=$(_read_env_var "$env_file" "CONSENSUS_BEACON_URL")
      validator_private_key=$(_read_env_var "$env_file" "VALIDATOR_PRIVATE_KEY")
      coinbase=$(_read_env_var "$env_file" "COINBASE")
      p2p_ip=$(_read_env_var "$env_file" "P2P_IP")

      local session_name
      session_name=$(_read_env_var "$env_file" "SCREEN_SESSION")
      [[ -z "$session_name" ]] && session_name="aztec"
      _update_env_var "$env_file" "SCREEN_SESSION" "$session_name"

      # Проверка и удаление существующих сессий с aztec
      existing_sessions=$(screen -ls | grep -oP '[0-9]+\.aztec[^\s]*')
      if [[ -n "$existing_sessions" ]]; then
        while read -r session; do
          screen -XS "$session" quit
          echo -e "${YELLOW}$(t "cli_quit_old_sessions") $session${NC}"
        done <<< "$existing_sessions"
      fi

      if screen -dmS "$session_name" && \
         screen -S "$session_name" -p 0 -X stuff "aztec start --node --archiver --sequencer \
--network $network \
--l1-rpc-urls $ethereum_rpc_url \
--l1-consensus-host-urls $consensus_beacon_url \
--sequencer.validatorPrivateKeys 0x$validator_private_key \
--sequencer.coinbase $coinbase \
--p2p.p2pIp $p2p_ip"$'\n'; then
        echo -e "${GREEN}$(t "node_started")${NC}"
      else
        echo -e "${RED}Failed to start Aztec in screen session${NC}"
        return 1
      fi
      ;;

    *)
      echo -e "${RED}Unknown RUN_TYPE: $run_type${NC}"
      return 1
      ;;
  esac
}

# === Aztec node version check (via direct JS entrypoint) ===
function check_aztec_version() {

    echo -e "\n${CYAN}$(t "checking_aztec_version")${NC}"
    container_id=$(docker ps --format "{{.ID}} {{.Names}}" \
                   | grep aztec | grep -vE 'watchtower|otel|prometheus|grafana' | head -n 1 | awk '{print $1}')

    if [ -z "$container_id" ]; then
        echo -e "${RED}$(t "container_not_found")${NC}"
        return
    fi

    echo -e "${GREEN}$(t "container_found") ${BLUE}$container_id${NC}"

    # Получаем вывод команды и фильтруем только версию
    version_output=$(docker exec "$container_id" node /usr/src/yarn-project/aztec/dest/bin/index.js --version 2>/dev/null)

    # Извлекаем только строку с версией (игнорируем debug/verbose сообщения)
    version=$(echo "$version_output" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+' | tail -n 1)

    # Альтернативный вариант: ищем последнюю строку, которая соответствует формату версии
    if [ -z "$version" ]; then
        version=$(echo "$version_output" | tail -n 1 | grep -E '^[0-9]+\.[0-9]+\.[0-9]+')
    fi

    # Проверяем версию с поддержкой rc версий (например: 2.0.0-rc.27)
    if [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-rc\.[0-9]+)?$ ]]; then
        echo -e "${GREEN}$(t "aztec_node_version") ${BLUE}$version${NC}"
    else
        echo -e "\n${RED}$(t "aztec_version_failed")${NC}"
        echo -e "${YELLOW}$(t "raw_output"):${NC}"
        echo "$version_output"
    fi
}

# === Approve ===
approve_with_all_keys() {
    # Get network settings
    local settings
    settings=$(get_network_settings)
    local network=$(echo "$settings" | cut -d'|' -f1)
    local rpc_url=$(echo "$settings" | cut -d'|' -f2)
    local contract_address=$(echo "$settings" | cut -d'|' -f3)

    local rpc_providers=(
        "$rpc_url"
        "https://ethereum-sepolia-rpc.publicnode.com"
        "https://1rpc.io/sepolia"
        "https://sepolia.drpc.org"
    )
    local key_files
    local private_key
    local current_rpc_url

    # Find all YML key files
    key_files=$(find $HOME/aztec/keys/ -name "*.yml" -type f)
    if [ -z "$key_files" ]; then
        echo "Error: No YML key files found in $HOME/aztec/keys/"
        return 1
    fi

    # Execute command for each private key sequentially
    for key_file in $key_files; do
        # Skip files with 'bls' in the name
        if [[ "$key_file" == *"bls"* ]]; then
            continue
        fi

        echo ""
        echo "Processing key file: $key_file"

        # Extract private key from YML file
        private_key=$(grep "privateKey:" "$key_file" | awk -F'"' '{print $2}')

        if [ -n "$private_key" ]; then
            echo "Executing with private key from $key_file"

            # Use the first RPC provider from the list
            current_rpc_url="${rpc_providers[0]}"
            echo "Using RPC URL: $current_rpc_url"

            # Execute the cast command
            cast send 0x139d2a7a0881e16332d7D1F8DB383A4507E1Ea7A \
                "approve(address,uint256)" \
                "$contract_address" \
                200000ether \
                --private-key "$private_key" \
                --rpc-url "$current_rpc_url"

            # Wait for completion before proceeding to next key
            wait
        else
            echo "Warning: No privateKey found in $key_file"
        fi
    done
}

# === Add BLS private keys to keystore.json ===
add_bls_to_keystore() {
    echo -e "\n${BLUE}=== $(t "bls_add_to_keystore_title") ===${NC}"

    # Файлы
    local BLS_PK_FILE="$HOME/aztec/bls-filtered-pk.json"
    local KEYSTORE_FILE="$HOME/aztec/config/keystore.json"
    local KEYSTORE_BACKUP="${KEYSTORE_FILE}.backup.$(date +%Y%m%d_%H%M%S)"

    # Проверка существования файлов
    if [ ! -f "$BLS_PK_FILE" ]; then
        echo -e "${RED}$(t "bls_pk_file_not_found")${NC}"
        return 1
    fi

    if [ ! -f "$KEYSTORE_FILE" ]; then
        echo -e "${RED}$(t "bls_keystore_not_found")${NC}"
        return 1
    fi

    # Создаем бекап
    echo -e "${CYAN}$(t "bls_creating_backup")${NC}"
    cp "$KEYSTORE_FILE" "$KEYSTORE_BACKUP"
    echo -e "${GREEN}✅ $(t "bls_backup_created"): $KEYSTORE_BACKUP${NC}"

    # Создаем временный файл
    local TEMP_KEYSTORE=$(mktemp)
    local MATCH_COUNT=0
    local TOTAL_VALIDATORS=0

    # Получаем общее количество валидаторов в keystore.json
    TOTAL_VALIDATORS=$(jq '.validators | length' "$KEYSTORE_FILE")

    echo -e "${CYAN}$(t "bls_processing_validators"): $TOTAL_VALIDATORS${NC}"

    # Создаем ассоциативный массив для сопоставления адресов с BLS ключами
    declare -A ADDRESS_TO_BLS_MAP

    # Заполняем маппинг адресов к BLS ключам из bls-filtered-pk.json
    echo -e "\n${BLUE}$(t "bls_reading_bls_keys")${NC}"
    while IFS= read -r validator; do
        local PRIVATE_KEY=$(echo "$validator" | jq -r '.attester.eth')
        local BLS_KEY=$(echo "$validator" | jq -r '.attester.bls')

        if [ -n "$PRIVATE_KEY" ] && [ "$PRIVATE_KEY" != "null" ] &&
           [ -n "$BLS_KEY" ] && [ "$BLS_KEY" != "null" ]; then

            # Генерируем адрес из приватного ключа
            local ETH_ADDRESS=$(cast wallet address --private-key "$PRIVATE_KEY" 2>/dev/null | tr '[:upper:]' '[:lower:]')

            if [ -n "$ETH_ADDRESS" ]; then
                ADDRESS_TO_BLS_MAP["$ETH_ADDRESS"]="$BLS_KEY"
                echo -e "${GREEN}✅ $(t "bls_mapped_address"): $ETH_ADDRESS${NC}"
            else
                echo -e "${YELLOW}⚠️ $(t "bls_failed_generate_address"): ${PRIVATE_KEY:0:20}...${NC}"
            fi
        fi
    done < <(jq -c '.validators[]' "$BLS_PK_FILE")

    if [ ${#ADDRESS_TO_BLS_MAP[@]} -eq 0 ]; then
        echo -e "${RED}$(t "bls_no_valid_mappings")${NC}"
        rm -f "$TEMP_KEYSTORE"
        return 1
    fi

    echo -e "${GREEN}✅ $(t "bls_total_mappings"): ${#ADDRESS_TO_BLS_MAP[@]}${NC}"

    # Обрабатываем keystore.json и добавляем BLS ключи
    echo -e "\n${BLUE}$(t "bls_updating_keystore")${NC}"

    # Создаем новый массив валидаторов с добавленными BLS ключами
    local UPDATED_VALIDATORS_JSON=$(jq -c \
        --argjson mappings "$(declare -p ADDRESS_TO_BLS_MAP)" \
        '
        .validators = (.validators | map(
            . as $validator |
            $validator.attester.eth as $address |
            if $address and ($address | ascii_downcase) then
                # Ищем соответствующий BLS ключ
                ($address | ascii_downcase) as $normalized_addr |
                if (env | has("ADDRESS_TO_BLS_MAP")) and (env.ADDRESS_TO_BLS_MAP | has($normalized_addr)) then
                    $validator | .attester.bls = env.ADDRESS_TO_BLS_MAP[$normalized_addr]
                else
                    $validator
                end
            else
                $validator
            end
        ))' "$KEYSTORE_FILE" 2>/dev/null)

    # Альтернативный подход через временные файлы
    local TEMP_JSON=$(mktemp)

    # Начинаем сборку нового JSON
    cat "$KEYSTORE_FILE" | jq '.' > "$TEMP_JSON"

    # Обновляем каждый валидатор
    for i in $(seq 0 $((TOTAL_VALIDATORS - 1))); do
        local VALIDATOR_ETH=$(jq -r ".validators[$i].attester.eth" "$TEMP_JSON" | tr '[:upper:]' '[:lower:]')

        if [ -n "$VALIDATOR_ETH" ] && [ "$VALIDATOR_ETH" != "null" ]; then
            if [ -n "${ADDRESS_TO_BLS_MAP[$VALIDATOR_ETH]}" ]; then
                # Обновляем валидатор с добавлением BLS ключа
                jq --arg idx "$i" --arg bls "${ADDRESS_TO_BLS_MAP[$VALIDATOR_ETH]}" \
                    '.validators[$idx | tonumber].attester.bls = $bls' \
                    "$TEMP_JSON" > "${TEMP_JSON}.tmp" && mv "${TEMP_JSON}.tmp" "$TEMP_JSON"

                ((MATCH_COUNT++))
                echo -e "${GREEN}✅ $(t "bls_key_added"): $VALIDATOR_ETH${NC}"
            else
                echo -e "${YELLOW}⚠️ $(t "bls_no_key_for_address"): $VALIDATOR_ETH${NC}"
            fi
        fi
    done

    # Проверяем результат
    if [ $MATCH_COUNT -eq 0 ]; then
        echo -e "${RED}$(t "bls_no_matches_found")${NC}"
        rm -f "$TEMP_JSON" "${TEMP_JSON}.tmp"
        return 1
    fi

    # Проверяем валидность JSON перед сохранением
    if jq empty "$TEMP_JSON" 2>/dev/null; then
        # Сохраняем обновленный файл
        cp "$TEMP_JSON" "$KEYSTORE_FILE"
        echo -e "${GREEN}✅ $(t "bls_keystore_updated")${NC}"
        echo -e "${GREEN}✅ $(t "bls_total_updated"): $MATCH_COUNT/$TOTAL_VALIDATORS${NC}"

        # Показываем пример обновленной структуры
        echo -e "\n${BLUE}=== $(t "bls_updated_structure_sample") ===${NC}"
        jq '.validators[0]' "$KEYSTORE_FILE" | head -20
    else
        echo -e "${RED}$(t "bls_invalid_json")${NC}"
        echo -e "${YELLOW}$(t "bls_restoring_backup")${NC}"
        cp "$KEYSTORE_BACKUP" "$KEYSTORE_FILE"
        rm -f "$TEMP_JSON" "${TEMP_JSON}.tmp"
        return 1
    fi

    # Очистка временных файлов
    rm -f "$TEMP_JSON" "${TEMP_JSON}.tmp"

    echo -e "\n${GREEN}🎉 $(t "bls_operation_completed")${NC}"
    return 0
}

# === Generate BLS keys with mode selection ===
generate_bls_keys() {
    echo -e "\n${BLUE}=== BLS Keys Generation and Transfer ===${NC}"

    # Выбор способа генерации
    echo -e "\n${CYAN}Select an action with BLS:${NC}"
    echo -e "1) $(t "bls_method_new_operator")"
    echo -e "2) $(t "bls_method_existing")"
    echo -e "3) $(t "bls_to_keystore")"
    echo ""
    read -p "$(t "bls_method_prompt") " GENERATION_METHOD

    case $GENERATION_METHOD in
        1)
            generate_bls_new_operator_method
            ;;
        2)
            generate_bls_existing_method
            ;;
        3)
            add_bls_to_keystore
            ;;
        *)
            echo -e "${RED}$(t "bls_invalid_method")${NC}"
            return 1
            ;;
    esac
}

# === Исправленная версия функции для новой структуры keystore.json ===
generate_bls_existing_method() {
    echo -e "\n${BLUE}=== $(t "bls_existing_method_title") ===${NC}"

    # 1. Запрос мнемонической фразы (скрытый ввод)
    echo -e "\n${CYAN}$(t "bls_mnemonic_prompt")${NC}"
    read -s -p "> " MNEMONIC
    echo

    if [ -z "$MNEMONIC" ]; then
        echo -e "${RED}Error: Mnemonic phrase cannot be empty${NC}"
        return 1
    fi

    # 2. Запрос количества кошельков
    echo -e "\n${CYAN}$(t "bls_wallet_count_prompt")${NC}"
    read -p "> " WALLET_COUNT

    if ! [[ "$WALLET_COUNT" =~ ^[1-9][0-9]*$ ]]; then
        echo -e "${RED}$(t "bls_invalid_number")${NC}"
        return 1
    fi

    # 3. Получение feeRecipient из keystore.json
    local KEYSTORE_FILE="$HOME/aztec/config/keystore.json"
    if [ ! -f "$KEYSTORE_FILE" ]; then
        echo -e "${RED}$(t "bls_keystore_not_found")${NC}"
        return 1
    fi

    # Извлекаем feeRecipient из первого валидатора
    local FEE_RECIPIENT_ADDRESS
    FEE_RECIPIENT_ADDRESS=$(jq -r '.validators[0].feeRecipient' "$KEYSTORE_FILE" 2>/dev/null)

    if [ -z "$FEE_RECIPIENT_ADDRESS" ] || [ "$FEE_RECIPIENT_ADDRESS" = "null" ]; then
        echo -e "${RED}$(t "bls_fee_recipient_not_found")${NC}"
        return 1
    fi

    echo -e "${GREEN}Found feeRecipient: $FEE_RECIPIENT_ADDRESS${NC}"

    # 4. Генерация BLS ключей
    echo -e "\n${BLUE}$(t "bls_generating_keys")${NC}"

    local BLS_OUTPUT_FILE="$HOME/aztec/bls.json"
    local BLS_FILTERED_PK_FILE="$HOME/aztec/bls-filtered-pk.json"
    local BLS_ETHWALLET_FILE="$HOME/aztec/bls-ethwallet.json"

    # Выполнение команды генерации
    echo -e "${YELLOW}Running command: aztec validator-keys new... Wait until process will not finished${NC}"

    if aztec validator-keys new \
        --fee-recipient "$FEE_RECIPIENT_ADDRESS" \
        --mnemonic "$MNEMONIC" \
        --count "$WALLET_COUNT" \
        --file "bls.json" \
        --data-dir "$HOME/aztec/"; then

        echo -e "${GREEN}$(t "bls_generation_success")${NC}"
        echo -e "${YELLOW}↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓${NC}"
        echo -e "${YELLOW}$(t "bls_public_save_attention")${NC}"
        echo -e "${YELLOW}↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑${NC}"
    else
        echo -e "${RED}$(t "bls_generation_failed")${NC}"
        return 1
    fi

    # 5. Проверка существования сгенерированного файла
    if [ ! -f "$BLS_OUTPUT_FILE" ]; then
        echo -e "${RED}$(t "bls_file_not_found")${NC}"
        return 1
    fi

    echo -e "${GREEN}✅ Generated BLS file: $BLS_OUTPUT_FILE${NC}"

    # 6. Получаем адреса валидаторов из keystore.json
    echo -e "\n${BLUE}$(t "bls_searching_matches")${NC}"

    # Извлекаем адреса валидаторов из keystore.json в правильном порядке
    local KEYSTORE_VALIDATOR_ADDRESSES=()
    while IFS= read -r address; do
        if [ -n "$address" ] && [ "$address" != "null" ]; then
            KEYSTORE_VALIDATOR_ADDRESSES+=("${address,,}")
        fi
    done < <(jq -r '.validators[].attester.eth' "$KEYSTORE_FILE" 2>/dev/null)

    if [ ${#KEYSTORE_VALIDATOR_ADDRESSES[@]} -eq 0 ]; then
        echo -e "${RED}No validator addresses found in keystore.json${NC}"
        return 1
    fi

    echo -e "${GREEN}Found ${#KEYSTORE_VALIDATOR_ADDRESSES[@]} validators in keystore.json${NC}"

    # 7. Создаем bls-ethwallet.json с добавленными eth адресами
    echo -e "\n${BLUE}=== Creating temp bls-ethwallet.json with ETH addresses ===${NC}"

    # Временный файл для преобразованного JSON
    local TEMP_ETHWALLET=$(mktemp)

    # Читаем исходный bls.json и добавляем eth адреса
    if jq '.validators[]' "$BLS_OUTPUT_FILE" > /dev/null 2>&1; then
        # Создаем новый JSON с добавленными адресами
        local VALIDATORS_WITH_ADDRESSES=()

        while IFS= read -r validator; do
            local PRIVATE_KEY=$(echo "$validator" | jq -r '.attester.eth')
            local BLS_KEY=$(echo "$validator" | jq -r '.attester.bls')

            # Генерируем eth адрес из приватного ключа
            local ETH_ADDRESS=$(cast wallet address --private-key "$PRIVATE_KEY" 2>/dev/null | tr '[:upper:]' '[:lower:]')

            if [ -n "$ETH_ADDRESS" ]; then
                # Создаем новый объект валидатора с добавленным адресом
                local NEW_VALIDATOR=$(jq -n \
                    --arg priv "$PRIVATE_KEY" \
                    --arg bls "$BLS_KEY" \
                    --arg addr "$ETH_ADDRESS" \
                    '{
                        "attester": {
                            "eth": $priv,
                            "bls": $bls,
                            "address": $addr
                        },
                        "feeRecipient": "'"$FEE_RECIPIENT_ADDRESS"'"
                    }')
                VALIDATORS_WITH_ADDRESSES+=("$NEW_VALIDATOR")
            else
                echo -e "${RED}Error: Failed to generate address for private key${NC}"
            fi
        done < <(jq -c '.validators[]' "$BLS_OUTPUT_FILE")

        # Собираем финальный JSON
        if [ ${#VALIDATORS_WITH_ADDRESSES[@]} -gt 0 ]; then
            printf '{\n  "schemaVersion": 1,\n  "validators": [\n' > "$TEMP_ETHWALLET"
            for i in "${!VALIDATORS_WITH_ADDRESSES[@]}"; do
                if [ $i -gt 0 ]; then
                    printf ",\n" >> "$TEMP_ETHWALLET"
                fi
                jq -c . <<< "${VALIDATORS_WITH_ADDRESSES[$i]}" >> "$TEMP_ETHWALLET"
            done
            printf '\n  ]\n}' >> "$TEMP_ETHWALLET"

            mv "$TEMP_ETHWALLET" "$BLS_ETHWALLET_FILE"
            echo -e "${GREEN}✅ Created temp bls-ethwallet.json with ${#VALIDATORS_WITH_ADDRESSES[@]} validators${NC}"
        else
            echo -e "${RED}Error: No validators processed${NC}"
            rm -f "$TEMP_ETHWALLET"
            return 1
        fi
    else
        echo -e "${RED}Error: Invalid JSON format in $BLS_OUTPUT_FILE${NC}"
        return 1
    fi

    # 8. Создаем bls-filtered-pk.json в порядке keystore.json
    echo -e "\n${BLUE}=== Creating final bls-filtered-pk.json in keystore.json order ===${NC}"

    local VALIDATORS_JSON=""
    local MATCH_COUNT=0

    # Создаем ассоциативный массив для быстрого поиска по адресам
    declare -A ADDRESS_TO_KEYS

    # Заполняем массив данными из bls-ethwallet.json
    while IFS= read -r validator; do
        local ETH_ADDRESS=$(echo "$validator" | jq -r '.attester.address' | tr '[:upper:]' '[:lower:]')
        local PRIVATE_KEY=$(echo "$validator" | jq -r '.attester.eth')
        local BLS_KEY=$(echo "$validator" | jq -r '.attester.bls')

        if [ -n "$ETH_ADDRESS" ] && [ "$ETH_ADDRESS" != "null" ]; then
            ADDRESS_TO_KEYS["$ETH_ADDRESS"]="$PRIVATE_KEY|$BLS_KEY"
        fi
    done < <(jq -c '.validators[]' "$BLS_ETHWALLET_FILE")

    # Теперь создаем финальный файл в порядке keystore.json
    for keystore_address in "${KEYSTORE_VALIDATOR_ADDRESSES[@]}"; do
        if [ -n "${ADDRESS_TO_KEYS[$keystore_address]}" ]; then
            ((MATCH_COUNT++))

            # Разбираем данные из массива
            IFS='|' read -r PRIVATE_KEY BLS_KEY <<< "${ADDRESS_TO_KEYS[$keystore_address]}"

            # Добавляем в JSON (сохраняем порядок keystore.json)
            if [ -n "$VALIDATORS_JSON" ]; then
                VALIDATORS_JSON+=","
            fi
            VALIDATORS_JSON+=$(cat <<EOF
    {
      "attester": {
        "eth": "$PRIVATE_KEY",
        "bls": "$BLS_KEY"
      },
      "feeRecipient": "$FEE_RECIPIENT_ADDRESS"
    }
EOF
            )
        else
            echo -e "${YELLOW}⚠️ No matching keys found for address: $keystore_address${NC}"
        fi
    done

    # 9. Создаем итоговый файл
    if [ $MATCH_COUNT -gt 0 ]; then
        cat > "$BLS_FILTERED_PK_FILE" << EOF
{
  "schemaVersion": 1,
  "validators": [
$VALIDATORS_JSON
  ]
}
EOF
        echo -e "${GREEN}✅ BLS keys file created with validators in keystore.json order${NC}"

        # Очистка временных файлов
        rm -f "$BLS_OUTPUT_FILE" "$BLS_ETHWALLET_FILE"

        echo -e "${GREEN}$(printf "$(t "bls_matches_found")" "$MATCH_COUNT")${NC}"
        echo -e "${GREEN}📁 Private keys saved to: $BLS_FILTERED_PK_FILE${NC}"

        return 0
    else
        echo -e "${RED}$(t "bls_no_matches")${NC}"

        # Очистка временных файлов
        rm -f "$BLS_OUTPUT_FILE" "$BLS_ETHWALLET_FILE"
        return 1
    fi
}

# === New operator method для новой структуры keystore.json ===
generate_bls_new_operator_method() {
    echo -e "\n${BLUE}=== $(t "bls_new_operator_title") ===${NC}"

    # Запрос данных старого валидатора
    echo -e "${CYAN}$(t "bls_old_validator_info")${NC}"
    read -sp "$(t "bls_old_private_key_prompt") " PRIVATE_KEYS_INPUT && echo

    # Обработка нескольких приватных ключей через запятую
    local OLD_SEQUENCER_KEYS
    IFS=',' read -ra OLD_SEQUENCER_KEYS <<< "$PRIVATE_KEYS_INPUT"

    if [ ${#OLD_SEQUENCER_KEYS[@]} -eq 0 ]; then
        echo -e "${RED}$(t "bls_no_private_keys")${NC}"
        return 1
    fi

    echo -e "${GREEN}$(t "bls_found_private_keys") ${#OLD_SEQUENCER_KEYS[@]}${NC}"

    # Генерируем адреса для старых валидаторов
    local OLD_VALIDATOR_ADDRESSES=()
    echo -e "\n${BLUE}Generating addresses for old validators...${NC}"
    for private_key in "${OLD_SEQUENCER_KEYS[@]}"; do
        local old_address=$(cast wallet address --private-key "$private_key" 2>/dev/null | tr '[:upper:]' '[:lower:]')
        if [ -n "$old_address" ]; then
            OLD_VALIDATOR_ADDRESSES+=("$old_address")
            echo -e "  ${GREEN}✓${NC} $old_address"
        else
            echo -e "  ${RED}✗${NC} Failed to generate address for key: ${private_key:0:10}..."
            OLD_VALIDATOR_ADDRESSES+=("unknown")
        fi
    done

    # Получаем порядок адресов из keystore.json
    local KEYSTORE_FILE="$HOME/aztec/config/keystore.json"
    if [ ! -f "$KEYSTORE_FILE" ]; then
        echo -e "${RED}$(t "bls_keystore_not_found")${NC}"
        return 1
    fi

    # Извлекаем адреса валидаторов из новой структуры keystore.json
    local KEYSTORE_VALIDATOR_ADDRESSES=()
    while IFS= read -r address; do
        if [ -n "$address" ] && [ "$address" != "null" ]; then
            KEYSTORE_VALIDATOR_ADDRESSES+=("${address,,}")
        fi
    done < <(jq -r '.validators[].attester.eth' "$KEYSTORE_FILE" 2>/dev/null)

    if [ ${#KEYSTORE_VALIDATOR_ADDRESSES[@]} -eq 0 ]; then
        echo -e "${RED}No validator addresses found in keystore.json${NC}"
        return 1
    fi

    echo -e "${GREEN}Found ${#KEYSTORE_VALIDATOR_ADDRESSES[@]} validators in keystore.json${NC}"

    # Получаем feeRecipient из keystore.json
    local FEE_RECIPIENT_ADDRESS
    FEE_RECIPIENT_ADDRESS=$(jq -r '.validators[0].feeRecipient' "$KEYSTORE_FILE" 2>/dev/null)

    if [ -z "$FEE_RECIPIENT_ADDRESS" ] || [ "$FEE_RECIPIENT_ADDRESS" = "null" ]; then
        echo -e "${RED}$(t "bls_fee_recipient_not_found")${NC}"
        return 1
    fi

    echo -e "${GREEN}Found feeRecipient: $FEE_RECIPIENT_ADDRESS${NC}"

    # Используем стандартный RPC URL вместо запроса у пользователя
    local RPC_URL="https://ethereum-sepolia-rpc.publicnode.com"
    echo -e "${GREEN}$(t "bls_starting_generation")${NC}"
    echo -e "${CYAN}Using default RPC: $RPC_URL${NC}"

    # Создаем папку для временных файлов
    local TEMP_DIR=$(mktemp -d)

    # Ассоциативные массивы для хранения ключей по адресам
    declare -A OLD_PRIVATE_KEYS_MAP
    declare -A NEW_ETH_PRIVATE_KEYS_MAP
    declare -A NEW_BLS_KEYS_MAP
    declare -A NEW_ETH_ADDRESSES_MAP

    # Заполняем маппинг старых приватных ключей по адресам
    for ((i=0; i<${#OLD_VALIDATOR_ADDRESSES[@]}; i++)); do
        if [ "${OLD_VALIDATOR_ADDRESSES[$i]}" != "unknown" ]; then
            OLD_PRIVATE_KEYS_MAP["${OLD_VALIDATOR_ADDRESSES[$i]}"]="${OLD_SEQUENCER_KEYS[$i]}"
        fi
    done

    echo -e "${YELLOW}$(t "bls_ready_to_generate")${NC}"

    # Генерация отдельных ключей для каждого валидатора
    for ((i=0; i<${#OLD_SEQUENCER_KEYS[@]}; i++)); do
        echo -e "\n${BLUE}Generating keys for validator $((i+1))/${#OLD_SEQUENCER_KEYS[@]}...${NC}"

        # Удаляем старый файл и генерируем новые ключи
        rm -f ~/.aztec/keystore/key1.json
        read -p "$(t "bls_press_enter_to_generate") " -r

        # Генерация новых ключей с правильным feeRecipient
        if ! aztec validator-keys new --fee-recipient "$FEE_RECIPIENT_ADDRESS"; then
            echo -e "${RED}$(t "bls_generation_failed")${NC}"
            rm -rf "$TEMP_DIR"
            return 1
        fi

        # Извлечение новых ключей
        local KEYSTORE_FILE=~/.aztec/keystore/key1.json
        if [ ! -f "$KEYSTORE_FILE" ]; then
            echo -e "${RED}$(t "bls_keystore_not_found")${NC}"
            rm -rf "$TEMP_DIR"
            return 1
        fi

        local NEW_ETH_PRIVATE_KEY=$(jq -r '.validators[0].attester.eth' "$KEYSTORE_FILE" 2>/dev/null)
        local BLS_ATTESTER_PRIV_KEY=$(jq -r '.validators[0].attester.bls' "$KEYSTORE_FILE" 2>/dev/null)
        local ETH_ATTESTER_ADDRESS=$(cast wallet address --private-key "$NEW_ETH_PRIVATE_KEY" 2>/dev/null | tr '[:upper:]' '[:lower:]')

        if [ -z "$NEW_ETH_PRIVATE_KEY" ] || [ "$NEW_ETH_PRIVATE_KEY" = "null" ] ||
           [ -z "$BLS_ATTESTER_PRIV_KEY" ] || [ "$BLS_ATTESTER_PRIV_KEY" = "null" ]; then
            echo -e "${RED}$(t "bls_key_extraction_failed")${NC}"
            rm -rf "$TEMP_DIR"
            return 1
        fi

        # Сохраняем ключи в ассоциативные массивы по старому адресу
        local OLD_ADDRESS="${OLD_VALIDATOR_ADDRESSES[$i]}"
        if [ "$OLD_ADDRESS" != "unknown" ]; then
            NEW_ETH_PRIVATE_KEYS_MAP["$OLD_ADDRESS"]="$NEW_ETH_PRIVATE_KEY"
            NEW_BLS_KEYS_MAP["$OLD_ADDRESS"]="$BLS_ATTESTER_PRIV_KEY"
            NEW_ETH_ADDRESSES_MAP["$OLD_ADDRESS"]="$ETH_ATTESTER_ADDRESS"
        fi

        # Показываем пользователю новые ключи
        echo -e "${GREEN}✅ Keys generated for validator $((i+1))${NC}"
        echo -e "   - $(t "bls_new_eth_private_key"): ${NEW_ETH_PRIVATE_KEY:0:20}..."
        echo -e "   - $(t "bls_new_bls_private_key"): ${BLS_ATTESTER_PRIV_KEY:0:20}..."
        echo -e "   - $(t "bls_new_public_address"): $ETH_ATTESTER_ADDRESS"

        # Сохраняем копию файла для каждого валидатора
        cp "$KEYSTORE_FILE" "$TEMP_DIR/keystore_validator_$((i+1)).json"
    done

    echo ""

    # Сохраняем ключи в файл для совместимости с stake_validators
    local BLS_PK_FILE="$HOME/aztec/bls-filtered-pk.json"

    # Создаем массив валидаторов в порядке keystore.json
    local VALIDATORS_JSON=""
    local MATCH_COUNT=0

    for keystore_address in "${KEYSTORE_VALIDATOR_ADDRESSES[@]}"; do
        if [ -n "${OLD_PRIVATE_KEYS_MAP[$keystore_address]}" ] &&
           [ -n "${NEW_ETH_PRIVATE_KEYS_MAP[$keystore_address]}" ] &&
           [ -n "${NEW_BLS_KEYS_MAP[$keystore_address]}" ] &&
           [ -n "${NEW_ETH_ADDRESSES_MAP[$keystore_address]}" ]; then

            ((MATCH_COUNT++))

            if [ -n "$VALIDATORS_JSON" ]; then
                VALIDATORS_JSON+=","
            fi

            VALIDATORS_JSON+=$(cat <<EOF
    {
      "attester": {
        "eth": "${OLD_PRIVATE_KEYS_MAP[$keystore_address]}",
        "bls": "${NEW_BLS_KEYS_MAP[$keystore_address]}",
        "old_address": "$keystore_address"
      },
      "feeRecipient": "$FEE_RECIPIENT_ADDRESS",
      "new_operator_info": {
        "eth_private_key": "${NEW_ETH_PRIVATE_KEYS_MAP[$keystore_address]}",
        "bls_private_key": "${NEW_BLS_KEYS_MAP[$keystore_address]}",
        "eth_address": "${NEW_ETH_ADDRESSES_MAP[$keystore_address]}",
        "rpc_url": "$RPC_URL"
      }
    }
EOF
            )
        else
            echo -e "${YELLOW}⚠️ No matching keys found for address: $keystore_address${NC}"
        fi
    done

    if [ $MATCH_COUNT -eq 0 ]; then
        echo -e "${RED}No matching validators found between provided keys and keystore.json${NC}"
        rm -rf "$TEMP_DIR"
        return 1
    fi

    cat > "$BLS_PK_FILE" << EOF
{
  "schemaVersion": 1,
  "validators": [
$VALIDATORS_JSON
  ]
}
EOF

    # Очищаем временную папку
    rm -rf "$TEMP_DIR"

    # Показываем сводную информацию
    echo -e "${GREEN}✅ $(t "bls_keys_saved_success")${NC}"
    echo -e "\n${BLUE}=== Summary of generated validators (in keystore.json order) ===${NC}"

    for keystore_address in "${KEYSTORE_VALIDATOR_ADDRESSES[@]}"; do
        if [ -n "${OLD_PRIVATE_KEYS_MAP[$keystore_address]}" ] &&
           [ -n "${NEW_ETH_ADDRESSES_MAP[$keystore_address]}" ]; then
            echo -e "${CYAN}Validator: $keystore_address${NC}"
            echo -e "  Old address: $keystore_address"
            echo -e "  New address: ${NEW_ETH_ADDRESSES_MAP[$keystore_address]}"
            echo -e "  Funding required: ${NEW_ETH_ADDRESSES_MAP[$keystore_address]}"
            echo ""
        fi
    done

    echo -e "${YELLOW}$(t "bls_next_steps")${NC}"
    echo -e "   1. $(t "bls_send_eth_step")"
    echo -e "   2. $(t "bls_run_approve_step")"
    echo -e "   3. $(t "bls_run_stake_step")"

    return 0
}

# === Stake validators ===
stake_validators() {
    echo -e "\n${BLUE}=== $(t "staking_title") ===${NC}"

    # Get network settings
    local settings
    settings=$(get_network_settings)
    local network=$(echo "$settings" | cut -d'|' -f1)
    local rpc_url=$(echo "$settings" | cut -d'|' -f2)
    local contract_address=$(echo "$settings" | cut -d'|' -f3)

    # Проверяем существование необходимых файлов
    local KEYSTORE_FILE="$HOME/aztec/config/keystore.json"
    local BLS_PK_FILE="$HOME/aztec/bls-filtered-pk.json"

    if [ ! -f "$BLS_PK_FILE" ]; then
        printf "${RED}❌ $(t "file_not_found")${NC}\n" "bls-filtered-pk.json" "$BLS_PK_FILE"
        echo -e "${YELLOW}$(t "staking_run_bls_generation_first")${NC}"
        return 1
    fi

    # Правильная проверка формата - ищем поле new_operator_info внутри validators
    if jq -e '.validators[0].new_operator_info' "$BLS_PK_FILE" > /dev/null 2>&1; then
        # Новый формат - есть информация о новом операторе внутри валидаторов
        echo -e "${GREEN}🔍 Detected new operator method format${NC}"
        stake_validators_new_format "$network" "$rpc_url" "$contract_address"
    else
        # Старый формат - нет информации о новом операторе
        echo -e "${GREEN}🔍 Detected existing method format${NC}"
        stake_validators_old_format "$network" "$rpc_url" "$contract_address"
    fi
}

# === Old format (existing method) ===
stake_validators_old_format() {
    local network="$1"
    local rpc_url="$2"
    local contract_address="$3"

    local KEYSTORE_FILE="$HOME/aztec/config/keystore.json"
    local BLS_PK_FILE="$HOME/aztec/bls-filtered-pk.json"

    if [ ! -f "$KEYSTORE_FILE" ]; then
        printf "${RED}❌ $(t "file_not_found")${NC}\n" "keystore.json" "$KEYSTORE_FILE"
        return 1
    fi

    if [ ! -f "$BLS_PK_FILE" ]; then
        printf "${RED}❌ $(t "file_not_found")${NC}\n" \
         "bls-filtered-pk.json" "$BLS_PK_FILE"
        return 1
    fi

    # Формируем ссылку для валидатора в зависимости от сети
    local validator_link_template
    if [[ "$network" == "mainnet" ]]; then
        validator_link_template="https://dashtec.xyz/validators/\$validator"
    else
        validator_link_template="https://${network}.dashtec.xyz/validators/\$validator"
    fi

    # Оригинальная логика для существующего метода
    local VALIDATOR_COUNT=$(jq -r '.validators | length' "$BLS_PK_FILE" 2>/dev/null)
    if [ -z "$VALIDATOR_COUNT" ] || [ "$VALIDATOR_COUNT" -eq 0 ]; then
        echo -e "${RED}❌ $(t "staking_no_validators") $BLS_PK_FILE${NC}"
        return 1
    fi

    printf "${GREEN}$(t "staking_found_validators")${NC}\n" "$VALIDATOR_COUNT"
    echo ""

    # Список RPC провайдеров
    local rpc_providers=(
        "$rpc_url"
        "https://ethereum-sepolia-rpc.publicnode.com"
        "https://1rpc.io/sepolia"
        "https://sepolia.drpc.org"
    )

    printf "${YELLOW}$(t "using_contract_address")${NC}\n" "$contract_address"
    echo ""

    # Цикл по всем валидаторам
    for ((i=0; i<VALIDATOR_COUNT; i++)); do
        printf "\n${BLUE}=== $(t "staking_processing") ===${NC}\n" \
         "$((i+1))" "$VALIDATOR_COUNT"
         echo ""

        # Из BLS файла берем приватные ключи
        local PRIVATE_KEY_OF_OLD_SEQUENCER=$(jq -r ".validators[$i].attester.eth" "$BLS_PK_FILE" 2>/dev/null)
        local BLS_ATTESTER_PRIV_KEY=$(jq -r ".validators[$i].attester.bls" "$BLS_PK_FILE" 2>/dev/null)

        # Из keystore файла берем Ethereum адреса
        local ETH_ATTESTER_ADDRESS=$(jq -r ".validators[$i].attester.eth" "$KEYSTORE_FILE" 2>/dev/null)

        # Проверяем что все данные получены
        if [ -z "$PRIVATE_KEY_OF_OLD_SEQUENCER" ] || [ "$PRIVATE_KEY_OF_OLD_SEQUENCER" = "null" ]; then
            printf "${RED}❌ $(t "staking_failed_private_key")${NC}\n" \
            "$((i+1))"
            continue
        fi

        if [ -z "$ETH_ATTESTER_ADDRESS" ] || [ "$ETH_ATTESTER_ADDRESS" = "null" ]; then
            printf "${RED}❌ $(t "staking_failed_eth_address")${NC}\n" \
            "$((i+1))"
            continue
        fi

        if [ -z "$BLS_ATTESTER_PRIV_KEY" ] || [ "$BLS_ATTESTER_PRIV_KEY" = "null" ]; then
            printf "${RED}❌ $(t "staking_failed_bls_key")${NC}\n" \
            "$((i+1))"
            continue
        fi

        echo -e "${GREEN}✓ $(t "staking_data_loaded")${NC}"
        echo -e "  $(t "eth_address"): $ETH_ATTESTER_ADDRESS"
        echo -e "  $(t "private_key"): ${PRIVATE_KEY_OF_OLD_SEQUENCER:0:10}..."
        echo -e "  $(t "bls_key"): ${BLS_ATTESTER_PRIV_KEY:0:20}..."

        # Цикл по RPC провайдерам
        local success=false
        for current_rpc_url in "${rpc_providers[@]}"; do
            printf "\n${YELLOW}$(t "staking_trying_rpc")${NC}\n" \
                  "$current_rpc_url"
             echo ""

            # Формируем команду
            local cmd="aztec add-l1-validator \\
  --l1-rpc-urls \"$current_rpc_url\" \\
  --network $network \\
  --private-key \"$PRIVATE_KEY_OF_OLD_SEQUENCER\" \\
  --attester \"$ETH_ATTESTER_ADDRESS\" \\
  --withdrawer \"$ETH_ATTESTER_ADDRESS\" \\
  --bls-secret-key \"$BLS_ATTESTER_PRIV_KEY\" \\
  --rollup \"$contract_address\""

            # Показываем команду с частичными приватными ключами (первые 7 символов)
            local PRIVATE_KEY_PREVIEW="${PRIVATE_KEY_OF_OLD_SEQUENCER:0:7}..."
            local BLS_KEY_PREVIEW="${BLS_ATTESTER_PRIV_KEY:0:7}..."

            local safe_cmd="aztec add-l1-validator \\
  --l1-rpc-urls \"$current_rpc_url\" \\
  --network $network \\
  --private-key \"$PRIVATE_KEY_PREVIEW\" \\
  --attester \"$ETH_ATTESTER_ADDRESS\" \\
  --withdrawer \"$ETH_ATTESTER_ADDRESS\" \\
  --bls-secret-key \"$BLS_KEY_PREVIEW\" \\
  --rollup \"$contract_address\""

            echo -e "${CYAN}$(t "command_to_execute")${NC}"
            echo -e "$safe_cmd"

            # Запрос подтверждения
            echo -e "\n${YELLOW}$(t "staking_command_prompt")${NC}"
            read -p "$(t "staking_execute_prompt"): " confirm

            case "$confirm" in
                [yY])
                    echo -e "${GREEN}$(t "staking_executing")${NC}"

                    if eval "$cmd"; then
                        printf "${GREEN}✅ $(t "staking_success")${NC}\n" \
                            "$((i+1))" "$current_rpc_url"
                        # Показываем ссылку на валидатора
                        local validator_link
                        if [[ "$network" == "mainnet" ]]; then
                            validator_link="https://dashtec.xyz/validators/$ETH_ATTESTER_ADDRESS"
                        else
                            validator_link="https://${network}.dashtec.xyz/validators/$ETH_ATTESTER_ADDRESS"
                        fi
                        echo -e "${CYAN}🌐 $(t "validator_link"): $validator_link${NC}"
                         echo ""

                        success=true
                        break  # Переходим к следующему валидатору
                    else
                        printf "${RED}❌ $(t "staking_failed")${NC}\n" \
                         "$((i+1))" "$current_rpc_url"
                         echo ""
                        echo -e "${YELLOW}$(t "trying_next_rpc")${NC}"
                    fi
                    ;;
                [sS])
                    printf "${YELLOW}⏭️ $(t "staking_skipped_validator")${NC}\n" \
                     "$((i+1))"
                    success=true  # Помечаем как "успех" чтобы перейти к следующему
                    break
                    ;;
                [qQ])
                    echo -e "${YELLOW}🛑 $(t "staking_cancelled")${NC}"
                    return 0
                    ;;
                *)
                    echo -e "${YELLOW}⏭️ $(t "staking_skipped_rpc")${NC}"
                    ;;
            esac
        done

        if [ "$success" = false ]; then
            printf "${RED}❌ $(t "staking_all_failed")${NC}\n" \
             "$((i+1))"
             echo ""
            echo -e "${YELLOW}$(t "continuing_next_validator")${NC}"
        fi

        # Небольшая пауза между валидаторами
        if [ $i -lt $((VALIDATOR_COUNT-1)) ]; then
            echo -e "\n${BLUE}--- $(t "waiting_before_next_validator") ---${NC}"
            sleep 2
        fi
    done

    echo -e "\n${GREEN}✅ $(t "staking_completed")${NC}"
    return 0
}

# === New format (new operator method) ===
stake_validators_new_format() {
    local network="$1"
    local rpc_url="$2"
    local contract_address="$3"

    local BLS_PK_FILE="$HOME/aztec/bls-filtered-pk.json"
    local KEYSTORE_FILE="$HOME/aztec/config/keystore.json"

    # Получаем количество валидаторов
    local VALIDATOR_COUNT=$(jq -r '.validators | length' "$BLS_PK_FILE" 2>/dev/null)
    if [ -z "$VALIDATOR_COUNT" ] || [ "$VALIDATOR_COUNT" -eq 0 ]; then
        echo -e "${RED}❌ $(t "staking_no_validators")${NC}"
        return 1
    fi

    echo -e "${GREEN}$(t "staking_found_validators_new_operator")${NC}" "$VALIDATOR_COUNT"
    echo ""

    # Создаем папку для ключей если не существует
    local KEYS_DIR="$HOME/aztec/keys"
    mkdir -p "$KEYS_DIR"

    printf "${YELLOW}$(t "using_contract_address")${NC}\n" "$contract_address"
    echo ""

    # Создаем резервную копию keystore.json перед изменениями
    local KEYSTORE_BACKUP="$KEYSTORE_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    if [ -f "$KEYSTORE_FILE" ]; then
        cp "$KEYSTORE_FILE" "$KEYSTORE_BACKUP"
        echo -e "${YELLOW}📁 $(t "staking_keystore_backup_created")${NC}" "$KEYSTORE_BACKUP"
    fi

    # Цикл по всем валидаторам
    for ((i=0; i<VALIDATOR_COUNT; i++)); do
        printf "\n${BLUE}=== $(t "staking_processing_new_operator") ===${NC}\n" \
         "$((i+1))" "$VALIDATOR_COUNT"
         echo ""

        # Получаем данные для текущего валидатора
        local PRIVATE_KEY_OF_OLD_SEQUENCER=$(jq -r ".validators[$i].attester.eth" "$BLS_PK_FILE" 2>/dev/null)
        local OLD_VALIDATOR_ADDRESS=$(jq -r ".validators[$i].attester.old_address" "$BLS_PK_FILE" 2>/dev/null)
        local NEW_ETH_PRIVATE_KEY=$(jq -r ".validators[$i].new_operator_info.eth_private_key" "$BLS_PK_FILE" 2>/dev/null)
        local BLS_ATTESTER_PRIV_KEY=$(jq -r ".validators[$i].new_operator_info.bls_private_key" "$BLS_PK_FILE" 2>/dev/null)
        local ETH_ATTESTER_ADDRESS=$(jq -r ".validators[$i].new_operator_info.eth_address" "$BLS_PK_FILE" 2>/dev/null)
        local VALIDATOR_RPC_URL=$(jq -r ".validators[$i].new_operator_info.rpc_url" "$BLS_PK_FILE" 2>/dev/null)

        # Приводим адреса к нижнему регистру для сравнения
        local OLD_VALIDATOR_ADDRESS_LOWER=$(echo "$OLD_VALIDATOR_ADDRESS" | tr '[:upper:]' '[:lower:]')
        local ETH_ATTESTER_ADDRESS_LOWER=$(echo "$ETH_ATTESTER_ADDRESS" | tr '[:upper:]' '[:lower:]')

        # Проверяем что все данные получены
        if [ -z "$PRIVATE_KEY_OF_OLD_SEQUENCER" ] || [ "$PRIVATE_KEY_OF_OLD_SEQUENCER" = "null" ] ||
           [ -z "$NEW_ETH_PRIVATE_KEY" ] || [ "$NEW_ETH_PRIVATE_KEY" = "null" ] ||
           [ -z "$BLS_ATTESTER_PRIV_KEY" ] || [ "$BLS_ATTESTER_PRIV_KEY" = "null" ] ||
           [ -z "$ETH_ATTESTER_ADDRESS" ] || [ "$ETH_ATTESTER_ADDRESS" = "null" ]; then
            printf "${RED}❌ $(t "staking_failed_private_key")${NC}\n" "$((i+1))"
            continue
        fi

        echo -e "${GREEN}✓ $(t "staking_data_loaded")${NC}"
        echo -e "  Old address: $OLD_VALIDATOR_ADDRESS"
        echo -e "  New address: $ETH_ATTESTER_ADDRESS"
        echo -e "  $(t "private_key"): ${PRIVATE_KEY_OF_OLD_SEQUENCER:0:10}..."
        echo -e "  $(t "bls_key"): ${BLS_ATTESTER_PRIV_KEY:0:20}..."

        # Список RPC провайдеров (используем сохраненный или дефолтный список)
        local rpc_providers=("${VALIDATOR_RPC_URL:-$rpc_url}")
        if [ -z "$VALIDATOR_RPC_URL" ] || [ "$VALIDATOR_RPC_URL" = "null" ]; then
            rpc_providers=(
                "$rpc_url"
                "https://ethereum-sepolia-rpc.publicnode.com"
                "https://1rpc.io/sepolia"
                "https://sepolia.drpc.org"
            )
        fi

        # Цикл по RPC провайдерам
        local success=false
        for current_rpc_url in "${rpc_providers[@]}"; do
            printf "\n${YELLOW}$(t "staking_trying_rpc")${NC}\n" "$current_rpc_url"
            echo ""

            # Формируем команду
            local cmd="aztec add-l1-validator \\
  --l1-rpc-urls \"$current_rpc_url\" \\
  --network $network \\
  --private-key \"$PRIVATE_KEY_OF_OLD_SEQUENCER\" \\
  --attester \"$ETH_ATTESTER_ADDRESS\" \\
  --withdrawer \"$ETH_ATTESTER_ADDRESS\" \\
  --bls-secret-key \"$BLS_ATTESTER_PRIV_KEY\" \\
  --rollup \"$contract_address\""

            # Безопасное отображение команды
            local PRIVATE_KEY_PREVIEW="${PRIVATE_KEY_OF_OLD_SEQUENCER:0:7}..."
            local BLS_KEY_PREVIEW="${BLS_ATTESTER_PRIV_KEY:0:7}..."

            local safe_cmd="aztec add-l1-validator \\
  --l1-rpc-urls \"$current_rpc_url\" \\
  --network $network \\
  --private-key \"$PRIVATE_KEY_PREVIEW\" \\
  --attester \"$ETH_ATTESTER_ADDRESS\" \\
  --withdrawer \"$ETH_ATTESTER_ADDRESS\" \\
  --bls-secret-key \"$BLS_KEY_PREVIEW\" \\
  --rollup \"$contract_address\""

            echo -e "${CYAN}$(t "command_to_execute")${NC}"
            echo -e "$safe_cmd"

            # Запрос подтверждения
            echo -e "\n${YELLOW}$(t "staking_command_prompt")${NC}"
            read -p "$(t "staking_execute_prompt"): " confirm

            case "$confirm" in
                [yY])
                    echo -e "${GREEN}$(t "staking_executing")${NC}"
                    if eval "$cmd"; then
                        printf "${GREEN}✅ $(t "staking_success_new_operator")${NC}\n" \
                                    "$((i+1))" "$current_rpc_url"

                        local validator_link
                        if [[ "$network" == "mainnet" ]]; then
                            validator_link="https://dashtec.xyz/validators/$ETH_ATTESTER_ADDRESS"
                        else
                            validator_link="https://${network}.dashtec.xyz/validators/$ETH_ATTESTER_ADDRESS"
                        fi
                        echo -e "${CYAN}🌐 $(t "validator_link"): $validator_link${NC}"

                        # Создаем YML файл для успешно застейканного валидатора
                        local YML_FILE="$KEYS_DIR/new_validator_$((i+1)).yml"
                        cat > "$YML_FILE" << EOF
type: "file-raw"
keyType: "SECP256K1"
privateKey: "$NEW_ETH_PRIVATE_KEY"
EOF

                        if [ -f "$YML_FILE" ]; then
                            echo -e "${GREEN}📁 $(t "staking_yml_file_created")${NC}" "$YML_FILE"

                            # Перезапускаем web3signer для загрузки нового ключа
                            echo -e "${BLUE}🔄 $(t "staking_restarting_web3signer")${NC}"
                            if docker restart web3signer > /dev/null 2>&1; then
                                echo -e "${GREEN}✅ $(t "staking_web3signer_restarted")${NC}"

                                # Проверяем статус web3signer после перезапуска
                                sleep 3
                                if docker ps | grep -q web3signer; then
                                    echo -e "${GREEN}✅ $(t "staking_web3signer_running")${NC}"
                                else
                                    echo -e "${YELLOW}⚠️ $(t "staking_web3signer_not_running")${NC}"
                                fi
                            else
                                echo -e "${RED}❌ $(t "staking_web3signer_restart_failed")${NC}"
                            fi
                        else
                            echo -e "${RED}⚠️ $(t "staking_yml_file_failed")${NC}" "$YML_FILE"
                        fi

                        # Заменяем старый адрес валидатора на новый в keystore.json
                        if [ -f "$KEYSTORE_FILE" ] && [ "$OLD_VALIDATOR_ADDRESS" != "null" ] && [ -n "$OLD_VALIDATOR_ADDRESS" ]; then
                            echo -e "${BLUE}🔄 $(t "staking_updating_keystore")${NC}"

                            # Создаем временный файл для обновленного keystore
                            local TEMP_KEYSTORE=$(mktemp)

                            # Заменяем старый адрес на новый в keystore.json (регистронезависимо)
                            if jq --arg old_addr_lower "$OLD_VALIDATOR_ADDRESS_LOWER" \
                                  --arg new_addr "$ETH_ATTESTER_ADDRESS" \
                                  'walk(if type == "object" and has("attester") and (.attester | ascii_downcase) == $old_addr_lower then .attester = $new_addr else . end)' \
                                  "$KEYSTORE_FILE" > "$TEMP_KEYSTORE"; then

                                # Проверяем, что замена произошла
                                if jq -e --arg new_addr "$ETH_ATTESTER_ADDRESS" \
                                         'any(.validators[]; .attester == $new_addr)' "$TEMP_KEYSTORE" > /dev/null; then

                                    mv "$TEMP_KEYSTORE" "$KEYSTORE_FILE"
                                    echo -e "${GREEN}✅ $(t "staking_keystore_updated")${NC}" "$OLD_VALIDATOR_ADDRESS → $ETH_ATTESTER_ADDRESS"

                                    # Дополнительная проверка: находим все вхождения нового адреса
                                    local MATCH_COUNT=$(jq -r --arg new_addr "$ETH_ATTESTER_ADDRESS" \
                                                         '[.validators[] | select(.attester == $new_addr)] | length' "$KEYSTORE_FILE")
                                    echo -e "${CYAN}🔍 Found $MATCH_COUNT occurrence(s) of new address in keystore${NC}"

                                else
                                    echo -e "${YELLOW}⚠️ $(t "staking_keystore_no_change")${NC}" "$OLD_VALIDATOR_ADDRESS"
                                    echo -e "${CYAN}Debug: Searching for old address in keystore...${NC}"

                                    # Отладочная информация: проверяем наличие старого адреса в keystore
                                    local OLD_ADDR_COUNT=$(jq -r --arg old_addr_lower "$OLD_VALIDATOR_ADDRESS_LOWER" \
                                                         '[.validators[] | select(.attester | ascii_downcase == $old_addr_lower)] | length' "$KEYSTORE_FILE")
                                    echo -e "${CYAN}Debug: Found $OLD_ADDR_COUNT occurrence(s) of old address (case-insensitive)${NC}"

                                    rm -f "$TEMP_KEYSTORE"
                                fi
                            else
                                echo -e "${RED}❌ $(t "staking_keystore_update_failed")${NC}"
                                rm -f "$TEMP_KEYSTORE"
                            fi
                        else
                            echo -e "${YELLOW}⚠️ $(t "staking_keystore_skip_update")${NC}"
                        fi

                        success=true
                        break
                    else
                        printf "${RED}❌ $(t "staking_failed_new_operator")${NC}\n" \
                         "$((i+1))" "$current_rpc_url"
                        echo -e "${YELLOW}$(t "trying_next_rpc")${NC}"
                    fi
                    ;;
                [sS])
                    printf "${YELLOW}⏭️ $(t "staking_skipped_validator")${NC}\n" "$((i+1))"
                    success=true
                    break
                    ;;
                [qQ])
                    echo -e "${YELLOW}🛑 $(t "staking_cancelled")${NC}"
                    return 0
                    ;;
                *)
                    echo -e "${YELLOW}⏭️ $(t "staking_skipped_rpc")${NC}"
                    ;;
            esac
        done

        if [ "$success" = false ]; then
            printf "${RED}❌ $(t "staking_all_failed_new_operator")${NC}\n" "$((i+1))"
            echo -e "${YELLOW}$(t "continuing_next_validator")${NC}"
        fi

        # Небольшая пауза между валидаторами
        if [ $i -lt $((VALIDATOR_COUNT-1)) ]; then
            echo -e "\n${BLUE}--- $(t "waiting_before_next_validator") ---${NC}"
            sleep 2
        fi
    done

    echo -e "\n${GREEN}✅ $(t "staking_completed_new_operator")${NC}"
    echo -e "${YELLOW}$(t "bls_restart_node_notice")${NC}"

    # Показываем итоговую информацию о созданных файлах
    local CREATED_FILES=$(find "$KEYS_DIR" -name "new_validator_*.yml" | wc -l)
    if [ "$CREATED_FILES" -gt 0 ]; then
        echo -e "${GREEN}📂 $(t "staking_total_yml_files_created")${NC}" "$CREATED_FILES"
        echo -e "${CYAN}$(t "staking_yml_files_location")${NC}" "$KEYS_DIR"

        # Финальный перезапуск web3signer для гарантии загрузки всех ключей
        echo -e "\n${BLUE}🔄 $(t "staking_final_web3signer_restart")${NC}"
        if docker restart web3signer > /dev/null 2>&1; then
            echo -e "${GREEN}✅ $(t "staking_final_web3signer_restarted")${NC}"
        else
            echo -e "${YELLOW}⚠️ $(t "staking_final_web3signer_restart_failed")${NC}"
        fi
    fi

    return 0
}

# === Claim Rewards Function ===
claim_rewards() {
    echo -e "\n${BLUE}=== $(t "aztec_rewards_claim") ===${NC}"
    echo ""

    # Get network settings
    local settings
    settings=$(get_network_settings)
    local network=$(echo "$settings" | cut -d'|' -f1)
    local rpc_url=$(echo "$settings" | cut -d'|' -f2)
    local contract_address=$(echo "$settings" | cut -d'|' -f3)

    # Determine token symbol based on network
    local TOKEN_SYMBOL="STK"
    if [[ "$network" == "mainnet" ]]; then
        TOKEN_SYMBOL="AZTEC"
    fi

    local KEYSTORE_FILE="$HOME/aztec/config/keystore.json"

    echo -e "${CYAN}$(t "using_contract") $contract_address${NC}"
    echo -e "${CYAN}$(t "using_rpc") $rpc_url${NC}"

    # Check if rewards are claimable
    echo -e "\n${BLUE}🔍 $(t "checking_rewards_claimable")${NC}"
    local claimable_result
    claimable_result=$(cast call "$contract_address" "isRewardsClaimable()" --rpc-url "$rpc_url" 2>/dev/null)

    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ $(t "failed_check_rewards_claimable")${NC}"
        return 1
    fi

    if [ "$claimable_result" != "0x1" ]; then
            echo -e "${RED}❌ $(t "rewards_not_claimable")${NC}"

            # Get earliest claimable timestamp for information
            local timestamp_result
            timestamp_result=$(cast call "$contract_address" "getEarliestRewardsClaimableTimestamp()" --rpc-url "$rpc_url" 2>/dev/null)

            if [ $? -eq 0 ] && [ -n "$timestamp_result" ]; then
                local timestamp_dec
                timestamp_dec=$(cast --to-dec "$timestamp_result" 2>/dev/null)
                if [ $? -eq 0 ]; then
                    if [ "$timestamp_dec" -eq "0" ]; then
                        echo -e "${YELLOW}ℹ️  $(t "claim_function_not_activated")${NC}"
                    else
                        local timestamp_human
                        timestamp_human=$(date -d "@$timestamp_dec" 2>/dev/null || echo "unknown format")
                        printf -v message "$(t "earliest_rewards_claimable_timestamp")" "$timestamp_dec" "$timestamp_human"
                        echo -e "${CYAN}ℹ️  ${message}${NC}"
                    fi
                fi
            fi
            return 1
    fi

    echo -e "${GREEN}✅ $(t "rewards_are_claimable")${NC}"

    # Extract validator addresses from keystore
    if [ ! -f "$KEYSTORE_FILE" ]; then
        echo -e "\n${RED}❌ $(t "keystore_file_not_found") $KEYSTORE_FILE${NC}"
        return 1
    fi

    echo -e "\n${BLUE}📋 $(t "extracting_validator_addresses")${NC}"

    # Extract payout addresses:
    # - Prefer per-validator .coinbase
    # - If .coinbase is missing/invalid, fall back to .attester.eth
    local coinbase_addresses=()
    while IFS= read -r address; do
        if [ -n "$address" ] && [ "$address" != "null" ] && [[ "$address" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
            coinbase_addresses+=("$address")
        fi
    done < <(jq -r '
        .validators[]
        | if (.coinbase != null and (.coinbase | test("^0x[0-9a-fA-F]{40}$")))
          then .coinbase
          elif (.attester.eth != null and (.attester.eth | test("^0x[0-9a-fA-F]{40}$")))
          then .attester.eth
          else empty
          end
    ' "$KEYSTORE_FILE" 2>/dev/null)

    if [ ${#coinbase_addresses[@]} -eq 0 ]; then
        echo -e "${YELLOW}⚠️ $(t "no_coinbase_addresses_found")${NC}"
        return 1
    fi

    # Remove duplicates and track unique addresses
    local unique_addresses=()
    local address_counts=()

    for addr in "${coinbase_addresses[@]}"; do
        local addr_lower=$(echo "$addr" | tr '[:upper:]' '[:lower:]')
        local found=0

        for i in "${!unique_addresses[@]}"; do
            if [ "${unique_addresses[i],,}" = "$addr_lower" ]; then
                ((address_counts[i]++))
                found=1
                break
            fi
        done

        if [ $found -eq 0 ]; then
            unique_addresses+=("$addr")
            address_counts+=("1")
        fi
    done

    echo -e "${GREEN}✅ $(t "found_unique_coinbase_addresses") ${#unique_addresses[@]}${NC}"

    # Show address distribution
    for i in "${!unique_addresses[@]}"; do
        if [ "${address_counts[i]}" -gt 1 ]; then
            printf "${CYAN}  📍 %s ($(t "repeats_times"))${NC}\n" "${unique_addresses[i]}" "${address_counts[i]}"
        else
            echo -e "${CYAN}  📍 ${unique_addresses[i]}${NC}"
        fi
    done

    # Check rewards for each unique address
    local addresses_with_rewards=()
    local reward_amounts=()

    echo -e "\n${BLUE}💰 $(t "checking_rewards")${NC}"

    for address in "${unique_addresses[@]}"; do
        echo -e "${CYAN}$(t "checking_address") $address...${NC}"

        local rewards_hex
        rewards_hex=$(cast call "$contract_address" "getSequencerRewards(address)" "$address" --rpc-url "$rpc_url" 2>/dev/null)

        if [ $? -ne 0 ]; then
            echo -e "${YELLOW}⚠️ $(t "failed_get_rewards_for_address") $address${NC}"
            continue
        fi

        # Convert hex to decimal
        local rewards_wei
        rewards_wei=$(cast --to-dec "$rewards_hex" 2>/dev/null)

        if [ $? -ne 0 ]; then
            printf -v message "$(t "failed_convert_rewards_amount")" "$address"
            echo -e "${YELLOW}⚠️ ${message}${NC}"
            continue
        fi

        # Convert wei to human-readable token amount (18 decimals)
        local rewards_eth
        rewards_eth=$(echo "scale=6; $rewards_wei / 1000000000000000000" | bc 2>/dev/null)

        if [ $? -ne 0 ]; then
            echo -e "${YELLOW}⚠️ $(t "failed_convert_to_eth") $address${NC}"
            continue
        fi

        # Check if rewards > 0
        if (( $(echo "$rewards_eth > 0" | bc -l) )); then
            printf -v message "$(t "rewards_amount")" "$rewards_eth"
            echo -e "${GREEN}🎯 ${message} ${TOKEN_SYMBOL}${NC}"
            addresses_with_rewards+=("$address")
            reward_amounts+=("$rewards_eth")
        else
            echo -e "${YELLOW}⏭️ $(t "no_rewards")${NC}"
        fi
    done

    if [ ${#addresses_with_rewards[@]} -eq 0 ]; then
        echo -e "${YELLOW}🎉 $(t "no_rewards_to_claim")${NC}"
        return 0
    fi

    printf "${GREEN}✅ $(t "found_unique_addresses_with_rewards") ${#addresses_with_rewards[@]}${NC}\n"

    # Claim rewards
    local claimed_count=0
    local failed_count=0
    local claimed_addresses=()

    for i in "${!addresses_with_rewards[@]}"; do
        local address="${addresses_with_rewards[$i]}"
        local amount="${reward_amounts[$i]}"

        # Check if we already claimed this address in this session
        if [[ " ${claimed_addresses[@]} " =~ " ${address} " ]]; then
            echo -e "${YELLOW}⏭️ $(t "already_claimed_this_session") $address, $(t "skipping")${NC}"
            continue
        fi

        echo -e "\n${BLUE}================================${NC}"
        echo -e "${CYAN}🎯 $(t "address_label") $address${NC}"
        printf "${YELLOW}💰 $(t "amount_eth") ${TOKEN_SYMBOL}${NC}\n" "$amount"

        # Find how many times this address repeats
        local repeat_count=0
        for j in "${!unique_addresses[@]}"; do
            if [ "${unique_addresses[j],,}" = "${address,,}" ]; then
                repeat_count="${address_counts[j]}"
                break
            fi
        done

        if [ "$repeat_count" -gt 1 ]; then
            printf "${CYAN}📊 $(t "address_appears_times")${NC}\n" "$repeat_count"
        fi

        # Ask for confirmation
        read -p "$(echo -e "\n${YELLOW}$(t "claim_rewards_confirmation") ${NC}")" confirm

        case "$confirm" in
            [yY]|yes)
                echo -e "${BLUE}🚀 $(t "claiming_rewards")${NC}"

                # Send claim transaction
                local tx_hash
                tx_hash=$(cast send "$contract_address" "claimSequencerRewards(address)" "$address" \
                    --rpc-url "$rpc_url" \
                    --keystore "$KEYSTORE_FILE" \
                    --from "$address" 2>/dev/null)

                if [ $? -eq 0 ] && [ -n "$tx_hash" ]; then
                    echo -e "${GREEN}✅ $(t "transaction_sent") $tx_hash${NC}"

                    # Wait and check receipt
                    echo -e "${BLUE}⏳ $(t "waiting_confirmation")${NC}"
                    sleep 10

                    local receipt
                    receipt=$(cast receipt "$tx_hash" --rpc-url "$rpc_url" 2>/dev/null)

                    if [ $? -eq 0 ]; then
                        local status
                        status=$(echo "$receipt" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)

                        if [ "$status" = "0x1" ] || [ "$status" = "1" ]; then
                            echo -e "${GREEN}✅ $(t "transaction_confirmed_successfully")${NC}"

                            # Mark this address as claimed
                            claimed_addresses+=("$address")

                            # Verify rewards are now zero
                            local new_rewards_hex
                            new_rewards_hex=$(cast call "$contract_address" "getSequencerRewards(address)" "$address" --rpc-url "$rpc_url" 2>/dev/null)
                            local new_rewards_wei
                            new_rewards_wei=$(cast --to-dec "$new_rewards_hex" 2>/dev/null)
                            local new_rewards_eth
                            new_rewards_eth=$(echo "scale=6; $new_rewards_wei / 1000000000000000000" | bc 2>/dev/null)

                            if (( $(echo "$new_rewards_eth == 0" | bc -l) )); then
                                echo -e "${GREEN}✅ $(t "rewards_successfully_claimed")${NC}"
                            else
                                printf -v message "$(t "rewards_claimed_balance_not_zero")" "$new_rewards_eth"
                                echo -e "${YELLOW}⚠️ ${message} ${TOKEN_SYMBOL}${NC}"
                            fi

                            ((claimed_count++))

                            # If this address repeats multiple times, show message
                            if [ "$repeat_count" -gt 1 ]; then
                                printf -v message "$(t "claimed_rewards_for_address_appears_times")" "$address" "$repeat_count"
                                echo -e "${GREEN}✅ ${message}${NC}"
                            fi
                        else
                            echo -e "${RED}❌ $(t "transaction_failed")${NC}"
                            ((failed_count++))
                        fi
                    else
                        echo -e "${YELLOW}⚠️ $(t "could_not_get_receipt_transaction_sent")${NC}"
                        claimed_addresses+=("$address")
                        ((claimed_count++))
                    fi
                else
                    echo -e "${RED}❌ $(t "failed_send_transaction")${NC}"
                    ((failed_count++))
                fi
                ;;
            [nN]|no)
                echo -e "${YELLOW}⏭️ $(t "skipping_claim_for_address") $address${NC}"
                ;;
            skip)
                echo -e "${YELLOW}⏭️ $(t "skipping_all_remaining_claims")${NC}"
                break
                ;;
            *)
                echo -e "${YELLOW}⏭️ $(t "skipping_claim_for_address") $address${NC}"
                ;;
        esac

        # Delay between transactions
        if [ $i -lt $((${#addresses_with_rewards[@]} - 1)) ]; then
            echo -e "${BLUE}⏳ $(t "waiting_seconds")${NC}"
            sleep 5
        fi
    done

    # Summary
    echo -e "\n${CYAN}================================${NC}"
    echo -e "${CYAN}           $(t "summary")${NC}"
    echo -e "${CYAN}================================${NC}"
    printf "${GREEN}✅ $(t "successfully_claimed") $claimed_count${NC}\n"
    if [ $failed_count -gt 0 ]; then
        printf "${RED}❌ $(t "failed_count") $failed_count${NC}\n"
    fi
    printf "${GREEN}🎯 $(t "unique_addresses_with_rewards") ${#addresses_with_rewards[@]}${NC}\n"
    printf "${GREEN}📊 $(t "total_coinbase_addresses_in_keystore") ${#coinbase_addresses[@]}${NC}\n"
    echo -e "${CYAN}📍 $(t "contract_used") $contract_address${NC}"

    return 0
}

# === Main menu ===
main_menu() {
  show_logo
  while true; do
    echo -e "\n${BLUE}$(t "title")${NC}"
    echo -e "${CYAN}$(t "option1")${NC}"
    echo -e "${GREEN}$(t "option2")${NC}"
    echo -e "${RED}$(t "option3")${NC}"
    echo -e "${CYAN}$(t "option4")${NC}"
    echo -e "${CYAN}$(t "option5")${NC}"
    echo -e "${CYAN}$(t "option6")${NC}"
    echo -e "${CYAN}$(t "option7")${NC}"
    echo -e "${CYAN}$(t "option8")${NC}"
    echo -e "${CYAN}$(t "option9")${NC}"
    echo -e "${CYAN}$(t "option10")${NC}"
    echo -e "${GREEN}$(t "option11")${NC}"
    echo -e "${RED}$(t "option12")${NC}"
    echo -e "${CYAN}$(t "option13")${NC}"
    echo -e "${CYAN}$(t "option14")${NC}"
    echo -e "${CYAN}$(t "option15")${NC}"
    echo -e "${YELLOW}$(t "option16")${NC}"
    echo -e "${CYAN}$(t "option17")${NC}"
    echo -e "${NC}$(t "option18")${NC}"
    echo -e "${NC}$(t "option19")${NC}"
    echo -e "${NC}$(t "option20")${NC}"
    echo -e "${NC}$(t "option21")${NC}"
    echo -e "${CYAN}$(t "option22")${NC}"
    echo -e "${CYAN}$(t "option23")${NC}"
    echo -e "${CYAN}$(t "option24")${NC}"
    echo -e "${RED}$(t "option0")${NC}"
    echo -e "${BLUE}================================${NC}"

    read -p "$(t "choose_option") " choice

    # Flag to track if a valid command was executed
    command_executed=false

    case "$choice" in
      1) check_aztec_container_logs; command_executed=true ;;
      2) create_systemd_agent; command_executed=true ;;
      3) remove_systemd_agent; command_executed=true ;;
      4) view_container_logs; command_executed=true ;;
      5) find_rollup_address; command_executed=true ;;
      6) find_peer_id; command_executed=true ;;
      7) find_governance_proposer_payload; command_executed=true ;;
      8) check_proven_block; command_executed=true ;;
      9) check_validator; command_executed=true ;;
      10) manage_publisher_balance_monitoring; command_executed=true ;;
      11) install_aztec; command_executed=true ;;
      12) delete_aztec; command_executed=true ;;
      13) start_aztec_containers; command_executed=true ;;
      14) stop_aztec_containers; command_executed=true ;;
      15) update_aztec; command_executed=true ;;
      16) downgrade_aztec; command_executed=true ;;
      17) check_aztec_version; command_executed=true ;;
      18) generate_bls_keys; command_executed=true ;;
      19) approve_with_all_keys; command_executed=true ;;
      20) stake_validators; command_executed=true ;;
      21) claim_rewards; command_executed=true ;;
      22) change_rpc_url; command_executed=true ;;
      23) check_updates_safely; command_executed=true ;;
      24) check_error_definitions_updates_safely; command_executed=true ;;
      0) echo -e "\n${GREEN}$(t "goodbye")${NC}"; exit 0 ;;
      *) echo -e "\n${RED}$(t "invalid_choice")${NC}" ;;
    esac

    # Wait for Enter before showing menu again (only for valid commands)
    if [ "$command_executed" = true ]; then
      echo ""
      echo -e "${YELLOW}Press Enter to continue...${NC}"
      read -r
      clear
      show_logo
    fi
  done
}

# === Script launch ===
init_languages
check_dependencies
main_menu

