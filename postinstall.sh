#!/bin/bash

# Global stuff
SCRIPT_PATH=$(realpath $(dirname "$0"))
BASE_PATH="$HOME/osmedeus-base"
DNS_WORDLIST="$BASE_PATH/data/wordlists/dns"
BINARY_PATH="$HOME/osmedeus-base/binaries"

announce_banner() {
    echo -e "\033[1;37m[\033[1;34m+\033[1;37m]\033[1;32m $1 \033[0m"
}

# Function to download git repositories removing previous versions
function download_repo {
REPO_NAME=$(echo "$1" | sed 's#.*/##') # Extract repository name
REPO_NAME="${REPO_NAME%.git}" # Remove the .git extension if it exists
REPO_NAME="$BINARY_PATH/$REPO_NAME"
if [ -d "$REPO_NAME" ]; then
    rm -rf "$REPO_NAME"
fi
git clone -q --recursive "$1" "$REPO_NAME"
}


# Install some utils
announce_banner "Running apt update"
apt update -y -qq
announce_banner "Installing some utils"
apt-get install -qq -y jq golang-go pipenv python3-pip python3-venv

python3 -m pip install --user pipx && python3 -m pipx ensurepath

# Download custom dns/domains/subdomains wordlists
announce_banner "Downloading custom dns/domains/subdomains wordlists"

wget -q -O "$DNS_WORDLIST/2m-subdomains.txt" https://wordlists-cdn.assetnote.io/data/manual/2m-subdomains.txt
wget -q -O "$DNS_WORDLIST/best-dns-wordlist.txt" https://wordlists-cdn.assetnote.io/data/manual/best-dns-wordlist.txt
wget -q -O "$DNS_WORDLIST/httparchive_html_htm_2023_08_28.txt" https://wordlists-cdn.assetnote.io/data/automated/httparchive_html_htm_2023_08_28.txt
wget -q -O "$DNS_WORDLIST/subdomains-spanish.txt" https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-spanish.txt
wget -q -O "$DNS_WORDLIST/subdomains-top1million-110000.txt" https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1million-110000.txt

# Download and install some tools
announce_banner "Copying binaries and scripts from binaries folder to $BINARY_PATH"
cp $SCRIPT_PATH/binaries/* $BINARY_PATH/

announce_banner "Installing waybackurls"
GOBIN=$BINARY_PATH go install github.com/tomnomnom/waybackurls@latest

announce_banner "Installing shosubgo"
GOBIN=/root/osmedeus-base/binaries go install github.com/incogbyte/shosubgo@latest

announce_banner "Installing github-subdomains"
GOBIN=/root/osmedeus-base/binaries go install github.com/gwen001/github-subdomains@latest

announce_banner "Installing censys-subdomain-finder"
download_repo "https://github.com/christophetd/censys-subdomain-finder.git"
cd $BINARY_PATH/censys-subdomain-finder
pipenv --python 3 && pipenv install

announce_banner "Installing Sudomy"
download_repo "https://github.com/screetsec/Sudomy.git"
cd $BINARY_PATH/Sudomy
pipenv --python 3 && pipenv install

announce_banner "Installing Bbot"
python3 -m pipx install bbot

announce_banner "Renaming Amass to Amass4"
mv $BINARY_PATH/amass $BINARY_PATH/amass4

announce_banner "Downloading Amass 3.32.3"
# After several tests amass 3 finishes passive enumeration in seconds while amass 4 freezes.
wget -q -O "$BINARY_PATH/amass.zip" https://github.com/owasp-amass/amass/releases/download/v3.23.3/amass_Linux_amd64.zip
unzip -qq "$BINARY_PATH/amass.zip" -d $BINARY_PATH
mv $BINARY_PATH/amass_Linux_amd64/amass $BINARY_PATH
rm -rf $BINARY_PATH/amass_Linux_amd64/





