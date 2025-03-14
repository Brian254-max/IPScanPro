#!/bin/bash
set -e

# Tool made by Lokesh Kumar
# clear the terminal
clear
sleep 2
# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[93m'
RESET='\033[0m'

# Detect the OS
if [[ $(uname -o) == "Android" ]]; then
    OS="Termux"
    PKG_MANAGER="pkg"
    UPDATE_CMD="pkg update -y && pkg upgrade -y"
    INSTALL_CMD="pkg install -y"
    BIN_DIR="$PREFIX/bin"
elif [[ -f /etc/debian_version ]]; then
    OS="Kali Linux"
    PKG_MANAGER="apt-get"
    UPDATE_CMD="apt-get update -y && apt-get upgrade -y"
    INSTALL_CMD="apt-get install -y"
    BIN_DIR="/usr/local/bin"
else
    echo -e "${RED}Unsupported operating system.${RESET}"
    exit 1
fi

# Show the detected OS to the user
echo -e "${GREEN}Detected OS: $OS${RESET}"

# Update and install required packages
{
    echo -e "${YELLOW}Updating and upgrading $OS...${RESET}"
    eval "$UPDATE_CMD" > /dev/null 2>&1

    echo -e "${YELLOW}Installing required packages...${RESET}"
    $INSTALL_CMD git python python2 python3 curl wget openssl figlet jq  > /dev/null 2>&1

    # Move the 'ip' script to the appropriate bin location
    echo -e "${YELLOW}Moving 'ip' script to ${BIN_DIR}...${RESET}"
    cp ip "$BIN_DIR/ip"
    chmod +x "$BIN_DIR/ip"
} &

# Show progress 
while kill -0 $! 2>/dev/null; do
    for i in {1..10}; do
        echo -ne "${GREEN}Working...${i}0%${RESET}\r"
        sleep 1
    done
    echo -ne "${GREEN}Working...${RESET}\r"
done

wait
display_banner() {
    clear
    echo -e "${CYAN}"
    figlet -f slant "IP Scanner Pro" | lolcat
    echo -e "${GREEN}By Lokesh Kumar${RESET}"
    echo -e "${MAGENTA}---------------------------------${RESET}"
    echo -e "${YELLOW}Advanced IP Scanning Tool${RESET}"
    echo -e "${MAGENTA}---------------------------------${RESET}"
}
clear
sleep 3
display_banner

echo -e "${RED}Installation complete! You can now run the tool using the command 'ip'.${RESET}"
cd ..
rm -rf IPScanPro
