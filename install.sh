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

function setup_docker() {
	echo -e "${GREEN} Docker setup started ${NC}"
	osascript -e 'quit app "Docker"'
	rm -rf ~/.docker
	rm -rf ~/goinfre/docker
	mkdir -p ~/goinfre/com.docker.docker
	rm -rf ~/Library/Containers/com.docker.docker
	ln -s ~/goinfre/com.docker.docker ~/Library/Containers/com.docker.docker
	return 0
}

# set up goinfre
if [ ! -d "$HOME/goinfre/com.docker.docker" ]; then
	setup_docker
fi

# open docker
docker ps > /dev/null 2>&1
if [ ! $? -eq 0 ]; then
	open -a docker                #what if docker does not open??
	echo -n " waiting for docker to start "
	timeout=60
	tries=1;
	while [ $timeout -gt 0 ]; do
		docker ps > /dev/null 2>&1
		if [ $? -eq 0 ]; then
			echo
			break
		else
			echo -n "."
			sleep 1
			timeout=$((timeout - 1))
			if [ $timeout -eq 0 ] && [ $tries -gt 0 ]; then
				tries=$((tries - 1))
				timeout=60
				setup_docker
				open -a docker
			fi
		fi
	done
	if [ $timeout -eq 0 ]; then
		echo -e "${RED}Docker failed to start.${NC}"
		echo -e "${RED}Please check docker is installed and try again.${NC}"
		exit 1
	fi
fi

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