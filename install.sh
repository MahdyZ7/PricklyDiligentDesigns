#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
GRAY='\033[0;37m'
NC='\033[0m'

# alias cmd
cmd='bash -c "$(curl -s -H "Range: bytes" https://raw.githubusercontent.com/MahdyZ7/PricklyDiligentDesigns/main/start.sh)"'


# check if goinfree is there (proxy for are you in 42)
if [ ! -d "$HOME/goinfre" ]; then
	echo -e "${RED} You must be using a terminal inside 42 lab ${NC}"
	exit 1
fi

#check and start docker if needed
curl -s -H 'Range: bytes' https://raw.githubusercontent.com/MahdyZ7/PricklyDiligentDesigns/main/start_docker.sh | bash

# replace alias in bash
if [ -f "$HOME/.bashrc" ]; then
	sed -i '' '/^alias valgrind=/d' ~/.bashrc
    echo "alias valgrind='$cmd'" >> "$HOME/.bashrc"
    if [[ "$SHELL" == *bash* ]]; then
        source "$HOME/.bashrc"
    fi
	echo -e "${GREEN} valgrind alias added to bash ${NC}"
fi
# replace alias in zsh
if [ -f "$HOME/.zshrc" ]; then
	sed -i '' '/^alias valgrind=/d' ~/.zshrc
	echo "alias valgrind='$cmd'" >> "$HOME/.zshrc"
	if [[ "$SHELL" == *zsh* ]]; then
	    source "$HOME/.zshrc"
	fi
	echo -e "${GREEN} valgrind alias added to zsh ${NC}"
fi

docker pull mahdyz7/rust_container:latest