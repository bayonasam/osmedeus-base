#### Installing osmedeus-base and all the stuff
bash <(curl -fsSL https://raw.githubusercontent.com/osmedeus/osmedeus-base/master/install.sh)

#### Compiling osmedeus with custom changes

echo -e "\033[1;37m[\033[1;34m+\033[1;37m]\033[1;32m Compiling Osmedeus with custom changes \033[0m"

# Check if osmedeus exists
if [ -e /usr/local/bin/osmedeus ]; then
    rm /usr/local/bin/osmedeus
fi

# Download official repository
REPO_PATH="/opt/osmedeus"
REPO_URL="https://github.com/j3ssie/osmedeus"
FILE="/opt/osmedeus/core/runner.go"
if [ -d "$REPO_PATH" ]; then
    rm -rf "$REPO_PATH"
fi
git clone --depth=1 "$REPO_URL" "$REPO_PATH"

# Search and replace
SEARCH_LINE="r.Opt.Scan.ROptions = r.Target"
NEW_LINE='\tnow := time.Now()\n\tformattedTime := now.Format("2006-01-02T15:04:05")\n\tr.Target["Output"] = r.Target["Output"] + "_" + formattedTime'
if grep -q "$SEARCH_LINE" "$FILE"; then
    sed -i "/$SEARCH_LINE/a\\
$NEW_LINE" "$FILE"
    echo "runner.go file successfully modified"
else
    echo "The line \"$SEARCH_LINE\" was not found in the file \"$NEW_LINE\"."
fi

SEARCH_LINE="import ("
NEW_LINE='\t"time"'
if grep -q "$SEARCH_LINE" "$FILE"; then
    sed -i "/$SEARCH_LINE/a\\
$NEW_LINE" "$FILE"
    echo "runner.go file successfully modified"
else
    echo "The line \"$SEARCH_LINE\" was not found in the file \"$NEW_LINE\"."
fi


# Downloading modified main.go and load_variables.go
wget -q -O "$REPO_PATH/main.go" https://raw.githubusercontent.com/bayonasam/osmedeus-base/main/main.go
wget -q -O "$REPO_PATH/core/load_variables.go" https://raw.githubusercontent.com/bayonasam/osmedeus-base/main/load_variables.go


# Compiling osmedeus
cd /opt/osmedeus
go build

if [ -f "/opt/osmedeus/osmedeus" ]; then
    cp /opt/osmedeus/osmedeus /usr/local/bin/osmedeus
    echo -e "\033[1;37m[\033[1;34m+\033[1;37m]\033[1;32m Osmedeus binary compiled \033[0m"
    osmedeus health # check osmedeus
else
    echo -e "\033[1;37m[\033[1;31m\!\033[1;37m]\033[1;31m Osmedeus binary in /opt/osmedeus/ does not exist \033[0m"
fi


echo -e "\033[1;37m[\033[1;34m+\033[1;37m]\033[1;32m Executing postinstall.sh script \033[0m"

#### Executing postinstall script with necessary custom binaries or files
bash <(curl -fsSL https://raw.githubusercontent.com/bayonasam/osmedeus-base/master/postinstall.sh)
