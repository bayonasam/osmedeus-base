#!/bin/bash

# Global stuff
BASE_PATH="$HOME/osmedeus-base"
DNS_WORDLIST="$BASE_PATH/data/wordlists/dns"
REPO_PATH="$HOME/osmedeus-base/binaries"

# Install some utils
apt install jq -y

# Download custom dns/domains/subdomains wordlists 
wget -O "$DNS_WORDLIST/2m-subdomains.txt" https://wordlists-cdn.assetnote.io/data/manual/2m-subdomains.txt
wget -O "$DNS_WORDLIST/best-dns-wordlist.txt" https://wordlists-cdn.assetnote.io/data/manual/best-dns-wordlist.txt
wget -O "$DNS_WORDLIST/httparchive_html_htm_2023_08_28.txt" https://wordlists-cdn.assetnote.io/data/automated/httparchive_html_htm_2023_08_28.txt
wget -O "$DNS_WORDLIST/subdomains-spanish.txt" https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-spanish.txt
wget -O "$DNS_WORDLIST/subdomains-top1million-110000.txt" https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1million-110000.txt

# Download scripts/binaries from repositories
REPO_PATH="$HOME/osmedeus-base/binaries"
function download_repo {
REPO_NAME=$(echo "$1" | sed 's#.*/##') # Extract repository name
REPO_NAME="${REPO_NAME%.git}" # Remove the .git extension if it exists
REPO_NAME="$REPO_PATH/$REPO_NAME"
if [ -d "$REPO_NAME" ]; then
    rm -rf "$REPO_NAME"
fi
git clone --depth=1 "$1" "$REPO_NAME"
}

download_repo "https://github.com/initstring/linkedin2username"
pip3 install -r "$REPO_NAME/requirements.txt"










