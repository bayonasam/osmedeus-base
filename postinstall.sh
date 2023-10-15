#!/bin/bash

# global stuff
BASE_PATH="$HOME/osmedeus-base"
DNS_WORDLIST="$BASE_PATH/data/wordlists/dns"

# install some utils
apt install jq -y

# download custom dns/domains/subdomains wordlists 
wget -O $DNS_WORDLIST https://wordlists-cdn.assetnote.io/data/manual/2m-subdomains.txt
wget -O $DNS_WORDLIST https://wordlists-cdn.assetnote.io/data/manual/best-dns-wordlist.txt
wget -O $DNS_WORDLIST https://wordlists-cdn.assetnote.io/data/automated/httparchive_html_htm_2023_08_28.txt
wget -O $DNS_WORDLIST https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-spanish.txt
wget -O $DNS_WORDLIST https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1million-110000.txt






